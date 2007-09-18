From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH ver2 24/24] ide-scsi.c: convert to data accessors and !use_sg
 cleanup
Date: Tue, 18 Sep 2007 11:03:21 +0200
Message-ID: <46EF9459.7070102@panasas.com>
References: <46E6F92D.2090409@panasas.com> <46E72F13.3090200@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:35566 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbXIRJD3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2007 05:03:29 -0400
Received: by ug-out-1314.google.com with SMTP id z38so57574ugc
        for <linux-scsi@vger.kernel.org>; Tue, 18 Sep 2007 02:03:28 -0700 (PDT)
In-Reply-To: <46E72F13.3090200@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


 - Convert ide-scsi to the new data accessors and cleanup
   the !use_sg code paths.

  In old code the MODE_SENSE or MODE_SELECT code paths still
  assumed scsi_cmnd->request_buffer is a linear char pointer.
  This means that this driver was broken since 2.6.17. Though
  I admit this assumption is hidden behind a flag:
  test_bit(PC_TRANSFORM, &pc->flags).

  I have hacked these code paths to properly handle an sg_count==1,
  which is true in todays implementation of MODE_SENSE or
  MODE_SELECT.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/ide-scsi.c |   85 +++++++++++++++++++++++++++--------------------
 1 files changed, 49 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 1cc01ac..5c9a444 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -63,7 +63,7 @@
 
 typedef struct idescsi_pc_s {
 	u8 c[12];				/* Actual packet bytes */
-	int request_transfer;			/* Bytes to transfer */
+	unsigned int request_transfer;		/* Bytes to transfer */
 	int actually_transferred;		/* Bytes actually transferred */
 	int buffer_size;			/* Size of our data buffer */
 	struct request *rq;			/* The corresponding request */
@@ -175,7 +175,8 @@ static void idescsi_input_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigne
 	char *buf;
 
 	while (bcount) {
-		if (pc->sg - (struct scatterlist *) pc->scsi_cmd->request_buffer > pc->scsi_cmd->use_sg) {
+		if (pc->sg - scsi_sglist(pc->scsi_cmd) >
+		                                 scsi_sg_count(pc->scsi_cmd)) {
 			printk (KERN_ERR "ide-scsi: scatter gather table too small, discarding data\n");
 			idescsi_discard_data (drive, bcount);
 			return;
@@ -210,7 +211,8 @@ static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsign
 	char *buf;
 
 	while (bcount) {
-		if (pc->sg - (struct scatterlist *) pc->scsi_cmd->request_buffer > pc->scsi_cmd->use_sg) {
+		if (pc->sg - scsi_sglist(pc->scsi_cmd) >
+		                                 scsi_sg_count(pc->scsi_cmd)) {
 			printk (KERN_ERR "ide-scsi: scatter gather table too small, padding with zeros\n");
 			idescsi_output_zeros (drive, bcount);
 			return;
@@ -245,21 +247,21 @@ static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsign
  */
 static inline void idescsi_transform_pc1 (ide_drive_t *drive, idescsi_pc_t *pc)
 {
-	u8 *c = pc->c, *scsi_buf = pc->buffer, *sc = pc->scsi_cmd->cmnd;
-	char *atapi_buf;
-
 	if (!test_bit(PC_TRANSFORM, &pc->flags))
 		return;
 	if (drive->media == ide_cdrom || drive->media == ide_optical) {
+		u8 *c = pc->c;
+
 		if (c[0] == READ_6 || c[0] == WRITE_6) {
 			c[8] = c[4];		c[5] = c[3];		c[4] = c[2];
 			c[3] = c[1] & 0x1f;	c[2] = 0;		c[1] &= 0xe0;
 			c[0] += (READ_10 - READ_6);
 		}
 		if (c[0] == MODE_SENSE || c[0] == MODE_SELECT) {
+			u8 *sc = pc->scsi_cmd->cmnd;
+			char *atapi_buf;
 			unsigned short new_len;
-			if (!scsi_buf)
-				return;
+
 			if ((atapi_buf = kmalloc(pc->buffer_size + 4, GFP_ATOMIC)) == NULL)
 				return;
 			memset(atapi_buf, 0, pc->buffer_size + 4);
@@ -272,42 +274,62 @@ static inline void idescsi_transform_pc1 (ide_drive_t *drive, idescsi_pc_t *pc)
 			c[7] = new_len >> 8;
 			c[9] = sc[5];
 			if (c[0] == MODE_SELECT_10) {
+				struct scatterlist *sg = scsi_sglist(pc->scsi_cmd);
+				u8 *scsi_buf;
+
+				/* FIXME: Use proper copy_from_sg(...) */
+				BUG_ON(!sg || sg->length < 4);
+				if (pc->buffer_size > sg->length)
+					pc->buffer_size = sg->length;
+				scsi_buf = (u8 *)(kmap(sg->page) + sg->offset);
+
 				atapi_buf[1] = scsi_buf[0];	/* Mode data length */
 				atapi_buf[2] = scsi_buf[1];	/* Medium type */
 				atapi_buf[3] = scsi_buf[2];	/* Device specific parameter */
 				atapi_buf[7] = scsi_buf[3];	/* Block descriptor length */
 				memcpy(atapi_buf + 8, scsi_buf + 4, pc->buffer_size - 4);
+				kunmap(sg->page);
 			}
 			pc->buffer = atapi_buf;
-			pc->request_transfer += 4;
 			pc->buffer_size += 4;
+			pc->request_transfer = pc->buffer_size;
 		}
 	}
 }
 
 static inline void idescsi_transform_pc2 (ide_drive_t *drive, idescsi_pc_t *pc)
 {
-	u8 *atapi_buf = pc->buffer;
-	u8 *sc = pc->scsi_cmd->cmnd;
-	u8 *scsi_buf = pc->scsi_cmd->request_buffer;
-
 	if (!test_bit(PC_TRANSFORM, &pc->flags))
 		return;
 	if (drive->media == ide_cdrom || drive->media == ide_optical) {
-		if (pc->c[0] == MODE_SENSE_10 && sc[0] == MODE_SENSE) {
+		u8 *atapi_buf = pc->buffer;
+		u8 *sc = pc->scsi_cmd->cmnd;
+		u8 *scsi_buf;
+		int request_transfer;
+		struct scatterlist *sg = scsi_sglist(pc->scsi_cmd);
+
+		/* FIXME: Use proper copy_to_sg(...) */
+		BUG_ON(!sg || sg->length < 4);
+		request_transfer = min(sg->length - 4, pc->request_transfer - 8);
+		scsi_buf = (u8 *)(kmap(sg->page) + sg->offset);
+		if (atapi_buf &&
+		    (pc->c[0] == MODE_SENSE_10) && (sc[0] == MODE_SENSE)) {
 			scsi_buf[0] = atapi_buf[1];		/* Mode data length */
 			scsi_buf[1] = atapi_buf[2];		/* Medium type */
 			scsi_buf[2] = atapi_buf[3];		/* Device specific parameter */
 			scsi_buf[3] = atapi_buf[7];		/* Block descriptor length */
-			memcpy(scsi_buf + 4, atapi_buf + 8, pc->request_transfer - 8);
+			memcpy(scsi_buf + 4, atapi_buf + 8, request_transfer);
 		}
 		if (pc->c[0] == INQUIRY) {
 			scsi_buf[2] |= 2;			/* ansi_revision */
 			scsi_buf[3] = (scsi_buf[3] & 0xf0) | 2;	/* response data format */
 		}
+		kunmap(sg->page);
+	}
+	if (pc->buffer) {
+		kfree(pc->buffer);
+		pc->buffer = NULL;
 	}
-	if (atapi_buf && atapi_buf != scsi_buf)
-		kfree(atapi_buf);
 }
 
 static void hexdump(u8 *x, int len)
@@ -393,7 +415,6 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 	idescsi_pc_t *pc = (idescsi_pc_t *) rq->special;
 	int log = test_bit(IDESCSI_LOG_CMD, &scsi->log);
 	struct Scsi_Host *host;
-	u8 *scsi_buf;
 	int errors = rq->errors;
 	unsigned long flags;
 
@@ -435,6 +456,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 	} else {
 		pc->scsi_cmd->result = DID_OK << 16;
 		idescsi_transform_pc2 (drive, pc);
+#if 0
 		if (log) {
 			printk ("ide-scsi: %s: suc %lu", drive->name, pc->scsi_cmd->serial_number);
 			if (!test_bit(PC_WRITING, &pc->flags) && pc->actually_transferred && pc->actually_transferred <= 1024 && pc->buffer) {
@@ -443,6 +465,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 				hexdump(scsi_buf, min_t(unsigned, 16, pc->scsi_cmd->request_bufflen));
 			} else printk("\n");
 		}
+#endif
 	}
 	host = pc->scsi_cmd->device->host;
 	spin_lock_irqsave(host->host_lock, flags);
@@ -637,19 +660,14 @@ static int idescsi_map_sg(ide_drive_t *drive, idescsi_pc_t *pc)
 		return 1;
 
 	sg = hwif->sg_table;
-	scsi_sg = pc->scsi_cmd->request_buffer;
-	segments = pc->scsi_cmd->use_sg;
+	scsi_sg = scsi_sglist(pc->scsi_cmd);
+	segments = scsi_sg_count(pc->scsi_cmd);
 
 	if (segments > hwif->sg_max_nents)
 		return 1;
 
-	if (!segments) {
-		hwif->sg_nents = 1;
-		sg_init_one(sg, pc->scsi_cmd->request_buffer, pc->request_transfer);
-	} else {
-		hwif->sg_nents = segments;
-		memcpy(sg, scsi_sg, sizeof(*sg) * segments);
-	}
+	hwif->sg_nents = segments;
+	memcpy(sg, scsi_sg, sizeof(*sg) * segments);
 
 	return 0;
 }
@@ -667,7 +685,7 @@ static ide_startstop_t idescsi_issue_pc (ide_drive_t *drive, idescsi_pc_t *pc)
 	scsi->pc=pc;							/* Set the current packet command */
 	pc->actually_transferred=0;					/* We haven't transferred any data yet */
 	pc->current_position=pc->buffer;
-	bcount.all = min(pc->request_transfer, 63 * 1024);		/* Request to transfer the entire buffer at once */
+	bcount.all = min_t(unsigned, pc->request_transfer, 63 * 1024);	/* Request to transfer the entire buffer at once */
 
 	feature.all = 0;
 	if (drive->using_dma && !idescsi_map_sg(drive, pc)) {
@@ -905,15 +923,10 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	pc->flags = 0;
 	pc->rq = rq;
 	memcpy (pc->c, cmd->cmnd, cmd->cmd_len);
-	if (cmd->use_sg) {
-		pc->buffer = NULL;
-		pc->sg = cmd->request_buffer;
-	} else {
-		pc->buffer = cmd->request_buffer;
-		pc->sg = NULL;
-	}
+	pc->buffer = NULL;
+	pc->sg = scsi_sglist(cmd);
 	pc->b_count = 0;
-	pc->request_transfer = pc->buffer_size = cmd->request_bufflen;
+	pc->request_transfer = pc->buffer_size = scsi_bufflen(cmd);
 	pc->scsi_cmd = cmd;
 	pc->done = done;
 	pc->timeout = jiffies + cmd->timeout_per_command;
-- 
1.5.3.1



From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 24/24 ver3 ] ide-scsi.c: convert to data accessors and !use_sg
 cleanup
Date: Tue, 18 Sep 2007 12:27:43 +0200
Message-ID: <46EFA81F.9090109@panasas.com>
References: <46E6F92D.2090409@panasas.com> <46E72F13.3090200@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa8.bezeqint.net ([192.115.104.22]:38111 "EHLO sa8.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246AbXIRLHk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Sep 2007 07:07:40 -0400
In-Reply-To: <46E72F13.3090200@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


 - Convert ide-scsi to the new data accessors and cleanup
   the !use_sg code paths.

  In old code the driver was trying to translate narrow commands,
  if received, to wide commands. This code  path still assumed
  scsi_cmnd->request_buffer is a linear char pointer.
  This means that this driver was broken since 2.6.17.

  As suggested by Christoph Hellwig I set
  use_10_for_rw = 1; and use_10_for_ms = 1;
  for this device and completely killed the translation.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/ide-scsi.c |  138 +++++------------------------------------------
 1 files changed, 13 insertions(+), 125 deletions(-)

diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 1cc01ac..3b55a6c 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -82,14 +82,12 @@ typedef struct idescsi_pc_s {
  */
 #define PC_DMA_IN_PROGRESS		0	/* 1 while DMA in progress */
 #define PC_WRITING			1	/* Data direction */
-#define PC_TRANSFORM			2	/* transform SCSI commands */
 #define PC_TIMEDOUT			3	/* command timed out */
 #define PC_DMA_OK			4	/* Use DMA */
 
 /*
  *	SCSI command transformation layer
  */
-#define IDESCSI_TRANSFORM		0	/* Enable/Disable transformation */
 #define IDESCSI_SG_TRANSFORM		1	/* /dev/sg transformation */
 
 /*
@@ -175,7 +173,8 @@ static void idescsi_input_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigne
 	char *buf;
 
 	while (bcount) {
-		if (pc->sg - (struct scatterlist *) pc->scsi_cmd->request_buffer > pc->scsi_cmd->use_sg) {
+		if (pc->sg - scsi_sglist(pc->scsi_cmd) >
+		                                 scsi_sg_count(pc->scsi_cmd)) {
 			printk (KERN_ERR "ide-scsi: scatter gather table too small, discarding data\n");
 			idescsi_discard_data (drive, bcount);
 			return;
@@ -210,7 +209,8 @@ static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsign
 	char *buf;
 
 	while (bcount) {
-		if (pc->sg - (struct scatterlist *) pc->scsi_cmd->request_buffer > pc->scsi_cmd->use_sg) {
+		if (pc->sg - scsi_sglist(pc->scsi_cmd) >
+		                                 scsi_sg_count(pc->scsi_cmd)) {
 			printk (KERN_ERR "ide-scsi: scatter gather table too small, padding with zeros\n");
 			idescsi_output_zeros (drive, bcount);
 			return;
@@ -239,77 +239,6 @@ static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsign
 	}
 }
 
-/*
- *	Most of the SCSI commands are supported directly by ATAPI devices.
- *	idescsi_transform_pc handles the few exceptions.
- */
-static inline void idescsi_transform_pc1 (ide_drive_t *drive, idescsi_pc_t *pc)
-{
-	u8 *c = pc->c, *scsi_buf = pc->buffer, *sc = pc->scsi_cmd->cmnd;
-	char *atapi_buf;
-
-	if (!test_bit(PC_TRANSFORM, &pc->flags))
-		return;
-	if (drive->media == ide_cdrom || drive->media == ide_optical) {
-		if (c[0] == READ_6 || c[0] == WRITE_6) {
-			c[8] = c[4];		c[5] = c[3];		c[4] = c[2];
-			c[3] = c[1] & 0x1f;	c[2] = 0;		c[1] &= 0xe0;
-			c[0] += (READ_10 - READ_6);
-		}
-		if (c[0] == MODE_SENSE || c[0] == MODE_SELECT) {
-			unsigned short new_len;
-			if (!scsi_buf)
-				return;
-			if ((atapi_buf = kmalloc(pc->buffer_size + 4, GFP_ATOMIC)) == NULL)
-				return;
-			memset(atapi_buf, 0, pc->buffer_size + 4);
-			memset (c, 0, 12);
-			c[0] = sc[0] | 0x40;
-			c[1] = sc[1];
-			c[2] = sc[2];
-			new_len = sc[4] + 4;
-			c[8] = new_len;
-			c[7] = new_len >> 8;
-			c[9] = sc[5];
-			if (c[0] == MODE_SELECT_10) {
-				atapi_buf[1] = scsi_buf[0];	/* Mode data length */
-				atapi_buf[2] = scsi_buf[1];	/* Medium type */
-				atapi_buf[3] = scsi_buf[2];	/* Device specific parameter */
-				atapi_buf[7] = scsi_buf[3];	/* Block descriptor length */
-				memcpy(atapi_buf + 8, scsi_buf + 4, pc->buffer_size - 4);
-			}
-			pc->buffer = atapi_buf;
-			pc->request_transfer += 4;
-			pc->buffer_size += 4;
-		}
-	}
-}
-
-static inline void idescsi_transform_pc2 (ide_drive_t *drive, idescsi_pc_t *pc)
-{
-	u8 *atapi_buf = pc->buffer;
-	u8 *sc = pc->scsi_cmd->cmnd;
-	u8 *scsi_buf = pc->scsi_cmd->request_buffer;
-
-	if (!test_bit(PC_TRANSFORM, &pc->flags))
-		return;
-	if (drive->media == ide_cdrom || drive->media == ide_optical) {
-		if (pc->c[0] == MODE_SENSE_10 && sc[0] == MODE_SENSE) {
-			scsi_buf[0] = atapi_buf[1];		/* Mode data length */
-			scsi_buf[1] = atapi_buf[2];		/* Medium type */
-			scsi_buf[2] = atapi_buf[3];		/* Device specific parameter */
-			scsi_buf[3] = atapi_buf[7];		/* Block descriptor length */
-			memcpy(scsi_buf + 4, atapi_buf + 8, pc->request_transfer - 8);
-		}
-		if (pc->c[0] == INQUIRY) {
-			scsi_buf[2] |= 2;			/* ansi_revision */
-			scsi_buf[3] = (scsi_buf[3] & 0xf0) | 2;	/* response data format */
-		}
-	}
-	if (atapi_buf && atapi_buf != scsi_buf)
-		kfree(atapi_buf);
-}
-
 static void hexdump(u8 *x, int len)
 {
 	int i;
@@ -393,7 +322,6 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 	idescsi_pc_t *pc = (idescsi_pc_t *) rq->special;
 	int log = test_bit(IDESCSI_LOG_CMD, &scsi->log);
 	struct Scsi_Host *host;
-	u8 *scsi_buf;
 	int errors = rq->errors;
 	unsigned long flags;
 
@@ -434,15 +362,6 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 		pc->scsi_cmd->result = (CHECK_CONDITION << 1) | (DID_OK << 16);
 	} else {
 		pc->scsi_cmd->result = DID_OK << 16;
-		idescsi_transform_pc2 (drive, pc);
-		if (log) {
-			printk ("ide-scsi: %s: suc %lu", drive->name, pc->scsi_cmd->serial_number);
-			if (!test_bit(PC_WRITING, &pc->flags) && pc->actually_transferred && pc->actually_transferred <= 1024 && pc->buffer) {
-				printk(", rst = ");
-				scsi_buf = pc->scsi_cmd->request_buffer;
-				hexdump(scsi_buf, min_t(unsigned, 16, pc->scsi_cmd->request_bufflen));
-			} else printk("\n");
-		}
 	}
 	host = pc->scsi_cmd->device->host;
 	spin_lock_irqsave(host->host_lock, flags);
@@ -637,19 +556,14 @@ static int idescsi_map_sg(ide_drive_t *drive, idescsi_pc_t *pc)
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
@@ -744,7 +658,6 @@ static void idescsi_setup (ide_drive_t *drive, idescsi_scsi_t *scsi)
 {
 	if (drive->id && (drive->id->config & 0x0060) == 0x20)
 		set_bit (IDESCSI_DRQ_INTERRUPT, &scsi->flags);
-	set_bit(IDESCSI_TRANSFORM, &scsi->transform);
 	clear_bit(IDESCSI_SG_TRANSFORM, &scsi->transform);
 #if IDESCSI_DEBUG_LOG
 	set_bit(IDESCSI_LOG_CMD, &scsi->log);
@@ -838,6 +751,8 @@ static struct block_device_operations idescsi_ops = {
 static int idescsi_slave_configure(struct scsi_device * sdp)
 {
 	/* Configure detected device */
+	sdp->use_10_for_rw = 1;
+	sdp->use_10_for_ms = 1;
 	scsi_adjust_queue_depth(sdp, MSG_SIMPLE_TAG, sdp->host->cmd_per_lun);
 	return 0;
 }
@@ -862,24 +777,6 @@ static int idescsi_ioctl (struct scsi_device *dev, int cmd, void __user *arg)
 	return -EINVAL;
 }
 
-static inline int should_transform(ide_drive_t *drive, struct scsi_cmnd *cmd)
-{
-	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
-
-	/* this was a layering violation and we can't support it
-	   anymore, sorry. */
-#if 0
-	struct gendisk *disk = cmd->request->rq_disk;
-
-	if (disk) {
-		struct struct scsi_device_Template **p = disk->private_data;
-		if (strcmp((*p)->scsi_driverfs_driver.name, "sg") == 0)
-			return test_bit(IDESCSI_SG_TRANSFORM, &scsi->transform);
-	}
-#endif
-	return test_bit(IDESCSI_TRANSFORM, &scsi->transform);
-}
-
 static int idescsi_queue (struct scsi_cmnd *cmd,
 		void (*done)(struct scsi_cmnd *))
 {
@@ -905,23 +802,14 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
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
 
-	if (should_transform(drive, cmd))
-		set_bit(PC_TRANSFORM, &pc->flags);
-	idescsi_transform_pc1 (drive, pc);
-
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: que %lu, cmd = ", drive->name, cmd->serial_number);
 		hexdump(cmd->cmnd, cmd->cmd_len);
-- 
1.5.3.1



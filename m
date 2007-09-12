From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 24/24] ide-scsi.c: convert to data accessors and !use_sg cleanup
Date: Wed, 12 Sep 2007 03:13:07 +0300
Message-ID: <46E72F13.3090200@panasas.com>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:29748 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755272AbXILAQy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 20:16:54 -0400
In-Reply-To: <46E6F92D.2090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


 - Convert ide-scsi to the new data accessors and cleanup
   the !use_sg code paths.

  Inspecting old code I can see places that still assume
  scsi_cmnd->request_buffer is a linear char pointer. Though I
  admit this assumption is hidden behind a flag:
  test_bit(PC_TRANSFORM, &pc->flags).
  I have commented out the offending code and put a
  WARN_ON(1) in it's place. So if there is missing functionality
  it will complain but will not crash the kernel.
  Maintainer of this driver please inspect if this functionality
  is still needed, if not then please remove the commented code.

  Thanks

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/ide-scsi.c |   53 ++++++++++++++++++++++++++++++----------------
 1 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 1cc01ac..e3e7d65 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
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
@@ -260,6 +262,10 @@ static inline void idescsi_transform_pc1 (ide_drive_t *drive, idescsi_pc_t *pc)
 			unsigned short new_len;
 			if (!scsi_buf)
 				return;
+			/* FIXME: see comment below at idescsi_transform_pc2 */
+			WARN_ON(1);
+
+#if 0
 			if ((atapi_buf = kmalloc(pc->buffer_size + 4, GFP_ATOMIC)) == NULL)
 				return;
 			memset(atapi_buf, 0, pc->buffer_size + 4);
@@ -281,12 +287,28 @@ static inline void idescsi_transform_pc1 (ide_drive_t *drive, idescsi_pc_t *pc)
 			pc->buffer = atapi_buf;
 			pc->request_transfer += 4;
 			pc->buffer_size += 4;
+#endif
 		}
 	}
 }
 
 static inline void idescsi_transform_pc2 (ide_drive_t *drive, idescsi_pc_t *pc)
 {
+	if (!test_bit(PC_TRANSFORM, &pc->flags))
+		return;
+
+	/*
+	 * FIXME: if code reached here then this driver is not
+	 * working for sure. If it is dead code then it can
+	 * surly be properly removed.
+	 *
+	 * Same is with above idescsi_transform_pc1() which
+	 * assumes pc->buffer must have something which surly
+	 * does not.
+	 */
+        WARN_ON(1);
+
+#if 0
 	u8 *atapi_buf = pc->buffer;
 	u8 *sc = pc->scsi_cmd->cmnd;
 	u8 *scsi_buf = pc->scsi_cmd->request_buffer;
@@ -308,6 +330,7 @@ static inline void idescsi_transform_pc2 (ide_drive_t *drive, idescsi_pc_t *pc)
 	}
 	if (atapi_buf && atapi_buf != scsi_buf)
 		kfree(atapi_buf);
+#endif
 }
 
 static void hexdump(u8 *x, int len)
@@ -435,6 +458,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 	} else {
 		pc->scsi_cmd->result = DID_OK << 16;
 		idescsi_transform_pc2 (drive, pc);
+#if 0
 		if (log) {
 			printk ("ide-scsi: %s: suc %lu", drive->name, pc->scsi_cmd->serial_number);
 			if (!test_bit(PC_WRITING, &pc->flags) && pc->actually_transferred && pc->actually_transferred <= 1024 && pc->buffer) {
@@ -443,6 +467,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 				hexdump(scsi_buf, min_t(unsigned, 16, pc->scsi_cmd->request_bufflen));
 			} else printk("\n");
 		}
+#endif
 	}
 	host = pc->scsi_cmd->device->host;
 	spin_lock_irqsave(host->host_lock, flags);
@@ -637,19 +662,14 @@ static int idescsi_map_sg(ide_drive_t *drive, idescsi_pc_t *pc)
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
@@ -905,15 +925,10 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
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



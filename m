From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] Is it time to kill ide-scsi.c?
Date: Wed, 04 Jul 2007 18:29:04 +0300
Message-ID: <468BBCC0.3010007@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:44597 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751565AbXGDP32 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jul 2007 11:29:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


 I have attempted (below) to convert ide-scsi to the new data
 accessors and cleanup the !use_sg code paths. Inspecting
 the code I can see places that still assume scsi_cmnd->request_buffer
 is a linear char pointer. Though I admit this assumption is hidden
 behind a flag "test_bit(PC_TRANSFORM, &pc->flags)". Is this an indication
 that this drivers no longer works? What is needed in order to kill this
 driver? If no killing is done than please accepted below patch.

 Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/ide-scsi.c |   48 ++++++++++++++++++++++++++++------------------
 1 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index bb90df8..4ee7ef3 100644
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
@@ -287,6 +289,21 @@ static inline void idescsi_transform_pc1 (ide_drive_t *drive, idescsi_pc_t *pc)
 
 static inline void idescsi_transform_pc2 (ide_drive_t *drive, idescsi_pc_t *pc)
 {
+	if (!test_bit(PC_TRANSFORM, &pc->flags))
+		return;
+
+	/* 
+	 * FIXME: if code reached here than this driver is not
+	 * working for sure. If it is a dead code than it can
+	 * surly be properly removed.
+	 * 
+	 * Same is with above idescsi_transform_pc1() which
+	 * assumes pc->buffer must have something which surly 
+	 * does not.
+	 */
+        BUG(); 
+
+#if 0
 	u8 *atapi_buf = pc->buffer;
 	u8 *sc = pc->scsi_cmd->cmnd;
 	u8 *scsi_buf = pc->scsi_cmd->request_buffer;
@@ -308,6 +325,7 @@ static inline void idescsi_transform_pc2 (ide_drive_t *drive, idescsi_pc_t *pc)
 	}
 	if (atapi_buf && atapi_buf != scsi_buf)
 		kfree(atapi_buf);
+#endif
 }
 
 static void hexdump(u8 *x, int len)
@@ -437,6 +455,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 	} else {
 		pc->scsi_cmd->result = DID_OK << 16;
 		idescsi_transform_pc2 (drive, pc);
+#if 0
 		if (log) {
 			printk ("ide-scsi: %s: suc %lu", drive->name, pc->scsi_cmd->serial_number);
 			if (!test_bit(PC_WRITING, &pc->flags) && pc->actually_transferred && pc->actually_transferred <= 1024 && pc->buffer) {
@@ -445,6 +464,7 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 				hexdump(scsi_buf, min_t(unsigned, 16, pc->scsi_cmd->request_bufflen));
 			} else printk("\n");
 		}
+#endif
 	}
 	host = pc->scsi_cmd->device->host;
 	spin_lock_irqsave(host->host_lock, flags);
@@ -639,19 +659,14 @@ static int idescsi_map_sg(ide_drive_t *drive, idescsi_pc_t *pc)
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
@@ -907,15 +922,10 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
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
1.5.2.2.249.g45fd


From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 8/9] ide-scsi: convert to use the data buffer accessors
Date: Fri, 7 Sep 2007 06:50:34 +0900
Message-ID: <20070906184024C.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:43080 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932515AbXIFVxF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2007 17:53:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bzolnier@gmail.com, jens.axboe@oracle.com, James.Bottomley@SteelEye.com, bharrosh@panasas.com, fujita.tomonori@lab.ntt.co.jp


This just blindly converts ide-scsi to use the new accessors for the
sg lists and the parameters.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ide-scsi.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index c05b291..42e821a 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -294,7 +294,7 @@ static inline void idescsi_transform_pc2 (ide_drive_t *drive, idescsi_pc_t *pc)
 {
 	u8 *atapi_buf = pc->buffer;
 	u8 *sc = pc->scsi_cmd->cmnd;
-	u8 *scsi_buf = pc->scsi_cmd->request_buffer;
+	u8 *scsi_buf = (u8 *)scsi_sglist(pc->scsi_cmd);
 
 	if (!test_bit(PC_TRANSFORM, &pc->flags))
 		return;
@@ -444,8 +444,9 @@ static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 			printk ("ide-scsi: %s: suc %lu", drive->name, pc->scsi_cmd->serial_number);
 			if (!test_bit(PC_WRITING, &pc->flags) && pc->actually_transferred && pc->actually_transferred <= 1024 && pc->buffer) {
 				printk(", rst = ");
-				scsi_buf = pc->scsi_cmd->request_buffer;
-				hexdump(scsi_buf, min_t(unsigned, 16, pc->scsi_cmd->request_bufflen));
+				scsi_buf = (u8 *)scsi_sglist(pc->scsi_cmd);
+				hexdump(scsi_buf, min_t(unsigned, 16,
+							scsi_bufflen(pc->scsi_cmd)));
 			} else printk("\n");
 		}
 	}
@@ -642,15 +643,15 @@ static int idescsi_map_sg(ide_drive_t *drive, idescsi_pc_t *pc)
 		return 1;
 
 	sg = hwif->sg_table;
-	scsi_sg = pc->scsi_cmd->request_buffer;
-	segments = pc->scsi_cmd->use_sg;
+	scsi_sg = scsi_sglist(pc->scsi_cmd);
+	segments = scsi_sg_count(pc->scsi_cmd);
 
 	if (segments > hwif->sg_max_nents)
 		return 1;
 
 	if (!segments) {
 		hwif->sg_nents = 1;
-		sg_init_one(sg, pc->scsi_cmd->request_buffer, pc->request_transfer);
+		sg_init_one(sg, scsi_sglist(pc->scsi_cmd), pc->request_transfer);
 	} else {
 		hwif->sg_nents = segments;
 		memcpy(sg, scsi_sg, sizeof(*sg) * segments);
@@ -910,17 +911,17 @@ static int idescsi_queue (struct scsi_cmnd *cmd,
 	pc->flags = 0;
 	pc->rq = rq;
 	memcpy (pc->c, cmd->cmnd, cmd->cmd_len);
-	if (cmd->use_sg) {
+	if (scsi_sg_count(cmd)) {
 		pc->buffer = NULL;
-		pc->sg = cmd->request_buffer;
-		pc->last_sg = sg_last(pc->sg, cmd->use_sg);
+		pc->sg = scsi_sglist(cmd);
+		pc->last_sg = sg_last(pc->sg, scsi_sg_count(cmd));
 	} else {
-		pc->buffer = cmd->request_buffer;
+		pc->buffer = (u8 *)scsi_sglist(cmd);
 		pc->sg = NULL;
 		pc->last_sg = NULL;
 	}
 	pc->b_count = 0;
-	pc->request_transfer = pc->buffer_size = cmd->request_bufflen;
+	pc->request_transfer = pc->buffer_size = scsi_bufflen(cmd);
 	pc->scsi_cmd = cmd;
 	pc->done = done;
 	pc->timeout = jiffies + cmd->timeout_per_command;
-- 
1.5.2.4


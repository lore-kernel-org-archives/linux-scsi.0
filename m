From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] tcm/iblock: Add UNMAP / Block DISCARD support
Date: Mon, 27 Sep 2010 15:51:39 -0700
Message-ID: <1285627899-6471-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm13.bullet.mail.sp2.yahoo.com ([98.139.91.83]:25695 "HELO
	nm13.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933308Ab0I0Wvp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 18:51:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds UNMAP emulation support using Block layer DISCARD in iblock_emulate_scsi_cdb()
-> transport_generic_unmap().  This includes the use of blk_queue_discard() in
iblock_create_virtdevice() to determine when to set DEV_ATTRIB(dev)->emulate_tpe=1 to
signal to TCM Core to perform the necessary control CDB emulation for TPE=1 / UNMAP.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 1b148f5..089f353 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -221,6 +221,16 @@ static struct se_device *iblock_create_virtdevice(
 	 */
 	if (__iblock_do_sync_cache(dev) == 0)
 		ib_dev->ibd_flags |= IBDF_BDEV_ISSUE_FLUSH;
+	/*
+	 * Check if the underlying struct block_device request_queue supports
+	 * the QUEUE_FLAG_DISCARD bit for UNMAP/WRITE_SAME in SCSI + TRIM
+	 * in ATA and we need to set TPE=1
+	 */
+	if (blk_queue_discard(bdev_get_queue(bd))) {
+		DEV_ATTRIB(dev)->emulate_tpe = 1;
+		printk(KERN_INFO "IBLOCK: Enabling BLOCK Discard"
+				" and TPE=1 emulation\n");
+	}
 
 	return dev;
 
@@ -446,8 +456,10 @@ static int iblock_emulate_read_cap16(struct se_task *task)
 
 static int iblock_emulate_scsi_cdb(struct se_task *task)
 {
-	int ret;
+	struct iblock_dev *ibd = (struct iblock_dev *) task->se_dev->dev_ptr;
+	struct block_device *bd = ibd->ibd_bd;
 	struct se_cmd *cmd = TASK_CMD(task);
+	int ret;
 
 	switch (T_TASK(cmd)->t_task_cdb[0]) {
 	case INQUIRY:
@@ -490,6 +502,11 @@ static int iblock_emulate_scsi_cdb(struct se_task *task)
 		if (ret < 0)
 			return ret;
 		break;
+	case UNMAP:
+		ret = transport_generic_unmap(cmd, bd);
+		if (ret < 0)
+			return ret;
+		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case ERASE:
 	case REZERO_UNIT:
-- 
1.5.6.5


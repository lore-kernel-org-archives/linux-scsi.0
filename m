From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] tcm/iblock,fileio: Fill in remaining Block Limits VPD from rq->limits
Date: Wed, 29 Sep 2010 14:21:10 -0700
Message-ID: <1285795270-31020-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.re3.yahoo.com ([66.196.96.85]:33002 "HELO
	smtp102.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752822Ab0I2VVP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2010 17:21:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates iblock_create_virtdevice() and fd_create_virtdevice()
to set the following device attributes from struct request_queue->limits values
when the generic Linux/Block Discard logic is enabled via blk_queue_discard()==1:

	max_unmap_lba_count = q->limits.max_discard_sectors;
	max_unmap_block_desc_count = 1
	unmap_granularity = q->limits.discard_granularity;
	unmap_granularity_alignment = q->limits.discard_alignment

Here is how it looks in action with sg_vpd with TCM_Loop -> TCM/IBLOCK ->
scsi_debug w/ TPE + TPU enabled:

target# sg_vpd --page=0xb0 /dev/sdh
Block limits VPD page (SBC):
  Maximum compare and write length: 0 blocks
  Optimal transfer length granularity: 1 blocks
  Maximum transfer length: 1024 blocks
  Optimal transfer length: 1024 blocks
  Maximum prefetch, xdread, xdwrite transfer length: 0 blocks
  Maximum unmap LBA count: 1024
  Maximum unmap block descriptor count: 1
  Optimal unmap granularity: 4096
  Unmap granularity alignment valid: 1
  Unmap granularity alignment: 4

Many thanks to Martin Petersen for answering questions here!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c   |   14 ++++++++++++++
 drivers/target/target_core_iblock.c |   15 ++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 8864f8f..d0afb50 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -241,6 +241,20 @@ static struct se_device *fd_create_virtdevice(
 	 */
 	if (S_ISBLK(inode->i_mode)) {
 		if (blk_queue_discard(bdev_get_queue(inode->i_bdev))) {
+			struct block_device *bd = inode->i_bdev;
+			struct request_queue *q = bdev_get_queue(bd);
+			
+			DEV_ATTRIB(dev)->max_unmap_lba_count =
+					q->limits.max_discard_sectors;
+			/*
+			 * Currently hardcoded to 1 in Linux/SCSI code..
+			 */
+			DEV_ATTRIB(dev)->max_unmap_block_desc_count = 1;
+			DEV_ATTRIB(dev)->unmap_granularity =
+					q->limits.discard_granularity;
+			DEV_ATTRIB(dev)->unmap_granularity_alignment =
+					q->limits.discard_alignment;
+
 			DEV_ATTRIB(dev)->emulate_tpu = 1;
 			printk(KERN_INFO "FILEIO: Enabling BLOCK Discard"
 				" and TPU=1 emulation\n");
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 80b9880..2dae7fd 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -227,8 +227,21 @@ static struct se_device *iblock_create_virtdevice(
 	 * in ATA and we need to set TPE=1
 	 */
 	if (blk_queue_discard(bdev_get_queue(bd))) {
+		struct request_queue *q = bdev_get_queue(bd);
+
+		DEV_ATTRIB(dev)->max_unmap_lba_count =
+				q->limits.max_discard_sectors;
+		/*
+		 * Currently hardcoded to 1 in Linux/SCSI code..
+		 */
+		DEV_ATTRIB(dev)->max_unmap_block_desc_count = 1;
+		DEV_ATTRIB(dev)->unmap_granularity =
+				q->limits.discard_granularity;
+		DEV_ATTRIB(dev)->unmap_granularity_alignment =
+				q->limits.discard_alignment;
+
 		DEV_ATTRIB(dev)->emulate_tpu = 1;
-		printk(KERN_INFO "IBLOCK: Enabling BLOCK Discard"
+		printk(KERN_INFO "IBLOCK: Enabling BLOCK Discard support"
 				" and TPU=1 emulation\n");
 	}
 
-- 
1.5.6.5


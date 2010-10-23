From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm/iblock: Update blkdev_issue_flush() parameter usage
Date: Sat, 23 Oct 2010 13:59:15 -0700
Message-ID: <1287867555-5796-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm5.bullet.mail.ne1.yahoo.com ([98.138.90.68]:48103 "HELO
	nm5.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751997Ab0JWU7W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Oct 2010 16:59:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings folks,

This patch follows Jen's for-2.6.37/core branch merged as commit 35da7a307c535
to convert blkdev_issue_flush() to use the new 'sector_t error_sector' and
drop legacy BLKDEV_IFL_WAIT usage.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index e7840da..a8267a8 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -410,12 +410,14 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 static int __iblock_do_sync_cache(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = (struct iblock_dev *)dev->dev_ptr;
+	sector_t error_sector;
 	int ret;
 
-	ret = blkdev_issue_flush(ib_dev->ibd_bd, GFP_KERNEL, NULL,
-				BLKDEV_IFL_WAIT);
+	ret = blkdev_issue_flush(ib_dev->ibd_bd, GFP_KERNEL, &error_sector);
 	if (ret != 0) {
-		printk(KERN_ERR "IBLOCK: block_issue_flush() failed: %d\n", ret);
+		printk(KERN_ERR "IBLOCK: block_issue_flush() failed: %d "
+			" error_sector: %llu\n", ret,
+			(unsigned long long)error_sector);
 		return -1;
 	}
 	DEBUG_IBLOCK("IBLOCK: Called block_issue_flush()\n");
-- 
1.7.3.2


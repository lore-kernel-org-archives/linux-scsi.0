From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 01/31] target: iblock/pscsi claim checking for NULL instead of IS_ERR
Date: Wed,  9 Feb 2011 15:34:36 -0800
Message-ID: <1297294506-23579-2-git-send-email-nab@linux-iscsi.org>
References: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm3-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.55]:37018 "HELO
	nm3-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754896Ab1BIXey (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 18:34:54 -0500
In-Reply-To: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Dan Carpenter <error27@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Dan Carpenter <error27@gmail.com>

blkdev_get_by_path() returns an ERR_PTR() or error and it doesn't return
a NULL.  It looks like this bug would be easy to trigger by mistake.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c |    2 +-
 drivers/target/target_core_pscsi.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index c6e0d75..3456135 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -154,7 +154,7 @@ static struct se_device *iblock_create_virtdevice(
 
 	bd = blkdev_get_by_path(ib_dev->ibd_udev_path,
 				FMODE_WRITE|FMODE_READ|FMODE_EXCL, ib_dev);
-	if (!(bd))
+	if (IS_ERR(bd))
 		goto failed;
 	/*
 	 * Setup the local scope queue_limits from struct request_queue->limits
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 742d246..f2a0847 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -462,8 +462,8 @@ static struct se_device *pscsi_create_type_disk(
 	 */
 	bd = blkdev_get_by_path(se_dev->se_dev_udev_path,
 				FMODE_WRITE|FMODE_READ|FMODE_EXCL, pdv);
-	if (!(bd)) {
-		printk("pSCSI: blkdev_get_by_path() failed\n");
+	if (IS_ERR(bd)) {
+		printk(KERN_ERR "pSCSI: blkdev_get_by_path() failed\n");
 		scsi_device_put(sd);
 		return NULL;
 	}
-- 
1.7.4


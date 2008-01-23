From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] ch: handle class_device_create failure properly
Date: Wed, 23 Jan 2008 23:34:35 +0900
Message-ID: <20080123233047Z.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:50564 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbYAWOen (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jan 2008 09:34:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

When class_device_create fails, ch_probe needs to fail too.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ch.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index cead0f5..765f2fc 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -913,29 +913,37 @@ static long ch_ioctl_compat(struct file * file,
 static int ch_probe(struct device *dev)
 {
 	struct scsi_device *sd = to_scsi_device(dev);
+	struct class_device *class_dev;
 	scsi_changer *ch;
-	
+
 	if (sd->type != TYPE_MEDIUM_CHANGER)
 		return -ENODEV;
-    
+
 	ch = kzalloc(sizeof(*ch), GFP_KERNEL);
 	if (NULL == ch)
 		return -ENOMEM;
 
 	ch->minor = ch_devcount;
 	sprintf(ch->name,"ch%d",ch->minor);
+
+	class_dev = class_device_create(ch_sysfs_class, NULL,
+					MKDEV(SCSI_CHANGER_MAJOR, ch->minor),
+					dev, "s%s", ch->name);
+	if (IS_ERR(class_dev)) {
+		printk(KERN_WARNING "ch%d: class_device_create failed\n",
+		       ch->minor);
+		kfree(ch);
+		return PTR_ERR(class_dev);
+	}
+
 	mutex_init(&ch->lock);
 	ch->device = sd;
 	ch_readconfig(ch);
 	if (init)
 		ch_init_elem(ch);
 
-	class_device_create(ch_sysfs_class, NULL,
-			    MKDEV(SCSI_CHANGER_MAJOR,ch->minor),
-			    dev, "s%s", ch->name);
-
 	sdev_printk(KERN_INFO, sd, "Attached scsi changer %s\n", ch->name);
-	
+
 	spin_lock(&ch_devlist_lock);
 	list_add_tail(&ch->list,&ch_devlist);
 	ch_devcount++;
-- 
1.5.3.4


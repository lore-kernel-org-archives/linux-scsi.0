From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/2] sg: handle class_device_create failure properly
Date: Tue, 15 Jan 2008 13:18:00 +0900
Message-ID: <20080115131800Q.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:49011 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbYAOEST (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 23:18:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James.Bottomley@HansenPartnership.com, mdr@sgi.com, linux-scsi@vger.kernel.org, tomof@acm.org


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 92b4367..527e2eb 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1430,11 +1430,14 @@ sg_add(struct class_device *cl_dev, struct class_interface *cl_intf)
 				MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
 				cl_dev->dev, "%s",
 				disk->disk_name);
-		if (IS_ERR(sg_class_member))
-			printk(KERN_WARNING "sg_add: "
-				"class_device_create failed\n");
+		if (IS_ERR(sg_class_member)) {
+			printk(KERN_ERR "sg_add: "
+			       "class_device_create failed\n");
+			error = PTR_ERR(sg_class_member);
+			goto cdev_add_err;
+		}
 		class_set_devdata(sg_class_member, sdp);
-		error = sysfs_create_link(&scsidp->sdev_gendev.kobj, 
+		error = sysfs_create_link(&scsidp->sdev_gendev.kobj,
 					  &sg_class_member->kobj, "generic");
 		if (error)
 			printk(KERN_ERR "sg_add: unable to make symlink "
-- 
1.5.3.4


From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix error handling in i2o_device_add()
Date: Thu, 10 Jul 2008 13:05:02 +0100
Message-ID: <20080710120501.27638.83131.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbYGJMFd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2008 08:05:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Fix error handling in i2o_device_add() - sysfs_create_link() can return an
error.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/message/i2o/device.c |   90 +++++++++++++++++++++++++++++++++---------
 1 files changed, 71 insertions(+), 19 deletions(-)


diff --git a/drivers/message/i2o/device.c b/drivers/message/i2o/device.c
index 489d7c5..c8b37e9 100644
--- a/drivers/message/i2o/device.c
+++ b/drivers/message/i2o/device.c
@@ -218,7 +218,8 @@ static struct i2o_device *i2o_device_alloc(void)
  */
 static int i2o_device_add(struct i2o_controller *c, i2o_lct_entry *entry)
 {
-	struct i2o_device *i2o_dev, *tmp;
+	struct list_head *_usrdev, *_pardev;
+	struct i2o_device *i2o_dev, *usr, *usrdev, *par, *pardev;
 	int rc;
 
 	i2o_dev = i2o_device_alloc();
@@ -242,30 +243,52 @@ static int i2o_device_add(struct i2o_controller *c, i2o_lct_entry *entry)
 	list_add_tail(&i2o_dev->list, &c->devices);
 
 	/* create user entries for this device */
-	tmp = i2o_iop_find_device(i2o_dev->iop, i2o_dev->lct_data.user_tid);
-	if (tmp && (tmp != i2o_dev))
-		sysfs_create_link(&i2o_dev->device.kobj, &tmp->device.kobj,
-				  "user");
+	usr = i2o_iop_find_device(i2o_dev->iop, i2o_dev->lct_data.user_tid);
+	if (usr && usr != i2o_dev) {
+		rc = sysfs_create_link(&i2o_dev->device.kobj, &usr->device.kobj,
+				       "user");
+		if (rc != 0)
+			goto err_unregister;
+	} else {
+		usr = NULL;
+	}
 
 	/* create user entries refering to this device */
-	list_for_each_entry(tmp, &c->devices, list)
-	    if ((tmp->lct_data.user_tid == i2o_dev->lct_data.tid)
-		&& (tmp != i2o_dev))
-		sysfs_create_link(&tmp->device.kobj,
-				  &i2o_dev->device.kobj, "user");
+	list_for_each(_usrdev, &c->devices) {
+		usrdev = list_entry(_usrdev, struct i2o_device, list);
+		if (usrdev->lct_data.user_tid == i2o_dev->lct_data.tid &&
+		    usrdev != i2o_dev) {
+			rc = sysfs_create_link(&usrdev->device.kobj,
+					       &i2o_dev->device.kobj,
+					       "user");
+			if (rc != 0)
+				goto err_discard_user_links;
+		}
+	}
 
 	/* create parent entries for this device */
-	tmp = i2o_iop_find_device(i2o_dev->iop, i2o_dev->lct_data.parent_tid);
-	if (tmp && (tmp != i2o_dev))
-		sysfs_create_link(&i2o_dev->device.kobj, &tmp->device.kobj,
-				  "parent");
+	par = i2o_iop_find_device(i2o_dev->iop, i2o_dev->lct_data.parent_tid);
+	if (par && par != i2o_dev) {
+		rc = sysfs_create_link(&i2o_dev->device.kobj, &par->device.kobj,
+				       "parent");
+		if (rc != 0)
+			goto err_discard_user_links;
+	} else {
+		par = NULL;
+	}
 
 	/* create parent entries refering to this device */
-	list_for_each_entry(tmp, &c->devices, list)
-	    if ((tmp->lct_data.parent_tid == i2o_dev->lct_data.tid)
-		&& (tmp != i2o_dev))
-		sysfs_create_link(&tmp->device.kobj,
-				  &i2o_dev->device.kobj, "parent");
+	list_for_each(_pardev, &c->devices) {
+		pardev = list_entry(_pardev, struct i2o_device, list);
+		if (pardev->lct_data.parent_tid == i2o_dev->lct_data.tid &&
+		    pardev != i2o_dev) {
+			rc = sysfs_create_link(&pardev->device.kobj,
+					       &i2o_dev->device.kobj,
+					       "parent");
+			if (rc != 0)
+				goto err_discard_parent_links;
+		}
+	}
 
 	i2o_driver_notify_device_add_all(i2o_dev);
 
@@ -273,6 +296,35 @@ static int i2o_device_add(struct i2o_controller *c, i2o_lct_entry *entry)
 
 	return 0;
 
+err_discard_parent_links:
+	while (_pardev = _pardev->prev,
+	       prefetch(_pardev->prev),
+	       _pardev != &c->devices
+	       ) {
+		pardev = list_entry(_pardev, struct i2o_device, list);
+		if (pardev->lct_data.parent_tid == i2o_dev->lct_data.tid &&
+		    pardev != i2o_dev)
+			sysfs_remove_link(&pardev->device.kobj, "parent");
+	}
+	if (par)
+		sysfs_remove_link(&i2o_dev->device.kobj, "parent");
+
+err_discard_user_links:
+	while (_usrdev = _usrdev->prev,
+	       prefetch(_usrdev->prev),
+	       _usrdev != &c->devices
+	       ) {
+		usrdev = list_entry(_usrdev, struct i2o_device, list);
+		if (usrdev->lct_data.user_tid == i2o_dev->lct_data.tid &&
+		    usrdev != i2o_dev)
+			sysfs_remove_link(&usrdev->device.kobj, "user");
+	}
+	if (usr)
+		sysfs_remove_link(&i2o_dev->device.kobj, "user");
+
+err_unregister:
+	list_del_init(&i2o_dev->list);
+	device_unregister(&i2o_dev->device);
 err:
 	kfree(i2o_dev);
 	return rc;


From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] ch: fix device minor number management bug
Date: Thu, 24 Jan 2008 17:24:50 +0900
Message-ID: <20080124172450N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:59423 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYAXIYu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jan 2008 03:24:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org

Oops, sorry, I sent the patches to linux-kernel...

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] ch: fix device minor number management bug

ch_probe uses the total number of ch devices as minor.

ch_probe:
	ch->minor = ch_devcount;
...
	ch_devcount++;

Then ch_remove decreases ch_devcount:

ch_remove:
	ch_devcount--;

If you have two ch devices, sch0 and sch1, and remove sch0,
ch_devcount is 1. Then if you add another ch device, ch_probe tries to
create sch1. So you get a warning and fail to create sch1:

Jan 24 16:01:05 nice kernel: sysfs: duplicate filename 'sch1' can not be created
Jan 24 16:01:05 nice kernel: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Jan 24 16:01:05 nice kernel: Pid: 2571, comm: iscsid Not tainted 2.6.24-rc7-ga3d2c2e8-dirty #1
Jan 24 16:01:05 nice kernel:
Jan 24 16:01:05 nice kernel: Call Trace:
Jan 24 16:01:05 nice kernel:  [<ffffffff802a22b8>] sysfs_add_one+0x54/0xbd
Jan 24 16:01:05 nice kernel:  [<ffffffff802a283c>] create_dir+0x4f/0x87
Jan 24 16:01:05 nice kernel:  [<ffffffff802a28a9>] sysfs_create_dir+0x35/0x4a
Jan 24 16:01:05 nice kernel:  [<ffffffff803069a1>] kobject_get+0x12/0x17
Jan 24 16:01:05 nice kernel:  [<ffffffff80306ece>] kobject_add+0xf3/0x1a6
Jan 24 16:01:05 nice kernel:  [<ffffffff8034252b>] class_device_add+0xaa/0x39d
Jan 24 16:01:05 nice kernel:  [<ffffffff803428fb>] class_device_create+0xcb/0xfa
Jan 24 16:01:05 nice kernel:  [<ffffffff80229e09>] printk+0x4e/0x56
Jan 24 16:01:05 nice kernel:  [<ffffffff802a2054>] sysfs_ilookup_test+0x0/0xf
Jan 24 16:01:05 nice kernel:  [<ffffffff88022580>] :ch:ch_probe+0xbe/0x61a

(snip)

This patch converts ch to use a standard minor number management way,
idr like sg and bsg.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ch.c |   71 +++++++++++++++++++++++++++++-----------------------
 1 files changed, 40 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 765f2fc..2b07014 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -21,6 +21,7 @@
 #include <linux/compat.h>
 #include <linux/chio.h>			/* here are all the ioctls */
 #include <linux/mutex.h>
+#include <linux/idr.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -33,6 +34,7 @@
 
 #define CH_DT_MAX       16
 #define CH_TYPES        8
+#define CH_MAX_DEVS     128
 
 MODULE_DESCRIPTION("device driver for scsi media changer devices");
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org>");
@@ -113,9 +115,8 @@ typedef struct {
 	struct mutex	    lock;
 } scsi_changer;
 
-static LIST_HEAD(ch_devlist);
-static DEFINE_SPINLOCK(ch_devlist_lock);
-static int ch_devcount;
+static DEFINE_IDR(ch_index_idr);
+static DEFINE_SPINLOCK(ch_index_lock);
 
 static struct scsi_driver ch_template =
 {
@@ -598,20 +599,17 @@ ch_release(struct inode *inode, struct file *file)
 static int
 ch_open(struct inode *inode, struct file *file)
 {
-	scsi_changer *tmp, *ch;
+	scsi_changer *ch;
 	int minor = iminor(inode);
 
-	spin_lock(&ch_devlist_lock);
-	ch = NULL;
-	list_for_each_entry(tmp,&ch_devlist,list) {
-		if (tmp->minor == minor)
-			ch = tmp;
-	}
+	spin_lock(&ch_index_lock);
+	ch = idr_find(&ch_index_idr, minor);
+
 	if (NULL == ch || scsi_device_get(ch->device)) {
-		spin_unlock(&ch_devlist_lock);
+		spin_unlock(&ch_index_lock);
 		return -ENXIO;
 	}
-	spin_unlock(&ch_devlist_lock);
+	spin_unlock(&ch_index_lock);
 
 	file->private_data = ch;
 	return 0;
@@ -914,6 +912,7 @@ static int ch_probe(struct device *dev)
 {
 	struct scsi_device *sd = to_scsi_device(dev);
 	struct class_device *class_dev;
+	int minor, ret = -ENOMEM;
 	scsi_changer *ch;
 
 	if (sd->type != TYPE_MEDIUM_CHANGER)
@@ -923,7 +922,22 @@ static int ch_probe(struct device *dev)
 	if (NULL == ch)
 		return -ENOMEM;
 
-	ch->minor = ch_devcount;
+	if (!idr_pre_get(&ch_index_idr, GFP_KERNEL))
+		goto free_ch;
+
+	spin_lock(&ch_index_lock);
+	ret = idr_get_new(&ch_index_idr, ch, &minor);
+	spin_unlock(&ch_index_lock);
+
+	if (ret)
+		goto free_ch;
+
+	if (minor > CH_MAX_DEVS) {
+		ret = -ENODEV;
+		goto remove_idr;
+	}
+
+	ch->minor = minor;
 	sprintf(ch->name,"ch%d",ch->minor);
 
 	class_dev = class_device_create(ch_sysfs_class, NULL,
@@ -932,8 +946,8 @@ static int ch_probe(struct device *dev)
 	if (IS_ERR(class_dev)) {
 		printk(KERN_WARNING "ch%d: class_device_create failed\n",
 		       ch->minor);
-		kfree(ch);
-		return PTR_ERR(class_dev);
+		ret = PTR_ERR(class_dev);
+		goto remove_idr;
 	}
 
 	mutex_init(&ch->lock);
@@ -942,35 +956,29 @@ static int ch_probe(struct device *dev)
 	if (init)
 		ch_init_elem(ch);
 
+	dev_set_drvdata(dev, ch);
 	sdev_printk(KERN_INFO, sd, "Attached scsi changer %s\n", ch->name);
 
-	spin_lock(&ch_devlist_lock);
-	list_add_tail(&ch->list,&ch_devlist);
-	ch_devcount++;
-	spin_unlock(&ch_devlist_lock);
 	return 0;
+remove_idr:
+	idr_remove(&ch_index_idr, minor);
+free_ch:
+	kfree(ch);
+	return ret;
 }
 
 static int ch_remove(struct device *dev)
 {
-	struct scsi_device *sd = to_scsi_device(dev);
-	scsi_changer *tmp, *ch;
+	scsi_changer *ch = dev_get_drvdata(dev);
 
-	spin_lock(&ch_devlist_lock);
-	ch = NULL;
-	list_for_each_entry(tmp,&ch_devlist,list) {
-		if (tmp->device == sd)
-			ch = tmp;
-	}
-	BUG_ON(NULL == ch);
-	list_del(&ch->list);
-	spin_unlock(&ch_devlist_lock);
+	spin_lock(&ch_index_lock);
+	idr_remove(&ch_index_idr, ch->minor);
+	spin_unlock(&ch_index_lock);
 
 	class_device_destroy(ch_sysfs_class,
 			     MKDEV(SCSI_CHANGER_MAJOR,ch->minor));
 	kfree(ch->dt);
 	kfree(ch);
-	ch_devcount--;
 	return 0;
 }
 
@@ -1007,6 +1015,7 @@ static void __exit exit_ch_module(void)
 	scsi_unregister_driver(&ch_template.gendrv);
 	unregister_chrdev(SCSI_CHANGER_MAJOR, "ch");
 	class_destroy(ch_sysfs_class);
+	idr_destroy(&ch_index_idr);
 }
 
 module_init(init_ch_module);
-- 
1.5.3.4


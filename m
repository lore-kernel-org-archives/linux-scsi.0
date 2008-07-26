From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/3] rename blk_scsi_cmd_filter to blk_cmd_filter
Date: Sat, 26 Jul 2008 18:03:25 +0900
Message-ID: <1217063005-25083-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <20080724123140V.fujita.tomonori@lab.ntt.co.jp>
 <1217063005-25083-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1217063005-25083-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1217063005-25083-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:55197 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbYGZJFW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jul 2008 05:05:22 -0400
In-Reply-To: <1217063005-25083-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, dan.j.williams@intel.com, adel.gadllah@gmail.com, pjones@redhat.com, viro@ZenIV.linux.org.uk, dougg@torque.net, matthew@wil.cx, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Technically, the cmd_filter would be applied to other protocols though
it's unlikely to happen. Putting SCSI stuff to request_queue is kinda
layer violation. So let's rename it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/cmd-filter.c     |   30 +++++++++++++++---------------
 block/scsi_ioctl.c     |    2 +-
 include/linux/blkdev.h |    8 ++++----
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/block/cmd-filter.c b/block/cmd-filter.c
index c705c33..0e3a123 100644
--- a/block/cmd-filter.c
+++ b/block/cmd-filter.c
@@ -27,7 +27,7 @@
 #include <scsi/scsi.h>
 #include <linux/cdrom.h>
 
-int blk_verify_command(struct blk_scsi_cmd_filter *filter,
+int blk_verify_command(struct blk_cmd_filter *filter,
 		       unsigned char *cmd, int has_write_perm)
 {
 	/* root can do any command. */
@@ -51,7 +51,7 @@ int blk_verify_command(struct blk_scsi_cmd_filter *filter,
 EXPORT_SYMBOL(blk_verify_command);
 
 /* and now, the sysfs stuff */
-static ssize_t rcf_cmds_show(struct blk_scsi_cmd_filter *filter, char *page,
+static ssize_t rcf_cmds_show(struct blk_cmd_filter *filter, char *page,
 			     int rw)
 {
 	char *npage = page;
@@ -78,18 +78,18 @@ static ssize_t rcf_cmds_show(struct blk_scsi_cmd_filter *filter, char *page,
 	return npage - page;
 }
 
-static ssize_t rcf_readcmds_show(struct blk_scsi_cmd_filter *filter, char *page)
+static ssize_t rcf_readcmds_show(struct blk_cmd_filter *filter, char *page)
 {
 	return rcf_cmds_show(filter, page, READ);
 }
 
-static ssize_t rcf_writecmds_show(struct blk_scsi_cmd_filter *filter,
+static ssize_t rcf_writecmds_show(struct blk_cmd_filter *filter,
 				 char *page)
 {
 	return rcf_cmds_show(filter, page, WRITE);
 }
 
-static ssize_t rcf_cmds_store(struct blk_scsi_cmd_filter *filter,
+static ssize_t rcf_cmds_store(struct blk_cmd_filter *filter,
 			      const char *page, size_t count, int rw)
 {
 	ssize_t ret = 0;
@@ -122,13 +122,13 @@ static ssize_t rcf_cmds_store(struct blk_scsi_cmd_filter *filter,
 	return count;
 }
 
-static ssize_t rcf_readcmds_store(struct blk_scsi_cmd_filter *filter,
+static ssize_t rcf_readcmds_store(struct blk_cmd_filter *filter,
 				  const char *page, size_t count)
 {
 	return rcf_cmds_store(filter, page, count, READ);
 }
 
-static ssize_t rcf_writecmds_store(struct blk_scsi_cmd_filter *filter,
+static ssize_t rcf_writecmds_store(struct blk_cmd_filter *filter,
 				   const char *page, size_t count)
 {
 	return rcf_cmds_store(filter, page, count, WRITE);
@@ -136,8 +136,8 @@ static ssize_t rcf_writecmds_store(struct blk_scsi_cmd_filter *filter,
 
 struct rcf_sysfs_entry {
 	struct attribute attr;
-	ssize_t (*show)(struct blk_scsi_cmd_filter *, char *);
-	ssize_t (*store)(struct blk_scsi_cmd_filter *, const char *, size_t);
+	ssize_t (*show)(struct blk_cmd_filter *, char *);
+	ssize_t (*store)(struct blk_cmd_filter *, const char *, size_t);
 };
 
 static struct rcf_sysfs_entry rcf_readcmds_entry = {
@@ -164,9 +164,9 @@ static ssize_t
 rcf_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 {
 	struct rcf_sysfs_entry *entry = to_rcf(attr);
-	struct blk_scsi_cmd_filter *filter;
+	struct blk_cmd_filter *filter;
 
-	filter = container_of(kobj, struct blk_scsi_cmd_filter, kobj);
+	filter = container_of(kobj, struct blk_cmd_filter, kobj);
 	if (entry->show)
 		return entry->show(filter, page);
 
@@ -178,7 +178,7 @@ rcf_attr_store(struct kobject *kobj, struct attribute *attr,
 			const char *page, size_t length)
 {
 	struct rcf_sysfs_entry *entry = to_rcf(attr);
-	struct blk_scsi_cmd_filter *filter;
+	struct blk_cmd_filter *filter;
 
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
@@ -186,7 +186,7 @@ rcf_attr_store(struct kobject *kobj, struct attribute *attr,
 	if (!entry->store)
 		return -EINVAL;
 
-	filter = container_of(kobj, struct blk_scsi_cmd_filter, kobj);
+	filter = container_of(kobj, struct blk_cmd_filter, kobj);
 	return entry->store(filter, page, length);
 }
 
@@ -203,7 +203,7 @@ static struct kobj_type rcf_ktype = {
 int blk_register_filter(struct gendisk *disk)
 {
 	int ret;
-	struct blk_scsi_cmd_filter *filter = &disk->queue->cmd_filter;
+	struct blk_cmd_filter *filter = &disk->queue->cmd_filter;
 	struct kobject *parent = kobject_get(disk->holder_dir->parent);
 
 	if (!parent)
@@ -220,7 +220,7 @@ int blk_register_filter(struct gendisk *disk)
 
 void blk_unregister_filter(struct gendisk *disk)
 {
-	struct blk_scsi_cmd_filter *filter = &disk->queue->cmd_filter;
+	struct blk_cmd_filter *filter = &disk->queue->cmd_filter;
 
 	kobject_put(&filter->kobj);
 	kobject_put(disk->holder_dir->parent);
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 1f7d56e..6ae41a5 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -105,7 +105,7 @@ static int sg_emulated_host(struct request_queue *q, int __user *p)
 	return put_user(1, p);
 }
 
-void blk_set_cmd_filter_defaults(struct blk_scsi_cmd_filter *filter)
+void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 {
 	/* Basic read-only commands */
 	__set_bit(TEST_UNIT_READY, filter->read_ok);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 211160f..e23f2ad 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -283,7 +283,7 @@ struct blk_queue_tag {
 #define BLK_SCSI_MAX_CMDS	(256)
 #define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
 
-struct blk_scsi_cmd_filter {
+struct blk_cmd_filter {
 	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
 	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
 	struct kobject kobj;
@@ -407,7 +407,7 @@ struct request_queue
 #if defined(CONFIG_BLK_DEV_BSG)
 	struct bsg_class_device bsg_dev;
 #endif
-	struct blk_scsi_cmd_filter cmd_filter;
+	struct blk_cmd_filter cmd_filter;
 };
 
 #define QUEUE_FLAG_CLUSTER	0	/* cluster several segments into 1 */
@@ -842,11 +842,11 @@ extern int blkdev_issue_flush(struct block_device *, sector_t *);
 /*
 * command filter functions
 */
-extern int blk_verify_command(struct blk_scsi_cmd_filter *filter,
+extern int blk_verify_command(struct blk_cmd_filter *filter,
 			      unsigned char *cmd, int has_write_perm);
 extern int blk_register_filter(struct gendisk *disk);
 extern void blk_unregister_filter(struct gendisk *disk);
-extern void blk_set_cmd_filter_defaults(struct blk_scsi_cmd_filter *filter);
+extern void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter);
 
 #define MAX_PHYS_SEGMENTS 128
 #define MAX_HW_SEGMENTS 128
-- 
1.5.4.2


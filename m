From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [-v3 PATCH 1/3] block: add a new attribute "alias" in gendisk
Date: Thu, 25 Aug 2011 18:04:06 +0900
Message-ID: <20110825090406.2288.70186.stgit@ltc197.sdl.hitachi.co.jp>
References: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, James.Bottomley@HansenPartnership.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, Nao Nishijima <nao.nishijima.xt@hitachi.com>
List-Id: linux-scsi@vger.kernel.org

This patch allows the user to set an "alias" of the disk via sysfs interface.

This patch only adds a new attribute "alias" in gendisk structure.
To show the alias instead of the device name in kernel messages,
we need to revise printk messages and use alias_name() in them.

Example:
(current) printk("disk name is %s\n", disk->disk_name);
(new)     printk("disk name is %s\n", alias_name(disk));

Users can use alphabets, numbers, '-' and '_' in "alias" attribute. A disk can
have an "alias" which length is up to 255 bytes. This attribute is write-once.

Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Suggested-by: Jon Masters <jcm@redhat.com>
Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
---

 Documentation/ABI/testing/sysfs-block |   13 ++++++
 block/genhd.c                         |   71 +++++++++++++++++++++++++++++++++
 include/linux/genhd.h                 |    4 ++
 3 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index c1eb41c..2b5d561 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -206,3 +206,16 @@ Description:
 		when a discarded area is read the discard_zeroes_data
 		parameter will be set to one. Otherwise it will be 0 and
 		the result of reading a discarded area is undefined.
+What:		/sys/block/<disk>/alias
+Date:		Aug 2011
+Contact:	Nao Nishijima <nao.nishijima.xt@hitachi.com>
+Description:
+		A raw device name of a disk does not always point a same disk
+		each boot-up time. Therefore, users have to use persistent
+		device names, which udev creates when the kernel finds a disk,
+		instead of raw device name. However, kernel doesn't show those
+		persistent names on its messages (e.g. dmesg).
+		This file can store an alias of the disk and it would be
+		appeared in kernel messages if it is set. A disk can have an
+		alias which length is up to 255bytes. Users can use alphabets,
+		numbers, "-" and "_" in alias name. This file is writeonce.
diff --git a/block/genhd.c b/block/genhd.c
index e2f6790..94855a9 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -19,6 +19,7 @@
 #include <linux/mutex.h>
 #include <linux/idr.h>
 #include <linux/log2.h>
+#include <linux/ctype.h>
 
 #include "blk.h"
 
@@ -909,6 +910,74 @@ static int __init genhd_device_init(void)
 
 subsys_initcall(genhd_device_init);
 
+static ssize_t alias_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	ssize_t ret = 0;
+
+	if (disk->alias)
+		ret = snprintf(buf, ALIAS_LEN, "%s\n", disk->alias);
+	return ret;
+}
+
+static ssize_t alias_store(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	char *alias;
+	char *envp[] = { NULL, NULL };
+	unsigned char c;
+	int i;
+	ssize_t ret = count;
+
+	if (!count)
+		return -EINVAL;
+
+	if (count >= ALIAS_LEN) {
+		printk(KERN_ERR "alias: alias is too long\n");
+		return -EINVAL;
+	}
+
+	/* Validation check */
+	for (i = 0; i < count; i++) {
+		c = buf[i];
+		if (i == count - 1 && c == '\n')
+			break;
+		if (!isalnum(c) && c != '_' && c != '-') {
+			printk(KERN_ERR "alias: invalid alias\n");
+			return -EINVAL;
+		}
+	}
+
+	if (disk->alias) {
+		printk(KERN_INFO "alias: %s is already assigned (%s)\n",
+		       disk->disk_name, disk->alias);
+		return -EINVAL;
+	}
+
+	alias = kasprintf(GFP_KERNEL, "%s", buf);
+	if (!alias)
+		return -ENOMEM;
+
+	if (alias[count - 1] == '\n')
+		alias[count - 1] = '\0';
+
+	envp[0] = kasprintf(GFP_KERNEL, "ALIAS=%s", alias);
+	if (!envp[0]) {
+		kfree(alias);
+		return -ENOMEM;
+	}
+
+	disk->alias = alias;
+	printk(KERN_INFO "alias: assigned %s to %s\n", alias, disk->disk_name);
+
+	kobject_uevent_env(&dev->kobj, KOBJ_ADD, envp);
+
+	kfree(envp[0]);
+	return ret;
+}
+
 static ssize_t disk_range_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
@@ -968,6 +1037,7 @@ static ssize_t disk_discard_alignment_show(struct device *dev,
 	return sprintf(buf, "%d\n", queue_discard_alignment(disk->queue));
 }
 
+static DEVICE_ATTR(alias, S_IRUGO|S_IWUSR, alias_show, alias_store);
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
@@ -990,6 +1060,7 @@ static struct device_attribute dev_attr_fail_timeout =
 #endif
 
 static struct attribute *disk_attrs[] = {
+	&dev_attr_alias.attr,
 	&dev_attr_range.attr,
 	&dev_attr_ext_range.attr,
 	&dev_attr_removable.attr,
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 02fa469..6957350 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -21,6 +21,8 @@
 #define dev_to_part(device)	container_of((device), struct hd_struct, __dev)
 #define disk_to_dev(disk)	(&(disk)->part0.__dev)
 #define part_to_dev(part)	(&((part)->__dev))
+#define alias_name(disk)	((disk)->alias ? (disk)->alias : \
+						 (disk)->disk_name)
 
 extern struct device_type part_type;
 extern struct kobject *block_depr;
@@ -58,6 +60,7 @@ enum {
 
 #define DISK_MAX_PARTS			256
 #define DISK_NAME_LEN			32
+#define ALIAS_LEN			256
 
 #include <linux/major.h>
 #include <linux/device.h>
@@ -162,6 +165,7 @@ struct gendisk {
                                          * disks that can't be partitioned. */
 
 	char disk_name[DISK_NAME_LEN];	/* name of major driver */
+	char *alias;			/* alias name of disk */
 	char *(*devnode)(struct gendisk *gd, mode_t *mode);
 
 	unsigned int events;		/* supported events */

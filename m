From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [PATCH v2 2/3] block: add a new attribute "alias name" in gendisk
 structure
Date: Fri, 22 Jul 2011 19:59:55 +0900
Message-ID: <20110722105955.7330.29063.stgit@ltc197.sdl.hitachi.co.jp>
References: <20110722105925.7330.6609.stgit@ltc197.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110722105925.7330.6609.stgit@ltc197.sdl.hitachi.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org, jcm@redhat.com, coughlan@redhat.com, kzak@redhat.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, greg@kroah.com, dgilbert@interlog.com, stefanr@s5r6.in-berlin.de, hare@suse.de, joe@perches.com, Nao Nishijima <nao.nishijima.xt@hitachi.com>
List-Id: linux-scsi@vger.kernel.org

This patch allows the user to set an "alias name" of the disk via sysfs
interface.

A raw device name of a disk does not always point a same disk at each boot-up
time. Therefore, users have to use persistent device names, which udev creates
to always access the same disk. However, kernel messages still display the raw
device names.

This patch adds a new attribute "alias name" in gendisk structure. And if users
set their preferred name to an "alias name" of the disk, it would be appeared
in kernel messages. A disk can have an "alias name" which length is up to
255bytes. Users can use alphabets, numbers, '-' and '_' in alias name.

Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Suggested-by: Jon Masters <jcm@redhat.com>
Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
---

 Documentation/ABI/testing/sysfs-block |   15 ++++++
 block/genhd.c                         |   84 +++++++++++++++++++++++++++++++++
 include/linux/genhd.h                 |    4 ++
 3 files changed, 103 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index c1eb41c..c42be33 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -206,3 +206,18 @@ Description:
 		when a discarded area is read the discard_zeroes_data
 		parameter will be set to one. Otherwise it will be 0 and
 		the result of reading a discarded area is undefined.
+
+What:		/sys/block/<disk>/alias_name
+Date:		July 2011
+Contact:	Nao Nishijima <nao.nishijima.xt@hitachi.com>
+Description:
+		A raw device name of a disk does not always point a same disk
+		each boot-up time. Therefore, users have to use persistent
+		device names, which udev creates when the kernel finds a disk,
+		instead of raw device name. However, kernel doesn't show those
+		persistent names on its message.
+		This file can store an alias name of the disk and it would be
+		appeared in kernel messages if it is set. A disk can have an
+		alias name which length is up to 255bytes. Users can use
+		use alphabets, numbers, "-" and "_" in alias name. An alias
+		name is write at once.
diff --git a/block/genhd.c b/block/genhd.c
index 3608289..04136e6 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -19,6 +19,7 @@
 #include <linux/mutex.h>
 #include <linux/idr.h>
 #include <linux/log2.h>
+#include <linux/ctype.h>
 
 #include "blk.h"
 
@@ -909,6 +910,86 @@ static int __init genhd_device_init(void)
 
 subsys_initcall(genhd_device_init);
 
+static ssize_t alias_name_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	ssize_t ret = 0;
+
+	if (disk->alias_name)
+		ret = snprintf(buf, ALIAS_NAME_LEN + 1, "%s\n",
+			       disk->alias_name);
+	return ret;
+}
+
+static ssize_t alias_name_store(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t count)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	struct disk_part_iter piter;
+	struct hd_struct *part;
+
+	char *new_alias_name;
+	char *envp[] = { NULL, NULL };
+	unsigned char c;
+	int idx;
+	ssize_t ret = count;
+
+	if (!count)
+		return -EINVAL;
+
+	if (count >= ALIAS_NAME_LEN) {
+		printk(KERN_ERR "alias_name: alias name is too long\n");
+		return -EINVAL;
+	}
+
+	/* Validation check */
+	for (idx = 0; idx < count; idx++) {
+		c = buf[idx];
+		if (idx == count - 1 && c == '\n')
+			break;
+		if (!isalnum(c) && c != '_' && c != '-') {
+			printk(KERN_ERR "alias_name: invalid alias name\n");
+			return -EINVAL;
+		}
+	}
+
+	if (disk->alias_name) {
+		printk(KERN_INFO "alias_name: %s is already assigned (%s)\n",
+		       disk->disk_name, disk->alias_name);
+		return -EINVAL;
+	}
+
+	new_alias_name = kasprintf(GFP_KERNEL, "%s", buf);
+	if (!new_alias_name)
+		return -ENOMEM;
+
+	if (new_alias_name[count - 1] == '\n')
+		new_alias_name[count - 1] = '\0';
+
+	envp[0] = kasprintf(GFP_KERNEL, "ALIAS=%s", new_alias_name);
+	if (!envp[0]) {
+		kfree(new_alias_name);
+		return -ENOMEM;
+	}
+
+	disk->alias_name = new_alias_name;
+	printk(KERN_INFO "alias_name: assigned %s to %s\n",
+	       new_alias_name, disk->disk_name);
+
+	kobject_uevent_env(&dev->kobj, KOBJ_ADD, envp);
+
+	/* announce possible partitions */
+	disk_part_iter_init(&piter, disk, 0);
+	while ((part = disk_part_iter_next(&piter)))
+		kobject_uevent_env(&part_to_dev(part)->kobj, KOBJ_ADD, envp);
+	disk_part_iter_exit(&piter);
+
+	kfree(envp[0]);
+	return ret;
+}
+
 static ssize_t disk_range_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
@@ -968,6 +1049,8 @@ static ssize_t disk_discard_alignment_show(struct device *dev,
 	return sprintf(buf, "%d\n", queue_discard_alignment(disk->queue));
 }
 
+static DEVICE_ATTR(alias_name, S_IRUGO|S_IWUSR, alias_name_show,
+		   alias_name_store);
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
@@ -990,6 +1073,7 @@ static struct device_attribute dev_attr_fail_timeout =
 #endif
 
 static struct attribute *disk_attrs[] = {
+	&dev_attr_alias_name.attr,
 	&dev_attr_range.attr,
 	&dev_attr_ext_range.attr,
 	&dev_attr_removable.attr,
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 300d758..e9ad85d 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -21,6 +21,8 @@
 #define dev_to_part(device)	container_of((device), struct hd_struct, __dev)
 #define disk_to_dev(disk)	(&(disk)->part0.__dev)
 #define part_to_dev(part)	(&((part)->__dev))
+#define alias_name(disk)	((disk)->alias_name ? (disk)->alias_name \
+						    : (disk)->disk_name)
 
 extern struct device_type part_type;
 extern struct kobject *block_depr;
@@ -58,6 +60,7 @@ enum {
 
 #define DISK_MAX_PARTS			256
 #define DISK_NAME_LEN			32
+#define ALIAS_NAME_LEN			256
 
 #include <linux/major.h>
 #include <linux/device.h>
@@ -162,6 +165,7 @@ struct gendisk {
                                          * disks that can't be partitioned. */
 
 	char disk_name[DISK_NAME_LEN];	/* name of major driver */
+	char *alias_name;		/* alias name of disk */
 	char *(*devnode)(struct gendisk *gd, mode_t *mode);
 
 	unsigned int events;		/* supported events */

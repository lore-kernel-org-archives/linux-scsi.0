From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Wed, 15 Jun 2011 17:16:28 +0900
Message-ID: <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, greg@kroah.com, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com, Nao Nishijima <nao.nishijima.xt@hitachi.com>
List-Id: linux-scsi@vger.kernel.org

Allow users to set the preferred name of device via sysfs interface.

(Exsample) sda -> foo
# echo foo > /sys/block/sda/preferred_name

Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Suggested-by: Jon Masters <jcm@redhat.com>
Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
---

 block/genhd.c          |   28 ++++++++++++++++++++++++++++
 include/linux/device.h |    9 +++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 95822ae..79b97f6 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -909,6 +909,31 @@ static int __init genhd_device_init(void)
 
 subsys_initcall(genhd_device_init);
 
+static ssize_t preferred_name_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PREFERRED_NAME_LEN, "%s\n", dev->preferred_name);
+}
+
+static ssize_t preferred_name_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+	if (!count)
+		return -EINVAL;
+	if (strlen(buf) >= PREFERRED_NAME_LEN) {
+		printk(KERN_ERR "preferred_name: %s is too long\n", buf);
+		return -EINVAL;
+	}
+	dev->preferred_name = kasprintf(GFP_KERNEL, "%s", buf);
+	if (!dev->preferred_name)
+		return -ENOMEM;
+	printk(KERN_INFO "preferred_name: assigned %s to %s\n",
+		buf, disk->disk_name);
+	return count;
+}
+
 static ssize_t disk_range_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
@@ -968,6 +993,8 @@ static ssize_t disk_discard_alignment_show(struct device *dev,
 	return sprintf(buf, "%d\n", queue_discard_alignment(disk->queue));
 }
 
+static DEVICE_ATTR(preferred_name, S_IRUGO|S_IWUSR, preferred_name_show,
+			preferred_name_store);
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
@@ -990,6 +1017,7 @@ static struct device_attribute dev_attr_fail_timeout =
 #endif
 
 static struct attribute *disk_attrs[] = {
+	&dev_attr_preferred_name.attr,
 	&dev_attr_range.attr,
 	&dev_attr_ext_range.attr,
 	&dev_attr_removable.attr,
diff --git a/include/linux/device.h b/include/linux/device.h
index c66111a..0486644 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -490,6 +490,9 @@ struct device_dma_parameters {
 	unsigned long segment_boundary_mask;
 };
 
+/* maximum length of preferred name */
+#define PREFERRED_NAME_LEN	256
+
 /**
  * struct device - The basic device structure
  * @parent:	The device's "parent" device, the device to which it is attached.
@@ -500,6 +503,7 @@ struct device_dma_parameters {
  * 		See the comment of the struct device_private for detail.
  * @kobj:	A top-level, abstract class from which other classes are derived.
  * @init_name:	Initial name of the device.
+ * @preferred_name: Preferred name of the device.
  * @type:	The type of device.
  * 		This identifies the device type and carries type-specific
  * 		information.
@@ -556,6 +560,7 @@ struct device {
 
 	struct kobject kobj;
 	const char		*init_name; /* initial name of the device */
+	const char	*preferred_name; /* preferred name of the device */
 	const struct device_type *type;
 
 	struct mutex		mutex;	/* mutex to synchronize calls to
@@ -608,6 +613,10 @@ struct device {
 
 static inline const char *dev_name(const struct device *dev)
 {
+	/* Use the preferred name when users set it */
+	if (dev->preferred_name)
+		return dev->preferred_name;
+
 	/* Use the init name until the kobject becomes available */
 	if (dev->init_name)
 		return dev->init_name;

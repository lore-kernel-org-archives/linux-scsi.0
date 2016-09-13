From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v6 4/9] char: rpmb: add device attributes
Date: Tue, 13 Sep 2016 16:22:59 +0300
Message-ID: <1473772984-17562-5-git-send-email-tomas.winkler@intel.com>
References: <1473772984-17562-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <1473772984-17562-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-mmc-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>
Cc: Avri Altman <avri.altman@gmail.com>, linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

Add attribute type that displays underlay storage type technology
EMMC, UFS, and attribute id, that displays underlay storage device id.
For EMMC this would be content of CID and for UFS serial number from
the device descriptor.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: resend
V3: set kernel version to 4.7
V4: update target date to Maj
V5: update date and kernel version
V6: 1. Add simulation device type
    2. Update date and kernel version
    3. Use binary attribute for id
    4. use simple sprintf instead of scnprintf
    5. Add more verbose documenation

 Documentation/ABI/testing/sysfs-class-rpmb | 27 +++++++++++
 drivers/char/rpmb/core.c                   | 72 ++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-rpmb b/Documentation/ABI/testing/sysfs-class-rpmb
index 9b840e660274..2fe100eb5aa7 100644
--- a/Documentation/ABI/testing/sysfs-class-rpmb
+++ b/Documentation/ABI/testing/sysfs-class-rpmb
@@ -18,3 +18,30 @@ Contact:	Tomas Winkler <tomas.winkler@intel.com>
 Description:
 		The /sys/class/rpmb/rpmbN directory is created for
 		each RPMB registered device.
+
+What:		/sys/class/rpmb/rpmbN/type
+Date:		Sep 2016
+KernelVersion:	4.9
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:
+		The /sys/class/rpmb/rpmbN/type file contains device
+		underlaying storage type technology: EMMC, UFS, SIM.
+
+What:		/sys/class/rpmb/rpmbN/id
+Date:		Sep 2016
+KernelVersion:	4.9
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:
+		The /sys/class/rpmb/rpmbN/id file contains unique device id
+		in a binary form as defined by underlying storage device.
+		In case of multiple RPMB devices a user can determine correct
+		device.
+		The content can be parsed according the storage device type.
+
+What:		/sys/class/rpmb/rpmbN/reliable_wr_cnt
+Date:		Sep 2016
+KernelVersion:	4.9
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:
+		The /sys/class/rpmb/rpmbN/reliable_wr_cnt file contains
+		number of blocks that can be reliable written in a single request.
diff --git a/drivers/char/rpmb/core.c b/drivers/char/rpmb/core.c
index 8cfbbb721538..f6b4cabb0982 100644
--- a/drivers/char/rpmb/core.c
+++ b/drivers/char/rpmb/core.c
@@ -338,6 +338,76 @@ struct rpmb_dev *rpmb_dev_find_by_device(struct device *parent)
 }
 EXPORT_SYMBOL_GPL(rpmb_dev_find_by_device);
 
+static ssize_t type_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	struct rpmb_dev *rdev = to_rpmb_dev(dev);
+	ssize_t ret;
+
+	switch (rdev->ops->type) {
+	case RPMB_TYPE_EMMC:
+		ret = sprintf(buf, "EMMC\n");
+		break;
+	case RPMB_TYPE_UFS:
+		ret = sprintf(buf, "UFS\n");
+		break;
+	case RPMB_TYPE_SIM:
+		ret = sprintf(buf, "SIM\n");
+		break;
+	default:
+		ret = sprintf(buf, "UNKNOWN\n");
+		break;
+	}
+
+	return ret;
+}
+static DEVICE_ATTR_RO(type);
+
+static ssize_t id_read(struct file *file, struct kobject *kobj,
+		       struct bin_attribute *attr, char *buf,
+		       loff_t off, size_t count)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct rpmb_dev *rdev = to_rpmb_dev(dev);
+	size_t sz = min_t(size_t, rdev->ops->dev_id_len, PAGE_SIZE);
+
+	if (!rdev->ops->dev_id)
+		return 0;
+
+	return memory_read_from_buffer(buf, count, &off, rdev->ops->dev_id, sz);
+}
+static BIN_ATTR_RO(id, 0);
+
+static ssize_t reliable_wr_cnt_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct rpmb_dev *rdev = to_rpmb_dev(dev);
+
+	return sprintf(buf, "%u\n", rdev->ops->reliable_wr_cnt);
+}
+static DEVICE_ATTR_RO(reliable_wr_cnt);
+
+static struct attribute *rpmb_attrs[] = {
+	&dev_attr_type.attr,
+	&dev_attr_reliable_wr_cnt.attr,
+	NULL,
+};
+
+static struct bin_attribute *rpmb_bin_attributes[] = {
+	&bin_attr_id,
+	NULL,
+};
+
+static struct attribute_group rpmb_attr_group = {
+	.attrs = rpmb_attrs,
+	.bin_attrs = rpmb_bin_attributes,
+};
+
+static const struct attribute_group *rpmb_attr_groups[] = {
+	&rpmb_attr_group,
+	NULL
+};
+
 /**
  * rpmb_dev_unregister - unregister RPMB partition from the RPMB subsystem
  *
@@ -407,6 +477,8 @@ struct rpmb_dev *rpmb_dev_register(struct device *dev,
 	dev_set_name(&rdev->dev, "rpmb%d", id);
 	rdev->dev.class = &rpmb_class;
 	rdev->dev.parent = dev;
+	rdev->dev.groups = rpmb_attr_groups;
+
 	ret = device_register(&rdev->dev);
 	if (ret)
 		goto exit;
-- 
2.7.4


From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v5 3/8] char: rpmb: add device attributes
Date: Mon, 18 Jul 2016 23:27:48 +0300
Message-ID: <1468873673-21776-4-git-send-email-tomas.winkler@intel.com>
References: <1468873673-21776-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <1468873673-21776-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-mmc-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
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
V5: adjust date and kernel version
 Documentation/ABI/testing/sysfs-class-rpmb | 24 ++++++++++++
 drivers/char/rpmb/core.c                   | 63 ++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-rpmb b/Documentation/ABI/testing/sysfs-class-rpmb
index 3ffcd2d1f683..7ca97d86bd97 100644
--- a/Documentation/ABI/testing/sysfs-class-rpmb
+++ b/Documentation/ABI/testing/sysfs-class-rpmb
@@ -18,3 +18,27 @@ Contact:	Tomas Winkler <tomas.winkler@intel.com>
 Description:
 		The /sys/class/rpmb/rpmbN directory is created for
 		each RPMB registered device
+
+What:		/sys/class/rpmb/rpmbN/id
+Date:		Aug 2016
+KernelVersion:	4.8
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:
+		The /sys/class/rpmb/rpmbN/id file contains device id
+		in a binary form
+
+What:		/sys/class/rpmb/rpmbN/type
+Date:		Aug 2016
+KernelVersion:	4.8
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:
+		The /sys/class/rpmb/rpmbN/type file contains device
+		underlay storage type technology: EMMC, UFS
+
+What:		/sys/class/rpmb/rpmbN/reliable_wr_cnt
+Date:		Aug 2016
+KernelVersion:	4.8
+Contact:	Tomas Winkler <tomas.winkler@intel.com>
+Description:
+		The /sys/class/rpmb/rpmbN/reliable_wr_cnt file contains
+		number of blocks that can be written in a single request
diff --git a/drivers/char/rpmb/core.c b/drivers/char/rpmb/core.c
index ff10cbb7b644..63271c7ed072 100644
--- a/drivers/char/rpmb/core.c
+++ b/drivers/char/rpmb/core.c
@@ -308,6 +308,67 @@ struct rpmb_dev *rpmb_dev_find_by_device(struct device *parent)
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
+		ret = scnprintf(buf, PAGE_SIZE, "EMMC\n");
+		break;
+	case RPMB_TYPE_UFS:
+		ret = scnprintf(buf, PAGE_SIZE, "UFS\n");
+		break;
+	default:
+		ret = scnprintf(buf, PAGE_SIZE, "UNKNOWN\n");
+		break;
+	}
+
+	return ret;
+}
+static DEVICE_ATTR_RO(type);
+
+static ssize_t id_show(struct device *dev,
+		       struct device_attribute *attr, char *buf)
+{
+	struct rpmb_dev *rdev = to_rpmb_dev(dev);
+	size_t sz = min_t(size_t, rdev->ops->dev_id_len, PAGE_SIZE);
+
+	if (!rdev->ops->dev_id)
+		return 0;
+
+	memcpy(buf, rdev->ops->dev_id, sz);
+	return sz;
+}
+static DEVICE_ATTR_RO(id);
+
+static ssize_t reliable_wr_cnt_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct rpmb_dev *rdev = to_rpmb_dev(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", rdev->ops->reliable_wr_cnt);
+}
+static DEVICE_ATTR_RO(reliable_wr_cnt);
+
+static struct attribute *rpmb_attrs[] = {
+	&dev_attr_type.attr,
+	&dev_attr_id.attr,
+	&dev_attr_reliable_wr_cnt.attr,
+	NULL,
+};
+
+static struct attribute_group rpmb_attr_group = {
+	.attrs = rpmb_attrs,
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
@@ -377,6 +438,8 @@ struct rpmb_dev *rpmb_dev_register(struct device *dev,
 	dev_set_name(&rdev->dev, "rpmb%d", id);
 	rdev->dev.class = &rpmb_class;
 	rdev->dev.parent = dev;
+	rdev->dev.groups = rpmb_attr_groups;
+
 	ret = device_register(&rdev->dev);
 	if (ret)
 		goto exit;
-- 
2.5.5


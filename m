From: Constantin Baranov <const@mimas.ru>
Subject: [PATCH] hwmon: Driver for SCSI/ATA temperature sensors
Date: Sun, 13 Sep 2009 04:01:04 +0500
Message-ID: <20090913040104.ab1d0b69.const@mimas.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:33755 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZILXBP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Sep 2009 19:01:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

The scsitemp module attaches a device to each SCSI device
and registers it in hwmon. Currently the only method of
reading temperature is ATA SMART. Adding support of the
pure SCSI methods is provided.

Signed-off-by: Constantin Baranov <const@mimas.ru>
---
 drivers/hwmon/Kconfig    |   10 ++
 drivers/hwmon/Makefile   |    1 +
 drivers/hwmon/scsitemp.c |  264 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 275 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hwmon/scsitemp.c

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 2d50166..fb9fd9d 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -692,6 +692,16 @@ config SENSORS_PCF8591
 	  These devices are hard to detect and rarely found on mainstream
 	  hardware.  If unsure, say N.
 
+config SENSORS_SCSITEMP
+	tristate "SCSI/ATA drive temperature sensors"
+	depends on SCSI
+	help
+	  If you say yes you get support for SCSI/ATA accessible temperature
+	  sensors found on most modern hard drives.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called scsitemp.
+
 config SENSORS_SHT15
 	tristate "Sensiron humidity and temperature sensors. SHT15 and compat."
 	depends on GENERIC_GPIO
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index b793dce..8c4c870 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_SENSORS_MAX6650)	+= max6650.o
 obj-$(CONFIG_SENSORS_PC87360)	+= pc87360.o
 obj-$(CONFIG_SENSORS_PC87427)	+= pc87427.o
 obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
+obj-$(CONFIG_SENSORS_SCSITEMP)	+= scsitemp.o
 obj-$(CONFIG_SENSORS_SHT15)	+= sht15.o
 obj-$(CONFIG_SENSORS_SIS5595)	+= sis5595.o
 obj-$(CONFIG_SENSORS_SMSC47B397)+= smsc47b397.o
diff --git a/drivers/hwmon/scsitemp.c b/drivers/hwmon/scsitemp.c
new file mode 100644
index 0000000..f50938a
--- /dev/null
+++ b/drivers/hwmon/scsitemp.c
@@ -0,0 +1,264 @@
+/*
+ * scsitemp.c - SCSI/ATA accessible temperature sensors
+ *
+ * TODO:
+ * - LOG SENSE Temperature log page method
+ * - LOG SENSE Informational Exceptions log page method
+ */
+
+#include <linux/ata.h>
+#include <linux/device.h>
+#include <linux/hwmon.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_driver.h>
+
+MODULE_AUTHOR("Constantin Baranov <const@mimas.ru>");
+MODULE_DESCRIPTION("SCSI/ATA temperature monitor");
+MODULE_VERSION("0.1");
+MODULE_LICENSE("GPL");
+
+struct scsitemp_method;
+
+struct scsitemp {
+	struct scsi_device *sdev;
+	struct device *hwmon;
+	const struct scsitemp_method *method;
+	int id;
+	struct device dev;
+};
+
+struct scsitemp_method {
+	const char *name;
+	int (*temp_input)(struct scsitemp *st, long *temp);
+};
+
+static int scsitemp_execute(struct scsitemp *st, const u8 *cdb,
+			void *buffer, unsigned *bufflen)
+{
+	int result;
+	int resid;
+
+	result = scsi_execute(st->sdev, cdb, DMA_FROM_DEVICE,
+			buffer, *bufflen, NULL, 1 * HZ, 0, 0, &resid);
+
+	if (result)
+		return -EIO;
+
+	*bufflen -= resid;
+	return 0;
+}
+
+static int scsitemp_ata_temp_input(struct scsitemp *st, long *temp)
+{
+	static const u8 cdb[16] = {
+		ATA_16,			0x08,	0x0e,			0x00,
+		ATA_SMART_READ_VALUES,	0x00,	0x01,			0x00,
+		0x00,			0x00,	ATA_SMART_LBAM_PASS,	0x00,
+		ATA_SMART_LBAH_PASS,	0x00,	ATA_CMD_SMART,		0x00,
+	};
+
+	u8 values[512];
+	unsigned len = sizeof(values);
+	unsigned nattrs, i;
+	int err;
+
+	err = scsitemp_execute(st, cdb, values, &len);
+	if (err)
+		goto out;
+
+	err = -ENXIO;
+	nattrs = min_t(unsigned, 30, len / 12);
+	for (i = 0; i < nattrs; i++) {
+		u8 *attr = values + i * 12;
+
+		if (attr[2] == 194) {
+			*temp = attr[7] * 1000;
+			err = 0;
+			break;
+		}
+	}
+
+out:
+	return err;
+}
+
+static const struct scsitemp_method scsitemp_methods[] = {
+	{"ATA SMART", scsitemp_ata_temp_input},
+	{}
+};
+
+static void scsitemp_assign_method(struct scsitemp *st)
+{
+	const struct scsitemp_method *m;
+
+	for (m = scsitemp_methods; m->temp_input; m++) {
+		long temp;
+
+		if (m->temp_input(st, &temp) == 0) {
+			st->method = m;
+			return;
+		}
+	}
+}
+
+static ssize_t name_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n", dev->class->name);
+}
+
+static ssize_t temp1_input_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct scsitemp *st = dev_get_drvdata(dev);
+	long temp;
+	int err;
+
+	err = st->method->temp_input(st, &temp);
+	if (err)
+		return err;
+
+	return sprintf(buf, "%ld\n", temp);
+}
+
+static ssize_t temp1_label_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct scsitemp *st = dev_get_drvdata(dev);
+	struct scsi_device *sdev = st->sdev;
+
+	return sprintf(buf, "%.8s %.16s\n", sdev->vendor, sdev->model);
+}
+
+static struct device_attribute scsitemp_attrs[] = {
+	__ATTR_RO(name),
+	__ATTR_RO(temp1_input),
+	__ATTR_RO(temp1_label),
+	__ATTR_NULL,
+};
+
+static struct class scsitemp_class;
+
+static int scsitemp_add(struct device *dev, struct class_interface *intf)
+{
+	struct device *devp = dev->parent;
+	struct scsi_device *sdev = to_scsi_device(devp);
+	struct scsitemp *st;
+	int err;
+
+	st = kzalloc(sizeof(*st), GFP_KERNEL);
+	if (st == NULL) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	st->sdev = sdev;
+	scsitemp_assign_method(st);
+	if (!st->method) {
+		err = -ENODEV;
+		goto out_st;
+	}
+
+	dev_set_name(&st->dev, "%s-%s", scsitemp_class.name, dev_name(devp));
+	st->dev.class = &scsitemp_class;
+	st->dev.parent = devp;
+	dev_set_drvdata(&st->dev, st);
+
+	err = device_register(&st->dev);
+	if (err)
+		goto out_st;
+
+	st->hwmon = hwmon_device_register(&st->dev);
+	if (IS_ERR(st->hwmon)) {
+		err = PTR_ERR(st->hwmon);
+		device_unregister(&st->dev);
+		goto out;
+	}
+
+	dev_info(devp, "found temperature sensor using %s method",
+		st->method->name);
+
+	return 0;
+
+out_st:
+	kfree(st);
+out:
+	return err;
+}
+
+static void scsitemp_device_release(struct device *dev)
+{
+	struct scsitemp *st = dev_get_drvdata(dev);
+
+	kfree(st);
+}
+
+static int scsitemp_match(struct device *dev, void *sdev)
+{
+	struct scsitemp *st = dev_get_drvdata(dev);
+
+	return st->sdev == (struct scsi_device *)sdev;
+}
+
+static void scsitemp_remove(struct device *dev, struct class_interface *intf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev->parent);
+	struct device *stdev;
+	struct scsitemp *st;
+
+	stdev = class_find_device(&scsitemp_class, NULL,
+				sdev, scsitemp_match);
+
+	if (!stdev)
+		return;
+
+	st = dev_get_drvdata(stdev);
+	hwmon_device_unregister(st->hwmon);
+	device_unregister(&st->dev);
+	put_device(&st->dev);
+}
+
+static struct class scsitemp_class = {
+	.name = KBUILD_MODNAME,
+	.owner = THIS_MODULE,
+	.dev_attrs = scsitemp_attrs,
+	.dev_release = scsitemp_device_release,
+};
+
+static struct class_interface scsitemp_interface = {
+	.add_dev = scsitemp_add,
+	.remove_dev = scsitemp_remove,
+};
+
+static int __init scsitemp_init(void)
+{
+	int err;
+
+	err = class_register(&scsitemp_class);
+	if (err)
+		goto out;
+
+	err = scsi_register_interface(&scsitemp_interface);
+	if (err)
+		goto out_class;
+
+	return 0;
+
+out_class:
+	class_unregister(&scsitemp_class);
+out:
+	return err;
+}
+
+static void __exit scsitemp_exit(void)
+{
+	scsi_unregister_interface(&scsitemp_interface);
+	class_unregister(&scsitemp_class);
+}
+
+module_init(scsitemp_init);
+module_exit(scsitemp_exit);
-- 
1.6.4.2


From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 07/12] ics932s401: New driver
Date: Mon, 06 Oct 2008 18:18:59 -0700
Message-ID: <20081007011859.12701.8929.stgit@elm3a70.beaverton.ibm.com>
References: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50894 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbYJGBTD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2008 21:19:03 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m971J2kS017303
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:19:02 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m971J26F284834
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:19:02 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m971J0l3022915
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:19:01 -0400
In-Reply-To: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-scsi@vger.kernel.org>, lm-sensors <lm-sensors@lm-sensors.org>


Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 Documentation/hwmon/ics932s401 |   31 ++
 drivers/hwmon/Kconfig          |   10 +
 drivers/hwmon/Makefile         |    1 
 drivers/hwmon/ics932s401.c     |  516 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 558 insertions(+), 0 deletions(-)

diff --git a/Documentation/hwmon/ics932s401 b/Documentation/hwmon/ics932s401
new file mode 100644
index 0000000..c2e2c4a
--- /dev/null
+++ b/Documentation/hwmon/ics932s401
@@ -0,0 +1,31 @@
+Kernel driver ics932s401
+======================
+
+Supported chips:
+  * Analog Devices ICS932S401
+    Prefix: 'ics932s401'
+    Addresses scanned: I2C 0x69
+    Datasheet: Publicly available at the Integrated Circuits website
+
+Author: Darrick J. Wong
+
+Description
+-----------
+
+This driver implements support for the Integrated Circuits ICS932S401 chip family.
+
+This chip has 4 clock outputs--a base clock for the CPU (which is likely
+multiplied to get the real CPU clock), a system clock, a PCI clock, a USB
+clock, and a reference clock.  The driver reports selected and actual
+frequency.  If spread spectrum mode is enabled, the driver also reports by what
+percent the clock signal is being spread, which should be between 0 and -0.5%.
+All frequencies are reported in KHz.
+
+The ICS932S401 monitors all inputs continuously. The driver will not read
+the registers more often than once every other second.
+
+Special Features
+----------------
+
+The clocks could be reprogrammed to increase system speed.  I will not help you
+do this, as you risk damaging your system!
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 0341b29..649a32a 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -394,6 +394,16 @@ config SENSORS_IBMPEX
 	  This driver can also be built as a module.  If so, the module
 	  will be called ibmpex.
 
+config SENSORS_ICS932S401
+	tristate "Integrated Circuits ICS932S401"
+	depends on I2C && EXPERIMENTAL
+	help
+	  If you say yes here you get support for the Integrated Circuits
+	  ICS932S401 clock monitoring chips.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called ics932s401.
+
 config SENSORS_IT87
 	tristate "ITE IT87xx and compatibles"
 	select HWMON_VID
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 836b277..487a3c6 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_SENSORS_HDAPS)	+= hdaps.o
 obj-$(CONFIG_SENSORS_I5K_AMB)	+= i5k_amb.o
 obj-$(CONFIG_SENSORS_IBMAEM)	+= ibmaem.o
 obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
+obj-$(CONFIG_SENSORS_ICS932S401)	+= ics932s401.o
 obj-$(CONFIG_SENSORS_IT87)	+= it87.o
 obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
 obj-$(CONFIG_SENSORS_LM63)	+= lm63.o
diff --git a/drivers/hwmon/ics932s401.c b/drivers/hwmon/ics932s401.c
new file mode 100644
index 0000000..492c1d7
--- /dev/null
+++ b/drivers/hwmon/ics932s401.c
@@ -0,0 +1,516 @@
+/*
+ * A hwmon driver for the Integrated Circuits ICS932S401
+ * Copyright (C) 2008 IBM
+ *
+ * Author: Darrick J. Wong <djwong@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/jiffies.h>
+#include <linux/i2c.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+#include <linux/log2.h>
+
+/* Addresses to scan */
+static const unsigned short normal_i2c[] = { 0x69, I2C_CLIENT_END };
+
+/* Insmod parameters */
+I2C_CLIENT_INSMOD_1(ics932s401);
+
+/* ICS932S401 registers */
+#define ICS932S401_REG_CFG2			0x01
+#define 	ICS932S401_CFG1_SPREAD		0x01
+#define ICS932S401_REG_CFG7			0x06
+#define		ICS932S401_FS_MASK		0x07
+#define	ICS932S401_REG_VENDOR_REV		0x07
+#define		ICS932S401_VENDOR		1
+#define		ICS932S401_VENDOR_MASK		0x0F
+#define		ICS932S401_REV			4
+#define		ICS932S401_REV_SHIFT		4
+#define ICS932S401_REG_DEVICE			0x09
+#define		ICS932S401_DEVICE		11
+#define	ICS932S401_REG_CTRL			0x0A
+#define		ICS932S401_MN_ENABLED		0x80
+#define		ICS932S401_CPU_ALT		0x04
+#define		ICS932S401_SRC_ALT		0x08
+#define ICS932S401_REG_CPU_M_CTRL		0x0B
+#define		ICS932S401_M_MASK		0x3F
+#define	ICS932S401_REG_CPU_N_CTRL		0x0C
+#define	ICS932S401_REG_CPU_SPREAD1		0x0D
+#define ICS932S401_REG_CPU_SPREAD2		0x0E
+#define		ICS932S401_SPREAD_MASK		0x7FFF
+#define ICS932S401_REG_SRC_M_CTRL		0x0F
+#define ICS932S401_REG_SRC_N_CTRL		0x10
+#define	ICS932S401_REG_SRC_SPREAD1		0x11
+#define ICS932S401_REG_SRC_SPREAD2		0x12
+#define ICS932S401_REG_CPU_DIVISOR		0x13
+#define 	ICS932S401_CPU_DIVISOR_SHIFT	4
+#define ICS932S401_REG_PCISRC_DIVISOR		0x14
+#define		ICS932S401_SRC_DIVISOR_MASK	0x0F
+#define		ICS932S401_PCI_DIVISOR_SHIFT	4
+
+/* Base clock is 14.318MHz */
+#define BASE_CLOCK				14318
+
+#define NUM_REGS				21
+#define NUM_MIRRORED_REGS			15
+
+static int regs_to_copy[NUM_MIRRORED_REGS] = {
+	ICS932S401_REG_CFG2,
+	ICS932S401_REG_CFG7,
+	ICS932S401_REG_VENDOR_REV,
+	ICS932S401_REG_DEVICE,
+	ICS932S401_REG_CTRL,
+	ICS932S401_REG_CPU_M_CTRL,
+	ICS932S401_REG_CPU_N_CTRL,
+	ICS932S401_REG_CPU_SPREAD1,
+	ICS932S401_REG_CPU_SPREAD2,
+	ICS932S401_REG_SRC_M_CTRL,
+	ICS932S401_REG_SRC_N_CTRL,
+	ICS932S401_REG_SRC_SPREAD1,
+	ICS932S401_REG_SRC_SPREAD2,
+	ICS932S401_REG_CPU_DIVISOR,
+	ICS932S401_REG_PCISRC_DIVISOR,
+};
+
+/* How often do we reread sensors values? (In jiffies) */
+#define SENSOR_REFRESH_INTERVAL	(2 * HZ)
+
+/* How often do we reread sensor limit values? (In jiffies) */
+#define LIMIT_REFRESH_INTERVAL	(60 * HZ)
+
+struct ics932s401_data {
+	struct device		*hwmon_dev;
+	struct attribute_group	attrs;
+	struct mutex		lock;
+	char			sensors_valid;
+	unsigned long		sensors_last_updated;	/* In jiffies */
+
+	u8			regs[NUM_REGS];
+};
+
+static int ics932s401_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id);
+static int ics932s401_detect(struct i2c_client *client, int kind,
+			  struct i2c_board_info *info);
+static int ics932s401_remove(struct i2c_client *client);
+
+static const struct i2c_device_id ics932s401_id[] = {
+	{ "ics932s401", ics932s401 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ics932s401_id);
+
+static struct i2c_driver ics932s401_driver = {
+	.class		= I2C_CLASS_HWMON,
+	.driver = {
+		.name	= "ics932s401",
+	},
+	.probe		= ics932s401_probe,
+	.remove		= ics932s401_remove,
+	.id_table	= ics932s401_id,
+	.detect		= ics932s401_detect,
+	.address_data	= &addr_data,
+};
+
+static struct ics932s401_data *ics932s401_update_device(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct ics932s401_data *data = i2c_get_clientdata(client);
+	unsigned long local_jiffies = jiffies;
+	int i, temp;
+
+	mutex_lock(&data->lock);
+	if (time_before(local_jiffies, data->sensors_last_updated +
+		SENSOR_REFRESH_INTERVAL)
+		&& data->sensors_valid)
+		goto out;
+
+	/*
+	 * Each register must be read as a word and then right shifted 8 bits.
+	 * Not really sure why this is; setting the "byte count programming"
+	 * register to 1 does not fix this problem.
+	 */
+	for (i = 0; i < NUM_MIRRORED_REGS; i++) {
+		temp = i2c_smbus_read_word_data(client, regs_to_copy[i]);
+		data->regs[regs_to_copy[i]] = temp >> 8;
+	}
+
+	data->sensors_last_updated = local_jiffies;
+	data->sensors_valid = 1;
+
+out:
+	mutex_unlock(&data->lock);
+	return data;
+}
+
+static ssize_t show_spread_enabled(struct device *dev,
+				   struct device_attribute *devattr,
+				   char *buf)
+{
+	struct ics932s401_data *data = ics932s401_update_device(dev);
+
+	if (data->regs[ICS932S401_REG_CFG2] & ICS932S401_CFG1_SPREAD)
+		return sprintf(buf, "1\n");
+
+	return sprintf(buf, "0\n");
+}
+
+/* bit to cpu khz map */
+static const int fs_speeds[] = {
+	266666,
+	133333,
+	200000,
+	166666,
+	333333,
+	100000,
+	400000,
+	0,
+};
+
+/* clock divisor map */
+static const int divisors[] = {2, 3, 5, 15, 4, 6, 10, 30, 8, 12, 20, 60, 16,
+			       24, 40, 120};
+
+/* Calculate CPU frequency from the M/N registers. */
+static int calculate_cpu_freq(struct ics932s401_data *data)
+{
+	int m, n, freq;
+
+	m = data->regs[ICS932S401_REG_CPU_M_CTRL] & ICS932S401_M_MASK;
+	n = data->regs[ICS932S401_REG_CPU_N_CTRL];
+
+	/* Pull in bits 8 & 9 from the M register */
+	n |= ((int)data->regs[ICS932S401_REG_CPU_M_CTRL] & 0x80) << 1;
+	n |= ((int)data->regs[ICS932S401_REG_CPU_M_CTRL] & 0x40) << 3;
+
+	freq = BASE_CLOCK * (n + 8) / (m + 2);
+	freq /= divisors[data->regs[ICS932S401_REG_CPU_DIVISOR] >>
+			 ICS932S401_CPU_DIVISOR_SHIFT];
+
+	return freq;
+}
+
+static ssize_t show_cpu_clock(struct device *dev,
+			      struct device_attribute *devattr,
+			      char *buf)
+{
+	struct ics932s401_data *data = ics932s401_update_device(dev);
+
+	return sprintf(buf, "%d\n", calculate_cpu_freq(data));
+}
+
+static ssize_t show_cpu_clock_sel(struct device *dev,
+				  struct device_attribute *devattr,
+				  char *buf)
+{
+	struct ics932s401_data *data = ics932s401_update_device(dev);
+	int freq;
+
+	if (data->regs[ICS932S401_REG_CTRL] & ICS932S401_MN_ENABLED)
+		freq = calculate_cpu_freq(data);
+	else {
+		/* Freq is neatly wrapped up for us */
+		int fid = data->regs[ICS932S401_REG_CFG7] & ICS932S401_FS_MASK;
+		freq = fs_speeds[fid];
+		if (data->regs[ICS932S401_REG_CTRL] & ICS932S401_CPU_ALT) {
+			switch (freq) {
+			case 166666:
+				freq = 160000;
+				break;
+			case 333333:
+				freq = 320000;
+				break;
+			}
+		}
+	}
+
+	return sprintf(buf, "%d\n", freq);
+}
+
+/* Calculate SRC frequency from the M/N registers. */
+static int calculate_src_freq(struct ics932s401_data *data)
+{
+	int m, n, freq;
+
+	m = data->regs[ICS932S401_REG_SRC_M_CTRL] & ICS932S401_M_MASK;
+	n = data->regs[ICS932S401_REG_SRC_N_CTRL];
+
+	/* Pull in bits 8 & 9 from the M register */
+	n |= ((int)data->regs[ICS932S401_REG_SRC_M_CTRL] & 0x80) << 1;
+	n |= ((int)data->regs[ICS932S401_REG_SRC_M_CTRL] & 0x40) << 3;
+
+	freq = BASE_CLOCK * (n + 8) / (m + 2);
+	freq /= divisors[data->regs[ICS932S401_REG_PCISRC_DIVISOR] &
+			 ICS932S401_SRC_DIVISOR_MASK];
+
+	return freq;
+}
+
+static ssize_t show_src_clock(struct device *dev,
+			      struct device_attribute *devattr,
+			      char *buf)
+{
+	struct ics932s401_data *data = ics932s401_update_device(dev);
+
+	return sprintf(buf, "%d\n", calculate_src_freq(data));
+}
+
+static ssize_t show_src_clock_sel(struct device *dev,
+				  struct device_attribute *devattr,
+				  char *buf)
+{
+	struct ics932s401_data *data = ics932s401_update_device(dev);
+	int freq;
+
+	if (data->regs[ICS932S401_REG_CTRL] & ICS932S401_MN_ENABLED)
+		freq = calculate_src_freq(data);
+	else
+		/* Freq is neatly wrapped up for us */
+		if (data->regs[ICS932S401_REG_CTRL] & ICS932S401_CPU_ALT &&
+		    data->regs[ICS932S401_REG_CTRL] & ICS932S401_SRC_ALT)
+			freq = 96000;
+		else
+			freq = 100000;
+
+	return sprintf(buf, "%d\n", freq);
+}
+
+/* Calculate PCI frequency from the SRC M/N registers. */
+static int calculate_pci_freq(struct ics932s401_data *data)
+{
+	int m, n, freq;
+
+	m = data->regs[ICS932S401_REG_SRC_M_CTRL] & ICS932S401_M_MASK;
+	n = data->regs[ICS932S401_REG_SRC_N_CTRL];
+
+	/* Pull in bits 8 & 9 from the M register */
+	n |= ((int)data->regs[ICS932S401_REG_SRC_M_CTRL] & 0x80) << 1;
+	n |= ((int)data->regs[ICS932S401_REG_SRC_M_CTRL] & 0x40) << 3;
+
+	freq = BASE_CLOCK * (n + 8) / (m + 2);
+	freq /= divisors[data->regs[ICS932S401_REG_PCISRC_DIVISOR] >>
+			 ICS932S401_PCI_DIVISOR_SHIFT];
+
+	return freq;
+}
+
+static ssize_t show_pci_clock(struct device *dev,
+			      struct device_attribute *devattr,
+			      char *buf)
+{
+	struct ics932s401_data *data = ics932s401_update_device(dev);
+
+	return sprintf(buf, "%d\n", calculate_pci_freq(data));
+}
+
+static ssize_t show_pci_clock_sel(struct device *dev,
+				  struct device_attribute *devattr,
+				  char *buf)
+{
+	struct ics932s401_data *data = ics932s401_update_device(dev);
+	int freq;
+
+	if (data->regs[ICS932S401_REG_CTRL] & ICS932S401_MN_ENABLED)
+		freq = calculate_pci_freq(data);
+	else
+		freq = 33333;
+
+	return sprintf(buf, "%d\n", freq);
+}
+
+static ssize_t show_value(struct device *dev,
+			  struct device_attribute *devattr,
+			  char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+
+	return sprintf(buf, "%d\n", attr->index);
+}
+
+static ssize_t show_spread(struct device *dev,
+			   struct device_attribute *devattr,
+			   char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct ics932s401_data *data = ics932s401_update_device(dev);
+	int reg;
+	unsigned long val;
+
+	if (!(data->regs[ICS932S401_REG_CFG2] & ICS932S401_CFG1_SPREAD))
+		return sprintf(buf, "0%%\n");
+
+	/* 1 = src, 0 = cpu */
+	if (attr->index)
+		reg = ICS932S401_REG_SRC_SPREAD1;
+	else
+		reg = ICS932S401_REG_CPU_SPREAD1;
+
+	val = data->regs[reg] | (data->regs[reg + 1] << 8);
+	val &= ICS932S401_SPREAD_MASK;
+
+	/* Scale 0..2^14 to -0.5. */
+	val = 500000 * val / 16384;
+	return sprintf(buf, "-0.%lu%%\n", val);
+}
+
+static SENSOR_DEVICE_ATTR(spread_enabled, S_IRUGO, show_spread_enabled,
+			  NULL, 0);
+static SENSOR_DEVICE_ATTR(cpu_clock_selection, S_IRUGO, show_cpu_clock_sel,
+			  NULL, 0);
+static SENSOR_DEVICE_ATTR(cpu_clock, S_IRUGO, show_cpu_clock, NULL, 0);
+static SENSOR_DEVICE_ATTR(src_clock_selection, S_IRUGO, show_src_clock_sel,
+			  NULL, 0);
+static SENSOR_DEVICE_ATTR(src_clock, S_IRUGO, show_src_clock, NULL, 0);
+static SENSOR_DEVICE_ATTR(pci_clock_selection, S_IRUGO, show_pci_clock_sel,
+			  NULL, 0);
+static SENSOR_DEVICE_ATTR(pci_clock, S_IRUGO, show_pci_clock, NULL, 0);
+static SENSOR_DEVICE_ATTR(usb_clock, S_IRUGO, show_value, NULL, 48000);
+static SENSOR_DEVICE_ATTR(ref_clock, S_IRUGO, show_value, NULL, BASE_CLOCK);
+static SENSOR_DEVICE_ATTR(cpu_spread, S_IRUGO, show_spread, NULL, 0);
+static SENSOR_DEVICE_ATTR(src_spread, S_IRUGO, show_spread, NULL, 1);
+
+static struct attribute *ics932s401_attr[] =
+{
+	&sensor_dev_attr_spread_enabled.dev_attr.attr,
+	&sensor_dev_attr_cpu_clock_selection.dev_attr.attr,
+	&sensor_dev_attr_cpu_clock.dev_attr.attr,
+	&sensor_dev_attr_src_clock_selection.dev_attr.attr,
+	&sensor_dev_attr_src_clock.dev_attr.attr,
+	&sensor_dev_attr_pci_clock_selection.dev_attr.attr,
+	&sensor_dev_attr_pci_clock.dev_attr.attr,
+	&sensor_dev_attr_usb_clock.dev_attr.attr,
+	&sensor_dev_attr_ref_clock.dev_attr.attr,
+	&sensor_dev_attr_cpu_spread.dev_attr.attr,
+	&sensor_dev_attr_src_spread.dev_attr.attr,
+	NULL
+};
+
+/* Return 0 if detection is successful, -ENODEV otherwise */
+static int ics932s401_detect(struct i2c_client *client, int kind,
+			  struct i2c_board_info *info)
+{
+	struct i2c_adapter *adapter = client->adapter;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -ENODEV;
+
+	if (kind <= 0) {
+		int vendor, device, revision;
+
+		vendor = i2c_smbus_read_word_data(client,
+						  ICS932S401_REG_VENDOR_REV);
+		vendor >>= 8;
+		revision = vendor >> ICS932S401_REV_SHIFT;
+		vendor &= ICS932S401_VENDOR_MASK;
+		if (vendor != ICS932S401_VENDOR)
+			return -ENODEV;
+
+		device = i2c_smbus_read_word_data(client,
+						  ICS932S401_REG_DEVICE);
+		device >>= 8;
+		if (device != ICS932S401_DEVICE)
+			return -ENODEV;
+
+		if (revision != ICS932S401_REV)
+			dev_info(&adapter->dev, "Unknown revision %d\n",
+				 revision);
+	} else
+		dev_dbg(&adapter->dev, "detection forced\n");
+
+	strlcpy(info->type, "ics932s401", I2C_NAME_SIZE);
+
+	return 0;
+}
+
+static int ics932s401_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct ics932s401_data *data;
+	int err;
+
+	data = kzalloc(sizeof(struct ics932s401_data), GFP_KERNEL);
+	if (!data) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	i2c_set_clientdata(client, data);
+	mutex_init(&data->lock);
+
+	dev_info(&client->dev, "%s chip found\n", client->name);
+
+	/* Register sysfs hooks */
+	data->attrs.attrs = ics932s401_attr;
+	err = sysfs_create_group(&client->dev.kobj, &data->attrs);
+	if (err)
+		goto exit_free;
+
+	data->hwmon_dev = hwmon_device_register(&client->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
+		goto exit_remove;
+	}
+
+	return 0;
+
+exit_remove:
+	sysfs_remove_group(&client->dev.kobj, &data->attrs);
+exit_free:
+	kfree(data);
+exit:
+	return err;
+}
+
+static int ics932s401_remove(struct i2c_client *client)
+{
+	struct ics932s401_data *data = i2c_get_clientdata(client);
+
+	hwmon_device_unregister(data->hwmon_dev);
+	sysfs_remove_group(&client->dev.kobj, &data->attrs);
+	kfree(data);
+	return 0;
+}
+
+static int __init ics932s401_init(void)
+{
+	return i2c_add_driver(&ics932s401_driver);
+}
+
+static void __exit ics932s401_exit(void)
+{
+	i2c_del_driver(&ics932s401_driver);
+}
+
+MODULE_AUTHOR("Darrick J. Wong <djwong@us.ibm.com>");
+MODULE_DESCRIPTION("ICS932S401 driver");
+MODULE_LICENSE("GPL");
+
+module_init(ics932s401_init);
+module_exit(ics932s401_exit);
+
+/* IBM IntelliStation Z30 */
+MODULE_ALIAS("dmi:bvnIBM:*:rn9228:*");
+MODULE_ALIAS("dmi:bvnIBM:*:rn9232:*");
+
+/* IBM x3650/x3550 */
+MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3650*");
+MODULE_ALIAS("dmi:bvnIBM:*:pnIBMSystemx3550*");


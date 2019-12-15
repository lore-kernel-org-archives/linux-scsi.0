Return-Path: <SRS0=xzXz=2F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3619CC43603
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 17:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E887C206E0
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Dec 2019 17:45:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r1G5mZBN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfLORpf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Dec 2019 12:45:35 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46987 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfLORpd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Dec 2019 12:45:33 -0500
Received: by mail-pl1-f195.google.com with SMTP id k20so3436829pll.13;
        Sun, 15 Dec 2019 09:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3a+ymkxK/0c20p4LO3e8z23pUDi+6DFvM+EYouliZE4=;
        b=r1G5mZBN3kNReMa/Mil0bYOQ19VzGqXBKZF9yDA3oq12UgMtmSL/noUaF9Qndpq55y
         iQZP6BvR9AjPWIw53yx59PXdYp3LAc7XpzeQgu4swR4yUZGqvSO5BrqbAv23/0lWg4cS
         0ydz3ZW0k9l0LwsTgYUt5Cyjj0T1boE3NGbL2PORRwdHfEq/ZlaU2kwqSVjqrV3MlTHx
         MjAoF4hJTAldehsBW6rHTVjfG+1eZj+/CoJl/KLRmVScKtTu/3QeV8EFhZkoWiPzKDi/
         FtFoHYJWrWvJtE23Xt/pCK63lAgboOIEO6pPm0j04vaWN1g1uaeif/gMAMd7UnpqGmBn
         Qn2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=3a+ymkxK/0c20p4LO3e8z23pUDi+6DFvM+EYouliZE4=;
        b=uimP0yNiodwAbrOxMCTHphODCHCjdiH0OoJo42zu5cqbyoUOXgzow9afrBTWRdMApj
         w7Je+Ud9Wjl5nJJwFJyva5XbLkTSR9UokAndUo0pvVxcmUM8/aA/eEWGrWEFQOi6e5qg
         4HaabrI7WbuJA4RnzXnXKRk/Cf0CvmufQBZxOJdFLAuPS5Ls0dvaycxN6FJAUqXjl+Gu
         dHoEb5sFSV9m2QmvLfn2R4zewoCcw7W5056XOTDh1D/JF4Au8Hh1/sJ2zo+bEczd/qe8
         ygyggM2ZQ1u2SfgzymrmzfHyvjH/s/UgdUxCXrnBQp79F71ANs5ewQI0NQjDglbGngJl
         5FpQ==
X-Gm-Message-State: APjAAAX6pCLHEsRUzWzZndl1IUd2gn6qeByp+jkFsYJw953EuhT415r1
        v7U5REeYEQsEtERWbKS5DtPALvAQ
X-Google-Smtp-Source: APXvYqyephaBywcExAc5rAiFKPFLcHJPkWa5a3Xo8fXk8EKicStMCevw9jDNd/IvuJ4xlJmG1tH/hg==
X-Received: by 2002:a17:90b:252:: with SMTP id fz18mr13299097pjb.49.1576431931957;
        Sun, 15 Dec 2019 09:45:31 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o17sm15801964pjq.1.2019.12.15.09.45.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 15 Dec 2019 09:45:31 -0800 (PST)
From:   Guenter Roeck <linux@roeck-us.net>
To:     linux-hwmon@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Chris Healy <cphealy@gmail.com>
Subject: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
Date:   Sun, 15 Dec 2019 09:45:09 -0800
Message-Id: <20191215174509.1847-2-linux@roeck-us.net>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191215174509.1847-1-linux@roeck-us.net>
References: <20191215174509.1847-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reading the hard drive temperature has been supported for years
by userspace tools such as smarttools or hddtemp. The downside of
such tools is that they need to run with super-user privilege, that
the temperatures are not reported by standard tools such as 'sensors'
or 'libsensors', and that drive temperatures are not available for use
in the kernel's thermal subsystem.

This driver solves this problem by adding support for reading the
temperature of SATA drives from the kernel using the hwmon API and
by adding a temperature zone for each drive.

With this driver, the hard disk temperature can be read using the
unprivileged 'sensors' application:

$ sensors satatemp-scsi-1-0
satatemp-scsi-1-0
Adapter: SCSI adapter
temp1:        +23.0°C

or directly from sysfs:

$ grep . /sys/class/hwmon/hwmon9/{name,temp1_input}
/sys/class/hwmon/hwmon9/name:satatemp
/sys/class/hwmon/hwmon9/temp1_input:23000

If the drive supports SCT transport and reports temperature limits,
those are reported as well.

satatemp-scsi-0-0
Adapter: SCSI adapter
temp1:        +27.0°C  (low  =  +0.0°C, high = +60.0°C)
                       (crit low = -41.0°C, crit = +85.0°C)
                       (lowest = +23.0°C, highest = +34.0°C)

The driver attempts to use SCT Command Transport to read the drive
temperature. If the SCT Command Transport feature set is not available,
or if it does not report the drive temperature, drive temperatures may
be readable through SMART attributes. Since SMART attributes are not well
defined, this method is only used as fallback mechanism.

Cc: Chris Healy <cphealy@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: scsi_cmd variable is no longer static
    Fixed drive name in Kconfig 
    Describe heuristics used to select SCT or SMART in commit message
    Added Reviewed-by: from Linus Walleij

 Documentation/hwmon/index.rst    |   1 +
 Documentation/hwmon/satatemp.rst |  48 +++
 drivers/hwmon/Kconfig            |  10 +
 drivers/hwmon/Makefile           |   1 +
 drivers/hwmon/satatemp.c         | 575 +++++++++++++++++++++++++++++++
 5 files changed, 635 insertions(+)
 create mode 100644 Documentation/hwmon/satatemp.rst
 create mode 100644 drivers/hwmon/satatemp.c

diff --git a/Documentation/hwmon/index.rst b/Documentation/hwmon/index.rst
index 230ad59b462b..ecf1832dd013 100644
--- a/Documentation/hwmon/index.rst
+++ b/Documentation/hwmon/index.rst
@@ -133,6 +133,7 @@ Hardware Monitoring Kernel Drivers
    pxe1610
    pwm-fan
    raspberrypi-hwmon
+   satatemp
    sch5627
    sch5636
    scpi-hwmon
diff --git a/Documentation/hwmon/satatemp.rst b/Documentation/hwmon/satatemp.rst
new file mode 100644
index 000000000000..59b105f3c79a
--- /dev/null
+++ b/Documentation/hwmon/satatemp.rst
@@ -0,0 +1,48 @@
+Kernel driver satatemp
+======================
+
+
+References
+----------
+
+ANS T13/1699-D
+Information technology - AT Attachment 8 - ATA/ATAPI Command Set (ATA8-ACS)
+
+ANS Project T10/BSR INCITS 513
+Information technology - SCSI Primary Commands - 4 (SPC-4)
+
+ANS Project INCITS 557
+Information technology - SCSI / ATA Translation - 5 (SAT-5)
+
+
+Description
+-----------
+
+This driver supports reporting the temperature of SATA drives.
+If supported, it uses the SCT Command Transport feature to read
+the current drive temperature and, if available, temperature limits
+as well as historic minimum and maximum temperatures. If SCT Command
+Transport is not supported, the driver uses SMART attributes to read
+the drive temperature.
+
+
+Sysfs entries
+-------------
+
+Only the temp1_input attribute is always available. Other attributes are
+available only if reported by the drive. All temperatures are reported in
+milli-degrees Celsius.
+
+=======================	=====================================================
+temp1_input		Current drive temperature
+temp1_lcrit		Minimum temperature limit. Operating the device below
+			this temperature may cause physical damage to the
+			device.
+temp1_min		Minimum recommended continuous operating limit
+temp1_max		Maximum recommended continuous operating temperature
+temp1_crit		Maximum temperature limit. Operating the device above
+			this temperature may cause physical damage to the
+			device.
+temp1_lowest		Minimum temperature seen this power cycle
+temp1_highest		Maximum temperature seen this power cycle
+=======================	=====================================================
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 13a6b4afb4b3..97acf4ebd5ca 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1346,6 +1346,16 @@ config SENSORS_RASPBERRYPI_HWMON
 	  This driver can also be built as a module. If so, the module
 	  will be called raspberrypi-hwmon.
 
+config SENSORS_SATATEMP
+	tristate "SATA hard disk drives with temperature sensors"
+	depends on SCSI && ATA
+	help
+	  If you say yes you get support for the temperature sensor on
+	  SATA hard disk drives.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called satatemp.
+
 config SENSORS_SHT15
 	tristate "Sensiron humidity and temperature sensors. SHT15 and compat."
 	depends on GPIOLIB || COMPILE_TEST
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 40c036ea45e6..fe55b8f76af9 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -148,6 +148,7 @@ obj-$(CONFIG_SENSORS_S3C)	+= s3c-hwmon.o
 obj-$(CONFIG_SENSORS_SCH56XX_COMMON)+= sch56xx-common.o
 obj-$(CONFIG_SENSORS_SCH5627)	+= sch5627.o
 obj-$(CONFIG_SENSORS_SCH5636)	+= sch5636.o
+obj-$(CONFIG_SENSORS_SATATEMP)	+= satatemp.o
 obj-$(CONFIG_SENSORS_SHT15)	+= sht15.o
 obj-$(CONFIG_SENSORS_SHT21)	+= sht21.o
 obj-$(CONFIG_SENSORS_SHT3x)	+= sht3x.o
diff --git a/drivers/hwmon/satatemp.c b/drivers/hwmon/satatemp.c
new file mode 100644
index 000000000000..9608716d422c
--- /dev/null
+++ b/drivers/hwmon/satatemp.c
@@ -0,0 +1,575 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Hwmon client for SATA hard disk drives with temperature sensors
+ * Copyright (C) 2019 Zodiac Inflight Innovations
+ *
+ * With input from:
+ *    Hwmon client for S.M.A.R.T. hard disk drives with temperature sensors.
+ *    (C) 2018 Linus Walleij
+ *
+ *    hwmon: Driver for SCSI/ATA temperature sensors
+ *    by Constantin Baranov <const@mimas.ru>, submitted September 2009
+ *
+ * The primary means to read hard drive temperatures and temperature limits
+ * is the SCT Command Transport feature set as specified in ATA8-ACS.
+ * It can be used to read the current drive temperature, temperature limits,
+ * and historic minimum and maximum temperatures. The SCT Command Transport
+ * feature set is documented in "AT Attachment 8 - ATA/ATAPI Command Set
+ * (ATA8-ACS)".
+ *
+ * If the SCT Command Transport feature set is not available, drive temperatures
+ * may be readable through SMART attributes. Since SMART attributes are not well
+ * defined, this method is only used as fallback mechanism.
+ *
+ * There are three SMART attributes which may report drive temperatures.
+ * Those are defined as follows (from
+ * http://www.cropel.com/library/smart-attribute-list.aspx).
+ *
+ * 190	Temperature	Temperature, monitored by a sensor somewhere inside
+ *			the drive. Raw value typicaly holds the actual
+ *			temperature (hexadecimal) in its rightmost two digits.
+ *
+ * 194	Temperature	Temperature, monitored by a sensor somewhere inside
+ *			the drive. Raw value typicaly holds the actual
+ *			temperature (hexadecimal) in its rightmost two digits.
+ *
+ * 231	Temperature	Temperature, monitored by a sensor somewhere inside
+ *			the drive. Raw value typicaly holds the actual
+ *			temperature (hexadecimal) in its rightmost two digits.
+ *
+ * Wikipedia defines attributes a bit differently.
+ *
+ * 190	Temperature	Value is equal to (100-temp. °C), allowing manufacturer
+ *	Difference or	to set a minimum threshold which corresponds to a
+ *	Airflow		maximum temperature. This also follows the convention of
+ *	Temperature	100 being a best-case value and lower values being
+ *			undesirable. However, some older drives may instead
+ *			report raw Temperature (identical to 0xC2) or
+ *			Temperature minus 50 here.
+ * 194	Temperature or	Indicates the device temperature, if the appropriate
+ *	Temperature	sensor is fitted. Lowest byte of the raw value contains
+ *	Celsius		the exact temperature value (Celsius degrees).
+ * 231	Life Left	Indicates the approximate SSD life left, in terms of
+ *	(SSDs) or	program/erase cycles or available reserved blocks.
+ *	Temperature	A normalized value of 100 represents a new drive, with
+ *			a threshold value at 10 indicating a need for
+ *			replacement. A value of 0 may mean that the drive is
+ *			operating in read-only mode to allow data recovery.
+ *			Previously (pre-2010) occasionally used for Drive
+ *			Temperature (more typically reported at 0xC2).
+ *
+ * Common denominator is that the first raw byte reports the temperature
+ * in degrees C on almost all drives. Some drives may report a fractional
+ * temperature in the second raw byte.
+ *
+ * Known exceptions (from libatasmart):
+ * - SAMSUNG SV0412H and SAMSUNG SV1204H) report the temperature in 10th
+ *   degrees C in the first two raw bytes.
+ * - A few Maxtor drives report an unknown or bad value in attribute 194.
+ * - Certain Apple SSD drives report an unknown value in attribute 190.
+ *   Only certain firmware versions are affected.
+ *
+ * Those exceptions affect older ATA drives and are currently ignored.
+ * Also, the second raw byte (possibly reporting the fractional temperature)
+ * is currently ignored.
+ *
+ * Many drives also report temperature limits in additional SMART data raw
+ * bytes. The format of those is not well defined and varies widely.
+ * The driver does not currently attempt to report those limits.
+ *
+ * According to data in smartmontools, attribute 231 is rarely used to report
+ * drive temperatures. At the same time, several drives report SSD life left
+ * in attribute 231, but do not support temperature sensors. For this reason,
+ * attribute 231 is currently ignored.
+ *
+ * Following above definitions, temperatures are reported as follows.
+ *   If SCT Command Transport is supported, it is used to read the
+ *   temperature and, if available, temperature limits.
+ * - Otherwise, if SMART attribute 194 is supported, it is used to read
+ *   the temperature.
+ * - Otherwise, if SMART attribute 190 is supported, it is used to read
+ *   the temperature.
+ */
+
+#include <linux/ata.h>
+#include <linux/bits.h>
+#include <linux/device.h>
+#include <linux/hwmon.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_proto.h>
+
+struct satatemp_data {
+	struct list_head list;		/* list of instantiated devices */
+	struct mutex lock;		/* protect data buffer accesses */
+	struct scsi_device *sdev;	/* SCSI device */
+	struct device *dev;		/* instantiating device */
+	struct device *hwdev;		/* hardware monitoring device */
+	u8 smartdata[ATA_SECT_SIZE];	/* local buffer */
+	int (*get_temp)(struct satatemp_data *st, u32 attr, long *val);
+	bool have_temp_lowest;		/* lowest temp in SCT status */
+	bool have_temp_highest;		/* highest temp in SCT status */
+	bool have_temp_min;		/* have min temp */
+	bool have_temp_max;		/* have max temp */
+	bool have_temp_lcrit;		/* have lower critical limit */
+	bool have_temp_crit;		/* have critical limit */
+	int temp_min;			/* min temp */
+	int temp_max;			/* max temp */
+	int temp_lcrit;			/* lower critical limit */
+	int temp_crit;			/* critical limit */
+};
+
+static LIST_HEAD(satatemp_devlist);
+
+#define ATA_MAX_SMART_ATTRS	30
+#define SMART_TEMP_PROP_190	190
+#define SMART_TEMP_PROP_194	194
+
+#define SCT_STATUS_REQ_ADDR	0xe0
+#define  SCT_STATUS_VERSION_LOW		0	/* log byte offsets */
+#define  SCT_STATUS_VERSION_HIGH	1
+#define  SCT_STATUS_TEMP		200
+#define  SCT_STATUS_TEMP_LOWEST		201
+#define  SCT_STATUS_TEMP_HIGHEST	202
+#define SCT_READ_LOG_ADDR	0xe1
+#define  SMART_READ_LOG			0xd5
+#define  SMART_WRITE_LOG		0xd6
+
+#define INVALID_TEMP		0x80
+
+#define temp_is_valid(temp)	((temp) != INVALID_TEMP)
+#define temp_from_sct(temp)	(((s8)(temp)) * 1000)
+
+static inline bool ata_id_smart_supported(u16 *id)
+{
+	return id[ATA_ID_COMMAND_SET_1] & BIT(0);
+}
+
+static inline bool ata_id_smart_enabled(u16 *id)
+{
+	return id[ATA_ID_CFS_ENABLE_1] & BIT(0);
+}
+
+static int satatemp_scsi_command(struct satatemp_data *st,
+				 u8 ata_command, u8 feature,
+				 u8 lba_low, u8 lba_mid, u8 lba_high)
+{
+	u8 scsi_cmd[MAX_COMMAND_SIZE];
+	int data_dir;
+
+	memset(scsi_cmd, 0, sizeof(scsi_cmd));
+	scsi_cmd[0] = ATA_16;
+	if (ata_command == ATA_CMD_SMART && feature == SMART_WRITE_LOG) {
+		scsi_cmd[1] = (5 << 1);	/* PIO Data-out */
+		/*
+		 * No off.line or cc, write to dev, block count in sector count
+		 * field.
+		 */
+		scsi_cmd[2] = 0x06;
+		data_dir = DMA_TO_DEVICE;
+	} else {
+		scsi_cmd[1] = (4 << 1);	/* PIO Data-in */
+		/*
+		 * No off.line or cc, read from dev, block count in sector count
+		 * field.
+		 */
+		scsi_cmd[2] = 0x0e;
+		data_dir = DMA_FROM_DEVICE;
+	}
+	scsi_cmd[4] = feature;
+	scsi_cmd[6] = 1;	/* 1 sector */
+	scsi_cmd[8] = lba_low;
+	scsi_cmd[10] = lba_mid;
+	scsi_cmd[12] = lba_high;
+	scsi_cmd[14] = ata_command;
+
+	return scsi_execute_req(st->sdev, scsi_cmd, data_dir,
+				st->smartdata, ATA_SECT_SIZE, NULL, HZ, 5,
+				NULL);
+}
+
+static int satatemp_ata_command(struct satatemp_data *st, u8 feature, u8 select)
+{
+	return satatemp_scsi_command(st, ATA_CMD_SMART, feature, select,
+				     ATA_SMART_LBAM_PASS, ATA_SMART_LBAH_PASS);
+}
+
+static int satatemp_get_smarttemp(struct satatemp_data *st, u32 attr,
+				  long *temp)
+{
+	u8 *buf = st->smartdata;
+	bool have_temp = false;
+	u8 temp_raw;
+	u8 csum;
+	int err;
+	int i;
+
+	err = satatemp_ata_command(st, ATA_SMART_READ_VALUES, 0);
+	if (err)
+		return err;
+
+	/* Checksum the read value table */
+	csum = 0;
+	for (i = 0; i < ATA_SECT_SIZE; i++)
+		csum += buf[i];
+	if (csum) {
+		dev_dbg(&st->sdev->sdev_gendev,
+			"checksum error reading SMART values\n");
+		return -EIO;
+	}
+
+	for (i = 0; i < ATA_MAX_SMART_ATTRS; i++) {
+		u8 *attr = buf + i * 12;
+		int id = attr[2];
+
+		if (!id)
+			continue;
+
+		if (id == SMART_TEMP_PROP_190) {
+			temp_raw = attr[7];
+			have_temp = true;
+		}
+		if (id == SMART_TEMP_PROP_194) {
+			temp_raw = attr[7];
+			have_temp = true;
+			break;
+		}
+	}
+
+	if (have_temp) {
+		*temp = temp_raw * 1000;
+		return 0;
+	}
+
+	return -ENXIO;
+}
+
+static int satatemp_get_scttemp(struct satatemp_data *st, u32 attr, long *val)
+{
+	u8 *buf = st->smartdata;
+	int err;
+
+	err = satatemp_ata_command(st, SMART_READ_LOG, SCT_STATUS_REQ_ADDR);
+	if (err)
+		return err;
+	switch (attr) {
+	case hwmon_temp_input:
+		*val = temp_from_sct(buf[SCT_STATUS_TEMP]);
+		break;
+	case hwmon_temp_lowest:
+		*val = temp_from_sct(buf[SCT_STATUS_TEMP_LOWEST]);
+		break;
+	case hwmon_temp_highest:
+		*val = temp_from_sct(buf[SCT_STATUS_TEMP_HIGHEST]);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+	return err;
+}
+
+static int satatemp_identify(struct satatemp_data *st)
+{
+	struct scsi_device *sdev = st->sdev;
+	u8 *buf = st->smartdata;
+	bool is_ata, is_sata;
+	bool have_sct_data_table;
+	bool have_sct_temp;
+	bool have_smart;
+	bool have_sct;
+	u16 *ata_id;
+	u16 version;
+	long temp;
+	u8 *vpd;
+	int err;
+
+	/* bail out immediately if there is no inquiry data */
+	if (!sdev->inquiry || sdev->inquiry_len < 16)
+		return -ENODEV;
+
+	/*
+	 * Inquiry data sanity checks (per SAT-5):
+	 * - peripheral qualifier must be 0
+	 * - peripheral device type must be 0x0 (Direct access block device)
+	 * - SCSI Vendor ID is "ATA     "
+	 */
+	if (sdev->inquiry[0] ||
+	    strncmp(&sdev->inquiry[8], "ATA     ", 8))
+		return -ENODEV;
+
+	vpd = kzalloc(1024, GFP_KERNEL);
+	if (!vpd)
+		return -ENOMEM;
+
+	err = scsi_get_vpd_page(sdev, 0x89, vpd, 1024);
+	if (err) {
+		kfree(vpd);
+		return err;
+	}
+
+	/*
+	 * More sanity checks.
+	 * For VPD offsets and values see ANS Project INCITS 557,
+	 * "Information technology - SCSI / ATA Translation - 5 (SAT-5)".
+	 */
+	if (vpd[1] != 0x89 || vpd[2] != 0x02 || vpd[3] != 0x38 ||
+	    vpd[36] != 0x34 || vpd[56] != ATA_CMD_ID_ATA) {
+		kfree(vpd);
+		return -ENODEV;
+	}
+	ata_id = (u16 *)&vpd[60];
+	is_ata = ata_id_is_ata(ata_id);
+	is_sata = ata_id_is_sata(ata_id);
+	have_sct = ata_id_sct_supported(ata_id);
+	have_sct_data_table = ata_id_sct_data_tables(ata_id);
+	have_smart = ata_id_smart_supported(ata_id) &&
+				ata_id_smart_enabled(ata_id);
+
+	kfree(vpd);
+
+	/* bail out if this is not a SATA device */
+	if (!is_ata || !is_sata)
+		return -ENODEV;
+	if (!have_sct)
+		goto skip_sct;
+
+	err = satatemp_ata_command(st, SMART_READ_LOG, SCT_STATUS_REQ_ADDR);
+	if (err)
+		goto skip_sct;
+
+	version = (buf[SCT_STATUS_VERSION_HIGH] << 8) |
+		  buf[SCT_STATUS_VERSION_LOW];
+	if (version != 2 && version != 3)
+		goto skip_sct;
+
+	have_sct_temp = temp_is_valid(buf[SCT_STATUS_TEMP]);
+	if (!have_sct_temp)
+		goto skip_sct;
+
+	st->have_temp_lowest = temp_is_valid(buf[SCT_STATUS_TEMP_LOWEST]);
+	st->have_temp_highest = temp_is_valid(buf[SCT_STATUS_TEMP_HIGHEST]);
+
+	if (!have_sct_data_table)
+		goto skip_sct;
+
+	/* Request and read temperature history table */
+	memset(buf, '\0', sizeof(st->smartdata));
+	buf[0] = 5;	/* data table command */
+	buf[2] = 1;	/* read table */
+	buf[4] = 2;	/* temperature history table */
+
+	err = satatemp_ata_command(st, SMART_WRITE_LOG, SCT_STATUS_REQ_ADDR);
+	if (err)
+		goto skip_sct_data;
+
+	err = satatemp_ata_command(st, SMART_READ_LOG, SCT_READ_LOG_ADDR);
+	if (err)
+		goto skip_sct_data;
+
+	/*
+	 * Temperature limits per AT Attachment 8 -
+	 * ATA/ATAPI Command Set (ATA8-ACS)
+	 */
+	st->have_temp_max = temp_is_valid(buf[6]);
+	st->have_temp_crit = temp_is_valid(buf[7]);
+	st->have_temp_min = temp_is_valid(buf[8]);
+	st->have_temp_lcrit = temp_is_valid(buf[9]);
+
+	st->temp_max = temp_from_sct(buf[6]);
+	st->temp_crit = temp_from_sct(buf[7]);
+	st->temp_min = temp_from_sct(buf[8]);
+	st->temp_lcrit = temp_from_sct(buf[9]);
+
+skip_sct_data:
+	if (have_sct_temp) {
+		st->get_temp = satatemp_get_scttemp;
+		return 0;
+	}
+skip_sct:
+	if (!have_smart)
+		return -ENODEV;
+	st->get_temp = satatemp_get_smarttemp;
+	return satatemp_get_smarttemp(st, hwmon_temp_input, &temp);
+}
+
+static int satatemp_read(struct device *dev, enum hwmon_sensor_types type,
+			 u32 attr, int channel, long *val)
+{
+	struct satatemp_data *st = dev_get_drvdata(dev);
+	int err = 0;
+
+	if (type != hwmon_temp)
+		return -EINVAL;
+
+	switch (attr) {
+	case hwmon_temp_input:
+	case hwmon_temp_lowest:
+	case hwmon_temp_highest:
+		mutex_lock(&st->lock);
+		err = st->get_temp(st, attr, val);
+		mutex_unlock(&st->lock);
+		break;
+	case hwmon_temp_lcrit:
+		*val = st->temp_lcrit;
+		break;
+	case hwmon_temp_min:
+		*val = st->temp_min;
+		break;
+	case hwmon_temp_max:
+		*val = st->temp_max;
+		break;
+	case hwmon_temp_crit:
+		*val = st->temp_crit;
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+	return err;
+}
+
+static umode_t satatemp_is_visible(const void *data,
+				   enum hwmon_sensor_types type,
+				   u32 attr, int channel)
+{
+	const struct satatemp_data *st = data;
+
+	switch (type) {
+	case hwmon_temp:
+		switch (attr) {
+		case hwmon_temp_input:
+			return 0444;
+		case hwmon_temp_lowest:
+			if (st->have_temp_lowest)
+				return 0444;
+			break;
+		case hwmon_temp_highest:
+			if (st->have_temp_highest)
+				return 0444;
+			break;
+		case hwmon_temp_min:
+			if (st->have_temp_min)
+				return 0444;
+			break;
+		case hwmon_temp_max:
+			if (st->have_temp_max)
+				return 0444;
+			break;
+		case hwmon_temp_lcrit:
+			if (st->have_temp_lcrit)
+				return 0444;
+			break;
+		case hwmon_temp_crit:
+			if (st->have_temp_crit)
+				return 0444;
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+static const struct hwmon_channel_info *satatemp_info[] = {
+	HWMON_CHANNEL_INFO(chip,
+			   HWMON_C_REGISTER_TZ),
+	HWMON_CHANNEL_INFO(temp, HWMON_T_INPUT |
+			   HWMON_T_LOWEST | HWMON_T_HIGHEST |
+			   HWMON_T_MIN | HWMON_T_MAX |
+			   HWMON_T_LCRIT | HWMON_T_CRIT),
+	NULL
+};
+
+static const struct hwmon_ops satatemp_ops = {
+	.is_visible = satatemp_is_visible,
+	.read = satatemp_read,
+};
+
+static const struct hwmon_chip_info satatemp_chip_info = {
+	.ops = &satatemp_ops,
+	.info = satatemp_info,
+};
+
+/*
+ * The device argument points to sdev->sdev_dev. Its parent is
+ * sdev->sdev_gendev, which we can use to get the scsi_device pointer.
+ */
+static int satatemp_add(struct device *dev, struct class_interface *intf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev->parent);
+	struct satatemp_data *st;
+	int err;
+
+	st = kzalloc(sizeof(*st), GFP_KERNEL);
+	if (!st)
+		return -ENOMEM;
+
+	st->sdev = sdev;
+	st->dev = dev;
+	mutex_init(&st->lock);
+
+	if (satatemp_identify(st)) {
+		err = -ENODEV;
+		goto abort;
+	}
+
+	st->hwdev = hwmon_device_register_with_info(dev->parent, "satatemp",
+						    st, &satatemp_chip_info,
+						    NULL);
+	if (IS_ERR(st->hwdev)) {
+		err = PTR_ERR(st->hwdev);
+		goto abort;
+	}
+
+	list_add(&st->list, &satatemp_devlist);
+	return 0;
+
+abort:
+	kfree(st);
+	return err;
+}
+
+static void satatemp_remove(struct device *dev, struct class_interface *intf)
+{
+	struct satatemp_data *st, *tmp;
+
+	list_for_each_entry_safe(st, tmp, &satatemp_devlist, list) {
+		if (st->dev == dev) {
+			list_del(&st->list);
+			hwmon_device_unregister(st->hwdev);
+			kfree(st);
+			break;
+		}
+	}
+}
+
+static struct class_interface satatemp_interface = {
+	.add_dev = satatemp_add,
+	.remove_dev = satatemp_remove,
+};
+
+static int __init satatemp_init(void)
+{
+	return scsi_register_interface(&satatemp_interface);
+}
+
+static void __exit satatemp_exit(void)
+{
+	scsi_unregister_interface(&satatemp_interface);
+}
+
+module_init(satatemp_init);
+module_exit(satatemp_exit);
+
+MODULE_AUTHOR("Guenter Roeck <linus@roeck-us.net>");
+MODULE_DESCRIPTION("ATA temperature monitor");
+MODULE_LICENSE("GPL");
-- 
2.17.1


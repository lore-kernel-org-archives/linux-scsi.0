Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4015392C50
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2026 21:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778622442; cv=none; b=LPXys715tRfmr7wNKzG147fAmgrQAZrmmnm6Vhz9qr+rNOx1GtkTqmZJjcGDlyJL/QkGbPITa8R0lHh4meE29L9O7ac3WAMBWztCh20C0j/fUFn5H5N/RxaaNoQexQhxbr04LoCrHpkJGLxcTtq05aWaI5wbCYaO0mVfkAirEAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778622442; c=relaxed/simple;
	bh=saC92KOxxM4It5KC/uWNvs0ap5oDnK1CCA3MZLPfBqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bq3bAUx8UyMcYQ4IBWIqtWqAd2h/EZ+fViBbEx2wc1dNbQNFU1C+370gwVYM2LaIKzG+JE81vWgz7blQZaPIdo3qqfemctKng8f+1M1IaO3Q1xYQi3JFwphjnu4X0yser4Xqat0iLvrAwcTRZEnMkMk5bR51gDbtLmAL/3Vq2YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lq0DsB7B; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lq0DsB7B"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-39380e79936so73624601fa.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 May 2026 14:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778622439; x=1779227239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ke/sZb9uK1j6VoXezaQMAEZyW4dQawkEtVgjASGCtGQ=;
        b=lq0DsB7BG3zHrhbb7MDeXA+XPmWmngZX2H6JNiP2UicTFIdubirbtaXN360wwfLBpm
         fFp8LiWXK0tYMvAQxn+Jca2Krkg/HhAYPzKjKlGGC2MumYQgCRTaG10xQN4oJUlNO0gc
         HDRaJFIP2yQ21bkgdQ43AoJJw0Cci9xAIuTAIyHcJk5Vu0uGdDLkhoLZe4thCZ1YDRwp
         ekUkEd6jy1As0slq5TTI6TvYXPsnbC/D1B0Ao8VaRWOFtvvjt7p1mdIIsYy3GZkAKAH6
         bspxEyYz96gnFU3x40PfMJrXN+hNR/B3wmP0R9eGfsLAyaHuYlpGc+ZEyFmdOfsz4tbG
         PUjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778622439; x=1779227239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ke/sZb9uK1j6VoXezaQMAEZyW4dQawkEtVgjASGCtGQ=;
        b=JAQaLXpj4EzYoblAytoTAtvd0BSb8JedRkpm+JP+b+/frV2X+74O+RuQAqQ8HTcXRa
         PPiD5rvkcByHzxN5eeQezrLeV98wHE/LO8J34d6rRV8zO9h5bUlLu3KdyMHJpwTOvq+y
         3AaKFGDXZPinxaa8bTu+szZDSwtBIo3nG6MXiRa1E9w2FTgupwv0LL1fJ9VKEG/DOs3/
         uUO66pXKaP5E7cgwvGHvZ3qbwyK8pgBxpeSyl11lcx+pGIocXCRfRuXgduy7hOa34PdR
         uWv/FPCjbWOXjD2/lxxH8RJyNETZ+ps7R03AiTHN3t9us+BccKyLFBrCXr/LDmG9CS8i
         4gFw==
X-Forwarded-Encrypted: i=1; AFNElJ+KgCOhnhCg3tIew/8HzOit0GE4GlZfVibcEPNbH0HAlewdYw5X47Mne0KEHiYxL4Zj5NGIGGhjuo+U@vger.kernel.org
X-Gm-Message-State: AOJu0Yzmexy4Oz67u7zXOC859FdztIFEiACzz7BWCF5elaPdTaoYC2bD
	ZnqA+O1fKv/+w2iQ8D6HfzLEYOkSUp4OglKHh+z5BdpepyoByPLTN+p9
X-Gm-Gg: Acq92OGbGMahBAZzJtqK/nW4XZIfWbSNVHw/yYiyWVzvnkaPbugmuPSI+s3290OFK5+
	PtZJY2SxAAVmm+/Ic9XDRhm7y8NU9TPrYqdDAKYxT401l59wVw6+lNs+kOnwBNFM0A9aYOcdAQ8
	8Ap688FnaM3mxEWtKeVwfMUyKxpJtCYoW3z55PQJHRHTnRhqAqxiC/j5C7w1SdmxWqtTITnC3nS
	IuXyitN1/AL3M4h09eeZm3MRPZ49BUEe2XfoYm4I6m74vZcWPzCMj5yJeQbrEmdhbx+rtLvYnav
	DEp6VuqGqD4WUxinzcSaG4yo0lBRFKBLMsR2lPRkJvQMJVi00gaSViosFphiXxE0dL0W66RGUM8
	wyXguhILMMuERtbuuAFORBuJuNERF5EXWaQ6oN81X4yl47uTYuw5FdtSqqWYY/k2TO9s/Gfll7m
	odD7PWUxVS9+U+bzvmzkWNhQlunsizzcjcqDS+pw==
X-Received: by 2002:a2e:8a86:0:b0:38e:83a6:d37 with SMTP id 38308e7fff4ca-3944b5aeab4mr1964531fa.13.1778622438869;
        Tue, 12 May 2026 14:47:18 -0700 (PDT)
Received: from localhost ([2001:863:361:c304:f117:a539:6ce3:fb03])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-393f6144071sm34373081fa.32.2026.05.12.14.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:47:18 -0700 (PDT)
From: Louis Sautier <sautier.louis@gmail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] scsi: mpt3sas: add hwmon support
Date: Tue, 12 May 2026 23:47:03 +0200
Message-ID: <20260512214703.655633-3-sautier.louis@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512214703.655633-1-sautier.louis@gmail.com>
References: <20260512214703.655633-1-sautier.louis@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Expose the IOC and board temperature sensors of LSI / Broadcom SAS
HBAs through hwmon. Readings come from MPI IO Unit Page 7 via the
accessor added in the preceding patch.

The same fields are exposed by Broadcom's userspace tooling
through the /dev/mpt[23]ctl ioctl path (typically root-only):
IOCTemperature and BoardTemperature in lsiutil; ROC and Controller
in storcli. With this driver, sensors(1) shows them unprivileged:

  $ sensors mpt3sas-pci-0200
  mpt3sas-pci-0200
  Adapter: PCI adapter
  IOC:          +42.0°C

Each channel is gated independently by its *TemperatureUnits field
through is_visible(); cards that populate only one sensor expose
only one input file, and cards that populate neither do not register
an hwmon device.

Built into mpt3sas.ko under a new CONFIG_SCSI_MPT3SAS_HWMON Kconfig
option.

Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Louis Sautier <sautier.louis@gmail.com>
---
 Documentation/hwmon/index.rst        |   1 +
 Documentation/hwmon/mpt3sas.rst      |  57 ++++++++
 MAINTAINERS                          |   1 +
 drivers/scsi/mpt3sas/Kconfig         |   9 ++
 drivers/scsi/mpt3sas/Makefile        |   2 +
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  17 +++
 drivers/scsi/mpt3sas/mpt3sas_hwmon.c | 200 +++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   6 +
 8 files changed, 293 insertions(+)
 create mode 100644 Documentation/hwmon/mpt3sas.rst
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_hwmon.c

diff --git a/Documentation/hwmon/index.rst b/Documentation/hwmon/index.rst
index 8b655e5d6b68..106f87fa8b18 100644
--- a/Documentation/hwmon/index.rst
+++ b/Documentation/hwmon/index.rst
@@ -193,6 +193,7 @@ Hardware Monitoring Kernel Drivers
    mp9941
    mp9945
    mpq8785
+   mpt3sas
    nct6683
    nct6775
    nct7363
diff --git a/Documentation/hwmon/mpt3sas.rst b/Documentation/hwmon/mpt3sas.rst
new file mode 100644
index 000000000000..3a260a389d6d
--- /dev/null
+++ b/Documentation/hwmon/mpt3sas.rst
@@ -0,0 +1,57 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Kernel driver mpt3sas
+=====================
+
+Supported chips:
+
+  * LSI / Broadcom / Avago SAS HBAs handled by the mpt3sas driver,
+    such as the 9300, 9400, and 9500 series.
+
+    Prefix: ``mpt3sas``
+
+
+Description
+-----------
+
+The mpt3sas driver exposes the IOC and board temperature sensors of
+LSI / Broadcom SAS HBAs through the hwmon interface.
+Either or both sensors may be absent depending on the card; the
+corresponding sysfs files only appear when the firmware reports the
+sensor as present, and cards that report neither sensor do not
+register an hwmon device at all.
+
+
+Sysfs entries
+-------------
+
+============  ======================
+Name          Description
+============  ======================
+temp1_input   IOC temperature (mC)
+temp1_label   "IOC"
+temp2_input   Board temperature (mC)
+temp2_label   "Board"
+============  ======================
+
+
+Cross-reference with vendor tooling
+-----------------------------------
+
+The hwmon channels correspond to fields reported by Broadcom's
+proprietary tools as follows:
+
+=================  ==========================  ===============================
+hwmon label        lsiutil                     storcli
+=================  ==========================  ===============================
+``IOC`` (temp1)    ``IOCTemperature``          ``ROC temperature``
+``Board`` (temp2)  ``BoardTemperature``        ``Controller temperature``
+=================  ==========================  ===============================
+
+With lsiutil::
+
+    lsiutil -pN -a 25,2,0,0
+
+With storcli::
+
+    storcli /cN show temperature
diff --git a/MAINTAINERS b/MAINTAINERS
index b2040011a386..e084f710f436 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15154,6 +15154,7 @@ L:	MPT-FusionLinux.pdl@broadcom.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 W:	http://www.avagotech.com/support/
+F:	Documentation/hwmon/mpt3sas.rst
 F:	drivers/message/fusion/
 F:	drivers/scsi/mpt3sas/
 
diff --git a/drivers/scsi/mpt3sas/Kconfig b/drivers/scsi/mpt3sas/Kconfig
index c299f7e078fb..638acd2c6623 100644
--- a/drivers/scsi/mpt3sas/Kconfig
+++ b/drivers/scsi/mpt3sas/Kconfig
@@ -73,6 +73,15 @@ config SCSI_MPT3SAS_MAX_SGE
 	can be 256. However, it may decreased down to 16.  Decreasing this
 	parameter will reduce memory requirements on a per controller instance.
 
+config SCSI_MPT3SAS_HWMON
+	bool "LSI MPT Fusion SAS hwmon support"
+	depends on SCSI_MPT3SAS && HWMON
+	depends on !(SCSI_MPT3SAS=y && HWMON=m)
+	help
+	Say Y here to expose the IOC and board temperature sensors of
+	LSI / Broadcom SAS HBAs (such as the 9300, 9400, and 9500 series)
+	through hwmon. See Documentation/hwmon/mpt3sas.rst for details.
+
 config SCSI_MPT2SAS
 	tristate "Legacy MPT2SAS config option"
 	default n
diff --git a/drivers/scsi/mpt3sas/Makefile b/drivers/scsi/mpt3sas/Makefile
index e76d994dbed3..9a2f3ce4158a 100644
--- a/drivers/scsi/mpt3sas/Makefile
+++ b/drivers/scsi/mpt3sas/Makefile
@@ -9,3 +9,5 @@ mpt3sas-y +=  mpt3sas_base.o     \
 		mpt3sas_trigger_diag.o \
 		mpt3sas_warpdrive.o \
 		mpt3sas_debugfs.o \
+
+mpt3sas-$(CONFIG_SCSI_MPT3SAS_HWMON) += mpt3sas_hwmon.o
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index c655742d0dde..63252f30343b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1629,6 +1629,7 @@ struct MPT3SAS_ADAPTER {
 	u8		is_aero_ioc;
 	struct dentry	*debugfs_root;
 	struct dentry	*ioc_dump;
+	struct mpt3sas_hwmon *hwmon;
 	PUT_SMID_IO_FP_HIP put_smid_scsi_io;
 	PUT_SMID_IO_FP_HIP put_smid_fast_path;
 	PUT_SMID_IO_FP_HIP put_smid_hi_priority;
@@ -2049,6 +2050,22 @@ void mpt3sas_destroy_debugfs(struct MPT3SAS_ADAPTER *ioc);
 void mpt3sas_init_debugfs(void);
 void mpt3sas_exit_debugfs(void);
 
+#if IS_ENABLED(CONFIG_SCSI_MPT3SAS_HWMON)
+int mpt3sas_hwmon_register(struct MPT3SAS_ADAPTER *ioc);
+void mpt3sas_hwmon_unregister(struct MPT3SAS_ADAPTER *ioc);
+#else
+static inline int
+mpt3sas_hwmon_register(struct MPT3SAS_ADAPTER *ioc)
+{
+	return 0;
+}
+
+static inline void
+mpt3sas_hwmon_unregister(struct MPT3SAS_ADAPTER *ioc)
+{
+}
+#endif
+
 /**
  * _scsih_is_pcie_scsi_device - determines if device is an pcie scsi device
  * @device_info: bitfield providing information about the device.
diff --git a/drivers/scsi/mpt3sas/mpt3sas_hwmon.c b/drivers/scsi/mpt3sas/mpt3sas_hwmon.c
new file mode 100644
index 000000000000..26227a992f35
--- /dev/null
+++ b/drivers/scsi/mpt3sas/mpt3sas_hwmon.c
@@ -0,0 +1,200 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Hardware monitoring (hwmon) support for the LSI / Broadcom mpt3sas
+ * SAS HBA driver. Exposes the IOC and board temperature sensors by
+ * reading MPI IO Unit Page 7.
+ */
+
+#include <linux/err.h>
+#include <linux/hwmon.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+#include "mpt3sas_base.h"
+
+struct mpt3sas_hwmon {
+	struct MPT3SAS_ADAPTER *ioc;
+	struct device *hwmon_dev;
+	bool ioc_present;
+	bool board_present;
+};
+
+/*
+ * Convert a (raw, units) reading to millidegrees Celsius.
+ * Returns -ENODATA when the sensor reports "not present" or
+ * unknown units. Temperature values are interpreted as signed
+ * two's-complement integers.
+ *
+ * The MPI2_IOUNITPAGE7_IOC_TEMP_* and MPI2_IOUNITPAGE7_BOARD_TEMP_*
+ * defines in mpi2_cnfg.h share the same values; the IOC ones are
+ * used for both channels.
+ */
+static int
+_hwmon_to_mdegc(s16 raw, u8 units, long *out)
+{
+	switch (units) {
+	case MPI2_IOUNITPAGE7_IOC_TEMP_CELSIUS:
+		*out = (long)raw * 1000;
+		return 0;
+	case MPI2_IOUNITPAGE7_IOC_TEMP_FAHRENHEIT:
+		/* (F - 32) * 5 / 9, expressed in milli-units */
+		*out = ((long)raw - 32) * 5000 / 9;
+		return 0;
+	default:
+		return -ENODATA;
+	}
+}
+
+static umode_t
+_hwmon_is_visible(const void *drvdata, enum hwmon_sensor_types type,
+		  u32 attr, int channel)
+{
+	const struct mpt3sas_hwmon *h = drvdata;
+
+	if (type != hwmon_temp)
+		return 0;
+	if (attr != hwmon_temp_input && attr != hwmon_temp_label)
+		return 0;
+	if (channel == 0 && h->ioc_present)
+		return 0444;
+	if (channel == 1 && h->board_present)
+		return 0444;
+	return 0;
+}
+
+static int
+_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
+	    u32 attr, int channel, long *val)
+{
+	struct mpt3sas_hwmon *h = dev_get_drvdata(dev);
+	Mpi2ConfigReply_t mpi_reply;
+	Mpi2IOUnitPage7_t page;
+	int r;
+
+	if (type != hwmon_temp || attr != hwmon_temp_input)
+		return -EOPNOTSUPP;
+
+	r = mpt3sas_config_get_iounit_pg7(h->ioc, &mpi_reply, &page);
+	if (r)
+		return r;
+
+	if (channel == 0)
+		return _hwmon_to_mdegc((s16)le16_to_cpu(page.IOCTemperature),
+				       page.IOCTemperatureUnits, val);
+	if (channel == 1)
+		return _hwmon_to_mdegc((s16)le16_to_cpu(page.BoardTemperature),
+				       page.BoardTemperatureUnits, val);
+	return -EOPNOTSUPP;
+}
+
+static const char * const mpt3sas_hwmon_temp_labels[] = {
+	"IOC",
+	"Board",
+};
+
+static int
+_hwmon_read_string(struct device *dev, enum hwmon_sensor_types type,
+		   u32 attr, int channel, const char **str)
+{
+	if (type != hwmon_temp || attr != hwmon_temp_label)
+		return -EOPNOTSUPP;
+	*str = mpt3sas_hwmon_temp_labels[channel];
+	return 0;
+}
+
+static const struct hwmon_channel_info * const mpt3sas_hwmon_info[] = {
+	HWMON_CHANNEL_INFO(temp,
+			   HWMON_T_INPUT | HWMON_T_LABEL,
+			   HWMON_T_INPUT | HWMON_T_LABEL),
+	NULL,
+};
+
+static const struct hwmon_ops mpt3sas_hwmon_ops = {
+	.is_visible	= _hwmon_is_visible,
+	.read		= _hwmon_read,
+	.read_string	= _hwmon_read_string,
+};
+
+static const struct hwmon_chip_info mpt3sas_hwmon_chip_info = {
+	.ops	= &mpt3sas_hwmon_ops,
+	.info	= mpt3sas_hwmon_info,
+};
+
+/**
+ * mpt3sas_hwmon_register - register an hwmon device for the IOC
+ * @ioc: per adapter object
+ * Context: sleep.
+ *
+ * Succeeds without registering when no temperature sensors are present,
+ * so cards without thermal monitoring do not expose an empty hwmon node.
+ * Paired with mpt3sas_hwmon_unregister() from the driver's remove path.
+ *
+ * Return: 0 for success, non-zero for failure.
+ */
+int
+mpt3sas_hwmon_register(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct device *parent = &ioc->pdev->dev;
+	struct mpt3sas_hwmon *h;
+	struct device *hwdev;
+	Mpi2ConfigReply_t mpi_reply;
+	Mpi2IOUnitPage7_t page;
+	int r;
+
+	h = kzalloc_obj(*h);
+	if (!h)
+		return -ENOMEM;
+
+	h->ioc = ioc;
+
+	r = mpt3sas_config_get_iounit_pg7(ioc, &mpi_reply, &page);
+	if (r) {
+		kfree(h);
+		return r;
+	}
+
+	h->ioc_present = page.IOCTemperatureUnits != MPI2_IOUNITPAGE7_IOC_TEMP_NOT_PRESENT;
+	h->board_present = page.BoardTemperatureUnits != MPI2_IOUNITPAGE7_BOARD_TEMP_NOT_PRESENT;
+
+	/*
+	 * A page where both *TemperatureUnits are NOT_PRESENT covers
+	 * two cases: cards that genuinely lack sensors, and firmware
+	 * errors that left the page zero-filled (the accessor mirrors
+	 * _config_request() behaviour). Either way: skip registration.
+	 */
+	if (!h->ioc_present && !h->board_present) {
+		kfree(h);
+		return 0;
+	}
+
+	hwdev = hwmon_device_register_with_info(parent, "mpt3sas", h,
+						&mpt3sas_hwmon_chip_info,
+						NULL);
+	if (IS_ERR(hwdev)) {
+		kfree(h);
+		return PTR_ERR(hwdev);
+	}
+
+	h->hwmon_dev = hwdev;
+	ioc->hwmon = h;
+	return 0;
+}
+
+/**
+ * mpt3sas_hwmon_unregister - tear down the hwmon device, if any
+ * @ioc: per adapter object
+ *
+ * Safe to call when registration was skipped (no sensors) or
+ * failed; in those cases ioc->hwmon is NULL and this is a no-op.
+ */
+void
+mpt3sas_hwmon_unregister(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct mpt3sas_hwmon *h = ioc->hwmon;
+
+	if (!h)
+		return;
+	hwmon_device_unregister(h->hwmon_dev);
+	kfree(h);
+	ioc->hwmon = NULL;
+}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 12caffeed3a0..dea78688cc9b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -12562,6 +12562,7 @@ static void scsih_remove(struct pci_dev *pdev)
 	/* release all the volumes */
 	_scsih_ir_shutdown(ioc);
 	mpt3sas_destroy_debugfs(ioc);
+	mpt3sas_hwmon_unregister(ioc);
 	sas_remove_host(shost);
 	list_for_each_entry_safe(raid_device, next, &ioc->raid_device_list,
 	    list) {
@@ -13651,6 +13652,11 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	scsi_scan_host(shost);
+
+	if (mpt3sas_hwmon_register(ioc))
+		ioc_warn(ioc,
+			 "hwmon registration failed; temperatures not exposed\n");
+
 	mpt3sas_setup_debugfs(ioc);
 	return 0;
 out_add_shost_fail:
-- 
2.54.0


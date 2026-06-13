Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D990342CB3
	for <linux-scsi@vger.kernel.org>; Sat, 13 Jun 2026 02:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781318343; cv=none; b=RjtlQjw02eP6DE+89lGsKA8x414AiYw9pjukmM5fHYFoUBzKlQWfs+0wF05hMjRh+YZaPrg5OZgIz1TrgxHlU2WMQgDIHxXplBg1BdHJLJZgKhZ91jh8t3ai3yhiXJS6jbH8ghXRWf4Rc4eyRgN13viHhwBjDwiob12BmWWmiKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781318343; c=relaxed/simple;
	bh=i9iNVKbbdYwZRGKcNzLSUNFyXWPROZ+7uVtQLeOSjOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TywIrrcWvo9yPDlN78feiRTIESw0VRkUksmWOGzBfCKgNKIvkhK7KoZ97Ft7id/sJG4Fahovudx+WZVODQ3As2Q1++Q9731Ku5GrLqtkpdnQ7XHHPN/S1TL1IQfglHiXhr1Mc4UeyxRBFWQxqzE8f9XCIHXt7f0ljoTI95MTFyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VIR1jNT1; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VIR1jNT1"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-45ef6565cfdso765430f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 19:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781318341; x=1781923141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cTUyapQ4BSxNuXC2zcdDRNn7Xjcqncz+nsTtTzP9eNc=;
        b=VIR1jNT1r3BZc/rAahpY1+AbLjc0l2GeuqS4AB2RgUpfxvFTlxbMa9dPV8POI7eogb
         DbZbs1ADZHHOg8Q/ncACnEQFblAkoY87uA9eUvEuO18KvidHi94qQbV/xJJaCFEVfWfu
         3zTj8nCWlCzvlOXrGT7ljS+HeQC1XEICRdGxoHWsAonDsR+ZwaKjcimLDaUh9+kc6qFE
         bdOjHu6amkZyvwlV06zyA9QSTh+ASiBfGcxjGDCIYKPVFvNVD/EYurBOmJdn/gSG2LH9
         FjIP2eifsFEzlHxfieiHBCYoh0kqFoNoFwtl6DTW9hOAn58iEPAqLLY1PCrTiy6CnP10
         CY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781318341; x=1781923141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cTUyapQ4BSxNuXC2zcdDRNn7Xjcqncz+nsTtTzP9eNc=;
        b=a8q3TF8QiWXobZHS8J/+IcIKAGiPzz9PFPFphYpI9gwolBT97Ux+JQT2JvqtbArqjD
         6fZgcJWojeX9e5LBlgz9afInVDgsWlU5TM1eN9qVOLaFjsIl5p0DjO6V9yebpMx10fMx
         GAlKUBHJoS4SyVvZDlgVyV4LfOelsso0bN2LHzaZR4rioWoAMgokpUJoFjJSk9ruV4wc
         WuGuIn4DyJoUkCeC0+yK5ERyFtpaoMY0nHSgvpUgx1zgGp1+g/ajTMtAK9Hlq0jdWcyH
         fn2uluBEOOQkgYqqE9MSbwhMzRCsGTcGefcPEHRJR5gk870DKCWK+LBQIfV5l38aDAbv
         Pe/w==
X-Forwarded-Encrypted: i=1; AFNElJ8JX9wLIcyR/T4+3H43ATI1T/sTr4FpM3klUWHt5pY1Jxm2OkbhE0HJAzTC5mcIHn3dEha4Mv8obtth@vger.kernel.org
X-Gm-Message-State: AOJu0YwXCdkHLzzKDuCVzcAmy76uoXgRZEz6nwylVFBDdcBVysdnr0wH
	+iPderE0Zxib+dNzH3OnMyS/5grt3Qg0bPKanKDmq/MMjjudy0Av8Sg8
X-Gm-Gg: Acq92OFel93SySAXq6fnvzzYVxB0O5ttcnsNFE8UF9Aa+eT+G5RMCLJbhFLZBAiJl50
	rWheOiuCvNdj67VTantlKowghRwsUHBtCLdWf9Ne9hAfILk/Y+8Sz0eGKKEIGW/txycuf7IXEic
	2zPoagTTm+l8lwA9lGqgDG+mlSr2Fp81h02bvNH6y2jz8WkzWVp1wX6OIVSllBI/HTPCbYYjuAr
	552YwftsQ7aXqSSFdQuRgVx5YyawD+6O0zSZmNDhehDznU2EjLf/hJJE5yfz+qOR547kdL0H+8w
	7kG/n53zhijkZ76zl00ydUg7JQ6Vbyttqm1ZROPatmIR+LzKI8VqSF4vsMVrTVp3GhuW4XLvrsk
	MZDL+RMBc7nWYKxUEJWA17rGsydk3CngiSLyKcF5BCfXfB54tclRFJFXzFbh0aLzsli9CGuwd4X
	zrsfEgzls=
X-Received: by 2002:a05:6000:2dc2:b0:460:3b5d:43b6 with SMTP id ffacd0b85a97d-4606dba0623mr8422998f8f.31.1781318340521;
        Fri, 12 Jun 2026 19:39:00 -0700 (PDT)
Received: from localhost ([2603:c027:c000:3cde::f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c473bsm11468595f8f.28.2026.06.12.19.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 19:39:00 -0700 (PDT)
From: Louis Sautier <sautier.louis@gmail.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] scsi: mpt3sas: add hwmon support
Date: Sat, 13 Jun 2026 04:38:33 +0200
Message-ID: <20260613023833.3163507-3-sautier.louis@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260613023833.3163507-1-sautier.louis@gmail.com>
References: <20260613023833.3163507-1-sautier.louis@gmail.com>
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

The hwmon code is gated directly on CONFIG_HWMON. IS_REACHABLE() is
used rather than IS_ENABLED() so that SCSI_MPT3SAS=y with HWMON=m
still builds; in that configuration, the sensors are not exposed
(same pattern as i915 and xe).

Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Louis Sautier <sautier.louis@gmail.com>
---
 drivers/scsi/mpt3sas/Makefile        |   2 +
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  17 +++
 drivers/scsi/mpt3sas/mpt3sas_hwmon.c | 195 +++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   6 +
 4 files changed, 220 insertions(+)
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_hwmon.c

diff --git a/drivers/scsi/mpt3sas/Makefile b/drivers/scsi/mpt3sas/Makefile
index e76d994dbed3..18e2d87eb4a2 100644
--- a/drivers/scsi/mpt3sas/Makefile
+++ b/drivers/scsi/mpt3sas/Makefile
@@ -9,3 +9,5 @@ mpt3sas-y +=  mpt3sas_base.o     \
 		mpt3sas_trigger_diag.o \
 		mpt3sas_warpdrive.o \
 		mpt3sas_debugfs.o \
+
+mpt3sas-$(CONFIG_HWMON) += mpt3sas_hwmon.o
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index fe21b0425047..47255bf9cdda 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1629,6 +1629,9 @@ struct MPT3SAS_ADAPTER {
 	u8		is_aero_ioc;
 	struct dentry	*debugfs_root;
 	struct dentry	*ioc_dump;
+#if IS_REACHABLE(CONFIG_HWMON)
+	struct mpt3sas_hwmon *hwmon;
+#endif
 	PUT_SMID_IO_FP_HIP put_smid_scsi_io;
 	PUT_SMID_IO_FP_HIP put_smid_fast_path;
 	PUT_SMID_IO_FP_HIP put_smid_hi_priority;
@@ -2050,6 +2053,20 @@ void mpt3sas_destroy_debugfs(struct MPT3SAS_ADAPTER *ioc);
 void mpt3sas_init_debugfs(void);
 void mpt3sas_exit_debugfs(void);
 
+#if IS_REACHABLE(CONFIG_HWMON)
+int mpt3sas_hwmon_register(struct MPT3SAS_ADAPTER *ioc);
+void mpt3sas_hwmon_unregister(struct MPT3SAS_ADAPTER *ioc);
+#else
+static inline int mpt3sas_hwmon_register(struct MPT3SAS_ADAPTER *ioc)
+{
+	return 0;
+}
+
+static inline void mpt3sas_hwmon_unregister(struct MPT3SAS_ADAPTER *ioc)
+{
+}
+#endif
+
 /**
  * _scsih_is_pcie_scsi_device - determines if device is an pcie scsi device
  * @device_info: bitfield providing information about the device.
diff --git a/drivers/scsi/mpt3sas/mpt3sas_hwmon.c b/drivers/scsi/mpt3sas/mpt3sas_hwmon.c
new file mode 100644
index 000000000000..6941f50b8aba
--- /dev/null
+++ b/drivers/scsi/mpt3sas/mpt3sas_hwmon.c
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Hardware monitoring (hwmon) support for the LSI / Broadcom mpt3sas
+ * SAS HBA driver. Exposes the IOC and board temperature sensors by
+ * reading MPI IO Unit Page 7.
+ */
+
+#include <linux/err.h>
+#include <linux/hwmon.h>
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
+static int _hwmon_to_mdegc(s16 raw, u8 units, long *out)
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
+static umode_t _hwmon_is_visible(const void *drvdata,
+				 enum hwmon_sensor_types type,
+				 u32 attr, int channel)
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
+static int _hwmon_read(struct device *dev, enum hwmon_sensor_types type,
+		       u32 attr, int channel, long *val)
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
+static int _hwmon_read_string(struct device *dev,
+			      enum hwmon_sensor_types type,
+			      u32 attr, int channel, const char **str)
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
+int mpt3sas_hwmon_register(struct MPT3SAS_ADAPTER *ioc)
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
+void mpt3sas_hwmon_unregister(struct MPT3SAS_ADAPTER *ioc)
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


Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A30F4A13B0
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2026 16:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781023522; cv=none; b=NhkUZp206ZLpNczz0gnv7WqFfTFwi/gA4HCBu8aGNEvTy5gn4GM9bGNC+MGimbkGVGRIOdLdT5AdKzBISekfhPUpOQhwVwDBFygB/CiGgsrIjEMCHDNPYiXc4EhC137ZOgyldGVbZRIImU0WAN54U0K3JFV9cbU5uAi5z37Usdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781023522; c=relaxed/simple;
	bh=q6nh2I0IJZkv6Er5gFdVYCsD7i1PPhsOiOfEvHDC0mM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ot8Rf03aTYIj0A9xKn/6D9rwbUe7VH4W3Fm/+HmlcFnDsgG7V6np8DyyCUech/qBXbkgKVWwZI/hvIHvgLK1GIPcVLSa578lynlFKUOYCGXKp0f0Zo0F0ASV1nc5vsmVRQ7XzwXWpFNg600PhSmWcMG/v1wbHlmyo4Dwe6f0GLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=COhzUYmB; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="COhzUYmB"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-45ef82204c6so3140222f8f.3
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jun 2026 09:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781023519; x=1781628319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b4S5uxuhqvO1rYma67W1OJrzGbqLrgJBV9Tf3hpikpE=;
        b=COhzUYmBxOJJ9Tem71qpRcCM90rQJKJDgytYvE0Ov8YbTtoTpD9ufkAW9VbN05wCOr
         tZY5RtjD6Ul7n7ZCHLvnTEB0nEe8BGlknJ03UOcA4fBVKrthwLYpgfp/VgPngUev1u0A
         lQtKJyMPIutB31PzhlSUX5EU/jb5TR2U5VE5wDdRa/xOwfPU5VPjNO6X4WJwx57ky2P3
         PP35r2vG2FE/efAQ4ra5mdja/xqKRcrMPu3yw8jYsWn9SpyfugAN2nhUGuisCvuTsM9s
         yuuQrN/j8Q1j0uUZpGjNanDtuTVNTHsxerwdIEVuV2JkAzh28yYOribnd36aW36CyxRx
         9HVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781023519; x=1781628319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b4S5uxuhqvO1rYma67W1OJrzGbqLrgJBV9Tf3hpikpE=;
        b=dhtXsD9OaoiNJLBt9X1Pb0+QrC5dI2gscWoS+ZDeRuUiL+FmyvGMUWNymyao7NLGo2
         iIFTqyr8p+DrGQWbawAp2p2RxAMOIt/NuqwCUGu+Ds0l3pOUExw2BizwHYb4Nclk3Cz3
         ipBKvXpQWmOyk8Fld2tq0E/5Z+6lbuk4iPLiAgKZ/bPv28aCBRuV8Ie+PhAy2jCOoKFO
         JFaLNgiKH+e9roRIzUbvAdVTmOW2xzQe0qSWYOqwRB5+6pjOkit9cAQ/F8CfoYr8KYjb
         mZFlh1sDGWVatE5Fx6geBPmmJPjusUqJD5/cZiei7vhPH/ac939O9BKFeAv7RVRqfqgw
         EKhg==
X-Forwarded-Encrypted: i=1; AFNElJ/5ccmt9LYbYUjr5T1YXKlw2dKEaqYmQdOrC3R8og5OWIIhOKMq0Maw6q8k1uMlrdZMTgZD5PuY7KSe@vger.kernel.org
X-Gm-Message-State: AOJu0YyI8SitZ0W0bfx1FL2+05zQgIuLekTzD3XC5XX8cHcGbmdwboQv
	+LFiq6y3suYR5iDrJXBV+ZZ5p7B/VNvFS6UrKW4CTQ1/vVo6kfEyobqk
X-Gm-Gg: Acq92OF30w1K8kqocYDQRu6XAXAvZx2eY3MV9iXnsM87Qd1F4vph/KGzNMRa5irUDB7
	gsAF5vaoqIcAW6gLs9dI/aH4GQNowgr7JzaAcvbFzagZTDKcyUHtcEetiz/aiP7om2lzUQXnVgo
	4/vszg6U3MwTgxjipIVwRkEbqj0TsJTx8cvdt/ukOmpTaYjP8WzoU6ulNat5E5dE9RKdFj7MJTE
	Om3mXR0FxLn+TRgonMuguxCwU7GBJAoNzpzgCAU/QKvKbi4Qm+msWRs1W7q0OOC9FrJ4M/sGV5J
	XUoyVcMVuM6nf71wHQ7+yE3bv60yqqsUaa8WkeEenGZ/6pgnUqlgp3Vc0KZDpwqr2GM8GgEWZMs
	x2jzWSXlNBM5V9UZFNNJV04xwhGmaFyvqJ3HhV5c1fuvou/0Td7R/rAmRvtJiGbzylvZ4cTG1zs
	a4k33Ehw4Mml+Xfr42
X-Received: by 2002:adf:ea51:0:b0:460:18e9:c0da with SMTP id ffacd0b85a97d-460302e32aamr25328714f8f.10.1781023518822;
        Tue, 09 Jun 2026 09:45:18 -0700 (PDT)
Received: from localhost ([2603:c027:c000:3cde::f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcbe3sm59351635f8f.8.2026.06.09.09.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 09:45:18 -0700 (PDT)
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
Subject: [PATCH v3 RESEND 2/2] scsi: mpt3sas: add hwmon support
Date: Tue,  9 Jun 2026 18:44:23 +0200
Message-ID: <20260609164423.2829699-3-sautier.louis@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260609164423.2829699-1-sautier.louis@gmail.com>
References: <20260609164423.2829699-1-sautier.louis@gmail.com>
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
 drivers/scsi/mpt3sas/Kconfig         |   9 ++
 drivers/scsi/mpt3sas/Makefile        |   2 +
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  17 +++
 drivers/scsi/mpt3sas/mpt3sas_hwmon.c | 200 +++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   6 +
 5 files changed, 234 insertions(+)
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_hwmon.c

diff --git a/drivers/scsi/mpt3sas/Kconfig b/drivers/scsi/mpt3sas/Kconfig
index c299f7e078fb..a2e1e112b7a3 100644
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
+	through hwmon.
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


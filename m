Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97362D057;
	Tue,  4 Feb 2025 14:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738679671; cv=none; b=mHH0BolEZv7ewHkIcvJl8BuisdPsxWYOrKH/8Q9UUf3BQgedCooDVeq8fhqArzhQ6vJs8LoktS44h+pIRLMVVHyXP8Ziy5Jdaz1aMGYo5yOUks2tl3tB0QasbRCOZYYo4xTSzDl9BVDbzE1OAhDqEgtCICJ2YvCerRPmzIRwmkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738679671; c=relaxed/simple;
	bh=ge2naNcPWKe06IeHRrWkR+VT+GT+fI/8lCrjkF20Pa0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SDMDIxHPdI4cGtgF/rZCx5XRs1YdOMFltv5j6NeIiL3YD8QsxLtahsI3ybzzvZFqIY6pLKbUNkz/DY7VoUtcjDyPCGqM//W2Hu+AvX/tNNd4+0PKrMl9yUy/HOXP4IBaQvd12A+DXZEknX6LGRqH9fgWLwg/Wts2cTW71fTTmgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=avqDZDQZ; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="avqDZDQZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738679670; x=1770215670;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ge2naNcPWKe06IeHRrWkR+VT+GT+fI/8lCrjkF20Pa0=;
  b=avqDZDQZ45DNMokQTrd0bioOGkx4d3jyklZLdO/HTZOGoZhmU6DXt5Ke
   iWG5MDwW7RKTMwA6U8hk0GQtmOcO5v/uimC2ffh6esYxfZ7T5G63RnjAM
   RHgbw6XG9LHnilPhCHyhR9Q1j3KI/VsHgw0Qoy+ejlo1KwwPAZLBqRumX
   5vgSEfMwzNJX05RLfAu1GpcewXDtSPyuALp+2RJj8uxiTv+LbVeCgblPe
   BdUTJH2EQMt9NudkjAlLOM5DC91DKJ/Gwds3iaXxnxqfJu4QtBgkF+p2M
   rPKH37aWA+0qiTS2j4SGdkcvu7fofkGlkFBjrgAFIkMw4q/czG4yiaEsn
   g==;
X-CSE-ConnectionGUID: i4juYKswRmi6hP1+I2w0uQ==
X-CSE-MsgGUID: GOMG6cgfQo+66LK81+StdA==
X-IronPort-AV: E=Sophos;i="6.13,258,1732550400"; 
   d="scan'208";a="36951506"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2025 22:34:23 +0800
IronPort-SDR: 67a217c7_a1vM+cmtz/7sATJn/XBeH/odrNQPnfWCnDGM72KlA+Zx0F5
 AmTF3C+t0Q9g8uAoqM+w48/SZbtllPmnbbo+unQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Feb 2025 05:36:07 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Feb 2025 06:34:22 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2] scsi: ufs: critical health condition
Date: Tue,  4 Feb 2025 16:31:24 +0200
Message-Id: <20250204143124.1252912-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Martin hi,

The UFS4.1 standard, released on January 8, 2025, is adding several new
features. Among them is a new exception event: HEALTH_CRITICAL, which
notifies the host of a device's critical health condition. This
notification implies that the device is approaching the end of its
lifetime based on the amount of performed program/erase cycles.

Once an EOL (End-of-Life) exception event is received, we toggle a
`dev_info` designated member, which is exposed via a `sysfs` entry.
This new `sysfs` entry, will indicate whether a critical health
condition has been detected (1) or not (0).

To handle this new `sysfs` entry, `udev` rules should be configured to
monitor changes in the `critical_health` attribute. When the attribute
value changes to 1, indicating a critical health condition, `udev` can
trigger a user-space script or application to notify the user or take
appropriate actions.

The host can gain further insight into the specific issue by reading one
of the following attributes: bPreEOLInfo, bDeviceLifeTimeEstA,
bDeviceLifeTimeEstB, bWriteBoosterBufferLifeTimeEst, and
bRPMBLifeTimeEst. All those are available for reading via the driver's
sysfs entries or through an applicable utility. It is up to user-space
to read these attributes if needed.

Please consider this for the next merge window.

Thanks,
Avri

Signed-off-by: Avri Altman <avri.altman@wdc.com>

---
Changes in v2:
 - withdraw from using hw-monitor subsystem (Guenter)
---
 Documentation/ABI/testing/sysfs-driver-ufs | 13 +++++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 10 ++++++++++
 drivers/ufs/core/ufshcd.c                  |  6 ++++++
 include/ufs/ufs.h                          |  4 ++++
 4 files changed, 33 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 5fa6655aee84..a74ea70bcee4 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1559,3 +1559,16 @@ Description:
 		Symbol - HCMID. This file shows the UFSHCD manufacturer id.
 		The Manufacturer ID is defined by JEDEC in JEDEC-JEP106.
 		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/critical_health
+What:		/sys/bus/platform/devices/*.ufs/critical_health
+Date:		February 2025
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:	indicate whether a critical health condition has been detected
+		(1) or not (0). further insight into the specific issue can be
+		gained by reading one of: bPreEOLInfo, bDeviceLifeTimeEstA,
+		bDeviceLifeTimeEstB, bWriteBoosterBufferLifeTimeEst, and
+		bRPMBLifeTimeEst.
+
+		The file is read only.
+
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 3438269a5440..84de3e558a55 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -458,6 +458,14 @@ static ssize_t pm_qos_enable_store(struct device *dev,
 	return count;
 }
 
+static ssize_t critical_health_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%d\n", hba->dev_info.critical_health);
+}
+
 static DEVICE_ATTR_RW(rpm_lvl);
 static DEVICE_ATTR_RO(rpm_target_dev_state);
 static DEVICE_ATTR_RO(rpm_target_link_state);
@@ -470,6 +478,7 @@ static DEVICE_ATTR_RW(enable_wb_buf_flush);
 static DEVICE_ATTR_RW(wb_flush_threshold);
 static DEVICE_ATTR_RW(rtc_update_ms);
 static DEVICE_ATTR_RW(pm_qos_enable);
+static DEVICE_ATTR_RO(critical_health);
 
 static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rpm_lvl.attr,
@@ -484,6 +493,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_wb_flush_threshold.attr,
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
+	&dev_attr_critical_health.attr,
 	NULL
 };
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index cd404ade48dc..950878c0bb01 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6216,6 +6216,9 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 	if (status & hba->ee_drv_mask & MASK_EE_URGENT_TEMP)
 		ufshcd_temp_exception_event_handler(hba, status);
 
+	if (status & hba->ee_drv_mask & MASK_EE_HEALTH_CRITICAL)
+		hba->dev_info.critical_health = true;
+
 	ufs_debugfs_exception_event(hba, status);
 }
 
@@ -8308,6 +8311,9 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	ufshcd_temp_notif_probe(hba, desc_buf);
 
+	if (dev_info->wspecversion >= 0x410)
+		ufshcd_enable_ee(hba, MASK_EE_HEALTH_CRITICAL);
+
 	ufs_init_rtc(hba, desc_buf);
 
 	/*
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 89672ad8c3bb..d25083098f66 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -419,6 +419,7 @@ enum {
 	MASK_EE_TOO_LOW_TEMP		= BIT(4),
 	MASK_EE_WRITEBOOSTER_EVENT	= BIT(5),
 	MASK_EE_PERFORMANCE_THROTTLING	= BIT(6),
+	MASK_EE_HEALTH_CRITICAL		= BIT(9),
 };
 #define MASK_EE_URGENT_TEMP (MASK_EE_TOO_HIGH_TEMP | MASK_EE_TOO_LOW_TEMP)
 
@@ -589,6 +590,9 @@ struct ufs_dev_info {
 	u32 rtc_update_period;
 
 	u8 rtt_cap; /* bDeviceRTTCap */
+
+	/* HEALTH_CRITICAL exception reported */
+	bool critical_health;
 };
 
 /*
-- 
2.25.1


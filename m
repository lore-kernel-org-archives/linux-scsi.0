Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABC7209F59;
	Mon,  3 Feb 2025 15:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738596651; cv=none; b=Qrb+is9c4xWlgnFKlFGAor2/EvvdjJAJcAODDqlRamsXK7b1CEbEH8v6Hz7wxPjlz6lo0ZJxn01sGjFb2a/qoIJVh0Iv/LFlK/BRM00CE2G4dgzCCLk/H1Y2CUaKCnvnZh6bd8vz+oEwZwwVPri0Sm7jXOslsXSvvGpMgk2/LVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738596651; c=relaxed/simple;
	bh=3Tt41DcaDXGlLXYMvRGQ2OROmQPcbjs9ADeuAa7WHkQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RrC29c8Yl5h3tdbMwMzf2/g5kJsEMa0AQz/ycssnCnLifjLiYOz9gkEEmzd8wjh/S3wFJYKrxw+WQPU4NV1hZMyEp6jHgMCoPdx0XYp6uQ99ckXV+IvrSbm7fHBfxnGr1eYOFd6RyS121rgRZ/sSrNTWqqnQHwnlZiCEYvbPpcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=C2rQV2kT; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="C2rQV2kT"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738596649; x=1770132649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3Tt41DcaDXGlLXYMvRGQ2OROmQPcbjs9ADeuAa7WHkQ=;
  b=C2rQV2kTW1eTBrJNaKbU4e7jyPUGywgNlmNvUdi2bWjUYir/xNTvHsT0
   XfZ6BtNdjouuNrUiSELXRty2tATO61c72keJuqH0pPlDNXFy13mA65wYz
   DknJiTrUr/OhCKFYRKZEvtg+f9d2GVBDkAvWbtFB7Pylz7xLBnOn3LkXo
   QcgQpBM2ULAPvjsuvMhd4HvNR0zsZcTPdV87K4oKXEiohHZrxlJD5RjZZ
   UKdUUiXvdxQXuH4coqeg3jsMgeC5StP//WW4NCL6tQGg9oMslcvkqzIwj
   hTFJNo23xrHZc4seNFSL+++u13XLk8jX29yXyxOfjBmvoutRimIr7GlwG
   Q==;
X-CSE-ConnectionGUID: R2ruNb1VS6+1gRnv6Nh4Hw==
X-CSE-MsgGUID: QPpShF4hQGOw8OAXeetxsQ==
X-IronPort-AV: E=Sophos;i="6.13,256,1732550400"; 
   d="scan'208";a="38686225"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2025 23:30:49 +0800
IronPort-SDR: 67a0d382_YHb+hISC1C6Xp7XbUJrOWoEBKn39YFgZbPeQxpr9fyHj2oX
 GyT9a5poKkupqufgPm9ObdAvnLP459nB16ljWCA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Feb 2025 06:32:35 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Feb 2025 07:30:47 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guenter Roeck <linux@roeck-us.net>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 2/2] scsi: ufs: Add support for critical health notification
Date: Mon,  3 Feb 2025 17:27:35 +0200
Message-Id: <20250203152735.825010-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250203152735.825010-1-avri.altman@wdc.com>
References: <20250203152735.825010-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The UFS 4.1 standard, released on January 8, 2025, introduces several
new features, including a new exception event: HEALTH_CRITICAL. This
event notifies the host of a device's critical health condition,
indicating that the device is approaching the end of its lifetime based
on the number of program/erase cycles performed.

We utilize the hwmon (hardware monitoring) subsystem to propagate this
information via the chip alarm channel.

The host can gain further insight into the specific issue by reading one
of the following attributes: bPreEOLInfo, bDeviceLifeTimeEstA,
bDeviceLifeTimeEstB, bWriteBoosterBufferLifeTimeEst, and
bRPMBLifeTimeEst. However, we do not provide the corresponding .read
method in the hwmon subsystem. This is intentional: all other
end-of-life (EOL) signals are available for reading via the driver's
sysfs entries or through an applicable utility. It is up to user-space
to read these attributes if needed. It is not the kernel's
responsibility to interpret any EOL signals, as they may vary from
vendor to vendor.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufs-hwmon.c |  4 ++++
 drivers/ufs/core/ufshcd.c    | 15 +++++++++++++++
 include/ufs/ufs.h            |  1 +
 3 files changed, 20 insertions(+)

diff --git a/drivers/ufs/core/ufs-hwmon.c b/drivers/ufs/core/ufs-hwmon.c
index db28f456b923..410dc6568de5 100644
--- a/drivers/ufs/core/ufs-hwmon.c
+++ b/drivers/ufs/core/ufs-hwmon.c
@@ -149,6 +149,7 @@ static umode_t ufs_hwmon_is_visible(const void *data,
 
 static const struct hwmon_channel_info *const ufs_hwmon_info[] = {
 	HWMON_CHANNEL_INFO(temp, HWMON_T_ENABLE | HWMON_T_INPUT | HWMON_T_CRIT | HWMON_T_LCRIT),
+	HWMON_CHANNEL_INFO(chip, HWMON_C_ALARMS),
 	NULL
 };
 
@@ -209,4 +210,7 @@ void ufs_hwmon_notify_event(struct ufs_hba *hba, u16 ee_mask)
 
 	if (ee_mask & MASK_EE_TOO_LOW_TEMP)
 		hwmon_notify_event(hba->hwmon_device, hwmon_temp, hwmon_temp_min_alarm, 0);
+
+	if (ee_mask & MASK_EE_HEALTH_CRITICAL)
+		hwmon_notify_event(hba->hwmon_device, hwmon_chip, hwmon_chip_alarms, 0);
 }
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9fbaf74b0fef..407dc1acca0f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6198,6 +6198,9 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 	if (status & hba->ee_drv_mask & MASK_EE_URGENT_TEMP)
 		ufs_hwmon_notify_event(hba, status & MASK_EE_URGENT_TEMP);
 
+	if (status & hba->ee_drv_mask & MASK_EE_HEALTH_CRITICAL)
+		ufs_hwmon_notify_event(hba, status & MASK_EE_HEALTH_CRITICAL);
+
 	ufs_debugfs_exception_event(hba, status);
 }
 
@@ -8091,12 +8094,24 @@ static void ufshcd_temp_notif_probe(struct ufs_hba *hba, const u8 *desc_buf, u16
 		*mask |= MASK_EE_TOO_HIGH_TEMP;
 }
 
+static void ufshcd_critical_health_probe(struct ufs_hba *hba, u16 *mask)
+{
+	struct ufs_dev_info *dev_info = &hba->dev_info;
+
+	if (dev_info->wspecversion < 0x410)
+		return;
+
+	*mask |= MASK_EE_HEALTH_CRITICAL;
+}
+
 static void ufshcd_hwmon_probe(struct ufs_hba *hba, const u8 *desc_buf)
 {
 	u16 mask = 0;
 
 	ufshcd_temp_notif_probe(hba, desc_buf, &mask);
 
+	ufshcd_critical_health_probe(hba, &mask);
+
 	if (mask) {
 		ufshcd_enable_ee(hba, mask);
 		ufs_hwmon_probe(hba, mask);
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index f151feb0ca8c..8a24ed59ec46 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -419,6 +419,7 @@ enum {
 	MASK_EE_TOO_LOW_TEMP		= BIT(4),
 	MASK_EE_WRITEBOOSTER_EVENT	= BIT(5),
 	MASK_EE_PERFORMANCE_THROTTLING	= BIT(6),
+	MASK_EE_HEALTH_CRITICAL		= BIT(9),
 };
 #define MASK_EE_URGENT_TEMP (MASK_EE_TOO_HIGH_TEMP | MASK_EE_TOO_LOW_TEMP)
 
-- 
2.25.1


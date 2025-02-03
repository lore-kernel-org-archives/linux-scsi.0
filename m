Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DEE17C8B;
	Mon,  3 Feb 2025 15:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738596644; cv=none; b=S+/gsGIx6Qm1XLPkQmTanaPL3Tr4DADfILqnO08RoFlRqcR+6Y7l2ELc3UYhv9mYeMYE2UAHD51sFpQZWm/vJMjMFJ/0pOxpgjAfwXzNTWTU345Fg7bMm0bWwdxV7dsFGxJgLtZgEoyBTTOgMfQ3MzFSK82aQcYjVLbzErSEUh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738596644; c=relaxed/simple;
	bh=mN7908q95XpmYyAzNk2iOlCs+WZjHA/RwrszHzGTNSQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PjG7B7Q0BybG560V6/P7oBRH7seExV4mNd4QzcxkpecG0L1PF0KAYWtNqzKZ0GcjKin/nq2s0K0oNk5GggQj3GihVM9qYl1KwzDg9VZB0cKh8EFIIvKGnnHQ4x8+y/JnNsV2cv6AotvSJbVZWwOJO1mgwqjYRTASmNdpVzFDEe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bc5U7Asf; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bc5U7Asf"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738596643; x=1770132643;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mN7908q95XpmYyAzNk2iOlCs+WZjHA/RwrszHzGTNSQ=;
  b=bc5U7AsfQbM4BJGwf2P6ocgNQuWCeR4UQ7JE/20fNVN4M9qhO/SV+BKv
   DIv/muB2M5PheWTSdQrKqvYsYsqvUks9RDUe0Yucdwck8F+/Da4N/h3XI
   5m6GXmIB0WhltQRwvvQ9k0q+yTRspYV5edbY9xNPIyuBSIMnjyASpxbqe
   b/96ffR7h52DclM8XEAGT/H8c+P/vSkrfyNVRgZ5VinpbbnpR0rbi+EpB
   5erD9H/p+YSY0Rkjp/XlwVR8Ft2VbLxT4ZShUJkxdZFztOIIcHA/4nX/w
   wn6PUN7AfUVt1C0rj6DKacvTmC/bDkdaT3+zRMH1PyH/XY7uj4k/YV4Pe
   g==;
X-CSE-ConnectionGUID: 0Wt8yFlVRcWXlpkzK6FcdA==
X-CSE-MsgGUID: TnmDX4E1SJO1OF+w+9l5Mg==
X-IronPort-AV: E=Sophos;i="6.13,256,1732550400"; 
   d="scan'208";a="37449432"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2025 23:30:41 +0800
IronPort-SDR: 67a0d37a_bwnZMe2NMio9kWuIDRE4UxZ5niefzs3govOjDWxcextIXcM
 0wcsiovuvJwwvj1M7LzKpKgsMcriUqfMgH16D5Q==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Feb 2025 06:32:26 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Feb 2025 07:30:39 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guenter Roeck <linux@roeck-us.net>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 1/2] scsi: ufs: hwmon: Prepare for more hwmon notifications
Date: Mon,  3 Feb 2025 17:27:34 +0200
Message-Id: <20250203152735.825010-2-avri.altman@wdc.com>
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

This commit updates the UFS hwmon driver to prepare for handling more
hardware monitoring notifications. Specifically, it changes the type of
the `mask` parameter from `u8` to `u16` to accommodate additional
notification types.

While at it, the Kconfig entry for `CONFIG_SCSI_UFS_HWMON` has been
updated to better reflect its purpose. The description has been changed
from "UFS Temperature Notification" to "UFS Hardware Monitoring" to
indicate that the driver now supports a broader range of hardware
monitoring notifications beyond just temperature.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/Kconfig       |  2 +-
 drivers/ufs/core/ufs-hwmon.c   |  8 ++++----
 drivers/ufs/core/ufshcd-priv.h |  8 ++++----
 drivers/ufs/core/ufshcd.c      | 16 +++++++++++-----
 4 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/ufs/core/Kconfig b/drivers/ufs/core/Kconfig
index 817208ee64ec..dd3b79ac79be 100644
--- a/drivers/ufs/core/Kconfig
+++ b/drivers/ufs/core/Kconfig
@@ -43,7 +43,7 @@ config SCSI_UFS_FAULT_INJECTION
 	  to test the UFS error handler and abort handler.
 
 config SCSI_UFS_HWMON
-	bool "UFS Temperature Notification"
+	bool "UFS Hardware Monitoring"
 	depends on SCSI_UFSHCD=HWMON || HWMON=y
 	help
 	  This provides support for UFS hardware monitoring. If enabled,
diff --git a/drivers/ufs/core/ufs-hwmon.c b/drivers/ufs/core/ufs-hwmon.c
index 34194064367f..db28f456b923 100644
--- a/drivers/ufs/core/ufs-hwmon.c
+++ b/drivers/ufs/core/ufs-hwmon.c
@@ -12,10 +12,10 @@
 
 struct ufs_hwmon_data {
 	struct ufs_hba *hba;
-	u8 mask;
+	u16 mask;
 };
 
-static int ufs_read_temp_enable(struct ufs_hba *hba, u8 mask, long *val)
+static int ufs_read_temp_enable(struct ufs_hba *hba, u16 mask, long *val)
 {
 	u32 ee_mask;
 	int err;
@@ -163,7 +163,7 @@ static const struct hwmon_chip_info ufs_hwmon_hba_info = {
 	.info	= ufs_hwmon_info,
 };
 
-void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask)
+void ufs_hwmon_probe(struct ufs_hba *hba, u16 mask)
 {
 	struct device *dev = hba->dev;
 	struct ufs_hwmon_data *data;
@@ -199,7 +199,7 @@ void ufs_hwmon_remove(struct ufs_hba *hba)
 	kfree(data);
 }
 
-void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask)
+void ufs_hwmon_notify_event(struct ufs_hba *hba, u16 ee_mask)
 {
 	if (!hba->hwmon_device)
 		return;
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 786f20ef2238..279c3e8d1b21 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -33,13 +33,13 @@ static inline bool ufshcd_is_wb_buf_flush_allowed(struct ufs_hba *hba)
 }
 
 #ifdef CONFIG_SCSI_UFS_HWMON
-void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask);
+void ufs_hwmon_probe(struct ufs_hba *hba, u16 mask);
 void ufs_hwmon_remove(struct ufs_hba *hba);
-void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask);
+void ufs_hwmon_notify_event(struct ufs_hba *hba, u16 ee_mask);
 #else
-static inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) {}
+static inline void ufs_hwmon_probe(struct ufs_hba *hba, u16 mask) {}
 static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
-static inline void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask) {}
+static inline void ufs_hwmon_notify_event(struct ufs_hba *hba, u16 ee_mask) {}
 #endif
 
 int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f6c38cf10382..9fbaf74b0fef 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8074,11 +8074,10 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, const u8 *desc_buf)
 	hba->caps &= ~UFSHCD_CAP_WB_EN;
 }
 
-static void ufshcd_temp_notif_probe(struct ufs_hba *hba, const u8 *desc_buf)
+static void ufshcd_temp_notif_probe(struct ufs_hba *hba, const u8 *desc_buf, u16 *mask)
 {
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 	u32 ext_ufs_feature;
-	u8 mask = 0;
 
 	if (!(hba->caps & UFSHCD_CAP_TEMP_NOTIF) || dev_info->wspecversion < 0x300)
 		return;
@@ -8086,10 +8085,17 @@ static void ufshcd_temp_notif_probe(struct ufs_hba *hba, const u8 *desc_buf)
 	ext_ufs_feature = get_unaligned_be32(desc_buf + DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
 
 	if (ext_ufs_feature & UFS_DEV_LOW_TEMP_NOTIF)
-		mask |= MASK_EE_TOO_LOW_TEMP;
+		*mask |= MASK_EE_TOO_LOW_TEMP;
 
 	if (ext_ufs_feature & UFS_DEV_HIGH_TEMP_NOTIF)
-		mask |= MASK_EE_TOO_HIGH_TEMP;
+		*mask |= MASK_EE_TOO_HIGH_TEMP;
+}
+
+static void ufshcd_hwmon_probe(struct ufs_hba *hba, const u8 *desc_buf)
+{
+	u16 mask = 0;
+
+	ufshcd_temp_notif_probe(hba, desc_buf, &mask);
 
 	if (mask) {
 		ufshcd_enable_ee(hba, mask);
@@ -8288,7 +8294,7 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	ufshcd_wb_probe(hba, desc_buf);
 
-	ufshcd_temp_notif_probe(hba, desc_buf);
+	ufshcd_hwmon_probe(hba, desc_buf);
 
 	ufs_init_rtc(hba, desc_buf);
 
-- 
2.25.1


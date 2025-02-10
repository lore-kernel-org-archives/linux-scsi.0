Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303472C9A;
	Mon, 10 Feb 2025 14:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739196097; cv=none; b=nZd3ybTF2TP7mRk84kiXaS1tzWMRWrMI5qOVVJg84y/L1CCcokDINEy7i82VUG9bShX/or/0KMbRXYhb6GjYMKpKYwHFRI2JMkSGJOrOgvM8I/DSzos7rUCtLd30O9FmexD2ZGHEeR4cB76fDf79CPDkEBAi1lwIwmJV213zoLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739196097; c=relaxed/simple;
	bh=FyEOJLA2xup0ux8mAaFQpgPZfZWmNKULHQS7sZdXji8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sRxhVTVeuCJ3bWVfcxfDNEem6vsnKAB8mJw2bDBQKF6e+M61NG5Pj0b65xwT4sT2+rcJOTZaxxJFKVcF2/2v+UPZ4XckHhN5lPbn6ftTAFxcjPGUqWQnM2NEDQYZN++TX+bTYRYJz57Dp5A+rREcIg0ArFEXYdHm8MQy4dg2Xl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JDX+DZfM; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JDX+DZfM"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1739196095; x=1770732095;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FyEOJLA2xup0ux8mAaFQpgPZfZWmNKULHQS7sZdXji8=;
  b=JDX+DZfMYFi2oNVvh39/RFB9l7b+EX0YHyZwkTiUy9pc6iDji0hI797+
   DVAFNMk3+uHOZikSvQ04wELDtAVpDenUNuLvD1mEA+T0a6rlEBPuyOPu7
   jxAf6HMze9ibL57IUN+O9npsHVJ9OEt/d1Uohs/BWaS1zIqdUj7s/yDFn
   cYP5fEqlxjx3qkIpg0LZUAmvvDmaH/+nqfnzQQFhw/9G7Fj3AxyiS+keg
   jSfnuwiroi1BQvs8pWw4f3l9Cg3wWIab8wDYVaheElZs4SVmGauM1HmWr
   hJ7xgysHk471HD6cnX5Lq6IUwl0CxitoAIIx8aKdLYo82CxQhHP0xTpft
   A==;
X-CSE-ConnectionGUID: 9T5KPCVZSvuzTfRrjaeTrg==
X-CSE-MsgGUID: RAz+bdyNROCtDraI3uCQDg==
X-IronPort-AV: E=Sophos;i="6.13,274,1732550400"; 
   d="scan'208";a="37467144"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2025 22:01:27 +0800
IronPort-SDR: 67a9f908_4iXPJZcxQIqqfbEAaHZQFzl+4mDkycTC/WgMLf6CAKuBYfU
 OB4ZUmlGqRtbkVQ1Zgmxh0d8G4iWjgv271X5NeA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Feb 2025 05:03:04 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Feb 2025 06:01:26 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3] scsi: ufs: critical health condition
Date: Mon, 10 Feb 2025 15:58:14 +0200
Message-Id: <20250210135814.50783-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Martin hi,

The UFS4.1 standard, released on January 8, 2025, added a new exception
event: HEALTH_CRITICAL, which notifies the host of a device's critical
health condition. This notification implies that the device is
approaching the end of its lifetime based on the amount of performed
program/erase cycles.

Once an EOL (End-of-Life) exception event is received, we increment a
designated member, which is exposed via a `sysfs` entry. This new entry,
will report the number of times a critical health event has been
reported by a UFS device.

To handle this new `sysfs` entry, either `udev` rules or some other
polling code can be configured to monitor changes in the
`critical_health` attribute.

The host can gain further insight into the specific issue by reading one
of the following attributes: bPreEOLInfo, bDeviceLifeTimeEstA,
bDeviceLifeTimeEstB, bWriteBoosterBufferLifeTimeEst, and
bRPMBLifeTimeEst. All those are available for reading via the driver's
sysfs entries or through an applicable utility. It is up to user-space
to read these attributes if needed.

Please consider this for the next merge window.

Signed-off-by: Avri Altman <avri.altman@wdc.com>

---
Changes in v3:
 - Report a counter instead of a Boolean (Bart)
 - Support polling (Bart)

Changes in v2:
 - withdraw from using hw-monitor subsystem (Guenter)
---
 Documentation/ABI/testing/sysfs-driver-ufs | 13 +++++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 10 ++++++++++
 drivers/ufs/core/ufshcd.c                  | 10 ++++++++++
 include/ufs/ufs.h                          |  1 +
 include/ufs/ufshcd.h                       |  4 ++++
 5 files changed, 38 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 5fa6655aee84..565d281a7dcd 100644
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
+Description:	Report the number of times a critical health event has been
+		reported by a UFS device. further insight into the specific
+		issue can be gained by reading one of: bPreEOLInfo,
+		bDeviceLifeTimeEstA, bDeviceLifeTimeEstB,
+		bWriteBoosterBufferLifeTimeEst, and bRPMBLifeTimeEst.
+
+		The file is read only.
+
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 3438269a5440..3899e34f6eae 100644
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
+	return sysfs_emit(buf, "%d\n", hba->critical_health);
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
index cd404ade48dc..ad4034fea6cc 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6216,6 +6216,11 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 	if (status & hba->ee_drv_mask & MASK_EE_URGENT_TEMP)
 		ufshcd_temp_exception_event_handler(hba, status);
 
+	if (status & hba->ee_drv_mask & MASK_EE_HEALTH_CRITICAL) {
+		hba->critical_health++;
+		sysfs_notify(&hba->dev->kobj, NULL, "critical_health");
+	}
+
 	ufs_debugfs_exception_event(hba, status);
 }
 
@@ -8308,6 +8313,11 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	ufshcd_temp_notif_probe(hba, desc_buf);
 
+	if (dev_info->wspecversion >= 0x410) {
+		hba->critical_health = 0;
+		ufshcd_enable_ee(hba, MASK_EE_HEALTH_CRITICAL);
+	}
+
 	ufs_init_rtc(hba, desc_buf);
 
 	/*
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 89672ad8c3bb..d335bff1a310 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -419,6 +419,7 @@ enum {
 	MASK_EE_TOO_LOW_TEMP		= BIT(4),
 	MASK_EE_WRITEBOOSTER_EVENT	= BIT(5),
 	MASK_EE_PERFORMANCE_THROTTLING	= BIT(6),
+	MASK_EE_HEALTH_CRITICAL		= BIT(9),
 };
 #define MASK_EE_URGENT_TEMP (MASK_EE_TOO_HIGH_TEMP | MASK_EE_TOO_LOW_TEMP)
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 650ff238cd74..81e35129ded0 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -962,6 +962,7 @@ enum ufshcd_mcq_opr {
  * @ufs_rtc_update_work: A work for UFS RTC periodic update
  * @pm_qos_req: PM QoS request handle
  * @pm_qos_enabled: flag to check if pm qos is enabled
+ * @critical_health: count of critical health exceptions
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -1130,6 +1131,9 @@ struct ufs_hba {
 	struct delayed_work ufs_rtc_update_work;
 	struct pm_qos_request pm_qos_req;
 	bool pm_qos_enabled;
+
+	/* HEALTH_CRITICAL exception reported */
+	int critical_health;
 };
 
 /**
-- 
2.25.1


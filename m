Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428CA26BDB6;
	Tue, 11 Feb 2025 07:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739257293; cv=none; b=A7Iq6qRyladyATG72mgJ6QkIpawh/l19pVnB/STv8Gn9csyeA3o9clF8NXA84czna+6VzUJlP7r2hGcyPoQCRVizOsnJ6nI8q+8bTM/glnizk0FakI0bS5TKStW78th1XhRMfNlVhvGdHWkV1TcaE5zj2oJ24/mM9ahOjoM7R8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739257293; c=relaxed/simple;
	bh=hqDljfFHrNOlqzlu27lGs8eeJ4ShXn6up9FSpMUeTjw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=atvPYDdW4MdSK8YGfSkw+9Fb3PiX3tBmfwg8oxhFWdLDjhwXszysEiMt3yVsT93DMz39ZmFaAad/9huBhj/qVNMNQaKRoqRSbBUeikk1/ap3FldsiCJLuG45R/EEnut5ZffB8fpEcI8BTzugzHbtZ871qiSgaW8T6jAGpBNNFM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=D2bIF71o; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="D2bIF71o"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1739257291; x=1770793291;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hqDljfFHrNOlqzlu27lGs8eeJ4ShXn6up9FSpMUeTjw=;
  b=D2bIF71oC8c9qrvVtV1671fBcAJDNYZXZ6PleiTAylvCDFtfbOkfu6IY
   k2s36PTMbxTFUyFMjYdxypL/dTHzujR3TssMNTeTdFBvEpAle0TU5JRQ1
   K/o3NYXlsrwZlfoU8Hb7hmxuLKazuqBvm5Xo4N/9tuInDF3Stqvr9g/Ta
   SRkDsPhjDp9sU+sL7fwdSU5TLw6ryRT/4YlW2PYSGczwz9ia1YpvaAXqv
   fyIZKpDmEspdLNSkdAW65T4EZj+TthsPbccfVpJbYAXG6kgdSYBrhweQj
   RETFgInjZWQ86kU7jsmElS2R/QrIQcUB/0Hb/KJnXQJIRvScAq5f9eLe1
   g==;
X-CSE-ConnectionGUID: 1TpPUzusTxOEUsz0R973dQ==
X-CSE-MsgGUID: Dh0R07ChTHqsno9LK3TDgg==
X-IronPort-AV: E=Sophos;i="6.13,276,1732550400"; 
   d="scan'208";a="37908063"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2025 15:01:30 +0800
IronPort-SDR: 67aae819_QyEQFj/R9TiExno32sZG7VIbMzT4fTgVV4jqHvuxyhELs80
 LtFJwGCSu0TiK6tb0nKDBJNVNXeml+3p/3TmijQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Feb 2025 22:03:06 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Feb 2025 23:01:29 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4] scsi: ufs: critical health condition
Date: Tue, 11 Feb 2025 08:58:13 +0200
Message-Id: <20250211065813.58091-1-avri.altman@wdc.com>
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

To handle this new `sysfs` entry, userspace applications can use
`select()`, `poll()`, or `epoll()` to monitor changes in the
`critical_health` attribute. The kernel will call `sysfs_notify()` to
signal changes, allowing the userspace application to detect and respond
to these changes efficiently.

The host can gain further insight into the specific issue by reading one
of the following attributes: bPreEOLInfo, bDeviceLifeTimeEstA,
bDeviceLifeTimeEstB, bWriteBoosterBufferLifeTimeEst, and
bRPMBLifeTimeEst. All those are available for reading via the driver's
sysfs entries or through an applicable utility. It is up to user-space
to read these attributes if needed.

Please consider this for the next merge window.

Signed-off-by: Avri Altman <avri.altman@wdc.com>

---
Changes in v4:
 - Elaborate commit log (Bart)
 - Change the variable name to critical_health_count (Bart)

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
 include/ufs/ufshcd.h                       |  3 +++
 5 files changed, 37 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 5fa6655aee84..2ace962cb5ef 100644
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
+		reported by a UFS device. Further insight into the specific
+		issue can be gained by reading one of: bPreEOLInfo,
+		bDeviceLifeTimeEstA, bDeviceLifeTimeEstB,
+		bWriteBoosterBufferLifeTimeEst, and bRPMBLifeTimeEst.
+
+		The file is read only.
+
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 3438269a5440..90b5ab60f5ae 100644
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
+	return sysfs_emit(buf, "%d\n", hba->critical_health_count);
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
index cd404ade48dc..ef56a5eb52dc 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6216,6 +6216,11 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 	if (status & hba->ee_drv_mask & MASK_EE_URGENT_TEMP)
 		ufshcd_temp_exception_event_handler(hba, status);
 
+	if (status & hba->ee_drv_mask & MASK_EE_HEALTH_CRITICAL) {
+		hba->critical_health_count++;
+		sysfs_notify(&hba->dev->kobj, NULL, "critical_health");
+	}
+
 	ufs_debugfs_exception_event(hba, status);
 }
 
@@ -8308,6 +8313,11 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	ufshcd_temp_notif_probe(hba, desc_buf);
 
+	if (dev_info->wspecversion >= 0x410) {
+		hba->critical_health_count = 0;
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
index 650ff238cd74..5efa570de4c1 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -962,6 +962,7 @@ enum ufshcd_mcq_opr {
  * @ufs_rtc_update_work: A work for UFS RTC periodic update
  * @pm_qos_req: PM QoS request handle
  * @pm_qos_enabled: flag to check if pm qos is enabled
+ * @critical_health_count: count of critical health exceptions
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -1130,6 +1131,8 @@ struct ufs_hba {
 	struct delayed_work ufs_rtc_update_work;
 	struct pm_qos_request pm_qos_req;
 	bool pm_qos_enabled;
+
+	int critical_health_count;
 };
 
 /**
-- 
2.25.1


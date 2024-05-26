Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9108DDB1;
	Sun, 26 May 2024 08:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716711450; cv=none; b=sZKgkzEroDB4VywruoXea4oOQgYVOb5BCmEq6DDdfCvMdVMo0PJv7CAYjLlnQsAyGJHzmNgwh1/H9byox7KVd4MfDi4OLiPjB6bdE0mVLBvDZ8Kctaev24oyht/jqM0ptgb6HFAuJs655IAmJpz7OyC3jelT+n7lDSOU+OW59qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716711450; c=relaxed/simple;
	bh=82iiPS45Hw7sp9NIsgaE3UMiiOB6uJGN6zPAufQZWSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjGWPamHG4l2xb+nVfYGCAiD8uEeCJ2ltmc/wocs7H+1uRmu1QLC4l3uDJ1sYHU1IISvz4kR8Qp/Ip9Pheg8d+oHwJ3Xnvj9lDDhWvscjLWXUbwkZVCTIjKH76wc1Zv9w4u+coPJD5Zht8CQSYyYTV/IIIEpoTzMnK6SQmZ6vsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=QsLiCf6o; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="QsLiCf6o"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1716711449; x=1748247449;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=82iiPS45Hw7sp9NIsgaE3UMiiOB6uJGN6zPAufQZWSQ=;
  b=QsLiCf6oqD6yMgGKRPA8VKFzX7vovOG0YmwFChjae3dY8kj0xRL3iY5A
   a97nvJzfMJ06opPdmEL7+Js+AifZlfliP4A6y3yqC/IvLNLwwgfQ+h36p
   ULKdAe6cpqDmxA4pxrCXIbtTxKMrEI0eOVVfzSFsbQtZpJPcMVb0ShOE7
   NPS7QOT2LT6nX7nxkGx5fttW0BLt5A6UH8cR+AbdOOw1tQmmZZ0zhMpAe
   Uo0aHnSbOWet1UIaxbpQNSyS/mb1aQTNpp8WtEDihO9h1arhbiTDyPtq7
   2KltrdZbb8tHtr3ZetlObTFh0zw4cwz9e83FX7gAx6EhNpofU5qL2rNg8
   w==;
X-CSE-ConnectionGUID: V5sd2rmTRG+4LYxLdLwZ6w==
X-CSE-MsgGUID: iHDQFV45Sbi2KBznArwaJg==
X-IronPort-AV: E=Sophos;i="6.08,190,1712592000"; 
   d="scan'208";a="16614402"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 May 2024 16:17:22 +0800
IronPort-SDR: 6652e3c5_7akhMHIqKsHJz/AU+1GAIcTr6l6cIV9RziLbCI86A7kLexX
 kUu2vkLM8viaVSauHqEJqtYyfmq4mNsH6x+B4Vw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 May 2024 00:24:54 -0700
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 May 2024 01:17:20 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v6 3/3] scsi: ufs: sysfs: Make max_number_of_rtt read-write
Date: Sun, 26 May 2024 11:16:36 +0300
Message-ID: <20240526081636.2064-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240526081636.2064-1-avri.altman@wdc.com>
References: <20240526081636.2064-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Given the importance of the RTT parameter, we want to be able to
configure it via sysfs. This is because UFS users should be discouraged
from change UFS device parameters without the UFSHCI driver being aware
of these changes.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 14 +++--
 drivers/ufs/core/ufs-sysfs.c               | 68 +++++++++++++++++++++-
 drivers/ufs/core/ufshcd-priv.h             | 24 ++++++++
 3 files changed, 99 insertions(+), 7 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 5bf7073b4f75..fe943ce76c60 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -920,14 +920,16 @@ Description:	This file shows whether the configuration descriptor is locked.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_number_of_rtt
 What:		/sys/bus/platform/devices/*.ufs/attributes/max_number_of_rtt
-Date:		February 2018
-Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
+Date:		May 2024
+Contact:	Avri Altman <avri.altman@wdc.com>
 Description:	This file provides the maximum current number of
-		outstanding RTTs in device that is allowed. The full
-		information about the attribute could be found at
-		UFS specifications 2.1.
+		outstanding RTTs in device that is allowed. bMaxNumOfRTT is a
+		read-write persistent attribute and is equal to two after device
+		manufacturing. It shall not be set to a value greater than
+		bDeviceRTTCap value, and it may be set only when the hw queues are
+		empty.
 
-		The file is read only.
+		The file is read write.
 
 What:		/sys/bus/platform/drivers/ufshcd/*/attributes/exception_event_control
 What:		/sys/bus/platform/devices/*.ufs/attributes/exception_event_control
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 3d049967f6bc..48ac708b8795 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1340,6 +1340,73 @@ static const struct attribute_group ufs_sysfs_flags_group = {
 	.attrs = ufs_sysfs_device_flags,
 };
 
+static ssize_t max_number_of_rtt_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 rtt;
+	int ret;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+		QUERY_ATTR_IDN_MAX_NUM_OF_RTT, 0, 0, &rtt);
+	ufshcd_rpm_put_sync(hba);
+
+	if (ret)
+		goto out;
+
+	ret = sysfs_emit(buf, "0x%08X\n", rtt);
+
+out:
+	up(&hba->host_sem);
+	return ret;
+}
+
+static ssize_t max_number_of_rtt_store(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_dev_info *dev_info = &hba->dev_info;
+	unsigned int rtt;
+	int ret;
+
+	if (kstrtouint(buf, 0, &rtt))
+		return -EINVAL;
+
+	if (rtt > dev_info->rtt_cap) {
+		dev_err(dev, "rtt can be at most bDeviceRTTCap\n");
+		return -EINVAL;
+	}
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	ufshcd_freez_hw_queues(hba);
+
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+		QUERY_ATTR_IDN_MAX_NUM_OF_RTT, 0, 0, &rtt);
+
+	ufshcd_unfreez_hw_queues(hba);
+	ufshcd_rpm_put_sync(hba);
+
+out:
+	up(&hba->host_sem);
+	return ret < 0 ? ret : count;
+}
+
+static DEVICE_ATTR_RW(max_number_of_rtt);
+
 static inline bool ufshcd_is_wb_attrs(enum attr_idn idn)
 {
 	return idn >= QUERY_ATTR_IDN_WB_FLUSH_STATUS &&
@@ -1387,7 +1454,6 @@ UFS_ATTRIBUTE(max_data_in_size, _MAX_DATA_IN);
 UFS_ATTRIBUTE(max_data_out_size, _MAX_DATA_OUT);
 UFS_ATTRIBUTE(reference_clock_frequency, _REF_CLK_FREQ);
 UFS_ATTRIBUTE(configuration_descriptor_lock, _CONF_DESC_LOCK);
-UFS_ATTRIBUTE(max_number_of_rtt, _MAX_NUM_OF_RTT);
 UFS_ATTRIBUTE(exception_event_control, _EE_CONTROL);
 UFS_ATTRIBUTE(exception_event_status, _EE_STATUS);
 UFS_ATTRIBUTE(ffu_status, _FFU_STATUS);
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index f42d99ce5bf1..2cdbe6b48d96 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -32,6 +32,30 @@ static inline bool ufshcd_is_wb_buf_flush_allowed(struct ufs_hba *hba)
 		!(hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL);
 }
 
+static inline void ufshcd_freez_hw_queues(struct ufs_hba *hba)
+{
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, hba->host) {
+		if (sdev == hba->ufs_device_wlun)
+			continue;
+		blk_mq_freeze_queue(sdev->request_queue);
+		blk_mq_quiesce_queue(sdev->request_queue);
+	}
+}
+
+static inline void ufshcd_unfreez_hw_queues(struct ufs_hba *hba)
+{
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, hba->host) {
+		if (sdev == hba->ufs_device_wlun)
+			continue;
+		blk_mq_unquiesce_queue(sdev->request_queue);
+		blk_mq_unfreeze_queue(sdev->request_queue);
+	}
+}
+
 #ifdef CONFIG_SCSI_UFS_HWMON
 void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask);
 void ufs_hwmon_remove(struct ufs_hba *hba);
-- 
2.34.1


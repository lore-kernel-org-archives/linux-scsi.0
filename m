Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDF617D8B0;
	Thu, 30 May 2024 14:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717079131; cv=none; b=JzuyjG9icxK4NqbhGw4Q2uBj3E76xNJlPO9BkGlmEoPyhUkR4OTexKOc/vhwVvWT69fhnIGoXL7STN7db8+CkCDJ9JhNK/iVHoPrfudgoYUjNz8YITsXlz29qwWUCxiYJKiE6lPXzgoCWt+U4ygMhMLZwysIr1ZlTP3bJKiZZQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717079131; c=relaxed/simple;
	bh=7/QrT6jhzfNvn0Ke6Bta3BWpn8kfq5OdV84xVX7LB6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEIrWJYbgXmMEVA/gkQapMYjBydsHYew4Yx87ApYoWUL1O7cTlTUnICX9nT0EQLJtTdQew9aRDtAWXAsa6BbADL9HSmhowvHkSltQ7Nq6uBwy40nG4ZDkLALP22/XbKbZkiCNxeLfH42YYt4xHlW+wRO2pfYMoQg0KY1qr2Cay8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=eHV47qqj; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eHV47qqj"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1717079129; x=1748615129;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7/QrT6jhzfNvn0Ke6Bta3BWpn8kfq5OdV84xVX7LB6g=;
  b=eHV47qqjQFdUYBwf8rRHVfzoKjBF84NiWYJYC0IFg9C6v6kYiQ3ItXWy
   kFkm+FjCeThoJzcQMZrrKA9CNdv1wZDib36qQnlVihtYquN8cOHusMnvG
   xk1sX3HRGtvEcOBJOIPvs2IcBzJFqqlPOnkuA7eaJPwfyMsCX1ErGNOPT
   hQPbsc4n+J/iErlkuxNIrD8USz2e8FSkNGMxKMolUVGiDZvOC/Th1948U
   fe1YONpaYDbyIGn+5mipRMry8NiPoXcfnUpO7SYTIKh0b/b925UDLseYN
   +kWsp0JW0G8uudaVnsgXSxmX4k5CAph6QyWs1SmwTC4tNr1DUzOAS8f2h
   w==;
X-CSE-ConnectionGUID: oMhzLP1CTeScdcjxKm9TNw==
X-CSE-MsgGUID: oHg1sLYgR5+uGdKwp0sMbg==
X-IronPort-AV: E=Sophos;i="6.08,201,1712592000"; 
   d="scan'208";a="17923540"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 May 2024 22:25:29 +0800
IronPort-SDR: 66587eb3_ANzKSgMx/OSOTpIeEaAbD7rAeczJFgY9SMGGL+pUNUxHirz
 ly3jMLo2DbVq5VT+7XzUY/LNsrStecux26tLomA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 May 2024 06:27:16 -0700
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip01.wdc.com with ESMTP; 30 May 2024 07:25:28 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v7 3/3] scsi: ufs: sysfs: Make max_number_of_rtt read-write
Date: Thu, 30 May 2024 17:25:09 +0300
Message-ID: <20240530142510.734-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240530142510.734-1-avri.altman@wdc.com>
References: <20240530142510.734-1-avri.altman@wdc.com>
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
 drivers/ufs/core/ufs-sysfs.c               | 73 +++++++++++++++++++++-
 2 files changed, 80 insertions(+), 7 deletions(-)

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
index 3d049967f6bc..e80a32421a8c 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1340,6 +1340,78 @@ static const struct attribute_group ufs_sysfs_flags_group = {
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
+	struct scsi_device *sdev;
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
+
+	shost_for_each_device(sdev, hba->host)
+		blk_mq_freeze_queue(sdev->request_queue);
+
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+		QUERY_ATTR_IDN_MAX_NUM_OF_RTT, 0, 0, &rtt);
+
+	shost_for_each_device(sdev, hba->host)
+		blk_mq_unfreeze_queue(sdev->request_queue);
+
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
@@ -1387,7 +1459,6 @@ UFS_ATTRIBUTE(max_data_in_size, _MAX_DATA_IN);
 UFS_ATTRIBUTE(max_data_out_size, _MAX_DATA_OUT);
 UFS_ATTRIBUTE(reference_clock_frequency, _REF_CLK_FREQ);
 UFS_ATTRIBUTE(configuration_descriptor_lock, _CONF_DESC_LOCK);
-UFS_ATTRIBUTE(max_number_of_rtt, _MAX_NUM_OF_RTT);
 UFS_ATTRIBUTE(exception_event_control, _EE_CONTROL);
 UFS_ATTRIBUTE(exception_event_status, _EE_STATUS);
 UFS_ATTRIBUTE(ffu_status, _FFU_STATUS);
-- 
2.34.1


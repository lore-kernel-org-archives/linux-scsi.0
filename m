Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B892CCC2;
	Thu, 16 May 2024 05:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715838716; cv=none; b=Rd0vWLXlmjAL8e5LqeCzj5Ndtvr24Zym/jNE8fibgd+liIbb6GIOWodR6yra1RAaUL1A9V1VgMyfpimNtt1TjU8g3I5ZEHgaqYDKTiq2qo0vr3JE9McV2JXgS8KSORo+5H03LWxKjt8wYgzOtVsyIcbrbsnPfkJiUjb20MWGa5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715838716; c=relaxed/simple;
	bh=mlTAF9IzZ5MszVVLrlFoPVpBmLnU5DPQaAULf7aCYbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ir8onV9D0/qwp+QhMf5DDpkcDuN7J9g5M5S9x1uNXzgBv13pdShmNTwrjpF58uMpMBMqxDIUrvkomkpjxvIj6UpZ+67YHxqCdj1h6ibmwvfVwv0FLGbpEnSI0c1C8x6xM7T2JzSpeOLwRUsHr2B5urcUryVkDJQ++QCIPz/IIz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=jYpS8t5W; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jYpS8t5W"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1715838715; x=1747374715;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mlTAF9IzZ5MszVVLrlFoPVpBmLnU5DPQaAULf7aCYbs=;
  b=jYpS8t5W9nRZzd6S5rQaBQAiTzT4KglJ8d0MItgi2P7/EZKxmSGwBEMM
   zHMxAax8eCL7A2yChym6Ak3PmuuDOVYSqjIb1OUMMhzvzorfVtOeIbZgh
   HmFrwMgIIV8jg+GZoBfhcRgZb8EkWpQD69/f987DB2xslSBmvpfgfQpJM
   DvVVvKAzFqelfRFD5kTG8IU4YEOFrWpG/kXmHGdgT29TSi4BHz70E+hk3
   HTnSsqygCMljeXfdsqitA+Jx4tVw1viBMsxctv06T91EZ5oKh+9v9lNKd
   81zYOg5exfkHVQw5YqoZLEH//9Y/3AzmtVW1YNRMepWnz/eDoVpyEs6IK
   A==;
X-CSE-ConnectionGUID: uS2NQsooQUyfYY8zn3e4PA==
X-CSE-MsgGUID: Dd9XOfrYQq23V6RqKM+4lw==
X-IronPort-AV: E=Sophos;i="6.08,163,1712592000"; 
   d="scan'208";a="17296259"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 May 2024 13:51:54 +0800
IronPort-SDR: 664592ba_pa912tIsMhlzTVLeTqH8evgXhe7dysXnMntJiZo7BHQYtf0
 7iN/iz5rZzF2lW7E6Ux/AsewEMHVj2CXNf46M1A==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 May 2024 21:59:39 -0700
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 15 May 2024 22:51:53 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 3/3] scsi: ufs: sysfs: Make max_number_of_rtt read-write
Date: Thu, 16 May 2024 08:51:24 +0300
Message-ID: <20240516055124.24490-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240516055124.24490-1-avri.altman@wdc.com>
References: <20240516055124.24490-1-avri.altman@wdc.com>
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
 Documentation/ABI/testing/sysfs-driver-ufs | 14 +++---
 drivers/ufs/core/ufs-sysfs.c               | 58 +++++++++++++++++++++-
 2 files changed, 65 insertions(+), 7 deletions(-)

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
index 3d049967f6bc..8c6aeb836407 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1340,6 +1340,63 @@ static const struct attribute_group ufs_sysfs_flags_group = {
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
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	unsigned int rtt;
+	int ret;
+
+	if (kstrtouint(buf, 0, &rtt))
+		return -EINVAL;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+		QUERY_ATTR_IDN_MAX_NUM_OF_RTT, 0, 0, &rtt);
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
@@ -1387,7 +1444,6 @@ UFS_ATTRIBUTE(max_data_in_size, _MAX_DATA_IN);
 UFS_ATTRIBUTE(max_data_out_size, _MAX_DATA_OUT);
 UFS_ATTRIBUTE(reference_clock_frequency, _REF_CLK_FREQ);
 UFS_ATTRIBUTE(configuration_descriptor_lock, _CONF_DESC_LOCK);
-UFS_ATTRIBUTE(max_number_of_rtt, _MAX_NUM_OF_RTT);
 UFS_ATTRIBUTE(exception_event_control, _EE_CONTROL);
 UFS_ATTRIBUTE(exception_event_status, _EE_STATUS);
 UFS_ATTRIBUTE(ffu_status, _FFU_STATUS);
-- 
2.34.1


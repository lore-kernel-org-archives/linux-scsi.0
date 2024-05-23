Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9652714AD25;
	Thu, 23 May 2024 12:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716469148; cv=none; b=QXk0rOi/E4nQdlk8vy44CdwwJ1FYd5ycR3GgZhyQ+06IpwgS7+dq9O6YXtGYvHOpbIRmrnG474CkKPQNsxawghzk5Vf4+VmC+lcumMwB4Ykk32g49wGKQd1GJzaXhJT34Ts9U7C+4AmJDefapfD7MgkeENmdagXduDzhAyNf+IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716469148; c=relaxed/simple;
	bh=3HMy5/V0H521gCFEHwEoQ1S0odb/OYD88xo+TVa9M1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8/geqt6n2xrOheAh8cqGWXH3s6/qebR9p47Yy7H1yfxWcIu4pNud4WdlvXg97WlXXZaVGlzJVEeoZS1c/25X9JNSQywakHkWqP4sT1f9Z6RfhFZFoDpBapGDgZhPsHu4y64xsZkkN7hrWyAiTVZg2bSHQYT6wHePOSgT4rEOEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Nn+MjaOx; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Nn+MjaOx"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1716469146; x=1748005146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3HMy5/V0H521gCFEHwEoQ1S0odb/OYD88xo+TVa9M1E=;
  b=Nn+MjaOxa1bFlkQs4ji8u/s7thvpMmIcUzYGks+x4ywdu5zoMREEGLxc
   vRBElHd4U5MHNJFFLF4jm9xSaPdGqTK7y+WKRCFb0cSny+R0xd1qMU/Ue
   Dlfzk0ISgk3mORZ9EVmUXAj+lXmmuYi1yeQ6gjBYCBI4lWRBeMj8lnA+l
   JqqmfJiVRx+cJFbKZpwOnh1C7IVh1/jSBiIAKcSK4vTWbjGI0vF8swMBl
   AxVwjKm5FsELQgUv/D625KQ25vpQPDa/U3qPgb6ep273d82458h0QE9IO
   QMveTzLwuTAl93tw7thHDxshaeIuTg9C7UovajlFw5ZT61JSN1dmmMPxI
   Q==;
X-CSE-ConnectionGUID: bI+AXJepSNyAsrcrBtlNKA==
X-CSE-MsgGUID: P8jlnTc/QN6TD6NpeZzPVA==
X-IronPort-AV: E=Sophos;i="6.08,182,1712592000"; 
   d="scan'208";a="16810345"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 23 May 2024 20:59:05 +0800
IronPort-SDR: 664f2ffc_jOHC+XnS10JtpFSluGVJhlhO1csq9YlqqpSszeO6wV2jwdG
 4edT+by8Q4VA7H68aZG0U01G33K3mtzfhLh7Sgg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 May 2024 05:01:00 -0700
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 23 May 2024 05:59:04 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v5 3/3] scsi: ufs: sysfs: Make max_number_of_rtt read-write
Date: Thu, 23 May 2024 15:58:26 +0300
Message-ID: <20240523125827.818-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240523125827.818-1-avri.altman@wdc.com>
References: <20240523125827.818-1-avri.altman@wdc.com>
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
 drivers/ufs/core/ufs-sysfs.c               | 72 +++++++++++++++++++++-
 drivers/ufs/core/ufshcd-priv.h             | 12 ++++
 drivers/ufs/core/ufshcd.c                  | 12 ----
 4 files changed, 91 insertions(+), 19 deletions(-)

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
index 3d049967f6bc..97fe1e9e63da 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1340,6 +1340,77 @@ static const struct attribute_group ufs_sysfs_flags_group = {
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
+
+	/* make sure that there are no outstanding requests when rtt is set */
+	ufshcd_scsi_block_requests(hba);
+	blk_mq_wait_quiesce_done(&hba->host->tag_set);
+
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+		QUERY_ATTR_IDN_MAX_NUM_OF_RTT, 0, 0, &rtt);
+
+	ufshcd_scsi_unblock_requests(hba);
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
@@ -1387,7 +1458,6 @@ UFS_ATTRIBUTE(max_data_in_size, _MAX_DATA_IN);
 UFS_ATTRIBUTE(max_data_out_size, _MAX_DATA_OUT);
 UFS_ATTRIBUTE(reference_clock_frequency, _REF_CLK_FREQ);
 UFS_ATTRIBUTE(configuration_descriptor_lock, _CONF_DESC_LOCK);
-UFS_ATTRIBUTE(max_number_of_rtt, _MAX_NUM_OF_RTT);
 UFS_ATTRIBUTE(exception_event_control, _EE_CONTROL);
 UFS_ATTRIBUTE(exception_event_status, _EE_STATUS);
 UFS_ATTRIBUTE(ffu_status, _FFU_STATUS);
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index f42d99ce5bf1..691987e2e5f5 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -32,6 +32,18 @@ static inline bool ufshcd_is_wb_buf_flush_allowed(struct ufs_hba *hba)
 		!(hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL);
 }
 
+static inline void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)
+{
+	if (atomic_dec_and_test(&hba->scsi_block_reqs_cnt))
+		scsi_unblock_requests(hba->host);
+}
+
+static inline void ufshcd_scsi_block_requests(struct ufs_hba *hba)
+{
+	if (atomic_inc_return(&hba->scsi_block_reqs_cnt) == 1)
+		scsi_block_requests(hba->host);
+}
+
 #ifdef CONFIG_SCSI_UFS_HWMON
 void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask);
 void ufs_hwmon_remove(struct ufs_hba *hba);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d8e0e80d66a5..f470180e6efb 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -332,18 +332,6 @@ static void ufshcd_configure_wb(struct ufs_hba *hba)
 		ufshcd_wb_toggle_buf_flush(hba, true);
 }
 
-static void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)
-{
-	if (atomic_dec_and_test(&hba->scsi_block_reqs_cnt))
-		scsi_unblock_requests(hba->host);
-}
-
-static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
-{
-	if (atomic_inc_return(&hba->scsi_block_reqs_cnt) == 1)
-		scsi_block_requests(hba->host);
-}
-
 static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 				      enum ufs_trace_str_t str_t)
 {
-- 
2.34.1


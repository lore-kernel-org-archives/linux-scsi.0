Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2CB175D49;
	Fri,  9 Aug 2024 07:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723188315; cv=none; b=Zlxj9+OhR8nDV/q9o1cEeIOiIfbLUc+J407q8bdrPSRZpnjR9lvsar1Fgw7LXSEXvi05+C3WgbyNz75+0wlAdkc1BfE/44/mDgAM+ChRTGE0dp5zI5mbUdGbTpHfRf7RoHwBW6yar+ipYAK/CBVZaDY/edFaTQy5Bk+5KQ2EXi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723188315; c=relaxed/simple;
	bh=zl47+hi/UIsopJhxNLXCNbZlqnIVXOLdsaQX+KMH7YE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kTtGzcIePTCTIUkSw8pVAnDOBksK1NtTGXy/YWGLlXu/6Q6rtJAnyOcotVegohbl9EzWd7NMvD4cCPIpcqMcE4c7MroqU3FXIa4XVYnThYrAEbpW3Pk7uuvvdD1p3rluVt7crWC6oa1aGAg2SgGa31xCiGuDERQGIPyuXdTjPjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=oY55u68f; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oY55u68f"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1723188313; x=1754724313;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zl47+hi/UIsopJhxNLXCNbZlqnIVXOLdsaQX+KMH7YE=;
  b=oY55u68fV2jkuX0UvoN+5Ruu2IVGeU5RJfBM1RYUBNYx48T8VT26Ethn
   DTNRC4CETQrBrIL3pVYgonGNvNQcqD2fz674D+LtK/QZj3y9XUjBxJXrd
   /UbjRrsrp8niY9YDGhS/Kuap+ieFFMbnBYhic2ZDbhXeDjlPtLPfHlK+s
   Xpfwfd7EhwuioA3AmpI2yopuCvBclXKiJDMEIVZiA9Ybw2P4n3GIfeZta
   23mYB7ukTga/tPuhGj7pitfj1zH4NlgPkvKh98g1t+GBI8lvl4KJz07U2
   +wD5otDQzedfUB3Ok75uXbw0bfg0xHf5vdnTQRh9Ppa6QFwg66FeyGrcb
   g==;
X-CSE-ConnectionGUID: d89WVwrSQ7aC9Fh6iNNOLQ==
X-CSE-MsgGUID: G1cEAQ0kQyeLQa5NcXKjJg==
X-IronPort-AV: E=Sophos;i="6.09,275,1716220800"; 
   d="scan'208";a="23232732"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Aug 2024 15:25:12 +0800
IronPort-SDR: 66b5b7af_TczDYPgTo8IqrM291NS+t2kAP8eqq/4xMragbceKIqsUfwK
 GVVHQOqFKjcGRwtD9PR1AdPetgmfbZTRPaTkTkw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Aug 2024 23:31:12 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Aug 2024 00:25:10 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Keoseong Park <keosung.park@samsung.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 2/2] scsi: ufs: Add HCI capabilities sysfs group
Date: Fri,  9 Aug 2024 10:23:31 +0300
Message-Id: <20240809072331.2483196-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240809072331.2483196-1-avri.altman@wdc.com>
References: <20240809072331.2483196-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The standard register map of UFSHCI is comprised of several groups.  The
first group (starting from offset 0x00), is the host capabilities group.
It contains some interesting information, that otherwise is not
available, e.g. the UFS version of the platform etc.

Reviewed-by: Keoseong Park <keosung.park@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 42 ++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 95 ++++++++++++++++++++++
 2 files changed, 137 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index fe943ce76c60..b6e0c3b806fd 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1532,3 +1532,45 @@ Contact:	Bean Huo <beanhuo@micron.com>
 Description:
 		rtc_update_ms indicates how often the host should synchronize or update the
 		UFS RTC. If set to 0, this will disable UFS RTC periodic update.
+
+What:		/sys/devices/platform/.../ufshci_capabilities/capabilities
+Date:		August 2024
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:
+		Host Capabilities register group: host controller capabilities register.
+		Symbol - CAP.  Offset: 0x00 - 0x03.
+
+What:		/sys/devices/platform/.../ufshci_capabilities/mcq_cap
+Date:		August 2024
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:
+		Host Capabilities register group: multi-circular queue capability register.
+		Symbol - MCQCAP.  Offset: 0x04 - 0x07.
+
+What:		/sys/devices/platform/.../ufshci_capabilities/version
+Date:		August 2024
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:
+		Host Capabilities register group: UFS version register.
+		Symbol - VER.  Offset: 0x08 - 0x0B.
+
+What:		/sys/devices/platform/.../ufshci_capabilities/ext_capabilities
+Date:		August 2024
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:
+		Host Capabilities register group: extended controller capabilities register.
+		Symbol - EXT_CAP.  Offset: 0x0C - 0x0F.
+
+What:		/sys/devices/platform/.../ufshci_capabilities/product_id
+Date:		August 2024
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:
+		Host Capabilities register group: product ID register.
+		Symbol - HCPID.  Offset: 0x10 - 0x13.
+
+What:		/sys/devices/platform/.../ufshci_capabilities/man_id
+Date:		August 2024
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:
+		Host Capabilities register group: manufacturer ID register.
+		Symbol - HCMID.  Offset: 0x14 - 0x17.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index dec7746c98e0..751d5ff406da 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -525,6 +525,100 @@ static const struct attribute_group ufs_sysfs_capabilities_group = {
 	.attrs = ufs_sysfs_capabilities_attrs,
 };
 
+static ssize_t capabilities_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "0x%x\n", hba->capabilities);
+}
+
+static ssize_t mcq_cap_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	if (hba->ufs_version < ufshci_version(4, 0))
+		return -EOPNOTSUPP;
+
+	return sysfs_emit(buf, "0x%x\n", hba->mcq_capabilities);
+}
+
+static ssize_t version_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "0x%x\n", hba->ufs_version);
+}
+
+static ssize_t ext_capabilities_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ret;
+	u32 val;
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	if (hba->ufs_version < ufshci_version(4, 0))
+		return -EOPNOTSUPP;
+
+	ret = ufshcd_read_hci_reg(hba, &val, REG_EXT_CONTROLLER_CAPABILITIES);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "0x%x\n", val);
+}
+
+static ssize_t product_id_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ret;
+	u32 val;
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	ret = ufshcd_read_hci_reg(hba, &val, REG_CONTROLLER_PID);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "0x%x\n", val);
+}
+
+static ssize_t man_id_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ret;
+	u32 val;
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	ret = ufshcd_read_hci_reg(hba, &val, REG_CONTROLLER_MID);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "0x%x\n", val);
+}
+
+static DEVICE_ATTR_RO(capabilities);
+static DEVICE_ATTR_RO(mcq_cap);
+static DEVICE_ATTR_RO(version);
+static DEVICE_ATTR_RO(ext_capabilities);
+static DEVICE_ATTR_RO(product_id);
+static DEVICE_ATTR_RO(man_id);
+
+static struct attribute *ufs_sysfs_ufshci_cap_attrs[] = {
+	&dev_attr_capabilities.attr,
+	&dev_attr_mcq_cap.attr,
+	&dev_attr_version.attr,
+	&dev_attr_ext_capabilities.attr,
+	&dev_attr_product_id.attr,
+	&dev_attr_man_id.attr,
+	NULL
+};
+
+static const struct attribute_group ufs_sysfs_ufshci_group = {
+	.name = "ufshci_capabilities",
+	.attrs = ufs_sysfs_ufshci_cap_attrs,
+};
+
 static ssize_t monitor_enable_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -1508,6 +1602,7 @@ static const struct attribute_group ufs_sysfs_attributes_group = {
 static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_default_group,
 	&ufs_sysfs_capabilities_group,
+	&ufs_sysfs_ufshci_group,
 	&ufs_sysfs_monitor_group,
 	&ufs_sysfs_power_info_group,
 	&ufs_sysfs_device_descriptor_group,
-- 
2.25.1


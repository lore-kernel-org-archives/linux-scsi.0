Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BFB156E4;
	Sun,  4 Aug 2024 07:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722756169; cv=none; b=ren7CYCny6bJJw0W6GD39yP/I4LZbI9eLTEWNW7D8cu+kQIlzd7i00N95LJ3fXws6uJysifngDKCXWufdyJt7sIY5JaOlkQ5abWTPbqrU6+FLriviuigR4b89vy33Fzbk6CnD3KsRbH9RdFXxpTWoMTcwUPwHZRYA6AQmdyfIa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722756169; c=relaxed/simple;
	bh=wtCYCVL7Tbpaue8Pa3D9laRV3mCidQ14oMghxtZzCro=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gCyruyZsc5CJQfAsyACRisxCDTn2oK/RP5xqp26+m1HtPj5A7gtjwkvas+dDINCXNh9f61lilorfyJyhqGPa/3AxASyHkGJQMh4Qg7d9DEG93bmNPCk40e0Y6Ejc1l7wazW0SN3wg1X1wTkukVzD1pr0yPS3NQKB0T/02NnmRuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=a7cCJDDs; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="a7cCJDDs"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1722756168; x=1754292168;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wtCYCVL7Tbpaue8Pa3D9laRV3mCidQ14oMghxtZzCro=;
  b=a7cCJDDs8x8Wyqhjm/j/oEBmmPrV2iN3//ONqUyxvratkSYXvoekjE0G
   PYVTWlyU6p5mCAxgGr7B9uUQpXFAXXaLacty1DpLyxwnwdCGxkfFMHwgr
   e+or5SKmFIy+8yxPUs7mklK2nKlCPVAYFkXFYN2BjY4wqOoSEY13n7i1J
   qifkpHbXqtiUOBbtcc3RjfMt7ofXEw4s4+SOxOxW6AS2NzFfaeOZIj0v0
   th9G1AmMO63E4rreN0UcbzpCCWXY3y5Q7+Y7cVBbe0oTtk8i5c08+lt7A
   oBubGsLPs8GJeaYT3vATwpeNNmTFOyLH6Dw+N1XB1wT+CAY+iEZyWtqB/
   Q==;
X-CSE-ConnectionGUID: Be9fHSXfR3yfv3/b36ycnQ==
X-CSE-MsgGUID: GF9AIsEwS/ifRim3PA1kwA==
X-IronPort-AV: E=Sophos;i="6.09,262,1716220800"; 
   d="scan'208";a="23384662"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Aug 2024 15:22:43 +0800
IronPort-SDR: 66af1fa0_BNf2az/xaAtHIFi/JsUmAAGMd8XCUAWs+/MgHsCgsqwSSUQ
 MEbLacyFpbSjpYOh/TSk4DeNLMX44WLvC9aRI2w==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Aug 2024 23:28:49 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Aug 2024 00:22:41 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 2/2] scsi: ufs: Add HCI capabilities sysfs group
Date: Sun,  4 Aug 2024 10:21:09 +0300
Message-Id: <20240804072109.2330880-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240804072109.2330880-1-avri.altman@wdc.com>
References: <20240804072109.2330880-1-avri.altman@wdc.com>
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

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 48 +++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 95 ++++++++++++++++++++++
 2 files changed, 143 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index fe943ce76c60..6c6cf12d25ca 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1532,3 +1532,51 @@ Contact:	Bean Huo <beanhuo@micron.com>
 Description:
 		rtc_update_ms indicates how often the host should synchronize or update the
 		UFS RTC. If set to 0, this will disable UFS RTC periodic update.
+
+What:		/sys/bus/platform/drivers/ufshcd/ufshci_capabilities/capabilities
+What:		/sys/bus/platform/devices/*.ufs/ufshci_capabilities/capabilities
+Date:		August 2024
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:
+		Host Capabilities register group: host controller capabiities register.
+		Symbol - CAP.  Offset: 0x00 - 0x03.
+
+What:		/sys/bus/platform/drivers/ufshcd/ufshci_capabilities/mcq_cap
+What:		/sys/bus/platform/devices/*.ufs/ufshci_capabilities/mcq_cap
+Date:		August 2024
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:
+		Host Capabilities register group: multi-circular queue capability register.
+		Symbol - MCQCAP.  Offset: 0x04 - 0x07.
+
+What:		/sys/bus/platform/drivers/ufshcd/ufshci_capabilities/version
+What:		/sys/bus/platform/devices/*.ufs/ufshci_capabilities/version
+Date:		August 2024
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:
+		Host Capabilities register group: UFS version register.
+		Symbol - VER.  Offset: 0x08 - 0x0B.
+
+What:		/sys/bus/platform/drivers/ufshcd/ufshci_capabilities/ext_capabilities
+What:		/sys/bus/platform/devices/*.ufs/ufshci_capabilities/ext_capabilities
+Date:		August 2024
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:
+		Host Capabilities register group: extended controller capabilities register.
+		Symbol - EXT_CAP.  Offset: 0x0C - 0x0F.
+
+What:		/sys/bus/platform/drivers/ufshcd/ufshci_capabilities/product_id
+What:		/sys/bus/platform/devices/*.ufs/ufshci_capabilities/product_id
+Date:		August 2024
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:
+		Host Capabilities register group: product ID register.
+		Symbol - HCPID.  Offset: 0x10 - 0x13.
+
+What:		/sys/bus/platform/drivers/ufshcd/ufshci_capabilities/man_id
+What:		/sys/bus/platform/devices/*.ufs/ufshci_capabilities/man_id
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


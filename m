Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285C61CAAF;
	Sun, 11 Aug 2024 14:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723387217; cv=none; b=QN1hrmrcAl7unlBjbAnuzfiVieeyi8ezVik6jcR12Uiew9sELJARw3FzfEQ+xfn7AG5anAJEOmDZeAkQgso8mqtnF8AADRmP7pICjCrEAD0WGgUJYdT35mEeER4mOhOKqGza/0wLP/ft5XOtnClGdait6AFu+jKUfal1nCHujQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723387217; c=relaxed/simple;
	bh=nVVQLsYEGtFzdLbTni7wqzhtxOLYmc7w5UyYNwtC2v8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ARfh6q0s0eftXRrJTxonoVdUg1QPq4+6TgPjchVIjb+IHBvHvC51ZbYo4P13SzR3ZgdmT/2TYJ8diKWUscYBkyMr0TNAnKrKIhWIIawHG0Hv5n3io/zAMTPhO2ocsnxWXDBloLcL7EVVN0GWz0cyHajhUxVf99L+S0j3mbKeWVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F8P7OLbR; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F8P7OLbR"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1723387215; x=1754923215;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nVVQLsYEGtFzdLbTni7wqzhtxOLYmc7w5UyYNwtC2v8=;
  b=F8P7OLbRzF5VNbFsGTwVcx59aN6BpWmp2tE659bpmVioGjJmtb6U8n3d
   C2hsr890Jgq4kScGRtDFwuXdDtC1Z7FdGxD0XeNeERFUKpJp4TxjbAIfP
   w3JHJN1GqcjuyZQdnm28/iOqREMLhLFyZ22CEmH0C8zOXOscSGrxPqYpA
   +X8blSXbZ6ifsobzC2N+hwxNvWI6tHBX2D2UR8OJCJs82pRNKiUNoCkQN
   +b1xTpA53e8orNviz4xbmyBRlMI/5dDf6PRbnagoDttvBlDyDhl5EgJcC
   Sw4cdcxKMbrSWQ9tQ2IWU+CKrXAmKcuygXh+0Dtl3dsfoZZReg4KLQ3VN
   g==;
X-CSE-ConnectionGUID: gYP/e/VNShqHcCaHhGFiJw==
X-CSE-MsgGUID: qu3xM0c9Sx+00LfHrlT97w==
X-IronPort-AV: E=Sophos;i="6.09,281,1716220800"; 
   d="scan'208";a="25021083"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2024 22:40:08 +0800
IronPort-SDR: 66b8c09d_a86kdrX+KyFMEmbkV3NPsXFfxlu0U8KWn7lzA/8fJgynm3w
 rhfJf6YiwvuyK1O4hRsIyQVxmaYDEmhpJcPtN2Q==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Aug 2024 06:46:05 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Aug 2024 07:40:06 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Keoseong Park <keosung.park@samsung.com>,
	Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v4 2/2] scsi: ufs: Add HCI capabilities sysfs group
Date: Sun, 11 Aug 2024 17:37:57 +0300
Message-Id: <20240811143757.2538212-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240811143757.2538212-1-avri.altman@wdc.com>
References: <20240811143757.2538212-1-avri.altman@wdc.com>
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
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs | 27 +++++++++++
 drivers/ufs/core/ufs-sysfs.c               | 53 ++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index fe943ce76c60..5fa6655aee84 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1532,3 +1532,30 @@ Contact:	Bean Huo <beanhuo@micron.com>
 Description:
 		rtc_update_ms indicates how often the host should synchronize or update the
 		UFS RTC. If set to 0, this will disable UFS RTC periodic update.
+
+What:		/sys/devices/platform/.../ufshci_capabilities/version
+Date:		August 2024
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:
+		Host Capabilities register group: UFS version register.
+		Symbol - VER.  This file shows the UFSHCD version.
+		Example: Version 3.12 would be represented as 0000_0312h.
+		The file is read only.
+
+What:		/sys/devices/platform/.../ufshci_capabilities/product_id
+Date:		August 2024
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:
+		Host Capabilities register group: product ID register.
+		Symbol - HCPID.  This file shows the UFSHCD product id.
+		The content of this register is vendor specific.
+		The file is read only.
+
+What:		/sys/devices/platform/.../ufshci_capabilities/man_id
+Date:		August 2024
+Contact:	Avri Altman <avri.altman@wdc.com>
+Description:
+		Host Capabilities register group: manufacturer ID register.
+		Symbol - HCMID. This file shows the UFSHCD manufacturer id.
+		The Manufacturer ID is defined by JEDEC in JEDEC-JEP106.
+		The file is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index dec7746c98e0..fe313800aed0 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -525,6 +525,58 @@ static const struct attribute_group ufs_sysfs_capabilities_group = {
 	.attrs = ufs_sysfs_capabilities_attrs,
 };
 
+static ssize_t version_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "0x%x\n", hba->ufs_version);
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
+static DEVICE_ATTR_RO(version);
+static DEVICE_ATTR_RO(product_id);
+static DEVICE_ATTR_RO(man_id);
+
+static struct attribute *ufs_sysfs_ufshci_cap_attrs[] = {
+	&dev_attr_version.attr,
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
@@ -1508,6 +1560,7 @@ static const struct attribute_group ufs_sysfs_attributes_group = {
 static const struct attribute_group *ufs_sysfs_groups[] = {
 	&ufs_sysfs_default_group,
 	&ufs_sysfs_capabilities_group,
+	&ufs_sysfs_ufshci_group,
 	&ufs_sysfs_monitor_group,
 	&ufs_sysfs_power_info_group,
 	&ufs_sysfs_device_descriptor_group,
-- 
2.25.1


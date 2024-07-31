Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116CA1B0111;
	Wed, 31 Jul 2024 12:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722428541; cv=none; b=Oxh3JU4eCK7xhlFURcnmhZMzlOC+cZDOH50wbAyiXGxl/b91l5ACK8X7zqZM/0P5MZzlFNcICeYHMDFzuaPLInejP6uHLsovhJg8dMKEIrClTh3fsFSxN4iRZTC8mgz1R9o0cfvOsxQa4NtkrY1TMSzwU3AwZNzENBtD83HYuJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722428541; c=relaxed/simple;
	bh=zYXPutPkojh64QN6h2f7s9rj66jDFKJuMW5LLhTwP58=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dzp1meOd2Cc1fa9XwjWNY0D9Lu6DFa413x/47qi3/0k1dK9kUpLSGRjmg/qZ9PdrxCXH8wr7Nt8x6VpiAwOdxYSgD4D+sZh8YvP/3GXYygs0YNixTNmOa+KTdLGljF0wh1vQYP2OKbrpm1hQ5gBM39tRERdYTe/I+5DPYUWdMxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=X5VS8V5P; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="X5VS8V5P"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1722428539; x=1753964539;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zYXPutPkojh64QN6h2f7s9rj66jDFKJuMW5LLhTwP58=;
  b=X5VS8V5P6qavfLmg99pw1rjs0205kx+CelKUAZ5CA2mHh+jt1Iqi2edA
   RC5FYaeqG3iR6/s6hHoj0nGNteMZVjdEtz7f+z4Xc/vaZrINssnHYdCOO
   aUzETRbpYbPhC+4vSuAhuU+VG9yJlZ3AQy39FjmtZlej+aC0HgrZGWbyR
   GLthIRx9e37VQ7zjAGkYoALJ6uVOZ9JeMwTCvSAaotrcreIZmhVqiggaU
   V1aM0n+p3/jcy3qyx9DgLQbItUsh1rE02aVw/bzcYLAw3N7/mWERIsceA
   g71/LrCYoQS2w/yFtALGT+NXwv/+qUr04tE9UlR75Xxzf0tapVIASLLaj
   A==;
X-CSE-ConnectionGUID: AIleQELqRp26Glt8PxcTqg==
X-CSE-MsgGUID: NfBj7p3pQyidZ8enO5Juaw==
X-IronPort-AV: E=Sophos;i="6.09,251,1716220800"; 
   d="scan'208";a="24150851"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jul 2024 20:22:17 +0800
IronPort-SDR: 66aa1e88_F1cIb0N4fD8OkZPcfzH2lfg/gWf928bQi5lMMrw8UU26Dm4
 xdlGWVdUOORFJy1c31RS9lPsxYsX942Nct0F0GQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Jul 2024 04:22:48 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Jul 2024 05:22:16 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 2/2] scsi: ufs: Add HCI capabilities sysfs group
Date: Wed, 31 Jul 2024 15:20:51 +0300
Message-Id: <20240731122051.2058406-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240731122051.2058406-1-avri.altman@wdc.com>
References: <20240731122051.2058406-1-avri.altman@wdc.com>
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
 drivers/ufs/core/ufs-sysfs.c | 95 ++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 7a264f8ef140..9ec3fc2f3af4 100644
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


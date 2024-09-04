Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7BD79DE
	for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2024 01:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725413235; cv=none; b=sNs2sXsvEqUlXaf+8NXynMmBdfzIMVXigZtIxdorR9kp5AtlVq8mhEkkIyVSoJTM4h6EcD2DeFtJzGIx/QQ4ePI/Tqw+Iq6tkUUcySYJTCLKdGbb9gvl12E17+YqMBT4hwP4KeRbFgyTftSrMCvWtNxtJGYvsPVqX3c+Qoe6NA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725413235; c=relaxed/simple;
	bh=MDOVWNqyXS3d4riagk+Txv7GvvYjo8hikLN6OrkRJWA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G7f/UUdXG2ItQEfQSVVSPlB4XB9FsG71QSh9Tce5kjK5YFYfWVtbVxJ7xT825ju9+FSz9ZMcaBP677Qf+2pj6RAJ39+17CGe5AsRQhPUXajDxE0wlD4j4ZwErypgCBIbJekGEkFHFdDn+hQfkbJN5eFWvGxpekbrwgKmHCierps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Wz4bH2Qvgz1j86r;
	Wed,  4 Sep 2024 09:26:51 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 035BB140158;
	Wed,  4 Sep 2024 09:27:11 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 4 Sep
 2024 09:27:10 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH -next 2/3] scsi: aacraid: Use sysfs_emit() to replace the sprintf()
Date: Wed, 4 Sep 2024 09:35:39 +0800
Message-ID: <20240904013540.2026972-3-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904013540.2026972-1-lihongbo22@huawei.com>
References: <20240904013540.2026972-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)

sysfs_emit validates assumptions made by sysfs and is the correct
mechanism to format data for sysfs.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 drivers/scsi/aacraid/linit.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 68f4dbcfff49..c87fb6c7828e 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -561,8 +561,8 @@ static ssize_t aac_show_raid_level(struct device *dev, struct device_attribute *
 		return snprintf(buf, PAGE_SIZE, sdev->no_uld_attach
 		  ? "Hidden\n" :
 		  ((aac->jbod && (sdev->type == TYPE_DISK)) ? "JBOD\n" : ""));
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-	  get_container_type(aac->fsa_dev[sdev_id(sdev)].type));
+	return sysfs_emit(buf, "%s\n",
+			  get_container_type(aac->fsa_dev[sdev_id(sdev)].type));
 }
 
 static struct device_attribute aac_raid_level_attr = {
@@ -585,7 +585,7 @@ static ssize_t aac_show_unique_id(struct device *dev,
 	if (sdev_channel(sdev) == CONTAINER_CHANNEL)
 		memcpy(sn, aac->fsa_dev[sdev_id(sdev)].identifier, sizeof(sn));
 
-	return snprintf(buf, 16 * 2 + 2,
+	return sysfs_emit(buf,
 		"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X\n",
 		sn[0], sn[1], sn[2], sn[3],
 		sn[4], sn[5], sn[6], sn[7],
@@ -1296,7 +1296,7 @@ static ssize_t aac_show_driver_version(struct device *device,
 					struct device_attribute *attr,
 					char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", aac_driver_version);
+	return sysfs_emit(buf, "%s\n", aac_driver_version);
 }
 
 static ssize_t aac_show_serial_number(struct device *device,
@@ -1322,15 +1322,13 @@ static ssize_t aac_show_serial_number(struct device *device,
 static ssize_t aac_show_max_channel(struct device *device,
 				    struct device_attribute *attr, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n",
-	  class_to_shost(device)->max_channel);
+	return sysfs_emit(buf, "%d\n", class_to_shost(device)->max_channel);
 }
 
 static ssize_t aac_show_max_id(struct device *device,
 			       struct device_attribute *attr, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n",
-	  class_to_shost(device)->max_id);
+	return sysfs_emit(buf, "%d\n", class_to_shost(device)->max_id);
 }
 
 static ssize_t aac_store_reset_adapter(struct device *device,
-- 
2.34.1


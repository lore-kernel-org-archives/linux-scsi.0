Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7F88837
	for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2024 01:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725413234; cv=none; b=j1liEgk1JdhlwXclxPn/zRfdPwT8CIhq03lE5U2kqsTCtwq7B4s5DZfAAz0WIz2Kkf18GLX4uwpMQsPj5kNJQBjGjxv5Xkqb2jzAxIgdHbEAJTSGtNh1Essn7ohA1Gfqch6E9e8bqCUPVqmmHtmotPDFfoPzjJeBasOU+In+uo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725413234; c=relaxed/simple;
	bh=mEW4P8apzmgpquVMD4mqjHYuTKqZ4rx7afEJPSO1kIs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NKSurrZ+OJDpKcve26cIpxge4epjbImys3WwRofri61P17uVeZWoWARjNhoOrHBvlbFPJl8+pppowkWj+8jEHOt2UZh7O1uSCgvhmmQ92MCIy1Uk3RLeyy2c/5mYxdvN/NrLPoAlwjvQ6/6L3zJqoF7fhdK6CybVA+lVSn5ybPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Wz4Wh0k9sz1HJ1S;
	Wed,  4 Sep 2024 09:23:44 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 2AAC31A0188;
	Wed,  4 Sep 2024 09:27:11 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 4 Sep
 2024 09:27:10 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH -next 3/3] scsi: hptiop: Change snprintf() to sysfs_emit()
Date: Wed, 4 Sep 2024 09:35:40 +0800
Message-ID: <20240904013540.2026972-4-lihongbo22@huawei.com>
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
mechanism to format data for sysfs. And this way is also suggested
in Documentation/filesystems/sysfs.rst.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 drivers/scsi/hptiop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index e889f268601b..5dcc9e18ce23 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1111,7 +1111,7 @@ static int hptiop_adjust_disk_queue_depth(struct scsi_device *sdev,
 static ssize_t hptiop_show_version(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", driver_ver);
+	return sysfs_emit(buf, "%s\n", driver_ver);
 }
 
 static ssize_t hptiop_show_fw_version(struct device *dev,
@@ -1120,7 +1120,7 @@ static ssize_t hptiop_show_fw_version(struct device *dev,
 	struct Scsi_Host *host = class_to_shost(dev);
 	struct hptiop_hba *hba = (struct hptiop_hba *)host->hostdata;
 
-	return snprintf(buf, PAGE_SIZE, "%d.%d.%d.%d\n",
+	return sysfs_emit(buf, "%d.%d.%d.%d\n",
 				hba->firmware_version >> 24,
 				(hba->firmware_version >> 16) & 0xff,
 				(hba->firmware_version >> 8) & 0xff,
-- 
2.34.1


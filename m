Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDD98C11
	for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2024 01:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725413235; cv=none; b=prnF+PFNL1UDiKm961ucG4szWdoVwN/3TUOc1YtpJAwX5Bs/C/9odusqWXBWKHXyXPptBcO95rlKO7rp+BR5iBz12P0MB26QvpfRnOP+nvNfEeegf1VOXgCQly+R7YaJidyJ29MkCg/Z4h7FRWr0kCSf5LkKGDlRSNBrajiIOIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725413235; c=relaxed/simple;
	bh=2UunxuAygnw7dr72L07ui4hVjlo1tYKaDIfhUJ4wexU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M0bk7eP05aI4ML4iokh9oOrhtHXhASeaCLNaG1NDa8M+9abUeSkVEuGkCzzk+nS63pl64EqHlAHbUFHT2g0iDdOT1MErpvIKW+dz7vMCBkLGDrRDlkLWnbt9SVLJd0HzdwyasifZDluVlFR2tFQjFQQAhW0tiEMw9IATkCmVZkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Wz4Ty1QXKz20nKr;
	Wed,  4 Sep 2024 09:22:14 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id D40F11A0188;
	Wed,  4 Sep 2024 09:27:10 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 4 Sep
 2024 09:27:10 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH -next 1/3] scsi: pmcraid: change snprintf() to sysfs_emit()
Date: Wed, 4 Sep 2024 09:35:38 +0800
Message-ID: <20240904013540.2026972-2-lihongbo22@huawei.com>
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

As Documentation/filesystems/sysfs.rst suggested, show()
should only use sysfs_emit() or sysfs_emit_at() when formatting
the value to be returned to user space.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 drivers/scsi/pmcraid.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index a2a084c8075e..22e53c4be894 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3541,7 +3541,7 @@ static ssize_t pmcraid_show_log_level(
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct pmcraid_instance *pinstance =
 		(struct pmcraid_instance *)shost->hostdata;
-	return snprintf(buf, PAGE_SIZE, "%d\n", pinstance->current_log_level);
+	return sysfs_emit(buf, "%d\n", pinstance->current_log_level);
 }
 
 /**
@@ -3602,8 +3602,7 @@ static ssize_t pmcraid_show_drv_version(
 	char *buf
 )
 {
-	return snprintf(buf, PAGE_SIZE, "version: %s\n",
-			PMCRAID_DRIVER_VERSION);
+	return sysfs_emit(buf, "version: %s\n", PMCRAID_DRIVER_VERSION);
 }
 
 static struct device_attribute pmcraid_driver_version_attr = {
@@ -3635,9 +3634,8 @@ static ssize_t pmcraid_show_adapter_id(
 	u32 adapter_id = pci_dev_id(pinstance->pdev);
 	u32 aen_group = pmcraid_event_family.id;
 
-	return snprintf(buf, PAGE_SIZE,
-			"adapter id: %d\nminor: %d\naen group: %d\n",
-			adapter_id, MINOR(pinstance->cdev.dev), aen_group);
+	return sysfs_emit(buf, "adapter id: %d\nminor: %d\naen group: %d\n",
+			  adapter_id, MINOR(pinstance->cdev.dev), aen_group);
 }
 
 static struct device_attribute pmcraid_adapter_id_attr = {
-- 
2.34.1


Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1791EA85
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 02:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353912; cv=none; b=gVFsw2Q5A3WyRSHg8ByVPUKWbTsY7BogIzuGocPmVbdtE9kbbMkZRL5bRG8pdnkinLDDFB6ebuk0yniYKL3kjTu8ITS52/3300TF/n7ZowsuFQXi0QMTj7VfippEcsBG2npk4kERr/9m9u5o+mQC1WaII5RYVyZ/fRPBl0NBhHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353912; c=relaxed/simple;
	bh=wchtal4BB6WvDzdo6JpMhbSZbRuFADPHFRu//GdlI9w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B75D2sQcwtU8y+m0hKiQ8zg9qV6vjaq7jhqy+0/JsJWnVAmzYQOOAW9cAIp/DpJ/8TxkP4atymPDlym1h/7pxAjQZT3QcCXnu/9kJdJ0eBTWH5oM4xTCIkRBVXvMshEwHHlcqJUUA0K2IjUhVpLa+KhPFL1rMFroGOT/OB6Aol4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XN04P2mWfzfd36;
	Tue,  8 Oct 2024 10:16:05 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 81762180106;
	Tue,  8 Oct 2024 10:18:28 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 8 Oct 2024 10:18:28 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH v2 06/13] scsi: hisi_sas: Check usage count only when the runtime PM status is RPM_SUSPENDING
Date: Tue, 8 Oct 2024 10:18:15 +0800
Message-ID: <20241008021822.2617339-7-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20241008021822.2617339-1-liyihang9@huawei.com>
References: <20241008021822.2617339-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemf100013.china.huawei.com (7.185.36.179)

Users can suspend the machine with 'echo disk > /sys/power/state', but the
suspend will fail because the SAS controller cannot be suspended:

[root@localhost ~]# echo freeze > /sys/power/state
-bash: echo: write error: Device or resource busy
[15104.142955] PM: suspend entry (s2idle)
...
[15104.283465] hisi_sas_v3_hw 0000:32:04.0: entering suspend state
[15104.283480] hisi_sas_v3_hw 0000:30:04.0: entering suspend state
[15104.283500] hisi_sas_v3_hw 0000:32:04.0: PM suspend: host status cannot be suspended
[15104.283508] hisi_sas_v3_hw 0000:30:04.0: PM suspend: host status cannot be suspended
[15104.283516] hisi_sas_v3_hw 0000:32:04.0: PM: pci_pm_suspend(): suspend_v3_hw+0x0/0x210 [hisi_sas_v3_hw] returns -16
[15104.283527] hisi_sas_v3_hw 0000:32:04.0: PM: dpm_run_callback(): pci_pm_suspend+0x0/0x1c0 returns -16
[15104.283524] hisi_sas_v3_hw 0000:30:04.0: PM: pci_pm_suspend(): suspend_v3_hw+0x0/0x210 [hisi_sas_v3_hw] returns -16
[15104.283533] hisi_sas_v3_hw 0000:32:04.0: PM: failed to suspend async: error -16
[15104.283536] hisi_sas_v3_hw 0000:30:04.0: PM: dpm_run_callback(): pci_pm_suspend+0x0/0x1c0 returns -16
[15104.283542] hisi_sas_v3_hw 0000:30:04.0: PM: failed to suspend async: error -16

The problem is that when the ->runtime_suspend() callback suspend_v3_hw()
is executing, the current runtime PM status is RPM_ACTIVE and the usage
count of the controller is not 0, so return immediately.

To fix it, Check the device usage count only when the runtime PM status is
RPM_SUSPENDING.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index d48777fc4bd9..9e65ad0e6ce0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -5048,7 +5048,8 @@ static int _suspend_v3_hw(struct device *device)
 	interrupt_disable_v3_hw(hisi_hba);
 
 #ifdef CONFIG_PM
-	if (atomic_read(&device->power.usage_count)) {
+	if ((device->power.runtime_status == RPM_SUSPENDING) &&
+	    atomic_read(&device->power.usage_count)) {
 		dev_err(dev, "PM suspend: host status cannot be suspended\n");
 		rc = -EBUSY;
 		goto err_out;
-- 
2.33.0


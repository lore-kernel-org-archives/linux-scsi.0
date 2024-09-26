Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EED917335E
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 01:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727315018; cv=none; b=UA7tdn2ZXy9p2WGep57uBfjP/3i5D8aJc89+KjS1b5K1ty3wdIfDzRSgs5XVZ4VHd1GX/ehczphnl8tp/EGUJ8HWz0B7N3fp8cTKXSBv6DeZNaxxJMB8HiqWUi185jnL8QhpOx6JIpcf6mtyqA3W/Cl8QCY4SW7an8wexUJiZwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727315018; c=relaxed/simple;
	bh=wchtal4BB6WvDzdo6JpMhbSZbRuFADPHFRu//GdlI9w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aC9a3eqES6YmreEC3GvGIlRyd+k2vpIwIErs33DlP/g1C9ADCjguUD+hX/3NyAMselCJClDPj0CnX55XTRLZXEKdN87ue/MHO0AKdVYNFdrbCqOB4SvEeG5vWuD8mQLNTfowL4QRCsaOZG+dGzNf3CpQukEkSEHY9OiDEEboQVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XDbtl6Tzdz10MfZ;
	Thu, 26 Sep 2024 09:42:07 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 052E71800F2;
	Thu, 26 Sep 2024 09:43:34 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 26 Sep 2024 09:43:33 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH 06/13] scsi: hisi_sas: Check usage count only when the runtime PM status is RPM_SUSPENDING
Date: Thu, 26 Sep 2024 09:43:25 +0800
Message-ID: <20240926014332.3905399-7-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240926014332.3905399-1-liyihang9@huawei.com>
References: <20240926014332.3905399-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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


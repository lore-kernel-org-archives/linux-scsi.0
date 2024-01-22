Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E26963A0
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jan 2024 06:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705904499; cv=none; b=i9LV3zgNf1gqQIw1baeFrxRD4Xv08ykQQDmwKwmZUlz4kohSEGXzs9vQLRNBF/GK/doniFAr5lPCzqnaTXwRiFfXIGVw+15F+gc+Fm23K6HfOI+0rjvMOuDPant9IoSxdmC4kFmPlENvBxi0DWgz4JsRLiMDn0+mP7sXKvZLqSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705904499; c=relaxed/simple;
	bh=jsJ4x6Lt/jXuYhIvPwS1CXSrjQkYHJkMck6wBdpbMh0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SvtZu2QDRHE656qRLhoCBKMz8U4fMq5fo3Hfedl3TVdQNZ+5rBxxK0AzM1IrC6D1szX1EZF6dvlIsRMudlBuzNSG8hm8nTgVrjvU+Jnh8ujnW070mQ1QeW1NtjnmE9ae7xY05Ic+I+kCKDJfpOkdg6P3hD0iPIzKdCnNgcs23xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4TJKqD73BzzbcFY;
	Mon, 22 Jan 2024 14:21:12 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id 09C0B180087;
	Mon, 22 Jan 2024 14:21:20 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Jan 2024 14:20:50 +0800
From: chenxiang <chenxiang66@hisilicon.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>, Yihang Li
	<liyihang9@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 3/4] scsi: hisi_sas: Check whether debugfs is enabled before removing or releasing it
Date: Mon, 22 Jan 2024 14:25:46 +0800
Message-ID: <1705904747-62186-4-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1705904747-62186-1-git-send-email-chenxiang66@hisilicon.com>
References: <1705904747-62186-1-git-send-email-chenxiang66@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500025.china.huawei.com (7.221.188.170)

From: Yihang Li <liyihang9@huawei.com>

Hisi_sas debugfs remove should be executed only when debugfs is enabled.
Check whether debugfs is enabled and then remove it only if enabled.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 3 ++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 7 +++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 70c998d..0b66c73 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2625,7 +2625,8 @@ static __exit void hisi_sas_exit(void)
 {
 	sas_release_transport(hisi_sas_stt);
 
-	debugfs_remove(hisi_sas_debugfs_dir);
+	if (hisi_sas_debugfs_enable)
+		debugfs_remove(hisi_sas_debugfs_dir);
 }
 
 module_init(hisi_sas_init);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index b56fbc6..033298d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4902,7 +4902,8 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_out_remove_host:
 	scsi_remove_host(shost);
 err_out_undo_debugfs:
-	debugfs_exit_v3_hw(hisi_hba);
+	if (hisi_sas_debugfs_enable)
+		debugfs_exit_v3_hw(hisi_hba);
 err_out_free_host:
 	hisi_sas_free(hisi_hba);
 	scsi_host_put(shost);
@@ -4942,7 +4943,9 @@ static void hisi_sas_v3_remove(struct pci_dev *pdev)
 
 	hisi_sas_v3_destroy_irqs(pdev, hisi_hba);
 	hisi_sas_free(hisi_hba);
-	debugfs_exit_v3_hw(hisi_hba);
+	if (hisi_sas_debugfs_enable)
+		debugfs_exit_v3_hw(hisi_hba);
+
 	scsi_host_put(shost);
 }
 
-- 
2.8.1


Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C1A173355
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 01:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727315017; cv=none; b=FnotI0Imf+4kormWYC0NB8KX4Vt+9DGRoTYi8E9zOCY5ebZswSyTjJFjgGgCoX14x6w0Piilrrv+jFzV2WRj9e78PoI/SL36466rJwwfjWd+4y1eL65RFGQCufG2I3BAVJqY/jaTKfFJ4STPHLeO7shZqOZxsjb+FBH2wyrgemU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727315017; c=relaxed/simple;
	bh=jNQMpKsQA6W8gNsOBDDufeV/8BQ5Gx7pLeLyFhwKx3Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=USLEDivV/uNqanw85QgRlQ5IbNyBkmL0SULQJ1P5zhv/w/01hd5s04j9/0qb5tUW64uClr8XnPZqi0NWcWEYlpUDUGolj0Mxh4JuvEyyXJtN3fn20xYCp+Sl7X5NxDsDm3CyengK9+OqxcpEQD9AYBMvk7GDJ6nmN82fp4gzE4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XDbtl2xP7z1T80D;
	Thu, 26 Sep 2024 09:42:07 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 3A7DC1401E0;
	Thu, 26 Sep 2024 09:43:33 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 26 Sep 2024 09:43:32 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH 01/13] scsi: hisi_sas: Adjust priority of registering and exiting debugfs for security
Date: Thu, 26 Sep 2024 09:43:20 +0800
Message-ID: <20240926014332.3905399-2-liyihang9@huawei.com>
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

To be safe, we should register debugfs at the last stage of driver
initialization and then unregister debugfs at the first stage of driver
uninstallation.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 17 ++++++-----------
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 6219807ce3b9..d3dcc4918444 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2630,10 +2630,10 @@ static __init int hisi_sas_init(void)
 
 static __exit void hisi_sas_exit(void)
 {
-	sas_release_transport(hisi_sas_stt);
-
 	if (hisi_sas_debugfs_enable)
 		debugfs_remove(hisi_sas_debugfs_dir);
+
+	sas_release_transport(hisi_sas_stt);
 }
 
 module_init(hisi_sas_init);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 4cd3a3eab6f1..63a7255d2994 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4860,16 +4860,13 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 					    SHOST_DIX_GUARD_CRC);
 	}
 
-	if (hisi_sas_debugfs_enable)
-		debugfs_init_v3_hw(hisi_hba);
-
 	rc = interrupt_preinit_v3_hw(hisi_hba);
 	if (rc)
-		goto err_out_undo_debugfs;
+		goto err_out_free_host;
 
 	rc = scsi_add_host(shost, dev);
 	if (rc)
-		goto err_out_undo_debugfs;
+		goto err_out_free_host;
 
 	rc = sas_register_ha(sha);
 	if (rc)
@@ -4880,6 +4877,8 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_out_unregister_ha;
 
 	scsi_scan_host(shost);
+	if (hisi_sas_debugfs_enable)
+		debugfs_init_v3_hw(hisi_hba);
 
 	pm_runtime_set_autosuspend_delay(dev, 5000);
 	pm_runtime_use_autosuspend(dev);
@@ -4900,9 +4899,6 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sas_unregister_ha(sha);
 err_out_remove_host:
 	scsi_remove_host(shost);
-err_out_undo_debugfs:
-	if (hisi_sas_debugfs_enable)
-		debugfs_exit_v3_hw(hisi_hba);
 err_out_free_host:
 	hisi_sas_free(hisi_hba);
 	scsi_host_put(shost);
@@ -4934,6 +4930,8 @@ static void hisi_sas_v3_remove(struct pci_dev *pdev)
 	struct Scsi_Host *shost = sha->shost;
 
 	pm_runtime_get_noresume(dev);
+	if (hisi_sas_debugfs_enable)
+		debugfs_exit_v3_hw(hisi_hba);
 
 	sas_unregister_ha(sha);
 	flush_workqueue(hisi_hba->wq);
@@ -4941,9 +4939,6 @@ static void hisi_sas_v3_remove(struct pci_dev *pdev)
 
 	hisi_sas_v3_destroy_irqs(pdev, hisi_hba);
 	hisi_sas_free(hisi_hba);
-	if (hisi_sas_debugfs_enable)
-		debugfs_exit_v3_hw(hisi_hba);
-
 	scsi_host_put(shost);
 }
 
-- 
2.33.0


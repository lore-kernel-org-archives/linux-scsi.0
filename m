From: John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: hisi_sas: fix free'ing in probe and remove
Date: Tue, 29 Nov 2016 23:45:57 +0800
Message-ID: <1480434357-63730-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:23908 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933640AbcK2PVB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2016 10:21:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: john.garry2@mail.dcu.ie, lambert.quentin@gmail.com, xuwei5@hisilicon.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, zhangfei.gao@linaro.org, linuxarm@huawei.com, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>

From: Xiaofei Tan <tanxiaofei@huawei.com>

This patch addresses 4 problems in the module probe/remove:
- When hisi_sas_shost_alloc() fails after we alloc shost memory,
we should free shost memory before the function returns.
- When hisi_sas_probe() fails after we alloc the HBA memories,
we should also free the HBA memories.
- We should free shost memory at the end of hisi_sas_remove().
- sha->core.shost is set twice, so remove extra set.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 6d6f150..d50e9cf 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1412,8 +1412,10 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	struct clk *refclk;
 
 	shost = scsi_host_alloc(&hisi_sas_sht, sizeof(*hisi_hba));
-	if (!shost)
-		goto err_out;
+	if (!shost) {
+		dev_err(dev, "scsi host alloc failed\n");
+		return NULL;
+	}
 	hisi_hba = shost_priv(shost);
 
 	hisi_hba->hw = hw;
@@ -1477,6 +1479,7 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 
 	return shost;
 err_out:
+	kfree(shost);
 	dev_err(dev, "shost alloc failed\n");
 	return NULL;
 }
@@ -1503,10 +1506,8 @@ int hisi_sas_probe(struct platform_device *pdev,
 	int rc, phy_nr, port_nr, i;
 
 	shost = hisi_sas_shost_alloc(pdev, hw);
-	if (!shost) {
-		rc = -ENOMEM;
-		goto err_out_ha;
-	}
+	if (!shost)
+		return -ENOMEM;
 
 	sha = SHOST_TO_SAS_HA(shost);
 	hisi_hba = shost_priv(shost);
@@ -1516,12 +1517,13 @@ int hisi_sas_probe(struct platform_device *pdev,
 
 	arr_phy = devm_kcalloc(dev, phy_nr, sizeof(void *), GFP_KERNEL);
 	arr_port = devm_kcalloc(dev, port_nr, sizeof(void *), GFP_KERNEL);
-	if (!arr_phy || !arr_port)
-		return -ENOMEM;
+	if (!arr_phy || !arr_port) {
+		rc = -ENOMEM;
+		goto err_out_ha;
+	}
 
 	sha->sas_phy = arr_phy;
 	sha->sas_port = arr_port;
-	sha->core.shost = shost;
 	sha->lldd_ha = hisi_hba;
 
 	shost->transportt = hisi_sas_stt;
@@ -1566,6 +1568,7 @@ int hisi_sas_probe(struct platform_device *pdev,
 err_out_register_ha:
 	scsi_remove_host(shost);
 err_out_ha:
+	hisi_sas_free(hisi_hba);
 	kfree(shost);
 	return rc;
 }
@@ -1575,12 +1578,14 @@ int hisi_sas_remove(struct platform_device *pdev)
 {
 	struct sas_ha_struct *sha = platform_get_drvdata(pdev);
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
+	struct Scsi_Host *shost = sha->core.shost;
 
 	scsi_remove_host(sha->core.shost);
 	sas_unregister_ha(sha);
 	sas_remove_host(sha->core.shost);
 
 	hisi_sas_free(hisi_hba);
+	kfree(shost);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(hisi_sas_remove);
-- 
1.9.1


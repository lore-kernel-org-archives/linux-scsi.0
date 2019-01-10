From: John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: hisi_sas: Set protection parameters prior to adding SCSI host
Date: Thu, 10 Jan 2019 21:32:41 +0800
Message-ID: <1547127161-213124-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Currently we set the protection parameters after calling scsi_add_host()
for v3 hw.

They should be set beforehand, so make this change.

Appearantly this fixes our DIX issue (not mainline yet) also, but more
testing required.

Fixes: d6a9000b81be ("scsi: hisi_sas: Add support for DIF feature for v2 hw")
Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index b780b52..18d1f2cb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2675,6 +2675,12 @@ static void debugfs_snapshot_restore_v3_hw(struct hisi_hba *hisi_hba)
 	if (hisi_sas_debugfs_enable)
 		hisi_sas_debugfs_init(hisi_hba);
 
+	if (hisi_hba->prot_mask) {
+		dev_info(dev, "Registering for DIF/DIX prot_mask=0x%x\n",
+			 prot_mask);
+		scsi_host_set_prot(hisi_hba->shost, prot_mask);
+	}
+
 	rc = scsi_add_host(shost, dev);
 	if (rc)
 		goto err_out_ha;
@@ -2687,12 +2693,6 @@ static void debugfs_snapshot_restore_v3_hw(struct hisi_hba *hisi_hba)
 	if (rc)
 		goto err_out_register_ha;
 
-	if (hisi_hba->prot_mask) {
-		dev_info(dev, "Registering for DIF/DIX prot_mask=0x%x\n",
-			 prot_mask);
-		scsi_host_set_prot(hisi_hba->shost, prot_mask);
-	}
-
 	scsi_scan_host(shost);
 
 	return 0;
-- 
1.9.1

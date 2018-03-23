From: John Garry <john.garry@huawei.com>
Subject: [PATCH 8/8] scsi: hisi_sas: remove some unneeded structure members
Date: Sat, 24 Mar 2018 00:05:15 +0800
Message-ID: <1521821115-120040-9-git-send-email-john.garry@huawei.com>
References: <1521821115-120040-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521821115-120040-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patch removes unneeded structure elements:
- hisi_sas_phy.dev_sas_addr: only ever written
	- Also remove associated function which writes it,
	  hisi_sas_init_add().
- hisi_sas_device.attached_phy: only ever written
	- Also remove code to set it in hisi_sas_dev_found()

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 17 +----------------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  2 --
 3 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index d1153e8..d413d05 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -137,7 +137,6 @@ struct hisi_sas_phy {
 	struct asd_sas_phy	sas_phy;
 	struct sas_identify	identify;
 	u64		port_id; /* from hw */
-	u64		dev_sas_addr;
 	u64		frame_rcvd_size;
 	u8		frame_rcvd[32];
 	u8		phy_attached;
@@ -174,7 +173,6 @@ struct hisi_sas_device {
 	struct completion *completion;
 	struct hisi_sas_dq	*dq;
 	struct list_head	list;
-	u64 attached_phy;
 	enum sas_device_type	dev_type;
 	int device_id;
 	int sata_idx;
@@ -440,7 +438,6 @@ struct hisi_sas_slot_buf_table {
 extern struct scsi_host_template *hisi_sas_sht;
 
 extern void hisi_sas_stop_phys(struct hisi_hba *hisi_hba);
-extern void hisi_sas_init_add(struct hisi_hba *hisi_hba);
 extern int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost);
 extern void hisi_sas_free(struct hisi_hba *hisi_hba);
 extern u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 8557fd0..d1a61b1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -577,10 +577,8 @@ static int hisi_sas_dev_found(struct domain_device *device)
 		for (phy_no = 0; phy_no < phy_num; phy_no++) {
 			phy = &parent_dev->ex_dev.ex_phy[phy_no];
 			if (SAS_ADDR(phy->attached_sas_addr) ==
-				SAS_ADDR(device->sas_addr)) {
-				sas_dev->attached_phy = phy_no;
+				SAS_ADDR(device->sas_addr))
 				break;
-			}
 		}
 
 		if (phy_no == phy_num) {
@@ -2079,17 +2077,6 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	return NULL;
 }
 
-void hisi_sas_init_add(struct hisi_hba *hisi_hba)
-{
-	int i;
-
-	for (i = 0; i < hisi_hba->n_phy; i++)
-		memcpy(&hisi_hba->phy[i].dev_sas_addr,
-		       hisi_hba->sas_addr,
-		       SAS_ADDR_SIZE);
-}
-EXPORT_SYMBOL_GPL(hisi_sas_init_add);
-
 int hisi_sas_probe(struct platform_device *pdev,
 			 const struct hisi_sas_hw *hw)
 {
@@ -2143,8 +2130,6 @@ int hisi_sas_probe(struct platform_device *pdev,
 		sha->sas_port[i] = &hisi_hba->port[i].sas_port;
 	}
 
-	hisi_sas_init_add(hisi_hba);
-
 	rc = scsi_add_host(shost, &pdev->dev);
 	if (rc)
 		goto err_out_ha;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 760724a..33735a7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2134,8 +2134,6 @@ static int soft_reset_v3_hw(struct hisi_hba *hisi_hba)
 		sha->sas_port[i] = &hisi_hba->port[i].sas_port;
 	}
 
-	hisi_sas_init_add(hisi_hba);
-
 	rc = scsi_add_host(shost, dev);
 	if (rc)
 		goto err_out_ha;
-- 
1.9.1

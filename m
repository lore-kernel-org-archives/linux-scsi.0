From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 02/11] scsi: ufshcd: release resources if probe fails
Date: Mon, 17 Oct 2016 17:09:11 -0700
Message-ID: <1476749352-11123-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

If ufshcd pltfrm/pci driver's probe fails for some reason then ensure that
scsi host is released to avoid memory leak but managed memory allocations
(via devm_* calls) need not to be freed explicitly on probe failure as
memory allocated with these functions is automatically freed on driver
detach.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd-pci.c    | 2 ++
 drivers/scsi/ufs/ufshcd-pltfrm.c | 5 +----
 drivers/scsi/ufs/ufshcd.c        | 3 ---
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index d15eaa4..52b546f 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -104,6 +104,7 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 	pm_runtime_forbid(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 	ufshcd_remove(hba);
+	ufshcd_dealloc_host(hba);
 }
 
 /**
@@ -147,6 +148,7 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = ufshcd_init(hba, mmio_base, pdev->irq);
 	if (err) {
 		dev_err(&pdev->dev, "Initialization failed\n");
+		ufshcd_dealloc_host(hba);
 		return err;
 	}
 
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index db53f38..a72a4ba 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -163,7 +163,7 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 	if (ret) {
 		dev_err(dev, "%s: unable to find %s err %d\n",
 				__func__, prop_name, ret);
-		goto out_free;
+		goto out;
 	}
 
 	vreg->min_uA = 0;
@@ -185,9 +185,6 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 
 	goto out;
 
-out_free:
-	devm_kfree(dev, vreg);
-	vreg = NULL;
 out:
 	if (!ret)
 		*out_vreg = vreg;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 77700ee..834a28c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6197,8 +6197,6 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba, true);
 
-	scsi_host_put(hba->host);
-
 	ufshcd_exit_clk_gating(hba);
 	if (ufshcd_is_clkscaling_enabled(hba))
 		devfreq_remove_device(hba->devfreq);
@@ -6561,7 +6559,6 @@ exit_gating:
 	ufshcd_exit_clk_gating(hba);
 out_disable:
 	hba->is_irq_enabled = false;
-	scsi_host_put(host);
 	ufshcd_hba_exit(hba);
 out_error:
 	return err;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

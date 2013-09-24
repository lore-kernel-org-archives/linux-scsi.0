From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] [SCSI] remove unnecessary pci_set_drvdata()
Date: Tue, 24 Sep 2013 10:16:20 +0900
Message-ID: <001301ceb8c3$ad4c37f0$07e4a7d0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:44853 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab3IXBQW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2013 21:16:22 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MTL000G4VI1E2H0@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 24 Sep 2013 10:16:21 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Jiri Kosina' <jkosina@suse.cz>
Cc: trivial@kernel.org, 'James Bottomley' <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>

Since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound),
the driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: James Bottomley <JBottomley@parallels.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c          |    1 -
 drivers/scsi/atp870u.c                    |    2 --
 drivers/scsi/bfa/bfad.c                   |    1 -
 drivers/scsi/csiostor/csio_init.c         |    2 --
 drivers/scsi/dc395x.c                     |    1 -
 drivers/scsi/fnic/fnic_main.c             |    1 -
 drivers/scsi/gdth.c                       |    2 --
 drivers/scsi/hpsa.c                       |    1 -
 drivers/scsi/lpfc/lpfc_init.c             |    3 ---
 drivers/scsi/megaraid/megaraid_mbox.c     |    6 ------
 drivers/scsi/megaraid/megaraid_sas_base.c |    5 -----
 drivers/scsi/mvsas/mv_init.c              |    1 -
 drivers/scsi/mvumi.c                      |    2 --
 drivers/scsi/pm8001/pm8001_init.c         |    1 -
 drivers/scsi/pmcraid.c                    |    1 -
 drivers/scsi/qla2xxx/qla_os.c             |    1 -
 drivers/scsi/qla4xxx/ql4_os.c             |    1 -
 drivers/scsi/stex.c                       |    2 --
 drivers/scsi/tmscsim.c                    |    1 -
 drivers/scsi/ufs/ufshcd-pci.c             |    1 -
 drivers/scsi/vmw_pvscsi.c                 |    2 --
 21 files changed, 38 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 33c52bc..97fd450 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1035,7 +1035,6 @@ static void arcmsr_remove(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 	scsi_host_put(host);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 }
 
 static void arcmsr_shutdown(struct pci_dev *pdev)
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 15a629d..a795d81 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -3144,8 +3144,6 @@ static void atp870u_remove (struct pci_dev *pdev)
 	atp870u_free_tables(pshost);
 	printk(KERN_INFO "scsi_host_put : %p\n",pshost);
 	scsi_host_put(pshost);
-	printk(KERN_INFO "pci_set_drvdata : %p\n",pdev);
-	pci_set_drvdata(pdev, NULL);	
 }
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index f8ca7be..2e6e3ac 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -833,7 +833,6 @@ bfad_pci_uninit(struct pci_dev *pdev, struct bfad_s *bfad)
 	/* Disable PCIE Advanced Error Recovery (AER) */
 	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 }
 
 bfa_status_t
diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 00346fe..1aafc33 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -1010,7 +1010,6 @@ err_lnode_exit:
 	csio_hw_stop(hw);
 	spin_unlock_irq(&hw->lock);
 	csio_lnodes_unblock_request(hw);
-	pci_set_drvdata(hw->pdev, NULL);
 	csio_lnodes_exit(hw, 0);
 	csio_hw_free(hw);
 err_pci_exit:
@@ -1044,7 +1043,6 @@ static void csio_remove_one(struct pci_dev *pdev)
 
 	csio_lnodes_exit(hw, 0);
 	csio_hw_free(hw);
-	pci_set_drvdata(pdev, NULL);
 	csio_pci_exit(pdev, &bars);
 }
 
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index e73445b..61c7cb7 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4859,7 +4859,6 @@ static void dc395x_remove_one(struct pci_dev *dev)
 	adapter_uninit(acb);
 	pci_disable_device(dev);
 	scsi_host_put(scsi_host);
-	pci_set_drvdata(dev, NULL);
 }
 
 
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index bbf81ea..889b594 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -996,7 +996,6 @@ static void fnic_remove(struct pci_dev *pdev)
 	fnic_iounmap(fnic);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 	scsi_host_put(lp->host);
 }
 
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 6d55b4e..ee4fa40 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -594,8 +594,6 @@ static void gdth_pci_remove_one(struct pci_dev *pdev)
 {
 	gdth_ha_str *ha = pci_get_drvdata(pdev);
 
-	pci_set_drvdata(pdev, NULL);
-
 	list_del(&ha->list);
 	gdth_remove_one(ha);
 
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index fb5a898..22f6432 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5017,7 +5017,6 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	kfree(h->hba_inquiry_data);
 	pci_disable_device(pdev);
 	pci_release_regions(pdev);
-	pci_set_drvdata(pdev, NULL);
 	kfree(h);
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 647f5bf..3dfd38c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4581,8 +4581,6 @@ lpfc_disable_pci_dev(struct lpfc_hba *phba)
 	/* Release PCI resource and disable PCI device */
 	pci_release_selected_regions(pdev, bars);
 	pci_disable_device(pdev);
-	/* Null out PCI private reference to driver */
-	pci_set_drvdata(pdev, NULL);
 
 	return;
 }
@@ -9429,7 +9427,6 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 	/* Disable interrupt */
 	lpfc_sli_disable_intr(phba);
 
-	pci_set_drvdata(pdev, NULL);
 	scsi_host_put(shost);
 
 	/*
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 515c962..d1a4b82 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -534,7 +534,6 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 out_cmm_unreg:
-	pci_set_drvdata(pdev, NULL);
 	megaraid_cmm_unregister(adapter);
 out_fini_mbox:
 	megaraid_fini_mbox(adapter);
@@ -594,11 +593,6 @@ megaraid_detach_one(struct pci_dev *pdev)
 	// detach from the IO sub-system
 	megaraid_io_detach(adapter);
 
-	// reset the device state in the PCI structure. We check this
-	// condition when we enter here. If the device state is NULL,
-	// that would mean the device has already been removed
-	pci_set_drvdata(pdev, NULL);
-
 	// Unregister from common management module
 	//
 	// FIXME: this must return success or failure for conditions if there
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3020921..a6efc1e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4449,7 +4449,6 @@ retry_irq_register:
 	megasas_mgmt_info.instance[megasas_mgmt_info.max_index] = NULL;
 	megasas_mgmt_info.max_index--;
 
-	pci_set_drvdata(pdev, NULL);
 	instance->instancet->disable_intr(instance);
 	if (instance->msix_vectors)
 		for (i = 0 ; i < instance->msix_vectors; i++)
@@ -4805,8 +4804,6 @@ static void megasas_detach_one(struct pci_dev *pdev)
 		}
 	}
 
-	pci_set_drvdata(instance->pdev, NULL);
-
 	instance->instancet->disable_intr(instance);
 
 	if (instance->msix_vectors)
@@ -4848,8 +4845,6 @@ static void megasas_detach_one(struct pci_dev *pdev)
 				instance->evt_detail, instance->evt_detail_h);
 	scsi_host_put(host);
 
-	pci_set_drvdata(pdev, NULL);
-
 	pci_disable_device(pdev);
 
 	return;
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 7b7381d..5ff978b 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -657,7 +657,6 @@ static void mvs_pci_remove(struct pci_dev *pdev)
 	tasklet_kill(&((struct mvs_prv_info *)sha->lldd_ha)->mv_tasklet);
 #endif
 
-	pci_set_drvdata(pdev, NULL);
 	sas_unregister_ha(sha);
 	sas_remove_host(mvi->shost);
 	scsi_remove_host(mvi->shost);
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index d0b6a03..3206ba3 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2583,7 +2583,6 @@ static int mvumi_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 fail_io_attach:
-	pci_set_drvdata(pdev, NULL);
 	mhba->instancet->disable_intr(mhba);
 	free_irq(mhba->pdev->irq, mhba);
 fail_init_irq:
@@ -2618,7 +2617,6 @@ static void mvumi_detach_one(struct pci_dev *pdev)
 	free_irq(mhba->pdev->irq, mhba);
 	mvumi_release_fw(mhba);
 	scsi_host_put(host);
-	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 	dev_dbg(&pdev->dev, "driver is removed!\n");
 }
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index f7c1896..0dba7c7 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -873,7 +873,6 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 	struct pm8001_hba_info *pm8001_ha;
 	int i;
 	pm8001_ha = sha->lldd_ha;
-	pci_set_drvdata(pdev, NULL);
 	sas_unregister_ha(sha);
 	sas_remove_host(pm8001_ha->shost);
 	list_del(&pm8001_ha->list);
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 1eb7b028..e43db77 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -6049,7 +6049,6 @@ out_release_regions:
 
 out_disable_device:
 	atomic_dec(&pmcraid_adapter_count);
-	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 	return -ENODEV;
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9f01bbb..1db4819 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3183,7 +3183,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	pci_disable_pcie_error_reporting(pdev);
 
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 }
 
 static void
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f8a0a26..1be6cef 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -7400,7 +7400,6 @@ static void qla4xxx_remove_adapter(struct pci_dev *pdev)
 
 	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 }
 
 /**
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 325c31c..1aa4bef 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1790,8 +1790,6 @@ static void stex_remove(struct pci_dev *pdev)
 
 	scsi_remove_host(hba->host);
 
-	pci_set_drvdata(pdev, NULL);
-
 	stex_hba_stop(hba);
 
 	stex_hba_free(hba);
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 9327f5f..b06a1de 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2553,7 +2553,6 @@ static void dc390_remove_one(struct pci_dev *dev)
 
 	pci_disable_device(dev);
 	scsi_host_put(scsi_host);
-	pci_set_drvdata(dev, NULL);
 }
 
 static struct pci_device_id tmscsim_pci_tbl[] = {
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index a823cf4..8b95312 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -132,7 +132,6 @@ static void ufshcd_pci_remove(struct pci_dev *pdev)
 	pm_runtime_forbid(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 	ufshcd_remove(hba);
-	pci_set_drvdata(pdev, NULL);
 }
 
 /**
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 3bfaa66..b9755ec 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1405,7 +1405,6 @@ out_release_resources:
 out_free_host:
 	scsi_host_put(host);
 out_disable_device:
-	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 
 	return error;
@@ -1445,7 +1444,6 @@ static void pvscsi_remove(struct pci_dev *pdev)
 
 	scsi_host_put(host);
 
-	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 }
 
-- 
1.7.10.4



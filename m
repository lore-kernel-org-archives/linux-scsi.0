From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 8/9] mpt2sas: pdev drv data points to NULL while OS resume from hibernate mode
Date: Fri, 7 Aug 2009 19:38:48 +0530
Message-ID: <20090807140841.GI5807@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og120.obsmtp.com ([64.18.2.18]:57673 "EHLO
	exprod7og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbZHGOas (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 10:30:48 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com, stable@kernel.org

Fix another ocurring when the system resumes.  This oops was due to driver 
setting the pci drvdata to NULL on the prior hibernation.  Becuase it was 
set to NULL, upon resmume we assume the pci drvdata is non-zero, and we oops.
To fix the ooops, we don't set pci drvdata to NULL at hibernation time.

---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index c29c4f9..35a1386 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1171,7 +1171,6 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER *ioc)
 		}
 	}
 
-	pci_set_drvdata(pdev, ioc->shost);
 	_base_mask_interrupts(ioc);
 	r = _base_enable_msix(ioc);
 	if (r)
@@ -1194,7 +1193,6 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER *ioc)
 	ioc->pci_irq = -1;
 	pci_release_selected_regions(ioc->pdev, ioc->bars);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 	return r;
 }
 
@@ -3253,7 +3251,6 @@ mpt2sas_base_free_resources(struct MPT2SAS_ADAPTER *ioc)
 	ioc->chip_phys = 0;
 	pci_release_selected_regions(ioc->pdev, ioc->bars);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 	return;
 }
 
@@ -3275,6 +3272,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	if (r)
 		return r;
 
+	pci_set_drvdata(ioc->pdev, ioc->shost);
 	r = _base_make_ioc_ready(ioc, CAN_SLEEP, SOFT_RESET);
 	if (r)
 		goto out_free_resources;
@@ -3357,6 +3355,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	ioc->remove_host = 1;
 	mpt2sas_base_free_resources(ioc);
 	_base_release_memory_pools(ioc);
+	pci_set_drvdata(ioc->pdev, NULL);
 	kfree(ioc->tm_cmds.reply);
 	kfree(ioc->transport_cmds.reply);
 	kfree(ioc->config_cmds.reply);
@@ -3389,6 +3388,7 @@ mpt2sas_base_detach(struct MPT2SAS_ADAPTER *ioc)
 	mpt2sas_base_stop_watchdog(ioc);
 	mpt2sas_base_free_resources(ioc);
 	_base_release_memory_pools(ioc);
+	pci_set_drvdata(ioc->pdev, NULL);
 	kfree(ioc->pfacts);
 	kfree(ioc->ctl_cmds.reply);
 	kfree(ioc->base_cmds.reply);

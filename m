From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 09/20] [SCSI] megaraid: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 10:03:55 +0900
Message-ID: <000d01ceb7f8$c6cc4010$5464c030$%han@samsung.com>
References: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:32039 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3IWBD4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Sep 2013 21:03:56 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MTK00GPL0ADEPB0@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 23 Sep 2013 10:03:55 +0900 (KST)
In-reply-to: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>, 'Neela Syam Kolli' <megaraidlinux@lsi.com>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/megaraid/megaraid_mbox.c     |    6 ------
 drivers/scsi/megaraid/megaraid_sas_base.c |    5 -----
 2 files changed, 11 deletions(-)

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
-- 
1.7.10.4



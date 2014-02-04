From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 13/22] megaraid: Use pci_enable_msix_range()
Date: Tue,  4 Feb 2014 12:16:59 +0100
Message-ID: <ba26af069a9e8c1260b17210820be17f8eab0d63.1391512266.git.agordeev@redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071AbaBDLPv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Feb 2014 06:15:51 -0500
In-Reply-To: <cover.1391512266.git.agordeev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/megaraid/megaraid_sas_base.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3b7ad10..90944f1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3731,18 +3731,12 @@ static int megasas_init_fw(struct megasas_instance *instance)
 					     (unsigned int)num_online_cpus());
 		for (i = 0; i < instance->msix_vectors; i++)
 			instance->msixentry[i].entry = i;
-		i = pci_enable_msix(instance->pdev, instance->msixentry,
-				    instance->msix_vectors);
-		if (i >= 0) {
-			if (i) {
-				if (!pci_enable_msix(instance->pdev,
-						     instance->msixentry, i))
-					instance->msix_vectors = i;
-				else
-					instance->msix_vectors = 0;
-			}
-		} else
+		i = pci_enable_msix_range(instance->pdev, instance->msixentry,
+					  1, instance->msix_vectors);
+		if (i < 0)
 			instance->msix_vectors = 0;
+		else
+			instance->msix_vectors = i;
 
 		dev_info(&instance->pdev->dev, "[scsi%d]: FW supports"
 			"<%d> MSIX vector,Online CPUs: <%d>,"
@@ -4667,9 +4661,11 @@ megasas_resume(struct pci_dev *pdev)
 		goto fail_ready_state;
 
 	/* Now re-enable MSI-X */
-	if (instance->msix_vectors)
-		pci_enable_msix(instance->pdev, instance->msixentry,
-				instance->msix_vectors);
+	if (instance->msix_vectors &&
+	    pci_enable_msix_range(instance->pdev, instance->msixentry,
+				  instance->msix_vectors,
+				  instance->msix_vectors) < 0)
+		goto fail_reenable_msix;
 
 	switch (instance->pdev->device) {
 	case PCI_DEVICE_ID_LSI_FUSION:
@@ -4756,6 +4752,7 @@ fail_init_mfi:
 
 fail_set_dma_mask:
 fail_ready_state:
+fail_reenable_msix:
 
 	pci_disable_device(pdev);
 
-- 
1.7.7.6


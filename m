From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v3 03/13] megaraid: Fail resume if MSI-X re-initialization failed
Date: Mon, 18 Aug 2014 08:01:43 +0200
Message-ID: <674297e21ea4fc03f08694c1dd830d9113dd7965.1408335523.git.agordeev@redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p50936449.dip0.t-ipconnect.de ([80.147.100.73]:30499 "EHLO
	dhcp-27-160.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752293AbaHRIzR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Aug 2014 04:55:17 -0400
In-Reply-To: <cover.1408335523.git.agordeev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org

Currently the driver fails to analize MSI-X re-enablement
status on resuming and always assumes the success. This
update checks the MSI-X initialization result and fails
to resume if MSI-Xs re-enablement failed.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Kashyap Desai <Kashyap.desai@avagotech.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 22a04e3..e4ffae5 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5132,9 +5132,10 @@ megasas_resume(struct pci_dev *pdev)
 		goto fail_ready_state;
 
 	/* Now re-enable MSI-X */
-	if (instance->msix_vectors)
-		pci_enable_msix(instance->pdev, instance->msixentry,
-				instance->msix_vectors);
+	if (instance->msix_vectors &&
+	    pci_enable_msix(instance->pdev, instance->msixentry,
+			    instance->msix_vectors))
+		goto fail_reenable_msix;
 
 	switch (instance->pdev->device) {
 	case PCI_DEVICE_ID_LSI_FUSION:
@@ -5243,6 +5244,7 @@ fail_init_mfi:
 
 fail_set_dma_mask:
 fail_ready_state:
+fail_reenable_msix:
 
 	pci_disable_device(pdev);
 
-- 
1.9.3


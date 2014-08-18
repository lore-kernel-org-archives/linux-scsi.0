From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v3 04/13] megaraid: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Mon, 18 Aug 2014 08:01:44 +0200
Message-ID: <53f5625fafdf27f7404efd9ec497a718a2465dc2.1408335523.git.agordeev@redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <cover.1408335523.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Kashyap Desai <Kashyap.desai@avagotech.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e4ffae5..a2f4d4f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4103,17 +4103,11 @@ static int megasas_init_fw(struct megasas_instance *instance)
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
+		if (i)
+			instance->msix_vectors = i;
+		else
 			instance->msix_vectors = 0;
 
 		dev_info(&instance->pdev->dev, "[scsi%d]: FW supports"
@@ -5133,8 +5127,8 @@ megasas_resume(struct pci_dev *pdev)
 
 	/* Now re-enable MSI-X */
 	if (instance->msix_vectors &&
-	    pci_enable_msix(instance->pdev, instance->msixentry,
-			    instance->msix_vectors))
+	    pci_enable_msix_exact(instance->pdev, instance->msixentry,
+				  instance->msix_vectors))
 		goto fail_reenable_msix;
 
 	switch (instance->pdev->device) {
-- 
1.9.3

From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: [PATCH] megaraid_sas : Fix bug in handling return value of pci_enable_msix_range()
Date: Mon,  3 Nov 2014 20:44:20 +0800
Message-ID: <1415018660-30775-1-git-send-email-jiang.liu@linux.intel.com>
Return-path: <linux-pci-owner@vger.kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Alexander Gordeev <agordeev@redhat.com>, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Function pci_enable_msix_range() may return negative values for error
conditions. So it's a bug by checking (pci_enable_msix_range() != 0)
for success and causes failure to megaraid driver when MSI is disabled.
[   16.487267] megaraid_sas 0000:02:00.0: Controller type: iMR
[   16.487275] genirq: Flags mismatch irq 0. 00000000 (megasas) vs. 00015a00 (tii
mer)
[   16.487347] megasas: Failed to register IRQ for vector 0.

Fixes: 8ae80ed1734b "megaraid: Use pci_enable_msix_range() instead of pci_enable_msix()"

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: "Bjorn Helgaas <bhelgaas@google.com>"
Cc: linux-pci@vger.kernel.org
Cc: <stable@vger.kernel.org> # 3.17
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f6a69a3b1b3f..5640ad1c8214 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4453,7 +4453,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			instance->msixentry[i].entry = i;
 		i = pci_enable_msix_range(instance->pdev, instance->msixentry,
 					  1, instance->msix_vectors);
-		if (i)
+		if (i > 0)
 			instance->msix_vectors = i;
 		else
 			instance->msix_vectors = 0;
-- 
1.7.10.4

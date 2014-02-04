From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 10/22] isci: Use pci_enable_msix_range()
Date: Tue,  4 Feb 2014 12:16:56 +0100
Message-ID: <ff99281291c3189da00a7d8150da326808a723ea.1391512266.git.agordeev@redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <cover.1391512266.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Lukasz Dorau <lukasz.dorau@intel.com>, Maciej Patelczyk <maciej.patelczyk@intel.com>, Dave Jiang <dave.jiang@intel.com>, intel-linux-scu@intel.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: intel-linux-scu@intel.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/isci/init.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index d25d0d8..b99f307 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -356,8 +356,9 @@ static int isci_setup_interrupts(struct pci_dev *pdev)
 	for (i = 0; i < num_msix; i++)
 		pci_info->msix_entries[i].entry = i;
 
-	err = pci_enable_msix(pdev, pci_info->msix_entries, num_msix);
-	if (err)
+	err = pci_enable_msix_range(pdev,
+				    pci_info->msix_entries, num_msix, num_msix);
+	if (err < 0)
 		goto intx;
 
 	for (i = 0; i < num_msix; i++) {
-- 
1.7.7.6

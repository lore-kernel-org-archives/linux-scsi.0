From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 14/22] mpt2sas: Use pci_enable_msix_range()
Date: Tue,  4 Feb 2014 12:17:00 +0100
Message-ID: <9502363c4325496286e36221acaff63da3af42b0.1391512266.git.agordeev@redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <cover.1391512266.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: support@lsi.com
Cc: DL-MPTFusionLinux@lsi.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 3901edc..a0662cb 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1432,10 +1432,13 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	for (i = 0, a = entries; i < ioc->reply_queue_count; i++, a++)
 		a->entry = i;
 
-	r = pci_enable_msix(ioc->pdev, entries, ioc->reply_queue_count);
-	if (r) {
-		dfailprintk(ioc, printk(MPT2SAS_INFO_FMT "pci_enable_msix "
-		    "failed (r=%d) !!!\n", ioc->name, r));
+	r = pci_enable_msix_range(ioc->pdev,
+				  entries,
+				  ioc->reply_queue_count,
+				  ioc->reply_queue_count);
+	if (r < 0) {
+		dfailprintk(ioc, printk(MPT2SAS_INFO_FMT
+		    "pci_enable_msix_range failed (r=%d) !!!\n", ioc->name, r));
 		kfree(entries);
 		goto try_ioapic;
 	}
-- 
1.7.7.6

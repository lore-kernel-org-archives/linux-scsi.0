From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 RESEND 15/23] mpt2sas: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Mon, 14 Apr 2014 10:05:39 +0200
Message-ID: <2b4bec5ef13a1991423a6cc3fb1b391b9e7c0aad.1397461652.git.agordeev@redhat.com>
References: <cover.1397461652.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1397461652.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: support@lsi.com
Cc: DL-MPTFusionLinux@lsi.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index bde63f7..984b605 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1432,10 +1432,10 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	for (i = 0, a = entries; i < ioc->reply_queue_count; i++, a++)
 		a->entry = i;
 
-	r = pci_enable_msix(ioc->pdev, entries, ioc->reply_queue_count);
+	r = pci_enable_msix_exact(ioc->pdev, entries, ioc->reply_queue_count);
 	if (r) {
-		dfailprintk(ioc, printk(MPT2SAS_INFO_FMT "pci_enable_msix "
-		    "failed (r=%d) !!!\n", ioc->name, r));
+		dfailprintk(ioc, printk(MPT2SAS_INFO_FMT
+		    "pci_enable_msix_exact failed (r=%d) !!!\n", ioc->name, r));
 		kfree(entries);
 		goto try_ioapic;
 	}
-- 
1.7.7.6

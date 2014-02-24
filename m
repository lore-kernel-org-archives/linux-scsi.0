From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 16/23] mpt3sas: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Mon, 24 Feb 2014 09:02:16 +0100
Message-ID: <2246a2223fbad5826f766fad04aacf485bcb156d.1393191330.git.agordeev@redhat.com>
References: <cover.1393191330.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1393191330.git.agordeev@redhat.com>
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
 drivers/scsi/mpt3sas/mpt3sas_base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0cf4f70..7b65ec2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1747,10 +1747,10 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	for (i = 0, a = entries; i < ioc->reply_queue_count; i++, a++)
 		a->entry = i;
 
-	r = pci_enable_msix(ioc->pdev, entries, ioc->reply_queue_count);
+	r = pci_enable_msix_exact(ioc->pdev, entries, ioc->reply_queue_count);
 	if (r) {
 		dfailprintk(ioc, pr_info(MPT3SAS_FMT
-			"pci_enable_msix failed (r=%d) !!!\n",
+			"pci_enable_msix_exact failed (r=%d) !!!\n",
 			ioc->name, r));
 		kfree(entries);
 		goto try_ioapic;
-- 
1.7.7.6

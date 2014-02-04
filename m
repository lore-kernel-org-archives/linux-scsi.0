From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 15/22] mpt3sas: Use pci_enable_msix_range()
Date: Tue,  4 Feb 2014 12:17:01 +0100
Message-ID: <de0561cedef079511f9bf17e0903d93cd11785ac.1391512266.git.agordeev@redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbaBDLP4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Feb 2014 06:15:56 -0500
In-Reply-To: <cover.1391512266.git.agordeev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org

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
 drivers/scsi/mpt3sas/mpt3sas_base.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index fa78506..46f1fba 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1747,10 +1747,13 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	for (i = 0, a = entries; i < ioc->reply_queue_count; i++, a++)
 		a->entry = i;
 
-	r = pci_enable_msix(ioc->pdev, entries, ioc->reply_queue_count);
-	if (r) {
+	r = pci_enable_msix_range(ioc->pdev,
+				  entries,
+				  ioc->reply_queue_count,
+				  ioc->reply_queue_count);
+	if (r < 0) {
 		dfailprintk(ioc, pr_info(MPT3SAS_FMT
-			"pci_enable_msix failed (r=%d) !!!\n",
+			"pci_enable_msix_range failed (r=%d) !!!\n",
 			ioc->name, r));
 		kfree(entries);
 		goto try_ioapic;
-- 
1.7.7.6


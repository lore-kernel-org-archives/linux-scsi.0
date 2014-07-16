From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 RESEND 22/23] qla4xxx: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Wed, 16 Jul 2014 20:05:26 +0200
Message-ID: <0496ccbc0f203afaeeb7758c146b93c2f387684c.1405533479.git.agordeev@redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965798AbaGPSFb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2014 14:05:31 -0400
In-Reply-To: <cover.1405533479.git.agordeev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, iscsi-driver@qlogic.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: iscsi-driver@qlogic.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Acked-By: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 9dbdb4b..7c33658 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -4221,7 +4221,7 @@ qla4_8xxx_enable_msix(struct scsi_qla_host *ha)
 	for (i = 0; i < QLA_MSIX_ENTRIES; i++)
 		entries[i].entry = qla4_8xxx_msix_entries[i].entry;
 
-	ret = pci_enable_msix(ha->pdev, entries, ARRAY_SIZE(entries));
+	ret = pci_enable_msix_exact(ha->pdev, entries, ARRAY_SIZE(entries));
 	if (ret) {
 		ql4_printk(KERN_WARNING, ha,
 		    "MSI-X: Failed to enable support -- %d/%d\n",
-- 
1.7.7.6


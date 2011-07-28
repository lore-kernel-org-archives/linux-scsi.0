From: David Miller <davem@davemloft.net>
Subject: [PATCH 1/2] mpt2sas: MSI-X vector table is ioremap()'d memory,
 access it as such.
Date: Wed, 27 Jul 2011 23:20:45 -0700 (PDT)
Message-ID: <20110727.232045.1471353054008102231.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:50241 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab1G1GUs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2011 02:20:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kashyap.Desai@lsi.com, eric.moore@lsi.com


The MSI-X vector table lives in ioremap() mapped memory, therefore it
must be accessed using readl/writel and be annotated with __iomem.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    6 +++---
 drivers/scsi/mpt2sas/mpt2sas_base.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 83035bd..543cd07 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1096,7 +1096,7 @@ _base_save_msix_table(struct MPT2SAS_ADAPTER *ioc)
 		return;
 
 	for (i = 0; i < ioc->msix_vector_count; i++)
-		ioc->msix_table_backup[i] = ioc->msix_table[i];
+		ioc->msix_table_backup[i] = readl(&ioc->msix_table[i]);
 }
 
 /**
@@ -1113,7 +1113,7 @@ _base_restore_msix_table(struct MPT2SAS_ADAPTER *ioc)
 		return;
 
 	for (i = 0; i < ioc->msix_vector_count; i++)
-		ioc->msix_table[i] = ioc->msix_table_backup[i];
+		writel(ioc->msix_table_backup[i], &ioc->msix_table[i]);
 }
 
 /**
@@ -1144,7 +1144,7 @@ _base_check_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	/* get msix table  */
 	pci_read_config_dword(ioc->pdev, base + 4, &msix_table_offset);
 	msix_table_offset &= 0xFFFFFFF8;
-	ioc->msix_table = (u32 *)((void *)ioc->chip + msix_table_offset);
+	ioc->msix_table = (u32 __iomem *)((void __iomem *)ioc->chip + msix_table_offset);
 
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "msix is supported, "
 	    "vector_count(%d), table_offset(0x%08x), table(%p)\n", ioc->name,
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 8d5be21..9a88fb9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -779,7 +779,7 @@ struct MPT2SAS_ADAPTER {
 
 	u8		msix_enable;
 	u16		msix_vector_count;
-	u32		*msix_table;
+	u32 __iomem	*msix_table;
 	u32		*msix_table_backup;
 	u32		ioc_reset_count;
 
-- 
1.7.6


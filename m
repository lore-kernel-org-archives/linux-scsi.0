From: David Miller <davem@davemloft.net>
Subject: [PATCH]: mpt2sas crashes on shutdown
Date: Mon, 26 Dec 2011 14:59:20 -0500 (EST)
Message-ID: <20111226.145920.1088076837634135764.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:39939 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab1LZT7Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Dec 2011 14:59:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stable@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, nagalakshmi.nandigama@lsi.com


The mpt2sas driver accesses I/O space as virtual addresses when
saving and restoring the MSIX table, this only works by luck on x86.

One needs to use the appropriate {read,write}{b,w,l}() APIs.

This is fixed in v3.2.x because all of this code got rewritten for
NUMA I/O support.

But both 3.0.x and 3.1.x still have this bug, and my Niagara sparc
machines crash on shutdown every single time due to this bug making my
-stable work more difficult than it needs to be.

Please apply to both 3.0.x-stable and 3.1.x-stable, thanks.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 83035bd..8cec3bd 100644
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
+	ioc->msix_table = ((void __iomem *)ioc->chip + msix_table_offset);
 
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "msix is supported, "
 	    "vector_count(%d), table_offset(0x%08x), table(%p)\n", ioc->name,
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 41a57a7..a8782f3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -768,7 +768,7 @@ struct MPT2SAS_ADAPTER {
 
 	u8		msix_enable;
 	u16		msix_vector_count;
-	u32		*msix_table;
+	u32 __iomem	*msix_table;
 	u32		*msix_table_backup;
 	u32		ioc_reset_count;
 

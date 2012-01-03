From: Greg KH <gregkh@suse.de>
Subject: [41/67] mpt2sas crashes on shutdown
Date: Tue, 03 Jan 2012 14:29:59 -0800
Message-ID: <20120103223034.779901025@clark.kroah.org>
References: <20120103223043.GA26738@kroah.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, linux-scsi@vger.kernel.org, nagalakshmi.nandigama@lsi.com, "David S. Miller" <davem@davemloft.net>, Eric Moore <Eric.Moore@lsi.com>
List-Id: linux-scsi@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Miller <davem@davemloft.net>

[Fixed differently in 3.2]

The mpt2sas driver accesses I/O space as virtual addresses when
saving and restoring the MSIX table, this only works by luck on x86.

One needs to use the appropriate {read,write}{b,w,l}() APIs.

This is fixed in v3.2.x because all of this code got rewritten for
NUMA I/O support.

But both 3.0.x and 3.1.x still have this bug, and my Niagara sparc
machines crash on shutdown every single time due to this bug making my
-stable work more difficult than it needs to be.


Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Eric Moore <Eric.Moore@lsi.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    6 +++---
 drivers/scsi/mpt2sas/mpt2sas_base.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1096,7 +1096,7 @@ _base_save_msix_table(struct MPT2SAS_ADA
 		return;
 
 	for (i = 0; i < ioc->msix_vector_count; i++)
-		ioc->msix_table_backup[i] = ioc->msix_table[i];
+		ioc->msix_table_backup[i] = readl(&ioc->msix_table[i]);
 }
 
 /**
@@ -1113,7 +1113,7 @@ _base_restore_msix_table(struct MPT2SAS_
 		return;
 
 	for (i = 0; i < ioc->msix_vector_count; i++)
-		ioc->msix_table[i] = ioc->msix_table_backup[i];
+		writel(ioc->msix_table_backup[i], &ioc->msix_table[i]);
 }
 
 /**
@@ -1144,7 +1144,7 @@ _base_check_enable_msix(struct MPT2SAS_A
 	/* get msix table  */
 	pci_read_config_dword(ioc->pdev, base + 4, &msix_table_offset);
 	msix_table_offset &= 0xFFFFFFF8;
-	ioc->msix_table = (u32 *)((void *)ioc->chip + msix_table_offset);
+	ioc->msix_table = ((void __iomem *)ioc->chip + msix_table_offset);
 
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "msix is supported, "
 	    "vector_count(%d), table_offset(0x%08x), table(%p)\n", ioc->name,
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -768,7 +768,7 @@ struct MPT2SAS_ADAPTER {
 
 	u8		msix_enable;
 	u16		msix_vector_count;
-	u32		*msix_table;
+	u32 __iomem	*msix_table;
 	u32		*msix_table_backup;
 	u32		ioc_reset_count;
 

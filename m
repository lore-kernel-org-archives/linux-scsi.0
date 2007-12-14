From: akpm@linux-foundation.org
Subject: [patch 14/30] aic94: fix section mismatches
Date: Thu, 13 Dec 2007 16:14:16 -0800
Message-ID: <200712140014.lBE0EGoL026210@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47738 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934286AbXLNAO5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 19:14:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, randy.dunlap@oracle.com

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warning:

WARNING: vmlinux.o(.init.text+0x23be6): Section mismatch: reference to .exit.text:asd_unmap_ha (between 'asd_pci_probe' and 'qla4xxx_module_init')
+
WARNING: vmlinux.o(.text+0x1ec8a8): Section mismatch: reference to .exit.text:as
d_unmap_ioport (between 'asd_unmap_ha' and 'asd_remove_dev_attrs')
WARNING: vmlinux.o(.text+0x1ec8b1): Section mismatch: reference to .exit.text:as
d_unmap_memio (between 'asd_unmap_ha' and 'asd_remove_dev_attrs')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic94xx/aic94xx_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/aic94xx/aic94xx_init.c~aic94-fix-section-mismatches drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c~aic94-fix-section-mismatches
+++ a/drivers/scsi/aic94xx/aic94xx_init.c
@@ -136,7 +136,7 @@ Err:
 	return err;
 }
 
-static void __devexit asd_unmap_memio(struct asd_ha_struct *asd_ha)
+static void asd_unmap_memio(struct asd_ha_struct *asd_ha)
 {
 	struct asd_ha_addrspace *io_handle;
 
@@ -173,7 +173,7 @@ static int __devinit asd_map_ioport(stru
 	return err;
 }
 
-static void __devexit asd_unmap_ioport(struct asd_ha_struct *asd_ha)
+static void asd_unmap_ioport(struct asd_ha_struct *asd_ha)
 {
 	pci_release_region(asd_ha->pcidev, PCI_IOBAR_OFFSET);
 }
@@ -210,7 +210,7 @@ Err:
 	return err;
 }
 
-static void __devexit asd_unmap_ha(struct asd_ha_struct *asd_ha)
+static void asd_unmap_ha(struct asd_ha_struct *asd_ha)
 {
 	if (asd_ha->iospace)
 		asd_unmap_ioport(asd_ha);
_

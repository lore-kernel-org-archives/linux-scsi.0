From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] aic94: fix section mismatches
Date: Mon, 29 Oct 2007 11:20:35 -0700
Message-ID: <20071029112035.b677bdfe.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:21645 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759991AbXJ2SWS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 14:22:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: hare@suse.de, jejb <james.bottomley@steeleye.com>, akpm <akpm@linux-foundation.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warning:

WARNING: vmlinux.o(.init.text+0x23be6): Section mismatch: reference to .exit.text:asd_unmap_ha (between 'asd_pci_probe' and 'qla4xxx_module_init')
+
WARNING: vmlinux.o(.text+0x1ec8a8): Section mismatch: reference to .exit.text:as
d_unmap_ioport (between 'asd_unmap_ha' and 'asd_remove_dev_attrs')
WARNING: vmlinux.o(.text+0x1ec8b1): Section mismatch: reference to .exit.text:as
d_unmap_memio (between 'asd_unmap_ha' and 'asd_remove_dev_attrs')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/aic94xx/aic94xx_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2624-rc1g4-v1.orig/drivers/scsi/aic94xx/aic94xx_init.c
+++ linux-2624-rc1g4-v1/drivers/scsi/aic94xx/aic94xx_init.c
@@ -134,7 +134,7 @@ Err:
 	return err;
 }
 
-static void __devexit asd_unmap_memio(struct asd_ha_struct *asd_ha)
+static void asd_unmap_memio(struct asd_ha_struct *asd_ha)
 {
 	struct asd_ha_addrspace *io_handle;
 
@@ -171,7 +171,7 @@ static int __devinit asd_map_ioport(stru
 	return err;
 }
 
-static void __devexit asd_unmap_ioport(struct asd_ha_struct *asd_ha)
+static void asd_unmap_ioport(struct asd_ha_struct *asd_ha)
 {
 	pci_release_region(asd_ha->pcidev, PCI_IOBAR_OFFSET);
 }
@@ -208,7 +208,7 @@ Err:
 	return err;
 }
 
-static void __devexit asd_unmap_ha(struct asd_ha_struct *asd_ha)
+static void asd_unmap_ha(struct asd_ha_struct *asd_ha)
 {
 	if (asd_ha->iospace)
 		asd_unmap_ioport(asd_ha);

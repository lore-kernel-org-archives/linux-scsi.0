From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] gdth: fix section mismatch warnings
Date: Wed, 08 Oct 2008 14:24:48 -0700
Message-ID: <48ED2520.1080203@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:16257 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbYJHV0N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2008 17:26:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Achim Leubner <achim_leubner@adaptec.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Could fix a bug in a hotplug scenario.

WARNING: drivers/scsi/gdth.o(.text+0x3e6d): Section mismatch in reference from the function gdth_pci_probe_one() to the function .init.text:gdth_search_drives()
The function gdth_pci_probe_one() references
the function __init gdth_search_drives().
This is often because gdth_pci_probe_one lacks a __init 
annotation or the annotation of gdth_search_drives is wrong.

WARNING: drivers/scsi/gdth.o(.text+0x3f78): Section mismatch in reference from the function gdth_pci_probe_one() to the function .init.text:gdth_enable_int()
The function gdth_pci_probe_one() references
the function __init gdth_enable_int().
This is often because gdth_pci_probe_one lacks a __init 
annotation or the annotation of gdth_enable_int is wrong.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Achim Leubner <achim_leubner@adaptec.com>
---
 drivers/scsi/gdth.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- lin2627-r9g1-sections.orig/drivers/scsi/gdth.c
+++ lin2627-r9g1-sections/drivers/scsi/gdth.c
@@ -1238,7 +1238,7 @@ static int gdth_init_pci(struct pci_dev 
 
 /* controller protocol functions */
 
-static void __init gdth_enable_int(gdth_ha_str *ha)
+static void gdth_enable_int(gdth_ha_str *ha)
 {
     ulong flags;
     gdt2_dpram_str __iomem *dp2_ptr;
@@ -1554,7 +1554,7 @@ static int gdth_internal_cmd(gdth_ha_str
 
 /* search for devices */
 
-static int __init gdth_search_drives(gdth_ha_str *ha)
+static int gdth_search_drives(gdth_ha_str *ha)
 {
     ushort cdev_cnt, i;
     int ok;
@@ -4919,7 +4919,7 @@ static int __init gdth_eisa_probe_one(us
 #endif /* CONFIG_EISA */
 
 #ifdef CONFIG_PCI
-static int gdth_pci_probe_one(gdth_pci_str *pcistr,
+int gdth_pci_probe_one(gdth_pci_str *pcistr,
 			     gdth_ha_str **ha_out)
 {
 	struct Scsi_Host *shp;

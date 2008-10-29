From: akpm@linux-foundation.org
Subject: [patch 11/17] gdth: fix section mismatch warnings
Date: Wed, 29 Oct 2008 14:24:43 -0700
Message-ID: <200810292124.m9TLOi0t021268@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755372AbYJ2VZn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 17:25:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, randy.dunlap@oracle.com, achim_leubner@adaptec.com

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
Cc: Achim Leubner <achim_leubner@adaptec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/gdth.c~gdth-fix-section-mismatch-warnings drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~gdth-fix-section-mismatch-warnings
+++ a/drivers/scsi/gdth.c
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
@@ -4932,7 +4932,7 @@ static int __init gdth_eisa_probe_one(us
 #endif /* CONFIG_EISA */
 
 #ifdef CONFIG_PCI
-static int gdth_pci_probe_one(gdth_pci_str *pcistr,
+int gdth_pci_probe_one(gdth_pci_str *pcistr,
 			     gdth_ha_str **ha_out)
 {
 	struct Scsi_Host *shp;
_

From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] SCSI gdth __init fixes
Date: Thu, 18 Oct 2007 12:51:05 +0200
Message-ID: <20071018105104.GH3778@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44747 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764164AbXJRKul (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 06:50:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, achim_leubner@adaptec.com, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch fixes the following build warnings:

<--  snip  -->

...
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0xbcffdb): Section mismatch: reference to .init.text.20:gdth_search_drives (between 'gdth_pci_probe_one' and 'gdth_start_timeout')
WARNING: vmlinux.o(.text+0xbd0102): Section mismatch: reference to .init.text.20:gdth_enable_int (between 'gdth_pci_probe_one' and 'gdth_start_timeout')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/gdth.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

81e1643617f1b0f76a5804359d2988dc523d0cc3 
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 3ac080e..56de5a6 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4734,7 +4734,7 @@ static struct scsi_host_template gdth_template = {
 };
 
 #ifdef CONFIG_ISA
-static int gdth_isa_probe_one(ulong32 isa_bios)
+static int __init gdth_isa_probe_one(ulong32 isa_bios)
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
@@ -4862,7 +4862,7 @@ static int gdth_isa_probe_one(ulong32 isa_bios)
 #endif /* CONFIG_ISA */
 
 #ifdef CONFIG_EISA
-static int gdth_eisa_probe_one(ushort eisa_slot)
+static int __init gdth_eisa_probe_one(ushort eisa_slot)
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
@@ -4991,7 +4991,7 @@ static int gdth_eisa_probe_one(ushort eisa_slot)
 #endif /* CONFIG_EISA */
 
 #ifdef CONFIG_PCI
-static int gdth_pci_probe_one(gdth_pci_str *pcistr, int ctr)
+static int __init gdth_pci_probe_one(gdth_pci_str *pcistr, int ctr)
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;


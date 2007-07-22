From: Gabriel C <nix.or.die@googlemail.com>
Subject: [PATCH] Fix drivers/scsi/fdomain.c , CONFIG_PCI=n warnings
Date: Sun, 22 Jul 2007 19:39:55 +0200
Message-ID: <46A3966B.9000601@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:2093 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbXGVRmN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 13:42:13 -0400
Received: by ug-out-1314.google.com with SMTP id j3so995912ugf
        for <linux-scsi@vger.kernel.org>; Sun, 22 Jul 2007 10:42:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org

Hi,

I get this warnings on current git when CONFIG_PCI is not set :

...

drivers/scsi/fdomain.c:390: warning: 'PCI_dev' defined but not used
drivers/scsi/fdomain.c:1768: warning: 'fdomain_pci_tbl' defined but not used

...


Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 36169d5..5d282e6 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -387,7 +387,9 @@ static void __iomem *    bios_mem;
 static int               bios_major;
 static int               bios_minor;
 static int               PCI_bus;
+#ifdef CONFIG_PCI
 static struct pci_dev	*PCI_dev;
+#endif
 static int               Quantum;	/* Quantum board variant */
 static int               interrupt_level;
 static volatile int      in_command;
@@ -1764,6 +1766,7 @@ struct scsi_host_template fdomain_driver_template = {
 };
 
 #ifndef PCMCIA
+#ifdef CONFIG_PCI
 
 static struct pci_device_id fdomain_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_FD, PCI_DEVICE_ID_FD_36C70,
@@ -1771,7 +1774,7 @@ static struct pci_device_id fdomain_pci_tbl[] __devinitdata = {
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, fdomain_pci_tbl);
-
+#endif
 #define driver_template fdomain_driver_template
 #include "scsi_module.c"
 

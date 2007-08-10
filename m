From: akpm@linux-foundation.org
Subject: [patch 12/30] Fix drivers/scsi/fdomain.c CONFIG_PCI=n warnings
Date: Fri, 10 Aug 2007 14:50:40 -0700
Message-ID: <200708102150.l7ALoe6g011351@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33844 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752418AbXHJV71 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 17:59:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, nix.or.die@googlemail.com

From: Gabriel C <nix.or.die@googlemail.com>

I get this warnings on current git when CONFIG_PCI is not set :

drivers/scsi/fdomain.c:390: warning: 'PCI_dev' defined but not used
drivers/scsi/fdomain.c:1768: warning: 'fdomain_pci_tbl' defined but not used

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/fdomain.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/fdomain.c~fix-drivers-scsi-fdomainc-config_pci=n-warnings drivers/scsi/fdomain.c
--- a/drivers/scsi/fdomain.c~fix-drivers-scsi-fdomainc-config_pci=n-warnings
+++ a/drivers/scsi/fdomain.c
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
@@ -1764,6 +1766,7 @@ struct scsi_host_template fdomain_driver
 };
 
 #ifndef PCMCIA
+#ifdef CONFIG_PCI
 
 static struct pci_device_id fdomain_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_FD, PCI_DEVICE_ID_FD_36C70,
@@ -1771,7 +1774,7 @@ static struct pci_device_id fdomain_pci_
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, fdomain_pci_tbl);
-
+#endif
 #define driver_template fdomain_driver_template
 #include "scsi_module.c"
 
_

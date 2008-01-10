From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] megaraid: fix section mismatch
Date: Thu, 10 Jan 2008 14:33:16 -0800
Message-ID: <20080110143316.071efbc1.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:63414 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759075AbYAJWdj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 17:33:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: megaraidlinux@lsi.com, scsi <linux-scsi@vger.kernel.org>
Cc: jejb <James.Bottomley@HansenPartnership.com>, akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Change megaraid_pci_driver_g variable name so that it matches the modpost
whitelist that allows pointers to init text/data.

WARNING: vmlinux.o(.data+0x1a8e30): Section mismatch: reference to .init.text:megaraid_probe_one (between 'megaraid_pci_driver_g' and 'class_device_attr_megaraid_mbox_app_hndl')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/megaraid/megaraid_mbox.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.24-rc7-git1.orig/drivers/scsi/megaraid/megaraid_mbox.c
+++ linux-2.6.24-rc7-git1/drivers/scsi/megaraid/megaraid_mbox.c
@@ -300,7 +300,7 @@ static struct pci_device_id pci_id_table
 MODULE_DEVICE_TABLE(pci, pci_id_table_g);
 
 
-static struct pci_driver megaraid_pci_driver_g = {
+static struct pci_driver megaraid_pci_driver = {
 	.name		= "megaraid",
 	.id_table	= pci_id_table_g,
 	.probe		= megaraid_probe_one,
@@ -394,7 +394,7 @@ megaraid_init(void)
 
 
 	// register as a PCI hot-plug driver module
-	rval = pci_register_driver(&megaraid_pci_driver_g);
+	rval = pci_register_driver(&megaraid_pci_driver);
 	if (rval < 0) {
 		con_log(CL_ANN, (KERN_WARNING
 			"megaraid: could not register hotplug support.\n"));
@@ -415,7 +415,7 @@ megaraid_exit(void)
 	con_log(CL_DLEVEL1, (KERN_NOTICE "megaraid: unloading framework\n"));
 
 	// unregister as PCI hotplug driver
-	pci_unregister_driver(&megaraid_pci_driver_g);
+	pci_unregister_driver(&megaraid_pci_driver);
 
 	return;
 }

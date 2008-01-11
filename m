From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [PATCH] megaraid: fix section mismatch
Date: Thu, 10 Jan 2008 19:40:16 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229E02CD7@NAMAIL2.ad.lsil.com>
References: <20080110143316.071efbc1.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:33654 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbYAKCkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 21:40:47 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20080110143316.071efbc1.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, scsi <linux-scsi@vger.kernel.org>
Cc: jejb <James.Bottomley@HansenPartnership.com>, akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>

Ack.

--Sumant 

-----Original Message-----
From: Randy Dunlap [mailto:randy.dunlap@oracle.com] 
Sent: Thursday, January 10, 2008 2:33 PM
To: DL-MegaRAID Linux; scsi
Cc: jejb; akpm; samr
Subject: [PATCH] megaraid: fix section mismatch

From: Randy Dunlap <randy.dunlap@oracle.com>

Change megaraid_pci_driver_g variable name so that it matches the
modpost whitelist that allows pointers to init text/data.

WARNING: vmlinux.o(.data+0x1a8e30): Section mismatch: reference to
.init.text:megaraid_probe_one (between 'megaraid_pci_driver_g' and
'class_device_attr_megaraid_mbox_app_hndl')

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
 			"megaraid: could not register hotplug
support.\n")); @@ -415,7 +415,7 @@ megaraid_exit(void)
 	con_log(CL_DLEVEL1, (KERN_NOTICE "megaraid: unloading
framework\n"));
 
 	// unregister as PCI hotplug driver
-	pci_unregister_driver(&megaraid_pci_driver_g);
+	pci_unregister_driver(&megaraid_pci_driver);
 
 	return;
 }

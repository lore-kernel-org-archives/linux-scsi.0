From: Daniel Drake <dsd@gentoo.org>
Subject: [PATCH] Allow both megaraid drivers to be built
Date: Mon, 29 Aug 2005 15:50:19 +0100
Message-ID: <431320AB.7010303@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090600010608080309010608"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta07-winn.ispmail.ntl.com ([81.103.221.47]:60194 "EHLO
	mta07-winn.ispmail.ntl.com") by vger.kernel.org with ESMTP
	id S1750941AbVH2Oqw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 10:46:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, sreenib@lsil.com, sju@lsil.com

This is a multi-part message in MIME format.
--------------090600010608080309010608
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Currently, the two megaraid drivers are exclusive - if you build the "new 
generation" megaraid driver then you aren't able to build the old one.

I've been investigating this as this is not ideal: the old driver supports a 
lot of common hardware which the new driver does not, and vice-versa.

The two drivers compile together ok but will clash at runtime, due to the same 
name in the pci_driver struct. However I presume that the main reason that 
these drivers exclude each other is because there is some hardware support 
overlap - the new driver supports some hardware which would also be claimed by 
the old, not a sensible thing to do if both can be built and run in parallel.

The hardware overlap isn't straightforward - the newgen driver supports mostly 
a specific set of pid/vid/sspid/ssvid whereas the legacy one supports pid/vid 
pairs and accepts _any_ subsystem id's.

For example, the legacy driver will claim any device with vendor=101E 
product=1960. The newgen driver also lists those ID numbers but only against 5 
different subsystem id pairs, it won't claim "the whole lot".

I have repeatedly tried to contact LSI Logic to find out more about this 
overlap. In the above example, are there devices which have the ID's 
vendor=101E product=1960 and a subsystem _not_ listed in the newgen driver? 
These devices would be claimed by the old driver and not the new - is there a 
reason for this - would they not work with the newgen driver? Do they even 
exist at all?

I have recieved no real response from LSIL so I have produced this patch, 
which has been included on Gentoo's latest release media where both drivers 
have been built alongside each other and we have not recieved any negative 
reports about it. (hopefully those legacy users are over the moon because they 
can install gentoo again!)

This patch makes the assumption that in the above example there are no 
101E/1960 adapters anywhere in the world that have subsystem ID's not listed 
in the newgen driver, and the same for the other device support overlaps. This 
results in the newgen driver being favoured (which apparently performs much 
better than the legacy on the devices which are supported by both) when both 
are built together -- however the device support in the old driver will be 
*unchanged* if you do not build the new one alongside it.

I know that this solution is not ideal, but as LSIL are being uncooperative, I 
think this is the best compromise we can do for now. Please apply.

Signed-off-by: Daniel Drake <dsd@gentoo.org>

--------------090600010608080309010608
Content-Type: text/x-patch;
 name="4351_megaraid-compatibility.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="4351_megaraid-compatibility.patch"

diff -urNp linux-2.6.12/drivers/scsi-orig/megaraid/Kconfig.megaraid linux-2.6.12/drivers/scsi/megaraid/Kconfig.megaraid
--- linux-2.6.12/drivers/scsi-orig/megaraid/Kconfig.megaraid	2005-06-29 16:19:55.000000000 +0100
+++ linux-2.6.12/drivers/scsi/megaraid/Kconfig.megaraid	2005-06-29 16:22:12.000000000 +0100
@@ -64,7 +64,6 @@ config MEGARAID_MAILBOX
 	To compile this driver as a module, choose M here: the
 	module will be called megaraid_mbox
 
-if MEGARAID_NEWGEN=n
 config MEGARAID_LEGACY
 	tristate "LSI Logic Legacy MegaRAID Driver"
 	depends on PCI && SCSI
@@ -75,4 +74,4 @@ config MEGARAID_LEGACY
 
 	To compile this driver as a module, choose M here: the
 	module will be called megaraid
-endif
+
diff -urNp linux-2.6.12/drivers/scsi-orig/megaraid.c linux-2.6.12/drivers/scsi/megaraid.c
--- linux-2.6.12/drivers/scsi-orig/megaraid.c	2005-06-29 16:19:55.000000000 +0100
+++ linux-2.6.12/drivers/scsi/megaraid.c	2005-06-30 13:07:41.000000000 +0100
@@ -5033,28 +5033,34 @@ megaraid_shutdown(struct device *dev)
 }
 
 static struct pci_device_id megaraid_pci_tbl[] = {
+#ifndef CONFIG_MEGARAID_NEWGEN
 	{PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_DISCOVERY,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_PERC4_DI,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, BOARD_64BIT},
 	{PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_PERC4_QC_VERDE,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, BOARD_64BIT},
+#endif
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID2,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+#ifndef CONFIG_MEGARAID_NEWGEN
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID3,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+#endif
 	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_AMI_MEGARAID3,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+#ifndef CONFIG_MEGARAID_NEWGEN
 	{PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_AMI_MEGARAID3,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+#endif
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, megaraid_pci_tbl);
 
 static struct pci_driver megaraid_pci_driver = {
-	.name		= "megaraid",
+	.name		= "megaraid_legacy",
 	.id_table	= megaraid_pci_tbl,
 	.probe		= megaraid_probe_one,
 	.remove		= __devexit_p(megaraid_remove_one),

--------------090600010608080309010608--

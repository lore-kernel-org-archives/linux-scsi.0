From: David Jeffery <david_jeffery@adaptec.com>
Subject: [PATCH 2.5] ips: remove arch limitations
Date: 28 Aug 2003 12:07:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1062086838.25316.32.camel@blackmagic>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-0TlZJXPbHAND8y9wHRSo"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:11453 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S264084AbTH1QEk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2003 12:04:40 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id h7SG4do29003
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2003 09:04:39 -0700
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8p2+Sun/8.8.8) with ESMTP id JAA18993
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2003 09:04:38 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


--=-0TlZJXPbHAND8y9wHRSo
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch removes the X86 arch limitation in drivers/scsi/Kconfig,
downgrades the #error check for x86/x86_64/ia64 to a #warning, and
updates an old email address in the help.

It also fixes up a two places in the driver which have 8 spaces instead
of a tab for indention.

David Jeffery

--=-0TlZJXPbHAND8y9wHRSo
Content-Disposition: attachment; filename=test4.patch
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=test4.patch; charset=ANSI_X3.4-1968

diff -urN linux-2.6.0-test4_p0/drivers/scsi/Kconfig linux-2.6.0-test4_p1/dr=
ivers/scsi/Kconfig
--- linux-2.6.0-test4_p0/drivers/scsi/Kconfig	2003-08-25 08:19:14.000000000=
 -0400
+++ linux-2.6.0-test4_p1/drivers/scsi/Kconfig	2003-08-25 08:30:04.000000000=
 -0400
@@ -726,13 +726,13 @@
=20
 config SCSI_IPS
 	tristate "IBM ServeRAID support"
-	depends on X86 && PCI && SCSI
+	depends on PCI && SCSI
 	---help---
 	  This is support for the IBM ServeRAID hardware RAID controllers.
 	  See <http://www.developer.ibm.com/welcome/netfinity/serveraid.html>
 	  for more information.  If this driver does not work correctly
 	  without modification please contact the author by email at
-	  ipslinux@us.ibm.com.
+	  ipslinux@adaptec.com.
=20
 	  You can build this driver as a module ( =3D code which can be
 	  inserted in and removed from the running kernel whenever you want),
diff -urN linux-2.6.0-test4_p0/drivers/scsi/ips.c linux-2.6.0-test4_p1/driv=
ers/scsi/ips.c
--- linux-2.6.0-test4_p0/drivers/scsi/ips.c	2003-08-25 08:18:32.000000000 -=
0400
+++ linux-2.6.0-test4_p1/drivers/scsi/ips.c	2003-08-25 08:25:08.000000000 -=
0400
@@ -199,7 +199,7 @@
 #define IPS_VERSION_LOW         ".90-BETA"
=20
 #if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
-#error "This driver has only been tested on the x86/ia64/x86_64 platforms"
+#warning "This driver has only been tested on the x86/ia64/x86_64 platform=
s"
 #endif
=20
 #if LINUX_VERSION_CODE <=3D KERNEL_VERSION(2,5,0)
@@ -284,9 +284,9 @@
 /* This table describes all ServeRAID Adapters */
 static struct  pci_device_id  ips_pci_table[] =3D {
 	{ 0x1014, 0x002E, PCI_ANY_ID, PCI_ANY_ID, 0, 0 },
-        { 0x1014, 0x01BD, PCI_ANY_ID, PCI_ANY_ID, 0, 0 },
-        { 0x9005, 0x0250, PCI_ANY_ID, PCI_ANY_ID, 0, 0 },
-        { 0, }
+	{ 0x1014, 0x01BD, PCI_ANY_ID, PCI_ANY_ID, 0, 0 },
+	{ 0x9005, 0x0250, PCI_ANY_ID, PCI_ANY_ID, 0, 0 },
+	{ 0, }
 };
=20
 MODULE_DEVICE_TABLE( pci, ips_pci_table );
@@ -300,7 +300,7 @@
 	.name		=3D ips_hot_plug_name,
 	.id_table	=3D ips_pci_table,
 	.probe		=3D ips_insert_device,
-        .remove		=3D __devexit_p(ips_remove_device),
+	.remove		=3D __devexit_p(ips_remove_device),
 };
           =20
=20

--=-0TlZJXPbHAND8y9wHRSo--


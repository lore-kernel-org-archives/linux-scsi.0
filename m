From: Matt Domsch <Matt_Domsch@dell.com>
Subject: [PATCH] sym53c8xx_2 pci_device_id list terminators
Date: Wed, 10 Sep 2003 16:40:31 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0309101635060.27316-100000@humbolt.us.dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp9.us.dell.com ([143.166.148.136]:47540 "EHLO
	smtp9.us.dell.com") by vger.kernel.org with ESMTP id S265811AbTIJVkv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 17:40:51 -0400
List-Id: linux-scsi@vger.kernel.org
To: groudier@free.fr
Cc: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Gerard, I found that the sym53c8xx_2 driver has two pci_device_id lists, 
neither of which are 0-terminated.  This causes the pci detection routine 
to walk off the end of the list into space and causes an oops.  Often this 
isn't a problem, as the things after those lists are zeros, but we can't 
count on it, and it just bit me. :-)

Patch below against 2.6.0-test5 + recent BK.  Please apply ASAP.

- -- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com


- --- linux-2.5/drivers/scsi/sym53c8xx_2/sym_glue.c	Sat Sep  6 21:58:13 2003
+++ linux-2.5-devinit/drivers/scsi/sym53c8xx_2/sym_glue.c	Wed Sep 10 16:25:35 2003
@@ -2445,6 +2445,7 @@ static void pqs_remove()
 
 static struct pci_device_id pqs_id_table[] __devinitdata = {
 	{ 0x101a, 0x0009, },
+	{ 0, },
 };
 
 MODULE_DEVICE_TABLE(pci, pqs_id_table);
@@ -2526,6 +2527,7 @@ static struct pci_device_id sym2_id_tabl
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C875J,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
+	{ 0, },
 };
 
 MODULE_DEVICE_TABLE(pci, sym2_id_table);
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE/X5pUIavu95Lw/AkRAtNTAJ0T6lq1JCJP0pBDV6bTcYCkqb+D2ACdEjxl
vEfgFnKx5uOLyQdjzG/iFjw=
=Uoyn
-----END PGP SIGNATURE-----


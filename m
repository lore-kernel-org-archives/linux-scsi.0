From: Mark Bellon <mbellon@mvista.com>
Subject: [PATCH] 2.4.28 - AIC driver causes kernel corruption (as a module)
Date: Tue, 11 Jan 2005 12:24:03 -0700
Message-ID: <41E427D3.2020201@mvista.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030507090101040404020106"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([12.44.186.158]:59643 "EHLO
	av.mvista.com") by vger.kernel.org with ESMTP id S262872AbVAKTYu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 14:24:50 -0500
Received: from [10.50.1.98] (av [127.0.0.1])
	by av.mvista.com (8.9.3/8.9.3) with ESMTP id LAA17465
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jan 2005 11:24:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This is a multi-part message in MIME format.
--------------030507090101040404020106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Didn't see a patch for this and the problem is in the 2.4.28 sources.

The scsi_register_module call from within ah[cd]_linux_init causes the 
detect routine to be called. The detect routine calls  
ah[cd]_linux_pci_init which does a pci_register_driver call. If no 
hardware is found in the detect routine, ah[cd]_linux_init will exit 
without calling pci_unregister_driver leaving the kernel with pointers 
to a driver that never really loaded.

mark


--------------030507090101040404020106
Content-Type: text/plain;
 name="scsi-patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-patch"

Index: drivers/scsi/aic7xxx/aic79xx_osm.c
===================================================================
RCS file: /cvsdev/mvl-kernel/linux/drivers/scsi/aic7xxx/aic79xx_osm.c,v
retrieving revision 1.2.4.2.12.4
diff -a -u -r1.2.4.2.12.4 aic79xx_osm.c
--- drivers/scsi/aic7xxx/aic79xx_osm.c	12 Feb 2004 15:33:49 -0000	1.2.4.2.12.4
+++ drivers/scsi/aic7xxx/aic79xx_osm.c	11 Jan 2005 18:46:42 -0000
@@ -5079,6 +5079,8 @@
 	}
 }
 
+static void ahd_linux_exit(void);
+
 static int __init
 ahd_linux_init(void)
 {
@@ -5087,8 +5089,7 @@
 #else
 	scsi_register_module(MODULE_SCSI_HA, &aic79xx_driver_template);
 	if (aic79xx_driver_template.present == 0) {
-		scsi_unregister_module(MODULE_SCSI_HA,
-				       &aic79xx_driver_template);
+		ahd_linux_exit();
 		return (-ENODEV);
 	}
 
Index: drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
RCS file: /cvsdev/mvl-kernel/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c,v
retrieving revision 1.2.4.2.12.3
diff -a -u -r1.2.4.2.12.3 aic7xxx_osm.c
--- drivers/scsi/aic7xxx/aic7xxx_osm.c	12 Feb 2004 15:33:49 -0000	1.2.4.2.12.3
+++ drivers/scsi/aic7xxx/aic7xxx_osm.c	11 Jan 2005 18:46:43 -0000
@@ -5077,6 +5077,8 @@
 	}
 }
 
+static void ahc_linux_exit(void);
+
 static int __init
 ahc_linux_init(void)
 {
@@ -5085,8 +5087,7 @@
 #else
 	scsi_register_module(MODULE_SCSI_HA, &aic7xxx_driver_template);
 	if (aic7xxx_driver_template.present == 0) {
-		scsi_unregister_module(MODULE_SCSI_HA,
-				       &aic7xxx_driver_template);
+		ahc_linux_exit();
 		return (-ENODEV);
 	}
 

--------------030507090101040404020106--

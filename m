From: Mark Bellon <mbellon@mvista.com>
Subject: Re: [PATCH] 2.4.28 - AIC driver causes kernel corruption (as a	module)
Date: Tue, 11 Jan 2005 13:19:03 -0700
Message-ID: <41E434B7.6050602@mvista.com>
References: <41E427D3.2020201@mvista.com> <1105472884.10378.17.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030301060604030404070300"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([12.44.186.158]:37111 "EHLO
	av.mvista.com") by vger.kernel.org with ESMTP id S262480AbVAKUTu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jan 2005 15:19:50 -0500
Received: from [10.50.1.98] (av [127.0.0.1])
	by av.mvista.com (8.9.3/8.9.3) with ESMTP id MAA22841
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jan 2005 12:19:48 -0800
In-Reply-To: <1105472884.10378.17.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


This is a multi-part message in MIME format.
--------------030301060604030404070300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

James Bottomley wrote:

>On Tue, 2005-01-11 at 12:24 -0700, Mark Bellon wrote:
>  
>
>>-		scsi_unregister_module(MODULE_SCSI_HA,
>>-				       &aic79xx_driver_template);
>>+		ahd_linux_exit();
>>    
>>
>
>Well, this is pretty much identical to the 2.6 fix for the same problem
>except that you forgot to remove the __exit designation from ah
>[cd]_linux_exit().  This is required to prevent hanging pointer
>references.
>
>James
>
>
>  
>
Ah! Very true, very true. Updated patch attached.

mark


--------------030301060604030404070300
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
+++ drivers/scsi/aic7xxx/aic79xx_osm.c	11 Jan 2005 19:53:02 -0000
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
 
@@ -5096,7 +5097,7 @@
 #endif
 }
 
-static void __exit
+static void
 ahd_linux_exit(void)
 {
 	struct ahd_softc *ahd;
Index: drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
RCS file: /cvsdev/mvl-kernel/linux/drivers/scsi/aic7xxx/aic7xxx_osm.c,v
retrieving revision 1.2.4.2.12.3
diff -a -u -r1.2.4.2.12.3 aic7xxx_osm.c
--- drivers/scsi/aic7xxx/aic7xxx_osm.c	12 Feb 2004 15:33:49 -0000	1.2.4.2.12.3
+++ drivers/scsi/aic7xxx/aic7xxx_osm.c	11 Jan 2005 19:53:08 -0000
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
 
@@ -5094,7 +5095,7 @@
 #endif
 }
 
-static void __exit
+static void
 ahc_linux_exit(void)
 {
 	struct ahc_softc *ahc;

--------------030301060604030404070300--

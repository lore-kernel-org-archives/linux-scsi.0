From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: Patch:  allow devices to restrict start on add
Date: Fri, 23 May 2003 11:00:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200305231100.21287.Eddie.Williams@Steeleye.com>
References: <200305221140.59633.Eddie.Williams@Steeleye.com> <20030522110522.A7240@beaverton.ibm.com> <200305221610.07839.Eddie.Williams@Steeleye.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_LOHCZAP8HLIYDJD1YLYW"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:28165 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264072AbTEWOz7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2003 10:55:59 -0400
Received: from aslan (aslan.sc.steeleye.com [172.17.6.51])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id h4NF95I03705
	for <linux-scsi@vger.kernel.org>; Fri, 23 May 2003 11:09:05 -0400
In-Reply-To: <200305221610.07839.Eddie.Williams@Steeleye.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--------------Boundary-00=_LOHCZAP8HLIYDJD1YLYW
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

> On Thursday 22 May 2003 04:10 pm, Eddie Williams wrote:
> > On Thursday 22 May 2003 02:05 pm, Patrick Mansfield wrote:

> > Also you should patch against scsi-misc-2.5, or a recent bk, since hc=
h
> > moved all of the devinfo code into scsi_devinfo.c
>
> Yes.  I had taken a snapshot of the kernel a couple of weeks ago but it
> took a while for me to test it out but did not go back and remerge.  I =
will
> have that out tomorrow.

I updated to bk16.

Eddie
--------------Boundary-00=_LOHCZAP8HLIYDJD1YLYW
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="noadd.bk16.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="noadd.bk16.diff"

diff -Nru linux-2.5.69/drivers/scsi.orig/scsi.h linux-2.5.69/drivers/scsi/scsi.h
--- linux-2.5.69/drivers/scsi.orig/scsi.h	Fri May 23 10:38:43 2003
+++ linux-2.5.69/drivers/scsi/scsi.h	Fri May 23 11:01:50 2003
@@ -389,6 +389,7 @@
 	unsigned remap:1;	/* support remapping  */
 //	unsigned sync:1;	/* Sync transfer state, managed by host */
 //	unsigned wide:1;	/* WIDE transfer state, managed by host */
+	unsigned no_start_on_add:1;	/* do not issue start on add */
 
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 
diff -Nru linux-2.5.69/drivers/scsi.orig/scsi_devinfo.c linux-2.5.69/drivers/scsi/scsi_devinfo.c
--- linux-2.5.69/drivers/scsi.orig/scsi_devinfo.c	Fri May 23 10:29:20 2003
+++ linux-2.5.69/drivers/scsi/scsi_devinfo.c	Fri May 23 11:01:50 2003
@@ -131,7 +131,7 @@
 	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
 	{"CANON", "IPUBJD", NULL, BLIST_SPARSELUN},
 	{"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN},
-	{"DEC", "HSG80", NULL, BLIST_FORCELUN},
+	{"DEC", "HSG80", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 	{"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN},
 	{"COMPAQ", "CR3500", NULL, BLIST_FORCELUN},
 	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
@@ -159,7 +159,10 @@
 	{"HP", "NetRAID-4M", NULL, BLIST_FORCELUN},
 	{"ADAPTEC", "AACRAID", NULL, BLIST_FORCELUN},
 	{"ADAPTEC", "Adaptec 5400S", NULL, BLIST_FORCELUN},
-	{"COMPAQ", "MSA1000", NULL, BLIST_FORCELUN},
+	{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
+	{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
+	{"COMPAQ", "HSV110", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
+	{"HP", "HSV100", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 	{"HP", "C1557A", NULL, BLIST_FORCELUN},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
 	{"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
diff -Nru linux-2.5.69/drivers/scsi.orig/scsi_devinfo.h linux-2.5.69/drivers/scsi/scsi_devinfo.h
--- linux-2.5.69/drivers/scsi.orig/scsi_devinfo.h	Fri May 23 10:32:57 2003
+++ linux-2.5.69/drivers/scsi/scsi_devinfo.h	Fri May 23 11:01:50 2003
@@ -14,3 +14,4 @@
 #define BLIST_LARGELUN		0x200	/* LUNs past 7 on a SCSI-2 device */
 #define BLIST_INQUIRY_36	0x400	/* override additional length field */
 #define BLIST_INQUIRY_58	0x800	/* ... for broken inquiry responses */
+#define BLIST_NOSTARTONADD      0x1000  /* do not do automatic start on add */
diff -Nru linux-2.5.69/drivers/scsi.orig/scsi_scan.c linux-2.5.69/drivers/scsi/scsi_scan.c
--- linux-2.5.69/drivers/scsi.orig/scsi_scan.c	Fri May 23 10:37:35 2003
+++ linux-2.5.69/drivers/scsi/scsi_scan.c	Fri May 23 11:01:50 2003
@@ -641,6 +641,13 @@
 		sdev->borken = 0;
 
 	/*
+	 * Some devices may not want to have a start command automatically
+	 * issued when a device is added.
+	 */
+	if (*bflags & BLIST_NOSTARTONADD)
+		sdev->no_start_on_add = 1;
+
+	/*
 	 * If we need to allow I/O to only one of the luns attached to
 	 * this target id at a time set single_lun, and allocate or modify
 	 * sdev_target.
diff -Nru linux-2.5.69/drivers/scsi.orig/sd.c linux-2.5.69/drivers/scsi/sd.c
--- linux-2.5.69/drivers/scsi.orig/sd.c	Fri May 23 10:39:39 2003
+++ linux-2.5.69/drivers/scsi/sd.c	Fri May 23 11:01:50 2003
@@ -855,7 +855,12 @@
 			break;
 		}
 					
-					
+		/*
+		 * The device does not want the automatic start to be issued.
+		 */
+		if (sdkp->device->no_start_on_add) {
+			break;
+		}
 
 		/*
 		 * If manual intervention is required, or this is an

--------------Boundary-00=_LOHCZAP8HLIYDJD1YLYW--


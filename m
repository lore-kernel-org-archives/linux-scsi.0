From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Patch:  allow devices to restrict start on add
Date: Thu, 22 May 2003 11:40:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200305221140.59633.Eddie.Williams@Steeleye.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_BWOASVXHDLI8WM4GPW6D"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:24071 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261969AbTEVPgN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2003 11:36:13 -0400
Received: from aslan (aslan.sc.steeleye.com [172.17.6.51])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id h4MFnHI01745
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2003 11:49:17 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--------------Boundary-00=_BWOASVXHDLI8WM4GPW6D
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


When a SCSI disk is added and it returns a NOT READY the SD driver is=20
automatically sending a START_UNIT command to spin the device up.  While =
this=20
may be the desired behavior for many if not most devices not all devices=20
either want or need this.  The attached patch provides a mechanism via th=
e=20
device_list that allows a device to be defined to disable the automatic s=
tart=20
being issued on an add.

The patch also modifies the device_list for several devices that would pr=
efer=20
to not have the start command issued.=20

Eddie Williams
--------------Boundary-00=_BWOASVXHDLI8WM4GPW6D
Content-Type: text/x-diff;
  charset="us-ascii";
  name="nostart.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="nostart.diff"

diff -Nru linux-2.5.69/drivers/scsi.notready/scsi.h linux-2.5.69/drivers/scsi/scsi.h
--- linux-2.5.69/drivers/scsi.notready/scsi.h	Thu May  8 15:20:18 2003
+++ linux-2.5.69/drivers/scsi/scsi.h	Thu May  8 15:26:44 2003
@@ -612,6 +612,7 @@
 	unsigned remap:1;	/* support remapping  */
 //	unsigned sync:1;	/* Sync transfer state, managed by host */
 //	unsigned wide:1;	/* WIDE transfer state, managed by host */
+	unsigned no_start_on_add:1;	/* do not issue start on add */
 
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 
diff -Nru linux-2.5.69/drivers/scsi.notready/scsi_scan.c linux-2.5.69/drivers/scsi/scsi_scan.c
--- linux-2.5.69/drivers/scsi.notready/scsi_scan.c	Thu May  8 15:20:18 2003
+++ linux-2.5.69/drivers/scsi/scsi_scan.c	Thu May  8 15:26:44 2003
@@ -52,6 +52,7 @@
 #define BLIST_LARGELUN		0x200	/* LUNs past 7 on a SCSI-2 device */
 #define BLIST_INQUIRY_36	0x400	/* override additional length field */
 #define BLIST_INQUIRY_58	0x800	/* ... for broken inquiry responses */
+#define BLIST_NOSTARTONADD	0x1000	/* do not do automatic start on add */
 
 /*
  * scsi_static_device_list: deprecated list of devices that require
@@ -152,7 +153,7 @@
 	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
 	{"CANON", "IPUBJD", NULL, BLIST_SPARSELUN},
 	{"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN},
-	{"DEC", "HSG80", NULL, BLIST_FORCELUN},
+	{"DEC", "HSG80", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 	{"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN},
 	{"COMPAQ", "CR3500", NULL, BLIST_FORCELUN},
 	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
@@ -180,7 +181,10 @@
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
@@ -804,6 +808,13 @@
 	 */
 	if ((*bflags & BLIST_BORKEN) == 0)
 		sdev->borken = 0;
+
+	/*
+	 * Some devices may not want to have a start command automatically
+	 * issued when a device is added.
+	 */
+	if (*bflags & BLIST_NOSTARTONADD)
+		sdev->no_start_on_add = 1;
 
 	/*
 	 * If we need to allow I/O to only one of the luns attached to
diff -Nru linux-2.5.69/drivers/scsi.notready/sd.c linux-2.5.69/drivers/scsi/sd.c
--- linux-2.5.69/drivers/scsi.notready/sd.c	Thu May  8 15:20:18 2003
+++ linux-2.5.69/drivers/scsi/sd.c	Thu May  8 15:26:44 2003
@@ -852,7 +852,10 @@
 			break;
 		}
 					
-					
+		/* The device does not want the automatic start to be issued. */
+		if (sdkp->device->no_start_on_add) {
+			break;
+		}
 
 		/*
 		 * If manual intervention is required, or this is an

--------------Boundary-00=_BWOASVXHDLI8WM4GPW6D--


From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: [PATCH] 2.4.23
Date: Wed, 17 Dec 2003 08:13:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA201EE1D8@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [65.203.33.17] ([65.203.33.17]:14060 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S264468AbTLQQNl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2003 11:13:41 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

My name is Frank Borich, representing Xyratex International
(http://www.xyratex.com).  We design, and manufacture Data Storage
Subsystems.  During integration testing, we discovered that a patch to
scsi_scan.c is required (2.4.x kernels only), in order to set the
BLIST_SPARSELUN flag for our subsystems.  This flag adds support for
non-contiguous lun numbering.  We are unable to use the already
implemented "device_list" to set flags for our subsystems.  This is due
to the fact that we sell only to OEMs, and vendor name will change.
Rather than submit a separate patch for each branded subsystem we can
look elsewhere in the SCSI inquiry data, and set the flag accordingly.
The logic below, is executed once the end of the device_list is reached.
When the end of the table is reached, a memcmp is issued to look for a
particular string located at offset 96.  If the string is found, the
flag BLIST_SPARSELUN is returned.  Below is a patch for the SCSI driver
(scsi_scan.c). 


diff -urN linux-2.4.23/drivers/scsi/scsi_scan.c
linux-2.4.23.changed/drivers/scsi/scsi_scan.c
--- linux-2.4.23/drivers/scsi/scsi_scan.c	2003-12-03
08:56:28.000000000 -0600
+++ linux-2.4.23.changed/drivers/scsi/scsi_scan.c	2003-12-03
09:02:15.000000000 -0600
@@ -292,8 +292,16 @@
 	int i = 0;
 	unsigned char *pnt;
 	for (i = 0; 1; i++) {
-		if (device_list[i].vendor == NULL)
+		if (device_list[i].vendor == NULL){
+			/* Set flags for Xyratex subsystems here (all
OEMs). 
+			Cannot use device_list because can have
different vendor names for same device */
+			pnt = &response_data[96];
+			while (*pnt && *pnt == ' ')
+				pnt++;
+			if (memcmp("Xyratex F7",pnt,10) == 0)
+			return BLIST_SPARSELUN;
 			return 0;
+		}
 		pnt = &response_data[8];
 		while (*pnt && *pnt == ' ')
 			pnt++;
Frank Borich
------------------------------------------------------------------
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
 


Frank Borich
------------------------------------------------------------------
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
 


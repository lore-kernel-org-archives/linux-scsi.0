From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sg driver for lk 2.5.70
Date: Thu, 29 May 2003 23:15:53 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ED60809.8010301@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090205010509020000010701"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:57866 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262219AbTE2NIJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2003 09:08:09 -0400
Received: from torque.net (d-241-110.stlucia.uq.net.au [203.101.241.110])
	by bunyip.cc.uq.edu.au (8.12.9/8.12.9) with ESMTP id h4TDLNhp019258
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2003 23:21:23 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090205010509020000010701
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This is a bug fix for a flawed patch I put in lk 2.4.19
(sg version 3.1.24) and has been carried through into
the 2.5 series. Thanks to Andy Polyakov
<appro@fy.chalmers.se> for pointing this out (more than once).

The sg.h header didn't get updated last time I submitted
an sg patch so this patch also addresses that.

Doug Gilbert


--------------090205010509020000010701
Content-Type: text/plain;
 name="sg_2570.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_2570.diff"

--- linux/include/scsi/sg.h	2002-11-18 21:51:19.000000000 +1000
+++ linux/include/scsi/sg.h3529	2003-05-29 14:00:52.000000000 +1000
@@ -9,11 +9,18 @@
 Original driver (sg.h):
 *       Copyright (C) 1992 Lawrence Foard
 Version 2 and 3 extensions to driver:
-*       Copyright (C) 1998 - 2002 Douglas Gilbert
+*       Copyright (C) 1998 - 2003 Douglas Gilbert
 
-    Version: 3.5.27 (20020812)
+    Version: 3.5.29 (20030529)
     This version is for 2.5 series kernels.
 
+    Changes since 3.5.28 (20030308)
+	- fix bug introduced in version 3.1.24 (last segment of sgat list)
+    Changes since 3.5.27 (20020812)
+    	- remove procfs entries: hosts, host_hdr + host_strs (now in sysfs)
+	- add sysfs sg driver params: def_reserved_size, allow_dio, version
+	- new boot option: "sg_allow_dio" and module parameter: "allow_dio"
+        - multiple internal changes due to scsi subsystem rework	
     Changes since 3.5.26 (20020708)
 	- re-add direct IO using Kai Makisara's work
 	- re-tab to 8, start using C99-isms
@@ -237,7 +244,7 @@
    read/written by a single scsi command. The user can find the value of
    PAGE_SIZE by calling getpagesize() defined in unistd.h . */
 
-#define SG_DEFAULT_RETRIES 1
+#define SG_DEFAULT_RETRIES 0
 
 /* Defaults, commented if they differ from original sg driver */
 #define SG_DEF_FORCE_LOW_DMA 0  /* was 1 -> memory below 16MB on i386 */
--- linux/drivers/scsi/sg.c	2003-05-27 17:15:20.000000000 +1000
+++ linux/drivers/scsi/sg.c3529_2570	2003-05-29 14:48:01.000000000 +1000
@@ -18,8 +18,8 @@
  *
  */
 #include <linux/config.h>
-static char *sg_version_str = "3.5.28 [20030308]";
-static int sg_version_num = 30528;	/* 2 digits for each component */
+static char *sg_version_str = "3.5.29 [20030529]";
+static int sg_version_num = 30529;	/* 2 digits for each component */
 /*
  *  D. P. Gilbert (dgilbert@interlog.com, dougg@triode.net.au), notes:
  *      - scsi logging is available via SCSI_LOG_TIMEOUT macros. First
@@ -1994,11 +1994,8 @@
 			if (res)
 				return res;
 
-			for (; k < schp->k_use_sg; ++k, ++sclp) {
-				ksglen = (int) sclp->length;
-				p = sg_scatg2virt(sclp);
-				if (NULL == p)
-					break;
+			for (; p; ++sclp, ksglen = (int) sclp->length,
+				  p = sg_scatg2virt(sclp)) {
 				if (usglen <= 0)
 					break;
 				if (ksglen > usglen) {
@@ -2025,6 +2022,9 @@
 					up += ksglen;
 					usglen -= ksglen;
 				}
+				++k;
+				if (k >= schp->k_use_sg)
+					return 0;
 			}
 		}
 	}
@@ -2151,11 +2151,8 @@
 			if (res)
 				return res;
 
-			for (; k < schp->k_use_sg; ++k, ++sclp) {
-				ksglen = (int) sclp->length;
-				p = sg_scatg2virt(sclp);
-				if (NULL == p)
-					break;
+			for (; p; ++sclp, ksglen = (int) sclp->length,
+				  p = sg_scatg2virt(sclp)) {
 				if (usglen <= 0)
 					break;
 				if (ksglen > usglen) {
@@ -2182,6 +2179,9 @@
 					up += ksglen;
 					usglen -= ksglen;
 				}
+				++k;
+				if (k >= schp->k_use_sg)
+					return 0;
 			}
 		}
 	}

--------------090205010509020000010701--



From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sg driver >= lk 2.4.19
Date: Fri, 30 May 2003 10:29:40 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ED6A5F4.3050905@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000908010207020307000407"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:38409 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263183AbTE3ARb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2003 20:17:31 -0400
Received: from torque.net (d-242-36.stlucia.uq.net.au [203.101.242.36])
	by bunyip.cc.uq.edu.au (8.12.9/8.12.9) with ESMTP id h4U0Ujhp012330
	for <linux-scsi@vger.kernel.org>; Fri, 30 May 2003 10:30:47 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000908010207020307000407
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Here is the equivalent sg driver bug fix patch for
the lk 2.4 series from and including lk 2.4.19 .

Changelog: [Version: 3.1.25 (20030529)]
     Changes since 3.1.24 (20020505)
         - fix side effect introduced by last "off by one" fix
     Changes since 3.1.23 (20020318)
         - off by one fix for last scatter gather element

This patch does _not_ impact the main sg based apps such
as cdrecord, SANE and cdparanoia.

Doug Gilbert

--------------000908010207020307000407
Content-Type: text/plain;
 name="sg_2421rc6.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_2421rc6.diff"

--- linux/include/scsi/sg.h	2002-05-06 01:39:07.000000000 +1000
+++ linux/include/scsi/sg.h3125	2003-05-29 11:09:55.000000000 +1000
@@ -9,11 +9,13 @@
 Original driver (sg.h):
 *       Copyright (C) 1992 Lawrence Foard
 Version 2 and 3 extensions to driver:
-*       Copyright (C) 1998 - 2002 Douglas Gilbert
+*       Copyright (C) 1998 - 2003 Douglas Gilbert
 
-    Version: 3.1.24 (20020505)
+    Version: 3.1.25 (20030529)
     This version is for 2.4 series kernels.
 
+    Changes since 3.1.24 (20020505)
+	- fix side effect introduced by last "off by one" fix
     Changes since 3.1.23 (20020318)
 	- off by one fix for last scatter gather element
 	- zero buffer obtained for non-root users
--- linux/drivers/scsi/sg.c	2003-05-29 13:23:48.000000000 +1000
+++ linux/drivers/scsi/sg.c3125	2003-05-29 14:53:00.000000000 +1000
@@ -7,7 +7,7 @@
  * Original driver (sg.c):
  *        Copyright (C) 1992 Lawrence Foard
  * Version 2 and 3 extensions to driver:
- *        Copyright (C) 1998 - 2002 Douglas Gilbert
+ *        Copyright (C) 1998 - 2003 Douglas Gilbert
  *
  *  Modified  19-JAN-1998  Richard Gooch <rgooch@atnf.csiro.au>  Devfs support
  *
@@ -19,9 +19,9 @@
  */
 #include <linux/config.h>
 #ifdef CONFIG_PROC_FS
- static char * sg_version_str = "Version: 3.1.24 (20020505)";
+ static char * sg_version_str = "Version: 3.1.25 (20030529)";
 #endif
- static int sg_version_num = 30124; /* 2 digits for each component */
+ static int sg_version_num = 30125; /* 2 digits for each component */
 /*
  *  D. P. Gilbert (dgilbert@interlog.com, dougg@triode.net.au), notes:
  *      - scsi logging is available via SCSI_LOG_TIMEOUT macros. First
@@ -1884,11 +1884,7 @@
 	    res = sg_u_iovec(hp, iovec_count, j, 1, &usglen, &up);
 	    if (res) return res;
 
-	    for (; k < schp->k_use_sg; ++k, ++sclp) {
-		ksglen = (int)sclp->length;
-		p = sclp->address;
-		if (NULL == p)
-		    break;
+	    for ( ; p; ++sclp, ksglen = (int)sclp->length, p = sclp->address) {
 		ok = (SG_USER_MEM != mem_src_arr[k]);
 		if (usglen <= 0)
 		    break;
@@ -1911,6 +1907,9 @@
 		    up += ksglen;
 		    usglen -= ksglen;
 		}
+                ++k;
+                if (k >= schp->k_use_sg)
+                    return 0;
             }
         }
     }
@@ -2040,11 +2039,7 @@
 	    res = sg_u_iovec(hp, iovec_count, j, 0, &usglen, &up);
 	    if (res) return res;
 
-	    for (; k < schp->k_use_sg; ++k, ++sclp) {
-		ksglen = (int)sclp->length;
-		p = sclp->address;
-		if (NULL == p)
-		    break;
+	    for ( ; p; ++sclp, ksglen = (int)sclp->length, p = sclp->address) {
 		ok = (SG_USER_MEM != mem_src_arr[k]);
 		if (usglen <= 0)
 		    break;
@@ -2067,6 +2062,9 @@
 		    up += ksglen;
 		    usglen -= ksglen;
 		}
+                ++k;
+                if (k >= schp->k_use_sg)
+                    return 0;
 	    }
 	}
     }

--------------000908010207020307000407--


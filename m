From: Brian King <brking@us.ibm.com>
Subject: [PATCH] Recognize device type 0x0C
Date: Thu, 22 Jan 2004 17:35:20 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40105E38.4020501@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040607090504090502070607"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:10468 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266453AbUAVXfW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 18:35:22 -0500
Received: from northrelay04.pok.ibm.com (northrelay04.pok.ibm.com [9.56.224.206])
	by e2.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id i0MNZL4r399092
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2004 18:35:21 -0500
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i0MNZKIF123138
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2004 18:35:21 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040607090504090502070607
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


Attached is a simple patch to recognize device type 0x0C, since I will
be creating devices of this type in the ipr driver, I figured it might
be good if they showed up as RAID devices rather than Unknown.



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------040607090504090502070607
Content-Type: text/plain;
 name="patch-2.6.1-array_controller"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-2.6.1-array_controller"

diff -Naur linux-2.6.1/drivers/scsi/scsi.c linux-2.6.1-sacl/drivers/scsi/scsi.c
--- linux-2.6.1/drivers/scsi/scsi.c	Fri Jan  9 00:59:34 2004
+++ linux-2.6.1-sacl/drivers/scsi/scsi.c	Thu Jan 22 14:17:50 2004
@@ -104,7 +104,7 @@
 	"Communications   ",
 	"Unknown          ",
 	"Unknown          ",
-	"Unknown          ",
+	"RAID             ",
 	"Enclosure        ",
 };
 
diff -Naur linux-2.6.1/include/scsi/scsi.h linux-2.6.1-sacl/include/scsi/scsi.h
--- linux-2.6.1/include/scsi/scsi.h	Fri Jan  9 01:00:12 2004
+++ linux-2.6.1-sacl/include/scsi/scsi.h	Thu Jan 22 14:19:03 2004
@@ -193,6 +193,7 @@
 #define TYPE_MEDIUM_CHANGER 0x08
 #define TYPE_COMM           0x09    /* Communications device */
 #define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
+#define TYPE_RAID           0x0c
 #define TYPE_NO_LUN         0x7f
 
 /*

--------------040607090504090502070607--


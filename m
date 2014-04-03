From: shirishpargaonkar@gmail.com
Subject: [PATCH] sg3_utils: Strip spaces at the end of various fields in INQUIRY response
Date: Thu,  3 Apr 2014 12:07:15 -0500
Message-ID: <1396544835-5912-1-git-send-email-spargaonkar@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:62612 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaDCRHZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2014 13:07:25 -0400
Received: by mail-ob0-f178.google.com with SMTP id wp18so2280724obc.9
        for <linux-scsi@vger.kernel.org>; Thu, 03 Apr 2014 10:07:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, hare@suse.com, Shirish Pargaonkar <spargaonkar@suse.com>

From: Shirish Pargaonkar <spargaonkar@suse.com>

sginfo <device> prints out various fields such as Vendor and Product in
INQUIRY response with spaces (0x20) characters.
This can confuse scripts some users have.

A change to sysfs attributes such that it now includes spaces caused
this problem.

Strip out those trailing spaces (if any).


Signed-off-by: Shirish Pargaonkar <spargaonkar@suse.com>
---
Index: src/sginfo.c
===================================================================
--- src.orig/sginfo.c	2014-04-02 22:36:13.779692431 -0500
+++ src/sginfo.c	2014-04-02 22:51:36.028265615 -0500
@@ -155,6 +155,7 @@
 #define MAX_BUFFER_SIZE MAX_RESP10_SIZE
 
 #define INQUIRY_RESP_INITIAL_LEN 36
+#define MAX_INQFIELD_LEN 17
 
 #define MAX_HEADS 127
 #define HEAD_SORT_TOKEN 0x55
@@ -3139,11 +3140,23 @@
     return status;
 }
 
+static void
+inqfieldname(unsigned char *deststr, const unsigned char *srcbuf, int maxlen)
+{
+	int i;
+
+	memset(deststr, '\0', MAX_INQFIELD_LEN);
+	for (i = maxlen - 1; i >= 0 && isspace(srcbuf[i]); --i)
+		;
+	memcpy(deststr, srcbuf, i + 1);
+}
+
 static int
 do_inquiry(int * peri_type, int * resp_byte6, int inquiry_verbosity)
 {
     int status;
     unsigned char cmd[6];
+    unsigned char fieldname[MAX_INQFIELD_LEN];
     unsigned char *pagestart;
     struct scsi_cmnd_io sci;
 
@@ -3214,14 +3227,18 @@
     }
     if (x_interface)
         printf("\n");
-    printf("%s%.8s\n", (!x_interface ? "Vendor:                    " : ""),
-           pagestart + 8);
-
-    printf("%s%.16s\n", (!x_interface ? "Product:                   " : ""),
-           pagestart + 16);
 
-    printf("%s%.4s\n", (!x_interface ? "Revision level:            " : ""),
-           pagestart + 32);
+    inqfieldname(fieldname, pagestart + 8, 8);
+    printf("%s%s\n", (!x_interface ? "Vendor:                    " : ""),
+           fieldname);
+
+    inqfieldname(fieldname, pagestart + 16, 16);
+    printf("%s%s\n", (!x_interface ? "Product:                   " : ""),
+           fieldname);
+
+    inqfieldname(fieldname, pagestart + 32, 4);
+    printf("%s%s\n", (!x_interface ? "Revision level:            " : ""),
+           fieldname);
 
     printf("\n");
     return status;

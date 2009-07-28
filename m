From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] gdth: Buffer overflow
Date: Tue, 28 Jul 2009 12:24:13 +0200
Message-ID: <4A6ED1CD.60702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:62935 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZG1KV0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2009 06:21:26 -0400
Received: by ewy26 with SMTP id 26so3848055ewy.37
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2009 03:21:25 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

This allows i == MAXHA, which is out of range

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 185e6bc..0c64940 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3841,7 +3841,7 @@ int __init option_setup(char *str)
 
     TRACE2(("option_setup() str %s
", str ? str:"NULL")); 
 
-    while (cur && isdigit(*cur) && i <= MAXHA) {
+    while (cur && isdigit(*cur) && i < MAXHA) {
         ints[i++] = simple_strtoul(cur, NULL, 0);
         if ((cur = strchr(cur, ',')) != NULL) cur++;
     }

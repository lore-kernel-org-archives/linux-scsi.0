From: akpm@linux-foundation.org
Subject: [patch 08/11] drivers/scsi/gdth.c: fix buffer overflow
Date: Thu, 06 Aug 2009 16:09:26 -0700
Message-ID: <200908062309.n76N9Qcm011541@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756901AbZHFXSr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2009 19:18:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com

From: Roel Kluin <roel.kluin@gmail.com>

This allows i == MAXHA, which is out of range

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/gdth.c~drivers-scsi-gdthc-fix-buffer-overflow drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~drivers-scsi-gdthc-fix-buffer-overflow
+++ a/drivers/scsi/gdth.c
@@ -3838,7 +3838,7 @@ int __init option_setup(char *str)
 
     TRACE2(("option_setup() str %s\n", str ? str:"NULL")); 
 
-    while (cur && isdigit(*cur) && i <= MAXHA) {
+    while (cur && isdigit(*cur) && i < MAXHA) {
         ints[i++] = simple_strtoul(cur, NULL, 0);
         if ((cur = strchr(cur, ',')) != NULL) cur++;
     }
_

From: akpm@linux-foundation.org
Subject: [patch 14/18] drivers/scsi/a3000.c: make 2 functions static
Date: Wed, 20 Aug 2008 16:55:33 -0700
Message-ID: <200808202355.m7KNtYuZ006222@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757336AbYHUADg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2008 20:03:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@kernel.org

From: Adrian Bunk <bunk@kernel.org>

a3000_{detect,release}() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/a3000.c |    6 ++++--
 drivers/scsi/a3000.h |    3 ---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/a3000.c~drivers-scsi-a3000c-make-2-functions-static drivers/scsi/a3000.c
--- a/drivers/scsi/a3000.c~drivers-scsi-a3000c-make-2-functions-static
+++ a/drivers/scsi/a3000.c
@@ -25,6 +25,8 @@
 
 static struct Scsi_Host *a3000_host = NULL;
 
+static int a3000_release(struct Scsi_Host *instance);
+
 static irqreturn_t a3000_intr (int irq, void *dummy)
 {
 	unsigned long flags;
@@ -157,7 +159,7 @@ static void dma_stop(struct Scsi_Host *i
     }
 }
 
-int __init a3000_detect(struct scsi_host_template *tpnt)
+static int __init a3000_detect(struct scsi_host_template *tpnt)
 {
     wd33c93_regs regs;
 
@@ -232,7 +234,7 @@ static struct scsi_host_template driver_
 
 #include "scsi_module.c"
 
-int a3000_release(struct Scsi_Host *instance)
+static int a3000_release(struct Scsi_Host *instance)
 {
     wd33c93_release();
     DMA(instance)->CNTR = 0;
diff -puN drivers/scsi/a3000.h~drivers-scsi-a3000c-make-2-functions-static drivers/scsi/a3000.h
--- a/drivers/scsi/a3000.h~drivers-scsi-a3000c-make-2-functions-static
+++ a/drivers/scsi/a3000.h
@@ -11,9 +11,6 @@
 
 #include <linux/types.h>
 
-int a3000_detect(struct scsi_host_template *);
-int a3000_release(struct Scsi_Host *);
-
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
 #endif
_

From: akpm@linux-foundation.org
Subject: [patch 13/17] drivers/scsi/a2091.c: make 2 functions static
Date: Mon, 22 Sep 2008 14:56:50 -0700
Message-ID: <200809222156.m8MLuoDe032300@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286AbYIVWGr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2008 18:06:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@kernel.org

From: Adrian Bunk <bunk@kernel.org>

a2091_{detect,release}() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/a2091.c |    6 ++++--
 drivers/scsi/a2091.h |    3 ---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/a2091.c~drivers-scsi-a2091c-make-2-functions-static drivers/scsi/a2091.c
--- a/drivers/scsi/a2091.c~drivers-scsi-a2091c-make-2-functions-static
+++ a/drivers/scsi/a2091.c
@@ -23,6 +23,8 @@
 #define DMA(ptr) ((a2091_scsiregs *)((ptr)->base))
 #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
 
+static int a2091_release(struct Scsi_Host *instance);
+
 static irqreturn_t a2091_intr (int irq, void *_instance)
 {
     unsigned long flags;
@@ -144,7 +146,7 @@ static void dma_stop(struct Scsi_Host *i
     }
 }
 
-int __init a2091_detect(struct scsi_host_template *tpnt)
+static int __init a2091_detect(struct scsi_host_template *tpnt)
 {
     static unsigned char called = 0;
     struct Scsi_Host *instance;
@@ -227,7 +229,7 @@ static struct scsi_host_template driver_
 
 #include "scsi_module.c"
 
-int a2091_release(struct Scsi_Host *instance)
+static int a2091_release(struct Scsi_Host *instance)
 {
 #ifdef MODULE
 	DMA(instance)->CNTR = 0;
diff -puN drivers/scsi/a2091.h~drivers-scsi-a2091c-make-2-functions-static drivers/scsi/a2091.h
--- a/drivers/scsi/a2091.h~drivers-scsi-a2091c-make-2-functions-static
+++ a/drivers/scsi/a2091.h
@@ -11,9 +11,6 @@
 
 #include <linux/types.h>
 
-int a2091_detect(struct scsi_host_template *);
-int a2091_release(struct Scsi_Host *);
-
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
 #endif
_

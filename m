From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] drivers/scsi/a2091.c: make 2 functions static
Date: Thu, 7 Aug 2008 00:11:15 +0300
Message-ID: <20080806211115.GQ1702@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp5.pp.htv.fi ([213.243.153.39]:50276 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760654AbYHFVMo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Aug 2008 17:12:44 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

a2091_{detect,release}() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 10 Jun 2008

 drivers/scsi/a2091.c |    6 ++++--
 drivers/scsi/a2091.h |    3 ---
 2 files changed, 4 insertions(+), 5 deletions(-)

22558d3b8c3dcf29bb54d76256a64db89017dedc diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index 07d572f..f36029c 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -23,6 +23,8 @@
 #define DMA(ptr) ((a2091_scsiregs *)((ptr)->base))
 #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
 
+static int a2091_release(struct Scsi_Host *instance);
+
 static irqreturn_t a2091_intr (int irq, void *_instance)
 {
     unsigned long flags;
@@ -144,7 +146,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
     }
 }
 
-int __init a2091_detect(struct scsi_host_template *tpnt)
+static int __init a2091_detect(struct scsi_host_template *tpnt)
 {
     static unsigned char called = 0;
     struct Scsi_Host *instance;
@@ -227,7 +229,7 @@ static struct scsi_host_template driver_template = {
 
 #include "scsi_module.c"
 
-int a2091_release(struct Scsi_Host *instance)
+static int a2091_release(struct Scsi_Host *instance)
 {
 #ifdef MODULE
 	DMA(instance)->CNTR = 0;
diff --git a/drivers/scsi/a2091.h b/drivers/scsi/a2091.h
index fe809bc..252528f 100644
--- a/drivers/scsi/a2091.h
+++ b/drivers/scsi/a2091.h
@@ -11,9 +11,6 @@
 
 #include <linux/types.h>
 
-int a2091_detect(struct scsi_host_template *);
-int a2091_release(struct Scsi_Host *);
-
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
 #endif


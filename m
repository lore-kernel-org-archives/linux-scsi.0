From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] drivers/scsi/a3000.c: make 2 functions static
Date: Thu, 7 Aug 2008 00:11:18 +0300
Message-ID: <20080806211118.GR1702@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59640 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758326AbYHFVMq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Aug 2008 17:12:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

a3000_{detect,release}() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 10 Jun 2008

 drivers/scsi/a3000.c |    6 ++++--
 drivers/scsi/a3000.h |    3 ---
 2 files changed, 4 insertions(+), 5 deletions(-)

85a02587af2fff4f03fcecf3bb0f61fbe1cfadc3 diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 8b449d8..6970ce8 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -25,6 +25,8 @@
 
 static struct Scsi_Host *a3000_host = NULL;
 
+static int a3000_release(struct Scsi_Host *instance);
+
 static irqreturn_t a3000_intr (int irq, void *dummy)
 {
 	unsigned long flags;
@@ -157,7 +159,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
     }
 }
 
-int __init a3000_detect(struct scsi_host_template *tpnt)
+static int __init a3000_detect(struct scsi_host_template *tpnt)
 {
     wd33c93_regs regs;
 
@@ -232,7 +234,7 @@ static struct scsi_host_template driver_template = {
 
 #include "scsi_module.c"
 
-int a3000_release(struct Scsi_Host *instance)
+static int a3000_release(struct Scsi_Host *instance)
 {
     wd33c93_release();
     DMA(instance)->CNTR = 0;
diff --git a/drivers/scsi/a3000.h b/drivers/scsi/a3000.h
index 44a4ec7..c7afe16 100644
--- a/drivers/scsi/a3000.h
+++ b/drivers/scsi/a3000.h
@@ -11,9 +11,6 @@
 
 #include <linux/types.h>
 
-int a3000_detect(struct scsi_host_template *);
-int a3000_release(struct Scsi_Host *);
-
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
 #endif


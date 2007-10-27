From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 2/2] SCSI/NCR5380: minor irq handler cleanups
Date: Fri, 26 Oct 2007 20:16:40 -0400 (EDT)
Message-ID: <a683fcd0b1196c41a80f57c896cc443b99d78497.1193444039.git.jeff@garzik.org>
References: <0f3b5fb60a45528af12178ba6c857af33ae048b1.1193444039.git.jeff@garzik.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:40736 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbXJ0AQk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 20:16:40 -0400
In-Reply-To: <0f3b5fb60a45528af12178ba6c857af33ae048b1.1193444039.git.jeff@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org

* remove unnecessary cast

* remove unnecessary use of 'irq' function arg

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/scsi/NCR5380.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 2597209..31787d8 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1157,16 +1157,17 @@ static void NCR5380_main(struct work_struct *work)
  *	Locks: takes the needed instance locks
  */
 
-static irqreturn_t NCR5380_intr(int irq, void *dev_id) 
+static irqreturn_t NCR5380_intr(int dummy, void *dev_id) 
 {
 	NCR5380_local_declare();
-	struct Scsi_Host *instance = (struct Scsi_Host *)dev_id;
+	struct Scsi_Host *instance = dev_id;
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 	int done;
 	unsigned char basr;
 	unsigned long flags;
 
-	dprintk(NDEBUG_INTR, ("scsi : NCR5380 irq %d triggered\n", irq));
+	dprintk(NDEBUG_INTR, ("scsi : NCR5380 irq %d triggered\n",
+		instance->irq));
 
 	do {
 		done = 1;
-- 
1.5.2.4


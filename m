From: akpm@linux-foundation.org
Subject: [patch 12/30] SCSI/NCR5380: minor irq handler cleanups
Date: Thu, 13 Dec 2007 16:14:14 -0800
Message-ID: <200712140014.lBE0EF3V026203@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933453AbXLNAP2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 19:15:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jeff@garzik.org, jgarzik@redhat.com

From: Jeff Garzik <jeff@garzik.org>

* remove unnecessary cast

* remove unnecessary use of 'irq' function arg

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/NCR5380.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/NCR5380.c~scsi-ncr5380-minor-irq-handler-cleanups drivers/scsi/NCR5380.c
--- a/drivers/scsi/NCR5380.c~scsi-ncr5380-minor-irq-handler-cleanups
+++ a/drivers/scsi/NCR5380.c
@@ -1157,16 +1157,17 @@ static void NCR5380_main(struct work_str
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
_

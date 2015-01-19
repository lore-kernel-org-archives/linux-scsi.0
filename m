From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 07/13] aha1542: Reorder functions to remove forward declarations
Date: Mon, 19 Jan 2015 23:37:51 +0100
Message-ID: <1421707077-25291-8-git-send-email-linux@rainbow-software.org>
References: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:44254 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbbASWiL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2015 17:38:11 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YDKxV-0006A4-Dw
	for linux-scsi@vger.kernel.org; Mon, 19 Jan 2015 23:38:09 +0100
In-Reply-To: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   51 +++++++++++++++++++++++-------------------------
 drivers/scsi/aha1542.h |   12 ------------
 2 files changed, 24 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 8851719..af1e8fa 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -124,10 +124,6 @@ static DEFINE_SPINLOCK(aha1542_lock);
 
 #define WAITnexttimeout 3000000
 
-static void setup_mailboxes(int base_io, struct Scsi_Host *shpnt);
-static int aha1542_restart(struct Scsi_Host *shost);
-static void aha1542_intr_handle(struct Scsi_Host *shost);
-
 static inline void aha1542_intr_reset(u16 base)
 {
 	outb(IRST, CONTROL(base));
@@ -368,16 +364,20 @@ fail:
 	return 0;		/* 0 = not ok */
 }
 
-/* A quick wrapper for do_aha1542_intr_handle to grab the spin lock */
-static irqreturn_t do_aha1542_intr_handle(int dummy, void *dev_id)
+static int aha1542_restart(struct Scsi_Host *shost)
 {
-	unsigned long flags;
-	struct Scsi_Host *shost = dev_id;
+	struct aha1542_hostdata *aha1542 = shost_priv(shost);
+	int i;
+	int count = 0;
 
-	spin_lock_irqsave(shost->host_lock, flags);
-	aha1542_intr_handle(shost);
-	spin_unlock_irqrestore(shost->host_lock, flags);
-	return IRQ_HANDLED;
+	for (i = 0; i < AHA1542_MAILBOXES; i++)
+		if (aha1542->SCint[i] &&
+		    !(aha1542->SCint[i]->device->soft_reset)) {
+			count++;
+		}
+	printk(KERN_DEBUG "Potential to restart %d stalled commands...\n", count);
+
+	return 0;
 }
 
 /* A "high" level interrupt handler */
@@ -539,6 +539,18 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 	};
 }
 
+/* A quick wrapper for do_aha1542_intr_handle to grab the spin lock */
+static irqreturn_t do_aha1542_intr_handle(int dummy, void *dev_id)
+{
+	unsigned long flags;
+	struct Scsi_Host *shost = dev_id;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	aha1542_intr_handle(shost);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	return IRQ_HANDLED;
+}
+
 static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 {
 	struct aha1542_hostdata *aha1542 = shost_priv(SCpnt->device->host);
@@ -1078,21 +1090,6 @@ static int aha1542_release(struct Scsi_Host *shost)
 	return 0;
 }
 
-static int aha1542_restart(struct Scsi_Host *shost)
-{
-	struct aha1542_hostdata *aha1542 = shost_priv(shost);
-	int i;
-	int count = 0;
-
-	for (i = 0; i < AHA1542_MAILBOXES; i++)
-		if (aha1542->SCint[i] &&
-		    !(aha1542->SCint[i]->device->soft_reset)) {
-			count++;
-		}
-	printk(KERN_DEBUG "Potential to restart %d stalled commands...\n", count);
-
-	return 0;
-}
 
 /*
  * This is a device reset.  This is handled by sending a special command
diff --git a/drivers/scsi/aha1542.h b/drivers/scsi/aha1542.h
index 6b418bb..f0b862b 100644
--- a/drivers/scsi/aha1542.h
+++ b/drivers/scsi/aha1542.h
@@ -125,18 +125,6 @@ struct ccb {		/* Command Control Block 5.3 */
 					/* REQUEST SENSE */
 };
 
-static struct Scsi_Host *aha1542_hw_init(struct scsi_host_template *tpnt, struct device *pdev, int indx);
-static int aha1542_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
-static int aha1542_bus_reset(Scsi_Cmnd * SCpnt);
-static int aha1542_dev_reset(Scsi_Cmnd * SCpnt);
-static int aha1542_host_reset(Scsi_Cmnd * SCpnt);
-#if 0
-static int aha1542_old_abort(Scsi_Cmnd * SCpnt);
-static int aha1542_old_reset(Scsi_Cmnd *, unsigned int);
-#endif
-static int aha1542_biosparam(struct scsi_device *, struct block_device *,
-		sector_t, int *);
-
 #define AHA1542_MAILBOXES 8
 
 #endif
-- 
Ondrej Zary


From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 03/13] aha1542: Remove SCSI_BUF_PA, SCSI_SG_PA, AHA1542_SCATTER and AHA1542_CMDLUN
Date: Mon, 19 Jan 2015 23:37:47 +0100
Message-ID: <1421707077-25291-4-git-send-email-linux@rainbow-software.org>
References: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:44248 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbbASWiL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2015 17:38:11 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YDKxU-0006A4-O2
	for linux-scsi@vger.kernel.org; Mon, 19 Jan 2015 23:38:08 +0100
In-Reply-To: <1421707077-25291-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove SCSI_BUF_PA, SCSI_SG_PA, AHA1542_SCATTER and AHA1542_CMDLUN macros

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   23 ++++++++++-------------
 drivers/scsi/aha1542.h |    2 --
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 506e33e..197480d 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -46,10 +46,6 @@
 #include "scsi.h"
 #include <scsi/scsi_host.h>
 #include "aha1542.h"
-
-#define SCSI_BUF_PA(address)	isa_virt_to_bus(address)
-#define SCSI_SG_PA(sgent)	(isa_page_to_bus(sg_page((sgent))) + (sgent)->offset)
-
 #include <linux/stat.h>
 
 #ifdef DEBUG
@@ -463,7 +459,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
 			return;
 		};
 
-		mbo = (scsi2int(mb[mbi].ccbptr) - (SCSI_BUF_PA(&ccb[0]))) / sizeof(struct ccb);
+		mbo = (scsi2int(mb[mbi].ccbptr) - (isa_virt_to_bus(&ccb[0]))) / sizeof(struct ccb);
 		mbistatus = mb[mbi].status;
 		mb[mbi].status = 0;
 		HOSTDATA(shost)->aha1542_last_mbi_used = mbi;
@@ -622,7 +618,7 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 	printk(KERN_DEBUG "Sending command (%d %x)...", mbo, done);
 #endif
 
-	any2scsi(mb[mbo].ccbptr, SCSI_BUF_PA(&ccb[mbo]));	/* This gets trashed for some reason */
+	any2scsi(mb[mbo].ccbptr, isa_virt_to_bus(&ccb[mbo]));	/* This gets trashed for some reason */
 
 	memset(&ccb[mbo], 0, sizeof(struct ccb));
 
@@ -653,11 +649,12 @@ static int aha1542_queuecommand_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *
 			return SCSI_MLQUEUE_HOST_BUSY;
 		}
 		scsi_for_each_sg(SCpnt, sg, sg_count, i) {
-			any2scsi(cptr[i].dataptr, SCSI_SG_PA(sg));
+			any2scsi(cptr[i].dataptr, isa_page_to_bus(sg_page(sg))
+								+ sg->offset);
 			any2scsi(cptr[i].datalen, sg->length);
 		};
 		any2scsi(ccb[mbo].datalen, sg_count * sizeof(struct chain));
-		any2scsi(ccb[mbo].dataptr, SCSI_BUF_PA(cptr));
+		any2scsi(ccb[mbo].dataptr, isa_virt_to_bus(cptr));
 #ifdef DEBUG
 		printk("cptr %x: ", cptr);
 		ptr = (unsigned char *) cptr;
@@ -713,10 +710,10 @@ static void setup_mailboxes(int bse, struct Scsi_Host *shpnt)
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		mb[i].status = mb[AHA1542_MAILBOXES + i].status = 0;
-		any2scsi(mb[i].ccbptr, SCSI_BUF_PA(&ccb[i]));
+		any2scsi(mb[i].ccbptr, isa_virt_to_bus(&ccb[i]));
 	};
 	aha1542_intr_reset(bse);	/* reset interrupts, so they don't block */
-	any2scsi((cmd + 2), SCSI_BUF_PA(mb));
+	any2scsi((cmd + 2), isa_virt_to_bus(mb));
 	aha1542_out(bse, cmd, 5);
 	WAIT(INTRFLAGS(bse), INTRMASK, HACC, 0);
 	while (0) {
@@ -1139,7 +1136,7 @@ static int aha1542_dev_reset(Scsi_Cmnd * SCpnt)
 	HOSTDATA(SCpnt->device->host)->aha1542_last_mbo_used = mbo;
 	spin_unlock_irqrestore(&aha1542_lock, flags);
 
-	any2scsi(mb[mbo].ccbptr, SCSI_BUF_PA(&ccb[mbo]));	/* This gets trashed for some reason */
+	any2scsi(mb[mbo].ccbptr, isa_virt_to_bus(&ccb[mbo]));	/* This gets trashed for some reason */
 
 	memset(&ccb[mbo], 0, sizeof(struct ccb));
 
@@ -1328,8 +1325,8 @@ static struct scsi_host_template driver_template = {
 	.bios_param		= aha1542_biosparam,
 	.can_queue		= AHA1542_MAILBOXES, 
 	.this_id		= 7,
-	.sg_tablesize		= AHA1542_SCATTER,
-	.cmd_per_lun		= AHA1542_CMDLUN,
+	.sg_tablesize		= 16,
+	.cmd_per_lun		= 1,
 	.unchecked_isa_dma	= 1, 
 	.use_clustering		= ENABLE_CLUSTERING,
 };
diff --git a/drivers/scsi/aha1542.h b/drivers/scsi/aha1542.h
index af91125..812a406 100644
--- a/drivers/scsi/aha1542.h
+++ b/drivers/scsi/aha1542.h
@@ -138,7 +138,5 @@ static int aha1542_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int *);
 
 #define AHA1542_MAILBOXES 8
-#define AHA1542_SCATTER 16
-#define AHA1542_CMDLUN 1
 
 #endif
-- 
Ondrej Zary


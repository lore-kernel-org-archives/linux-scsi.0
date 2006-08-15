From: akpm@osdl.org
Subject: [patch 14/24] Fix panic when reinserting Adaptec PCMCIA SCSI card
Date: Mon, 14 Aug 2006 23:09:27 -0700
Message-ID: <200608150609.k7F69RV9013241@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:14742 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965106AbWHOGK2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Aug 2006 02:10:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, alex14641@yahoo.com

From: Alex Davis <alex14641@yahoo.com>

If the card is re-inserted 2 or more times, we access elements past the end
of the aha152x_host array.

Also correct spelling errors.

[akpm@osdl.org: cleanups]
Signed-off-by: Alex Davis <alex14641@yahoo.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aha152x.c |   37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/aha152x.c~fix-panic-when-reinserting-adaptec-pcmcia-scsi-card drivers/scsi/aha152x.c
--- a/drivers/scsi/aha152x.c~fix-panic-when-reinserting-adaptec-pcmcia-scsi-card
+++ a/drivers/scsi/aha152x.c
@@ -771,7 +771,8 @@ static irqreturn_t swintr(int irqno, voi
 	struct Scsi_Host *shpnt = lookup_irq(irqno);
 
 	if (!shpnt) {
-        	printk(KERN_ERR "aha152x: catched software interrupt %d for unknown controller.\n", irqno);
+		printk(KERN_ERR "aha152x: caught software interrupt %d for "
+			"unknown controller.\n", irqno);
 		return IRQ_NONE;
 	}
 
@@ -784,6 +785,7 @@ static irqreturn_t swintr(int irqno, voi
 struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
 {
 	struct Scsi_Host *shpnt;
+	int i;
 
 	shpnt = scsi_host_alloc(&aha152x_driver_template, sizeof(struct aha152x_hostdata));
 	if (!shpnt) {
@@ -792,6 +794,21 @@ struct Scsi_Host *aha152x_probe_one(stru
 	}
 
 	/* need to have host registered before triggering any interrupt */
+
+	/* find an empty slot. */
+	for (i = 0; i < ARRAY_SIZE(aha152x_host); i++) {
+		if (aha152x_host[i] == NULL)
+			break;
+	}
+
+	/* no empty slots? */
+	if (i >= ARRAY_SIZE(aha152x_host)) {
+		printk(KERN_ERR "aha152x: too many hosts: %d\n", i + 1);
+		return NULL;
+	}
+
+	registered_count = i;
+
 	aha152x_host[registered_count] = shpnt;
 
 	memset(HOSTDATA(shpnt), 0, sizeof *HOSTDATA(shpnt));
@@ -920,6 +937,8 @@ out_host_put:
 
 void aha152x_release(struct Scsi_Host *shpnt)
 {
+	int i;
+
 	if(!shpnt)
 		return;
 
@@ -938,6 +957,12 @@ void aha152x_release(struct Scsi_Host *s
 
 	scsi_remove_host(shpnt);
 	scsi_host_put(shpnt);
+	for (i = 0; i < ARRAY_SIZE(aha152x_host); i++) {
+		if (aha152x_host[i] == shpnt) {
+			aha152x_host[i] = NULL;
+			break;
+		}
+	}
 }
 
 
@@ -1476,7 +1501,8 @@ static irqreturn_t intr(int irqno, void 
 	unsigned char rev, dmacntrl0;
 
 	if (!shpnt) {
-		printk(KERN_ERR "aha152x: catched interrupt %d for unknown controller.\n", irqno);
+		printk(KERN_ERR "aha152x: caught interrupt %d for unknown "
+				"controller.\n", irqno);
 		return IRQ_NONE;
 	}
 
@@ -2997,6 +3023,9 @@ static void show_queues(struct Scsi_Host
 	Scsi_Cmnd *ptr;
 	unsigned long flags;
 
+	if (!shpnt)
+		return;
+
 	DO_LOCK(flags);
 	printk(KERN_DEBUG "\nqueue status:\nissue_SC:\n");
 	for (ptr = ISSUE_SC; ptr; ptr = SCNEXT(ptr))
@@ -3960,10 +3989,8 @@ static void __exit aha152x_exit(void)
 {
 	int i;
 
-	for(i=0; i<ARRAY_SIZE(setup); i++) {
+	for(i = 0; i < ARRAY_SIZE(setup); i++)
 		aha152x_release(aha152x_host[i]);
-		aha152x_host[i]=NULL;
-	}
 }
 
 module_init(aha152x_init);
_

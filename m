From: Alex Davis <alex14641@yahoo.com>
Subject: [REPOST: PATCH] Fix panic when reinserting Adaptec PCMCIA SCSI card.
Date: Sat, 8 Jul 2006 23:49:32 -0700 (PDT)
Message-ID: <20060709064932.77080.qmail@web50204.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web50204.mail.yahoo.com ([206.190.38.45]:36264 "HELO
	web50204.mail.yahoo.com") by vger.kernel.org with SMTP
	id S1161100AbWGIGtd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Jul 2006 02:49:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This is a resubmit of a patch that was submitted 2 weeks ago. To date, no feedback
has been received.

Please cc: me as I am not subscribed.

===========================================================================
If the card is re-inserted 2 or more times, we access elements
past the end of the aha152x_host array.

Also correct spelling errors.

Signed-off-by Alex Davis <alex14641 at yahoo dot com>
=========================================================================
diff -u linux-2.6.17.1-orig/drivers/scsi/aha152x.c linux-2.6.17.1/drivers/scsi/aha152x.c
--- linux-2.6.17.1-orig/drivers/scsi/aha152x.c	2006-06-17 21:49:35.000000000 -0400
+++ linux-2.6.17.1/drivers/scsi/aha152x.c	2006-06-25 20:06:05.000000000 -0400
@@ -766,7 +766,7 @@
 	struct Scsi_Host *shpnt = lookup_irq(irqno);
 
 	if (!shpnt) {
-        	printk(KERN_ERR "aha152x: catched software interrupt %d for unknown controller.\n",
irqno);
+        	printk(KERN_ERR "aha152x: caught software interrupt %d for unknown controller.\n",
irqno);
 		return IRQ_NONE;
 	}
 
@@ -779,6 +779,7 @@
 struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
 {
 	struct Scsi_Host *shpnt;
+	int i;
 
 	shpnt = scsi_host_alloc(&aha152x_driver_template, sizeof(struct aha152x_hostdata));
 	if (!shpnt) {
@@ -787,6 +788,22 @@
 	}
 
 	/* need to have host registered before triggering any interrupt */
+
+	/* find an empty slot. */
+	for ( i = 0; i < ARRAY_SIZE(aha152x_host); ++i ) {
+		if ( aha152x_host[i] == NULL ) {
+			break;
+		}
+	}
+
+	/* no empty slots? */
+	if ( i >= ARRAY_SIZE(aha152x_host) ) {
+		printk(KERN_ERR "aha152x: too many hosts: %d\n", i + 1);
+		return NULL;
+	}
+
+	registered_count = i;
+
 	aha152x_host[registered_count] = shpnt;
 
 	memset(HOSTDATA(shpnt), 0, sizeof *HOSTDATA(shpnt));
@@ -915,6 +932,8 @@
 
 void aha152x_release(struct Scsi_Host *shpnt)
 {
+	int i;
+
 	if(!shpnt)
 		return;
 
@@ -933,6 +952,12 @@
 
 	scsi_remove_host(shpnt);
 	scsi_host_put(shpnt);
+	for ( i = 0; i < ARRAY_SIZE(aha152x_host); ++i ) {
+		if ( aha152x_host[i] == shpnt ) {
+			aha152x_host[i] = NULL;
+			break;
+		}
+	}
 }
 
 
@@ -1458,7 +1483,7 @@
 	unsigned char rev, dmacntrl0;
 
 	if (!shpnt) {
-		printk(KERN_ERR "aha152x: catched interrupt %d for unknown controller.\n", irqno);
+		printk(KERN_ERR "aha152x: caught interrupt %d for unknown controller.\n", irqno);
 		return IRQ_NONE;
 	}
 
@@ -2976,6 +3001,9 @@
 	Scsi_Cmnd *ptr;
 	unsigned long flags;
 
+	if(!shpnt)
+		return;
+
 	DO_LOCK(flags);
 	printk(KERN_DEBUG "\nqueue status:\nissue_SC:\n");
 	for (ptr = ISSUE_SC; ptr; ptr = SCNEXT(ptr))
@@ -3941,7 +3969,6 @@
 
 	for(i=0; i<ARRAY_SIZE(setup); i++) {
 		aha152x_release(aha152x_host[i]);
-		aha152x_host[i]=NULL;
 	}
 }


I code, therefore I am

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 

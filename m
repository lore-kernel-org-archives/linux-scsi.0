From: =?iso-8859-1?B?SvxyZ2VuIEUu?= Fischer <fischer@linux-buechse.de>
Subject: Re: [Bugme-new] [Bug 6092] New: drivers/scsi/pcmcia/aha152x_stub.c: aha152x_resume(): variable used before set
Date: Sat, 18 Feb 2006 23:10:39 +0100
Message-ID: <20060218221039.GA3912@linux-buechse.de>
References: <200602180209.k1I29meW030162@fire-2.osdl.org> <20060217211049.4368ff20.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:37612 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S932236AbWBRWLl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Feb 2006 17:11:41 -0500
Content-Disposition: inline
In-Reply-To: <20060217211049.4368ff20.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, linux-scsi@vger.kernel.org

Hi there,

On Fri, Feb 17, 2006 at 21:10:49 -0800, Andrew Morton wrote:
> > I just tried to compile the Linux Kernel version 2.6.11.12
> > with the most excellent Intel C compiler. It said
> > 
> > drivers/scsi/pcmcia/aha152x_stub.c(313): remark #592: variable "tmp" is used
> > before its value is set
> >        tmp.device->host = info->host;
> >        ^
> > 
> > This is clearly broken code, since the field tmp.device has not been
> > initialised, and so isn't pointing to anything.

Fix below.

Signed-off-by: Juergen E. Fischer <fischer@linux-buechse.de>


diff -ur orig/linux-2.6/drivers/scsi/aha152x.c linux-2.6/drivers/scsi/aha152x.c
--- orig/linux-2.6/drivers/scsi/aha152x.c	2006-02-18 13:04:12.132570132 +0100
+++ linux-2.6/drivers/scsi/aha152x.c	2006-02-18 22:49:58.121862877 +0100
@@ -1259,16 +1259,15 @@
  * Reset the bus
  *
  */
-static int aha152x_bus_reset(Scsi_Cmnd *SCpnt)
+static int aha152x_bus_reset_host(struct Scsi_Host *shpnt)
 {
-	struct Scsi_Host *shpnt = SCpnt->device->host;
 	unsigned long flags;
 
 	DO_LOCK(flags);
 
 #if defined(AHA152X_DEBUG)
 	if(HOSTDATA(shpnt)->debug & debug_eh) {
-		printk(DEBUG_LEAD "aha152x_bus_reset(%p)", CMDINFO(SCpnt), SCpnt);
+		printk(KERN_DEBUG "scsi%d: bus reset", shpnt->host_no);
 		show_queues(shpnt);
 	}
 #endif
@@ -1276,14 +1275,14 @@
 	free_hard_reset_SCs(shpnt, &ISSUE_SC);
 	free_hard_reset_SCs(shpnt, &DISCONNECTED_SC);
 
-	DPRINTK(debug_eh, DEBUG_LEAD "resetting bus\n", CMDINFO(SCpnt));
+	DPRINTK(debug_eh, KERN_DEBUG "scsi%d: resetting bus\n", shpnt->host_no);
 
 	SETPORT(SCSISEQ, SCSIRSTO);
 	mdelay(256);
 	SETPORT(SCSISEQ, 0);
 	mdelay(DELAY);
 
-	DPRINTK(debug_eh, DEBUG_LEAD "bus resetted\n", CMDINFO(SCpnt));
+	DPRINTK(debug_eh, KERN_DEBUG "scsi%d: bus resetted\n", shpnt->host_no);
 
 	setup_expected_interrupts(shpnt);
 	if(HOSTDATA(shpnt)->commands==0)
@@ -1294,6 +1293,14 @@
 	return SUCCESS;
 }
 
+/*
+ * Reset the bus
+ *
+ */
+static int aha152x_bus_reset(Scsi_Cmnd *SCpnt)
+{
+	return aha152x_bus_reset_host(SCpnt->device->host);
+}
 
 /*
  *  Restore default values to the AIC-6260 registers and reset the fifos
@@ -1336,23 +1343,28 @@
  * Reset the host (bus and controller)
  *
  */
-int aha152x_host_reset(Scsi_Cmnd * SCpnt)
+int aha152x_host_reset_host(struct Scsi_Host *shpnt)
 {
-#if defined(AHA152X_DEBUG)
-	struct Scsi_Host *shpnt = SCpnt->device->host;
-#endif
+	DPRINTK(debug_eh, KERN_DEBUG "scsi%d: host reset\n", shpnt->host_no);
 
-	DPRINTK(debug_eh, DEBUG_LEAD "aha152x_host_reset(%p)\n", CMDINFO(SCpnt), SCpnt);
+	aha152x_bus_reset_host(shpnt);
 
-	aha152x_bus_reset(SCpnt);
-
-	DPRINTK(debug_eh, DEBUG_LEAD "resetting ports\n", CMDINFO(SCpnt));
-	reset_ports(SCpnt->device->host);
+	DPRINTK(debug_eh, KERN_DEBUG "scsi%d: resetting ports\n", shpnt->host_no);
+	reset_ports(shpnt);
 
 	return SUCCESS;
 }
 
 /*
+ * Reset the host (bus and controller)
+ * 
+ */
+static int aha152x_host_reset(Scsi_Cmnd *SCpnt)
+{
+	return aha152x_host_reset_host(SCpnt->device->host);
+}
+
+/*
  * Return the "logical geometry"
  *
  */
@@ -1430,22 +1442,18 @@
 {
 	int i;
 	for (i = 0; i<ARRAY_SIZE(aha152x_host); i++) {
-		struct Scsi_Host *shpnt = aha152x_host[i];
-		if (shpnt && HOSTDATA(shpnt)->service) {
-			HOSTDATA(shpnt)->service=0;
-			is_complete(shpnt);
-		}
+		is_complete(aha152x_host[i]);
 	}
 }
 
 /*
- *    Interrupts handler
+ * Interrupt handler
  *
  */
-
 static irqreturn_t intr(int irqno, void *dev_id, struct pt_regs *regs)
 {
 	struct Scsi_Host *shpnt = lookup_irq(irqno);
+	unsigned long flags;
 	unsigned char rev, dmacntrl0;
 
 	if (!shpnt) {
@@ -1471,23 +1479,23 @@
 	if ((rev == 0xFF) && (dmacntrl0 == 0xFF))
 		return IRQ_NONE;
 
+	if( TESTLO(DMASTAT, INTSTAT) )
+		return IRQ_NONE;	
+
 	/* no more interrupts from the controller, while we're busy.
 	   INTEN is restored by the BH handler */
 	CLRBITS(DMACNTRL0, INTEN);
 
-#if 0
-	/* check if there is already something to be
-           serviced; should not happen */
-	if(HOSTDATA(shpnt)->service) {
-		printk(KERN_ERR "aha152x%d: lost interrupt (%d)\n", HOSTNO, HOSTDATA(shpnt)->service);
-	        show_queues(shpnt);
+	DO_LOCK(flags);
+	if( HOSTDATA(shpnt)->service==0 ) {
+		HOSTDATA(shpnt)->service=1;
+
+		/* Poke the BH handler */
+		INIT_WORK(&aha152x_tq, (void *) run, NULL);
+		schedule_work(&aha152x_tq);
 	}
-#endif
-	
-	/* Poke the BH handler */
-	HOSTDATA(shpnt)->service++;
-	INIT_WORK(&aha152x_tq, (void *) run, NULL);
-	schedule_work(&aha152x_tq);
+	DO_UNLOCK(flags);
+
 	return IRQ_HANDLED;
 }
 
@@ -2526,7 +2534,11 @@
 	unsigned long flags;
 	int pending;
 
+	if(!shpnt)
+		return;
+
 	DO_LOCK(flags);
+
 	if(HOSTDATA(shpnt)->in_intr) {
 		DO_UNLOCK(flags);
 		/* aha152x_error never returns.. */
@@ -2534,6 +2546,14 @@
 	}
 	HOSTDATA(shpnt)->in_intr++;
 
+	if( HOSTDATA(shpnt)->service==0 )  {
+		DO_UNLOCK(flags);
+		return;
+	}
+
+	HOSTDATA(shpnt)->service = 0;
+
+
 	/*
 	 * loop while there are interrupt conditions pending
 	 *
diff -ur orig/linux-2.6/drivers/scsi/aha152x.h linux-2.6/drivers/scsi/aha152x.h
--- orig/linux-2.6/drivers/scsi/aha152x.h	2005-06-17 21:48:29.000000000 +0200
+++ linux-2.6/drivers/scsi/aha152x.h	2006-02-18 16:40:48.383590058 +0100
@@ -332,6 +332,6 @@
 
 struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *);
 void aha152x_release(struct Scsi_Host *);
-int aha152x_host_reset(Scsi_Cmnd *);
+int aha152x_host_reset_host(struct Scsi_Host *);
 
 #endif /* _AHA152X_H */
diff -ur orig/linux-2.6/drivers/scsi/pcmcia/aha152x_stub.c linux-2.6/drivers/scsi/pcmcia/aha152x_stub.c
--- orig/linux-2.6/drivers/scsi/pcmcia/aha152x_stub.c	2006-02-18 12:52:23.902417669 +0100
+++ linux-2.6/drivers/scsi/pcmcia/aha152x_stub.c	2006-02-18 20:52:18.154711475 +0100
@@ -302,10 +302,8 @@
 	/* Fall through... */
     case CS_EVENT_CARD_RESET:
 	if (link->state & DEV_CONFIG) {
-	    Scsi_Cmnd tmp;
 	    pcmcia_request_configuration(link->handle, &link->conf);
-	    tmp.device->host = info->host;
-	    aha152x_host_reset(&tmp);
+	    aha152x_host_reset_host(info->host);
 	}
 	break;
     }


From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Marcelo, please apply [PATCH] AHA152x driver hangs on PCMCIA card eject, kernel2.4.22-pre6
Date: Wed, 23 Jul 2003 20:48:05 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030723204805.A31900@infradead.org>
References: <021a01c34f91$ffe6e4c0$6e260987@rnd.avaya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:28423 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S271239AbTGWTdB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jul 2003 15:33:01 -0400
Content-Disposition: inline
In-Reply-To: <021a01c34f91$ffe6e4c0$6e260987@rnd.avaya.com>; from bhavesh@avaya.com on Mon, Jul 21, 2003 at 08:11:37AM -0600
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, "Bhavesh P. Davda" <bhavesh@avaya.com>

On Mon, Jul 21, 2003 at 08:11:37AM -0600, Bhavesh P. Davda wrote:
> Marcelo,
> 
> David Hinds approves of this patch (Thanks, Dave!). Please apply to 2.4.22

And here's a 2.6 version.

--- 1.34/drivers/scsi/aha152x.c	Fri Jul 18 16:43:18 2003
+++ edited/drivers/scsi/aha152x.c	Wed Jul 23 10:18:09 2003
@@ -1868,11 +1868,30 @@
 static irqreturn_t intr(int irqno, void *dev_id, struct pt_regs *regs)
 {
 	struct Scsi_Host *shpnt = lookup_irq(irqno);
+	unsigned char rev, dmacntrl0;
 
 	if (!shpnt) {
 		printk(KERN_ERR "aha152x: catched interrupt %d for unknown controller.\n", irqno);
 		return IRQ_NONE;
 	}
+
+	/*
+	 * Read a couple of registers that are known to not be all 1's. If
+	 * we read all 1's (-1), that means that either:
+	 *
+	 * a. The host adapter chip has gone bad, and we cannot control it,
+	 *	OR
+	 * b. The host adapter is a PCMCIA card that has been ejected
+	 *
+	 * In either case, we cannot do anything with the host adapter at
+	 * this point in time. So just ignore the interrupt and return.
+	 * In the latter case, the interrupt might actually be meant for
+	 * someone else sharing this IRQ, and that driver will handle it.
+	 */
+	rev = GETPORT(REV);
+	dmacntrl0 = GETPORT(DMACNTRL0);
+	if ((rev == 0xFF) && (dmacntrl0 == 0xFF))
+		return IRQ_NONE;
 
 	/* no more interrupts from the controller, while we're busy.
 	   INTEN is restored by the BH handler */
===== drivers/scsi/pcmcia/aha152x_stub.c 1.17 vs edited =====
--- 1.17/drivers/scsi/pcmcia/aha152x_stub.c	Fri Jul 18 16:43:19 2003
+++ edited/drivers/scsi/pcmcia/aha152x_stub.c	Wed Jul 23 10:18:09 2003
@@ -40,7 +40,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/timer.h>
 #include <linux/ioport.h>
 #include <scsi/scsi.h>
 #include <linux/major.h>
@@ -102,7 +101,7 @@
     struct Scsi_Host	*host;
 } scsi_info_t;
 
-static void aha152x_release_cs(u_long arg);
+static void aha152x_release_cs(dev_link_t *link);
 static int aha152x_event(event_t event, int priority,
 			 event_callback_args_t *args);
 
@@ -126,9 +125,6 @@
     if (!info) return NULL;
     memset(info, 0, sizeof(*info));
     link = &info->link; link->priv = info;
-    init_timer(&link->release);
-    link->release.function = &aha152x_release_cs;
-    link->release.data = (u_long)link;
 
     link->io.NumPorts1 = 0x20;
     link->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
@@ -181,9 +177,8 @@
     if (*linkp == NULL)
 	return;
 
-    del_timer(&link->release);
     if (link->state & DEV_CONFIG) {
-	aha152x_release_cs((u_long)link);
+	aha152x_release_cs(link);
 	if (link->state & DEV_STALE_CONFIG) {
 	    link->state |= DEV_STALE_LINK;
 	    return;
@@ -290,13 +285,12 @@
     
 cs_failed:
     cs_error(link->handle, last_fn, last_ret);
-    aha152x_release_cs((u_long)link);
+    aha152x_release_cs(link);
     return;
 }
 
-static void aha152x_release_cs(u_long arg)
+static void aha152x_release_cs(dev_link_t *link)
 {
-	dev_link_t *link = (dev_link_t *)arg;
 	scsi_info_t *info = link->priv;
 
 	scsi_remove_host(info->host);
@@ -325,7 +319,7 @@
     case CS_EVENT_CARD_REMOVAL:
 	link->state &= ~DEV_PRESENT;
 	if (link->state & DEV_CONFIG)
-	    mod_timer(&link->release, jiffies + HZ/20);
+	    aha152x_release_cs(link);
 	break;
     case CS_EVENT_CARD_INSERTION:
 	link->state |= DEV_PRESENT | DEV_CONFIG_PENDING;
===== drivers/scsi/pcmcia/fdomain_stub.c 1.18 vs edited =====
--- 1.18/drivers/scsi/pcmcia/fdomain_stub.c	Fri Jul 18 16:43:19 2003
+++ edited/drivers/scsi/pcmcia/fdomain_stub.c	Wed Jul 23 10:18:09 2003
@@ -37,7 +37,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/timer.h>
 #include <linux/ioport.h>
 #include <scsi/scsi.h>
 #include <linux/major.h>
@@ -90,7 +89,7 @@
 extern struct Scsi_Host *__fdomain_16x0_detect( Scsi_Host_Template *tpnt );
 extern int fdomain_16x0_bus_reset(Scsi_Cmnd *SCpnt);
 
-static void fdomain_release(u_long arg);
+static void fdomain_release(dev_link_t *link);
 static int fdomain_event(event_t event, int priority,
 			event_callback_args_t *args);
 
@@ -116,10 +115,6 @@
     if (!info) return NULL;
     memset(info, 0, sizeof(*info));
     link = &info->link; link->priv = info;
-    init_timer(&link->release);
-    link->release.function = &fdomain_release;
-    link->release.data = (u_long)link;
-
     link->io.NumPorts1 = 0x10;
     link->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
     link->io.IOAddrLines = 10;
@@ -171,9 +166,8 @@
     if (*linkp == NULL)
 	return;
 
-    del_timer(&link->release);
     if (link->state & DEV_CONFIG) {
-	fdomain_release((u_long)link);
+	fdomain_release(link);
 	if (link->state & DEV_STALE_CONFIG) {
 	    link->state |= DEV_STALE_LINK;
 	    return;
@@ -266,16 +260,15 @@
     
 cs_failed:
     cs_error(link->handle, last_fn, last_ret);
-    fdomain_release((u_long)link);
+    fdomain_release(link);
     return;
     
 } /* fdomain_config */
 
 /*====================================================================*/
 
-static void fdomain_release(u_long arg)
+static void fdomain_release(dev_link_t *link)
 {
-    dev_link_t *link = (dev_link_t *)arg;
     scsi_info_t *info = link->priv;
 
     DEBUG(0, "fdomain_release(0x%p)\n", link);
@@ -307,7 +300,7 @@
     case CS_EVENT_CARD_REMOVAL:
 	link->state &= ~DEV_PRESENT;
 	if (link->state & DEV_CONFIG)
-	    mod_timer(&link->release, jiffies + HZ/20);
+	    fdomain_release(link);
 	break;
     case CS_EVENT_CARD_INSERTION:
 	link->state |= DEV_PRESENT | DEV_CONFIG_PENDING;
===== drivers/scsi/pcmcia/nsp_cs.c 1.25 vs edited =====
--- 1.25/drivers/scsi/pcmcia/nsp_cs.c	Fri Jul 18 16:43:19 2003
+++ edited/drivers/scsi/pcmcia/nsp_cs.c	Wed Jul 23 10:18:09 2003
@@ -38,7 +38,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/timer.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
@@ -1477,10 +1476,6 @@
 	link = &info->link;
 	link->priv = info;
 
-	/* Initialize the dev_link_t structure */
-	link->release.function	 = &nsp_cs_release;
-	link->release.data	 = (u_long)link;
-
 	/* The io structure describes IO port mapping */
 	link->io.NumPorts1	 = 0x10;
 	link->io.Attributes1	 = IO_DATA_PATH_WIDTH_AUTO;
@@ -1558,9 +1553,8 @@
 		return;
 	}
 
-	del_timer(&link->release);
 	if (link->state & DEV_CONFIG) {
-		nsp_cs_release((u_long)link);
+		nsp_cs_release(link);
 		if (link->state & DEV_STALE_CONFIG) {
 			link->state |= DEV_STALE_LINK;
 			return;
@@ -1780,7 +1774,7 @@
 
 cs_failed:
 	cs_error(link->handle, last_fn, last_ret);
-	nsp_cs_release((u_long)link);
+	nsp_cs_release(link);
 	return;
 
 } /* nsp_cs_config */
@@ -1792,9 +1786,8 @@
     device, and release the PCMCIA configuration.  If the device is
     still open, this will be postponed until it is closed.
 ======================================================================*/
-static void nsp_cs_release(u_long arg)
+static void nsp_cs_release(dev_link_t *link)
 {
-	dev_link_t *link = (dev_link_t *)arg;
 	scsi_info_t *info = link->priv;
 
 	DEBUG(0, "%s(0x%p)\n", __FUNCTION__, link);
@@ -1866,7 +1859,7 @@
 		link->state &= ~DEV_PRESENT;
 		if (link->state & DEV_CONFIG) {
 			((scsi_info_t *)link->priv)->stop = 1;
-			mod_timer(&link->release, jiffies + HZ/20);
+			nsp_cs_release(link);
 		}
 		break;
 
@@ -1933,7 +1926,7 @@
 	/* XXX: this really needs to move into generic code.. */
 	while (dev_list != NULL) {
 		if (dev_list->state & DEV_CONFIG) {
-			nsp_cs_release((u_long)dev_list);
+			nsp_cs_release(dev_list);
 		}
 		nsp_cs_detach(dev_list);
 	}
===== drivers/scsi/pcmcia/nsp_cs.h 1.10 vs edited =====
--- 1.10/drivers/scsi/pcmcia/nsp_cs.h	Mon May 12 16:26:17 2003
+++ edited/drivers/scsi/pcmcia/nsp_cs.h	Wed Jul 23 10:18:09 2003
@@ -272,7 +272,7 @@
 
 
 
-static void        nsp_cs_release(u_long arg);
+static void        nsp_cs_release(dev_link_t *link);
 static int         nsp_cs_event(event_t event, int priority, event_callback_args_t *args);
 static dev_link_t *nsp_cs_attach(void);
 static void        nsp_cs_detach(dev_link_t *);
===== drivers/scsi/pcmcia/qlogic_stub.c 1.17 vs edited =====
--- 1.17/drivers/scsi/pcmcia/qlogic_stub.c	Fri Jul 18 16:43:19 2003
+++ edited/drivers/scsi/pcmcia/qlogic_stub.c	Wed Jul 23 10:18:09 2003
@@ -37,7 +37,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/timer.h>
 #include <linux/ioport.h>
 #include <asm/io.h>
 #include <scsi/scsi.h>
@@ -90,7 +89,7 @@
 	unsigned short manf_id;
 } scsi_info_t;
 
-static void qlogic_release(u_long arg);
+static void qlogic_release(dev_link_t *link);
 static int qlogic_event(event_t event, int priority, event_callback_args_t * args);
 
 static dev_link_t *qlogic_attach(void);
@@ -117,10 +116,6 @@
 	memset(info, 0, sizeof(*info));
 	link = &info->link;
 	link->priv = info;
-	init_timer(&link->release);
-	link->release.function = &qlogic_release;
-	link->release.data = (u_long) link;
-
 	link->io.NumPorts1 = 16;
 	link->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
 	link->io.IOAddrLines = 10;
@@ -170,9 +165,8 @@
 	if (*linkp == NULL)
 		return;
 
-	del_timer_sync(&link->release);
 	if (link->state & DEV_CONFIG) {
-		qlogic_release((u_long) link);
+		qlogic_release(link);
 		if (link->state & DEV_STALE_CONFIG) {
 			link->state |= DEV_STALE_LINK;
 			return;
@@ -279,16 +273,15 @@
 
 cs_failed:
 	cs_error(link->handle, last_fn, last_ret);
-	qlogic_release((u_long) link);
+	qlogic_release(link);
 	return;
 
 }				/* qlogic_config */
 
 /*====================================================================*/
 
-static void qlogic_release(u_long arg)
+static void qlogic_release(dev_link_t *link)
 {
-	dev_link_t *link = (dev_link_t *) arg;
 	scsi_info_t *info = link->priv;
 
 	DEBUG(0, "qlogic_release(0x%p)\n", link);
@@ -319,7 +312,7 @@
 	case CS_EVENT_CARD_REMOVAL:
 		link->state &= ~DEV_PRESENT;
 		if (link->state & DEV_CONFIG)
-			mod_timer(&link->release, jiffies + HZ / 20);
+			qlogic_release(link);
 		break;
 	case CS_EVENT_CARD_INSERTION:
 		link->state |= DEV_PRESENT | DEV_CONFIG_PENDING;

From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] nuke some junk from the pcmcia scsi drivers
Date: Fri, 8 Aug 2003 21:10:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030808191050.GD17983@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:54658 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S271848AbTHHTKx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2003 15:10:53 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

DEV_STALE_* is used for some crude hacks in pcmcia netdrivers and it
seems people copied it blindly over to the scsi ones also it couldn't
ever be triggered (dev_link_t.open is never incremented e.g.)


diff -Nru a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
--- a/drivers/scsi/pcmcia/aha152x_stub.c	Fri Aug  8 11:12:56 2003
+++ b/drivers/scsi/pcmcia/aha152x_stub.c	Fri Aug  8 11:12:56 2003
@@ -177,13 +177,8 @@
     if (*linkp == NULL)
 	return;
 
-    if (link->state & DEV_CONFIG) {
+    if (link->state & DEV_CONFIG)
 	aha152x_release_cs(link);
-	if (link->state & DEV_STALE_CONFIG) {
-	    link->state |= DEV_STALE_LINK;
-	    return;
-	}
-    }
 
     if (link->handle)
 	CardServices(DeregisterClient, link->handle);
@@ -302,9 +297,6 @@
     
 	link->state &= ~DEV_CONFIG;
 	scsi_unregister(info->host);
-
-	if (link->state & DEV_STALE_LINK)
-		aha152x_detach(link);
 }
 
 static int aha152x_event(event_t event, int priority,
diff -Nru a/drivers/scsi/pcmcia/fdomain_stub.c b/drivers/scsi/pcmcia/fdomain_stub.c
--- a/drivers/scsi/pcmcia/fdomain_stub.c	Fri Aug  8 11:12:56 2003
+++ b/drivers/scsi/pcmcia/fdomain_stub.c	Fri Aug  8 11:12:56 2003
@@ -166,13 +166,8 @@
     if (*linkp == NULL)
 	return;
 
-    if (link->state & DEV_CONFIG) {
+    if (link->state & DEV_CONFIG)
 	fdomain_release(link);
-	if (link->state & DEV_STALE_CONFIG) {
-	    link->state |= DEV_STALE_LINK;
-	    return;
-	}
-    }
 
     if (link->handle)
 	CardServices(DeregisterClient, link->handle);
@@ -283,9 +278,7 @@
     scsi_unregister(info->host);
 
     link->state &= ~DEV_CONFIG;
-    if (link->state & DEV_STALE_LINK)
-	fdomain_detach(link);
-} /* fdomain_release */
+}
 
 /*====================================================================*/
 
diff -Nru a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
--- a/drivers/scsi/pcmcia/nsp_cs.c	Fri Aug  8 11:12:56 2003
+++ b/drivers/scsi/pcmcia/nsp_cs.c	Fri Aug  8 11:12:56 2003
@@ -1553,18 +1553,12 @@
 		return;
 	}
 
-	if (link->state & DEV_CONFIG) {
+	if (link->state & DEV_CONFIG)
 		nsp_cs_release(link);
-		if (link->state & DEV_STALE_CONFIG) {
-			link->state |= DEV_STALE_LINK;
-			return;
-		}
-	}
 
 	/* Break the link with Card Services */
-	if (link->handle) {
+	if (link->handle)
 		CardServices(DeregisterClient, link->handle);
-	}
 
 	/* Unlink device structure, free bits */
 	*linkp = link->next;
@@ -1792,17 +1786,6 @@
 
 	DEBUG(0, "%s(0x%p)\n", __FUNCTION__, link);
 
-	/*
-	 * If the device is currently in use, we won't release until it
-	 * is actually closed.
-	 */
-	if (link->open) {
-		DEBUG(1, "nsp_cs: release postponed, '%s' still open\n",
-		      link->dev->dev_name);
-		link->state |= DEV_STALE_CONFIG;
-		return;
-	}
-
 	/* Unlink the device chain */
 #if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,2))
 	scsi_unregister_module(MODULE_SCSI_HA, &nsp_driver_template);
@@ -1824,11 +1807,7 @@
 		CardServices(ReleaseIRQ,    link->handle, &link->irq);
 	}
 	link->state &= ~DEV_CONFIG;
-
-	if (link->state & DEV_STALE_LINK) {
-		nsp_cs_detach(link);
-	}
-} /* nsp_cs_release */
+}
 
 /*======================================================================
 
diff -Nru a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
--- a/drivers/scsi/pcmcia/qlogic_stub.c	Fri Aug  8 11:12:56 2003
+++ b/drivers/scsi/pcmcia/qlogic_stub.c	Fri Aug  8 11:12:56 2003
@@ -165,13 +165,8 @@
 	if (*linkp == NULL)
 		return;
 
-	if (link->state & DEV_CONFIG) {
+	if (link->state & DEV_CONFIG)
 		qlogic_release(link);
-		if (link->state & DEV_STALE_CONFIG) {
-			link->state |= DEV_STALE_LINK;
-			return;
-		}
-	}
 
 	if (link->handle)
 		CardServices(DeregisterClient, link->handle);
@@ -296,9 +291,7 @@
 	scsi_unregister(info->host);
 
 	link->state &= ~DEV_CONFIG;
-	if (link->state & DEV_STALE_LINK)
-		qlogic_detach(link);
-}				/* qlogic_release */
+}
 
 /*====================================================================*/
 

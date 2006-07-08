From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic94xx: fix sleep under lock
Date: Sat, 08 Jul 2006 11:03:48 -0500
Message-ID: <1152374628.12020.2.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:54948 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964880AbWGHQDu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jul 2006 12:03:50 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k68G3nY00605
	for <linux-scsi@vger.kernel.org>; Sat, 8 Jul 2006 12:03:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Lockdep didn't pick this one up for me, sigh ...

But I noticed the port_alloc/port_add functions are called with locks
held.  Since these may potentially sleep, this is a no-no.  Correct by
moving the calls to outside the locked region.

James

Index: BUILD-2.6/drivers/scsi/sas/sas_port.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_port.c	2006-07-08 10:40:18.000000000 -0500
+++ BUILD-2.6/drivers/scsi/sas/sas_port.c	2006-07-08 10:43:31.000000000 -0500
@@ -82,13 +82,6 @@
 		return;
 	}
 
-	if (!port->port) {
-		port->port = sas_port_alloc(phy->phy->dev.parent, port->id);
-		BUG_ON(!port->port);
-		sas_port_add(port->port);
-	}
-	sas_port_add_phy(port->port, phy->phy);
-
 	/* add the phy to the port */
 	list_add_tail(&phy->port_phy_el, &port->phy_list);
 	phy->port = port;
@@ -114,6 +107,13 @@
 	spin_unlock(&port->phy_list_lock);
 	spin_unlock(&sas_ha->phy_port_lock);
 
+	if (!port->port) {
+		port->port = sas_port_alloc(phy->phy->dev.parent, port->id);
+		BUG_ON(!port->port);
+		sas_port_add(port->port);
+	}
+	sas_port_add_phy(port->port, phy->phy);
+
 	if (port->port_dev)
 		port->port_dev->pathways = port->num_phys;
 



From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic94xx: fix panic on module removal in complex topology
Date: Sun, 02 Jul 2006 22:38:52 -0500
Message-ID: <1151897932.3942.2.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:11989 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751135AbWGCDiy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Jul 2006 23:38:54 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k633crY01149
	for <linux-scsi@vger.kernel.org>; Sun, 2 Jul 2006 23:38:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The aic94xx still isn't stable in complex topologies.  This patch fixes
a panic in a two expander two device wide port configuration.  However,
there's still a fairly nasty soft lockup on module insertion while it's
scanning the ports.

James

Index: BUILD-2.6/drivers/scsi/sas/sas_expander.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_expander.c	2006-07-03 04:42:18.000000000 -0500
+++ BUILD-2.6/drivers/scsi/sas/sas_expander.c	2006-07-03 04:42:37.000000000 -0500
@@ -683,15 +683,12 @@
 		BUG();
 	}
 	port = parent->port;
-	port->phy = phy->phy;
-	port->port = phy->port;
 	child->rphy = rphy;
 	edev = rphy_to_expander_device(rphy);
 	child->dev_type = phy->attached_dev_type;
 	child->parent = parent;
 	port->port_dev = child;
 	child->port = port;
-	child->port->port = phy->port;
 	child->iproto = phy->attached_iproto;
 	child->tproto = phy->attached_tproto;
 	memcpy(child->sas_addr, phy->attached_sas_addr, SAS_ADDR_SIZE);
@@ -702,6 +699,11 @@
 					   edev->level);
 	sas_init_dev(child);
 	sas_rphy_add(child->rphy);
+
+	spin_lock(&parent->port->dev_list_lock);
+	list_add_tail(&child->dev_list_node, &parent->port->dev_list);
+	spin_unlock(&parent->port->dev_list_lock);
+
 	res = sas_discover_expander(child);
 	if (res) {
 		kfree(child);



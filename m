From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic94xx: fix hotplug/unplug
Date: Sun, 27 Aug 2006 12:48:21 -0500
Message-ID: <1156700901.3460.18.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:54765 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932210AbWH0RsW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Aug 2006 13:48:22 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k7RHmL505494
	for <linux-scsi@vger.kernel.org>; Sun, 27 Aug 2006 13:48:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This should fix hotplug/unplug, at least for devices.

There were several problems

- Broadcasts weren't being correctly propagated in cascaded expander
environments
- devices weren't being properly unregistered.
- ports weren't being correctly added and removed.

The same now probably needs to be done for expanders, and probably for
directly attached devices.

There's also a problem with SATA hotplug, but it seems to be an expander
issue with my LSI SASx12.  When a SATA device is hotplugged, the
expander goes into some type of phy error but doesn't report a broadcast
change.  The device can be added by resetting the phy, but this is
manual.

James

Index: BUILD-2.6/drivers/scsi/libsas/sas_expander.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_expander.c	2006-08-27 12:33:11.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_expander.c	2006-08-27 12:33:37.000000000 -0500
@@ -148,11 +148,14 @@ static void sas_set_ex_phy(struct domain
 	struct smp_resp *resp = disc_resp;
 	struct discover_resp *dr = &resp->disc;
 	struct sas_rphy *rphy = dev->rphy;
+	int rediscover = (phy->phy != NULL);
 
-	phy->phy = sas_phy_alloc(&rphy->dev, phy_id);
+	if (!rediscover) {
+		phy->phy = sas_phy_alloc(&rphy->dev, phy_id);
 
-	/* FIXME: error_handling */
-	BUG_ON(!phy->phy);
+		/* FIXME: error_handling */
+		BUG_ON(!phy->phy);
+	}
 
 	switch (resp->result) {
 	case SMP_RESP_PHY_VACANT:
@@ -203,7 +206,8 @@ static void sas_set_ex_phy(struct domain
 		break;
 	}
 
-	sas_phy_add(phy->phy);
+	if (!rediscover)
+		sas_phy_add(phy->phy);
 
 	SAS_DPRINTK("ex %016llx phy%02d:%c attached: %016llx\n",
 		    SAS_ADDR(dev->sas_addr), phy->phy_id,
@@ -764,7 +768,6 @@ static struct domain_device *sas_ex_disc
 	edev = rphy_to_expander_device(rphy);
 	child->dev_type = phy->attached_dev_type;
 	child->parent = parent;
-	port->port_dev = child;
 	child->port = port;
 	child->iproto = phy->attached_iproto;
 	child->tproto = phy->attached_tproto;
@@ -787,6 +790,7 @@ static struct domain_device *sas_ex_disc
 		kfree(child);
 		return NULL;
 	}
+	list_add_tail(&child->siblings, &parent->ex_dev.children);
 	return child;
 }
 
@@ -1533,15 +1537,19 @@ static int sas_get_phy_attached_sas_addr
 {
 	int res;
 	struct smp_resp *disc_resp;
+	struct discover_resp *dr;
 
 	disc_resp = alloc_smp_resp(DISCOVER_RESP_SIZE);
 	if (!disc_resp)
 		return -ENOMEM;
+	dr = &disc_resp->disc;
 
 	res = sas_get_phy_discover(dev, phy_id, disc_resp);
-	if (!res)
+	if (!res) {
 		memcpy(attached_sas_addr,disc_resp->disc.attached_sas_addr,8);
-
+		if (dr->attached_dev_type == 0)
+			memset(attached_sas_addr, 0, 8);
+	}
 	kfree(disc_resp);
 	return res;
 }
@@ -1668,6 +1676,10 @@ static void sas_unregister_devs_sas_addr
 	}
 	sas_disable_routing(parent, phy->attached_sas_addr);
 	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
+	sas_port_delete_phy(phy->port, phy->phy);
+	if (phy->port->num_phys == 0)
+		sas_port_delete(phy->port);
+	phy->port = NULL;
 }
 
 static int sas_discover_bfs_by_root_level(struct domain_device *root,
Index: BUILD-2.6/drivers/scsi/libsas/sas_discover.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_discover.c	2006-08-27 12:32:04.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_discover.c	2006-08-27 12:33:11.000000000 -0500
@@ -629,6 +629,7 @@ void sas_unregister_dev(struct domain_de
 		kfree(dev->ex_dev.ex_phy);
 		dev->ex_dev.ex_phy = NULL;
 	}
+	sas_unregister_common_dev(dev);
 }
 
 static void sas_unregister_domain_devices(void *data)





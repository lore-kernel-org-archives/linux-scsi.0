From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] update: aic94xx: make use of the new sas_port
Date: Thu, 01 Jun 2006 16:43:48 -0500
Message-ID: <1149198228.3489.66.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:11475 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750967AbWFAVnt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jun 2006 17:43:49 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k51Lhma15510
	for <linux-scsi@vger.kernel.org>; Thu, 1 Jun 2006 17:43:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This likewise has a few updates: notably to make domain devices play
better with the expander ports.

Now if someone could actually test this over a wide port from an
expander to another device, I'd be grateful ...

James

---

[PATCH] aic94xx: make use of the new sas_port

This one is slightly tricky.  The aic94xx driver has a natural sas_port
at the HBA level, but it doesn't have any concept of a sas_port at the
expander level.  Since this is just a proof of concept I just rammed one
in there; however a bit more careful work will have to be done to make
this clean.

James

Index: BUILD-2.6/drivers/scsi/sas/sas_discover.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_discover.c
+++ BUILD-2.6/drivers/scsi/sas/sas_discover.c
@@ -237,13 +237,15 @@ static int sas_get_port_device(struct as
 
 	switch (dev->dev_type) {
 	case SAS_END_DEV:
-		rphy = sas_end_device_alloc(phy->phy);
+		rphy = sas_end_device_alloc(port->port);
 		break;
 	case EDGE_DEV:
-		rphy = sas_expander_alloc(phy->phy, SAS_EDGE_EXPANDER_DEVICE);
+		rphy = sas_expander_alloc(port->port,
+					  SAS_EDGE_EXPANDER_DEVICE);
 		break;
 	case FANOUT_DEV:
-		rphy = sas_expander_alloc(phy->phy, SAS_FANOUT_EXPANDER_DEVICE);
+		rphy = sas_expander_alloc(port->port,
+					  SAS_FANOUT_EXPANDER_DEVICE);
 		break;
 	default:
 		printk("ERROR: Unidentified device type %d\n", dev->dev_type);
@@ -580,10 +582,6 @@ int sas_discover_end_dev(struct domain_d
 	if (res)
 		return res;
 
-
-	if (!res) {
-	}
-
 	res = sas_rphy_add(dev->rphy);
 	if (res)
 		goto out_err;
@@ -614,7 +612,18 @@ static inline void sas_unregister_common
 
 void sas_unregister_dev(struct domain_device *dev)
 {
-	sas_rphy_delete(dev->rphy);
+	if (dev->rphy) {
+		sas_remove_children(&dev->rphy->dev);
+		sas_rphy_delete(dev->rphy);
+		dev->rphy = NULL;
+	}
+	if (dev->dev_type == EDGE_DEV || dev->dev_type == FANOUT_DEV) {
+		/* remove the phys and ports, everything else should be gone */
+		kfree(dev->ex_dev.ex_phy);
+		dev->ex_dev.ex_phy = NULL;
+		kfree(dev->ex_dev.ex_port);
+		dev->ex_dev.ex_port = NULL;
+	}
 }
 
 static void sas_unregister_domain_devices(void *data)
@@ -628,6 +637,8 @@ static void sas_unregister_domain_device
 	list_for_each_entry_reverse_safe(dev,n,&port->dev_list,dev_list_node)
 		sas_unregister_dev(dev);
 
+	port->port->rphy = NULL;
+
 	complete(&port->port_gone_completion);
 }
 
Index: BUILD-2.6/drivers/scsi/sas/sas_expander.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_expander.c
+++ BUILD-2.6/drivers/scsi/sas/sas_expander.c
@@ -151,7 +151,6 @@ static void sas_set_ex_phy(struct domain
 	struct sas_rphy *rphy = dev->rphy;
 
 	phy->phy = sas_phy_alloc(&rphy->dev, phy_id);
-	dev_printk(KERN_ERR, &phy->phy->dev, "ALLOCATED\n\n");
 
 	/* FIXME: error_handling */
 	BUG_ON(!phy->phy);
@@ -271,18 +270,24 @@ out_err:
 static int sas_expander_discover(struct domain_device *dev)
 {
 	struct expander_device *ex = &dev->ex_dev;
-	int res;
+	int res = -ENOMEM;
 
 	ex->ex_phy = kzalloc(sizeof(*ex->ex_phy)*ex->num_phys, GFP_KERNEL);
 	if (!ex->ex_phy)
 		return -ENOMEM;
+	ex->ex_port = kzalloc(sizeof(void *)*ex->num_phys, GFP_KERNEL);
+	if (!ex->ex_port)
+		goto out_free_phys;
 
 	res = sas_ex_phy_discover(dev, -1);
 	if (res)
 		goto out_err;
 
 	return 0;
-out_err:
+ out_err:
+	kfree(ex->ex_port);
+	ex->ex_port = NULL;
+ out_free_phys:
 	kfree(ex->ex_phy);
 	ex->ex_phy = NULL;
 	return res;
@@ -513,10 +518,20 @@ static inline void sas_ex_get_linkrate(s
 				       struct ex_phy *parent_phy)
 {
 	struct expander_device *parent_ex = &parent->ex_dev;
+	struct sas_port *port;
 	int i;
 
 	child->pathways = 0;
 
+	for (i = 0; i < parent_ex->num_phys; i++)
+		if (!parent_ex->ex_port[i])
+			break;
+
+	parent_ex->ex_port[i] = port = sas_port_alloc(&parent->rphy->dev, i);
+	BUG_ON(!port);
+	/* FIXME: better error handling */
+	BUG_ON(sas_port_add(port) != 0);
+
 	for (i = 0; i < parent_ex->num_phys; i++) {
 		struct ex_phy *phy = &parent_ex->ex_phy[i];
 
@@ -532,6 +547,9 @@ static inline void sas_ex_get_linkrate(s
 			child->max_linkrate = max(parent->max_linkrate,
 						  phy->linkrate);
 			child->pathways++;
+			BUG_ON(phy->port != NULL);
+			phy->port = port;
+			sas_port_add_phy(port, phy->phy);
 		}
 	}
 	child->linkrate = min(parent_phy->linkrate, child->max_linkrate);
@@ -590,7 +608,7 @@ static struct domain_device *sas_ex_disc
 		}
 	} else if (phy->attached_tproto & SAS_PROTO_SSP) {
 		child->dev_type = SAS_END_DEV;
-		rphy = sas_end_device_alloc(phy->phy);
+		rphy = sas_end_device_alloc(phy->port);
 		/* FIXME: error handling */
 		BUG_ON(!rphy);
 		child->tproto = phy->attached_tproto;
@@ -613,7 +631,8 @@ static struct domain_device *sas_ex_disc
 				    "at %016llx:0x%x returned 0x%x\n",
 				    SAS_ADDR(child->sas_addr),
 				    SAS_ADDR(parent->sas_addr), phy_id, res);
-			kfree(child);
+			/* FIXME: this kfrees list elements without removing them */
+			//kfree(child);
 			return NULL;
 		}
 	} else {
@@ -649,10 +668,12 @@ static struct domain_device *sas_ex_disc
 		return NULL;
 	switch (phy->attached_dev_type) {
 	case EDGE_DEV:
-		rphy = sas_expander_alloc(phy->phy, SAS_EDGE_EXPANDER_DEVICE);
+		rphy = sas_expander_alloc(phy->port,
+					  SAS_EDGE_EXPANDER_DEVICE);
 		break;
 	case FANOUT_DEV:
-		rphy = sas_expander_alloc(phy->phy, SAS_FANOUT_EXPANDER_DEVICE);
+		rphy = sas_expander_alloc(phy->port,
+					  SAS_FANOUT_EXPANDER_DEVICE);
 		break;
 	default:
 		rphy = NULL;	/* shut gcc up */
Index: BUILD-2.6/drivers/scsi/sas/sas_port.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sas/sas_port.c
+++ BUILD-2.6/drivers/scsi/sas/sas_port.c
@@ -84,13 +84,19 @@ static void sas_form_port(struct asd_sas
 		return;
 	}
 
+	if (!port->port) {
+		port->port = sas_port_alloc(phy->phy->dev.parent, port->id);
+		BUG_ON(!port->port);
+		sas_port_add(port->port);
+	}
+	sas_port_add_phy(port->port, phy->phy);
+
 	/* add the phy to the port */
 	list_add_tail(&phy->port_phy_el, &port->phy_list);
 	phy->port = port;
 	port->num_phys++;
 	port->phy_mask |= (1U << phy->id);
 
-	phy->phy->port_identifier = port->id;
 	if (!port->phy)
 		port->phy = phy->phy;
 
@@ -144,7 +150,11 @@ void sas_deform_port(struct asd_sas_phy 
 		init_completion(&port->port_gone_completion);
 		sas_discover_event(port, DISCE_PORT_GONE);
 		wait_for_completion(&port->port_gone_completion);
-	}
+		sas_port_delete(port->port);
+		port->port = NULL;
+	} else
+		sas_port_delete_phy(port->port, phy->phy);
+
 
 	if (si->dft->lldd_port_deformed)
 		si->dft->lldd_port_deformed(phy);
Index: BUILD-2.6/include/scsi/sas/sas_class.h
===================================================================
--- BUILD-2.6.orig/include/scsi/sas/sas_class.h
+++ BUILD-2.6/include/scsi/sas/sas_class.h
@@ -180,6 +180,8 @@ struct asd_sas_port {
 
 	struct sas_ha_struct *ha;
 
+	struct sas_port	*port;
+
 	void *lldd_port;	  /* not touched by the sas class code */
 };
 
Index: BUILD-2.6/include/scsi/sas/sas_expander.h
===================================================================
--- BUILD-2.6.orig/include/scsi/sas/sas_expander.h
+++ BUILD-2.6/include/scsi/sas/sas_expander.h
@@ -72,6 +72,7 @@ struct ex_phy {
 	int  last_da_index;
 
 	struct sas_phy *phy;
+	struct sas_port *port;
 };
 
 struct expander_device {
@@ -85,6 +86,7 @@ struct expander_device {
 	u8     enclosure_logical_id[8];
 
 	struct ex_phy *ex_phy;
+	struct sas_port **ex_port;
 };
 
 int  sas_discover_root_expander(struct domain_device *dev);



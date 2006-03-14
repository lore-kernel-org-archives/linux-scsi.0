From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [RFC] Preliminary expander support for aic94xx
Date: Mon, 13 Mar 2006 19:02:57 -0600
Message-ID: <1142298177.3238.59.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:22936 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932533AbWCNBC7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Mar 2006 20:02:59 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k2E12v213947
	for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2006 20:02:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is dependent on the previously posted transport class expander
patch, but now it makes aic94xx handle expanders in a reasonable
fashion.

With this, the driver should be useable by almost all SAS (not SATA)
configurations ... as long as you don't try and remove it as a
module ...

James

diff --git a/drivers/scsi/sas/sas_discover.c b/drivers/scsi/sas/sas_discover.c
index c10b453..8b568ad 100644
--- a/drivers/scsi/sas/sas_discover.c
+++ b/drivers/scsi/sas/sas_discover.c
@@ -230,7 +230,21 @@ static int sas_get_port_device(struct sa
 
 	sas_init_dev(dev);
 
-	rphy = dev->dev_type == SAS_END_DEV ? sas_end_device_alloc(phy->phy) : sas_rphy_alloc(phy->phy);
+	switch (dev->dev_type) {
+	case SAS_END_DEV:
+		rphy = sas_end_device_alloc(phy->phy);
+		break;
+	case EDGE_DEV:
+		rphy = sas_expander_alloc(phy->phy, SAS_EDGE_EXPANDER_DEVICE);
+		break;
+	case FANOUT_DEV:
+		rphy = sas_expander_alloc(phy->phy, SAS_FANOUT_EXPANDER_DEVICE);
+		break;
+	default:
+		rphy = sas_rphy_alloc(phy->phy);
+		break;
+	}
+
 	if (!rphy) {
 		spin_unlock_irqrestore(&port->phy_list_lock, flags);
 		kfree(dev);
diff --git a/drivers/scsi/sas/sas_expander.c b/drivers/scsi/sas/sas_expander.c
index 0db6301..4713b19 100644
--- a/drivers/scsi/sas/sas_expander.c
+++ b/drivers/scsi/sas/sas_expander.c
@@ -142,6 +142,13 @@ static void sas_set_ex_phy(struct domain
 	struct ex_phy *phy = &ex->ex_phy[phy_id];
 	struct smp_resp *resp = disc_resp;
 	struct discover_resp *dr = &resp->disc;
+	struct sas_rphy *rphy = dev->rphy;
+
+	phy->phy = sas_phy_alloc(&rphy->dev, phy_id);
+	dev_printk(KERN_ERR, &phy->phy->dev, "ALLOCATED\n\n");
+
+	/* FIXME: error_handling */
+	BUG_ON(!phy->phy);
 
 	switch (resp->result) {
 	case SMP_RESP_PHY_VACANT:
@@ -170,6 +177,33 @@ static void sas_set_ex_phy(struct domain
 	phy->virtual = dr->virtual;
 	phy->last_da_index = -1;
 
+	/* FIXME: This probably isn't right, but it will do for now*/
+	phy->phy->local_attached = 1;
+
+	phy->phy->identify.initiator_port_protocols = phy->attached_iproto;
+	phy->phy->identify.target_port_protocols = phy->attached_tproto;
+	phy->phy->identify.phy_identifier = phy_id;
+	phy->phy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
+	phy->phy->maximum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
+	phy->phy->minimum_linkrate = SAS_LINK_RATE_1_5_GBPS;
+	phy->phy->maximum_linkrate = SAS_LINK_RATE_3_0_GBPS;
+	switch (phy->linkrate) {
+	case PHY_LINKRATE_1_5:
+		phy->phy->negotiated_linkrate = SAS_LINK_RATE_1_5_GBPS;
+		break;
+	case PHY_LINKRATE_3:
+		phy->phy->negotiated_linkrate = SAS_LINK_RATE_3_0_GBPS;
+		break;
+	case PHY_LINKRATE_6:
+		phy->phy->negotiated_linkrate = SAS_LINK_RATE_6_0_GBPS;
+		break;
+	default:
+		phy->phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
+		break;
+	}
+
+	sas_phy_add(phy->phy);
+
 	SAS_DPRINTK("ex %016llx phy%02d:%c attached: %016llx\n",
 		    SAS_ADDR(dev->sas_addr), phy->phy_id,
 		    phy->routing_attr == TABLE_ROUTING ? 'T' :
@@ -319,16 +353,19 @@ static inline void ex_assign_manuf_info(
 					*_mi_resp)
 {
 	u8 *mi_resp = _mi_resp;
+	struct sas_rphy *rphy = dev->rphy;
+	struct sas_expander_device *edev = rphy_to_expander_device(rphy);
 
-	memcpy(dev->ex_dev.vendor_id, mi_resp + 12, 8);
-	memcpy(dev->ex_dev.product_id, mi_resp + 20, 16);
-	memcpy(dev->ex_dev.product_rev, mi_resp + 36, 4);
+	memcpy(edev->vendor_id, mi_resp + 12, SAS_EXPANDER_VENDOR_ID_LEN);
+	memcpy(edev->product_id, mi_resp + 20, SAS_EXPANDER_PRODUCT_ID_LEN);
+	memcpy(edev->product_rev, mi_resp + 36,
+	       SAS_EXPANDER_PRODUCT_REV_LEN);
 
 	if (mi_resp[8] & 1) {
-		memcpy(dev->ex_dev.component_vendor_id, mi_resp + 40, 8);
-		dev->ex_dev.component_id =
-			be16_to_cpu(*(__be16 *)(mi_resp + 48));
-		dev->ex_dev.component_revision_id = mi_resp[50];
+		memcpy(edev->component_vendor_id, mi_resp + 40,
+		       SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN);
+		edev->component_id = mi_resp[48] << 8 | mi_resp[49];
+		edev->component_revision_id = mi_resp[50];
 	}
 }
 
@@ -501,6 +538,7 @@ static struct domain_device *sas_ex_disc
 	struct expander_device *parent_ex = &parent->ex_dev;
 	struct ex_phy *phy = &parent_ex->ex_phy[phy_id];
 	struct domain_device *child = NULL;
+	struct sas_rphy *rphy;
 	int res;
 
 	if (phy->attached_sata_host || phy->attached_sata_ps)
@@ -519,6 +557,7 @@ static struct domain_device *sas_ex_disc
 
 	if ((phy->attached_tproto & SAS_PROTO_STP) || phy->attached_sata_dev) {
 		child->dev_type = SATA_DEV;
+		rphy = sas_rphy_alloc(phy->phy);
 		if (phy->attached_tproto & SAS_PROTO_STP)
 			child->tproto = phy->attached_tproto;
 		if (phy->attached_sata_dev)
@@ -546,8 +585,23 @@ static struct domain_device *sas_ex_disc
 		}
 	} else if (phy->attached_tproto & SAS_PROTO_SSP) {
 		child->dev_type = SAS_END_DEV;
+		rphy = sas_end_device_alloc(phy->phy);
+		/* FIXME: error handling */
+		BUG_ON(!rphy);
 		child->tproto = phy->attached_tproto;
 		sas_init_dev(child);
+
+		child->rphy = rphy;
+		rphy->identify.phy_identifier = phy->phy->identify.phy_identifier;
+		rphy->identify.device_type = SAS_END_DEVICE;
+		rphy->identify.sas_address = SAS_ADDR(child->sas_addr);
+		rphy->identify.initiator_port_protocols = child->iproto;
+		rphy->identify.target_port_protocols = child->tproto;
+
+		spin_lock(&parent->port->dev_list_lock);
+		list_add_tail(&child->dev_list_node, &parent->port->dev_list);
+		spin_unlock(&parent->port->dev_list_lock);
+
 		res = sas_discover_end_dev(child);
 		if (res) {
 			SAS_DPRINTK("sas_discover_end_dev() for device %16llx "
@@ -561,7 +615,9 @@ static struct domain_device *sas_ex_disc
 		SAS_DPRINTK("target proto 0x%x at %016llx:0x%x not handled\n",
 			    phy->attached_tproto, SAS_ADDR(parent->sas_addr),
 			    phy_id);
+		rphy = sas_rphy_alloc(phy->phy);
 	}
+
 	list_add_tail(&child->siblings, &parent_ex->children);
 	return child;
 }
@@ -569,9 +625,11 @@ static struct domain_device *sas_ex_disc
 static struct domain_device *sas_ex_discover_expander(
 	struct domain_device *parent, int phy_id)
 {
-	struct expander_device *parent_ex = &parent->ex_dev;
-	struct ex_phy *phy = &parent_ex->ex_phy[phy_id];
+	struct sas_expander_device *parent_ex = rphy_to_expander_device(parent->rphy);
+	struct ex_phy *phy = &parent->ex_dev.ex_phy[phy_id];
 	struct domain_device *child = NULL;
+	struct sas_rphy *rphy;
+	struct sas_expander_device *edev;
 	int res;
 
 	if (phy->routing_attr == DIRECT_ROUTING) {
@@ -585,6 +643,19 @@ static struct domain_device *sas_ex_disc
 	child = kzalloc(sizeof(*child), GFP_KERNEL);
 	if (!child)
 		return NULL;
+	switch (phy->attached_dev_type) {
+	case EDGE_DEV:
+		rphy = sas_expander_alloc(phy->phy, SAS_EDGE_EXPANDER_DEVICE);
+		break;
+	case FANOUT_DEV:
+		rphy = sas_expander_alloc(phy->phy, SAS_FANOUT_EXPANDER_DEVICE);
+		break;
+	default:
+		rphy = NULL;	/* shut gcc up */
+		BUG();
+	}
+	child->rphy = rphy;
+	edev = rphy_to_expander_device(rphy);
 	child->dev_type = phy->attached_dev_type;
 	child->parent = parent;
 	child->port = parent->port;
@@ -593,16 +664,15 @@ static struct domain_device *sas_ex_disc
 	memcpy(child->sas_addr, phy->attached_sas_addr, SAS_ADDR_SIZE);
 	sas_hash_addr(child->hashed_sas_addr, child->sas_addr);
 	sas_ex_get_linkrate(parent, child, phy);
-	child->ex_dev.level = parent_ex->level + 1;
+	edev->level = parent_ex->level + 1;
 	parent->port->disc.max_level = max(parent->port->disc.max_level,
-					   child->ex_dev.level);
+					   edev->level);
 	sas_init_dev(child);
 	res = sas_discover_expander(child);
 	if (res) {
 		kfree(child);
 		return NULL;
 	}
-	list_add_tail(&child->siblings, &parent_ex->children);
 	return child;
 }
 
@@ -1248,7 +1318,8 @@ static int sas_ex_level_discovery(struct
 	list_for_each_entry(dev, &port->dev_list, dev_list_node) {
 		if (dev->dev_type == EDGE_DEV ||
 		    dev->dev_type == FANOUT_DEV) {
-			struct expander_device *ex = &dev->ex_dev;
+			struct sas_expander_device *ex =
+				rphy_to_expander_device(dev->rphy);
 
 			if (level == ex->level)
 				res = sas_ex_discover_devices(dev, -1);
@@ -1275,8 +1346,11 @@ static int sas_ex_bfs_disc(struct sas_po
 int sas_discover_root_expander(struct domain_device *dev)
 {
 	int res;
+	struct sas_expander_device *ex = rphy_to_expander_device(dev->rphy);
+
+	sas_rphy_add(dev->rphy);
 
-	dev->ex_dev.level = dev->port->disc.max_level; /* 0 */
+	ex->level = dev->port->disc.max_level; /* 0 */
 	res = sas_discover_expander(dev);
 	if (!res)
 		sas_ex_bfs_disc(dev->port);
@@ -1482,7 +1556,8 @@ static int sas_discover_bfs_by_root_leve
 	list_for_each_entry(child, &ex_root->children, siblings) {
 		if (child->dev_type == EDGE_DEV ||
 		    child->dev_type == FANOUT_DEV) {
-			struct expander_device *ex = &child->ex_dev;
+			struct sas_expander_device *ex =
+				rphy_to_expander_device(child->rphy);
 
 			if (level > ex->level)
 				res = sas_discover_bfs_by_root_level(child,
@@ -1497,7 +1572,8 @@ static int sas_discover_bfs_by_root_leve
 static int sas_discover_bfs_by_root(struct domain_device *dev)
 {
 	int res;
-	int level = dev->ex_dev.level+1;
+	struct sas_expander_device *ex = rphy_to_expander_device(dev->rphy);
+	int level = ex->level+1;
 
 	res = sas_ex_discover_devices(dev, -1);
 	if (res)
diff --git a/include/scsi/sas/sas_expander.h b/include/scsi/sas/sas_expander.h
index bd00e1c..e83b41c 100644
--- a/include/scsi/sas/sas_expander.h
+++ b/include/scsi/sas/sas_expander.h
@@ -70,13 +70,13 @@ struct ex_phy {
 	u8   virtual:1;
 
 	int  last_da_index;
+
+	struct sas_phy *phy;
 };
 
 struct expander_device {
 	struct list_head children;
 
-	int    level;
-
 	u16    ex_change_count;
 	u16    max_route_indexes;
 	u8     num_phys;
@@ -84,20 +84,7 @@ struct expander_device {
 	u8     conf_route_table:1;
 	u8     enclosure_logical_id[8];
 
-	char   vendor_id[8+1];
-	char   product_id[16+1];
-	char   product_rev[4+1];
-	char   component_vendor_id[8+1];
-	u16    component_id;
-	u8     component_revision_id;
-
 	struct ex_phy *ex_phy;
-
-	struct bin_attribute smp_bin_attr;
-	void *smp_req;
-	int   smp_req_size;
-	int   smp_portal_pid;
-	struct semaphore smp_sema;
 };
 
 int  sas_discover_root_expander(struct domain_device *dev);



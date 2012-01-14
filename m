From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH v5 7/7] libsas: let libata recover links that fail to
 transmit initial sig-fis
Date: Sat, 14 Jan 2012 10:10:55 -0800
Message-ID: <20120114181048.25887.56612.stgit@localhost6.localdomain6>
References: <20120114180904.25887.75601.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50462 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902Ab2ANSK4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Jan 2012 13:10:56 -0500
In-Reply-To: <20120114180904.25887.75601.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Xiangliang Yu <yuxiangl@marvell.com>, linux-ide@vger.kernel.org, Luben Tuikov <ltuikov@yahoo.com>, Jack Wang <jack_wang@usish.com>

libsas fails to discover all sata devices in the domain.  If a device fails
negotiation and does not transmit a signature fis the link needs recovery.
libata already understands how to manage slow to come up links, so treat these
conditions as ata device attach events for the purposes of creating an
ata_port.  This allows libata to manage retrying link bring up.

Cc: Jack Wang <jack_wang@usish.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_ata.c      |   71 +++++++++++++++++++-
 drivers/scsi/libsas/sas_discover.c |    1 
 drivers/scsi/libsas/sas_expander.c |  125 ++++++++++++++++--------------------
 drivers/scsi/libsas/sas_internal.h |    6 +-
 include/scsi/sas.h                 |    4 +
 include/scsi/sas_ata.h             |    8 ++
 6 files changed, 136 insertions(+), 79 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 0ee6831..d14af22 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -278,26 +278,84 @@ static struct sas_internal *dev_to_sas_internal(struct domain_device *dev)
 	return to_sas_internal(dev->port->ha->core.shost->transportt);
 }
 
+static void sas_get_ata_command_set(struct domain_device *dev);
+
+int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy)
+{
+	if (phy->attached_tproto & SAS_PROTOCOL_STP)
+		dev->tproto = phy->attached_tproto;
+	if (phy->attached_sata_dev)
+		dev->tproto |= SATA_DEV;
+
+	if (phy->attached_dev_type == SATA_PENDING)
+		dev->dev_type = SATA_PENDING;
+	else {
+		int res;
+
+		dev->dev_type = SATA_DEV;
+		res = sas_get_report_phy_sata(dev->parent, phy->phy_id,
+					      &dev->sata_dev.rps_resp);
+		if (res) {
+			SAS_DPRINTK("report phy sata to %016llx:0x%x returned "
+				    "0x%x\n", SAS_ADDR(dev->parent->sas_addr),
+				    phy->phy_id, res);
+			return res;
+		}
+		memcpy(dev->frame_rcvd, &dev->sata_dev.rps_resp.rps.fis,
+		       sizeof(struct dev_to_host_fis));
+		/* TODO switch to ata_dev_classify() */
+		sas_get_ata_command_set(dev);
+	}
+	return 0;
+}
+
+static int sas_ata_clear_pending(struct domain_device *dev, struct ex_phy *phy)
+{
+	int res;
+
+	/* we weren't pending, so successfully end the reset sequence now */
+	if (dev->dev_type != SATA_PENDING)
+		return 1;
+
+	/* hmmm, if this succeeds do we need to repost the domain_device to the
+	 * lldd so it can pick up new parameters?
+	 */
+	res = sas_get_ata_info(dev, phy);
+	if (res)
+		return 0; /* retry */
+	else
+		return 1;
+}
+
 static int smp_ata_check_ready(struct ata_link *link)
 {
 	int res;
-	u8 addr[8];
 	struct ata_port *ap = link->ap;
 	struct domain_device *dev = ap->private_data;
 	struct domain_device *ex_dev = dev->parent;
 	struct sas_phy *phy = sas_get_local_phy(dev);
+	struct ex_phy *ex_phy = &ex_dev->ex_dev.ex_phy[phy->number];
 
-	res = sas_get_phy_attached_sas_addr(ex_dev, phy->number, addr);
+	res = sas_ex_phy_discover(ex_dev, phy->number);
 	sas_put_local_phy(phy);
+
 	/* break the wait early if the expander is unreachable,
 	 * otherwise keep polling
 	 */
 	if (res == -ECOMM)
 		return res;
-	if (res != SMP_RESP_FUNC_ACC || SAS_ADDR(addr) == 0)
+	if (res != SMP_RESP_FUNC_ACC)
 		return 0;
-	else
-		return 1;
+
+	switch (ex_phy->attached_dev_type) {
+	case SATA_PENDING:
+		return 0;
+	case SAS_END_DEV:
+		if (ex_phy->attached_sata_dev)
+			return sas_ata_clear_pending(dev, ex_phy);
+	default:
+		return -ENODEV;
+	}
 }
 
 static int local_ata_check_ready(struct ata_link *link)
@@ -562,6 +620,9 @@ static void sas_get_ata_command_set(struct domain_device *dev)
 	struct dev_to_host_fis *fis =
 		(struct dev_to_host_fis *) dev->frame_rcvd;
 
+	if (dev->dev_type == SATA_PENDING)
+		return;
+
 	if ((fis->sector_count == 1 && /* ATA */
 	     fis->lbal         == 1 &&
 	     fis->lbam         == 0 &&
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index c6681b4..dc8baef 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -48,6 +48,7 @@ void sas_init_dev(struct domain_device *dev)
         case SATA_DEV:
         case SATA_PM:
         case SATA_PM_PORT:
+	case SATA_PENDING:
                 INIT_LIST_HEAD(&dev->sata_dev.children);
                 break;
         default:
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 68a80a0..18aef30 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -166,17 +166,15 @@ static inline void *alloc_smp_resp(int size)
 	return kzalloc(size, GFP_KERNEL);
 }
 
-/* ---------- Expander configuration ---------- */
-
-static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
-			   void *disc_resp)
+static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 {
+	struct smp_resp *resp = rsp;
+	struct discover_resp *dr = &resp->disc;
 	struct expander_device *ex = &dev->ex_dev;
 	struct ex_phy *phy = &ex->ex_phy[phy_id];
-	struct smp_resp *resp = disc_resp;
-	struct discover_resp *dr = &resp->disc;
 	struct sas_rphy *rphy = dev->rphy;
-	int rediscover = (phy->phy != NULL);
+	int rediscover = !!phy->phy;
+	char *type;
 
 	if (!rediscover) {
 		phy->phy = sas_phy_alloc(&rphy->dev, phy_id);
@@ -197,8 +195,14 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
 		break;
 	}
 
+	/* This is detecting a failure to transmit initial dev to host
+	 * FIS as described in section J.5 of sas-2 r16
+	 */
+	if (dr->attached_dev_type == NO_DEVICE && dr->attached_sata_dev)
+		phy->attached_dev_type = SATA_PENDING;
+	else
+		phy->attached_dev_type = dr->attached_dev_type;
 	phy->phy_id = phy_id;
-	phy->attached_dev_type = dr->attached_dev_type;
 	phy->linkrate = dr->linkrate;
 	phy->attached_sata_host = dr->attached_sata_host;
 	phy->attached_sata_dev  = dr->attached_sata_dev;
@@ -213,7 +217,7 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
 	phy->last_da_index = -1;
 
 	phy->phy->identify.sas_address = SAS_ADDR(phy->attached_sas_addr);
-	phy->phy->identify.device_type = phy->attached_dev_type;
+	phy->phy->identify.device_type = dr->attached_dev_type;
 	phy->phy->identify.initiator_port_protocols = phy->attached_iproto;
 	phy->phy->identify.target_port_protocols = phy->attached_tproto;
 	phy->phy->identify.phy_identifier = phy_id;
@@ -229,14 +233,33 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
 			return;
 		}
 
-	SAS_DPRINTK("ex %016llx phy%02d:%c attached: %016llx\n",
+	switch (phy->attached_dev_type) {
+	case SATA_PENDING:
+		type = "stp pending";
+		break;
+	case NO_DEVICE:
+		type = "no device";
+		break;
+	case SAS_END_DEV:
+		if (dr->attached_sata_dev)
+			type = "stp";
+		else
+			type = "ssp";
+		break;
+	case EDGE_DEV:
+	case FANOUT_DEV:
+		type = "smp";
+		break;
+	default:
+		type = "unknown";
+	}
+
+	SAS_DPRINTK("ex %016llx phy%02d:%c attached: %016llx (%s)\n",
 		    SAS_ADDR(dev->sas_addr), phy->phy_id,
 		    phy->routing_attr == TABLE_ROUTING ? 'T' :
 		    phy->routing_attr == DIRECT_ROUTING ? 'D' :
 		    phy->routing_attr == SUBTRACTIVE_ROUTING ? 'S' : '?',
-		    SAS_ADDR(phy->attached_sas_addr));
-
-	return;
+		    SAS_ADDR(phy->attached_sas_addr), type);
 }
 
 /* check if we have an existing attached ata device on this expander phy */
@@ -267,50 +290,25 @@ struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id)
 static int sas_ex_phy_discover_helper(struct domain_device *dev, u8 *disc_req,
 				      u8 *disc_resp, int single)
 {
-	struct domain_device *ata_dev = sas_ex_to_ata(dev, single);
-	int i, res;
+	struct discover_resp *dr;
+	int res;
 
 	disc_req[9] = single;
-	for (i = 1 ; i < 3; i++) {
-		struct discover_resp *dr;
 
-		res = smp_execute_task(dev, disc_req, DISCOVER_REQ_SIZE,
-				       disc_resp, DISCOVER_RESP_SIZE);
-		if (res)
-			return res;
-		dr = &((struct smp_resp *)disc_resp)->disc;
-		if (memcmp(dev->sas_addr, dr->attached_sas_addr,
-			  SAS_ADDR_SIZE) == 0) {
-			sas_printk("Found loopback topology, just ignore it!\n");
-			return 0;
-		}
-
-		/* This is detecting a failure to transmit initial
-		 * dev to host FIS as described in section J.5 of
-		 * sas-2 r16
-		 */
-		if (!(dr->attached_dev_type == 0 &&
-		      dr->attached_sata_dev))
-			break;
-
-		/* In order to generate the dev to host FIS, we send a
-		 * link reset to the expander port.  If a device was
-		 * previously detected on this port we ask libata to
-		 * manage the reset and link recovery.
-		 */
-		if (ata_dev) {
-			sas_ata_schedule_reset(ata_dev);
-			break;
-		}
-		sas_smp_phy_control(dev, single, PHY_FUNC_LINK_RESET, NULL);
-		/* Wait for the reset to trigger the negotiation */
-		msleep(500);
+	res = smp_execute_task(dev, disc_req, DISCOVER_REQ_SIZE,
+			       disc_resp, DISCOVER_RESP_SIZE);
+	if (res)
+		return res;
+	dr = &((struct smp_resp *)disc_resp)->disc;
+	if (memcmp(dev->sas_addr, dr->attached_sas_addr, SAS_ADDR_SIZE) == 0) {
+		sas_printk("Found loopback topology, just ignore it!\n");
+		return 0;
 	}
 	sas_set_ex_phy(dev, single, disc_resp);
 	return 0;
 }
 
-static int sas_ex_phy_discover(struct domain_device *dev, int single)
+int sas_ex_phy_discover(struct domain_device *dev, int single)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	int  res = 0;
@@ -615,9 +613,8 @@ int sas_smp_get_phy_events(struct sas_phy *phy)
 #define RPS_REQ_SIZE  16
 #define RPS_RESP_SIZE 60
 
-static int sas_get_report_phy_sata(struct domain_device *dev,
-					  int phy_id,
-					  struct smp_resp *rps_resp)
+int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
+			    struct smp_resp *rps_resp)
 {
 	int res;
 	u8 *rps_req = alloc_smp_req(RPS_REQ_SIZE);
@@ -727,21 +724,9 @@ static struct domain_device *sas_ex_discover_end_dev(
 
 #ifdef CONFIG_SCSI_SAS_ATA
 	if ((phy->attached_tproto & SAS_PROTOCOL_STP) || phy->attached_sata_dev) {
-		child->dev_type = SATA_DEV;
-		if (phy->attached_tproto & SAS_PROTOCOL_STP)
-			child->tproto = phy->attached_tproto;
-		if (phy->attached_sata_dev)
-			child->tproto |= SATA_DEV;
-		res = sas_get_report_phy_sata(parent, phy_id,
-					      &child->sata_dev.rps_resp);
-		if (res) {
-			SAS_DPRINTK("report phy sata to %016llx:0x%x returned "
-				    "0x%x\n", SAS_ADDR(parent->sas_addr),
-				    phy_id, res);
+		res = sas_get_ata_info(child, phy);
+		if (res)
 			goto out_free;
-		}
-		memcpy(child->frame_rcvd, &child->sata_dev.rps_resp.rps.fis,
-		       sizeof(struct dev_to_host_fis));
 
 		rphy = sas_end_device_alloc(phy->port);
 		if (unlikely(!rphy))
@@ -956,7 +941,8 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
 
 	if (ex_phy->attached_dev_type != SAS_END_DEV &&
 	    ex_phy->attached_dev_type != FANOUT_DEV &&
-	    ex_phy->attached_dev_type != EDGE_DEV) {
+	    ex_phy->attached_dev_type != EDGE_DEV &&
+	    ex_phy->attached_dev_type != SATA_PENDING) {
 		SAS_DPRINTK("unknown device type(0x%x) attached to ex %016llx "
 			    "phy 0x%x\n", ex_phy->attached_dev_type,
 			    SAS_ADDR(dev->sas_addr),
@@ -982,6 +968,7 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
 
 	switch (ex_phy->attached_dev_type) {
 	case SAS_END_DEV:
+	case SATA_PENDING:
 		child = sas_ex_discover_end_dev(dev, phy_id);
 		break;
 	case FANOUT_DEV:
@@ -1658,8 +1645,8 @@ static int sas_get_phy_change_count(struct domain_device *dev,
 	return res;
 }
 
-int sas_get_phy_attached_sas_addr(struct domain_device *dev, int phy_id,
-				  u8 *attached_sas_addr)
+static int sas_get_phy_attached_sas_addr(struct domain_device *dev, int phy_id,
+					 u8 *attached_sas_addr)
 {
 	int res;
 	struct smp_resp *disc_resp;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 4157f6e..a37a5bd 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -90,8 +90,9 @@ int sas_smp_get_phy_events(struct sas_phy *phy);
 void sas_device_set_phy(struct domain_device *dev, struct sas_port *port);
 struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
 struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
-int sas_get_phy_attached_sas_addr(struct domain_device *dev, int phy_id,
-				  u8 *attached_sas_addr);
+int sas_ex_phy_discover(struct domain_device *dev, int single);
+int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
+			    struct smp_resp *rps_resp);
 int sas_try_ata_reset(struct asd_sas_phy *phy);
 void sas_hae_reset(struct work_struct *work);
 
@@ -121,6 +122,7 @@ static inline void sas_fill_in_rphy(struct domain_device *dev,
 	case SATA_DEV:
 		/* FIXME: need sata device type */
 	case SAS_END_DEV:
+	case SATA_PENDING:
 		rphy->identify.device_type = SAS_END_DEVICE;
 		break;
 	case EDGE_DEV:
diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index 3673d68..a577a83 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -89,8 +89,7 @@ enum sas_oob_mode {
 	SAS_OOB_MODE
 };
 
-/* See sas_discover.c if you plan on changing these.
- */
+/* See sas_discover.c if you plan on changing these */
 enum sas_dev_type {
 	NO_DEVICE   = 0,	  /* protocol */
 	SAS_END_DEV = 1,	  /* protocol */
@@ -100,6 +99,7 @@ enum sas_dev_type {
 	SATA_DEV    = 5,
 	SATA_PM     = 7,
 	SATA_PM_PORT= 8,
+	SATA_PENDING  = 9,
 };
 
 enum sas_protocol {
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index cb724fd..0ca2f8a 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -33,9 +33,10 @@
 static inline int dev_is_sata(struct domain_device *dev)
 {
 	return dev->dev_type == SATA_DEV || dev->dev_type == SATA_PM ||
-	       dev->dev_type == SATA_PM_PORT;
+	       dev->dev_type == SATA_PM_PORT || dev->dev_type == SATA_PENDING;
 }
 
+int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy);
 int sas_ata_init_host_and_port(struct domain_device *found_dev,
 			       struct scsi_target *starget);
 
@@ -82,6 +83,11 @@ static inline void sas_ata_schedule_reset(struct domain_device *dev)
 static inline void sas_ata_wait_eh(struct domain_device *dev)
 {
 }
+
+static inline int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy)
+{
+	return 0;
+}
 #endif
 
 #endif /* _SAS_ATA_H_ */


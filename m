From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.3-rc5
Date: Mon, 30 Apr 2012 09:21:28 +0100
Message-ID: <1335774088.2950.3.camel@dabdike.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58426 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861Ab2D3IVe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Apr 2012 04:21:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a set of SAS and SATA fixes; there are one or two longstanding
bug fixes, but most of this is regression fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is

Dan Williams (7):
      Revert "[SCSI] libsas: fix sas port naming"
      libsas: fix false positive 'device attached' conditions
      libsas, libata: fix start of life for a sas ata_port
      libsas: fix ata_eh clobbering ex_phys via smp_ata_check_ready
      libsas: unify domain_device sas_rphy lifetimes
      libsas: fix sas_get_port_device regression
      libsas: introduce sas_work to fix sas_drain_work vs sas_queue_work

Lin Ming (2):
      libata: Pass correct DMA device to scsi host
      scsi_lib: use correct DMA device in __scsi_alloc_queue

Thomas Jackson (1):
      libsas: fix sas_find_bcast_phy() in the presence of 'vacant' phys

Vasu Dev (1):
      libfc: update mfs boundry checking

And the diffstat

 drivers/ata/libata-scsi.c          |   38 ++++++++++++----------
 drivers/scsi/ipr.c                 |    6 +++-
 drivers/scsi/libfc/fc_lport.c      |   12 ++++---
 drivers/scsi/libsas/sas_ata.c      |   33 ++++++-------------
 drivers/scsi/libsas/sas_discover.c |   61 +++++++++++++++++++++---------------
 drivers/scsi/libsas/sas_event.c    |   24 +++++++-------
 drivers/scsi/libsas/sas_expander.c |   56 ++++++++++++++++++++++++++-------
 drivers/scsi/libsas/sas_init.c     |   11 +++----
 drivers/scsi/libsas/sas_internal.h |    6 ++--
 drivers/scsi/libsas/sas_phy.c      |   21 +++++--------
 drivers/scsi/libsas/sas_port.c     |   17 ++++------
 drivers/scsi/scsi_lib.c            |    2 +-
 include/linux/libata.h             |    3 +-
 include/scsi/libsas.h              |   40 ++++++++++++++++++++---
 include/scsi/sas_ata.h             |    4 +--
 15 files changed, 198 insertions(+), 136 deletions(-)

The full diff is below.

James

---

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 93dabdc..2222635 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3399,7 +3399,8 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		 */
 		shost->max_host_blocked = 1;
 
-		rc = scsi_add_host(ap->scsi_host, &ap->tdev);
+		rc = scsi_add_host_with_dma(ap->scsi_host,
+						&ap->tdev, ap->host->dev);
 		if (rc)
 			goto err_add;
 	}
@@ -3838,18 +3839,25 @@ void ata_sas_port_stop(struct ata_port *ap)
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_stop);
 
-int ata_sas_async_port_init(struct ata_port *ap)
+/**
+ * ata_sas_async_probe - simply schedule probing and return
+ * @ap: Port to probe
+ *
+ * For batch scheduling of probe for sas attached ata devices, assumes
+ * the port has already been through ata_sas_port_init()
+ */
+void ata_sas_async_probe(struct ata_port *ap)
 {
-	int rc = ap->ops->port_start(ap);
-
-	if (!rc) {
-		ap->print_id = atomic_inc_return(&ata_print_id);
-		__ata_port_probe(ap);
-	}
+	__ata_port_probe(ap);
+}
+EXPORT_SYMBOL_GPL(ata_sas_async_probe);
 
-	return rc;
+int ata_sas_sync_probe(struct ata_port *ap)
+{
+	return ata_port_probe(ap);
 }
-EXPORT_SYMBOL_GPL(ata_sas_async_port_init);
+EXPORT_SYMBOL_GPL(ata_sas_sync_probe);
+
 
 /**
  *	ata_sas_port_init - Initialize a SATA device
@@ -3866,12 +3874,10 @@ int ata_sas_port_init(struct ata_port *ap)
 {
 	int rc = ap->ops->port_start(ap);
 
-	if (!rc) {
-		ap->print_id = atomic_inc_return(&ata_print_id);
-		rc = ata_port_probe(ap);
-	}
-
-	return rc;
+	if (rc)
+		return rc;
+	ap->print_id = atomic_inc_return(&ata_print_id);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_init);
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index e002cd4..467dc38 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4549,8 +4549,12 @@ static int ipr_ata_slave_alloc(struct scsi_device *sdev)
 	ENTER;
 	if (sdev->sdev_target)
 		sata_port = sdev->sdev_target->hostdata;
-	if (sata_port)
+	if (sata_port) {
 		rc = ata_sas_port_init(sata_port->ap);
+		if (rc == 0)
+			rc = ata_sas_sync_probe(sata_port->ap);
+	}
+
 	if (rc)
 		ipr_slave_destroy(sdev);
 
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index ef9560d..cc83b66 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1742,17 +1742,19 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mfs = ntohs(flp->fl_csp.sp_bb_data) &
 		FC_SP_BB_DATA_MASK;
-	if (mfs >= FC_SP_MIN_MAX_PAYLOAD &&
-	    mfs <= lport->mfs) {
-		lport->mfs = mfs;
-		fc_host_maxframe_size(lport->host) = mfs;
-	} else {
+
+	if (mfs < FC_SP_MIN_MAX_PAYLOAD || mfs > FC_SP_MAX_MAX_PAYLOAD) {
 		FC_LPORT_DBG(lport, "FLOGI bad mfs:%hu response, "
 			     "lport->mfs:%hu\n", mfs, lport->mfs);
 		fc_lport_error(lport, fp);
 		goto err;
 	}
 
+	if (mfs <= lport->mfs) {
+		lport->mfs = mfs;
+		fc_host_maxframe_size(lport->host) = mfs;
+	}
+
 	csp_flags = ntohs(flp->fl_csp.sp_features);
 	r_a_tov = ntohl(flp->fl_csp.sp_r_a_tov);
 	e_d_tov = ntohl(flp->fl_csp.sp_e_d_tov);
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index bc0cecc..441d88a 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -546,11 +546,12 @@ static struct ata_port_info sata_port_info = {
 	.port_ops = &sas_sata_ops
 };
 
-int sas_ata_init_host_and_port(struct domain_device *found_dev)
+int sas_ata_init(struct domain_device *found_dev)
 {
 	struct sas_ha_struct *ha = found_dev->port->ha;
 	struct Scsi_Host *shost = ha->core.shost;
 	struct ata_port *ap;
+	int rc;
 
 	ata_host_init(&found_dev->sata_dev.ata_host,
 		      ha->dev,
@@ -567,8 +568,11 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev)
 	ap->private_data = found_dev;
 	ap->cbl = ATA_CBL_SATA;
 	ap->scsi_host = shost;
-	/* publish initialized ata port */
-	smp_wmb();
+	rc = ata_sas_port_init(ap);
+	if (rc) {
+		ata_sas_port_destroy(ap);
+		return rc;
+	}
 	found_dev->sata_dev.ap = ap;
 
 	return 0;
@@ -648,18 +652,13 @@ static void sas_get_ata_command_set(struct domain_device *dev)
 void sas_probe_sata(struct asd_sas_port *port)
 {
 	struct domain_device *dev, *n;
-	int err;
 
 	mutex_lock(&port->ha->disco_mutex);
-	list_for_each_entry_safe(dev, n, &port->disco_list, disco_list_node) {
+	list_for_each_entry(dev, &port->disco_list, disco_list_node) {
 		if (!dev_is_sata(dev))
 			continue;
 
-		err = sas_ata_init_host_and_port(dev);
-		if (err)
-			sas_fail_probe(dev, __func__, err);
-		else
-			ata_sas_async_port_init(dev->sata_dev.ap);
+		ata_sas_async_probe(dev->sata_dev.ap);
 	}
 	mutex_unlock(&port->ha->disco_mutex);
 
@@ -718,18 +717,6 @@ static void async_sas_ata_eh(void *data, async_cookie_t cookie)
 	sas_put_device(dev);
 }
 
-static bool sas_ata_dev_eh_valid(struct domain_device *dev)
-{
-	struct ata_port *ap;
-
-	if (!dev_is_sata(dev))
-		return false;
-	ap = dev->sata_dev.ap;
-	/* consume fully initialized ata ports */
-	smp_rmb();
-	return !!ap;
-}
-
 void sas_ata_strategy_handler(struct Scsi_Host *shost)
 {
 	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
@@ -753,7 +740,7 @@ void sas_ata_strategy_handler(struct Scsi_Host *shost)
 
 		spin_lock(&port->dev_list_lock);
 		list_for_each_entry(dev, &port->dev_list, dev_list_node) {
-			if (!sas_ata_dev_eh_valid(dev))
+			if (!dev_is_sata(dev))
 				continue;
 			async_schedule_domain(async_sas_ata_eh, dev, &async);
 		}
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 3646796..629a086 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -72,6 +72,7 @@ static int sas_get_port_device(struct asd_sas_port *port)
 	struct asd_sas_phy *phy;
 	struct sas_rphy *rphy;
 	struct domain_device *dev;
+	int rc = -ENODEV;
 
 	dev = sas_alloc_device();
 	if (!dev)
@@ -110,9 +111,16 @@ static int sas_get_port_device(struct asd_sas_port *port)
 
 	sas_init_dev(dev);
 
+	dev->port = port;
 	switch (dev->dev_type) {
-	case SAS_END_DEV:
 	case SATA_DEV:
+		rc = sas_ata_init(dev);
+		if (rc) {
+			rphy = NULL;
+			break;
+		}
+		/* fall through */
+	case SAS_END_DEV:
 		rphy = sas_end_device_alloc(port->port);
 		break;
 	case EDGE_DEV:
@@ -131,19 +139,14 @@ static int sas_get_port_device(struct asd_sas_port *port)
 
 	if (!rphy) {
 		sas_put_device(dev);
-		return -ENODEV;
+		return rc;
 	}
 
-	spin_lock_irq(&port->phy_list_lock);
-	list_for_each_entry(phy, &port->phy_list, port_phy_el)
-		sas_phy_set_target(phy, dev);
-	spin_unlock_irq(&port->phy_list_lock);
 	rphy->identify.phy_identifier = phy->phy->identify.phy_identifier;
 	memcpy(dev->sas_addr, port->attached_sas_addr, SAS_ADDR_SIZE);
 	sas_fill_in_rphy(dev, rphy);
 	sas_hash_addr(dev->hashed_sas_addr, dev->sas_addr);
 	port->port_dev = dev;
-	dev->port = port;
 	dev->linkrate = port->linkrate;
 	dev->min_linkrate = port->linkrate;
 	dev->max_linkrate = port->linkrate;
@@ -155,6 +158,7 @@ static int sas_get_port_device(struct asd_sas_port *port)
 	sas_device_set_phy(dev, port->port);
 
 	dev->rphy = rphy;
+	get_device(&dev->rphy->dev);
 
 	if (dev_is_sata(dev) || dev->dev_type == SAS_END_DEV)
 		list_add_tail(&dev->disco_list_node, &port->disco_list);
@@ -164,6 +168,11 @@ static int sas_get_port_device(struct asd_sas_port *port)
 		spin_unlock_irq(&port->dev_list_lock);
 	}
 
+	spin_lock_irq(&port->phy_list_lock);
+	list_for_each_entry(phy, &port->phy_list, port_phy_el)
+		sas_phy_set_target(phy, dev);
+	spin_unlock_irq(&port->phy_list_lock);
+
 	return 0;
 }
 
@@ -205,8 +214,7 @@ void sas_notify_lldd_dev_gone(struct domain_device *dev)
 static void sas_probe_devices(struct work_struct *work)
 {
 	struct domain_device *dev, *n;
-	struct sas_discovery_event *ev =
-		container_of(work, struct sas_discovery_event, work);
+	struct sas_discovery_event *ev = to_sas_discovery_event(work);
 	struct asd_sas_port *port = ev->port;
 
 	clear_bit(DISCE_PROBE, &port->disc.pending);
@@ -255,6 +263,9 @@ void sas_free_device(struct kref *kref)
 {
 	struct domain_device *dev = container_of(kref, typeof(*dev), kref);
 
+	put_device(&dev->rphy->dev);
+	dev->rphy = NULL;
+
 	if (dev->parent)
 		sas_put_device(dev->parent);
 
@@ -291,8 +302,7 @@ static void sas_unregister_common_dev(struct asd_sas_port *port, struct domain_d
 static void sas_destruct_devices(struct work_struct *work)
 {
 	struct domain_device *dev, *n;
-	struct sas_discovery_event *ev =
-		container_of(work, struct sas_discovery_event, work);
+	struct sas_discovery_event *ev = to_sas_discovery_event(work);
 	struct asd_sas_port *port = ev->port;
 
 	clear_bit(DISCE_DESTRUCT, &port->disc.pending);
@@ -302,7 +312,6 @@ static void sas_destruct_devices(struct work_struct *work)
 
 		sas_remove_children(&dev->rphy->dev);
 		sas_rphy_delete(dev->rphy);
-		dev->rphy = NULL;
 		sas_unregister_common_dev(port, dev);
 	}
 }
@@ -314,11 +323,11 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 		/* this rphy never saw sas_rphy_add */
 		list_del_init(&dev->disco_list_node);
 		sas_rphy_free(dev->rphy);
-		dev->rphy = NULL;
 		sas_unregister_common_dev(port, dev);
+		return;
 	}
 
-	if (dev->rphy && !test_and_set_bit(SAS_DEV_DESTROY, &dev->state)) {
+	if (!test_and_set_bit(SAS_DEV_DESTROY, &dev->state)) {
 		sas_rphy_unlink(dev->rphy);
 		list_move_tail(&dev->disco_list_node, &port->destroy_list);
 		sas_discover_event(dev->port, DISCE_DESTRUCT);
@@ -377,8 +386,7 @@ static void sas_discover_domain(struct work_struct *work)
 {
 	struct domain_device *dev;
 	int error = 0;
-	struct sas_discovery_event *ev =
-		container_of(work, struct sas_discovery_event, work);
+	struct sas_discovery_event *ev = to_sas_discovery_event(work);
 	struct asd_sas_port *port = ev->port;
 
 	clear_bit(DISCE_DISCOVER_DOMAIN, &port->disc.pending);
@@ -419,8 +427,6 @@ static void sas_discover_domain(struct work_struct *work)
 
 	if (error) {
 		sas_rphy_free(dev->rphy);
-		dev->rphy = NULL;
-
 		list_del_init(&dev->disco_list_node);
 		spin_lock_irq(&port->dev_list_lock);
 		list_del_init(&dev->dev_list_node);
@@ -437,8 +443,7 @@ static void sas_discover_domain(struct work_struct *work)
 static void sas_revalidate_domain(struct work_struct *work)
 {
 	int res = 0;
-	struct sas_discovery_event *ev =
-		container_of(work, struct sas_discovery_event, work);
+	struct sas_discovery_event *ev = to_sas_discovery_event(work);
 	struct asd_sas_port *port = ev->port;
 	struct sas_ha_struct *ha = port->ha;
 
@@ -466,21 +471,25 @@ static void sas_revalidate_domain(struct work_struct *work)
 
 /* ---------- Events ---------- */
 
-static void sas_chain_work(struct sas_ha_struct *ha, struct work_struct *work)
+static void sas_chain_work(struct sas_ha_struct *ha, struct sas_work *sw)
 {
-	/* chained work is not subject to SA_HA_DRAINING or SAS_HA_REGISTERED */
-	scsi_queue_work(ha->core.shost, work);
+	/* chained work is not subject to SA_HA_DRAINING or
+	 * SAS_HA_REGISTERED, because it is either submitted in the
+	 * workqueue, or known to be submitted from a context that is
+	 * not racing against draining
+	 */
+	scsi_queue_work(ha->core.shost, &sw->work);
 }
 
 static void sas_chain_event(int event, unsigned long *pending,
-			    struct work_struct *work,
+			    struct sas_work *sw,
 			    struct sas_ha_struct *ha)
 {
 	if (!test_and_set_bit(event, pending)) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&ha->state_lock, flags);
-		sas_chain_work(ha, work);
+		sas_chain_work(ha, sw);
 		spin_unlock_irqrestore(&ha->state_lock, flags);
 	}
 }
@@ -519,7 +528,7 @@ void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *port)
 
 	disc->pending = 0;
 	for (i = 0; i < DISC_NUM_EVENTS; i++) {
-		INIT_WORK(&disc->disc_work[i].work, sas_event_fns[i]);
+		INIT_SAS_WORK(&disc->disc_work[i].work, sas_event_fns[i]);
 		disc->disc_work[i].port = port;
 	}
 }
diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index 16639bb..4e4292d 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -27,19 +27,21 @@
 #include "sas_internal.h"
 #include "sas_dump.h"
 
-void sas_queue_work(struct sas_ha_struct *ha, struct work_struct *work)
+void sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw)
 {
 	if (!test_bit(SAS_HA_REGISTERED, &ha->state))
 		return;
 
-	if (test_bit(SAS_HA_DRAINING, &ha->state))
-		list_add(&work->entry, &ha->defer_q);
-	else
-		scsi_queue_work(ha->core.shost, work);
+	if (test_bit(SAS_HA_DRAINING, &ha->state)) {
+		/* add it to the defer list, if not already pending */
+		if (list_empty(&sw->drain_node))
+			list_add(&sw->drain_node, &ha->defer_q);
+	} else
+		scsi_queue_work(ha->core.shost, &sw->work);
 }
 
 static void sas_queue_event(int event, unsigned long *pending,
-			    struct work_struct *work,
+			    struct sas_work *work,
 			    struct sas_ha_struct *ha)
 {
 	if (!test_and_set_bit(event, pending)) {
@@ -55,7 +57,7 @@ static void sas_queue_event(int event, unsigned long *pending,
 void __sas_drain_work(struct sas_ha_struct *ha)
 {
 	struct workqueue_struct *wq = ha->core.shost->work_q;
-	struct work_struct *w, *_w;
+	struct sas_work *sw, *_sw;
 
 	set_bit(SAS_HA_DRAINING, &ha->state);
 	/* flush submitters */
@@ -66,9 +68,9 @@ void __sas_drain_work(struct sas_ha_struct *ha)
 
 	spin_lock_irq(&ha->state_lock);
 	clear_bit(SAS_HA_DRAINING, &ha->state);
-	list_for_each_entry_safe(w, _w, &ha->defer_q, entry) {
-		list_del_init(&w->entry);
-		sas_queue_work(ha, w);
+	list_for_each_entry_safe(sw, _sw, &ha->defer_q, drain_node) {
+		list_del_init(&sw->drain_node);
+		sas_queue_work(ha, sw);
 	}
 	spin_unlock_irq(&ha->state_lock);
 }
@@ -151,7 +153,7 @@ int sas_init_events(struct sas_ha_struct *sas_ha)
 	int i;
 
 	for (i = 0; i < HA_NUM_EVENTS; i++) {
-		INIT_WORK(&sas_ha->ha_events[i].work, sas_ha_event_fns[i]);
+		INIT_SAS_WORK(&sas_ha->ha_events[i].work, sas_ha_event_fns[i]);
 		sas_ha->ha_events[i].ha = sas_ha;
 	}
 
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 05acd9e..caa0525 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -202,6 +202,7 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	u8 sas_addr[SAS_ADDR_SIZE];
 	struct smp_resp *resp = rsp;
 	struct discover_resp *dr = &resp->disc;
+	struct sas_ha_struct *ha = dev->port->ha;
 	struct expander_device *ex = &dev->ex_dev;
 	struct ex_phy *phy = &ex->ex_phy[phy_id];
 	struct sas_rphy *rphy = dev->rphy;
@@ -209,6 +210,8 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	char *type;
 
 	if (new_phy) {
+		if (WARN_ON_ONCE(test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state)))
+			return;
 		phy->phy = sas_phy_alloc(&rphy->dev, phy_id);
 
 		/* FIXME: error_handling */
@@ -233,6 +236,8 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	memcpy(sas_addr, phy->attached_sas_addr, SAS_ADDR_SIZE);
 
 	phy->attached_dev_type = to_dev_type(dr);
+	if (test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state))
+		goto out;
 	phy->phy_id = phy_id;
 	phy->linkrate = dr->linkrate;
 	phy->attached_sata_host = dr->attached_sata_host;
@@ -240,7 +245,14 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	phy->attached_sata_ps   = dr->attached_sata_ps;
 	phy->attached_iproto = dr->iproto << 1;
 	phy->attached_tproto = dr->tproto << 1;
-	memcpy(phy->attached_sas_addr, dr->attached_sas_addr, SAS_ADDR_SIZE);
+	/* help some expanders that fail to zero sas_address in the 'no
+	 * device' case
+	 */
+	if (phy->attached_dev_type == NO_DEVICE ||
+	    phy->linkrate < SAS_LINK_RATE_1_5_GBPS)
+		memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
+	else
+		memcpy(phy->attached_sas_addr, dr->attached_sas_addr, SAS_ADDR_SIZE);
 	phy->attached_phy_id = dr->attached_phy_id;
 	phy->phy_change_count = dr->change_count;
 	phy->routing_attr = dr->routing_attr;
@@ -266,6 +278,7 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 			return;
 		}
 
+ out:
 	switch (phy->attached_dev_type) {
 	case SATA_PENDING:
 		type = "stp pending";
@@ -304,7 +317,15 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	else
 		return;
 
-	SAS_DPRINTK("ex %016llx phy%02d:%c:%X attached: %016llx (%s)\n",
+	/* if the attached device type changed and ata_eh is active,
+	 * make sure we run revalidation when eh completes (see:
+	 * sas_enable_revalidation)
+	 */
+	if (test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state))
+		set_bit(DISCE_REVALIDATE_DOMAIN, &dev->port->disc.pending);
+
+	SAS_DPRINTK("%sex %016llx phy%02d:%c:%X attached: %016llx (%s)\n",
+		    test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state) ? "ata: " : "",
 		    SAS_ADDR(dev->sas_addr), phy->phy_id,
 		    sas_route_char(dev, phy), phy->linkrate,
 		    SAS_ADDR(phy->attached_sas_addr), type);
@@ -776,13 +797,16 @@ static struct domain_device *sas_ex_discover_end_dev(
 		if (res)
 			goto out_free;
 
+		sas_init_dev(child);
+		res = sas_ata_init(child);
+		if (res)
+			goto out_free;
 		rphy = sas_end_device_alloc(phy->port);
-		if (unlikely(!rphy))
+		if (!rphy)
 			goto out_free;
 
-		sas_init_dev(child);
-
 		child->rphy = rphy;
+		get_device(&rphy->dev);
 
 		list_add_tail(&child->disco_list_node, &parent->port->disco_list);
 
@@ -806,6 +830,7 @@ static struct domain_device *sas_ex_discover_end_dev(
 		sas_init_dev(child);
 
 		child->rphy = rphy;
+		get_device(&rphy->dev);
 		sas_fill_in_rphy(child, rphy);
 
 		list_add_tail(&child->disco_list_node, &parent->port->disco_list);
@@ -830,8 +855,6 @@ static struct domain_device *sas_ex_discover_end_dev(
 
  out_list_del:
 	sas_rphy_free(child->rphy);
-	child->rphy = NULL;
-
 	list_del(&child->disco_list_node);
 	spin_lock_irq(&parent->port->dev_list_lock);
 	list_del(&child->dev_list_node);
@@ -911,6 +934,7 @@ static struct domain_device *sas_ex_discover_expander(
 	}
 	port = parent->port;
 	child->rphy = rphy;
+	get_device(&rphy->dev);
 	edev = rphy_to_expander_device(rphy);
 	child->dev_type = phy->attached_dev_type;
 	kref_get(&parent->kref);
@@ -934,6 +958,7 @@ static struct domain_device *sas_ex_discover_expander(
 
 	res = sas_discover_expander(child);
 	if (res) {
+		sas_rphy_delete(rphy);
 		spin_lock_irq(&parent->port->dev_list_lock);
 		list_del(&child->dev_list_node);
 		spin_unlock_irq(&parent->port->dev_list_lock);
@@ -1718,9 +1743,17 @@ static int sas_find_bcast_phy(struct domain_device *dev, int *phy_id,
 		int phy_change_count = 0;
 
 		res = sas_get_phy_change_count(dev, i, &phy_change_count);
-		if (res)
-			goto out;
-		else if (phy_change_count != ex->ex_phy[i].phy_change_count) {
+		switch (res) {
+		case SMP_RESP_PHY_VACANT:
+		case SMP_RESP_NO_PHY:
+			continue;
+		case SMP_RESP_FUNC_ACC:
+			break;
+		default:
+			return res;
+		}
+
+		if (phy_change_count != ex->ex_phy[i].phy_change_count) {
 			if (update)
 				ex->ex_phy[i].phy_change_count =
 					phy_change_count;
@@ -1728,8 +1761,7 @@ static int sas_find_bcast_phy(struct domain_device *dev, int *phy_id,
 			return 0;
 		}
 	}
-out:
-	return res;
+	return 0;
 }
 
 static int sas_get_ex_change_count(struct domain_device *dev, int *ecc)
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 120bff6..10cb5ae 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -94,8 +94,7 @@ void sas_hash_addr(u8 *hashed, const u8 *sas_addr)
 
 void sas_hae_reset(struct work_struct *work)
 {
-	struct sas_ha_event *ev =
-		container_of(work, struct sas_ha_event, work);
+	struct sas_ha_event *ev = to_sas_ha_event(work);
 	struct sas_ha_struct *ha = ev->ha;
 
 	clear_bit(HAE_RESET, &ha->pending);
@@ -369,14 +368,14 @@ static void sas_phy_release(struct sas_phy *phy)
 
 static void phy_reset_work(struct work_struct *work)
 {
-	struct sas_phy_data *d = container_of(work, typeof(*d), reset_work);
+	struct sas_phy_data *d = container_of(work, typeof(*d), reset_work.work);
 
 	d->reset_result = transport_sas_phy_reset(d->phy, d->hard_reset);
 }
 
 static void phy_enable_work(struct work_struct *work)
 {
-	struct sas_phy_data *d = container_of(work, typeof(*d), enable_work);
+	struct sas_phy_data *d = container_of(work, typeof(*d), enable_work.work);
 
 	d->enable_result = sas_phy_enable(d->phy, d->enable);
 }
@@ -389,8 +388,8 @@ static int sas_phy_setup(struct sas_phy *phy)
 		return -ENOMEM;
 
 	mutex_init(&d->event_lock);
-	INIT_WORK(&d->reset_work, phy_reset_work);
-	INIT_WORK(&d->enable_work, phy_enable_work);
+	INIT_SAS_WORK(&d->reset_work, phy_reset_work);
+	INIT_SAS_WORK(&d->enable_work, phy_enable_work);
 	d->phy = phy;
 	phy->hostdata = d;
 
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index f05c638..507e4cf 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -45,10 +45,10 @@ struct sas_phy_data {
 	struct mutex event_lock;
 	int hard_reset;
 	int reset_result;
-	struct work_struct reset_work;
+	struct sas_work reset_work;
 	int enable;
 	int enable_result;
-	struct work_struct enable_work;
+	struct sas_work enable_work;
 };
 
 void sas_scsi_recover_host(struct Scsi_Host *shost);
@@ -80,7 +80,7 @@ void sas_porte_broadcast_rcvd(struct work_struct *work);
 void sas_porte_link_reset_err(struct work_struct *work);
 void sas_porte_timer_event(struct work_struct *work);
 void sas_porte_hard_reset(struct work_struct *work);
-void sas_queue_work(struct sas_ha_struct *ha, struct work_struct *work);
+void sas_queue_work(struct sas_ha_struct *ha, struct sas_work *sw);
 
 int sas_notify_lldd_dev_found(struct domain_device *);
 void sas_notify_lldd_dev_gone(struct domain_device *);
diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
index dcfd4a9..521422e 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -32,8 +32,7 @@
 
 static void sas_phye_loss_of_signal(struct work_struct *work)
 {
-	struct asd_sas_event *ev =
-		container_of(work, struct asd_sas_event, work);
+	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
 	clear_bit(PHYE_LOSS_OF_SIGNAL, &phy->phy_events_pending);
@@ -43,8 +42,7 @@ static void sas_phye_loss_of_signal(struct work_struct *work)
 
 static void sas_phye_oob_done(struct work_struct *work)
 {
-	struct asd_sas_event *ev =
-		container_of(work, struct asd_sas_event, work);
+	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
 	clear_bit(PHYE_OOB_DONE, &phy->phy_events_pending);
@@ -53,8 +51,7 @@ static void sas_phye_oob_done(struct work_struct *work)
 
 static void sas_phye_oob_error(struct work_struct *work)
 {
-	struct asd_sas_event *ev =
-		container_of(work, struct asd_sas_event, work);
+	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 	struct sas_ha_struct *sas_ha = phy->ha;
 	struct asd_sas_port *port = phy->port;
@@ -85,8 +82,7 @@ static void sas_phye_oob_error(struct work_struct *work)
 
 static void sas_phye_spinup_hold(struct work_struct *work)
 {
-	struct asd_sas_event *ev =
-		container_of(work, struct asd_sas_event, work);
+	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 	struct sas_ha_struct *sas_ha = phy->ha;
 	struct sas_internal *i =
@@ -127,14 +123,12 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
 		phy->error = 0;
 		INIT_LIST_HEAD(&phy->port_phy_el);
 		for (k = 0; k < PORT_NUM_EVENTS; k++) {
-			INIT_WORK(&phy->port_events[k].work,
-				  sas_port_event_fns[k]);
+			INIT_SAS_WORK(&phy->port_events[k].work, sas_port_event_fns[k]);
 			phy->port_events[k].phy = phy;
 		}
 
 		for (k = 0; k < PHY_NUM_EVENTS; k++) {
-			INIT_WORK(&phy->phy_events[k].work,
-				  sas_phy_event_fns[k]);
+			INIT_SAS_WORK(&phy->phy_events[k].work, sas_phy_event_fns[k]);
 			phy->phy_events[k].phy = phy;
 		}
 
@@ -144,8 +138,7 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
 		spin_lock_init(&phy->sas_prim_lock);
 		phy->frame_rcvd_size = 0;
 
-		phy->phy = sas_phy_alloc(&sas_ha->core.shost->shost_gendev,
-					 i);
+		phy->phy = sas_phy_alloc(&sas_ha->core.shost->shost_gendev, i);
 		if (!phy->phy)
 			return -ENOMEM;
 
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index eb19c01..e884a8c 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -123,7 +123,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 	spin_unlock_irqrestore(&sas_ha->phy_port_lock, flags);
 
 	if (!port->port) {
-		port->port = sas_port_alloc(phy->phy->dev.parent, phy->id);
+		port->port = sas_port_alloc(phy->phy->dev.parent, port->id);
 		BUG_ON(!port->port);
 		sas_port_add(port->port);
 	}
@@ -208,8 +208,7 @@ void sas_deform_port(struct asd_sas_phy *phy, int gone)
 
 void sas_porte_bytes_dmaed(struct work_struct *work)
 {
-	struct asd_sas_event *ev =
-		container_of(work, struct asd_sas_event, work);
+	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
 	clear_bit(PORTE_BYTES_DMAED, &phy->port_events_pending);
@@ -219,8 +218,7 @@ void sas_porte_bytes_dmaed(struct work_struct *work)
 
 void sas_porte_broadcast_rcvd(struct work_struct *work)
 {
-	struct asd_sas_event *ev =
-		container_of(work, struct asd_sas_event, work);
+	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 	unsigned long flags;
 	u32 prim;
@@ -237,8 +235,7 @@ void sas_porte_broadcast_rcvd(struct work_struct *work)
 
 void sas_porte_link_reset_err(struct work_struct *work)
 {
-	struct asd_sas_event *ev =
-		container_of(work, struct asd_sas_event, work);
+	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
 	clear_bit(PORTE_LINK_RESET_ERR, &phy->port_events_pending);
@@ -248,8 +245,7 @@ void sas_porte_link_reset_err(struct work_struct *work)
 
 void sas_porte_timer_event(struct work_struct *work)
 {
-	struct asd_sas_event *ev =
-		container_of(work, struct asd_sas_event, work);
+	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
 	clear_bit(PORTE_TIMER_EVENT, &phy->port_events_pending);
@@ -259,8 +255,7 @@ void sas_porte_timer_event(struct work_struct *work)
 
 void sas_porte_hard_reset(struct work_struct *work)
 {
-	struct asd_sas_event *ev =
-		container_of(work, struct asd_sas_event, work);
+	struct asd_sas_event *ev = to_asd_sas_event(work);
 	struct asd_sas_phy *phy = ev->phy;
 
 	clear_bit(PORTE_HARD_RESET, &phy->port_events_pending);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ead6405..5dfd749 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1638,7 +1638,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 					 request_fn_proc *request_fn)
 {
 	struct request_queue *q;
-	struct device *dev = shost->shost_gendev.parent;
+	struct device *dev = shost->dma_dev;
 
 	q = blk_init_queue(request_fn, NULL);
 	if (!q)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 42378d6..e926df7 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -996,7 +996,8 @@ extern int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *dev,
 extern void ata_sas_port_destroy(struct ata_port *);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
-extern int ata_sas_async_port_init(struct ata_port *);
+extern void ata_sas_async_probe(struct ata_port *ap);
+extern int ata_sas_sync_probe(struct ata_port *ap);
 extern int ata_sas_port_init(struct ata_port *);
 extern int ata_sas_port_start(struct ata_port *ap);
 extern void ata_sas_port_stop(struct ata_port *ap);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 5f5ed1b..f4f1c96 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -217,11 +217,29 @@ struct domain_device {
 	struct kref kref;
 };
 
-struct sas_discovery_event {
+struct sas_work {
+	struct list_head drain_node;
 	struct work_struct work;
+};
+
+static inline void INIT_SAS_WORK(struct sas_work *sw, void (*fn)(struct work_struct *))
+{
+	INIT_WORK(&sw->work, fn);
+	INIT_LIST_HEAD(&sw->drain_node);
+}
+
+struct sas_discovery_event {
+	struct sas_work work;
 	struct asd_sas_port *port;
 };
 
+static inline struct sas_discovery_event *to_sas_discovery_event(struct work_struct *work)
+{
+	struct sas_discovery_event *ev = container_of(work, typeof(*ev), work.work);
+
+	return ev;
+}
+
 struct sas_discovery {
 	struct sas_discovery_event disc_work[DISC_NUM_EVENTS];
 	unsigned long    pending;
@@ -244,7 +262,7 @@ struct asd_sas_port {
 	struct list_head destroy_list;
 	enum   sas_linkrate linkrate;
 
-	struct work_struct work;
+	struct sas_work work;
 
 /* public: */
 	int id;
@@ -270,10 +288,17 @@ struct asd_sas_port {
 };
 
 struct asd_sas_event {
-	struct work_struct work;
+	struct sas_work work;
 	struct asd_sas_phy *phy;
 };
 
+static inline struct asd_sas_event *to_asd_sas_event(struct work_struct *work)
+{
+	struct asd_sas_event *ev = container_of(work, typeof(*ev), work.work);
+
+	return ev;
+}
+
 /* The phy pretty much is controlled by the LLDD.
  * The class only reads those fields.
  */
@@ -333,10 +358,17 @@ struct scsi_core {
 };
 
 struct sas_ha_event {
-	struct work_struct work;
+	struct sas_work work;
 	struct sas_ha_struct *ha;
 };
 
+static inline struct sas_ha_event *to_sas_ha_event(struct work_struct *work)
+{
+	struct sas_ha_event *ev = container_of(work, typeof(*ev), work.work);
+
+	return ev;
+}
+
 enum sas_ha_state {
 	SAS_HA_REGISTERED,
 	SAS_HA_DRAINING,
diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index cdccd2e..77670e8 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -37,7 +37,7 @@ static inline int dev_is_sata(struct domain_device *dev)
 }
 
 int sas_get_ata_info(struct domain_device *dev, struct ex_phy *phy);
-int sas_ata_init_host_and_port(struct domain_device *found_dev);
+int sas_ata_init(struct domain_device *dev);
 void sas_ata_task_abort(struct sas_task *task);
 void sas_ata_strategy_handler(struct Scsi_Host *shost);
 void sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
@@ -52,7 +52,7 @@ static inline int dev_is_sata(struct domain_device *dev)
 {
 	return 0;
 }
-static inline int sas_ata_init_host_and_port(struct domain_device *found_dev)
+static inline int sas_ata_init(struct domain_device *dev)
 {
 	return 0;
 }



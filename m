From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/3] libsas: fix/amend device gone notification in
	sas_deform_port()
Date: Tue, 03 May 2011 11:36:27 -0700
Message-ID: <20110503183627.21471.57988.stgit@localhost6.localdomain6>
References: <20110503183526.21471.84735.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4087 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262Ab1ECSUQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 May 2011 14:20:16 -0400
In-Reply-To: <20110503183526.21471.84735.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de
Cc: Haipao Fan <haipao.fan@intel.com>, linux-scsi@vger.kernel.org, David Milburn <dmilburn@redhat.com>, Maciej Trela <maciej.trela@intel.com>, linux-ide@vger.kernel.org, "Darrick J. Wong" <djwong@us.ibm.com>

Commit 56dd2c06 "libsas: Don't issue commands to devices that have been
hot-removed" edited Darrick's original patch to remove setting 'gone' in
the sas_deform_port() path because that prevented scsi sync cache
commands from being issued when the driver was unloaded.  However, this
allows true device gone notifications (as signaled port phy events) to
trigger sync cache commands to devices that are known to be unreachable.

Teach libsas which sas_deform_port() invocations are likely device gone
events.

This patch also introduces sas_device_gone() which hopefully allows
subtle/tricky locking to be dropped from lldd drivers, like the
following in mvsas which is broken if the ata path is ever converted to
call lldd_execute_task() with irqs enabled:

	flags_libsas = 0;
	[...]
	spin_unlock_irqrestore(dev->sata_dev.ap->lock, flags_libsas);
	spin_unlock_irqrestore(&mvi->lock, flags);
	t->task_done(t);
	spin_lock_irqsave(&mvi->lock, flags);
	spin_lock_irqsave(dev->sata_dev.ap->lock, flags_libsas);

Cc: Darrick J. Wong <djwong@us.ibm.com>
Cc: Haipao Fan <haipao.fan@intel.com>
Cc: Maciej Trela <maciej.trela@intel.com>
Cc: David Milburn <dmilburn@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_expander.c |   20 +++++++++++++++++---
 drivers/scsi/libsas/sas_internal.h |    3 ++-
 drivers/scsi/libsas/sas_phy.c      |    4 ++--
 drivers/scsi/libsas/sas_port.c     |   21 ++++++++++++---------
 4 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 505ffe3..7a785df 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1721,13 +1721,27 @@ out:
 	return res;
 }
 
+/* FIXME: delete this routine when/if sas_ata stops submitting tasks
+ * with host_lock held
+ */
+void sas_device_gone(struct domain_device *dev)
+{
+	struct sas_rphy *rphy = dev->rphy;
+	struct Scsi_Host *shost = dev_to_shost(rphy->dev.parent);
+
+	/* take the lock to synchronize against incoming sata i/o */
+	spin_lock_irq(shost->host_lock);
+	dev->gone = 1;
+	spin_unlock_irq(shost->host_lock);
+}
+
 static void sas_unregister_ex_tree(struct domain_device *dev)
 {
 	struct expander_device *ex = &dev->ex_dev;
 	struct domain_device *child, *n;
 
 	list_for_each_entry_safe(child, n, &ex->children, siblings) {
-		child->gone = 1;
+		sas_device_gone(child);
 		if (child->dev_type == EDGE_DEV ||
 		    child->dev_type == FANOUT_DEV)
 			sas_unregister_ex_tree(child);
@@ -1748,7 +1762,7 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 			&ex_dev->children, siblings) {
 			if (SAS_ADDR(child->sas_addr) ==
 			    SAS_ADDR(phy->attached_sas_addr)) {
-				child->gone = 1;
+				sas_device_gone(child);
 				if (child->dev_type == EDGE_DEV ||
 				    child->dev_type == FANOUT_DEV)
 					sas_unregister_ex_tree(child);
@@ -1757,7 +1771,7 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
 				break;
 			}
 		}
-		parent->gone = 1;
+		sas_device_gone(parent);
 		sas_disable_routing(parent, phy->attached_sas_addr);
 	}
 	memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 0001374..6fcfd82 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -61,7 +61,7 @@ int  sas_init_queue(struct sas_ha_struct *sas_ha);
 int  sas_init_events(struct sas_ha_struct *sas_ha);
 void sas_shutdown_queue(struct sas_ha_struct *sas_ha);
 
-void sas_deform_port(struct asd_sas_phy *phy);
+void sas_deform_port(struct asd_sas_phy *phy, int gone);
 
 void sas_porte_bytes_dmaed(struct work_struct *work);
 void sas_porte_broadcast_rcvd(struct work_struct *work);
@@ -71,6 +71,7 @@ void sas_porte_hard_reset(struct work_struct *work);
 
 int sas_notify_lldd_dev_found(struct domain_device *);
 void sas_notify_lldd_dev_gone(struct domain_device *);
+void sas_device_gone(struct domain_device *dev);
 
 int sas_smp_phy_control(struct domain_device *dev, int phy_id,
 			enum phy_func phy_func, struct sas_phy_linkrates *);
diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
index b459c4b..e0f5018 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -39,7 +39,7 @@ static void sas_phye_loss_of_signal(struct work_struct *work)
 	sas_begin_event(PHYE_LOSS_OF_SIGNAL, &phy->ha->event_lock,
 			&phy->phy_events_pending);
 	phy->error = 0;
-	sas_deform_port(phy);
+	sas_deform_port(phy, 1);
 }
 
 static void sas_phye_oob_done(struct work_struct *work)
@@ -66,7 +66,7 @@ static void sas_phye_oob_error(struct work_struct *work)
 	sas_begin_event(PHYE_OOB_ERROR, &phy->ha->event_lock,
 			&phy->phy_events_pending);
 
-	sas_deform_port(phy);
+	sas_deform_port(phy, 1);
 
 	if (!port && phy->enabled && i->dft->lldd_control_phy) {
 		phy->error++;
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index 5257fdf..be490e4 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -57,7 +57,7 @@ static void sas_form_port(struct asd_sas_phy *phy)
 
 	if (port) {
 		if (!phy_is_wideport_member(port, phy))
-			sas_deform_port(phy);
+			sas_deform_port(phy, 0);
 		else {
 			SAS_DPRINTK("%s: phy%d belongs to port%d already(%d)!\n",
 				    __func__, phy->id, phy->port->id,
@@ -153,28 +153,31 @@ static void sas_form_port(struct asd_sas_phy *phy)
  * This is called when the physical link to the other phy has been
  * lost (on this phy), in Event thread context. We cannot delay here.
  */
-void sas_deform_port(struct asd_sas_phy *phy)
+void sas_deform_port(struct asd_sas_phy *phy, int gone)
 {
 	struct sas_ha_struct *sas_ha = phy->ha;
 	struct asd_sas_port *port = phy->port;
 	struct sas_internal *si =
 		to_sas_internal(sas_ha->core.shost->transportt);
+	struct domain_device *dev;
 	unsigned long flags;
 
 	if (!port)
 		return;		  /* done by a phy event */
 
-	if (port->port_dev)
-		port->port_dev->pathways--;
+	dev = port->port_dev;
+	if (dev)
+		dev->pathways--;
 
 	if (port->num_phys == 1) {
+		if (dev && gone)
+			sas_device_gone(dev);
 		sas_unregister_domain_devices(port);
 		sas_port_delete(port->port);
 		port->port = NULL;
 	} else
 		sas_port_delete_phy(port->port, phy->phy);
 
-
 	if (si->dft->lldd_port_deformed)
 		si->dft->lldd_port_deformed(phy);
 
@@ -244,7 +247,7 @@ void sas_porte_link_reset_err(struct work_struct *work)
 	sas_begin_event(PORTE_LINK_RESET_ERR, &phy->ha->event_lock,
 			&phy->port_events_pending);
 
-	sas_deform_port(phy);
+	sas_deform_port(phy, 1);
 }
 
 void sas_porte_timer_event(struct work_struct *work)
@@ -256,7 +259,7 @@ void sas_porte_timer_event(struct work_struct *work)
 	sas_begin_event(PORTE_TIMER_EVENT, &phy->ha->event_lock,
 			&phy->port_events_pending);
 
-	sas_deform_port(phy);
+	sas_deform_port(phy, 1);
 }
 
 void sas_porte_hard_reset(struct work_struct *work)
@@ -268,7 +271,7 @@ void sas_porte_hard_reset(struct work_struct *work)
 	sas_begin_event(PORTE_HARD_RESET, &phy->ha->event_lock,
 			&phy->port_events_pending);
 
-	sas_deform_port(phy);
+	sas_deform_port(phy, 1);
 }
 
 /* ---------- SAS port registration ---------- */
@@ -306,6 +309,6 @@ void sas_unregister_ports(struct sas_ha_struct *sas_ha)
 
 	for (i = 0; i < sas_ha->num_phys; i++)
 		if (sas_ha->sas_phy[i]->port)
-			sas_deform_port(sas_ha->sas_phy[i]);
+			sas_deform_port(sas_ha->sas_phy[i], 0);
 
 }


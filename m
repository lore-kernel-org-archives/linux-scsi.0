From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/4] libsas: fix/amend device gone notification in
	sas_deform_port()
Date: Tue, 24 May 2011 13:17:53 -0700
Message-ID: <20110524201753.7351.43638.stgit@localhost6.localdomain6>
References: <20110524201708.7351.76421.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20110524201708.7351.76421.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: Haipao Fan <haipao.fan@intel.com>, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jeffrey.d.skirvin@intel.com, Maciej Trela <maciej.trela@intel.com>, jacek.danecki@intel.com, linux-ide@vger.kernel.org, David Milburn <dmilburn@redhat.com>, edmund.nadolski@intel.com, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Commit 56dd2c06 "libsas: Don't issue commands to devices that have been
hot-removed" edited Darrick's original patch to remove setting 'gone' in
the sas_deform_port() path because that prevented scsi sync cache
commands from being issued when the driver was unloaded.  However, this
allows true device gone notifications (as signaled port phy events) to
trigger sync cache commands to devices that are known to be unreachable.

Teach libsas which sas_deform_port() invocations are likely device gone
events.

Cc: Darrick J. Wong <djwong@us.ibm.com>
Cc: Haipao Fan <haipao.fan@intel.com>
Cc: Maciej Trela <maciej.trela@intel.com>
Cc: David Milburn <dmilburn@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_internal.h |    2 +-
 drivers/scsi/libsas/sas_phy.c      |    4 ++--
 drivers/scsi/libsas/sas_port.c     |   21 ++++++++++++---------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 8b538bd..14e21b5 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -57,7 +57,7 @@ int  sas_init_queue(struct sas_ha_struct *sas_ha);
 int  sas_init_events(struct sas_ha_struct *sas_ha);
 void sas_shutdown_queue(struct sas_ha_struct *sas_ha);
 
-void sas_deform_port(struct asd_sas_phy *phy);
+void sas_deform_port(struct asd_sas_phy *phy, int gone);
 
 void sas_porte_bytes_dmaed(struct work_struct *work);
 void sas_porte_broadcast_rcvd(struct work_struct *work);
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
index 5257fdf..42fd1f2 100644
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
+			dev->gone = 1;
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


From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 2/5] zfcp: Fix deadlock between zfcp ERP and SCSI
Date: Thu, 10 May 2007 09:49:02 +0200
Message-ID: <20070510074902.GA7893@osiris.boeblingen.de.ibm.com>
References: <200705081116.53021.swen@vnet.ibm.com> <4640907B.3080409@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:33852 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932AbXEJHuI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 May 2007 03:50:08 -0400
Content-Disposition: inline
In-Reply-To: <4640907B.3080409@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Swen Schillig <swen@vnet.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

On Tue, May 08, 2007 at 11:00:11AM -0400, James Smart wrote:
> Curious why you are calling scsi_scan_target() or
> scsi_target_block()/scsi_target_unblock() directly. I would have
> thought the add/remove rport code would have done this for you,
> and it deals with all the flush conditions, etc.
> 
> -- james
> 
> Swen Schillig wrote:
> >From: Christof Schmitt <christof.schmitt@de.ibm.com>
> >The SCSI stack requires low level drivers to register and
> >unregister devices. For zfcp this leads to the situation where
> >zfcp calls the SCSI stack, the SCSI tries to scan the new device
> >and the scan SCSI command fails. This would require the zfcp erp,
> >but the erp thread is already blocked in the register call.
> >The fix is to make sure that the calls from the ERP thread to
> >the SCSI stack do not block the ERP thread. In detail:
> >1) Use a workqueue to avoid blocking of the scsi_scan_target calls.
> >2) When removing a unit make sure that no scsi_scan_target call is
> >   pending.
> >3) Replace scsi_flush_work with scsi_target_unblock. This avoids
> >   blocking and has the same result.

Reading the patch again, I think there is still a race:

> >+static void zfcp_erp_scsi_scan(struct work_struct *work)
> >+{
> >+	struct zfcp_erp_add_work *p =
> >+		container_of(work, struct zfcp_erp_add_work, work);
> >+	struct zfcp_unit *unit = p->unit;
> >+	struct fc_rport *rport = unit->port->rport;
> >+	scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
> >+			 unit->scsi_lun, 0);
> >+	atomic_clear_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
> >+	wake_up(&unit->scsi_scan_wq);
> >+	zfcp_unit_put(unit);
> >+	kfree(p);

This function gets executed via schedule_work() and therefore there is
nothing that prevents the rport to go. E.g. the following might happen:
function gets enqueued for execution via schedule_work(), adapter gets
shut down, call to fc_remort_port_delete(), port->rport gets deleted,
then zfcp_erp_scsi_scan() gets called and tries to derefence port->rport
which is NULL. Addressing exception is the result.

The patch below should fix that, but it changes the call from
scsi_scan_target() to scsi_add_device(). I think that should be ok.

Not-yet-signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/s390/scsi/zfcp_def.h |    1 +
 drivers/s390/scsi/zfcp_erp.c |   37 +++++++++++++++++++------------------
 2 files changed, 20 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/s390/scsi/zfcp_def.h
===================================================================
--- linux-2.6.orig/drivers/s390/scsi/zfcp_def.h
+++ linux-2.6/drivers/s390/scsi/zfcp_def.h
@@ -961,6 +961,7 @@ struct zfcp_port {
         atomic_t               erp_counter;
 	u32                    maxframe_size;
 	u32                    supported_classes;
+	unsigned int	       scsi_target_id;
 };
 
 /* the struct device sysfs_device must be at the beginning of this structure.
Index: linux-2.6/drivers/s390/scsi/zfcp_erp.c
===================================================================
--- linux-2.6.orig/drivers/s390/scsi/zfcp_erp.c
+++ linux-2.6/drivers/s390/scsi/zfcp_erp.c
@@ -1591,7 +1591,7 @@ zfcp_erp_strategy_check_adapter(struct z
 }
 
 struct zfcp_erp_add_work {
-	struct zfcp_unit  *unit;
+	struct zfcp_unit *unit;
 	struct work_struct work;
 };
 
@@ -1603,15 +1603,14 @@ struct zfcp_erp_add_work {
  */
 static void zfcp_erp_scsi_scan(struct work_struct *work)
 {
-	struct zfcp_erp_add_work *p =
-		container_of(work, struct zfcp_erp_add_work, work);
-	struct zfcp_unit *unit = p->unit;
-	struct fc_rport *rport = unit->port->rport;
-	scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
-			 unit->scsi_lun, 0);
-	atomic_clear_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
-	wake_up(&unit->scsi_scan_wq);
-	zfcp_unit_put(unit);
+	struct zfcp_erp_add_work *p;
+
+	p = container_of(work, struct zfcp_erp_add_work, work);
+	scsi_add_device(p->unit->port->adapter->scsi_host, 0,
+			p->unit->port->scsi_target_id, p->unit->scsi_lun);
+	atomic_clear_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &p->unit->status);
+	wake_up(&p->unit->scsi_scan_wq);
+	zfcp_unit_put(p->unit);
 	kfree(p);
 }
 
@@ -3161,25 +3160,27 @@ zfcp_erp_action_cleanup(int action, stru
 			break;
 		}
 
-		if ((result == ZFCP_ERP_SUCCEEDED)
-		    && !port->rport) {
+		if ((result == ZFCP_ERP_SUCCEEDED) && !port->rport) {
 			struct fc_rport_identifiers ids;
+			struct fc_rport *rport;
+
 			ids.node_name = port->wwnn;
 			ids.port_name = port->wwpn;
 			ids.port_id = port->d_id;
 			ids.roles = FC_RPORT_ROLE_FCP_TARGET;
-			port->rport =
-				fc_remote_port_add(adapter->scsi_host, 0, &ids);
-			if (!port->rport)
+			rport = fc_remote_port_add(adapter->scsi_host, 0, &ids);
+			if (!rport)
 				ZFCP_LOG_NORMAL("failed registration of rport"
 						"(adapter %s, wwpn=0x%016Lx)\n",
 						zfcp_get_busid_by_port(port),
 						port->wwpn);
 			else {
-				scsi_target_unblock(&port->rport->dev);
-				port->rport->maxframe_size = port->maxframe_size;
-				port->rport->supported_classes =
+				port->rport = rport;
+				port->scsi_target_id = rport->scsi_target_id;
+				rport->maxframe_size = port->maxframe_size;
+				rport->supported_classes =
 					port->supported_classes;
+				scsi_target_unblock(&port->rport->dev);
 			}
 		}
 		if ((result != ZFCP_ERP_SUCCEEDED) && port->rport) {

From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Fri,  7 Dec 2012 15:51:20 +0100
Message-ID: <1354891880-16159-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965033Ab2LGOv1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2012 09:51:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, James Bottomley <jbottomley@parallels.com>

'Bus reset' is not really applicable to FibreChannel, as
the concept of a bus doesn't apply. Hence all FC LLDD
simulate a 'bus reset' by sending a target reset to each
attached remote port, causing error handling to spill
over to unaffected devices.

This patch implements a 'I_T nexus reset' handler,
which attempts to reset the I_T nexus to the remote
port. This way only the affected remote ports are
reset; other ports are left untouched.

I_T nexus reset is done by invoking the dev_loss_tmo
mechanism with a '0' fast fail timeout. This causes
any outstanding I/O to be aborted immediately.
The port is then set to 'blocked' to indicate that
no further I/O should be issued to this port.
The standard dev_loss_tmo mechanism is then
invoked to clear up any outstanding resources.

In my test this patch cuts down the total time
for recovery from 100 secs to 60 secs. And,
of course, with no interruption to the other
remote ports.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Smart <james.smart@emulex.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: James Bottomley <jbottomley@parallels.com>
---
 drivers/scsi/bfa/bfad_im.c       |    4 +-
 drivers/scsi/lpfc/lpfc_scsi.c    |    4 +-
 drivers/scsi/qla2xxx/qla_os.c    |    2 +-
 drivers/scsi/scsi_transport_fc.c |  146 ++++++++++++++++++++++++--------------
 include/scsi/scsi_transport_fc.h |    1 +
 5 files changed, 99 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 8f92732..d6555aa 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -793,7 +793,7 @@ struct scsi_host_template bfad_im_scsi_host_template = {
 	.queuecommand = bfad_im_queuecommand,
 	.eh_abort_handler = bfad_im_abort_handler,
 	.eh_device_reset_handler = bfad_im_reset_lun_handler,
-	.eh_bus_reset_handler = bfad_im_reset_bus_handler,
+	.eh_bus_reset_handler = fc_eh_reset_it_nexus_handler,
 
 	.slave_alloc = bfad_im_slave_alloc,
 	.slave_configure = bfad_im_slave_configure,
@@ -815,7 +815,7 @@ struct scsi_host_template bfad_im_vport_template = {
 	.queuecommand = bfad_im_queuecommand,
 	.eh_abort_handler = bfad_im_abort_handler,
 	.eh_device_reset_handler = bfad_im_reset_lun_handler,
-	.eh_bus_reset_handler = bfad_im_reset_bus_handler,
+	.eh_bus_reset_handler = fc_eh_reset_it_nexus_handler,
 
 	.slave_alloc = bfad_im_slave_alloc,
 	.slave_configure = bfad_im_slave_configure,
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 60e5a17..2fd67c1 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5136,7 +5136,7 @@ struct scsi_host_template lpfc_template = {
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
-	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
+	.eh_bus_reset_handler	= fc_eh_reset_it_nexus_handler,
 	.eh_host_reset_handler  = lpfc_host_reset_handler,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
@@ -5160,7 +5160,7 @@ struct scsi_host_template lpfc_vport_template = {
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
-	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
+	.eh_bus_reset_handler	= fc_eh_reset_it_nexus_handler,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3a1661c..5d59284 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -246,7 +246,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 	.eh_abort_handler	= qla2xxx_eh_abort,
 	.eh_device_reset_handler = qla2xxx_eh_device_reset,
 	.eh_target_reset_handler = qla2xxx_eh_target_reset,
-	.eh_bus_reset_handler	= qla2xxx_eh_bus_reset,
+	.eh_bus_reset_handler	= fc_eh_reset_it_nexus_handler,
 	.eh_host_reset_handler	= qla2xxx_eh_host_reset,
 
 	.slave_configure	= qla2xxx_slave_configure,
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index e894ca7..e1da601 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2920,6 +2920,62 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 EXPORT_SYMBOL(fc_remote_port_add);
 
 
+void
+__fc_remote_port_delete(struct fc_rport *rport, int fast_io_fail_tmo)
+{
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	unsigned long timeout = rport->dev_loss_tmo;
+	unsigned long flags;
+
+	/*
+	 * No need to flush the fc_host work_q's, as all adds are synchronous.
+	 *
+	 * We do need to reclaim the rport scan work element, so eventually
+	 * (in fc_rport_final_delete()) we'll flush the scsi host work_q if
+	 * there's still a scan pending.
+	 */
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	if (rport->port_state != FC_PORTSTATE_ONLINE) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		return;
+	}
+
+	/*
+	 * In the past, we if this was not an FCP-Target, we would
+	 * unconditionally just jump to deleting the rport.
+	 * However, rports can be used as node containers by the LLDD,
+	 * and its not appropriate to just terminate the rport at the
+	 * first sign of a loss in connectivity. The LLDD may want to
+	 * send ELS traffic to re-validate the login. If the rport is
+	 * immediately deleted, it makes it inappropriate for a node
+	 * container.
+	 * So... we now unconditionally wait dev_loss_tmo before
+	 * destroying an rport.
+	 */
+
+	rport->port_state = FC_PORTSTATE_BLOCKED;
+
+	rport->flags |= FC_RPORT_DEVLOSS_PENDING;
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (rport->roles & FC_PORT_ROLE_FCP_INITIATOR &&
+	    shost->active_mode & MODE_TARGET)
+		fc_tgt_it_nexus_destroy(shost, (unsigned long)rport);
+
+	scsi_target_block(&rport->dev);
+
+	/* see if we need to kill io faster than waiting for device loss */
+	if ((fast_io_fail_tmo != -1) && (fast_io_fail_tmo < timeout))
+		fc_queue_devloss_work(shost, &rport->fail_io_work,
+					fast_io_fail_tmo * HZ);
+
+	/* cap the length the devices can be blocked until they are deleted */
+	fc_queue_devloss_work(shost, &rport->dev_loss_work, timeout * HZ);
+}
+
 /**
  * fc_remote_port_delete - notifies the fc transport that a remote port is no longer in existence.
  * @rport:	The remote port that no longer exists
@@ -2973,58 +3029,7 @@ EXPORT_SYMBOL(fc_remote_port_add);
 void
 fc_remote_port_delete(struct fc_rport  *rport)
 {
-	struct Scsi_Host *shost = rport_to_shost(rport);
-	unsigned long timeout = rport->dev_loss_tmo;
-	unsigned long flags;
-
-	/*
-	 * No need to flush the fc_host work_q's, as all adds are synchronous.
-	 *
-	 * We do need to reclaim the rport scan work element, so eventually
-	 * (in fc_rport_final_delete()) we'll flush the scsi host work_q if
-	 * there's still a scan pending.
-	 */
-
-	spin_lock_irqsave(shost->host_lock, flags);
-
-	if (rport->port_state != FC_PORTSTATE_ONLINE) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		return;
-	}
-
-	/*
-	 * In the past, we if this was not an FCP-Target, we would
-	 * unconditionally just jump to deleting the rport.
-	 * However, rports can be used as node containers by the LLDD,
-	 * and its not appropriate to just terminate the rport at the
-	 * first sign of a loss in connectivity. The LLDD may want to
-	 * send ELS traffic to re-validate the login. If the rport is
-	 * immediately deleted, it makes it inappropriate for a node
-	 * container.
-	 * So... we now unconditionally wait dev_loss_tmo before
-	 * destroying an rport.
-	 */
-
-	rport->port_state = FC_PORTSTATE_BLOCKED;
-
-	rport->flags |= FC_RPORT_DEVLOSS_PENDING;
-
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	if (rport->roles & FC_PORT_ROLE_FCP_INITIATOR &&
-	    shost->active_mode & MODE_TARGET)
-		fc_tgt_it_nexus_destroy(shost, (unsigned long)rport);
-
-	scsi_target_block(&rport->dev);
-
-	/* see if we need to kill io faster than waiting for device loss */
-	if ((rport->fast_io_fail_tmo != -1) &&
-	    (rport->fast_io_fail_tmo < timeout))
-		fc_queue_devloss_work(shost, &rport->fail_io_work,
-					rport->fast_io_fail_tmo * HZ);
-
-	/* cap the length the devices can be blocked until they are deleted */
-	fc_queue_devloss_work(shost, &rport->dev_loss_work, timeout * HZ);
+	__fc_remote_port_delete(rport, rport->fast_io_fail_tmo);
 }
 EXPORT_SYMBOL(fc_remote_port_delete);
 
@@ -3266,8 +3271,8 @@ fc_timeout_fail_rport_io(struct work_struct *work)
 	if (rport->port_state != FC_PORTSTATE_BLOCKED)
 		return;
 
-	rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
 	fc_terminate_rport_io(rport);
+	rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
 }
 
 /**
@@ -3332,6 +3337,41 @@ int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
 EXPORT_SYMBOL(fc_block_scsi_eh);
 
 /**
+ * fc_eh_reset_it_nexus_handler - Reset I_T nexus
+ * @cmnd: SCSI command that scsi_eh is trying to recover
+ *
+ * This routine can be called from a FC LLD scsi_eh callback. It
+ * attempts to perform an REMOVE I_T NEXUS transport management
+ * function by failing all outstanding commands and invoke
+ * dev_loss_tmo() on the affected port.
+ *
+ * Returns: SUCCESS if all commands on the remote port have been
+ *	    terminated or the port is in PORTSTATE_ONLINE again
+ *	    FAST_IO_FAIL if the fast_io_fail_tmo fired and there
+ *	    is still I/O in flight
+ *	    FAILED otherwise.
+ */
+int
+fc_eh_reset_it_nexus_handler(struct scsi_cmnd *cmnd)
+{
+	struct scsi_target *starget = scsi_target(cmnd->device);
+	struct fc_rport *rport = starget_to_rport(starget);
+	int ret;
+
+	__fc_remote_port_delete(rport, 0);
+	ret = fc_block_scsi_eh(cmnd);
+	if (ret != FAST_IO_FAIL) {
+		if (rport->port_state == FC_PORTSTATE_ONLINE)
+			ret = SUCCESS;
+		else
+			ret = FAILED;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(fc_eh_reset_it_nexus_handler);
+
+/**
  * fc_vport_setup - allocates and creates a FC virtual port.
  * @shost:	scsi host the virtual port is connected to.
  * @channel:	Channel on shost port connected to.
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index b797e8f..f884305 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -851,5 +851,6 @@ struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
 int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
+int fc_eh_reset_it_nexus_handler(struct scsi_cmnd *cmnd);
 
 #endif /* SCSI_TRANSPORT_FC_H */
-- 
1.7.4.2


From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Tue, 11 Dec 2012 09:23:39 +0100
Message-ID: <1355214219-17343-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab2LKIXn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Dec 2012 03:23:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Krishna C Gudipati <kgudipat@brocade.com>, James Bottomley <jbottomley@parallels.com>

'Bus reset' is not really applicable to FibreChannel, as
the concept of a bus doesn't really apply. All FC driver
simulate a 'bus reset' by sending a target reset to each
attached remote port, causing error handling to spill
over to unaffected devices.
In addition, 'Target reset' has been removed from SAM
since SAM-3.

Instead, SAM-5 proposes an REMOVE I_T NEXUS TMF,
which just removes the I_T nexus, thereby avoiding
any spill-over to unaffected ports.

This patch implements fc_eh_it_nexus_loss_handler(),
which attempts to reset the I_T nexus to the remote
port.

For I_T nexus reset we first check if the port
is already blocked, then call a new LLDD-provided
'eh_it_nexus_loss' callback to allow the LLDD
to cleanup any outstanding resources or abort I/O.
If the callback succeeds the dev_loss_tmo
mechanism is called with '-1' fast fail timeout,
which causes fast_io_fail_tmo to be skipped.
Otherwise the dev_loss_tmo mechanism is called
with a '0' fast fail timeout, causing any
outstanding I/O to be aborted immediately.
The port is then set to 'blocked' to indicate that
no further I/O should be issued to this port.
Finally the standard dev_loss_tmo mechanism will
eventually clear up any outstanding resources.

fc_eh_it_nexus_loss_handler() is invoked as the
eh_target_reset_handler() callback and the
eh_bus_reset_handler() is removed.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Smart <james.smart@emulex.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Krishna C Gudipati <kgudipat@brocade.com>
Cc: James Bottomley <jbottomley@parallels.com>
---
 drivers/scsi/bfa/bfad_im.c       |    6 ++-
 drivers/scsi/lpfc/lpfc_scsi.c    |    8 ++--
 drivers/scsi/qla2xxx/qla_os.c    |    4 +-
 drivers/scsi/scsi_transport_fc.c |   63 +++++++++++++++++++++++++++++++++++---
 include/scsi/scsi_transport_fc.h |    2 +
 5 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 8f92732..fd1fc4a 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -793,7 +793,8 @@ struct scsi_host_template bfad_im_scsi_host_template = {
 	.queuecommand = bfad_im_queuecommand,
 	.eh_abort_handler = bfad_im_abort_handler,
 	.eh_device_reset_handler = bfad_im_reset_lun_handler,
-	.eh_bus_reset_handler = bfad_im_reset_bus_handler,
+	.eh_target_reset_handler = fc_eh_it_nexus_loss_handler,
+	.eh_bus_reset_handler = NULL,
 
 	.slave_alloc = bfad_im_slave_alloc,
 	.slave_configure = bfad_im_slave_configure,
@@ -815,7 +816,8 @@ struct scsi_host_template bfad_im_vport_template = {
 	.queuecommand = bfad_im_queuecommand,
 	.eh_abort_handler = bfad_im_abort_handler,
 	.eh_device_reset_handler = bfad_im_reset_lun_handler,
-	.eh_bus_reset_handler = bfad_im_reset_bus_handler,
+	.eh_target_reset_handler = fc_eh_it_nexus_loss_handler,
+	.eh_bus_reset_handler = NULL,
 
 	.slave_alloc = bfad_im_slave_alloc,
 	.slave_configure = bfad_im_slave_configure,
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 60e5a17..c4e2788 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5135,8 +5135,8 @@ struct scsi_host_template lpfc_template = {
 	.queuecommand		= lpfc_queuecommand,
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
-	.eh_target_reset_handler = lpfc_target_reset_handler,
-	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
+	.eh_target_reset_handler = fc_eh_it_nexus_loss_handler,
+	.eh_bus_reset_handler	= NULL,
 	.eh_host_reset_handler  = lpfc_host_reset_handler,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
@@ -5159,8 +5159,8 @@ struct scsi_host_template lpfc_vport_template = {
 	.queuecommand		= lpfc_queuecommand,
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
-	.eh_target_reset_handler = lpfc_target_reset_handler,
-	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
+	.eh_target_reset_handler = fc_eh_it_nexus_loss_handler,
+	.eh_bus_reset_handler	= NULL,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3a1661c..c59e681 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -245,8 +245,8 @@ struct scsi_host_template qla2xxx_driver_template = {
 
 	.eh_abort_handler	= qla2xxx_eh_abort,
 	.eh_device_reset_handler = qla2xxx_eh_device_reset,
-	.eh_target_reset_handler = qla2xxx_eh_target_reset,
-	.eh_bus_reset_handler	= qla2xxx_eh_bus_reset,
+	.eh_target_reset_handler = fc_eh_it_nexus_loss_handler,
+	.eh_bus_reset_handler	= NULL,
 	.eh_host_reset_handler	= qla2xxx_eh_host_reset,
 
 	.slave_configure	= qla2xxx_slave_configure,
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index e894ca7..da647d3 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2971,7 +2971,7 @@ EXPORT_SYMBOL(fc_remote_port_add);
  *	This routine assumes no locks are held on entry.
  */
 void
-fc_remote_port_delete(struct fc_rport  *rport)
+__fc_remote_port_delete(struct fc_rport *rport, int fast_io_fail_tmo)
 {
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	unsigned long timeout = rport->dev_loss_tmo;
@@ -3018,14 +3018,19 @@ fc_remote_port_delete(struct fc_rport  *rport)
 	scsi_target_block(&rport->dev);
 
 	/* see if we need to kill io faster than waiting for device loss */
-	if ((rport->fast_io_fail_tmo != -1) &&
-	    (rport->fast_io_fail_tmo < timeout))
+	if ((fast_io_fail_tmo != -1) && (fast_io_fail_tmo < timeout))
 		fc_queue_devloss_work(shost, &rport->fail_io_work,
-					rport->fast_io_fail_tmo * HZ);
+					fast_io_fail_tmo * HZ);
 
 	/* cap the length the devices can be blocked until they are deleted */
 	fc_queue_devloss_work(shost, &rport->dev_loss_work, timeout * HZ);
 }
+
+void
+fc_remote_port_delete(struct fc_rport  *rport)
+{
+	__fc_remote_port_delete(rport, rport->fast_io_fail_tmo);
+}
 EXPORT_SYMBOL(fc_remote_port_delete);
 
 /**
@@ -3266,8 +3271,8 @@ fc_timeout_fail_rport_io(struct work_struct *work)
 	if (rport->port_state != FC_PORTSTATE_BLOCKED)
 		return;
 
-	rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
 	fc_terminate_rport_io(rport);
+	rport->flags |= FC_RPORT_FAST_FAIL_TIMEDOUT;
 }
 
 /**
@@ -3332,6 +3337,54 @@ int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
 EXPORT_SYMBOL(fc_block_scsi_eh);
 
 /**
+ * fc_eh_it_nexus_loss_handler - Invoke REMOVE I_T NEXUS TMF
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
+fc_eh_it_nexus_loss_handler(struct scsi_cmnd *cmnd)
+{
+	struct fc_internal *i = to_fc_internal(cmnd->device->host->transportt);
+	struct scsi_target *starget = scsi_target(cmnd->device);
+	struct fc_rport *rport = starget_to_rport(starget);
+	int ret;
+
+	ret = fc_block_scsi_eh(cmnd);
+	if (i->f->eh_it_nexus_loss)
+		ret = i->f->eh_it_nexus_loss(cmnd);
+
+	/* FAST_IO_FAIL indicates the port is already blocked */
+	if (ret == FAST_IO_FAIL)
+		return ret;
+	if (ret == SUCCESS)
+		/* All outstanding I/O has been aborted */
+		__fc_remote_port_delete(rport, -1);
+	else {
+		/* Failed to abort outstanding I/O, trigger FAST_IO_FAIL */
+		__fc_remote_port_delete(rport, 0);
+		ret = fc_block_scsi_eh(cmnd);
+	}
+	if (ret != FAST_IO_FAIL) {
+		if (rport->port_state == FC_PORTSTATE_ONLINE)
+			ret = SUCCESS;
+		else
+			ret = FAILED;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(fc_eh_it_nexus_loss_handler);
+
+/**
  * fc_vport_setup - allocates and creates a FC virtual port.
  * @shost:	scsi host the virtual port is connected to.
  * @channel:	Channel on shost port connected to.
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index b797e8f..17e2968 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -684,6 +684,7 @@ struct fc_function_template {
 
 	void    (*dev_loss_tmo_callbk)(struct fc_rport *);
 	void	(*terminate_rport_io)(struct fc_rport *);
+	int	(*eh_it_nexus_loss)(struct scsi_cmnd *);
 
 	void	(*set_vport_symbolic_name)(struct fc_vport *);
 	int  	(*vport_create)(struct fc_vport *, bool);
@@ -851,5 +852,6 @@ struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
 int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
+int fc_eh_it_nexus_loss_handler(struct scsi_cmnd *cmnd);
 
 #endif /* SCSI_TRANSPORT_FC_H */
-- 
1.7.4.2


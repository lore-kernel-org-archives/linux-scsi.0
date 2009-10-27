From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: fc_remote_port_delete and returning SCSI commands from LLD
Date: Tue, 27 Oct 2009 17:59:44 +0100
Message-ID: <20091027165943.GA21795@schmichrtp.de.ibm.com>
References: <20091020144027.GA17717@schmichrtp.de.ibm.com> <20091021152437.GA19717@schmichrtp.de.ibm.com> <4ADF37D5.5090507@emulex.com> <20091023075839.GC5930@schmichrtp.de.ibm.com> <4AE1C2A7.3040508@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:55801 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbZJ0RAH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2009 13:00:07 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate4.uk.ibm.com (8.14.3/8.13.8) with ESMTP id n9RGxtAo264154
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2009 17:00:00 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9RGxjUk1351792
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2009 16:59:45 GMT
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9RGxiGK003165
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2009 16:59:45 GMT
Content-Disposition: inline
In-Reply-To: <4AE1C2A7.3040508@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Oct 23, 2009 at 10:50:15AM -0400, James Smart wrote:
> Christof Schmitt wrote:
>> It looks to me like this is required to prevent offline SCSI devices
>> in this case. Should this code be in a FC transport helper function
>> rather than being duplicated in each FC LLD?
>
> That would make sense....
>
> -- james s

Here is a patch for this. It is only compile tested on x86, but the
code move is fairly trivial.

Christof
---
scsi_transport_fc: Introduce helper function for blocking scsi_eh

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Move the duplicated code from FC LLDs to SCSI FC transport class.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/scsi/fnic/fnic_scsi.c    |   20 ++------------------
 drivers/scsi/lpfc/lpfc_scsi.c    |   30 ++++--------------------------
 drivers/scsi/qla2xxx/qla_os.c    |   25 ++++---------------------
 drivers/scsi/scsi_transport_fc.c |   26 ++++++++++++++++++++++++++
 include/scsi/scsi_transport_fc.h |    1 +
 5 files changed, 37 insertions(+), 65 deletions(-)

--- a/drivers/scsi/scsi_transport_fc.c	2009-10-27 17:50:56.000000000 +0100
+++ b/drivers/scsi/scsi_transport_fc.c	2009-10-27 17:51:18.000000000 +0100
@@ -27,6 +27,7 @@
  */
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/delay.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
@@ -3128,6 +3129,31 @@ fc_scsi_scan_rport(struct work_struct *w
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
+/**
+ * fc_block_scsi_eh - Block SCSI eh thread for blocked fc_rport
+ * @cmnd: SCSI command that scsi_eh is trying to recover
+ *
+ * This routine can be called from a FC LLD scsi_eh callback. It
+ * blocks the scsi_eh thread until the fc_rport leaves the
+ * FC_PORTSTATE_BLOCKED. This is necessary to avoid the scsi_eh
+ * failing recovery actions for blocked rports which would lead to
+ * offlined SCSI devices.
+ */
+void fc_block_scsi_eh(struct scsi_cmnd *cmnd)
+{
+	struct Scsi_Host *shost = cmnd->device->host;
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		msleep(1000);
+		spin_lock_irqsave(shost->host_lock, flags);
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+EXPORT_SYMBOL(fc_block_scsi_eh);
 
 /**
  * fc_vport_setup - allocates and creates a FC virtual port.
--- a/include/scsi/scsi_transport_fc.h	2009-10-27 17:50:57.000000000 +0100
+++ b/include/scsi/scsi_transport_fc.h	2009-10-27 17:51:18.000000000 +0100
@@ -807,5 +807,6 @@ void fc_host_post_vendor_event(struct Sc
 struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
+void fc_block_scsi_eh(struct scsi_cmnd *cmnd);
 
 #endif /* SCSI_TRANSPORT_FC_H */
--- a/drivers/scsi/fnic/fnic_scsi.c	2009-10-27 17:50:56.000000000 +0100
+++ b/drivers/scsi/fnic/fnic_scsi.c	2009-10-27 17:51:18.000000000 +0100
@@ -1224,22 +1224,6 @@ void fnic_terminate_rport_io(struct fc_r
 
 }
 
-static void fnic_block_error_handler(struct scsi_cmnd *sc)
-{
-	struct Scsi_Host *shost = sc->device->host;
-	struct fc_rport *rport = starget_to_rport(scsi_target(sc->device));
-	unsigned long flags;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		msleep(1000);
-		spin_lock_irqsave(shost->host_lock, flags);
-	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
-}
-
 /*
  * This function is exported to SCSI for sending abort cmnds.
  * A SCSI IO is represented by a io_req in the driver.
@@ -1259,7 +1243,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 
 	/* Wait for rport to unblock */
-	fnic_block_error_handler(sc);
+	fc_block_scsi_eh(sc);
 
 	/* Get local-port, check ready and link up */
 	lp = shost_priv(sc->device->host);
@@ -1541,7 +1525,7 @@ int fnic_device_reset(struct scsi_cmnd *
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 
 	/* Wait for rport to unblock */
-	fnic_block_error_handler(sc);
+	fc_block_scsi_eh(sc);
 
 	/* Get local-port, check ready and link up */
 	lp = shost_priv(sc->device->host);
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2009-10-27 17:50:56.000000000 +0100
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2009-10-27 17:51:18.000000000 +0100
@@ -2917,28 +2917,6 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 }
 
 /**
- * lpfc_block_error_handler - Routine to block error  handler
- * @cmnd: Pointer to scsi_cmnd data structure.
- *
- *  This routine blocks execution till fc_rport state is not FC_PORSTAT_BLCOEKD.
- **/
-static void
-lpfc_block_error_handler(struct scsi_cmnd *cmnd)
-{
-	struct Scsi_Host *shost = cmnd->device->host;
-	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
-
-	spin_lock_irq(shost->host_lock);
-	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
-		spin_unlock_irq(shost->host_lock);
-		msleep(1000);
-		spin_lock_irq(shost->host_lock);
-	}
-	spin_unlock_irq(shost->host_lock);
-	return;
-}
-
-/**
  * lpfc_abort_handler - scsi_host_template eh_abort_handler entry point
  * @cmnd: Pointer to scsi_cmnd data structure.
  *
@@ -2961,7 +2939,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	int ret = SUCCESS;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
-	lpfc_block_error_handler(cmnd);
+	fc_block_scsi_eh(cmnd);
 	lpfc_cmd = (struct lpfc_scsi_buf *)cmnd->host_scribble;
 	BUG_ON(!lpfc_cmd);
 
@@ -3259,7 +3237,7 @@ lpfc_device_reset_handler(struct scsi_cm
 	struct lpfc_scsi_event_header scsi_event;
 	int status;
 
-	lpfc_block_error_handler(cmnd);
+	fc_block_scsi_eh(cmnd);
 
 	status = lpfc_chk_tgt_mapped(vport, cmnd);
 	if (status == FAILED) {
@@ -3318,7 +3296,7 @@ lpfc_target_reset_handler(struct scsi_cm
 	struct lpfc_scsi_event_header scsi_event;
 	int status;
 
-	lpfc_block_error_handler(cmnd);
+	fc_block_scsi_eh(cmnd);
 
 	status = lpfc_chk_tgt_mapped(vport, cmnd);
 	if (status == FAILED) {
@@ -3384,7 +3362,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
-	lpfc_block_error_handler(cmnd);
+	fc_block_scsi_eh(cmnd);
 
 	/*
 	 * Since the driver manages a single bus device, reset all
--- a/drivers/scsi/qla2xxx/qla_os.c	2009-10-27 17:50:56.000000000 +0100
+++ b/drivers/scsi/qla2xxx/qla_os.c	2009-10-27 17:51:18.000000000 +0100
@@ -727,23 +727,6 @@ qla2x00_abort_fcport_cmds(fc_port_t *fcp
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
-static void
-qla2x00_block_error_handler(struct scsi_cmnd *cmnd)
-{
-	struct Scsi_Host *shost = cmnd->device->host;
-	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
-	unsigned long flags;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		msleep(1000);
-		spin_lock_irqsave(shost->host_lock, flags);
-	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
-	return;
-}
-
 /**************************************************************************
 * qla2xxx_eh_abort
 *
@@ -773,7 +756,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	struct req_que *req = vha->req;
 	srb_t *spt;
 
-	qla2x00_block_error_handler(cmd);
+	fc_block_scsi_eh(cmd);
 
 	if (!CMD_SP(cmd))
 		return SUCCESS;
@@ -904,7 +887,7 @@ __qla2xxx_eh_generic_reset(char *name, e
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	int err;
 
-	qla2x00_block_error_handler(cmd);
+	fc_block_scsi_eh(cmd);
 
 	if (!fcport)
 		return FAILED;
@@ -984,7 +967,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *c
 	unsigned long serial;
 	srb_t *sp = (srb_t *) CMD_SP(cmd);
 
-	qla2x00_block_error_handler(cmd);
+	fc_block_scsi_eh(cmd);
 
 	id = cmd->device->id;
 	lun = cmd->device->lun;
@@ -1047,7 +1030,7 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *
 	srb_t *sp = (srb_t *) CMD_SP(cmd);
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
-	qla2x00_block_error_handler(cmd);
+	fc_block_scsi_eh(cmd);
 
 	id = cmd->device->id;
 	lun = cmd->device->lun;

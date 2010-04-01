From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/2] scsi: Allow FC LLD to fast-fail scsi eh
Date: Thu, 01 Apr 2010 13:48:49 +0200
Message-ID: <20100401115739.677833000@de.ibm.com>
References: <20100401114848.628357000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:39650 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab0DAL5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2010 07:57:41 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.13.1/8.13.1) with ESMTP id o31BvekH010327
	for <linux-scsi@vger.kernel.org>; Thu, 1 Apr 2010 11:57:40 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o31BveQN995438
	for <linux-scsi@vger.kernel.org>; Thu, 1 Apr 2010 13:57:40 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o31BvdLQ021120
	for <linux-scsi@vger.kernel.org>; Thu, 1 Apr 2010 13:57:40 +0200
Content-Disposition: inline; filename=fast-fail-2.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

If the scsi eh is running and then a FC LLD calls
fc_remote_port_delete, the SCSI commands sent from the eh will fail.
To prevent this, a FC LLD can call fc_block_scsi_eh from the eh
callback, blocking the eh thread until the dev_loss_tmo fires or the
remote port is available again.

If (e.g. for a multipathing setup) the dev_loss_tmo is set to a very
large value, thus preventing the scsi device removal , the scsi eh can
block for a long time. For multipathing, the fast_io_fail_tmo is then
set to a low value to detect path problems sooner.

This patch introduces a new return code FAST_IO_FAIL. The function
fc_block_scsi_eh now returns FAST_IO_FAIL when the fast_io_fail_tmo
fires. This indicates that the LLD terminated all pending I/O requests
and there are no more pending SCSI commands for the scsi eh to wait
for. This return code can be passed back to the scsi eh to stop the
escalation and finish the recovery process for this device.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/scsi/scsi_error.c        |   15 ++++++++++-----
 drivers/scsi/scsi_transport_fc.c |   20 +++++++++++++++-----
 include/scsi/scsi.h              |    1 +
 include/scsi/scsi_transport_fc.h |    2 +-
 4 files changed, 27 insertions(+), 11 deletions(-)

--- a/drivers/scsi/scsi_error.c	2010-03-23 11:25:24.000000000 +0100
+++ b/drivers/scsi/scsi_error.c	2010-03-23 11:25:26.000000000 +0100
@@ -956,9 +956,10 @@ static int scsi_eh_abort_cmds(struct lis
 						  "0x%p\n", current->comm,
 						  scmd));
 		rtn = scsi_try_to_abort_cmd(scmd);
-		if (rtn == SUCCESS) {
+		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			scmd->eh_eflags &= ~SCSI_EH_CANCEL_CMD;
 			if (!scsi_device_online(scmd->device) ||
+			    rtn == FAST_IO_FAIL ||
 			    !scsi_eh_tur(scmd)) {
 				scsi_eh_finish_cmd(scmd, done_q);
 			}
@@ -1085,8 +1086,9 @@ static int scsi_eh_bus_device_reset(stru
 						  " 0x%p\n", current->comm,
 						  sdev));
 		rtn = scsi_try_bus_device_reset(bdr_scmd);
-		if (rtn == SUCCESS) {
+		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			if (!scsi_device_online(sdev) ||
+			    rtn == FAST_IO_FAIL ||
 			    !scsi_eh_tur(bdr_scmd)) {
 				list_for_each_entry_safe(scmd, next,
 							 work_q, eh_entry) {
@@ -1149,10 +1151,11 @@ static int scsi_eh_target_reset(struct S
 						  "to target %d\n",
 						  current->comm, id));
 		rtn = scsi_try_target_reset(tgtr_scmd);
-		if (rtn == SUCCESS) {
+		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (id == scmd_id(scmd))
 					if (!scsi_device_online(scmd->device) ||
+					    rtn == FAST_IO_FAIL ||
 					    !scsi_eh_tur(tgtr_scmd))
 						scsi_eh_finish_cmd(scmd,
 								   done_q);
@@ -1208,10 +1211,11 @@ static int scsi_eh_bus_reset(struct Scsi
 						  " %d\n", current->comm,
 						  channel));
 		rtn = scsi_try_bus_reset(chan_scmd);
-		if (rtn == SUCCESS) {
+		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (channel == scmd_channel(scmd))
 					if (!scsi_device_online(scmd->device) ||
+					    rtn == FAST_IO_FAIL ||
 					    !scsi_eh_tur(scmd))
 						scsi_eh_finish_cmd(scmd,
 								   done_q);
@@ -1245,9 +1249,10 @@ static int scsi_eh_host_reset(struct lis
 						  , current->comm));
 
 		rtn = scsi_try_host_reset(scmd);
-		if (rtn == SUCCESS) {
+		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (!scsi_device_online(scmd->device) ||
+				    rtn == FAST_IO_FAIL ||
 				    (!scsi_eh_try_stu(scmd) && !scsi_eh_tur(scmd)) ||
 				    !scsi_eh_tur(scmd))
 					scsi_eh_finish_cmd(scmd, done_q);
--- a/drivers/scsi/scsi_transport_fc.c	2010-03-23 11:25:24.000000000 +0100
+++ b/drivers/scsi/scsi_transport_fc.c	2010-03-23 11:26:16.000000000 +0100
@@ -3190,23 +3190,33 @@ fc_scsi_scan_rport(struct work_struct *w
  *
  * This routine can be called from a FC LLD scsi_eh callback. It
  * blocks the scsi_eh thread until the fc_rport leaves the
- * FC_PORTSTATE_BLOCKED. This is necessary to avoid the scsi_eh
- * failing recovery actions for blocked rports which would lead to
- * offlined SCSI devices.
+ * FC_PORTSTATE_BLOCKED, or the fast_io_fail_tmo fires. This is
+ * necessary to avoid the scsi_eh failing recovery actions for blocked
+ * rports which would lead to offlined SCSI devices.
+ *
+ * Returns: 0 if the fc_rport left the state FC_PORTSTATE_BLOCKED.
+ *	    FAST_IO_FAIL if the fast_io_fail_tmo fired, this should be
+ *	    passed back to scsi_eh.
  */
-void fc_block_scsi_eh(struct scsi_cmnd *cmnd)
+int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host *shost = cmnd->device->host;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
+	while (rport->port_state == FC_PORTSTATE_BLOCKED &&
+	       !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		msleep(1000);
 		spin_lock_irqsave(shost->host_lock, flags);
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
+		return FAST_IO_FAIL;
+
+	return 0;
 }
 EXPORT_SYMBOL(fc_block_scsi_eh);
 
--- a/include/scsi/scsi.h	2010-03-23 11:25:24.000000000 +0100
+++ b/include/scsi/scsi.h	2010-03-23 11:25:26.000000000 +0100
@@ -423,6 +423,7 @@ static inline int scsi_is_wlun(unsigned 
 #define ADD_TO_MLQUEUE  0x2006
 #define TIMEOUT_ERROR   0x2007
 #define SCSI_RETURN_NOT_HANDLED   0x2008
+#define FAST_IO_FAIL	0x2009
 
 /*
  * Midlevel queue return values.
--- a/include/scsi/scsi_transport_fc.h	2010-03-23 11:25:24.000000000 +0100
+++ b/include/scsi/scsi_transport_fc.h	2010-03-23 11:25:26.000000000 +0100
@@ -807,6 +807,6 @@ void fc_host_post_vendor_event(struct Sc
 struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 		struct fc_vport_identifiers *);
 int fc_vport_terminate(struct fc_vport *vport);
-void fc_block_scsi_eh(struct scsi_cmnd *cmnd);
+int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
 
 #endif /* SCSI_TRANSPORT_FC_H */


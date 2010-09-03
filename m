From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH] scsi, fcoe,
	libfc: drop scsi host_lock use from fc_queuecommand
Date: Fri, 03 Sep 2010 15:27:16 -0700
Message-ID: <20100903222715.6237.75737.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17975 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab0ICW1R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:27:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Joe Eykholt <jeykholt@cisco.com>, James Bottomley <James.Bottomley@sus>

Currently fc_queuecommand drops this lock very early on and then re-acquires
this lock just before return, this re-acquired lock gets dropped immediately
by its fast path caller scsi_dispatch_cmd, this re-acquire and then immediate
drop on each IO hits performance especially with small size IOs on multi-core
systems, this hit is significant about 25% with 512 bytes size IOs.

This lock is not needed in fc_queuecommand and calling fc_queuecommand
without this lock held removes above described performance hit.

So this patch adds unlocked_qcmds flag to drop host_lock before
calling only fc_queuecommand and removes re-acquire &  then drop
for  each IO. Added flag, drops this lock only if LLD wants such
as fcoe.ko does here for fc_queuecommand. This change won't affect
any existing LLD since added unlocked_qcmds flag will be zero
in those cases and their host lock uses would effectively remain
same after this patch.

As per Mike and Nab comments, restored host lock around SHOST_DEL state
in scsi_dispatch_cmd.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---
 drivers/scsi/fcoe/fcoe.c    |    1 +
 drivers/scsi/libfc/fc_fcp.c |   14 +++++---------
 drivers/scsi/scsi.c         |    7 ++++++-
 include/scsi/scsi_host.h    |    3 +++
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 844d618..280a4df 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -706,6 +706,7 @@ static int fcoe_shost_config(struct fc_lport *lport, struct device *dev)
 	lport->host->max_id = FCOE_MAX_FCP_TARGET;
 	lport->host->max_channel = 0;
 	lport->host->max_cmd_len = FCOE_MAX_CMD_LEN;
+	lport->host->unlocked_qcmds = 1;
 
 	if (lport->vport)
 		lport->host->transportt = fcoe_vport_transport_template;
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 43866e6..39b6bfa 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1751,8 +1751,7 @@ static inline int fc_fcp_lport_queue_ready(struct fc_lport *lport)
  * @cmd:   The scsi_cmnd to be executed
  * @done:  The callback function to be called when the scsi_cmnd is complete
  *
- * This is the i/o strategy routine, called by the SCSI layer. This routine
- * is called with the host_lock held.
+ * This is the i/o strategy routine, called by the SCSI layer.
  */
 int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 {
@@ -1770,9 +1769,8 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	if (rval) {
 		sc_cmd->result = rval;
 		done(sc_cmd);
-		return 0;
+		return rc;
 	}
-	spin_unlock_irq(lport->host->host_lock);
 
 	if (!*(struct fc_remote_port **)rport->dd_data) {
 		/*
@@ -1781,7 +1779,7 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 		 */
 		sc_cmd->result = DID_IMM_RETRY << 16;
 		done(sc_cmd);
-		goto out;
+		return rc;
 	}
 
 	rpriv = rport->dd_data;
@@ -1790,13 +1788,13 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 		if (lport->qfull)
 			fc_fcp_can_queue_ramp_down(lport);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
-		goto out;
+		return rc;
 	}
 
 	fsp = fc_fcp_pkt_alloc(lport, GFP_ATOMIC);
 	if (fsp == NULL) {
 		rc = SCSI_MLQUEUE_HOST_BUSY;
-		goto out;
+		return rc;
 	}
 
 	/*
@@ -1848,8 +1846,6 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 		fc_fcp_pkt_release(fsp);
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 	}
-out:
-	spin_lock_irq(lport->host->host_lock);
 	return rc;
 }
 EXPORT_SYMBOL(fc_queuecommand);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ad0ed21..3819d66 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -749,11 +749,16 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	if (unlikely(host->shost_state == SHOST_DEL)) {
 		cmd->result = (DID_NO_CONNECT << 16);
 		scsi_done(cmd);
+		spin_unlock_irqrestore(host->host_lock, flags);
 	} else {
 		trace_scsi_dispatch_cmd_start(cmd);
+		if (host->unlocked_qcmds)
+			spin_unlock_irqrestore(host->host_lock, flags);
 		rtn = host->hostt->queuecommand(cmd, scsi_done);
+		if (!host->unlocked_qcmds)
+			spin_unlock_irqrestore(host->host_lock, flags);
 	}
-	spin_unlock_irqrestore(host->host_lock, flags);
+
 	if (rtn) {
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b7bdecb..1814c51 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -636,6 +636,9 @@ struct Scsi_Host {
 	/* Asynchronous scan in progress */
 	unsigned async_scan:1;
 
+	/* call queuecommand without Scsi_Host lock held */
+	unsigned unlocked_qcmds:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */


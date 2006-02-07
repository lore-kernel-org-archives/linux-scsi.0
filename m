From: andrew.vasquez@qlogic.com
Subject: [PATCH 4/4] qla2xxx: Close window on race between rport removal and fcport transition.
Date: Tue, 7 Feb 2006 08:45:45 -0800
Message-ID: <113933074083-git-send-email-andrew.vasquez@qlogic.com>
References: <20060207163937.GC1405@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:28811 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1750855AbWBGQpq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 11:45:46 -0500
In-Reply-To: <20060207163937.GC1405@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Fcport visibility is recognized during interrupt time, but,
rport removal can only occur during a process
(sleeping)-context.  Return a DID_IMM_RETRY status for
commands submitted within this window to insure I/Os do not
prematurely run-out of retries.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_os.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

36a01169a75c52beab6427a5dc36146c8aaa19d4
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c4b6c34..9f91f1a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -366,6 +366,12 @@ qla2x00_queuecommand(struct scsi_cmnd *c
 		goto qc_fail_command;
 	}
 
+	/* Close window on fcport/rport state-transitioning. */
+	if (!*(fc_port_t **)rport->dd_data) {
+		cmd->result = DID_IMM_RETRY << 16;
+		goto qc_fail_command;
+	}
+
 	if (atomic_read(&fcport->state) != FCS_ONLINE) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
 		    atomic_read(&ha->loop_state) == LOOP_DEAD) {
@@ -421,6 +427,12 @@ qla24xx_queuecommand(struct scsi_cmnd *c
 		goto qc24_fail_command;
 	}
 
+	/* Close window on fcport/rport state-transitioning. */
+	if (!*(fc_port_t **)rport->dd_data) {
+		cmd->result = DID_IMM_RETRY << 16;
+		goto qc24_fail_command;
+	}
+
 	if (atomic_read(&fcport->state) != FCS_ONLINE) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
 		    atomic_read(&ha->loop_state) == LOOP_DEAD) {
@@ -1672,11 +1684,13 @@ qla2x00_schedule_rport_del(struct scsi_q
 		spin_lock_irqsave(&fcport->rport_lock, flags);
 		fcport->drport = rport;
 		fcport->rport = NULL;
+		*(fc_port_t **)rport->dd_data = NULL;
 		spin_unlock_irqrestore(&fcport->rport_lock, flags);
 		set_bit(FCPORT_UPDATE_NEEDED, &ha->dpc_flags);
 	} else {
 		spin_lock_irqsave(&fcport->rport_lock, flags);
 		fcport->rport = NULL;
+		*(fc_port_t **)rport->dd_data = NULL;
 		spin_unlock_irqrestore(&fcport->rport_lock, flags);
 		fc_remote_port_delete(rport);
 	}
-- 
1.1.6.ga2c6



From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [10/18] qla2xxx: Additional tape handling fixes
Date: Mon, 21 Jun 2004 22:55:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622055547.GA8453@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:46543 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266602AbUFVFwD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:52:03 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1846 04/06/16 11:40:12 andrew.vasquez@apc.qlogic.com +2 -0
  Issue a big-hammer after link-down-timeout expires in order
  properly return tape commands to the mid-layer.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_init.c |   16 ++++++++++------
 drivers/scsi/qla2xxx/qla_os.c   |   19 ++++++++++++++++++-
 2 files changed, 28 insertions(+), 7 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2004-06-21 15:38:44 -07:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2004-06-21 15:38:44 -07:00
@@ -4112,9 +4112,9 @@
 		    "Performing ISP error recovery - ha= %p.\n", ha);
 		qla2x00_reset_chip(ha);
 
+		atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
 		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
 			atomic_set(&ha->loop_state, LOOP_DOWN);
-			atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
 			qla2x00_mark_all_devices_lost(ha);
 		} else {
 			if (!atomic_read(&ha->loop_down_timer))
@@ -4131,23 +4131,27 @@
 				if (ha->actthreads)
 					ha->actthreads--;
 				sp->lun_queue->out_cnt--;
-				sp->flags = 0;
 
 				/*
 				 * Set the cmd host_byte status depending on
 				 * whether the scsi_error_handler is
 				 * active or not.
  				 */
-				if (ha->host->eh_active != EH_ACTIVE) {
-					sp->cmd->result = DID_BUS_BUSY << 16;
+				if (sp->flags & SRB_TAPE) {
+					sp->cmd->result = DID_NO_CONNECT << 16;
 				} else {
-					sp->cmd->result = DID_RESET << 16;
+					if (ha->host->eh_active != EH_ACTIVE)
+						sp->cmd->result =
+						    DID_BUS_BUSY << 16;
+					else
+						sp->cmd->result =
+						    DID_RESET << 16;
 				}
+				sp->flags = 0;
 				sp->cmd->host_scribble = (unsigned char *)NULL;
 				add_to_done_queue(ha, sp);
 			}
 		}
-
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 		qla2x00_nvram_config(ha);
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:38:44 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:38:44 -07:00
@@ -3609,6 +3609,8 @@
 	os_lun_t *lq;
 	os_tgt_t *tq;
 	int		start_dpc = 0;
+	int		index;
+	srb_t		*sp;
 
 	/*
 	 * We try and restart any request in the retry queue every second.
@@ -3712,7 +3714,6 @@
 	if (atomic_read(&ha->loop_down_timer) > 0 &&
 	    !(test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags)) && ha->flags.online) {
 
-		/* dg 10/30 if (atomic_read(&ha->loop_down_timer) == LOOP_DOWN_TIME) { */
 		if (atomic_read(&ha->loop_down_timer) ==
 		    ha->loop_down_abort_time) {
 
@@ -3722,6 +3723,22 @@
 
 			if (!IS_QLA2100(ha) && ha->link_down_timeout)
 				atomic_set(&ha->loop_state, LOOP_DEAD); 
+
+			/* Schedule an ISP abort to return any tape commands. */
+			spin_lock_irqsave(&ha->hardware_lock, cpu_flags);
+			for (index = 1; index < MAX_OUTSTANDING_COMMANDS;
+			    index++) {
+				sp = ha->outstanding_cmds[index];
+				if (!sp)
+					continue;
+				if (!(sp->fclun->fcport->flags &
+				    FCF_TAPE_PRESENT))
+					continue;
+
+				set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+				break;
+			}
+			spin_unlock_irqrestore(&ha->hardware_lock, cpu_flags);
 
 			set_bit(ABORT_QUEUES_NEEDED, &ha->dpc_flags);
 			start_dpc++;

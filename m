From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [6/15] qla2xxx:  Track error-state of SBRs
Date: Sun, 14 Mar 2004 00:24:55 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314082455.GA3423@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:10172 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263315AbUCNIWZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 03:22:25 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1662 04/03/01 09:39:39 andrew.vasquez@apc.qlogic.com +3 -0
  Consistenly track the error-state of a failed SRB.

  drivers/scsi/qla2xxx/qla_os.c
    1.10 04/03/01 09:37:21 andrew.vasquez@apc.qlogic.com +30 -13
    Set the error-state of a failed SRB.

  drivers/scsi/qla2xxx/qla_isr.c
    1.7 04/03/01 09:37:21 andrew.vasquez@apc.qlogic.com +4 -0
    Set the error-state of a failed SRB.

  drivers/scsi/qla2xxx/qla_def.h
    1.9 04/03/01 09:37:21 andrew.vasquez@apc.qlogic.com +4 -0
    Add error-state definitions.

 drivers/scsi/qla2xxx/qla_def.h |    4 +++
 drivers/scsi/qla2xxx/qla_isr.c |    4 +++
 drivers/scsi/qla2xxx/qla_os.c  |   43 ++++++++++++++++++++++++++++-------------
 3 files changed, 38 insertions(+), 13 deletions(-)

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/15_track_srb_state.patch

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	Fri Mar 12 17:07:39 2004
+++ b/drivers/scsi/qla2xxx/qla_def.h	Fri Mar 12 17:07:39 2004
@@ -265,6 +265,10 @@
 	/* Raw completion info for use by failover ? */
 	uint8_t	fo_retry_cnt;		/* Retry count this request */
 	uint8_t	err_id;			/* error id */
+#define SRB_ERR_PORT	1		/* Request failed -- "port down" */
+#define SRB_ERR_LOOP	2		/* Request failed -- "loop down" */
+#define SRB_ERR_DEVICE	3		/* Request failed -- "device error" */
+#define SRB_ERR_OTHER	4
 
 	/* Segment/entries counts */
 	uint16_t	req_cnt;	/* !0 indicates counts determined */
diff -Nru a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c	Fri Mar 12 17:07:39 2004
+++ b/drivers/scsi/qla2xxx/qla_isr.c	Fri Mar 12 17:07:39 2004
@@ -1139,6 +1139,10 @@
 		if ((sp->flags & SRB_IOCTL) ||
 		    atomic_read(&fcport->state) == FCS_DEVICE_DEAD) {
 			cp->result = DID_NO_CONNECT << 16;
+			if (atomic_read(&ha->loop_state) == LOOP_DOWN) 
+				sp->err_id = SRB_ERR_LOOP;
+			else
+				sp->err_id = SRB_ERR_PORT;
 			add_to_done_queue(ha, sp);
 		} else {
 			qla2x00_extend_timeout(cp, EXTEND_CMD_TIMEOUT);
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:07:39 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:07:39 2004
@@ -736,6 +736,7 @@
 	}
 
 	sp->fo_retry_cnt = 0;
+	sp->err_id = 0;
 
 	/* Generate LU queue on bus, target, LUN */
 	b = cmd->device->channel;
@@ -755,6 +756,7 @@
 
 	if (l >= ha->max_luns) {
 		cmd->result = DID_NO_CONNECT << 16;
+		sp->err_id = SRB_ERR_PORT;
 
 		spin_lock_irq(ha->host->host_lock);
 
@@ -801,6 +803,7 @@
 		    ha->host_no,t,l));
 
 		cmd->result = DID_NO_CONNECT << 16;
+		sp->err_id = SRB_ERR_PORT;
 
 		spin_lock_irq(ha->host->host_lock);
 
@@ -846,6 +849,11 @@
 		 * processing
 		 */
 		cmd->result = DID_NO_CONNECT << 16;
+		if (atomic_read(&ha2->loop_state) == LOOP_DOWN) 
+			sp->err_id = SRB_ERR_LOOP;
+		else
+			sp->err_id = SRB_ERR_PORT;
+
 		add_to_done_queue(ha, sp);
 		if (!list_empty(&ha->done_queue))
 			qla2x00_done(ha);
@@ -3253,6 +3261,11 @@
 
 					__del_from_retry_queue(ha, sp);
 					sp->cmd->result = DID_NO_CONNECT << 16;
+					if (atomic_read(&fcport->ha->loop_state) ==
+					    LOOP_DOWN) 
+						sp->err_id = SRB_ERR_LOOP;
+					else
+						sp->err_id = SRB_ERR_PORT;
 					sp->cmd->host_scribble =
 					    (unsigned char *) NULL;
 					__add_to_done_queue(ha, sp);
@@ -3940,6 +3953,10 @@
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
 		    atomic_read(&vis_ha->loop_state) == LOOP_DEAD) {
 			cmd->result = DID_NO_CONNECT << 16;
+			if (atomic_read(&fcport->ha->loop_state) == LOOP_DOWN) 
+				sp->err_id = SRB_ERR_LOOP;
+			else
+				sp->err_id = SRB_ERR_PORT;
 		} else {
 			cmd->result = DID_BUS_BUSY << 16;
 		}
@@ -3978,6 +3995,10 @@
 		    atomic_read(&dest_ha->loop_state) == LOOP_DEAD) {
 			qla2x00_extend_timeout(cmd, EXTEND_CMD_TIMEOUT);
 			cmd->result = DID_NO_CONNECT << 16;
+			if (atomic_read(&dest_ha->loop_state) == LOOP_DOWN) 
+				sp->err_id = SRB_ERR_LOOP;
+			else
+				sp->err_id = SRB_ERR_PORT;
 		} else {
 			cmd->result = DID_BUS_BUSY << 16;
 		}
@@ -4237,20 +4258,16 @@
 
 		/* If device is dead then send request back to OS */
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD) {
-
 			sp->cmd->result = DID_NO_CONNECT << 16;
-
-			if (!atomic_read(&dest_ha->loop_down_timer) &&
-			    atomic_read(&dest_ha->loop_state) == LOOP_DOWN) {
-				sp->err_id = 2;
-			} else {
-				sp->err_id = 1;
-			}
-			DEBUG3(printk("scsi(%ld): loop/port is down - "
-			    "pid=%ld, sp=%p loopid=0x%x queued to dest HBA "
-			    "scsi%ld.\n",
-			    dest_ha->host_no,
-			    sp->cmd->serial_number, sp,
+			if (atomic_read(&dest_ha->loop_state) == LOOP_DOWN) 
+				sp->err_id = SRB_ERR_LOOP;
+			else
+				sp->err_id = SRB_ERR_PORT;
+
+			DEBUG3(printk("scsi(%ld): loop/port is down - pid=%ld, "
+			    "sp=%p err_id=%d loopid=0x%x queued to dest HBA "
+			    "scsi%ld.\n", dest_ha->host_no,
+			    sp->cmd->serial_number, sp, sp->err_id,
 			    fcport->loop_id, dest_ha->host_no));
 			/* 
 			 * Initiate a failover - done routine will initiate.

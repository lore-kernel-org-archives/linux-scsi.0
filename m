From: giridhar.malavali@qlogic.com
Subject: [PATCH 1/4] qla2xxx: Correct FCP2 recovery handling.
Date: Tue, 12 Jan 2010 12:59:48 -0800
Message-ID: <1263329991-307-2-git-send-email-giridhar.malavali@qlogic.com>
References: <1263329991-307-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:54869 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753161Ab0ALU74 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2010 15:59:56 -0500
In-Reply-To: <1263329991-307-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

The driver did not account for non-tape devices needing to employ
proper FCP2 recovery.  Driver now checks the FCP2-capable flag
only, rather than using a midlayer-determined flag (TYPE_TAPE).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    3 +--
 drivers/scsi/qla2xxx/qla_init.c |   12 ++++++------
 drivers/scsi/qla2xxx/qla_os.c   |   12 ++++++------
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 608e675..1263d97 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1586,8 +1586,7 @@ typedef struct fc_port {
  */
 #define FCF_FABRIC_DEVICE	BIT_0
 #define FCF_LOGIN_NEEDED	BIT_1
-#define FCF_TAPE_PRESENT	BIT_2
-#define FCF_FCP2_DEVICE		BIT_3
+#define FCF_FCP2_DEVICE		BIT_2
 
 /* No loop ID flag. */
 #define FC_NO_LOOP_ID		0x1000
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b4a0eac..3f8e849 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -205,7 +205,7 @@ qla2x00_async_login_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 
 	switch (data[0]) {
 	case MBS_COMMAND_COMPLETE:
-		if (fcport->flags & FCF_TAPE_PRESENT)
+		if (fcport->flags & FCF_FCP2_DEVICE)
 			opts |= BIT_1;
 		rval = qla2x00_get_port_database(vha, fcport, opts);
 		if (rval != QLA_SUCCESS)
@@ -2726,7 +2726,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 
 		/*
 		 * Logout all previous fabric devices marked lost, except
-		 * tape devices.
+		 * FCP2 devices.
 		 */
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
@@ -2739,7 +2739,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 				qla2x00_mark_device_lost(vha, fcport,
 				    ql2xplogiabsentdevice, 0);
 				if (fcport->loop_id != FC_NO_LOOP_ID &&
-				    (fcport->flags & FCF_TAPE_PRESENT) == 0 &&
+				    (fcport->flags & FCF_FCP2_DEVICE) == 0 &&
 				    fcport->port_type != FCT_INITIATOR &&
 				    fcport->port_type != FCT_BROADCAST) {
 					ha->isp_ops->fabric_logout(vha,
@@ -3018,7 +3018,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 			fcport->d_id.b24 = new_fcport->d_id.b24;
 			fcport->flags |= FCF_LOGIN_NEEDED;
 			if (fcport->loop_id != FC_NO_LOOP_ID &&
-			    (fcport->flags & FCF_TAPE_PRESENT) == 0 &&
+			    (fcport->flags & FCF_FCP2_DEVICE) == 0 &&
 			    fcport->port_type != FCT_INITIATOR &&
 			    fcport->port_type != FCT_BROADCAST) {
 				ha->isp_ops->fabric_logout(vha, fcport->loop_id,
@@ -3272,9 +3272,9 @@ qla2x00_fabric_dev_login(scsi_qla_host_t *vha, fc_port_t *fcport,
 
 	rval = qla2x00_fabric_login(vha, fcport, next_loopid);
 	if (rval == QLA_SUCCESS) {
-		/* Send an ADISC to tape devices.*/
+		/* Send an ADISC to FCP2 devices.*/
 		opts = 0;
-		if (fcport->flags & FCF_TAPE_PRESENT)
+		if (fcport->flags & FCF_FCP2_DEVICE)
 			opts |= BIT_1;
 		rval = qla2x00_get_port_database(vha, fcport, opts);
 		if (rval != QLA_SUCCESS) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 209f50e..8529eb1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1188,7 +1188,6 @@ qla2xxx_slave_configure(struct scsi_device *sdev)
 	scsi_qla_host_t *vha = shost_priv(sdev->host);
 	struct qla_hw_data *ha = vha->hw;
 	struct fc_rport *rport = starget_to_rport(sdev->sdev_target);
-	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
 	struct req_que *req = vha->req;
 
 	if (sdev->tagged_supported)
@@ -1197,8 +1196,6 @@ qla2xxx_slave_configure(struct scsi_device *sdev)
 		scsi_deactivate_tcq(sdev, req->max_q_depth);
 
 	rport->dev_loss_tmo = ha->port_down_retry_count;
-	if (sdev->type == TYPE_TAPE)
-		fcport->flags |= FCF_TAPE_PRESENT;
 
 	return 0;
 }
@@ -2805,7 +2802,7 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 
 			fcport->login_retry--;
 			if (fcport->flags & FCF_FABRIC_DEVICE) {
-				if (fcport->flags & FCF_TAPE_PRESENT)
+				if (fcport->flags & FCF_FCP2_DEVICE)
 					ha->isp_ops->fabric_logout(vha,
 							fcport->loop_id,
 							fcport->d_id.b.domain,
@@ -3141,7 +3138,10 @@ qla2x00_timer(scsi_qla_host_t *vha)
 			if (!IS_QLA2100(ha) && vha->link_down_timeout)
 				atomic_set(&vha->loop_state, LOOP_DEAD);
 
-			/* Schedule an ISP abort to return any tape commands. */
+			/*
+			 * Schedule an ISP abort to return any FCP2-device
+			 * commands.
+			 */
 			/* NPIV - scan physical port only */
 			if (!vha->vp_idx) {
 				spin_lock_irqsave(&ha->hardware_lock,
@@ -3158,7 +3158,7 @@ qla2x00_timer(scsi_qla_host_t *vha)
 					if (sp->ctx)
 						continue;
 					sfcp = sp->fcport;
-					if (!(sfcp->flags & FCF_TAPE_PRESENT))
+					if (!(sfcp->flags & FCF_FCP2_DEVICE))
 						continue;
 
 					set_bit(ISP_ABORT_NEEDED,
-- 
1.6.2.rc1.30.gd43c


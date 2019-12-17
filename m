Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FEBC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A004F20716
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:07:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="lQ9TKm/R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfLQWHQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 17:07:16 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27766 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbfLQWHQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Dec 2019 17:07:16 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHM5aBm029957;
        Tue, 17 Dec 2019 14:07:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=hMzBdeJHnsXEx3qSI9rPmI7fx0K3Xgq/NgXMMlbI+j4=;
 b=lQ9TKm/Rzms1FExLmgsRpLsuUk8a/or54OeTqURnXEiswfZh3Ez3haSL6ynXc0tCodHP
 xC4rZW3MltOLDgeu87esSfuuPvXPmS8iJw6iQP85UEVawzamxbETFJ1XNf9+eYrDwu28
 PfM2Aq20hR9B5eLcoqbIQbd7z893hmfm9Sr4gI2F20tgs48M9n4iZkQldOBgOVxj5CV1
 UMwnLI2sSIRh5VaCLDmISz/fnEq0wg/fjuH90haJ/Pz6McXpdtxOoMyBJ4EiRN+rQm2t
 DEeWUpUJYI2letd/hvoyOuElWjCAPa17zU4x9oAIphKPEF0if+lApxvaDHYsWKvHsmF1 5Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wxn0wm22h-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 14:07:07 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Dec
 2019 14:06:20 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Dec 2019 14:06:20 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 097383F703F;
        Tue, 17 Dec 2019 14:06:21 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBHM6K7R028123;
        Tue, 17 Dec 2019 14:06:20 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBHM6KKg028122;
        Tue, 17 Dec 2019 14:06:20 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 01/14] qla2xxx: Remove defer flag to indicate immeadiate port loss
Date:   Tue, 17 Dec 2019 14:06:04 -0800
Message-ID: <20191217220617.28084-2-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191217220617.28084-1-hmadhani@marvell.com>
References: <20191217220617.28084-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_04:2019-12-17,2019-12-17 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During Cable pull test case, if the port is disconnected for time
larger than devloss timeout, driver does not mark path offline.
In such case, instead of notifying SCSI-ML of loop down, driver
goes into endless loop of device relogin because defer flag is set.

with newer handling of device relogin in driver discovery, defer
flag is now redundant. This patch removes defer flag and cleans up
code handling port lost indication to SCSI-ML.

Signed-off-by: Quinn Tran <qtran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h    |  4 +--
 drivers/scsi/qla2xxx/qla_init.c   | 18 ++++++-------
 drivers/scsi/qla2xxx/qla_isr.c    | 16 +++++------
 drivers/scsi/qla2xxx/qla_mid.c    |  6 ++---
 drivers/scsi/qla2xxx/qla_mr.c     | 10 +++----
 drivers/scsi/qla2xxx/qla_nx.c     |  2 +-
 drivers/scsi/qla2xxx/qla_os.c     | 57 ++++++++++++---------------------------
 drivers/scsi/qla2xxx/qla_target.c |  2 +-
 8 files changed, 45 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5b163ad85c34..51916183cbe9 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -253,8 +253,8 @@ extern scsi_qla_host_t *qla24xx_create_vhost(struct fc_vport *);
 extern void qla2x00_sp_free_dma(srb_t *sp);
 extern char *qla2x00_get_fw_version_str(struct scsi_qla_host *, char *);
 
-extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int, int);
-extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *, int);
+extern void qla2x00_mark_device_lost(scsi_qla_host_t *, fc_port_t *, int);
+extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *);
 
 extern struct fw_blob *qla2x00_request_firmware(scsi_qla_host_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index aa5204163bec..c689e34a5235 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -425,7 +425,7 @@ qla2x00_async_prlo_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 	fcport->flags &= ~FCF_ASYNC_ACTIVE;
 	/* Don't re-login in target mode */
 	if (!fcport->tgt_session)
-		qla2x00_mark_device_lost(vha, fcport, 1, 0);
+		qla2x00_mark_device_lost(vha, fcport, 1);
 	qlt_logo_completion_handler(fcport, data[0]);
 }
 
@@ -2000,7 +2000,7 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 		if (ea->data[1] & QLA_LOGIO_LOGIN_RETRIED)
 			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		else
-			qla2x00_mark_device_lost(vha, ea->fcport, 1, 0);
+			qla2x00_mark_device_lost(vha, ea->fcport, 1);
 		break;
 	case MBS_LOOP_ID_USED:
 		/* data[1] = IO PARAM 1 = nport ID  */
@@ -5230,7 +5230,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 			    qla_ini_mode_enabled(vha)) &&
 			    atomic_read(&fcport->state) == FCS_ONLINE) {
 				qla2x00_mark_device_lost(vha, fcport,
-					ql2xplogiabsentdevice, 0);
+					ql2xplogiabsentdevice);
 				if (fcport->loop_id != FC_NO_LOOP_ID &&
 				    (fcport->flags & FCF_FCP2_DEVICE) == 0 &&
 				    fcport->port_type != FCT_INITIATOR &&
@@ -5905,7 +5905,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 			    qla_ini_mode_enabled(vha)) &&
 			    atomic_read(&fcport->state) == FCS_ONLINE) {
 				qla2x00_mark_device_lost(vha, fcport,
-					ql2xplogiabsentdevice, 0);
+					ql2xplogiabsentdevice);
 				if (fcport->loop_id != FC_NO_LOOP_ID &&
 				    (fcport->flags & FCF_FCP2_DEVICE) == 0 &&
 				    fcport->port_type != FCT_INITIATOR &&
@@ -6071,7 +6071,7 @@ qla2x00_fabric_login(scsi_qla_host_t *vha, fc_port_t *fcport,
 			ha->isp_ops->fabric_logout(vha, fcport->loop_id,
 			    fcport->d_id.b.domain, fcport->d_id.b.area,
 			    fcport->d_id.b.al_pa);
-			qla2x00_mark_device_lost(vha, fcport, 1, 0);
+			qla2x00_mark_device_lost(vha, fcport, 1);
 
 			rval = 1;
 			break;
@@ -6585,9 +6585,9 @@ qla2x00_quiesce_io(scsi_qla_host_t *vha)
 	atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
 	if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 		atomic_set(&vha->loop_state, LOOP_DOWN);
-		qla2x00_mark_all_devices_lost(vha, 0);
+		qla2x00_mark_all_devices_lost(vha);
 		list_for_each_entry(vp, &ha->vp_list, list)
-			qla2x00_mark_all_devices_lost(vp, 0);
+			qla2x00_mark_all_devices_lost(vp);
 	} else {
 		if (!atomic_read(&vha->loop_down_timer))
 			atomic_set(&vha->loop_down_timer,
@@ -6663,14 +6663,14 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 	if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 		atomic_set(&vha->loop_state, LOOP_DOWN);
-		qla2x00_mark_all_devices_lost(vha, 0);
+		qla2x00_mark_all_devices_lost(vha);
 
 		spin_lock_irqsave(&ha->vport_slock, flags);
 		list_for_each_entry(vp, &ha->vp_list, list) {
 			atomic_inc(&vp->vref_count);
 			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
-			qla2x00_mark_all_devices_lost(vp, 0);
+			qla2x00_mark_all_devices_lost(vp);
 
 			spin_lock_irqsave(&ha->vport_slock, flags);
 			atomic_dec(&vp->vref_count);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 7b8a6bfcf08d..f60fb9c19c26 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -788,7 +788,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 			atomic_set(&vha->loop_state, LOOP_DOWN);
 			atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
-			qla2x00_mark_all_devices_lost(vha, 1);
+			qla2x00_mark_all_devices_lost(vha);
 		}
 
 		if (vha->vp_idx) {
@@ -861,7 +861,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			}
 
 			vha->device_flags |= DFLG_NO_CABLE;
-			qla2x00_mark_all_devices_lost(vha, 1);
+			qla2x00_mark_all_devices_lost(vha);
 		}
 
 		if (vha->vp_idx) {
@@ -881,7 +881,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 			atomic_set(&vha->loop_state, LOOP_DOWN);
 			atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
-			qla2x00_mark_all_devices_lost(vha, 1);
+			qla2x00_mark_all_devices_lost(vha);
 		}
 
 		if (vha->vp_idx) {
@@ -924,7 +924,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 				atomic_set(&vha->loop_down_timer,
 				    LOOP_DOWN_TIME);
 			if (!N2N_TOPO(ha))
-				qla2x00_mark_all_devices_lost(vha, 1);
+				qla2x00_mark_all_devices_lost(vha);
 		}
 
 		if (vha->vp_idx) {
@@ -953,7 +953,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			if (!atomic_read(&vha->loop_down_timer))
 				atomic_set(&vha->loop_down_timer,
 				    LOOP_DOWN_TIME);
-			qla2x00_mark_all_devices_lost(vha, 1);
+			qla2x00_mark_all_devices_lost(vha);
 		}
 
 		if (vha->vp_idx) {
@@ -1022,7 +1022,6 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			    "Marking port lost loopid=%04x portid=%06x.\n",
 			    fcport->loop_id, fcport->d_id.b24);
 			if (qla_ini_mode_enabled(vha)) {
-				qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
 				fcport->logout_on_delete = 0;
 				qlt_schedule_sess_for_deletion(fcport);
 			}
@@ -1034,14 +1033,14 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 				atomic_set(&vha->loop_down_timer,
 				    LOOP_DOWN_TIME);
 				vha->device_flags |= DFLG_NO_CABLE;
-				qla2x00_mark_all_devices_lost(vha, 1);
+				qla2x00_mark_all_devices_lost(vha);
 			}
 
 			if (vha->vp_idx) {
 				atomic_set(&vha->vp_state, VP_FAILED);
 				fc_vport_set_state(vha->fc_vport,
 				    FC_VPORT_FAILED);
-				qla2x00_mark_all_devices_lost(vha, 1);
+				qla2x00_mark_all_devices_lost(vha);
 			}
 
 			vha->flags.management_server_logged_in = 0;
@@ -2745,7 +2744,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 				port_state_str[FCS_ONLINE],
 				comp_status);
 
-			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
 			qlt_schedule_sess_for_deletion(fcport);
 		}
 
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index eabc5127174e..8ae639d089d1 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -147,7 +147,7 @@ qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
 		    "Marking port dead, loop_id=0x%04x : %x.\n",
 		    fcport->loop_id, fcport->vha->vp_idx);
 
-		qla2x00_mark_device_lost(vha, fcport, 0, 0);
+		qla2x00_mark_device_lost(vha, fcport, 0);
 		qla2x00_set_fcport_state(fcport, FCS_UNCONFIGURED);
 	}
 }
@@ -167,7 +167,7 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
 	list_for_each_entry(fcport, &vha->vp_fcports, list)
 		fcport->logout_on_delete = 0;
 
-	qla2x00_mark_all_devices_lost(vha, 0);
+	qla2x00_mark_all_devices_lost(vha);
 
 	/* Remove port id from vp target map */
 	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
@@ -327,7 +327,7 @@ qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 	 */
 	if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
 		atomic_set(&vha->loop_state, LOOP_DOWN);
-		qla2x00_mark_all_devices_lost(vha, 0);
+		qla2x00_mark_all_devices_lost(vha);
 	} else {
 		if (!atomic_read(&vha->loop_down_timer))
 			atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 605b59c76c90..cb830d79cfbe 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1210,7 +1210,7 @@ qlafx00_find_all_targets(scsi_qla_host_t *vha,
 				    " Existing TGT-ID %x did not get "
 				    " offline event from firmware.\n",
 				    fcport->old_tgt_id);
-				qla2x00_mark_device_lost(vha, fcport, 0, 0);
+				qla2x00_mark_device_lost(vha, fcport, 0);
 				set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 				kfree(new_fcport);
 				return rval;
@@ -1274,7 +1274,7 @@ qlafx00_configure_all_targets(scsi_qla_host_t *vha)
 
 		if (atomic_read(&fcport->state) == FCS_DEVICE_LOST) {
 			if (fcport->port_type != FCT_INITIATOR)
-				qla2x00_mark_device_lost(vha, fcport, 0, 0);
+				qla2x00_mark_device_lost(vha, fcport, 0);
 		}
 	}
 
@@ -1706,7 +1706,7 @@ qlafx00_tgt_detach(struct scsi_qla_host *vha, int tgt_id)
 	if (!fcport)
 		return;
 
-	qla2x00_mark_device_lost(vha, fcport, 0, 0);
+	qla2x00_mark_device_lost(vha, fcport, 0);
 
 	return;
 }
@@ -1740,7 +1740,7 @@ qlafx00_process_aen(struct scsi_qla_host *vha, struct qla_work_evt *evt)
 				set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 			} else if (evt->u.aenfx.mbx[2] == 2) {
 				vha->device_flags |= DFLG_NO_CABLE;
-				qla2x00_mark_all_devices_lost(vha, 1);
+				qla2x00_mark_all_devices_lost(vha);
 			}
 		}
 		break;
@@ -2513,7 +2513,7 @@ qlafx00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		    atomic_read(&fcport->state));
 
 		if (atomic_read(&fcport->state) == FCS_ONLINE)
-			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
+			qla2x00_mark_device_lost(fcport->vha, fcport, 1);
 		break;
 
 	case CS_ABORTED:
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 2b2028f2383e..30be084ccc1b 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3030,7 +3030,7 @@ qla8xxx_dev_failed_handler(scsi_qla_host_t *vha)
 	/* Set DEV_FAILED flag to disable timer */
 	vha->device_flags |= DFLG_DEV_FAILED;
 	qla2x00_abort_all_cmds(vha, DID_NO_CONNECT << 16);
-	qla2x00_mark_all_devices_lost(vha, 0);
+	qla2x00_mark_all_devices_lost(vha);
 	vha->flags.online = 0;
 	vha->flags.init_done = 0;
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8b84bc4a6ac8..936036375f73 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1110,7 +1110,7 @@ qla2x00_wait_for_sess_deletion(scsi_qla_host_t *vha)
 {
 	u8 i;
 
-	qla2x00_mark_all_devices_lost(vha, 0);
+	qla2x00_mark_all_devices_lost(vha);
 
 	for (i = 0; i < 10; i++) {
 		if (wait_event_timeout(vha->fcport_waitQ,
@@ -1667,7 +1667,7 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 	if (ha->flags.enable_lip_full_login && !IS_CNA_CAPABLE(ha)) {
 		atomic_set(&vha->loop_state, LOOP_DOWN);
 		atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
-		qla2x00_mark_all_devices_lost(vha, 0);
+		qla2x00_mark_all_devices_lost(vha);
 		ret = qla2x00_full_login_lip(vha);
 		if (ret != QLA_SUCCESS) {
 			ql_dbg(ql_dbg_taskm, vha, 0x802d,
@@ -3854,37 +3854,21 @@ void qla2x00_free_fcports(struct scsi_qla_host *vha)
 }
 
 static inline void
-qla2x00_schedule_rport_del(struct scsi_qla_host *vha, fc_port_t *fcport,
-    int defer)
+qla2x00_schedule_rport_del(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
-	struct fc_rport *rport;
-	scsi_qla_host_t *base_vha;
-	unsigned long flags;
+	int now;
 
 	if (!fcport->rport)
 		return;
 
-	rport = fcport->rport;
-	if (defer) {
-		base_vha = pci_get_drvdata(vha->hw->pdev);
-		spin_lock_irqsave(vha->host->host_lock, flags);
-		fcport->drport = rport;
-		spin_unlock_irqrestore(vha->host->host_lock, flags);
-		qlt_do_generation_tick(vha, &base_vha->total_fcport_update_gen);
-		set_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags);
-		qla2xxx_wake_dpc(base_vha);
-	} else {
-		int now;
-
-		if (rport) {
-			ql_dbg(ql_dbg_disc, fcport->vha, 0x2109,
-			    "%s %8phN. rport %p roles %x\n",
-			    __func__, fcport->port_name, rport,
-			    rport->roles);
-			fc_remote_port_delete(rport);
-		}
-		qlt_do_generation_tick(vha, &now);
+	if (fcport->rport) {
+		ql_dbg(ql_dbg_disc, fcport->vha, 0x2109,
+		    "%s %8phN. rport %p roles %x\n",
+		    __func__, fcport->port_name, fcport->rport,
+		    fcport->rport->roles);
+		fc_remote_port_delete(fcport->rport);
 	}
+	qlt_do_generation_tick(vha, &now);
 }
 
 /*
@@ -3897,18 +3881,18 @@ qla2x00_schedule_rport_del(struct scsi_qla_host *vha, fc_port_t *fcport,
  * Context:
  */
 void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
-    int do_login, int defer)
+    int do_login)
 {
 	if (IS_QLAFX00(vha->hw)) {
 		qla2x00_set_fcport_state(fcport, FCS_DEVICE_LOST);
-		qla2x00_schedule_rport_del(vha, fcport, defer);
+		qla2x00_schedule_rport_del(vha, fcport);
 		return;
 	}
 
 	if (atomic_read(&fcport->state) == FCS_ONLINE &&
 	    vha->vp_idx == fcport->vha->vp_idx) {
 		qla2x00_set_fcport_state(fcport, FCS_DEVICE_LOST);
-		qla2x00_schedule_rport_del(vha, fcport, defer);
+		qla2x00_schedule_rport_del(vha, fcport);
 	}
 	/*
 	 * We may need to retry the login, so don't change the state of the
@@ -3937,7 +3921,7 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
  * Context:
  */
 void
-qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha, int defer)
+qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha)
 {
 	fc_port_t *fcport;
 
@@ -3957,13 +3941,6 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha, int defer)
 		 */
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD)
 			continue;
-		if (atomic_read(&fcport->state) == FCS_ONLINE) {
-			qla2x00_set_fcport_state(fcport, FCS_DEVICE_LOST);
-			if (defer)
-				qla2x00_schedule_rport_del(vha, fcport, defer);
-			else if (vha->vp_idx == fcport->vha->vp_idx)
-				qla2x00_schedule_rport_del(vha, fcport, defer);
-		}
 	}
 }
 
@@ -6899,13 +6876,13 @@ static void qla_pci_error_cleanup(scsi_qla_host_t *vha)
 		qpair->online = 0;
 	mutex_unlock(&ha->mq_lock);
 
-	qla2x00_mark_all_devices_lost(vha, 0);
+	qla2x00_mark_all_devices_lost(vha);
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	list_for_each_entry(vp, &ha->vp_list, list) {
 		atomic_inc(&vp->vref_count);
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
-		qla2x00_mark_all_devices_lost(vp, 0);
+		qla2x00_mark_all_devices_lost(vp);
 		spin_lock_irqsave(&ha->vport_slock, flags);
 		atomic_dec(&vp->vref_count);
 	}
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 68c14143e50e..a43f7c9463c8 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -966,7 +966,7 @@ void qlt_free_session_done(struct work_struct *work)
 		sess->send_els_logo);
 
 	if (!IS_SW_RESV_ADDR(sess->d_id)) {
-		qla2x00_mark_device_lost(vha, sess, 0, 0);
+		qla2x00_mark_device_lost(vha, sess, 0);
 
 		if (sess->send_els_logo) {
 			qlt_port_logo_t logo;
-- 
2.12.0


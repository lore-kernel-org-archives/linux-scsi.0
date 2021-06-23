Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E66CEC4743C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 10:29:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CACA460BD3
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 10:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhFWKbV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 06:31:21 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54842 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230031AbhFWKbU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Jun 2021 06:31:20 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15NABgo6008236
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 03:29:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=gMcOUEONHNWO0DaW1+isXieJhpiz4oQWiG36AnCQNAI=;
 b=Gvz19n68krez/t1/coeH0t3PZQ25JOhwDX4+vSLY90265X4Q003w3uwc00AHfJpLEPUq
 1cM0kSuHxzEElMY0MfrY1K3HB70aehnJuhykZop8hOUKpqV9zM4blRZv53lpklvp9zKG
 T7cH6i25gcHwwsyYKPGfCeZt7dCEwRIlGkA5m2v0dgsjTgFjfwpc6UzNthsOS2Q1aTC7
 AiGngll3vrirsjXLtMlrUPBKpiZ2axgxKYazJXGza8Py7Ixc41cPJZ5g4Nhuo555YLkL
 uHnl2iMaTkyRUkiBxeYDdisrFBhBthuw/pjF8gZTV/+RqcW+3iQ70sa2XGyYAn3mEtNk iQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 39bx5j946d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jun 2021 03:29:02 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 23 Jun
 2021 03:29:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 23 Jun 2021 03:29:00 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E9DBF5B6947;
        Wed, 23 Jun 2021 03:29:00 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 15NAT0LX003720;
        Wed, 23 Jun 2021 03:29:00 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 15NAT0Pk003711;
        Wed, 23 Jun 2021 03:29:00 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 06/11] qla2xxx: Add authentication pass + fail bsg's
Date:   Wed, 23 Jun 2021 03:26:06 -0700
Message-ID: <20210623102611.3637-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210623102611.3637-1-njavali@marvell.com>
References: <20210623102611.3637-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: EjDikW4Es-VvLOG5wvmCa7hQCX5sv_83
X-Proofpoint-GUID: EjDikW4Es-VvLOG5wvmCa7hQCX5sv_83
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_03:2021-06-23,2021-06-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Latest FC adapter from Marvell has the ability to encrypt
data in flight (EDIF) feature. This feature require an
application (ex: ipsec, etc) to act as an authenticator.

On completion of the authentication process, the authentication
application will notify driver on whether it is successful or not.

If success, application will use the QL_VND_SC_AUTH_OK BSG call
to tell driver to proceed to the PRLI phase.

If fail, application will use the QL_VND_SC_AUTH_FAIL bsg call
to tell driver to tear down the connection and retry. In
the case where an existing session is active, the re-key
process can fail. The session tear down ensure data is not
further compromise.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Larry Wisneski <Larry.Wisneski@marvell.com>
Signed-off-by: Duane Grigsby <duane.grigsby@marvell.com>
Signed-off-by: Rick Hicksted Jr <rhicksted@marvell.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 213 +++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_gbl.h  |   1 +
 drivers/scsi/qla2xxx/qla_init.c |   3 +-
 3 files changed, 209 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 15f9e10ac257..8f486bd1201f 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -656,6 +656,204 @@ qla_edif_app_stop(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	return rval;
 }
 
+static int
+qla_edif_app_chk_sa_update(scsi_qla_host_t *vha, fc_port_t *fcport,
+		struct app_plogi_reply *appplogireply)
+{
+	int	ret = 0;
+
+	if (!(fcport->edif.rx_sa_set && fcport->edif.tx_sa_set)) {
+		ql_dbg(ql_dbg_edif, vha, 0x911e,
+		    "%s: wwpn %8phC Both SA indexes has not been SET TX %d, RX %d.\n",
+		    __func__, fcport->port_name, fcport->edif.tx_sa_set,
+		    fcport->edif.rx_sa_set);
+		appplogireply->prli_status = 0;
+		ret = 1;
+	} else  {
+		ql_dbg(ql_dbg_edif, vha, 0x911e,
+		    "%s wwpn %8phC Both SA(s) updated.\n", __func__,
+		    fcport->port_name);
+		fcport->edif.rx_sa_set = fcport->edif.tx_sa_set = 0;
+		fcport->edif.rx_sa_pending = fcport->edif.tx_sa_pending = 0;
+		appplogireply->prli_status = 1;
+	}
+	return ret;
+}
+
+/**
+ * qla_edif_app_authok - authentication by app succeeded.  Driver can proceed
+ *   with prli
+ * @vha: host adapter pointer
+ * @bsg_job: user request
+ */
+static int
+qla_edif_app_authok(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
+{
+	int32_t			rval = 0;
+	struct auth_complete_cmd appplogiok;
+	struct app_plogi_reply	appplogireply = {0};
+	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
+	fc_port_t		*fcport = NULL;
+	port_id_t		portid = {0};
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, &appplogiok,
+	    sizeof(struct auth_complete_cmd));
+
+	switch (appplogiok.type) {
+	case PL_TYPE_WWPN:
+		fcport = qla2x00_find_fcport_by_wwpn(vha,
+		    appplogiok.u.wwpn, 0);
+		if (!fcport)
+			ql_dbg(ql_dbg_edif, vha, 0x911d,
+			    "%s wwpn lookup failed: %8phC\n",
+			    __func__, appplogiok.u.wwpn);
+		break;
+	case PL_TYPE_DID:
+		fcport = qla2x00_find_fcport_by_pid(vha, &appplogiok.u.d_id);
+		if (!fcport)
+			ql_dbg(ql_dbg_edif, vha, 0x911d,
+			    "%s d_id lookup failed: %x\n", __func__,
+			    portid.b24);
+		break;
+	default:
+		ql_dbg(ql_dbg_edif, vha, 0x911d,
+		    "%s undefined type: %x\n", __func__,
+		    appplogiok.type);
+		break;
+	}
+
+	if (!fcport) {
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		goto errstate_exit;
+	}
+
+	/*
+	 * if port is online then this is a REKEY operation
+	 * Only do sa update checking
+	 */
+	if (atomic_read(&fcport->state) == FCS_ONLINE) {
+		ql_dbg(ql_dbg_edif, vha, 0x911d,
+		    "%s Skipping PRLI complete based on rekey\n", __func__);
+		appplogireply.prli_status = 1;
+		SET_DID_STATUS(bsg_reply->result, DID_OK);
+		qla_edif_app_chk_sa_update(vha, fcport, &appplogireply);
+		goto errstate_exit;
+	}
+
+	/* make sure in AUTH_PENDING or else reject */
+	if (fcport->disc_state != DSC_LOGIN_AUTH_PEND) {
+		ql_dbg(ql_dbg_edif, vha, 0x911e,
+		    "%s wwpn %8phC is not in auth pending state (%x)\n",
+		    __func__, fcport->port_name, fcport->disc_state);
+		SET_DID_STATUS(bsg_reply->result, DID_OK);
+		appplogireply.prli_status = 0;
+		goto errstate_exit;
+	}
+
+	SET_DID_STATUS(bsg_reply->result, DID_OK);
+	appplogireply.prli_status = 1;
+	if (!(fcport->edif.rx_sa_set && fcport->edif.tx_sa_set)) {
+		ql_dbg(ql_dbg_edif, vha, 0x911e,
+		    "%s: wwpn %8phC Both SA indexes has not been SET TX %d, RX %d.\n",
+		    __func__, fcport->port_name, fcport->edif.tx_sa_set,
+		    fcport->edif.rx_sa_set);
+		SET_DID_STATUS(bsg_reply->result, DID_OK);
+		appplogireply.prli_status = 0;
+		goto errstate_exit;
+
+	} else {
+		ql_dbg(ql_dbg_edif, vha, 0x911e,
+		    "%s wwpn %8phC Both SA(s) updated.\n", __func__,
+		    fcport->port_name);
+		fcport->edif.rx_sa_set = fcport->edif.tx_sa_set = 0;
+		fcport->edif.rx_sa_pending = fcport->edif.tx_sa_pending = 0;
+	}
+
+	if (qla_ini_mode_enabled(vha)) {
+		ql_dbg(ql_dbg_edif, vha, 0x911e,
+		    "%s AUTH complete - RESUME with prli for wwpn %8phC\n",
+		    __func__, fcport->port_name);
+		qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 1);
+		qla24xx_post_prli_work(vha, fcport);
+	}
+
+errstate_exit:
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, &appplogireply,
+	    sizeof(struct app_plogi_reply));
+
+	return rval;
+}
+
+/**
+ * qla_edif_app_authfail - authentication by app has failed.  Driver is given
+ *   notice to tear down current session.
+ * @vha: host adapter pointer
+ * @bsg_job: user request
+ */
+static int
+qla_edif_app_authfail(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
+{
+	int32_t			rval = 0;
+	struct auth_complete_cmd appplogifail;
+	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
+	fc_port_t		*fcport = NULL;
+	port_id_t		portid = {0};
+
+	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app auth fail\n", __func__);
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, &appplogifail,
+	    sizeof(struct auth_complete_cmd));
+
+	/*
+	 * TODO: edif: app has failed this plogi. Inform driver to
+	 * take any action (if any).
+	 */
+	switch (appplogifail.type) {
+	case PL_TYPE_WWPN:
+		fcport = qla2x00_find_fcport_by_wwpn(vha,
+		    appplogifail.u.wwpn, 0);
+		SET_DID_STATUS(bsg_reply->result, DID_OK);
+		break;
+	case PL_TYPE_DID:
+		fcport = qla2x00_find_fcport_by_pid(vha, &appplogifail.u.d_id);
+		if (!fcport)
+			ql_dbg(ql_dbg_edif, vha, 0x911d,
+			    "%s d_id lookup failed: %x\n", __func__,
+			    portid.b24);
+		SET_DID_STATUS(bsg_reply->result, DID_OK);
+		break;
+	default:
+		ql_dbg(ql_dbg_edif, vha, 0x911e,
+		    "%s undefined type: %x\n", __func__,
+		    appplogifail.type);
+		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		rval = -1;
+		break;
+	}
+
+	ql_dbg(ql_dbg_edif, vha, 0x911d,
+	    "%s fcport is 0x%p\n", __func__, fcport);
+
+	if (fcport) {
+		/* set/reset edif values and flags */
+		ql_dbg(ql_dbg_edif, vha, 0x911e,
+		    "%s reset the auth process - %8phC, loopid=%x portid=%06x.\n",
+		    __func__, fcport->port_name, fcport->loop_id, fcport->d_id.b24);
+
+		if (qla_ini_mode_enabled(fcport->vha)) {
+			fcport->send_els_logo = 1;
+			qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
+		}
+	}
+
+	return rval;
+}
+
 /**
  * qla_edif_app_getfcinfo - app would like to read session info (wwpn, nportid,
  *   [initiator|target] mode.  It can specific session with specific nport id or
@@ -697,8 +895,7 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			tdid = app_req.remote_pid;
 
 			ql_dbg(ql_dbg_edif, vha, 0x2058,
-			    "APP request entry - portid=%06x.\n",
-			    tdid.b24);
+			    "APP request entry - portid=%06x.\n", tdid.b24);
 
 			/* Ran out of space */
 			if (pcnt > app_req.num_ports)
@@ -719,10 +916,8 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			app_reply->ports[pcnt].remote_pid = fcport->d_id;
 
 			ql_dbg(ql_dbg_edif, vha, 0x2058,
-			    "Found FC_SP fcport - nn %8phN pn %8phN pcnt %d portid=%02x%02x%02x.\n",
-			    fcport->node_name, fcport->port_name, pcnt,
-			    fcport->d_id.b.domain, fcport->d_id.b.area,
-			    fcport->d_id.b.al_pa);
+			    "Found FC_SP fcport - nn %8phN pn %8phN pcnt %d portid=%06x\n",
+			    fcport->node_name, fcport->port_name, pcnt, fcport->d_id.b24);
 
 			switch (fcport->edif.auth_state) {
 			case VND_CMD_AUTH_STATE_ELS_RCVD:
@@ -888,6 +1083,12 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
 	case QL_VND_SC_APP_STOP:
 		rval = qla_edif_app_stop(vha, bsg_job);
 		break;
+	case QL_VND_SC_AUTH_OK:
+		rval = qla_edif_app_authok(vha, bsg_job);
+		break;
+	case QL_VND_SC_AUTH_FAIL:
+		rval = qla_edif_app_authfail(vha, bsg_job);
+		break;
 	case QL_VND_SC_GET_FCINFO:
 		rval = qla_edif_app_getfcinfo(vha, bsg_job);
 		break;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index e7c5143c66ef..d9d554101788 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -12,6 +12,7 @@
  * Global Function Prototypes in qla_init.c source file.
  */
 extern int qla2x00_initialize_adapter(scsi_qla_host_t *);
+extern int qla24xx_post_prli_work(struct scsi_qla_host *vha, fc_port_t *fcport);
 
 extern int qla2100_pci_config(struct scsi_qla_host *);
 extern int qla2300_pci_config(struct scsi_qla_host *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 663182f16471..71f6c76be401 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -34,7 +34,6 @@ static int qla2x00_restart_isp(scsi_qla_host_t *);
 static struct qla_chip_state_84xx *qla84xx_get_chip(struct scsi_qla_host *);
 static int qla84xx_init_chip(scsi_qla_host_t *);
 static int qla25xx_init_queues(struct qla_hw_data *);
-static int qla24xx_post_prli_work(struct scsi_qla_host*, fc_port_t *);
 static void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha,
 				      struct event_arg *ea);
 static void qla24xx_handle_prli_done_event(struct scsi_qla_host *,
@@ -1191,7 +1190,7 @@ static void qla24xx_async_gpdb_sp_done(srb_t *sp, int res)
 	sp->free(sp);
 }
 
-static int qla24xx_post_prli_work(struct scsi_qla_host *vha, fc_port_t *fcport)
+int qla24xx_post_prli_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
 	struct qla_work_evt *e;
 
-- 
2.19.0.rc0


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A20C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 07:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18B1161186
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 07:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhEaHLF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 03:11:05 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56750 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230070AbhEaHLF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 May 2021 03:11:05 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14V76C1c026554
        for <linux-scsi@vger.kernel.org>; Mon, 31 May 2021 00:09:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=/ihdyBIPIjMnilLT4yo7MLLDTpaTkMzYfOijGKHANDs=;
 b=cnqaCHK/R2pneuiS0DZq0wV63ckJ7lL84NdCgzKpnnpXovsMh0yqKhbrwIJPPqlRorGR
 W/uTxVKLe87eDryF/TeqEI2FkI2CrC2BibwEe+j3AGu+rqlGzaqCiz6hcTC0XZI60dVo
 LJ2Te65VgcX6MxOvQT8CFKVkPN2Jgc0oOQg2azvOFKzoMhynczAr1WuE+wQrpLwZ7YN0
 oIcdg1ngfSUApvLLLy7SniynB/DoCc2LOniDU5vIAQNCaIVN7o4rsNKSh8Ase0hHjJ1S
 YirXSUHFkuIKoNpYQBx475ZMRtL9pzHnRbXs+Kgw9PDdvdfxt/ali0nuwnL6GEDxYlaR kA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 38vtnj82pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 31 May 2021 00:09:25 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 May
 2021 00:09:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 31 May 2021 00:09:23 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 195BD3F703F;
        Mon, 31 May 2021 00:09:23 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 14V79MpU032165;
        Mon, 31 May 2021 00:09:22 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 14V79MaL032164;
        Mon, 31 May 2021 00:09:22 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 08/10] qla2xxx: Add doorbell notification for app
Date:   Mon, 31 May 2021 00:05:43 -0700
Message-ID: <20210531070545.32072-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210531070545.32072-1-njavali@marvell.com>
References: <20210531070545.32072-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: C-lWbIL2c_A7wdVEuun1F3lCa0hYhGTM
X-Proofpoint-ORIG-GUID: C-lWbIL2c_A7wdVEuun1F3lCa0hYhGTM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_04:2021-05-31,2021-05-31 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Latest FC adapter from Marvell has the ability to encrypt
data in flight (EDIF) feature. This feature require an
application (ex: ipsec, etc) to act as an authenticator.

During runtime, driver and authentication application needs
to stay in sync in terms of: session being down|up, arrival of
new authentication message(AUTH ELS) and SADB update completion.

These events are queued up as doorbell to the authentication
application. Application would read this doorbell on regular
basis to stay up to date. Each SCSI host would have a separate
doorbell queue.

The doorbell interface can daisy chain a list of events for
each read. Each event contains an event code + hint to help
application steer the next course of action.

Signed-off-by: Larry Wisneski <Larry.Wisneski@marvell.com>
Signed-off-by: Duane Grigsby <duane.grigsby@marvell.com>
Signed-off-by: Rick Hicksted Jr <rhicksted@marvell.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   |   4 +
 drivers/scsi/qla2xxx/qla_bsg.c    |  24 ++-
 drivers/scsi/qla2xxx/qla_edif.c   | 342 ++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h    |   4 +
 drivers/scsi/qla2xxx/qla_init.c   |   3 +
 drivers/scsi/qla2xxx/qla_os.c     |   4 +
 drivers/scsi/qla2xxx/qla_target.c |   2 +
 7 files changed, 379 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index d78db2949ef6..22191e9a04a0 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2435,6 +2435,7 @@ static DEVICE_ATTR(port_speed, 0644, qla2x00_port_speed_show,
     qla2x00_port_speed_store);
 static DEVICE_ATTR(port_no, 0444, qla2x00_port_no_show, NULL);
 static DEVICE_ATTR(fw_attr, 0444, qla2x00_fw_attr_show, NULL);
+static DEVICE_ATTR_RO(edif_doorbell);
 
 
 struct device_attribute *qla2x00_host_attrs[] = {
@@ -2480,6 +2481,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_port_no,
 	&dev_attr_fw_attr,
 	&dev_attr_dport_diagnostics,
+	&dev_attr_edif_doorbell,
 	NULL, /* reserve for qlini_mode */
 	NULL, /* reserve for ql2xiniexchg */
 	NULL, /* reserve for ql2xexchoffld */
@@ -3108,6 +3110,8 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 
 	qla_nvme_delete(vha);
 	qla_enode_stop(vha);
+	qla_edb_stop(vha);
+
 	vha->flags.delete_progress = 1;
 
 	qlt_remove_target(ha, vha);
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 2d43603e31ec..0739f8ad525a 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2784,10 +2784,13 @@ qla2x00_manage_host_port(struct bsg_job *bsg_job)
 }
 
 static int
-qla2x00_process_vendor_specific(struct bsg_job *bsg_job)
+qla2x00_process_vendor_specific(struct scsi_qla_host *vha, struct bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 
+	ql_dbg(ql_dbg_edif, vha, 0x911b, "%s FC_BSG_HST_VENDOR cmd[0]=0x%x\n",
+	    __func__, bsg_request->rqst_data.h_vendor.vendor_cmd[0]);
+
 	switch (bsg_request->rqst_data.h_vendor.vendor_cmd[0]) {
 	case QL_VND_LOOPBACK:
 		return qla2x00_process_loopback(bsg_job);
@@ -2916,12 +2919,19 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
 		ql_dbg(ql_dbg_user, vha, 0x709f,
 		    "BSG: ISP abort active/needed -- cmd=%d.\n",
 		    bsg_request->msgcode);
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
 		return -EBUSY;
 	}
 
+	if (test_bit(PFLG_DRIVER_REMOVING, &vha->pci_flags)) {
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		return -EIO;
+	}
+
 skip_chip_chk:
-	ql_dbg(ql_dbg_user, vha, 0x7000,
-	    "Entered %s msgcode=0x%x.\n", __func__, bsg_request->msgcode);
+	ql_dbg(ql_dbg_user + ql_dbg_verbose, vha, 0x7000,
+	    "Entered %s msgcode=0x%x. bsg ptr %px\n",
+	    __func__, bsg_request->msgcode, bsg_job);
 
 	switch (bsg_request->msgcode) {
 	case FC_BSG_RPT_ELS:
@@ -2932,7 +2942,7 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
 		ret = qla2x00_process_ct(bsg_job);
 		break;
 	case FC_BSG_HST_VENDOR:
-		ret = qla2x00_process_vendor_specific(bsg_job);
+		ret = qla2x00_process_vendor_specific(vha, bsg_job);
 		break;
 	case FC_BSG_HST_ADD_RPORT:
 	case FC_BSG_HST_DEL_RPORT:
@@ -2941,6 +2951,10 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
 		ql_log(ql_log_warn, vha, 0x705a, "Unsupported BSG request.\n");
 		break;
 	}
+
+	ql_dbg(ql_dbg_user + ql_dbg_verbose, vha, 0x7000,
+	    "%s done with return %x\n", __func__, ret);
+
 	return ret;
 }
 
@@ -2955,6 +2969,8 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 	unsigned long flags;
 	struct req_que *req;
 
+	ql_log(ql_log_info, vha, 0x708b, "%s CMD timeout. bsg ptr %p.\n",
+	    __func__, bsg_job);
 	/* find the bsg job from the active list of commands */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (que = 0; que < ha->max_req_queues; que++) {
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 0fa6a1420c30..721898afb064 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -19,6 +19,18 @@ static int qla_edif_sadb_delete_sa_index(fc_port_t *fcport, uint16_t nport_handl
 		uint16_t sa_index);
 static int qla_pur_get_pending(scsi_qla_host_t *, fc_port_t *, struct bsg_job *);
 
+struct edb_node {
+	struct  list_head	list;
+	uint32_t		ntype;
+	uint32_t		lstate;
+	union {
+		port_id_t	plogi_did;
+		uint32_t	async;
+		port_id_t	els_sid;
+		struct edif_sa_update_aen	sa_aen;
+	} u;
+};
+
 static struct els_sub_cmd {
 	uint16_t cmd;
 	const char *str;
@@ -455,6 +467,10 @@ static void __qla2x00_release_all_sadb(struct scsi_qla_host *vha,
 					/* build and send the aen */
 					fcport->edif.rx_sa_set = 1;
 					fcport->edif.rx_sa_pending = 0;
+					qla_edb_eventcreate(vha,
+							VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
+							QL_VND_SA_STAT_SUCCESS,
+							QL_VND_RX_SA_KEY, fcport);
 				}
 				ql_dbg(ql_dbg_edif, vha, 0x5033,
 	"%s: releasing edif_entry %p, update_sa_index: 0x%x, delete_sa_index: 0x%x\n",
@@ -547,6 +563,12 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 			    fcport->loop_id, fcport->d_id.b24,
 			    fcport->logout_on_delete);
 
+			ql_dbg(ql_dbg_edif, vha, 0xf084,
+			    "keep %d els_logo %d disc state %d auth state %d stop state %d\n",
+			    fcport->keep_nport_handle,
+			    fcport->send_els_logo, fcport->disc_state,
+			    fcport->edif.auth_state, fcport->edif.app_stop);
+
 			if (atomic_read(&vha->loop_state) == LOOP_DOWN)
 				break;
 
@@ -1232,6 +1254,10 @@ qla24xx_check_sadb_avail_slot(struct bsg_job *bsg_job, fc_port_t *fcport,
 		/* build and send the aen */
 		fcport->edif.rx_sa_set = 1;
 		fcport->edif.rx_sa_pending = 0;
+		qla_edb_eventcreate(fcport->vha,
+		    VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
+		    QL_VND_SA_STAT_SUCCESS,
+		    QL_VND_RX_SA_KEY, fcport);
 
 		/* force a return of good bsg status; */
 		return RX_DELETE_NO_EDIF_SA_INDEX;
@@ -1806,17 +1832,314 @@ qla_els_reject_iocb(scsi_qla_host_t *vha, struct qla_qpair *qp,
 	qla2x00_start_iocbs(vha, qp->req);
 	return 0;
 }
+
+void
+qla_edb_init(scsi_qla_host_t *vha)
+{
+	if (vha->e_dbell.db_flags == EDB_ACTIVE) {
+		/* list already init'd - error */
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		    "edif db already initialized, cannot reinit\n");
+		return;
+	}
+
+	/* initialize lock which protects doorbell & init list */
+	spin_lock_init(&vha->e_dbell.db_lock);
+	INIT_LIST_HEAD(&vha->e_dbell.head);
+
+	/* create and initialize doorbell */
+	init_completion(&vha->e_dbell.dbell);
+}
+
+static void
+qla_edb_node_free(scsi_qla_host_t *vha, struct edb_node *node)
+{
+	/*
+	 * releases the space held by this edb node entry
+	 * this function does _not_ free the edb node itself
+	 * NB: the edb node entry passed should not be on any list
+	 *
+	 * currently for doorbell there's no additional cleanup
+	 * needed, but here as a placeholder for furture use.
+	 */
+
+	if (!node) {
+		ql_dbg(ql_dbg_edif, vha, 0x09122,
+		    "%s error - no valid node passed\n", __func__);
+		return;
+	}
+
+	node->lstate = LSTATE_DEST;
+	node->ntype = N_UNDEF;
+}
+
 /* function called when app is stopping */
 
 void
 qla_edb_stop(scsi_qla_host_t *vha)
 {
+	unsigned long flags;
+	struct edb_node *node, *q;
+
 	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
 		/* doorbell list not enabled */
 		ql_dbg(ql_dbg_edif, vha, 0x09102,
 		    "%s doorbell not enabled\n", __func__);
 		return;
 	}
+
+	/* grab lock so list doesn't move */
+	spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
+
+	vha->e_dbell.db_flags &= ~EDB_ACTIVE; /* mark it not active */
+	/* hopefully this is a null list at this point */
+	list_for_each_entry_safe(node, q, &vha->e_dbell.head, list) {
+		ql_dbg(ql_dbg_edif, vha, 0x910f,
+		    "%s freeing edb_node type=%x\n",
+		    __func__, node->ntype);
+		qla_edb_node_free(vha, node);
+		list_del(&node->list);
+
+		spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
+		kfree(node);
+		spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
+	}
+	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
+
+	/* wake up doorbell waiters - they'll be dismissed with error code */
+	complete_all(&vha->e_dbell.dbell);
+}
+
+static struct edb_node *
+qla_edb_node_alloc(scsi_qla_host_t *vha, uint32_t ntype)
+{
+	struct edb_node	*node;
+
+	node = kzalloc(sizeof(*node), GFP_ATOMIC);
+	if (!node) {
+		/* couldn't get space */
+		ql_dbg(ql_dbg_edif, vha, 0x9100,
+		    "edb node unable to be allocated\n");
+		return NULL;
+	}
+
+	node->lstate = LSTATE_OFF;
+	node->ntype = ntype;
+	INIT_LIST_HEAD(&node->list);
+	return node;
+}
+
+/* adds a already alllocated enode to the linked list */
+static bool
+qla_edb_node_add(scsi_qla_host_t *vha, struct edb_node *ptr)
+{
+	unsigned long		flags;
+
+	if (ptr->lstate != LSTATE_OFF) {
+		ql_dbg(ql_dbg_edif, vha, 0x911a,
+		    "%s error edb node(%p) state=%x\n",
+		    __func__, ptr, ptr->lstate);
+		return false;
+	}
+
+	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+		/* doorbell list not enabled */
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		    "%s doorbell not enabled\n", __func__);
+		return false;
+	}
+
+	spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
+	ptr->lstate = LSTATE_ON;
+	list_add_tail(&ptr->list, &vha->e_dbell.head);
+	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
+
+	/* ring doorbell for waiters */
+	complete(&vha->e_dbell.dbell);
+
+	return true;
+}
+
+/* adds event to doorbell list */
+void
+qla_edb_eventcreate(scsi_qla_host_t *vha, uint32_t dbtype,
+	uint32_t data, uint32_t data2, fc_port_t	*sfcport)
+{
+	struct edb_node	*edbnode;
+	fc_port_t *fcport = sfcport;
+	port_id_t id;
+
+	if (!vha->hw->flags.edif_enabled) {
+		/* edif not enabled */
+		return;
+	}
+
+	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+		if (fcport)
+			fcport->edif.auth_state = dbtype;
+		/* doorbell list not enabled */
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		    "%s doorbell not enabled (type=%d\n", __func__, dbtype);
+		return;
+	}
+
+	edbnode = qla_edb_node_alloc(vha, dbtype);
+	if (!edbnode) {
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		    "%s unable to alloc db node\n", __func__);
+		return;
+	}
+
+	if (!fcport) {
+		id.b.domain = (data >> 16) & 0xff;
+		id.b.area = (data >> 8) & 0xff;
+		id.b.al_pa = data & 0xff;
+		ql_dbg(ql_dbg_edif, vha, 0x09222,
+		    "%s: Arrived s_id: %06x\n", __func__,
+		    id.b24);
+		fcport = qla2x00_find_fcport_by_pid(vha, &id);
+		if (!fcport) {
+			ql_dbg(ql_dbg_edif, vha, 0x09102,
+			    "%s can't find fcport for sid= 0x%x - ignoring\n",
+			__func__, id.b24);
+			kfree(edbnode);
+			return;
+		}
+	}
+
+	/* populate the edb node */
+	switch (dbtype) {
+	case VND_CMD_AUTH_STATE_NEEDED:
+	case VND_CMD_AUTH_STATE_SESSION_SHUTDOWN:
+		edbnode->u.plogi_did.b24 = fcport->d_id.b24;
+		break;
+	case VND_CMD_AUTH_STATE_ELS_RCVD:
+		edbnode->u.els_sid.b24 = fcport->d_id.b24;
+		break;
+	case VND_CMD_AUTH_STATE_SAUPDATE_COMPL:
+		edbnode->u.sa_aen.port_id = fcport->d_id;
+		edbnode->u.sa_aen.status =  data;
+		edbnode->u.sa_aen.key_type =  data2;
+		break;
+	default:
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+			"%s unknown type: %x\n", __func__, dbtype);
+		qla_edb_node_free(vha, edbnode);
+		kfree(edbnode);
+		edbnode = NULL;
+		break;
+	}
+
+	if (edbnode && (!qla_edb_node_add(vha, edbnode))) {
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		    "%s unable to add dbnode\n", __func__);
+		qla_edb_node_free(vha, edbnode);
+		kfree(edbnode);
+		return;
+	}
+	if (edbnode && fcport)
+		fcport->edif.auth_state = dbtype;
+	ql_dbg(ql_dbg_edif, vha, 0x09102,
+	    "%s Doorbell produced : type=%d %p\n", __func__, dbtype, edbnode);
+}
+
+static struct edb_node *
+qla_edb_getnext(scsi_qla_host_t *vha)
+{
+	unsigned long	flags;
+	struct edb_node	*edbnode = NULL;
+
+	spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
+
+	/* db nodes are fifo - no qualifications done */
+	if (!list_empty(&vha->e_dbell.head)) {
+		edbnode = list_first_entry(&vha->e_dbell.head,
+		    struct edb_node, list);
+		list_del(&edbnode->list);
+		edbnode->lstate = LSTATE_OFF;
+	}
+
+	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
+
+	return edbnode;
+}
+
+/*
+ * app uses separate thread to read this. It'll wait until the doorbell
+ * is rung by the driver or the max wait time has expired
+ */
+ssize_t
+edif_doorbell_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct edb_node	*dbnode = NULL;
+	struct edif_app_dbell *ap = (struct edif_app_dbell *)buf;
+	uint32_t dat_siz, buf_size, sz;
+
+	sz = 256; /* app currently hardcode to 256. */
+
+	/* stop new threads from waiting if we're not init'd */
+	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x09122,
+		    "%s error - edif db not enabled\n", __func__);
+		return 0;
+	}
+
+	if (!vha->hw->flags.edif_enabled) {
+		/* edif not enabled */
+		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x09122,
+		    "%s error - edif not enabled\n", __func__);
+		return -1;
+	}
+
+	buf_size = 0;
+	while ((sz - buf_size) >= sizeof(struct edb_node)) {
+		/* remove the next item from the doorbell list */
+		dat_siz = 0;
+		dbnode = qla_edb_getnext(vha);
+		if (dbnode) {
+			ap->event_code = dbnode->ntype;
+			switch (dbnode->ntype) {
+			case VND_CMD_AUTH_STATE_SESSION_SHUTDOWN:
+			case VND_CMD_AUTH_STATE_NEEDED:
+				ap->port_id = dbnode->u.plogi_did;
+				dat_siz += sizeof(ap->port_id);
+				break;
+			case VND_CMD_AUTH_STATE_ELS_RCVD:
+				ap->port_id = dbnode->u.els_sid;
+				dat_siz += sizeof(ap->port_id);
+				break;
+			case VND_CMD_AUTH_STATE_SAUPDATE_COMPL:
+				ap->port_id = dbnode->u.sa_aen.port_id;
+				memcpy(ap->event_data, &dbnode->u,
+						sizeof(struct edif_sa_update_aen));
+				dat_siz += sizeof(struct edif_sa_update_aen);
+				break;
+			default:
+				/* unknown node type, rtn unknown ntype */
+				ap->event_code = VND_CMD_AUTH_STATE_UNDEF;
+				memcpy(ap->event_data, &dbnode->ntype, 4);
+				dat_siz += 4;
+				break;
+			}
+
+			ql_dbg(ql_dbg_edif, vha, 0x09102,
+				"%s Doorbell consumed : type=%d %p\n",
+				__func__, dbnode->ntype, dbnode);
+			/* we're done with the db node, so free it up */
+			qla_edb_node_free(vha, dbnode);
+			kfree(dbnode);
+		} else {
+			break;
+		}
+
+		ap->event_data_size = dat_siz;
+		/* 8bytes = ap->event_code + ap->event_data_size */
+		buf_size += dat_siz + 8;
+		ap = (struct edif_app_dbell *)(buf + buf_size);
+	}
+	return buf_size;
 }
 
 static void qla_noop_sp_done(srb_t *sp, int res)
@@ -2138,6 +2461,8 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 	    __func__, purex->pur_info.pur_bytes_rcvd,
 	    purex->pur_info.pur_sid.b24,
 	    purex->pur_info.pur_did.b24, p->rx_xchg_addr);
+
+	qla_edb_eventcreate(host, VND_CMD_AUTH_STATE_ELS_RCVD, sid, 0, NULL);
 }
 
 static uint16_t  qla_edif_get_sa_index_from_freepool(fc_port_t *fcport, int dir)
@@ -2356,9 +2681,15 @@ qla28xx_sa_update_iocb_entry(scsi_qla_host_t *v, struct req_que *req,
 		if (pkt->flags & SA_FLAG_TX) {
 			sp->fcport->edif.tx_sa_set = 1;
 			sp->fcport->edif.tx_sa_pending = 0;
+			qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
+				QL_VND_SA_STAT_SUCCESS,
+				QL_VND_TX_SA_KEY, sp->fcport);
 		} else {
 			sp->fcport->edif.rx_sa_set = 1;
 			sp->fcport->edif.rx_sa_pending = 0;
+			qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
+				QL_VND_SA_STAT_SUCCESS,
+				QL_VND_RX_SA_KEY, sp->fcport);
 		}
 	} else {
 		ql_dbg(ql_dbg_edif, vha, 0x3063,
@@ -2366,6 +2697,15 @@ qla28xx_sa_update_iocb_entry(scsi_qla_host_t *v, struct req_que *req,
 		    __func__, sp->fcport->port_name,
 		    pkt->sa_index, pkt->new_sa_info, pkt->port_id[2],
 		    pkt->port_id[1], pkt->port_id[0]);
+
+		if (pkt->flags & SA_FLAG_TX)
+			qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
+				(le16_to_cpu(pkt->u.comp_sts) << 16) | QL_VND_SA_STAT_FAILED,
+				QL_VND_TX_SA_KEY, sp->fcport);
+		else
+			qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
+				(le16_to_cpu(pkt->u.comp_sts) << 16) | QL_VND_SA_STAT_FAILED,
+				QL_VND_RX_SA_KEY, sp->fcport);
 	}
 
 	/* for delete, release sa_ctl, sa_index */
@@ -2872,6 +3212,8 @@ void qla_edif_sess_down(struct scsi_qla_host *vha, struct fc_port *sess)
 			"%s: sess %8phN send port_offline event\n",
 			__func__, sess->port_name);
 		sess->edif.app_sess_online = 0;
+		qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SESSION_SHUTDOWN,
+		    sess->d_id.b24, 0, sess);
 		qla2x00_post_aen_work(vha, FCH_EVT_PORT_OFFLINE, sess->d_id.b24);
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index c695f5a58d4d..cc78339b47ac 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -981,11 +981,15 @@ void qla_nvme_unregister_remote_port(struct fc_port *fcport);
 
 /* qla_edif.c */
 fc_port_t *qla2x00_find_fcport_by_pid(scsi_qla_host_t *vha, port_id_t *id);
+void qla_edb_eventcreate(scsi_qla_host_t *vha, uint32_t dbtype, uint32_t data, uint32_t data2,
+		fc_port_t *fcport);
 void qla_edb_stop(scsi_qla_host_t *vha);
+ssize_t edif_doorbell_show(struct device *dev, struct device_attribute *attr, char *buf);
 int32_t qla_edif_app_mgmt(struct bsg_job *bsg_job);
 void qla_enode_init(scsi_qla_host_t *vha);
 void qla_enode_stop(scsi_qla_host_t *vha);
 void qla_edif_flush_sa_ctl_lists(fc_port_t *fcport);
+void qla_edb_init(scsi_qla_host_t *vha);
 void qla24xx_sa_update_iocb(srb_t *sp, struct sa_update_28xx *sa_update_iocb);
 void qla24xx_sa_replace_iocb(srb_t *sp, struct sa_update_28xx *sa_update_iocb);
 void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7a20b1ddc63f..bef9bf59bc50 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1474,6 +1474,9 @@ static int	qla_chk_secure_login(scsi_qla_host_t	*vha, fc_port_t *fcport,
 				    __func__, __LINE__, fcport->port_name);
 				fcport->edif.app_started = 1;
 				fcport->edif.app_sess_online = 1;
+
+				qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_NEEDED,
+				    fcport->d_id.b24, 0, fcport);
 			}
 
 			rc = 1;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0b379ac179fa..efc21ef80142 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3490,6 +3490,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 probe_failed:
 	qla_enode_stop(base_vha);
+	qla_edb_stop(base_vha);
 	if (base_vha->gnl.l) {
 		dma_free_coherent(&ha->pdev->dev, base_vha->gnl.size,
 				base_vha->gnl.l, base_vha->gnl.ldma);
@@ -3793,6 +3794,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	base_vha->gnl.l = NULL;
 	qla_enode_stop(base_vha);
+	qla_edb_stop(base_vha);
 
 	vfree(base_vha->scan.l);
 
@@ -4919,6 +4921,8 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	init_waitqueue_head(&vha->fcport_waitQ);
 	init_waitqueue_head(&vha->vref_waitq);
 	qla_enode_init(vha);
+	qla_edb_init(vha);
+
 
 	vha->gnl.size = sizeof(struct get_name_list_extended) *
 			(ha->max_loop_id + 1);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index faf446f0fe8c..5d9fafa0c5d9 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -585,6 +585,8 @@ static void qla2x00_async_nack_sp_done(srb_t *sp, int res)
 			    DSC_LOGIN_AUTH_PEND);
 			qla2x00_post_aen_work(vha, FCH_EVT_PORT_ONLINE,
 			    sp->fcport->d_id.b24);
+			qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_NEEDED, sp->fcport->d_id.b24,
+			    0, sp->fcport);
 		}
 		break;
 
-- 
2.19.0.rc0


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4763DC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F33960E76
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237102AbhHJEiw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 00:38:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32732 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236460AbhHJEij (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 00:38:39 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A4aQaT008600
        for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2021 21:38:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=y8c1W2s/0lMXUebvB5LE5SXUv304WMWorGR0NldvGGY=;
 b=PxTpMtBZaYsV5CVUu8+I/hRg7xBVyEsnt+FFGdv7bjfaaCziAXmxUZmIkl/kiu82ISgf
 k7XgkEBB33zY7pKSJp+BUVjVt5kJSLYS+OAzAUqN4K0n7xec8dv/NvpDlAM2OjETGcws
 62NaA8QGQd6Ou4AKhUxaCIsUa2mwfMDYVbh16g8TFyaPFR3steFcIajEquOE1OM7/ST/
 udPoiqLOrweeR7cbvwJwdeOTLsPlh6cXdORP2Cnn8/wC6sTzxpIjlL33G44c6UYAEMeT
 7O7Cs67PyNs1/zN9M31meFmQNVVPGWsmDlnPAhMvuOAL+R5TEKN/bQSMSLj/METtW/oo gg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3abfu2gf47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 21:38:16 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 9 Aug
 2021 21:38:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 9 Aug 2021 21:38:14 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DCAE73F70A1;
        Mon,  9 Aug 2021 21:38:14 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17A4cESo001188;
        Mon, 9 Aug 2021 21:38:14 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17A4cEIY001187;
        Mon, 9 Aug 2021 21:38:14 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 02/14] qla2xxx: Change %p to %px in the log messages
Date:   Mon, 9 Aug 2021 21:37:08 -0700
Message-ID: <20210810043720.1137-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210810043720.1137-1-njavali@marvell.com>
References: <20210810043720.1137-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: QMIvJpqewNJrblTQUraSrbY2WIOSzXuD
X-Proofpoint-GUID: QMIvJpqewNJrblTQUraSrbY2WIOSzXuD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_01:2021-08-06,2021-08-10 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

Improve debuggability of the log messages.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_edif.c    |  78 +++++++-------
 drivers/scsi/qla2xxx/qla_gs.c      |   2 +-
 drivers/scsi/qla2xxx/qla_init.c    |  18 ++--
 drivers/scsi/qla2xxx/qla_iocb.c    |  18 ++--
 drivers/scsi/qla2xxx/qla_isr.c     |  24 ++---
 drivers/scsi/qla2xxx/qla_mbx.c     |   2 +-
 drivers/scsi/qla2xxx/qla_mid.c     |  16 +--
 drivers/scsi/qla2xxx/qla_nvme.c    |  18 ++--
 drivers/scsi/qla2xxx/qla_os.c      |  82 +++++++-------
 drivers/scsi/qla2xxx/qla_sup.c     |   4 +-
 drivers/scsi/qla2xxx/qla_target.c  | 168 +++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_tmpl.c    |   8 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  18 ++--
 13 files changed, 229 insertions(+), 227 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index ccbe0e1bfcbc..567c3013fb1a 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -105,7 +105,7 @@ static void qla2x00_sa_replace_iocb_timeout(struct timer_list *t)
 
 		if (sa_ctl) {
 			ql_dbg(ql_dbg_edif, vha, 0x3063,
-			    "%s: sa_ctl: %p, delete index %d, update index: %d, lid: 0x%x\n",
+			    "%s: sa_ctl: %px, delete index %d, update index: %d, lid: 0x%x\n",
 			    __func__, sa_ctl, delete_sa_index, edif_entry->update_sa_index,
 			    nport_handle);
 
@@ -234,7 +234,7 @@ fc_port_t *fcport)
 		qla_pur_get_pending(vha, fcport, bsg_job);
 
 		ql_dbg(ql_dbg_edif, vha, 0x911d,
-			"%s %s %8phN sid=%x. xchg %x, nb=%xh bsg ptr %p\n",
+			"%s %s %8phN sid=%x. xchg %x, nb=%xh bsg ptr %px\n",
 			__func__, sc_to_str(p->sub_cmd), fcport->port_name,
 			fcport->d_id.b24, rpl->rx_xchg_address,
 			rpl->r.reply_payload_rcv_len, bsg_job);
@@ -336,12 +336,12 @@ static void qla_edif_reset_auth_wait(struct fc_port *fcport, int state,
 
 	if (!waitonly) {
 		ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
-		    "%s: waited for session - %8phC, loopid=%x portid=%06x fcport=%p state=%u, cnt=%u\n",
+		    "%s: waited for session - %8phC, loopid=%x portid=%06x fcport=%px state=%u, cnt=%u\n",
 		    __func__, fcport->port_name, fcport->loop_id,
 		    fcport->d_id.b24, fcport, fcport->disc_state, cnt);
 	} else {
 		ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
-		    "%s: waited ONLY for session - %8phC, loopid=%x portid=%06x fcport=%p state=%u, cnt=%u\n",
+		    "%s: waited ONLY for session - %8phC, loopid=%x portid=%06x fcport=%px state=%u, cnt=%u\n",
 		    __func__, fcport->port_name, fcport->loop_id,
 		    fcport->d_id.b24, fcport, fcport->disc_state, cnt);
 	}
@@ -420,7 +420,7 @@ static void __qla2x00_release_all_sadb(struct scsi_qla_host *vha,
 			qla_edif_free_sa_ctl(fcport, sa_ctl, sa_ctl->index);
 		} else {
 			ql_dbg(ql_dbg_edif, vha, 0x3063,
-			    "%s: sa_ctl NOT freed, sa_ctl: %p\n", __func__, sa_ctl);
+			    "%s: sa_ctl NOT freed, sa_ctl: %px\n", __func__, sa_ctl);
 		}
 
 		/* Release the index */
@@ -439,7 +439,7 @@ static void __qla2x00_release_all_sadb(struct scsi_qla_host *vha,
 				qla_edif_list_find_sa_index(fcport, entry->handle);
 			if (edif_entry) {
 				ql_dbg(ql_dbg_edif, vha, 0x5033,
-				    "%s: remove edif_entry %p, update_sa_index: 0x%x, delete_sa_index: 0x%x\n",
+				    "%s: remove edif_entry %px, update_sa_index: 0x%x, delete_sa_index: 0x%x\n",
 				    __func__, edif_entry, edif_entry->update_sa_index,
 				    edif_entry->delete_sa_index);
 				qla_edif_list_delete_sa_index(fcport, edif_entry);
@@ -460,7 +460,7 @@ static void __qla2x00_release_all_sadb(struct scsi_qla_host *vha,
 							QL_VND_RX_SA_KEY, fcport);
 				}
 				ql_dbg(ql_dbg_edif, vha, 0x5033,
-				    "%s: release edif_entry %p, update_sa_index: 0x%x, delete_sa_index: 0x%x\n",
+				    "%s: release edif_entry %px, update_sa_index: 0x%x, delete_sa_index: 0x%x\n",
 				    __func__, edif_entry, edif_entry->update_sa_index,
 				    edif_entry->delete_sa_index);
 
@@ -548,7 +548,7 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 	list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
 		ql_dbg(ql_dbg_edif, vha, 0xf084,
-		    "%s: sess %p %8phC lid %#04x s_id %06x logout %d\n",
+		    "%s: sess %px %8phC lid %#04x s_id %06x logout %d\n",
 		    __func__, fcport, fcport->port_name,
 		    fcport->loop_id, fcport->d_id.b24,
 		    fcport->logout_on_delete);
@@ -636,7 +636,7 @@ qla_edif_app_stop(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 
 		if (fcport->flags & FCF_FCSP_DEVICE) {
 			ql_dbg(ql_dbg_edif, vha, 0xf084,
-			    "%s: sess %p from port %8phC lid %#04x s_id %06x logout %d keep %d els_logo %d\n",
+			    "%s: sess %px from port %8phC lid %#04x s_id %06x logout %d keep %d els_logo %d\n",
 			    __func__, fcport,
 			    fcport->port_name, fcport->loop_id, fcport->d_id.b24,
 			    fcport->logout_on_delete, fcport->keep_nport_handle,
@@ -847,7 +847,7 @@ qla_edif_app_authfail(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	}
 
 	ql_dbg(ql_dbg_edif, vha, 0x911d,
-	    "%s fcport is 0x%p\n", __func__, fcport);
+	    "%s fcport is 0x%px\n", __func__, fcport);
 
 	if (fcport) {
 		/* set/reset edif values and flags */
@@ -1068,7 +1068,7 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
 	if (!vha->hw->flags.edif_enabled ||
 		test_bit(VPORT_DELETE, &vha->dpc_flags)) {
 		ql_dbg(ql_dbg_edif, vha, 0x911d,
-		    "%s edif not enabled or vp delete. bsg ptr done %p. dpc_flags %lx\n",
+		    "%s edif not enabled or vp delete. bsg ptr done %px. dpc_flags %lx\n",
 		    __func__, bsg_job, vha->dpc_flags);
 
 		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
@@ -1121,7 +1121,7 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
 done:
 	if (done) {
 		ql_dbg(ql_dbg_user, vha, 0x7009,
-		    "%s: %d  bsg ptr done %p\n", __func__, __LINE__, bsg_job);
+		    "%s: %d  bsg ptr done %px\n", __func__, __LINE__, bsg_job);
 		bsg_job_done(bsg_job, bsg_reply->result,
 		    bsg_reply->reply_payload_rcv_len);
 	}
@@ -1159,7 +1159,7 @@ qla_edif_add_sa_ctl(fc_port_t *fcport, struct qla_sa_update_frame *sa_frame,
 	sa_ctl->flags = 0;
 	sa_ctl->state = 0L;
 	ql_dbg(ql_dbg_edif, fcport->vha, 0x9100,
-	    "%s: Added sa_ctl %p, index %d, state 0x%lx\n",
+	    "%s: Added sa_ctl %px, index %d, state 0x%lx\n",
 	    __func__, sa_ctl, sa_ctl->index, sa_ctl->state);
 	spin_lock_irqsave(&fcport->edif.sa_list_lock, flags);
 	if (dir == SAU_FLG_TX)
@@ -1272,7 +1272,7 @@ qla24xx_check_sadb_avail_slot(struct bsg_job *bsg_job, fc_port_t *fcport,
 		fcport->edif.rx_rekey_cnt++;
 
 	ql_dbg(ql_dbg_edif, fcport->vha, 0x9100,
-	    "%s: Found sa_ctl %p, index %d, state 0x%lx, tx_cnt %d, rx_cnt %d, nport_handle: 0x%x\n",
+	    "%s: Found sa_ctl %px, index %d, state 0x%lx, tx_cnt %d, rx_cnt %d, nport_handle: 0x%x\n",
 	    __func__, sa_ctl, sa_ctl->index, sa_ctl->state,
 	    fcport->edif.tx_rekey_cnt,
 	    fcport->edif.rx_rekey_cnt, fcport->loop_id);
@@ -1448,7 +1448,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 		edif_entry->timer.expires = jiffies + RX_DELAY_DELETE_TIMEOUT * HZ;
 
 		ql_dbg(ql_dbg_edif, vha, 0x911d,
-		    "%s: adding timer, entry: %p, delete sa_index %d, lid 0x%x to edif_list\n",
+		    "%s: adding timer, entry: %px, delete sa_index %d, lid 0x%x to edif_list\n",
 		    __func__, edif_entry, sa_index, nport_handle);
 
 		/*
@@ -1466,7 +1466,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 		 */
 
 		ql_dbg(ql_dbg_edif, vha, 0x911d,
-		    "%s: delete sa_index %d, lid 0x%x to edif_list. bsg done ptr %p\n",
+		    "%s: delete sa_index %d, lid 0x%x to edif_list. bsg done ptr %px\n",
 		    __func__, sa_index, nport_handle, bsg_job);
 
 		edif_entry->delete_sa_index = sa_index;
@@ -1557,7 +1557,7 @@ qla24xx_sadb_update(struct bsg_job *bsg_job)
 done:
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	ql_dbg(ql_dbg_edif, vha, 0x911d,
-	    "%s:status: FAIL, result: 0x%x, bsg ptr done %p\n",
+	    "%s:status: FAIL, result: 0x%x, bsg ptr done %px\n",
 	    __func__, bsg_reply->result, bsg_job);
 	bsg_job_done(bsg_job, bsg_reply->result,
 	    bsg_reply->reply_payload_rcv_len);
@@ -1989,7 +1989,7 @@ qla_edb_eventcreate(scsi_qla_host_t *vha, uint32_t dbtype,
 	if (edbnode && fcport)
 		fcport->edif.auth_state = dbtype;
 	ql_dbg(ql_dbg_edif, vha, 0x09102,
-	    "%s Doorbell produced : type=%d %p\n", __func__, dbtype, edbnode);
+	    "%s Doorbell produced : type=%d %px\n", __func__, dbtype, edbnode);
 }
 
 static struct edb_node *
@@ -2074,7 +2074,7 @@ edif_doorbell_show(struct device *dev, struct device_attribute *attr,
 			}
 
 			ql_dbg(ql_dbg_edif, vha, 0x09102,
-				"%s Doorbell consumed : type=%d %p\n",
+				"%s Doorbell consumed : type=%d %px\n",
 				__func__, dbnode->ntype, dbnode);
 			/* we're done with the db node, so free it up */
 			qla_edb_node_free(vha, dbnode);
@@ -2111,7 +2111,7 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
 	uint16_t nport_handle = e->u.sa_update.nport_handle;
 
 	ql_dbg(ql_dbg_edif, vha, 0x70e6,
-	    "%s: starting,  sa_ctl: %p\n", __func__, sa_ctl);
+	    "%s: starting,  sa_ctl: %px\n", __func__, sa_ctl);
 
 	if (!sa_ctl) {
 		ql_dbg(ql_dbg_edif, vha, 0x70e6,
@@ -2134,7 +2134,7 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
 	iocb_cmd->u.sa_update.sa_ctl = sa_ctl;
 
 	ql_dbg(ql_dbg_edif, vha, 0x3073,
-	    "Enter: SA REPL portid=%06x, sa_ctl %p, index %x, nport_handle: 0x%x\n",
+	    "Enter: SA REPL portid=%06x, sa_ctl %px, index %x, nport_handle: 0x%x\n",
 	    fcport->d_id.b24, sa_ctl, sa_ctl->index, nport_handle);
 	/*
 	 * if this is a sadb cleanup delete, mark it so the isr can
@@ -2144,7 +2144,7 @@ qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
 		/* mark this srb as a cleanup delete */
 		sp->flags |= SRB_EDIF_CLEANUP_DELETE;
 		ql_dbg(ql_dbg_edif, vha, 0x70e6,
-		    "%s: sp 0x%p flagged as cleanup delete\n", __func__, sp);
+		    "%s: sp 0x%px flagged as cleanup delete\n", __func__, sp);
 	}
 
 	sp->type = SRB_SA_REPLACE;
@@ -2172,24 +2172,24 @@ void qla24xx_sa_update_iocb(srb_t *sp, struct sa_update_28xx *sa_update_iocb)
 	switch (sa_frame->flags & (SAU_FLG_INV | SAU_FLG_TX)) {
 	case 0:
 		ql_dbg(ql_dbg_edif, vha, 0x911d,
-		    "%s: EDIF SA UPDATE RX IOCB  vha: 0x%p  index: %d\n",
+		    "%s: EDIF SA UPDATE RX IOCB  vha: 0x%px  index: %d\n",
 		    __func__, vha, sa_frame->fast_sa_index);
 		break;
 	case 1:
 		ql_dbg(ql_dbg_edif, vha, 0x911d,
-		    "%s: EDIF SA DELETE RX IOCB  vha: 0x%p  index: %d\n",
+		    "%s: EDIF SA DELETE RX IOCB  vha: 0x%px  index: %d\n",
 		    __func__, vha, sa_frame->fast_sa_index);
 		flags |= SA_FLAG_INVALIDATE;
 		break;
 	case 2:
 		ql_dbg(ql_dbg_edif, vha, 0x911d,
-		    "%s: EDIF SA UPDATE TX IOCB  vha: 0x%p  index: %d\n",
+		    "%s: EDIF SA UPDATE TX IOCB  vha: 0x%px  index: %d\n",
 		    __func__, vha, sa_frame->fast_sa_index);
 		flags |= SA_FLAG_TX;
 		break;
 	case 3:
 		ql_dbg(ql_dbg_edif, vha, 0x911d,
-		    "%s: EDIF SA DELETE TX IOCB  vha: 0x%p  index: %d\n",
+		    "%s: EDIF SA DELETE TX IOCB  vha: 0x%px  index: %d\n",
 		    __func__, vha, sa_frame->fast_sa_index);
 		flags |= SA_FLAG_TX | SA_FLAG_INVALIDATE;
 		break;
@@ -2529,22 +2529,22 @@ qla28xx_sa_update_iocb_entry(scsi_qla_host_t *v, struct req_que *req,
 	switch (pkt->flags & (SA_FLAG_INVALIDATE | SA_FLAG_TX)) {
 	case 0:
 		ql_dbg(ql_dbg_edif, vha, 0x3063,
-		    "%s: EDIF SA UPDATE RX IOCB  vha: 0x%p  index: %d\n",
+		    "%s: EDIF SA UPDATE RX IOCB  vha: 0x%px  index: %d\n",
 		    __func__, vha, pkt->sa_index);
 		break;
 	case 1:
 		ql_dbg(ql_dbg_edif, vha, 0x3063,
-		    "%s: EDIF SA DELETE RX IOCB  vha: 0x%p  index: %d\n",
+		    "%s: EDIF SA DELETE RX IOCB  vha: 0x%px  index: %d\n",
 		    __func__, vha, pkt->sa_index);
 		break;
 	case 2:
 		ql_dbg(ql_dbg_edif, vha, 0x3063,
-		    "%s: EDIF SA UPDATE TX IOCB  vha: 0x%p  index: %d\n",
+		    "%s: EDIF SA UPDATE TX IOCB  vha: 0x%px  index: %d\n",
 		    __func__, vha, pkt->sa_index);
 		break;
 	case 3:
 		ql_dbg(ql_dbg_edif, vha, 0x3063,
-		    "%s: EDIF SA DELETE TX IOCB  vha: 0x%p  index: %d\n",
+		    "%s: EDIF SA DELETE TX IOCB  vha: 0x%px  index: %d\n",
 		    __func__, vha, pkt->sa_index);
 		break;
 	}
@@ -2569,13 +2569,13 @@ qla28xx_sa_update_iocb_entry(scsi_qla_host_t *v, struct req_que *req,
 		edif_entry = qla_edif_list_find_sa_index(sp->fcport, nport_handle);
 		if (edif_entry) {
 			ql_dbg(ql_dbg_edif, vha, 0x5033,
-			    "%s: removing edif_entry %p, new sa_index: 0x%x\n",
+			    "%s: removing edif_entry %px, new sa_index: 0x%x\n",
 			    __func__, edif_entry, pkt->sa_index);
 			qla_edif_list_delete_sa_index(sp->fcport, edif_entry);
 			del_timer(&edif_entry->timer);
 
 			ql_dbg(ql_dbg_edif, vha, 0x5033,
-			    "%s: releasing edif_entry %p, new sa_index: 0x%x\n",
+			    "%s: releasing edif_entry %px, new sa_index: 0x%x\n",
 			    __func__, edif_entry, pkt->sa_index);
 
 			kfree(edif_entry);
@@ -2656,7 +2656,7 @@ qla28xx_sa_update_iocb_entry(scsi_qla_host_t *v, struct req_que *req,
 			qla_edif_free_sa_ctl(sp->fcport, sa_ctl, sa_ctl->index);
 		} else {
 			ql_dbg(ql_dbg_edif, vha, 0x3063,
-			    "%s: sa_ctl NOT freed, sa_ctl: %p\n",
+			    "%s: sa_ctl NOT freed, sa_ctl: %px\n",
 			    __func__, sa_ctl);
 		}
 		ql_dbg(ql_dbg_edif, vha, 0x3063,
@@ -2720,7 +2720,7 @@ qla28xx_start_scsi_edif(srb_t *sp)
 		if (qla2x00_marker(vha, sp->qpair, 0, 0, MK_SYNC_ALL) !=
 			QLA_SUCCESS) {
 			ql_log(ql_log_warn, vha, 0x300c,
-			    "qla2x00_marker failed for cmd=%p.\n", cmd);
+			    "qla2x00_marker failed for cmd=%px.\n", cmd);
 			return QLA_FUNCTION_FAILED;
 		}
 		vha->marker_needed = 0;
@@ -2769,7 +2769,7 @@ qla28xx_start_scsi_edif(srb_t *sp)
 	    mempool_alloc(ha->ctx_mempool, GFP_ATOMIC);
 	if (!ctx) {
 		ql_log(ql_log_fatal, vha, 0x3010,
-		    "Failed to allocate ctx for cmd=%p.\n", cmd);
+		    "Failed to allocate ctx for cmd=%px.\n", cmd);
 		goto queuing_error;
 	}
 
@@ -2778,7 +2778,7 @@ qla28xx_start_scsi_edif(srb_t *sp)
 	    GFP_ATOMIC, &ctx->fcp_cmnd_dma);
 	if (!ctx->fcp_cmnd) {
 		ql_log(ql_log_fatal, vha, 0x3011,
-		    "Failed to allocate fcp_cmnd for cmd=%p.\n", cmd);
+		    "Failed to allocate fcp_cmnd for cmd=%px.\n", cmd);
 		goto queuing_error;
 	}
 
@@ -2989,7 +2989,7 @@ static uint16_t qla_edif_sadb_get_sa_index(fc_port_t *fcport,
 	uint16_t nport_handle = fcport->loop_id;
 
 	ql_dbg(ql_dbg_edif, vha, 0x3063,
-	    "%s: entry  fc_port: %p, nport_handle: 0x%x\n",
+	    "%s: entry  fc_port: %px, nport_handle: 0x%x\n",
 	    __func__, fcport, nport_handle);
 
 	if (dir)
@@ -3197,7 +3197,7 @@ static void __chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
 	sa_ctl = qla_edif_find_sa_ctl_by_index(fcport, delete_sa_index, 0);
 	if (sa_ctl) {
 		ql_dbg(ql_dbg_edif, vha, 0x3063,
-		    "%s: POST SA DELETE sa_ctl: %p, index recvd %d\n",
+		    "%s: POST SA DELETE sa_ctl: %px, index recvd %d\n",
 		    __func__, sa_ctl, sa_index);
 		ql_dbg(ql_dbg_edif, vha, 0x3063,
 		    "delete index %d, update index: %d, nport handle: 0x%x, handle: 0x%x\n",
@@ -3368,7 +3368,7 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	rval = qla2x00_start_sp(sp);
 
 	ql_dbg(ql_dbg_edif, vha, 0x700a,
-	    "%s %s %8phN xchg %x ctlflag %x hdl %x reqlen %xh bsg ptr %p\n",
+	    "%s %s %8phN xchg %x ctlflag %x hdl %x reqlen %xh bsg ptr %px\n",
 	    __func__, sc_to_str(p->e.sub_cmd), fcport->port_name,
 	    p->e.extra_rx_xchg_address, p->e.extra_control_flags,
 	    sp->handle, sp->remap.req.len, bsg_job);
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index b16b7d16be12..b0b15fac5f3b 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3861,7 +3861,7 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha, struct srb *sp,
 
 	if (!sp->u.iocb_cmd.u.ctarg.req || !sp->u.iocb_cmd.u.ctarg.rsp) {
 		ql_log(ql_log_warn, vha, 0xffff,
-		    "%s: req %p rsp %p are not setup\n",
+		    "%s: req %px rsp %px are not setup\n",
 		    __func__, sp->u.iocb_cmd.u.ctarg.req,
 		    sp->u.iocb_cmd.u.ctarg.rsp);
 		spin_lock_irqsave(&vha->work_lock, flags);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ad0d3f536a31..24683ac1a620 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1610,7 +1610,7 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	u16 sec;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d8,
-	    "%s %8phC DS %d LS %d P %d fl %x confl %p rscn %d|%d login %d lid %d scan %d\n",
+	    "%s %8phC DS %d LS %d P %d fl %x confl %px rscn %d|%d login %d lid %d scan %d\n",
 	    __func__, fcport->port_name, fcport->disc_state,
 	    fcport->fw_login_state, fcport->login_pause, fcport->flags,
 	    fcport->conflict, fcport->last_rscn_gen, fcport->rscn_gen,
@@ -1809,7 +1809,7 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 		return;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2102,
-	    "%s %8phC DS %d LS %d P %d del %d cnfl %p rscn %d|%d login %d|%d fl %x\n",
+	    "%s %8phC DS %d LS %d P %d del %d cnfl %px rscn %d|%d login %d|%d fl %x\n",
 	    __func__, fcport->port_name, fcport->disc_state,
 	    fcport->fw_login_state, fcport->login_pause,
 	    fcport->deleted, fcport->conflict,
@@ -3169,7 +3169,7 @@ qla2x00_chip_diag(scsi_qla_host_t *vha)
 	/* Assume a failed state */
 	rval = QLA_FUNCTION_FAILED;
 
-	ql_dbg(ql_dbg_init, vha, 0x007b, "Testing device at %p.\n",
+	ql_dbg(ql_dbg_init, vha, 0x007b, "Testing device at %px.\n",
 	       &reg->flash_address);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -3638,7 +3638,7 @@ qla2x00_alloc_outstanding_cmds(struct qla_hw_data *ha, struct req_que *req)
 		if (!req->outstanding_cmds) {
 			ql_log(ql_log_fatal, NULL, 0x0126,
 			    "Failed to allocate memory for "
-			    "outstanding_cmds for req_que %p.\n", req);
+			    "outstanding_cmds for req_que %px.\n", req);
 			req->num_outstanding_cmds = 0;
 			return QLA_FUNCTION_FAILED;
 		}
@@ -5072,7 +5072,7 @@ qla2x00_rport_del(void *data)
 	spin_unlock_irqrestore(fcport->vha->host->host_lock, flags);
 	if (rport) {
 		ql_dbg(ql_dbg_disc, fcport->vha, 0x210b,
-		    "%s %8phN. rport %p roles %x\n",
+		    "%s %8phN. rport %px roles %x\n",
 		    __func__, fcport->port_name, rport,
 		    rport->roles);
 
@@ -5678,7 +5678,7 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
 	fc_remote_port_rolechg(rport, rport_ids.roles);
 
 	ql_dbg(ql_dbg_disc, vha, 0x20ee,
-	    "%s: %8phN. rport %ld:0:%d (%p) is %s mode\n",
+	    "%s: %8phN. rport %ld:0:%d (%px) is %s mode\n",
 	    __func__, fcport->port_name, vha->host_no,
 	    rport->scsi_target_id, rport,
 	    (fcport->port_type == FCT_TARGET) ? "tgt" :
@@ -6884,7 +6884,7 @@ qla2xxx_mctp_dump(scsi_qla_host_t *vha)
 		    "Failed to capture mctp dump\n");
 	} else {
 		ql_log(ql_log_info, vha, 0x5070,
-		    "Mctp dump capture for host (%ld/%p).\n",
+		    "Mctp dump capture for host (%ld/%px).\n",
 		    vha->host_no, ha->mctp_dump);
 		ha->mctp_dumped = 1;
 	}
@@ -6921,7 +6921,7 @@ qla2x00_quiesce_io(scsi_qla_host_t *vha)
 	struct scsi_qla_host *vp;
 
 	ql_dbg(ql_dbg_dpc, vha, 0x401d,
-	    "Quiescing I/O - ha=%p.\n", ha);
+	    "Quiescing I/O - ha=%px.\n", ha);
 
 	atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
 	if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
@@ -6958,7 +6958,7 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	vha->qla_stats.total_isp_aborts++;
 
 	ql_log(ql_log_info, vha, 0x00af,
-	    "Performing ISP error recovery - ha=%p.\n", ha);
+	    "Performing ISP error recovery - ha=%px.\n", ha);
 
 	ha->flags.purge_mbox = 1;
 	/* For ISP82XX, reset_chip is just disabling interrupts.
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 625d6b237fb2..b97346bd3c2b 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1048,7 +1048,7 @@ qla24xx_walk_and_build_prot_sglist(struct qla_hw_data *ha, srb_t *sp,
 		difctx = sp->u.scmd.crc_ctx;
 		direction_to_device = cmd->sc_data_direction == DMA_TO_DEVICE;
 		ql_dbg(ql_dbg_tgt + ql_dbg_verbose, vha, 0xe021,
-		  "%s: scsi_cmnd: %p, crc_ctx: %p, sp: %p\n",
+		  "%s: scsi_cmnd: %px, crc_ctx: %px, sp: %px\n",
 			__func__, cmd, difctx, sp);
 	} else if (tc) {
 		vha = tc->vha;
@@ -3018,7 +3018,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 		goto out;
 	}
 
-	ql_dbg(ql_dbg_io, vha, 0x3073, "PLOGI %p %p\n", ptr, resp_ptr);
+	ql_dbg(ql_dbg_io, vha, 0x3073, "PLOGI %px %px\n", ptr, resp_ptr);
 
 	memset(ptr, 0, sizeof(struct els_plogi_payload));
 	memset(resp_ptr, 0, sizeof(struct els_plogi_payload));
@@ -3327,7 +3327,7 @@ qla82xx_start_scsi(srb_t *sp)
 		if (qla2x00_marker(vha, ha->base_qpair,
 			0, 0, MK_SYNC_ALL) != QLA_SUCCESS) {
 			ql_log(ql_log_warn, vha, 0x300c,
-			    "qla2x00_marker failed for cmd=%p.\n", cmd);
+			    "qla2x00_marker failed for cmd=%px.\n", cmd);
 			return QLA_FUNCTION_FAILED;
 		}
 		vha->marker_needed = 0;
@@ -3360,7 +3360,7 @@ qla82xx_start_scsi(srb_t *sp)
 		more_dsd_lists = qla24xx_calc_dsd_lists(tot_dsds);
 		if ((more_dsd_lists + ha->gbl_dsd_inuse) >= NUM_DSD_CHAIN) {
 			ql_dbg(ql_dbg_io, vha, 0x300d,
-			    "Num of DSD list %d is than %d for cmd=%p.\n",
+			    "Num of DSD list %d is than %d for cmd=%px.\n",
 			    more_dsd_lists + ha->gbl_dsd_inuse, NUM_DSD_CHAIN,
 			    cmd);
 			goto queuing_error;
@@ -3376,7 +3376,7 @@ qla82xx_start_scsi(srb_t *sp)
 			if (!dsd_ptr) {
 				ql_log(ql_log_fatal, vha, 0x300e,
 				    "Failed to allocate memory for dsd_dma "
-				    "for cmd=%p.\n", cmd);
+				    "for cmd=%px.\n", cmd);
 				goto queuing_error;
 			}
 
@@ -3386,7 +3386,7 @@ qla82xx_start_scsi(srb_t *sp)
 				kfree(dsd_ptr);
 				ql_log(ql_log_fatal, vha, 0x300f,
 				    "Failed to allocate memory for dsd_addr "
-				    "for cmd=%p.\n", cmd);
+				    "for cmd=%px.\n", cmd);
 				goto queuing_error;
 			}
 			list_add_tail(&dsd_ptr->list, &ha->gbl_dsd_list);
@@ -3412,7 +3412,7 @@ qla82xx_start_scsi(srb_t *sp)
 		    mempool_alloc(ha->ctx_mempool, GFP_ATOMIC);
 		if (!ctx) {
 			ql_log(ql_log_fatal, vha, 0x3010,
-			    "Failed to allocate ctx for cmd=%p.\n", cmd);
+			    "Failed to allocate ctx for cmd=%px.\n", cmd);
 			goto queuing_error;
 		}
 
@@ -3421,7 +3421,7 @@ qla82xx_start_scsi(srb_t *sp)
 			GFP_ATOMIC, &ctx->fcp_cmnd_dma);
 		if (!ctx->fcp_cmnd) {
 			ql_log(ql_log_fatal, vha, 0x3011,
-			    "Failed to allocate fcp_cmnd for cmd=%p.\n", cmd);
+			    "Failed to allocate fcp_cmnd for cmd=%px.\n", cmd);
 			goto queuing_error;
 		}
 
@@ -3437,7 +3437,7 @@ qla82xx_start_scsi(srb_t *sp)
 				 */
 				ql_log(ql_log_warn, vha, 0x3012,
 				    "scsi cmd len %d not multiple of 4 "
-				    "for cmd=%p.\n", cmd->cmd_len, cmd);
+				    "for cmd=%px.\n", cmd->cmd_len, cmd);
 				goto queuing_error_fcp_cmnd;
 			}
 			ctx->fcp_cmnd_len = 12 + cmd->cmd_len + 4;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e8928fd83049..8d4d174419bb 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2188,7 +2188,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 		type = "Driver ELS logo";
 		if (iocb_type != ELS_IOCB_TYPE) {
 			ql_dbg(ql_dbg_user, vha, 0x5047,
-			    "Completing %s: (%p) type=%d.\n",
+			    "Completing %s: (%px) type=%d.\n",
 			    type, sp, sp->type);
 			sp->done(sp, 0);
 			return;
@@ -2205,7 +2205,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 		return;
 	default:
 		ql_dbg(ql_dbg_user, vha, 0x503e,
-		    "Unrecognized SRB: (%p) type=%d.\n", sp, sp->type);
+		    "Unrecognized SRB: (%px) type=%d.\n", sp, sp->type);
 		return;
 	}
 
@@ -2808,7 +2808,7 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
 
 	if (sense_len) {
 		ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x301c,
-		    "Check condition Sense data, nexus%ld:%d:%llu cmd=%p.\n",
+		    "Check condition Sense data, nexus%ld:%d:%llu cmd=%px.\n",
 		    sp->vha->host_no, cp->device->id, cp->device->lun,
 		    cp);
 		ql_dump_buffer(ql_dbg_io + ql_dbg_buffer, vha, 0x302b,
@@ -2851,7 +2851,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 	e_ref_tag = get_unaligned_le32(ep + 4);
 
 	ql_dbg(ql_dbg_io, vha, 0x3023,
-	    "iocb(s) %p Returned STATUS.\n", sts24);
+	    "iocb(s) %px Returned STATUS.\n", sts24);
 
 	ql_dbg(ql_dbg_io, vha, 0x3024,
 	    "DIF ERROR in cmd 0x%x lba 0x%llx act ref"
@@ -3136,7 +3136,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	if (req == NULL ||
 	    que >= find_first_zero_bit(ha->req_qid_map, ha->max_req_queues)) {
 		ql_dbg(ql_dbg_io, vha, 0x3059,
-		    "Invalid status handle (0x%x): Bad req pointer. req=%p, "
+		    "Invalid status handle (0x%x): Bad req pointer. req=%px, "
 		    "que=%u.\n", sts->handle, req, que);
 		return;
 	}
@@ -3169,7 +3169,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	if (sp->cmd_type != TYPE_SRB) {
 		req->outstanding_cmds[handle] = NULL;
 		ql_dbg(ql_dbg_io, vha, 0x3015,
-		    "Unknown sp->cmd_type %x %p).\n",
+		    "Unknown sp->cmd_type %x %px).\n",
 		    sp->cmd_type, sp);
 		return;
 	}
@@ -3206,7 +3206,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	cp = GET_CMD_SP(sp);
 	if (cp == NULL) {
 		ql_dbg(ql_dbg_io, vha, 0x3018,
-		    "Command already returned (0x%x/%p).\n",
+		    "Command already returned (0x%x/%px).\n",
 		    sts->handle, sp);
 
 		return;
@@ -3453,7 +3453,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 	case CS_DMA:
 		ql_log(ql_log_info, fcport->vha, 0x3022,
-		    "CS_DMA error: 0x%x-0x%x (0x%x) nexus=%ld:%d:%llu portid=%06x oxid=0x%x cdb=%10phN len=0x%x rsp_info=0x%x resid=0x%x fw_resid=0x%x sp=%p cp=%p.\n",
+		    "CS_DMA error: 0x%x-0x%x (0x%x) nexus=%ld:%d:%llu portid=%06x oxid=0x%x cdb=%10phN len=0x%x rsp_info=0x%x resid=0x%x fw_resid=0x%x sp=%px cp=%px.\n",
 		    comp_status, scsi_status, res, vha->host_no,
 		    cp->device->id, cp->device->lun, fcport->d_id.b24,
 		    ox_id, cp->cmnd, scsi_bufflen(cp), rsp_info_len,
@@ -3471,7 +3471,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 out:
 	if (logit)
 		ql_log(ql_log_warn, fcport->vha, 0x3022,
-		       "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%llu portid=%02x%02x%02x oxid=0x%x cdb=%10phN len=0x%x rsp_info=0x%x resid=0x%x fw_resid=0x%x sp=%p cp=%p.\n",
+		       "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%llu portid=%02x%02x%02x oxid=0x%x cdb=%10phN len=0x%x rsp_info=0x%x resid=0x%x fw_resid=0x%x sp=%px cp=%px.\n",
 		       comp_status, scsi_status, res, vha->host_no,
 		       cp->device->id, cp->device->lun, fcport->d_id.b.domain,
 		       fcport->d_id.b.area, fcport->d_id.b.al_pa, ox_id,
@@ -3509,7 +3509,7 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
 	cp = GET_CMD_SP(sp);
 	if (cp == NULL) {
 		ql_log(ql_log_warn, vha, 0x3025,
-		    "cmd is NULL: already returned to OS (sp=%p).\n", sp);
+		    "cmd is NULL: already returned to OS (sp=%px).\n", sp);
 
 		rsp->status_srb = NULL;
 		return;
@@ -4405,10 +4405,10 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		     ql2xmqsupport))
 			ha->mqenable = 1;
 	ql_dbg(ql_dbg_multiq, vha, 0xc005,
-	    "mqiobase=%p, max_rsp_queues=%d, max_req_queues=%d.\n",
+	    "mqiobase=%px, max_rsp_queues=%d, max_req_queues=%d.\n",
 	    ha->mqiobase, ha->max_rsp_queues, ha->max_req_queues);
 	ql_dbg(ql_dbg_init, vha, 0x0055,
-	    "mqiobase=%p, max_rsp_queues=%d, max_req_queues=%d.\n",
+	    "mqiobase=%px, max_rsp_queues=%d, max_req_queues=%d.\n",
 	    ha->mqiobase, ha->max_rsp_queues, ha->max_req_queues);
 
 msix_out:
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 4dd008e06617..63ca4c29c791 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -240,7 +240,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	}
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1117,
-	    "I/O Address = %p.\n", optr);
+	    "I/O Address = %px.\n", optr);
 
 	/* Issue set host interrupt command to send cmd out. */
 	ha->flags.mbox_int = 0;
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 078d596dbd49..98333f5b0807 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -284,7 +284,7 @@ qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 			case MBA_POINT_TO_POINT:
 			case MBA_CHG_IN_CONNECTION:
 				ql_dbg(ql_dbg_async, vha, 0x5024,
-				    "Async_event for VP[%d], mb=0x%x vha=%p.\n",
+				    "Async_event for VP[%d], mb=0x%x vha=%px.\n",
 				    i, *mb, vha);
 				qla2x00_async_event(vha, rsp, mb);
 				break;
@@ -292,7 +292,7 @@ qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 			case MBA_RSCN_UPDATE:
 				if ((mb[3] & 0xff) == vha->vp_idx) {
 					ql_dbg(ql_dbg_async, vha, 0x5024,
-					    "Async_event for VP[%d], mb=0x%x vha=%p\n",
+					    "Async_event for VP[%d], mb=0x%x vha=%px\n",
 					    i, *mb, vha);
 					qla2x00_async_event(vha, rsp, mb);
 				}
@@ -549,7 +549,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	host->transportt = qla2xxx_transport_vport_template;
 
 	ql_dbg(ql_dbg_vport, vha, 0xa007,
-	    "Detect vport hba %ld at address = %p.\n",
+	    "Detect vport hba %ld at address = %px.\n",
 	    vha->host_no, vha);
 
 	vha->flags.init_done = 1;
@@ -777,12 +777,12 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	req->out_ptr = (uint16_t *)(req->ring + req->length);
 	mutex_unlock(&ha->mq_lock);
 	ql_dbg(ql_dbg_multiq, base_vha, 0xc004,
-	    "ring_ptr=%p ring_index=%d, "
+	    "ring_ptr=%px ring_index=%d, "
 	    "cnt=%d id=%d max_q_depth=%d.\n",
 	    req->ring_ptr, req->ring_index,
 	    req->cnt, req->id, req->max_q_depth);
 	ql_dbg(ql_dbg_init, base_vha, 0x00de,
-	    "ring_ptr=%p ring_index=%d, "
+	    "ring_ptr=%px ring_index=%d, "
 	    "cnt=%d id=%d max_q_depth=%d.\n",
 	    req->ring_ptr, req->ring_index, req->cnt,
 	    req->id, req->max_q_depth);
@@ -866,7 +866,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	rsp->vp_idx = vp_idx;
 	rsp->hw = ha;
 	ql_dbg(ql_dbg_init, base_vha, 0x00e4,
-	    "rsp queue_id=%d rid=%d vp_idx=%d hw=%p.\n",
+	    "rsp queue_id=%d rid=%d vp_idx=%d hw=%px.\n",
 	    que_id, rsp->rid, rsp->vp_idx, rsp->hw);
 	/* Use alternate PCI bus number */
 	if (MSB(rsp->rid))
@@ -889,11 +889,11 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	rsp->in_ptr = (uint16_t *)(rsp->ring + rsp->length);
 	mutex_unlock(&ha->mq_lock);
 	ql_dbg(ql_dbg_multiq, base_vha, 0xc00b,
-	    "options=%x id=%d rsp_q_in=%p rsp_q_out=%p\n",
+	    "options=%x id=%d rsp_q_in=%px rsp_q_out=%px\n",
 	    rsp->options, rsp->id, rsp->rsp_q_in,
 	    rsp->rsp_q_out);
 	ql_dbg(ql_dbg_init, base_vha, 0x00e5,
-	    "options=%x id=%d rsp_q_in=%p rsp_q_out=%p\n",
+	    "options=%x id=%d rsp_q_in=%px rsp_q_out=%px\n",
 	    rsp->options, rsp->id, rsp->rsp_q_in,
 	    rsp->rsp_q_out);
 
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index fdac3f7fa080..6f3c0a506509 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -98,7 +98,7 @@ static int qla_nvme_alloc_queue(struct nvme_fc_local_port *lport,
 	ha = vha->hw;
 
 	ql_log(ql_log_info, vha, 0x2104,
-	    "%s: handle %p, idx =%d, qsize %d\n",
+	    "%s: handle %px, idx =%d, qsize %d\n",
 	    __func__, handle, qidx, qsize);
 
 	if (qidx > qla_nvme_fc_transport.max_hw_queues) {
@@ -111,7 +111,7 @@ static int qla_nvme_alloc_queue(struct nvme_fc_local_port *lport,
 	if (ha->queue_pair_map[qidx]) {
 		*handle = ha->queue_pair_map[qidx];
 		ql_log(ql_log_info, vha, 0x2121,
-		    "Returning existing qpair of %p for idx=%x\n",
+		    "Returning existing qpair of %px for idx=%x\n",
 		    *handle, qidx);
 		return 0;
 	}
@@ -224,7 +224,7 @@ static void qla_nvme_abort_work(struct work_struct *work)
 	int rval;
 
 	ql_dbg(ql_dbg_io, fcport->vha, 0xffff,
-	       "%s called for sp=%p, hndl=%x on fcport=%p deleted=%d\n",
+	       "%s called for sp=%px, hndl=%x on fcport=%px deleted=%d\n",
 	       __func__, sp, sp->handle, fcport, fcport->deleted);
 
 	if (!ha->flags.fw_started || fcport->deleted)
@@ -232,7 +232,7 @@ static void qla_nvme_abort_work(struct work_struct *work)
 
 	if (ha->flags.host_shutting_down) {
 		ql_log(ql_log_info, sp->fcport->vha, 0xffff,
-		    "%s Calling done on sp: %p, type: 0x%x\n",
+		    "%s Calling done on sp: %px, type: 0x%x\n",
 		    __func__, sp, sp->type);
 		sp->done(sp, 0);
 		goto out;
@@ -241,7 +241,7 @@ static void qla_nvme_abort_work(struct work_struct *work)
 	rval = ha->isp_ops->abort_command(sp);
 
 	ql_dbg(ql_dbg_io, fcport->vha, 0x212b,
-	    "%s: %s command for sp=%p, handle=%x on fcport=%p rval=%x\n",
+	    "%s: %s command for sp=%px, handle=%x on fcport=%px rval=%x\n",
 	    __func__, (rval != QLA_SUCCESS) ? "Failed to abort" : "Aborted",
 	    sp, sp->handle, fcport, rval);
 
@@ -633,7 +633,7 @@ static void qla_nvme_localport_delete(struct nvme_fc_local_port *lport)
 	struct scsi_qla_host *vha = lport->private;
 
 	ql_log(ql_log_info, vha, 0x210f,
-	    "localport delete of %p completed.\n", vha->nvme_local_port);
+	    "localport delete of %px completed.\n", vha->nvme_local_port);
 	vha->nvme_local_port = NULL;
 	complete(&vha->nvme_del_done);
 }
@@ -648,7 +648,7 @@ static void qla_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
 	fcport->nvme_flag &= ~NVME_FLAG_REGISTERED;
 	fcport->nvme_flag &= ~NVME_FLAG_DELETING;
 	ql_log(ql_log_info, fcport->vha, 0x2110,
-	    "remoteport_delete of %p %8phN completed.\n",
+	    "remoteport_delete of %px %8phN completed.\n",
 	    fcport, fcport->port_name);
 	complete(&fcport->nvme_del_done);
 }
@@ -680,7 +680,7 @@ void qla_nvme_unregister_remote_port(struct fc_port *fcport)
 		return;
 
 	ql_log(ql_log_warn, fcport->vha, 0x2112,
-	    "%s: unregister remoteport on %p %8phN\n",
+	    "%s: unregister remoteport on %px %8phN\n",
 	    __func__, fcport, fcport->port_name);
 
 	if (test_bit(PFLG_DRIVER_REMOVING, &fcport->vha->pci_flags))
@@ -705,7 +705,7 @@ void qla_nvme_delete(struct scsi_qla_host *vha)
 	if (vha->nvme_local_port) {
 		init_completion(&vha->nvme_del_done);
 		ql_log(ql_log_info, vha, 0x2116,
-			"unregister localport=%p\n",
+			"unregister localport=%px\n",
 			vha->nvme_local_port);
 		nv_ret = nvme_fc_unregister_localport(vha->nvme_local_port);
 		if (nv_ret)
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 868037c7d608..53e9eea031bd 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -866,11 +866,11 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		if (ha->flags.pci_channel_io_perm_failure) {
 			ql_dbg(ql_dbg_aer, vha, 0x9010,
 			    "PCI Channel IO permanent failure, exiting "
-			    "cmd=%p.\n", cmd);
+			    "cmd=%px.\n", cmd);
 			cmd->result = DID_NO_CONNECT << 16;
 		} else {
 			ql_dbg(ql_dbg_aer, vha, 0x9011,
-			    "EEH_Busy, Requeuing the cmd=%p.\n", cmd);
+			    "EEH_Busy, Requeuing the cmd=%px.\n", cmd);
 			cmd->result = DID_REQUEUE << 16;
 		}
 		goto qc24_fail_command;
@@ -880,7 +880,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	if (rval) {
 		cmd->result = rval;
 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3003,
-		    "fc_remote_port_chkready failed for cmd=%p, rval=0x%x.\n",
+		    "fc_remote_port_chkready failed for cmd=%px, rval=0x%x.\n",
 		    cmd, rval);
 		goto qc24_fail_command;
 	}
@@ -888,7 +888,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	if (!vha->flags.difdix_supported &&
 		scsi_get_prot_op(cmd) != SCSI_PROT_NORMAL) {
 			ql_dbg(ql_dbg_io, vha, 0x3004,
-			    "DIF Cap not reg, fail DIF capable cmd's:%p.\n",
+			    "DIF Cap not reg, fail DIF capable cmd's:%px.\n",
 			    cmd);
 			cmd->result = DID_NO_CONNECT << 16;
 			goto qc24_fail_command;
@@ -936,7 +936,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	rval = ha->isp_ops->start_scsi(sp);
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3013,
-		    "Start scsi failed rval=%d for cmd=%p.\n", rval, cmd);
+		    "Start scsi failed rval=%d for cmd=%px.\n", rval, cmd);
 		goto qc24_host_busy_free_sp;
 	}
 
@@ -971,7 +971,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 	if (rval) {
 		cmd->result = rval;
 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3076,
-		    "fc_remote_port_chkready failed for cmd=%p, rval=0x%x.\n",
+		    "fc_remote_port_chkready failed for cmd=%px, rval=0x%x.\n",
 		    cmd, rval);
 		goto qc24_fail_command;
 	}
@@ -1024,7 +1024,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 	rval = ha->isp_ops->start_scsi_mq(sp);
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3078,
-		    "Start scsi failed rval=%d for cmd=%p.\n", rval, cmd);
+		    "Start scsi failed rval=%d for cmd=%px.\n", rval, cmd);
 		goto qc24_host_busy_free_sp;
 	}
 
@@ -1129,7 +1129,7 @@ static inline int test_fcport_count(scsi_qla_host_t *vha)
 
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	ql_dbg(ql_dbg_init, vha, 0x00ec,
-	    "tgt %p, fcport_count=%d\n",
+	    "tgt %px, fcport_count=%d\n",
 	    vha, vha->fcport_count);
 	res = (vha->fcport_count == 0);
 	if  (res) {
@@ -1286,7 +1286,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	lun = cmd->device->lun;
 
 	ql_dbg(ql_dbg_taskm, vha, 0x8002,
-	    "Aborting from RISC nexus=%ld:%d:%llu sp=%p cmd=%p handle=%x\n",
+	    "Aborting from RISC nexus=%ld:%d:%llu sp=%px cmd=%px handle=%x\n",
 	    vha->host_no, id, lun, sp, cmd, sp->handle);
 
 	/*
@@ -1297,7 +1297,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	rval = ha->isp_ops->abort_command(sp);
 
 	ql_dbg(ql_dbg_taskm, vha, 0x8003,
-	       "Abort command mbx cmd=%p, rval=%x.\n", cmd, rval);
+	       "Abort command mbx cmd=%px, rval=%x.\n", cmd, rval);
 
 	/* Wait for the command completion. */
 	ratov_j = ha->r_a_tov/10 * 4 * 1000;
@@ -1407,39 +1407,39 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 		return SUCCESS;
 
 	ql_log(ql_log_info, vha, 0x8009,
-	    "%s RESET ISSUED nexus=%ld:%d:%llu cmd=%p.\n", name, vha->host_no,
+	    "%s RESET ISSUED nexus=%ld:%d:%llu cmd=%px.\n", name, vha->host_no,
 	    cmd->device->id, cmd->device->lun, cmd);
 
 	err = 0;
 	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800a,
-		    "Wait for hba online failed for cmd=%p.\n", cmd);
+		    "Wait for hba online failed for cmd=%px.\n", cmd);
 		goto eh_reset_failed;
 	}
 	err = 2;
 	if (do_reset(fcport, cmd->device->lun, 1)
 		!= QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800c,
-		    "do_reset failed for cmd=%p.\n", cmd);
+		    "do_reset failed for cmd=%px.\n", cmd);
 		goto eh_reset_failed;
 	}
 	err = 3;
 	if (qla2x00_eh_wait_for_pending_commands(vha, cmd->device->id,
 	    cmd->device->lun, type) != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800d,
-		    "wait for pending cmds failed for cmd=%p.\n", cmd);
+		    "wait for pending cmds failed for cmd=%px.\n", cmd);
 		goto eh_reset_failed;
 	}
 
 	ql_log(ql_log_info, vha, 0x800e,
-	    "%s RESET SUCCEEDED nexus:%ld:%d:%llu cmd=%p.\n", name,
+	    "%s RESET SUCCEEDED nexus:%ld:%d:%llu cmd=%px.\n", name,
 	    vha->host_no, cmd->device->id, cmd->device->lun, cmd);
 
 	return SUCCESS;
 
 eh_reset_failed:
 	ql_log(ql_log_info, vha, 0x800f,
-	    "%s RESET FAILED: %s nexus=%ld:%d:%llu cmd=%p.\n", name,
+	    "%s RESET FAILED: %s nexus=%ld:%d:%llu cmd=%px.\n", name,
 	    reset_errors[err], vha->host_no, cmd->device->id, cmd->device->lun,
 	    cmd);
 	vha->reset_cmd_err_cnt++;
@@ -2038,7 +2038,7 @@ qla2x00_iospace_config(struct qla_hw_data *ha)
 			pci_resource_len(ha->pdev, 3));
 	if (ha->mqiobase) {
 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0018,
-		    "MQIO Base=%p.\n", ha->mqiobase);
+		    "MQIO Base=%px.\n", ha->mqiobase);
 		/* Read MSIX vector size of the board */
 		pci_read_config_word(ha->pdev, QLA_PCI_MSIX_CONTROL, &msix);
 		ha->msix_count = msix + 1;
@@ -2849,7 +2849,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto disable_device;
 	}
 	ql_dbg_pci(ql_dbg_init, pdev, 0x000a,
-	    "Memory allocated for ha=%p.\n", ha);
+	    "Memory allocated for ha=%px.\n", ha);
 	ha->pdev = pdev;
 	INIT_LIST_HEAD(&ha->tgt.q_full_list);
 	spin_lock_init(&ha->tgt.q_full_lock);
@@ -3089,7 +3089,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    ha->init_cb_size, ha->gid_list_info_size, ha->optrom_size,
 	    ha->nvram_npiv_size, ha->max_fibre_devices);
 	ql_dbg_pci(ql_dbg_init, pdev, 0x001f,
-	    "isp_ops=%p, flash_conf_off=%d, "
+	    "isp_ops=%px, flash_conf_off=%d, "
 	    "flash_data_off=%d, nvram_conf_off=%d, nvram_data_off=%d.\n",
 	    ha->isp_ops, ha->flash_conf_off, ha->flash_data_off,
 	    ha->nvram_conf_off, ha->nvram_data_off);
@@ -3100,7 +3100,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto iospace_config_failed;
 
 	ql_log_pci(ql_log_info, pdev, 0x001d,
-	    "Found an ISP%04X irq %d iobase 0x%p.\n",
+	    "Found an ISP%04X irq %d iobase 0x%px.\n",
 	    pdev->device, pdev->irq, ha->iobase);
 	mutex_init(&ha->vport_lock);
 	mutex_init(&ha->mq_lock);
@@ -3188,7 +3188,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ql_dbg(ql_dbg_init, base_vha, 0x0033,
 	    "max_id=%d this_id=%d "
 	    "cmd_per_len=%d unique_id=%d max_cmd_len=%d max_channel=%d "
-	    "max_lun=%llu transportt=%p, vendor_id=%llu.\n", host->max_id,
+	    "max_lun=%llu transportt=%px, vendor_id=%llu.\n", host->max_id,
 	    host->this_id, host->cmd_per_lun, host->unique_id,
 	    host->max_cmd_len, host->max_channel, host->max_lun,
 	    host->transportt, sht->vendor_id);
@@ -3270,18 +3270,18 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	ql_dbg(ql_dbg_multiq, base_vha, 0xc009,
-	    "rsp_q_map=%p req_q_map=%p rsp->req=%p req->rsp=%p.\n",
+	    "rsp_q_map=%px req_q_map=%px rsp->req=%px req->rsp=%px.\n",
 	    ha->rsp_q_map, ha->req_q_map, rsp->req, req->rsp);
 	ql_dbg(ql_dbg_multiq, base_vha, 0xc00a,
-	    "req->req_q_in=%p req->req_q_out=%p "
-	    "rsp->rsp_q_in=%p rsp->rsp_q_out=%p.\n",
+	    "req->req_q_in=%px req->req_q_out=%px "
+	    "rsp->rsp_q_in=%px rsp->rsp_q_out=%px.\n",
 	    req->req_q_in, req->req_q_out,
 	    rsp->rsp_q_in, rsp->rsp_q_out);
 	ql_dbg(ql_dbg_init, base_vha, 0x003e,
-	    "rsp_q_map=%p req_q_map=%p rsp->req=%p req->rsp=%p.\n",
+	    "rsp_q_map=%px req_q_map=%px rsp->req=%px req->rsp=%px.\n",
 	    ha->rsp_q_map, ha->req_q_map, rsp->req, req->rsp);
 	ql_dbg(ql_dbg_init, base_vha, 0x003f,
-	    "req->req_q_in=%p req->req_q_out=%p rsp->rsp_q_in=%p rsp->rsp_q_out=%p.\n",
+	    "req->req_q_in=%px req->req_q_out=%px rsp->rsp_q_in=%px rsp->rsp_q_out=%px.\n",
 	    req->req_q_in, req->req_q_out, rsp->rsp_q_in, rsp->rsp_q_out);
 
 	ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 0);
@@ -3322,7 +3322,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		host->can_queue = req->num_outstanding_cmds - 10;
 
 	ql_dbg(ql_dbg_init, base_vha, 0x0032,
-	    "can_queue=%d, req=%p, mgmt_svr_loop_id=%d, sg_tablesize=%d.\n",
+	    "can_queue=%d, req=%px, mgmt_svr_loop_id=%d, sg_tablesize=%d.\n",
 	    host->can_queue, base_vha->req,
 	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
 
@@ -3393,7 +3393,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    "Started qla2x00_timer with "
 	    "interval=%d.\n", WATCH_INTERVAL);
 	ql_dbg(ql_dbg_init, base_vha, 0x00f0,
-	    "Detected hba at address=%p.\n",
+	    "Detected hba at address=%px.\n",
 	    ha);
 
 	if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif) {
@@ -3926,7 +3926,7 @@ qla2x00_schedule_rport_del(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	if (fcport->rport) {
 		ql_dbg(ql_dbg_disc, fcport->vha, 0x2109,
-		    "%s %8phN. rport %p roles %x\n",
+		    "%s %8phN. rport %px roles %x\n",
 		    __func__, fcport->port_name, fcport->rport,
 		    fcport->rport->roles);
 		fc_remote_port_delete(fcport->rport);
@@ -4049,7 +4049,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		if (!ha->ctx_mempool)
 			goto fail_free_srb_mempool;
 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0021,
-		    "ctx_cachep=%p ctx_mempool=%p.\n",
+		    "ctx_cachep=%px ctx_mempool=%px.\n",
 		    ctx_cachep, ha->ctx_mempool);
 	}
 
@@ -4066,7 +4066,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		goto fail_free_nvram;
 
 	ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0022,
-	    "init_cb=%p gid_list=%p, srb_mempool=%p s_dma_pool=%p.\n",
+	    "init_cb=%px gid_list=%px, srb_mempool=%px s_dma_pool=%px.\n",
 	    ha->init_cb, ha->gid_list, ha->srb_mempool, ha->s_dma_pool);
 
 	if (IS_P3P_TYPE(ha) || ql2xenabledif || (IS_QLA28XX(ha) && ql2xsecenable)) {
@@ -4162,7 +4162,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		}
 
 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0025,
-		    "dl_dma_pool=%p fcp_cmnd_dma_pool=%p dif_bundl_pool=%p.\n",
+		    "dl_dma_pool=%px fcp_cmnd_dma_pool=%px dif_bundl_pool=%px.\n",
 		    ha->dl_dma_pool, ha->fcp_cmnd_dma_pool,
 		    ha->dif_bundl_pool);
 	}
@@ -4175,7 +4175,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		if (!ha->sns_cmd)
 			goto fail_dma_pool;
 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0026,
-		    "sns_cmd: %p.\n", ha->sns_cmd);
+		    "sns_cmd: %px.\n", ha->sns_cmd);
 	} else {
 	/* Get consistent memory allocated for MS IOCB */
 		ha->ms_iocb = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
@@ -4188,7 +4188,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		if (!ha->ct_sns)
 			goto fail_free_ms_iocb;
 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0027,
-		    "ms_iocb=%p ct_sns=%p.\n",
+		    "ms_iocb=%px ct_sns=%px.\n",
 		    ha->ms_iocb, ha->ct_sns);
 	}
 
@@ -4228,8 +4228,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	(*req)->rsp = *rsp;
 	(*rsp)->req = *req;
 	ql_dbg_pci(ql_dbg_init, ha->pdev, 0x002c,
-	    "req=%p req->length=%d req->ring=%p rsp=%p "
-	    "rsp->length=%d rsp->ring=%p.\n",
+	    "req=%px req->length=%d req->ring=%px rsp=%px "
+	    "rsp->length=%d rsp->ring=%px.\n",
 	    *req, (*req)->length, (*req)->ring, *rsp, (*rsp)->length,
 	    (*rsp)->ring);
 	/* Allocate memory for NVRAM data for vports */
@@ -4253,7 +4253,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		if (!ha->ex_init_cb)
 			goto fail_ex_init_cb;
 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x002e,
-		    "ex_init_cb=%p.\n", ha->ex_init_cb);
+		    "ex_init_cb=%px.\n", ha->ex_init_cb);
 	}
 
 	/* Get consistent memory allocated for Special Features-CB. */
@@ -4263,7 +4263,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		if (!ha->sf_init_cb)
 			goto fail_sf_init_cb;
 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0199,
-			   "sf_init_cb=%p.\n", ha->sf_init_cb);
+			   "sf_init_cb=%px.\n", ha->sf_init_cb);
 	}
 
 	INIT_LIST_HEAD(&ha->gbl_dsd_list);
@@ -4275,7 +4275,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		if (!ha->async_pd)
 			goto fail_async_pd;
 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x002f,
-		    "async_pd=%p.\n", ha->async_pd);
+		    "async_pd=%px.\n", ha->async_pd);
 	}
 
 	INIT_LIST_HEAD(&ha->vp_list);
@@ -4289,7 +4289,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	else {
 		qla2x00_set_reserved_loop_ids(ha);
 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0123,
-		    "loop_id_map=%p.\n", ha->loop_id_map);
+		    "loop_id_map=%px.\n", ha->loop_id_map);
 	}
 
 	ha->sfp_data = dma_alloc_coherent(&ha->pdev->dev,
@@ -4954,7 +4954,7 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 
 	sprintf(vha->host_str, "%s_%lu", QLA2XXX_DRIVER_NAME, vha->host_no);
 	ql_dbg(ql_dbg_init, vha, 0x0041,
-	    "Allocated the host=%p hw=%p vha=%p dev_name=%s",
+	    "Allocated the host=%px hw=%px vha=%px dev_name=%s",
 	    vha->host, vha->hw, vha,
 	    dev_name(&(ha->pdev->dev)));
 
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index a0aeba69513d..4361b5e0b4fb 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1338,7 +1338,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, __le32 *dwptr, uint32_t faddr,
 			}
 
 			ql_log(ql_log_warn, vha, 0x7097,
-			    "Failed burst-write at %x (%p/%#llx)....\n",
+			    "Failed burst-write at %x (%px/%#llx)....\n",
 			    flash_data_addr(ha, faddr), optrom,
 			    (u64)optrom_dma);
 
@@ -2927,7 +2927,7 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 		    flash_data_addr(ha, faddr), dburst);
 		if (rval != QLA_SUCCESS) {
 			ql_log(ql_log_warn, vha, 0x7097,
-			    "Failed burst write at %x (%p/%#llx)...\n",
+			    "Failed burst write at %x (%px/%#llx)...\n",
 			    flash_data_addr(ha, faddr), optrom,
 			    (u64)optrom_dma);
 			break;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index c3a589659658..c27cc79e151c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -202,6 +202,8 @@ struct scsi_qla_host *qla_find_host_by_d_id(struct scsi_qla_host *vha,
 		ql_dbg(ql_dbg_tgt_mgt + ql_dbg_verbose, vha, 0xf005,
 		    "Unable to find host %06x\n", key);
 
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf005,
+	       "find host %06x host %px\n", key, host);
 	return host;
 }
 
@@ -291,7 +293,7 @@ static void qlt_try_to_dequeue_unknown_atios(struct scsi_qla_host *vha,
 	list_for_each_entry_safe(u, t, &vha->unknown_atio_list, cmd_list) {
 		if (u->aborted) {
 			ql_dbg(ql_dbg_async, vha, 0x502e,
-			    "Freeing unknown %s %p, because of Abort\n",
+			    "Freeing unknown %s %px, because of Abort\n",
 			    "ATIO_TYPE7", u);
 			qlt_send_term_exchange(vha->hw->base_qpair, NULL,
 			    &u->atio, ha_locked, 0);
@@ -301,17 +303,17 @@ static void qlt_try_to_dequeue_unknown_atios(struct scsi_qla_host *vha,
 		host = qla_find_host_by_d_id(vha, u->atio.u.isp24.fcp_hdr.d_id);
 		if (host != NULL) {
 			ql_dbg(ql_dbg_async + ql_dbg_verbose, vha, 0x502f,
-			    "Requeuing unknown ATIO_TYPE7 %p\n", u);
+			    "Requeuing unknown ATIO_TYPE7 %px\n", u);
 			qlt_24xx_atio_pkt(host, &u->atio, ha_locked);
 		} else if (tgt->tgt_stop) {
 			ql_dbg(ql_dbg_async + ql_dbg_verbose, vha, 0x503a,
-			    "Freeing unknown %s %p, because tgt is being stopped\n",
+			    "Freeing unknown %s %px, because tgt is being stopped\n",
 			    "ATIO_TYPE7", u);
 			qlt_send_term_exchange(vha->hw->base_qpair, NULL,
 			    &u->atio, ha_locked, 0);
 		} else {
 			ql_dbg(ql_dbg_async + ql_dbg_verbose, vha, 0x503d,
-			    "Reschedule u %p, vha %p, host %p\n", u, vha, host);
+			    "Reschedule u %px, vha %px, host %px\n", u, vha, host);
 			if (!queued) {
 				queued = 1;
 				schedule_delayed_work(&vha->unknown_atio_work,
@@ -695,7 +697,7 @@ void qla24xx_do_nack_work(struct scsi_qla_host *vha, struct qla_work_evt *e)
 		mutex_unlock(&vha->vha_tgt.tgt_mutex);
 		if (t) {
 			ql_log(ql_log_info, vha, 0xd034,
-			    "%s create sess success %p", __func__, t);
+			    "%s create sess success %px", __func__, t);
 			/* create sess has an extra kref */
 			vha->hw->tgt.tgt_ops->put_sess(e->u.nack.fcport);
 		}
@@ -775,7 +777,7 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 		    sess->local ? "local " : "", sess->port_name, sess->loop_id);
 
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf007,
-		    "Reappeared sess %p\n", sess);
+		    "Reappeared sess %px\n", sess);
 
 		ha->tgt.tgt_ops->update_sess(sess, fcport->d_id,
 		    fcport->loop_id,
@@ -890,8 +892,8 @@ qlt_plogi_ack_link(struct scsi_qla_host *vha, struct qlt_plogi_ack_t *pla,
 	pla->ref_count++;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf097,
-		"Linking sess %p [%d] wwn %8phC with PLOGI ACK to wwn %8phC"
-		" s_id %02x:%02x:%02x, ref=%d pla %p link %d\n",
+		"Linking sess %px [%d] wwn %8phC with PLOGI ACK to wwn %8phC"
+		" s_id %02x:%02x:%02x, ref=%d pla %px link %d\n",
 		sess, link, sess->port_name,
 		iocb->u.isp24.port_name, iocb->u.isp24.port_id[2],
 		iocb->u.isp24.port_id[1], iocb->u.isp24.port_id[0],
@@ -977,7 +979,7 @@ void qlt_free_session_done(struct work_struct *work)
 		sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN];
 
 	ql_dbg(ql_dbg_disc, vha, 0xf084,
-		"%s: se_sess %p / sess %p from port %8phC loop_id %#04x"
+		"%s: se_sess %px / sess %px from port %8phC loop_id %#04x"
 		" s_id %02x:%02x:%02x logout %d keep %d els_logo %d\n",
 		__func__, sess->se_sess, sess, sess->port_name, sess->loop_id,
 		sess->d_id.b.domain, sess->d_id.b.area, sess->d_id.b.al_pa,
@@ -1021,7 +1023,7 @@ void qlt_free_session_done(struct work_struct *work)
 				    NULL);
 				if (rc != QLA_SUCCESS)
 					ql_log(ql_log_warn, vha, 0xf085,
-					    "Schedule logo failed sess %p rc %d\n",
+					    "Schedule logo failed sess %px rc %d\n",
 					    sess, rc);
 				else
 					logout_started = true;
@@ -1031,7 +1033,7 @@ void qlt_free_session_done(struct work_struct *work)
 				    NULL);
 				if (rc != QLA_SUCCESS)
 					ql_log(ql_log_warn, vha, 0xf085,
-					    "Schedule PRLO failed sess %p rc %d\n",
+					    "Schedule PRLO failed sess %px rc %d\n",
 					    sess, rc);
 				else
 					logout_started = true;
@@ -1058,7 +1060,7 @@ void qlt_free_session_done(struct work_struct *work)
 		while (!READ_ONCE(sess->logout_completed)) {
 			if (!traced) {
 				ql_dbg(ql_dbg_disc, vha, 0xf086,
-					"%s: waiting for sess %p logout\n",
+					"%s: waiting for sess %px logout\n",
 					__func__, sess);
 				traced = true;
 			}
@@ -1074,7 +1076,7 @@ void qlt_free_session_done(struct work_struct *work)
 		}
 
 		ql_dbg(ql_dbg_disc, vha, 0xf087,
-		    "%s: sess %p logout completed\n", __func__, sess);
+		    "%s: sess %px logout completed\n", __func__, sess);
 	}
 
 	if (sess->logo_ack_needed) {
@@ -1122,7 +1124,7 @@ void qlt_free_session_done(struct work_struct *work)
 		if (con) {
 			iocb = &con->iocb;
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf099,
-				 "se_sess %p / sess %p port %8phC is gone,"
+				 "se_sess %px / sess %px port %8phC is gone,"
 				 " %s (ref=%d), releasing PLOGI for %8phC (ref=%d)\n",
 				 sess->se_sess, sess, sess->port_name,
 				 own ? "releasing own PLOGI" : "no own PLOGI pending",
@@ -1132,7 +1134,7 @@ void qlt_free_session_done(struct work_struct *work)
 			sess->plogi_link[QLT_PLOGI_LINK_CONFLICT] = NULL;
 		} else {
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf09a,
-			    "se_sess %p / sess %p port %8phC is gone, %s (ref=%d)\n",
+			    "se_sess %px / sess %px port %8phC is gone, %s (ref=%d)\n",
 			    sess->se_sess, sess, sess->port_name,
 			    own ? "releasing own PLOGI" :
 			    "no own PLOGI pending",
@@ -1153,7 +1155,7 @@ void qlt_free_session_done(struct work_struct *work)
 	qla2x00_dfs_remove_rport(vha, sess);
 
 	ql_dbg(ql_dbg_disc, vha, 0xf001,
-	    "Unregistration of sess %p %8phC finished fcp_cnt %d\n",
+	    "Unregistration of sess %px %8phC finished fcp_cnt %d\n",
 		sess, sess->port_name, vha->fcport_count);
 
 	if (tgt && (tgt->sess_count == 0))
@@ -1186,7 +1188,7 @@ void qlt_unreg_sess(struct fc_port *sess)
 	unsigned long flags;
 
 	ql_dbg(ql_dbg_disc, sess->vha, 0x210a,
-	    "%s sess %p for deletion %8phC\n",
+	    "%s sess %px for deletion %8phC\n",
 	    __func__, sess, sess->port_name);
 
 	spin_lock_irqsave(&sess->vha->work_lock, flags);
@@ -1237,14 +1239,14 @@ static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 	}
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe000,
-	    "Using sess for qla_tgt_reset: %p\n", sess);
+	    "Using sess for qla_tgt_reset: %px\n", sess);
 	if (!sess) {
 		res = -ESRCH;
 		return res;
 	}
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe047,
-	    "scsi(%ld): resetting (session %p from port %8phC mcmd %x, "
+	    "scsi(%ld): resetting (session %px from port %8phC mcmd %x, "
 	    "loop_id %d)\n", vha->host_no, sess, sess->port_name,
 	    mcmd, loop_id);
 
@@ -1313,7 +1315,7 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 	qla24xx_chk_fcp_state(sess);
 
 	ql_dbg(ql_log_warn, sess->vha, 0xe001,
-	    "Scheduling sess %p for deletion %8phC fc4_type %x\n",
+	    "Scheduling sess %px for deletion %8phC fc4_type %x\n",
 	    sess, sess->port_name, sess->fc4_type);
 
 	WARN_ON(!queue_work(sess->vha->hw->wq, &sess->del_work));
@@ -1445,7 +1447,7 @@ static struct fc_port *qlt_create_sess(
 	}
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf006,
-	    "Adding sess %p se_sess %p  to tgt %p sess_count %d\n",
+	    "Adding sess %px se_sess %px  to tgt %px sess_count %d\n",
 	    sess, sess->se_sess, vha->vha_tgt.qla_tgt,
 	    vha->vha_tgt.qla_tgt->sess_count);
 
@@ -1489,14 +1491,14 @@ qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport, int max_gen)
 	if (max_gen - sess->generation < 0) {
 		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf092,
-		    "Ignoring stale deletion request for se_sess %p / sess %p"
+		    "Ignoring stale deletion request for se_sess %px / sess %px"
 		    " for port %8phC, req_gen %d, sess_gen %d\n",
 		    sess->se_sess, sess, sess->port_name, max_gen,
 		    sess->generation);
 		return;
 	}
 
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf008, "qla_tgt_fc_port_deleted %p", sess);
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf008, "qla_tgt_fc_port_deleted %px", sess);
 
 	sess->local = 1;
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
@@ -1514,7 +1516,7 @@ static inline int test_tgt_sess_count(struct qla_tgt *tgt)
 	 */
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	ql_dbg(ql_dbg_tgt, tgt->vha, 0xe002,
-	    "tgt %p, sess_count=%d\n",
+	    "tgt %px, sess_count=%d\n",
 	    tgt, tgt->sess_count);
 	res = (tgt->sess_count == 0);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
@@ -1540,7 +1542,7 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 		return -EPERM;
 	}
 
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xe003, "Stopping target for host %ld(%p)\n",
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xe003, "Stopping target for host %ld(%px)\n",
 	    vha->host_no, vha);
 	/*
 	 * Mutex needed to sync with qla_tgt_fc_port_[added,deleted].
@@ -1553,7 +1555,7 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 	mutex_unlock(&qla_tgt_mutex);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf009,
-	    "Waiting for sess works (tgt %p)", tgt);
+	    "Waiting for sess works (tgt %px)", tgt);
 	spin_lock_irqsave(&tgt->sess_work_lock, flags);
 	while (!list_empty(&tgt->sess_works_list)) {
 		spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
@@ -1563,7 +1565,7 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 	spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00a,
-	    "Waiting for tgt %p: sess_count=%d\n", tgt, tgt->sess_count);
+	    "Waiting for tgt %px: sess_count=%d\n", tgt, tgt->sess_count);
 
 	wait_event_timeout(tgt->waitQ, test_tgt_sess_count(tgt), 10*HZ);
 
@@ -1605,7 +1607,7 @@ void qlt_stop_phase2(struct qla_tgt *tgt)
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
 	mutex_unlock(&tgt->ha->optrom_mutex);
 
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00c, "Stop of tgt %p finished\n",
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00c, "Stop of tgt %px finished\n",
 	    tgt);
 
 	switch (vha->qlini_mode) {
@@ -1665,7 +1667,7 @@ static void qlt_release(struct qla_tgt *tgt)
 	vha->vha_tgt.qla_tgt = NULL;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00d,
-	    "Release of tgt %p finished\n", tgt);
+	    "Release of tgt %px finished\n", tgt);
 
 	kfree(tgt);
 }
@@ -1686,8 +1688,8 @@ static int qlt_sched_sess_work(struct qla_tgt *tgt, int type,
 	}
 
 	ql_dbg(ql_dbg_tgt_mgt, tgt->vha, 0xf00e,
-	    "Scheduling work (type %d, prm %p)"
-	    " to find session for param %p (size %d, tgt %p)\n",
+	    "Scheduling work (type %d, prm %px)"
+	    " to find session for param %px (size %d, tgt %px)\n",
 	    type, prm, param, param_size, tgt);
 
 	prm->type = type;
@@ -1718,7 +1720,7 @@ static void qlt_send_notify_ack(struct qla_qpair *qpair,
 	if (!ha->flags.fw_started)
 		return;
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe004, "Sending NOTIFY_ACK (ha=%p)\n", ha);
+	ql_dbg(ql_dbg_tgt, vha, 0xe004, "Sending NOTIFY_ACK (ha=%px)\n", ha);
 
 	pkt = (request_t *)__qla2x00_alloc_iocbs(qpair, NULL);
 	if (!pkt) {
@@ -1783,7 +1785,7 @@ static int qlt_build_abts_resp_iocb(struct qla_tgt_mgmt_cmd *mcmd)
 	struct qla_qpair *qpair = mcmd->qpair;
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe006,
-	    "Sending task mgmt ABTS response (ha=%p, status=%x)\n",
+	    "Sending task mgmt ABTS response (ha=%px, status=%x)\n",
 	    ha, mcmd->fc_tm_rsp);
 
 	rc = qlt_check_reserve_free_req(qpair, 1);
@@ -1869,7 +1871,7 @@ static void qlt_24xx_send_abts_resp(struct qla_qpair *qpair,
 	uint8_t *p;
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe006,
-	    "Sending task mgmt ABTS response (ha=%p, atio=%p, status=%x\n",
+	    "Sending task mgmt ABTS response (ha=%px, atio=%px, status=%x\n",
 	    ha, abts, status);
 
 	resp = (struct abts_resp_to_24xx *)qla2x00_alloc_iocbs_ready(qpair,
@@ -2260,7 +2262,7 @@ static void qlt_24xx_send_task_mgmt_ctio(struct qla_qpair *qpair,
 	uint16_t temp;
 
 	ql_dbg(ql_dbg_tgt, ha, 0xe008,
-	    "Sending task mgmt CTIO7 (ha=%p, atio=%p, resp_code=%x\n",
+	    "Sending task mgmt CTIO7 (ha=%px, atio=%px, resp_code=%x\n",
 	    ha, atio, resp_code);
 
 
@@ -2317,7 +2319,7 @@ void qlt_send_resp_ctio(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 	struct scsi_qla_host *vha = cmd->vha;
 
 	ql_dbg(ql_dbg_tgt_dif, vha, 0x3066,
-	    "Sending response CTIO7 (vha=%p, atio=%p, scsi_status=%02x, "
+	    "Sending response CTIO7 (vha=%px, atio=%px, scsi_status=%02x, "
 	    "sense_key=%02x, asc=%02x, ascq=%02x",
 	    vha, atio, scsi_status, sense_key, asc, ascq);
 
@@ -2382,7 +2384,7 @@ void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 	bool free_mcmd = true;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf013,
-	    "TM response mcmd (%p) status %#x state %#x",
+	    "TM response mcmd (%px) status %#x state %#x",
 	    mcmd, mcmd->fc_tm_rsp, mcmd->flags);
 
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
@@ -2755,28 +2757,28 @@ static void qlt_print_dif_err(struct qla_tgt_prm *prm)
 		case 1:
 			ql_dbg(ql_dbg_tgt_dif, vha, 0xe00b,
 			    "BE detected Guard TAG ERR: lba[0x%llx|%lld] len[0x%x] "
-			    "se_cmd=%p tag[%x]",
+			    "se_cmd=%px tag[%x]",
 			    cmd->lba, cmd->lba, cmd->num_blks, &cmd->se_cmd,
 			    cmd->atio.u.isp24.exchange_addr);
 			break;
 		case 2:
 			ql_dbg(ql_dbg_tgt_dif, vha, 0xe00c,
 			    "BE detected APP TAG ERR: lba[0x%llx|%lld] len[0x%x] "
-			    "se_cmd=%p tag[%x]",
+			    "se_cmd=%px tag[%x]",
 			    cmd->lba, cmd->lba, cmd->num_blks, &cmd->se_cmd,
 			    cmd->atio.u.isp24.exchange_addr);
 			break;
 		case 3:
 			ql_dbg(ql_dbg_tgt_dif, vha, 0xe00f,
 			    "BE detected REF TAG ERR: lba[0x%llx|%lld] len[0x%x] "
-			    "se_cmd=%p tag[%x]",
+			    "se_cmd=%px tag[%x]",
 			    cmd->lba, cmd->lba, cmd->num_blks, &cmd->se_cmd,
 			    cmd->atio.u.isp24.exchange_addr);
 			break;
 		default:
 			ql_dbg(ql_dbg_tgt_dif, vha, 0xe010,
 			    "BE detected Dif ERR: lba[%llx|%lld] len[%x] "
-			    "se_cmd=%p tag[%x]",
+			    "se_cmd=%px tag[%x]",
 			    cmd->lba, cmd->lba, cmd->num_blks, &cmd->se_cmd,
 			    cmd->atio.u.isp24.exchange_addr);
 			break;
@@ -3082,7 +3084,7 @@ qlt_build_ctio_crc2_pkt(struct qla_qpair *qpair, struct qla_tgt_prm *prm)
 	memset(pkt, 0, sizeof(*pkt));
 
 	ql_dbg_qp(ql_dbg_tgt, cmd->qpair, 0xe071,
-		"qla_target(%d):%s: se_cmd[%p] CRC2 prot_op[0x%x] cmd prot sg:cnt[%p:%x] lba[%llu]\n",
+		"qla_target(%d):%s: se_cmd[%px] CRC2 prot_op[0x%x] cmd prot sg:cnt[%px:%x] lba[%llu]\n",
 		cmd->vp_idx, __func__, se_cmd, se_cmd->prot_op,
 		prm->prot_sg, prm->prot_seg_cnt, se_cmd->t_task_lba);
 
@@ -3284,7 +3286,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	}
 
 	ql_dbg_qp(ql_dbg_tgt, qpair, 0xe018,
-	    "is_send_status=%d, cmd->bufflen=%d, cmd->sg_cnt=%d, cmd->dma_data_direction=%d se_cmd[%p] qp %d\n",
+	    "is_send_status=%d, cmd->bufflen=%d, cmd->sg_cnt=%d, cmd->dma_data_direction=%d se_cmd[%px] qp %d\n",
 	    (xmit_type & QLA_TGT_XMIT_STATUS) ?
 	    1 : 0, cmd->bufflen, cmd->sg_cnt, cmd->dma_data_direction,
 	    &cmd->se_cmd, qpair->id);
@@ -3369,7 +3371,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 				    qpair->req);
 
 			ql_dbg_qp(ql_dbg_tgt, qpair, 0x305e,
-			    "Building additional status packet 0x%p.\n",
+			    "Building additional status packet 0x%px.\n",
 			    ctio);
 
 			/*
@@ -3536,7 +3538,7 @@ qlt_handle_dif_error(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 	/* check appl tag */
 	if (cmd->e_app_tag != cmd->a_app_tag) {
 		ql_dbg(ql_dbg_tgt_dif, vha, 0xe00d,
-		    "App Tag ERR: cdb[%x] lba[%llx %llx] blks[%x] [Actual|Expected] Ref[%x|%x], App[%x|%x], Guard [%x|%x] cmd=%p ox_id[%04x]",
+		    "App Tag ERR: cdb[%x] lba[%llx %llx] blks[%x] [Actual|Expected] Ref[%x|%x], App[%x|%x], Guard [%x|%x] cmd=%px ox_id[%04x]",
 		    cmd->cdb[0], lba, (lba+cmd->num_blks), cmd->num_blks,
 		    cmd->a_ref_tag, cmd->e_ref_tag, cmd->a_app_tag,
 		    cmd->e_app_tag, cmd->a_guard, cmd->e_guard, cmd,
@@ -3552,7 +3554,7 @@ qlt_handle_dif_error(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 	/* check ref tag */
 	if (cmd->e_ref_tag != cmd->a_ref_tag) {
 		ql_dbg(ql_dbg_tgt_dif, vha, 0xe00e,
-		    "Ref Tag ERR: cdb[%x] lba[%llx %llx] blks[%x] [Actual|Expected] Ref[%x|%x], App[%x|%x], Guard[%x|%x] cmd=%p ox_id[%04x] ",
+		    "Ref Tag ERR: cdb[%x] lba[%llx %llx] blks[%x] [Actual|Expected] Ref[%x|%x], App[%x|%x], Guard[%x|%x] cmd=%px ox_id[%04x] ",
 		    cmd->cdb[0], lba, (lba+cmd->num_blks), cmd->num_blks,
 		    cmd->a_ref_tag, cmd->e_ref_tag, cmd->a_app_tag,
 		    cmd->e_app_tag, cmd->a_guard, cmd->e_guard, cmd,
@@ -3569,7 +3571,7 @@ qlt_handle_dif_error(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 	/* check guard */
 	if (cmd->e_guard != cmd->a_guard) {
 		ql_dbg(ql_dbg_tgt_dif, vha, 0xe012,
-		    "Guard ERR: cdb[%x] lba[%llx %llx] blks[%x] [Actual|Expected] Ref[%x|%x], App[%x|%x], Guard [%x|%x] cmd=%p ox_id[%04x]",
+		    "Guard ERR: cdb[%x] lba[%llx %llx] blks[%x] [Actual|Expected] Ref[%x|%x], App[%x|%x], Guard [%x|%x] cmd=%px ox_id[%04x]",
 		    cmd->cdb[0], lba, (lba+cmd->num_blks), cmd->num_blks,
 		    cmd->a_ref_tag, cmd->e_ref_tag, cmd->a_app_tag,
 		    cmd->e_app_tag, cmd->a_guard, cmd->e_guard, cmd,
@@ -3618,7 +3620,7 @@ static int __qlt_send_term_imm_notif(struct scsi_qla_host *vha,
 	int ret = 0;
 
 	ql_dbg(ql_dbg_tgt_tmr, vha, 0xe01c,
-	    "Sending TERM ELS CTIO (ha=%p)\n", ha);
+	    "Sending TERM ELS CTIO (ha=%px)\n", ha);
 
 	pkt = (request_t *)qla2x00_alloc_iocbs(vha, NULL);
 	if (pkt == NULL) {
@@ -3683,7 +3685,7 @@ static int __qlt_send_term_exchange(struct qla_qpair *qpair,
 	int ret = 0;
 	uint16_t temp;
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe009, "Sending TERM EXCH CTIO (ha=%p)\n", ha);
+	ql_dbg(ql_dbg_tgt, vha, 0xe009, "Sending TERM EXCH CTIO (ha=%px)\n", ha);
 
 	if (cmd)
 		vha = cmd->vha;
@@ -3699,7 +3701,7 @@ static int __qlt_send_term_exchange(struct qla_qpair *qpair,
 	if (cmd != NULL) {
 		if (cmd->state < QLA_TGT_STATE_PROCESSED) {
 			ql_dbg(ql_dbg_tgt, vha, 0xe051,
-			    "qla_target(%d): Terminating cmd %p with "
+			    "qla_target(%d): Terminating cmd %px with "
 			    "incorrect state %d\n", vha->vp_idx, cmd,
 			    cmd->state);
 		} else
@@ -3825,8 +3827,8 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 	unsigned long flags;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf014,
-	    "qla_target(%d): terminating exchange for aborted cmd=%p "
-	    "(se_cmd=%p, tag=%llu)", vha->vp_idx, cmd, &cmd->se_cmd,
+	    "qla_target(%d): terminating exchange for aborted cmd=%px "
+	    "(se_cmd=%px, tag=%llu)", vha->vp_idx, cmd, &cmd->se_cmd,
 	    se_cmd->tag);
 
 	spin_lock_irqsave(&cmd->cmd_lock, flags);
@@ -3838,7 +3840,7 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 		 *  2) TCM TMR - drain_state_list
 		 */
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf016,
-		    "multiple abort. %p transport_state %x, t_state %x, "
+		    "multiple abort. %px transport_state %x, t_state %x, "
 		    "se_cmd_flags %x\n", cmd, cmd->se_cmd.transport_state,
 		    cmd->se_cmd.t_state, cmd->se_cmd.se_cmd_flags);
 		return -EIO;
@@ -3857,7 +3859,7 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 	struct fc_port *sess = cmd->sess;
 
 	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe074,
-	    "%s: se_cmd[%p] ox_id %04x\n",
+	    "%s: se_cmd[%px] ox_id %04x\n",
 	    __func__, &cmd->se_cmd,
 	    be16_to_cpu(cmd->atio.u.isp24.fcp_hdr.ox_id));
 
@@ -3895,7 +3897,7 @@ static int qlt_term_ctio_exchange(struct qla_qpair *qpair, void *ctio,
 	if (cmd->se_cmd.prot_op)
 		ql_dbg(ql_dbg_tgt_dif, vha, 0xe013,
 		    "Term DIF cmd: lba[0x%llx|%lld] len[0x%x] "
-		    "se_cmd=%p tag[%x] op %#x/%s",
+		    "se_cmd=%px tag[%x] op %#x/%s",
 		     cmd->lba, cmd->lba,
 		     cmd->num_blks, &cmd->se_cmd,
 		     cmd->atio.u.isp24.exchange_addr,
@@ -4024,7 +4026,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 			/* They are OK */
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf058,
 			    "qla_target(%d): CTIO with "
-			    "status %#x received, state %x, se_cmd %p, "
+			    "status %#x received, state %x, se_cmd %px, "
 			    "(LIP_RESET=e, ABORTED=2, TARGET_RESET=17, "
 			    "TIMEOUT=b, INVALID_RX_ID=8)\n", vha->vp_idx,
 			    status, cmd->state, se_cmd);
@@ -4038,7 +4040,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf059,
 			    "qla_target(%d): CTIO with %s status %x "
-			    "received (state %x, se_cmd %p)\n", vha->vp_idx,
+			    "received (state %x, se_cmd %px)\n", vha->vp_idx,
 			    logged_out ? "PORT LOGGED OUT" : "PORT UNAVAILABLE",
 			    status, cmd->state, se_cmd);
 
@@ -4061,7 +4063,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 				(struct ctio_crc_from_fw *)ctio;
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf073,
 			    "qla_target(%d): CTIO with DIF_ERROR status %x "
-			    "received (state %x, ulp_cmd %p) actual_dif[0x%llx] "
+			    "received (state %x, ulp_cmd %px) actual_dif[0x%llx] "
 			    "expect_dif[0x%llx]\n",
 			    vha->vp_idx, status, cmd->state, se_cmd,
 			    *((u64 *)&crc->actual_dif[0]),
@@ -4076,13 +4078,13 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 		case CTIO_FAST_INVALID_REQ:
 		case CTIO_FAST_SPI_ERR:
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05b,
-			    "qla_target(%d): CTIO with EDIF error status 0x%x received (state %x, se_cmd %p\n",
+			    "qla_target(%d): CTIO with EDIF error status 0x%x received (state %x, se_cmd %px\n",
 			    vha->vp_idx, status, cmd->state, se_cmd);
 			break;
 
 		default:
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05b,
-			    "qla_target(%d): CTIO with error status 0x%x received (state %x, se_cmd %p\n",
+			    "qla_target(%d): CTIO with error status 0x%x received (state %x, se_cmd %px\n",
 			    vha->vp_idx, status, cmd->state, se_cmd);
 			break;
 		}
@@ -4115,7 +4117,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 	} else if (cmd->aborted) {
 		cmd->trc_flags |= TRC_CTIO_ABORTED;
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01e,
-		  "Aborted command %p (tag %lld) finished\n", cmd, se_cmd->tag);
+		  "Aborted command %px (tag %lld) finished\n", cmd, se_cmd->tag);
 	} else {
 		cmd->trc_flags |= TRC_CTIO_STRANGE;
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05c,
@@ -4219,7 +4221,7 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	return;
 
 out_term:
-	ql_dbg(ql_dbg_io, vha, 0x3060, "Terminating work cmd %p", cmd);
+	ql_dbg(ql_dbg_io, vha, 0x3060, "Terminating work cmd %px", cmd);
 	/*
 	 * cmd has not sent to target yet, so pass NULL as the second
 	 * argument to qlt_send_term_exchange() and free the memory here.
@@ -4399,7 +4401,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 
 	if (unlikely(tgt->tgt_stop)) {
 		ql_dbg(ql_dbg_io, vha, 0x3061,
-		    "New command while device %p is shutting down\n", tgt);
+		    "New command while device %px is shutting down\n", tgt);
 		return -ENODEV;
 	}
 
@@ -4415,7 +4417,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	 * session deletion, but it's still in sess_del_work wq */
 	if (sess->deleted) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf002,
-		    "New command while old session %p is being deleted\n",
+		    "New command while old session %px is being deleted\n",
 		    sess);
 		return -EFAULT;
 	}
@@ -4622,7 +4624,7 @@ void qlt_logo_completion_handler(fc_port_t *fcport, int rc)
 {
 	if (rc != MBS_COMMAND_COMPLETE) {
 		ql_dbg(ql_dbg_tgt_mgt, fcport->vha, 0xf093,
-			"%s: se_sess %p / sess %p from"
+			"%s: se_sess %px / sess %px from"
 			" port %8phC loop_id %#04x s_id %02x:%02x:%02x"
 			" LOGO failed: %#x\n",
 			__func__,
@@ -4666,7 +4668,7 @@ qlt_find_sess_invalidate_other(scsi_qla_host_t *vha, uint64_t wwn,
 		if (port_id.b24 == other_sess->d_id.b24) {
 			if (loop_id != other_sess->loop_id) {
 				ql_dbg(ql_dbg_disc, vha, 0x1000c,
-				    "Invalidating sess %p loop_id %d wwn %llx.\n",
+				    "Invalidating sess %px loop_id %d wwn %llx.\n",
 				    other_sess, other_sess->loop_id, other_wwn);
 
 				/*
@@ -4682,7 +4684,7 @@ qlt_find_sess_invalidate_other(scsi_qla_host_t *vha, uint64_t wwn,
 				 * kill the session, but don't free the loop_id
 				 */
 				ql_dbg(ql_dbg_disc, vha, 0xf01b,
-				    "Invalidating sess %p loop_id %d wwn %llx.\n",
+				    "Invalidating sess %px loop_id %d wwn %llx.\n",
 				    other_sess, other_sess->loop_id, other_wwn);
 
 				other_sess->keep_nport_handle = 1;
@@ -4697,7 +4699,7 @@ qlt_find_sess_invalidate_other(scsi_qla_host_t *vha, uint64_t wwn,
 		if ((loop_id == other_sess->loop_id) &&
 			(loop_id != FC_NO_LOOP_ID)) {
 			ql_dbg(ql_dbg_disc, vha, 0x1000d,
-			       "Invalidating sess %p loop_id %d wwn %llx.\n",
+			       "Invalidating sess %px loop_id %d wwn %llx.\n",
 			       other_sess, other_sess->loop_id, other_wwn);
 
 			/* Same loop_id but different s_id
@@ -5029,7 +5031,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 				break;
 			default:
 				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf09b,
-				    "PRLI with conflicting sess %p port %8phC\n",
+				    "PRLI with conflicting sess %px port %8phC\n",
 				    conflict_sess, conflict_sess->port_name);
 				conflict_sess->fw_login_state =
 				    DSC_LS_PORT_UNAVAIL;
@@ -5090,7 +5092,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 				 * while last one finishes.
 				 */
 				ql_log(ql_log_warn, sess->vha, 0xf095,
-				    "sess %p PRLI received, before plogi ack.\n",
+				    "sess %px PRLI received, before plogi ack.\n",
 				    sess);
 				qlt_send_term_imm_notif(vha, iocb, 1);
 				res = 0;
@@ -5102,7 +5104,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 			 * since we have deleted the old session during PLOGI
 			 */
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf096,
-			    "PRLI (loop_id %#04x) for existing sess %p (loop_id %#04x)\n",
+			    "PRLI (loop_id %#04x) for existing sess %px (loop_id %#04x)\n",
 			    sess->loop_id, sess, iocb->u.isp24.nport_handle);
 
 			sess->local = 0;
@@ -5173,7 +5175,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		res = qlt_reset(vha, iocb, QLA_TGT_NEXUS_LOSS_SESS);
 
 		ql_dbg(ql_dbg_disc, vha, 0x20fc,
-		    "%s: logo %llx res %d sess %p ",
+		    "%s: logo %llx res %d sess %px ",
 		    __func__, wwn, res, sess);
 		if (res == 0) {
 			/*
@@ -5206,7 +5208,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		    iocb->u.isp24.port_name, 1);
 		if (sess) {
 			ql_dbg(ql_dbg_disc, vha, 0x20fd,
-				"sess %p lid %d|%d DS %d LS %d\n",
+				"sess %px lid %d|%d DS %d LS %d\n",
 				sess, sess->loop_id, loop_id,
 				sess->disc_state, sess->fw_login_state);
 		}
@@ -5454,7 +5456,7 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 
 	if (unlikely(tgt->tgt_stop)) {
 		ql_dbg(ql_dbg_io, vha, 0x300a,
-			"New command while device %p is shutting down\n", tgt);
+			"New command while device %px is shutting down\n", tgt);
 		return;
 	}
 
@@ -5569,7 +5571,7 @@ qlt_free_qfull_cmds(struct qla_qpair *qpair)
 			    be16_to_cpu(cmd->atio.u.isp24.fcp_hdr.ox_id));
 		else
 			ql_dbg(ql_dbg_io, vha, 0x3008,
-			    "%s: Unexpected cmd in QFull list %p\n", __func__,
+			    "%s: Unexpected cmd in QFull list %px\n", __func__,
 			    cmd);
 
 		list_move_tail(&cmd->cmd_list, &free_list);
@@ -5641,7 +5643,7 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 
 	if (unlikely(tgt == NULL)) {
 		ql_dbg(ql_dbg_tgt, vha, 0x3064,
-		    "ATIO pkt, but no tgt (ha %p)", ha);
+		    "ATIO pkt, but no tgt (ha %px)", ha);
 		return;
 	}
 	/*
@@ -5847,7 +5849,7 @@ static void qlt_response_pkt(struct scsi_qla_host *vha,
 
 	if (unlikely(tgt == NULL)) {
 		ql_dbg(ql_dbg_tgt, vha, 0xe05d,
-		    "qla_target(%d): Response pkt %x received, but no tgt (ha %p)\n",
+		    "qla_target(%d): Response pkt %x received, but no tgt (ha %px)\n",
 		    vha->vp_idx, pkt->entry_type, vha->hw);
 		return;
 	}
@@ -6381,7 +6383,7 @@ static void qlt_sess_work_fn(struct work_struct *work)
 	struct scsi_qla_host *vha = tgt->vha;
 	unsigned long flags;
 
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf000, "Sess work (tgt %p)", tgt);
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf000, "Sess work (tgt %px)", tgt);
 
 	spin_lock_irqsave(&tgt->sess_work_lock, flags);
 	while (!list_empty(&tgt->sess_works_list)) {
@@ -6433,7 +6435,7 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 	}
 
 	ql_dbg(ql_dbg_tgt, base_vha, 0xe03b,
-	    "Registering target for host %ld(%p).\n", base_vha->host_no, ha);
+	    "Registering target for host %ld(%px).\n", base_vha->host_no, ha);
 
 	BUG_ON(base_vha->vha_tgt.qla_tgt != NULL);
 
@@ -6528,7 +6530,7 @@ int qlt_remove_target(struct qla_hw_data *ha, struct scsi_qla_host *vha)
 	/* free left over qfull cmds */
 	qlt_init_term_exchange(vha);
 
-	ql_dbg(ql_dbg_tgt, vha, 0xe03c, "Unregistering target for host %ld(%p)",
+	ql_dbg(ql_dbg_tgt, vha, 0xe03c, "Unregistering target for host %ld(%px)",
 	    vha->host_no, ha);
 	qlt_release(vha->vha_tgt.qla_tgt);
 
@@ -7324,7 +7326,7 @@ qlt_update_vp_map(struct scsi_qla_host *vha, int cmd)
 		slot = btree_lookup32(&vha->hw->host_map, key);
 		if (!slot) {
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf018,
-			    "Save vha in host_map %p %06x\n", vha, key);
+			    "Save vha in host_map %px %06x\n", vha, key);
 			rc = btree_insert32(&vha->hw->host_map,
 				key, vha, GFP_ATOMIC);
 			if (rc)
@@ -7334,7 +7336,7 @@ qlt_update_vp_map(struct scsi_qla_host *vha, int cmd)
 			return;
 		}
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf019,
-		    "replace existing vha in host_map %p %06x\n", vha, key);
+		    "replace existing vha in host_map %px %06x\n", vha, key);
 		btree_update32(&vha->hw->host_map, key, vha);
 		break;
 	case RESET_VP_IDX:
@@ -7344,7 +7346,7 @@ qlt_update_vp_map(struct scsi_qla_host *vha, int cmd)
 		break;
 	case RESET_AL_PA:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01a,
-		   "clear vha in host_map %p %06x\n", vha, key);
+		   "clear vha in host_map %px %06x\n", vha, key);
 		slot = btree_lookup32(&vha->hw->host_map, key);
 		if (slot)
 			btree_remove32(&vha->hw->host_map, key);
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 26c13a953b97..aa520ccefc3b 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -1017,7 +1017,7 @@ qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 			buf += fwdt->dump_size;
 			walk_template_only = true;
 			ql_log(ql_log_warn, vha, 0x02f4,
-			       "-> MPI firmware already dumped -- dump saving to temporary buffer %p.\n",
+			       "-> MPI firmware already dumped -- dump saving to temporary buffer %px.\n",
 			       buf);
 		}
 
@@ -1043,7 +1043,7 @@ qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 		vha->hw->mpi_fw_dumped = 1;
 
 		ql_log(ql_log_warn, vha, 0x02f8,
-		       "-> MPI firmware dump saved to buffer (%lu/%p)\n",
+		       "-> MPI firmware dump saved to buffer (%lu/%px)\n",
 		       vha->host_no, vha->hw->mpi_fw_dump);
 		qla2x00_post_uevent_work(vha, QLA_UEVENT_CODE_FW_DUMP);
 	}
@@ -1062,7 +1062,7 @@ qla27xx_fwdump(scsi_qla_host_t *vha)
 		ql_log(ql_log_warn, vha, 0xd01e, "-> fwdump no buffer\n");
 	} else if (vha->hw->fw_dumped) {
 		ql_log(ql_log_warn, vha, 0xd01f,
-		    "-> Firmware already dumped (%p) -- ignoring request\n",
+		    "-> Firmware already dumped (%px) -- ignoring request\n",
 		    vha->hw->fw_dump);
 	} else {
 		struct fwdt *fwdt = vha->hw->fwdt;
@@ -1088,7 +1088,7 @@ qla27xx_fwdump(scsi_qla_host_t *vha)
 		vha->hw->fw_dumped = true;
 
 		ql_log(ql_log_warn, vha, 0xd015,
-		    "-> Firmware dump saved to buffer (%lu/%p) <%lx>\n",
+		    "-> Firmware dump saved to buffer (%lu/%px) <%lx>\n",
 		    vha->host_no, vha->hw->fw_dump, vha->hw->fw_dump_cap_flags);
 		qla2x00_post_uevent_work(vha, QLA_UEVENT_CODE_FW_DUMP);
 	}
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 03de1bcf1461..3dc9438a1f21 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -392,7 +392,7 @@ static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 		 * can get ahead of this cmd. tcm_qla2xxx_aborted_task
 		 * already kick start the free.
 		 */
-		pr_debug("write_pending aborted cmd[%p] refcount %d "
+		pr_debug("write_pending aborted cmd[%px] refcount %d "
 			"transport_state %x, t_state %x, se_cmd_flags %x\n",
 			cmd, kref_read(&cmd->se_cmd.cmd_kref),
 			cmd->se_cmd.transport_state,
@@ -659,7 +659,7 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 		 * can get ahead of this cmd. tcm_qla2xxx_aborted_task
 		 * already kick start the free.
 		 */
-		pr_debug("queue_data_in aborted cmd[%p] refcount %d "
+		pr_debug("queue_data_in aborted cmd[%px] refcount %d "
 			"transport_state %x, t_state %x, se_cmd_flags %x\n",
 			cmd, kref_read(&cmd->se_cmd.cmd_kref),
 			cmd->se_cmd.transport_state,
@@ -701,7 +701,7 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 		 * already kick start the free.
 		 */
 		pr_debug(
-		    "queue_data_in aborted cmd[%p] refcount %d transport_state %x, t_state %x, se_cmd_flags %x\n",
+		    "queue_data_in aborted cmd[%px] refcount %d transport_state %x, t_state %x, se_cmd_flags %x\n",
 		    cmd, kref_read(&cmd->se_cmd.cmd_kref),
 		    cmd->se_cmd.transport_state, cmd->se_cmd.t_state,
 		    cmd->se_cmd.se_cmd_flags);
@@ -740,7 +740,7 @@ static void tcm_qla2xxx_queue_tm_rsp(struct se_cmd *se_cmd)
 	struct qla_tgt_mgmt_cmd *mcmd = container_of(se_cmd,
 				struct qla_tgt_mgmt_cmd, se_cmd);
 
-	pr_debug("queue_tm_rsp: mcmd: %p func: 0x%02x response: 0x%02x\n",
+	pr_debug("queue_tm_rsp: mcmd: %px func: 0x%02x response: 0x%02x\n",
 			mcmd, se_tmr->function, se_tmr->response);
 	/*
 	 * Do translation between TCM TM response codes and
@@ -815,7 +815,7 @@ static void tcm_qla2xxx_clear_nacl_from_fcport_map(struct fc_port *sess)
 			       node, GFP_ATOMIC);
 	}
 
-	pr_debug("Removed from fcport_map: %p for WWNN: 0x%016LX, port_id: 0x%06x\n",
+	pr_debug("Removed from fcport_map: %px for WWNN: 0x%016LX, port_id: 0x%06x\n",
 	    se_nacl, nacl->nport_wwnn, nacl->nport_id);
 	/*
 	 * Now clear the se_nacl and session pointers from our HW lport lookup
@@ -1202,7 +1202,7 @@ static struct fc_port *tcm_qla2xxx_find_sess_by_s_id(scsi_qla_host_t *vha,
 		pr_debug("Unable to locate s_id: 0x%06x\n", key);
 		return NULL;
 	}
-	pr_debug("find_sess_by_s_id: located se_nacl: %p, initiatorname: %s\n",
+	pr_debug("find_sess_by_s_id: located se_nacl: %px, initiatorname: %s\n",
 	    se_nacl, se_nacl->initiatorname);
 
 	nacl = container_of(se_nacl, struct tcm_qla2xxx_nacl, se_node_acl);
@@ -1276,7 +1276,7 @@ static void tcm_qla2xxx_set_sess_by_s_id(
 	fc_port->se_sess = se_sess;
 	nacl->fc_port = fc_port;
 
-	pr_debug("Setup nacl->fc_port %p by s_id for se_nacl: %p, initiatorname: %s\n",
+	pr_debug("Setup nacl->fc_port %px by s_id for se_nacl: %px, initiatorname: %s\n",
 	    nacl->fc_port, new_se_nacl, new_se_nacl->initiatorname);
 }
 
@@ -1379,7 +1379,7 @@ static void tcm_qla2xxx_set_sess_by_loop_id(
 	if (nacl->fc_port != fc_port)
 		nacl->fc_port = fc_port;
 
-	pr_debug("Setup nacl->fc_port %p by loop_id for se_nacl: %p, initiatorname: %s\n",
+	pr_debug("Setup nacl->fc_port %px by loop_id for se_nacl: %px, initiatorname: %s\n",
 	    nacl->fc_port, new_se_nacl, new_se_nacl->initiatorname);
 }
 
@@ -1516,7 +1516,7 @@ static void tcm_qla2xxx_update_sess(struct fc_port *sess, port_id_t s_id,
 
 
 	if (sess->loop_id != loop_id || sess->d_id.b24 != s_id.b24)
-		pr_info("Updating session %p from port %8phC loop_id %d -> %d s_id %x:%x:%x -> %x:%x:%x\n",
+		pr_info("Updating session %px from port %8phC loop_id %d -> %d s_id %x:%x:%x -> %x:%x:%x\n",
 		    sess, sess->port_name,
 		    sess->loop_id, loop_id, sess->d_id.b.domain,
 		    sess->d_id.b.area, sess->d_id.b.al_pa, s_id.b.domain,
-- 
2.19.0.rc0


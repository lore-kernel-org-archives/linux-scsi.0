Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC959C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 10:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B27EE6109E
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 10:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbhJ0KCp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 06:02:45 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29434 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241513AbhJ0KCJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 06:02:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R6I99H032380
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 02:59:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=E5IEYh5iyeUK1zaX2YS02F/NPdFoWLmtYHOWMWPAcoc=;
 b=gXRPfQgq5kXGOWIe2ENVdHTQbguNFCq5D/SX1A2pUv6on8IqrNpH2xV+8uATH1G4XyLX
 DfJi2hkRrWXQVveLRglN2XS1ZqQVbVoMt8YUDifZ/IS8KWk+heNVJlJwrYpjMrur7Z/k
 HnqMYIf6oBOEz6oDIpySijrZR5wF/SSuf+i/8zevli+cteYYxiklWFyTnrcvzO0xbthz
 xJPCT56mgwcr7j/i3i8+5DF+99M99CYqQbaffmARDKZDYvj1h/wa42sgPG8d3Z7u+gbx
 9bjmZCurGF/6jrpT3SczBK3fgx2OEB3+EsNlQt9qxaewdZXlYw2sxptCpn8eejqaGXoc AA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3by1ca8tjs-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 02:59:44 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 02:59:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 02:59:41 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id EBA273F7077;
        Wed, 27 Oct 2021 02:59:40 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19R9xerc016429;
        Wed, 27 Oct 2021 02:59:40 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19R9xeeJ016428;
        Wed, 27 Oct 2021 02:59:40 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v4 08/13] qla2xxx: edif: tweak trace message
Date:   Wed, 27 Oct 2021 02:58:46 -0700
Message-ID: <20211027095851.16362-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211027095851.16362-1-njavali@marvell.com>
References: <20211027095851.16362-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: QZFRLCECokFl6I_WuICOiKe3R6jo8OFS
X-Proofpoint-ORIG-GUID: QZFRLCECokFl6I_WuICOiKe3R6jo8OFS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_03,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Modify trace messages for additional debugability.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  4 ++--
 drivers/scsi/qla2xxx/qla_edif.c |  6 +++++-
 drivers/scsi/qla2xxx/qla_init.c | 15 +++++++++------
 drivers/scsi/qla2xxx/qla_isr.c  |  4 ++++
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 8924eeb9367d..9ebf4a234d9a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -639,9 +639,9 @@ struct qla_els_pt_arg {
 	u8 els_opcode;
 	u8 vp_idx;
 	__le16 nport_handle;
-	u16 control_flags;
+	u16 control_flags, ox_id;
 	__le32 rx_xchg_address;
-	port_id_t did;
+	port_id_t did, sid;
 	u32 tx_len, tx_byte_count, rx_len, rx_byte_count;
 	dma_addr_t tx_addr, rx_addr;
 
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 30f33065d114..f0f799fdc117 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1759,7 +1759,8 @@ qla_els_reject_iocb(scsi_qla_host_t *vha, struct qla_qpair *qp,
 	qla_els_pt_iocb(vha, els_iocb, a);
 
 	ql_dbg(ql_dbg_edif, vha, 0x0183,
-	    "Sending ELS reject...\n");
+	    "Sending ELS reject ox_id %04x s:%06x -> d:%06x\n",
+	    a->ox_id, a->sid.b24, a->did.b24);
 	ql_dump_buffer(ql_dbg_edif + ql_dbg_verbose, vha, 0x0185,
 	    vha->hw->elsrej.c, sizeof(*vha->hw->elsrej.c));
 	/* flush iocb to mem before notifying hw doorbell */
@@ -2354,6 +2355,7 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 	a.tx_addr = vha->hw->elsrej.cdma;
 	a.vp_idx = vha->vp_idx;
 	a.control_flags = EPD_ELS_RJT;
+	a.ox_id = le16_to_cpu(p->ox_id);
 
 	sid = p->s_id[0] | (p->s_id[1] << 8) | (p->s_id[2] << 16);
 
@@ -2403,6 +2405,8 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 	purex->pur_info.pur_did.b.al_pa =  p->d_id[0];
 	purex->pur_info.vp_idx = p->vp_idx;
 
+	a.sid = purex->pur_info.pur_did;
+
 	rc = __qla_copy_purex_to_buffer(vha, pkt, rsp, purex->msgp,
 		purex->msgp_len);
 	if (rc) {
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2ccdc76cf0d9..dbffc59e1677 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -333,9 +333,6 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 		    vha->e_dbell.db_flags & EDB_ACTIVE) {
 			lio->u.logio.flags |=
 				(SRB_LOGIN_FCSP | SRB_LOGIN_SKIP_PRLI);
-			ql_dbg(ql_dbg_disc, vha, 0x2072,
-			    "Async-login: w/ FCSP %8phC hdl=%x, loopid=%x portid=%06x\n",
-			    fcport->port_name, sp->handle, fcport->loop_id, fcport->d_id.b24);
 		} else {
 			lio->u.logio.flags |= SRB_LOGIN_COND_PLOGI;
 		}
@@ -344,12 +341,14 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	if (NVME_TARGET(vha->hw, fcport))
 		lio->u.logio.flags |= SRB_LOGIN_SKIP_PRLI;
 
+	rval = qla2x00_start_sp(sp);
+
 	ql_dbg(ql_dbg_disc, vha, 0x2072,
-	       "Async-login - %8phC hdl=%x, loopid=%x portid=%06x retries=%d.\n",
+	       "Async-login - %8phC hdl=%x, loopid=%x portid=%06x retries=%d %s.\n",
 	       fcport->port_name, sp->handle, fcport->loop_id,
-	       fcport->d_id.b24, fcport->login_retry);
+	       fcport->d_id.b24, fcport->login_retry,
+	       lio->u.logio.flags & SRB_LOGIN_FCSP ? "FCSP" : "");
 
-	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
 		fcport->flags |= FCF_LOGIN_NEEDED;
 		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
@@ -5867,6 +5866,10 @@ void qla_register_fcport_fn(struct work_struct *work)
 
 	qla2x00_update_fcport(fcport->vha, fcport);
 
+	ql_dbg(ql_dbg_disc, fcport->vha, 0x911e,
+	       "%s rscn gen %d/%d next DS %d\n", __func__,
+	       rscn_gen, fcport->rscn_gen, fcport->next_disc_state);
+
 	if (rscn_gen != fcport->rscn_gen) {
 		/* RSCN(s) came in while registration */
 		switch (fcport->next_disc_state) {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b26f2699adb2..aaf6504570fd 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2233,6 +2233,10 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 				}
 
 			} else if (comp_status == CS_PORT_LOGGED_OUT) {
+				ql_dbg(ql_dbg_disc, vha, 0x911e,
+				       "%s %d schedule session deletion\n",
+				       __func__, __LINE__);
+
 				els->u.els_plogi.len = 0;
 				res = DID_IMM_RETRY << 16;
 				qlt_schedule_sess_for_deletion(sp->fcport);
-- 
2.19.0.rc0


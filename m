Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D6EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 07:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28E5C6112D
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 07:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhJUHeu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 03:34:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51178 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231283AbhJUHep (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 03:34:45 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19KMsQa5002523
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 00:32:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=hIhMDGSCDEsO0M7+ljcUUwcBXAOplPz7QDfoiyUzLzQ=;
 b=dwt4WQ6x0GUvMIIN/5rT1On1x6RCdVKkBRHQIl8L15EEbGkkupCYI/5gcATXI8xJ3NJr
 Ucw4q7lJC33eFnIzNneUBQ2TiluMFXUoHybgk+TqTnCiJsZnrgC6h9VKIN9StpA/XhQX
 ufs0OH6nPF3YRu780AThAe0cDhxinyghb0SPX1qNKnR/Xgxc8da97yCqv9GhFQ0jk6Sa
 8EoIZBfI7B1LLwCrMywzfiUKvQkoOPomXYqdweUBGFLi36HGbubml6SU1di2gjEVqEvn
 7NdQTahnzmzhHZ7fvol/XO9Jo8Vwnlyqq48eYeog0dDNog8D1R8gy1anmAy/dnFBi0ek TA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3btjwdmrxn-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 00:32:29 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 21 Oct
 2021 00:32:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 21 Oct 2021 00:32:27 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 220EE3F70A0;
        Thu, 21 Oct 2021 00:32:27 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19L7WQPk027641;
        Thu, 21 Oct 2021 00:32:26 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19L7WQqu027640;
        Thu, 21 Oct 2021 00:32:26 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 06/13] qla2xxx: edif: flush stale events and msgs on session down
Date:   Thu, 21 Oct 2021 00:32:01 -0700
Message-ID: <20211021073208.27582-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211021073208.27582-1-njavali@marvell.com>
References: <20211021073208.27582-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: wrIKxUkGYkVyAc6JhFp8GCB4boa8qvJ7
X-Proofpoint-ORIG-GUID: wrIKxUkGYkVyAc6JhFp8GCB4boa8qvJ7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_02,2021-10-20_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

On session down, driver will flush all stale messages and
doorbell events. This prevents authentication application
from having to process stale data.

Fixes: 4de067e5df12 ("scsi: qla2xxx: edif: Add N2N support for EDIF")
Signed-off-by: Karunakara Merugu <kmerugu@marvell.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c   | 99 ++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_gbl.h    |  2 +
 drivers/scsi/qla2xxx/qla_target.c |  1 +
 3 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 33cdcdf9f511..b4eca966067a 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1595,6 +1595,41 @@ qla_enode_stop(scsi_qla_host_t *vha)
 	spin_unlock_irqrestore(&vha->pur_cinfo.pur_lock, flags);
 }
 
+static void qla_enode_clear(scsi_qla_host_t *vha, port_id_t portid)
+{
+	unsigned    long flags;
+	struct enode    *e, *tmp;
+	struct purexevent   *purex;
+	LIST_HEAD(enode_list);
+
+	if (vha->pur_cinfo.enode_flags != ENODE_ACTIVE) {
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		       "%s enode not active\n", __func__);
+		return;
+	}
+	spin_lock_irqsave(&vha->pur_cinfo.pur_lock, flags);
+	list_for_each_entry_safe(e, tmp, &vha->pur_cinfo.head, list) {
+		purex = &e->u.purexinfo;
+		if (purex->pur_info.pur_sid.b24 == portid.b24) {
+			ql_dbg(ql_dbg_edif, vha, 0x911d,
+			    "%s free ELS sid=%x. xchg %x, nb=%xh\n",
+			    __func__, portid.b24,
+			    purex->pur_info.pur_rx_xchg_address,
+			    purex->pur_info.pur_bytes_rcvd);
+
+			list_del_init(&e->list);
+			list_add_tail(&e->list, &enode_list);
+		}
+	}
+
+	spin_unlock_irqrestore(&vha->pur_cinfo.pur_lock, flags);
+
+	list_for_each_entry_safe(e, tmp, &enode_list, list) {
+		list_del_init(&e->list);
+		qla_enode_free(vha, e);
+	}
+}
+
 /*
  *  allocate enode struct and populate buffer
  *  returns: enode pointer with buffers
@@ -1794,6 +1829,59 @@ qla_edb_node_free(scsi_qla_host_t *vha, struct edb_node *node)
 	node->ntype = N_UNDEF;
 }
 
+static void qla_edb_clear(scsi_qla_host_t *vha, port_id_t portid)
+{
+	unsigned long flags;
+	struct edb_node *e, *tmp;
+	port_id_t sid;
+	LIST_HEAD(edb_list);
+
+	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+		/* doorbell list not enabled */
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		       "%s doorbell not enabled\n", __func__);
+		return;
+	}
+
+	/* grab lock so list doesn't move */
+	spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
+
+	list_for_each_entry_safe(e, tmp, &vha->e_dbell.head, list) {
+		switch (e->ntype) {
+		case VND_CMD_AUTH_STATE_NEEDED:
+		case VND_CMD_AUTH_STATE_SESSION_SHUTDOWN:
+			sid = e->u.plogi_did;
+			break;
+		case VND_CMD_AUTH_STATE_ELS_RCVD:
+			sid = e->u.els_sid;
+			break;
+		case VND_CMD_AUTH_STATE_SAUPDATE_COMPL:
+			/* app wants to see this  */
+			continue;
+		default:
+			ql_log(ql_log_warn, vha, 0x09102,
+			       "%s unknown type: %x\n", __func__, e->ntype);
+			sid.b24 = 0;
+			break;
+		}
+		if (sid.b24 == portid.b24) {
+			ql_dbg(ql_dbg_edif, vha, 0x910f,
+			       "%s Doorbell free : type=%x %p\n",
+			       __func__, e->ntype, e);
+			list_del_init(&e->list);
+			list_add_tail(&e->list, &edb_list);
+		}
+	}
+
+	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
+
+	list_for_each_entry_safe(e, tmp, &edb_list, list) {
+		qla_edb_node_free(vha, e);
+		list_del_init(&e->list);
+		kfree(e);
+	}
+}
+
 /* function called when app is stopping */
 
 void
@@ -2380,7 +2468,7 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 	ql_dbg(ql_dbg_edif, host, 0x0910c,
 	    "%s COMPLETE purex->pur_info.pur_bytes_rcvd =%xh s:%06x -> d:%06x xchg=%xh\n",
 	    __func__, purex->pur_info.pur_bytes_rcvd, purex->pur_info.pur_sid.b24,
-	    purex->pur_info.pur_did.b24, p->rx_xchg_addr);
+	    purex->pur_info.pur_did.b24, purex->pur_info.pur_rx_xchg_address);
 
 	qla_edb_eventcreate(host, VND_CMD_AUTH_STATE_ELS_RCVD, sid, 0, NULL);
 }
@@ -3403,3 +3491,12 @@ void qla_edif_sess_down(struct scsi_qla_host *vha, struct fc_port *sess)
 		qla2x00_post_aen_work(vha, FCH_EVT_PORT_OFFLINE, sess->d_id.b24);
 	}
 }
+
+void qla_edif_clear_appdata(struct scsi_qla_host *vha, struct fc_port *fcport)
+{
+	if (!(fcport->flags & FCF_FCSP_DEVICE))
+		return;
+
+	qla_edb_clear(vha, fcport->d_id);
+	qla_enode_clear(vha, fcport->d_id);
+}
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 8faaa0ec595d..76b89bd297dc 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -142,6 +142,8 @@ void qlt_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha, fc_port_t *fcport,
 void qla2x00_release_all_sadb(struct scsi_qla_host *vha, struct fc_port *fcport);
 int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsgjob);
 void qla_edif_sess_down(struct scsi_qla_host *vha, struct fc_port *sess);
+void qla_edif_clear_appdata(struct scsi_qla_host *vha,
+			    struct fc_port *fcport);
 const char *sc_to_str(uint16_t cmd);
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b3478ed9b12e..edc34e69d75b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1003,6 +1003,7 @@ void qlt_free_session_done(struct work_struct *work)
 					"%s bypassing release_all_sadb\n",
 					__func__);
 			}
+			qla_edif_clear_appdata(vha, sess);
 			qla_edif_sess_down(vha, sess);
 		}
 		qla2x00_mark_device_lost(vha, sess, 0);
-- 
2.19.0.rc0


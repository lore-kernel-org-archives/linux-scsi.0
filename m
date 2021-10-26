Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74225C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 11:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5680960F0F
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 11:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235615AbhJZL5B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 07:57:01 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13912 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233479AbhJZL45 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 07:56:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QAMggW014676
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 04:54:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=BayTfWkhbm8cN2mq67Vw382fT5UpF6jzgnhAMHqRLgQ=;
 b=XkUlLzgSQW2pWpFXlvqvZSvi25C3xVs5L7HWBuXVcFpRbrjAOiA6rnO2i/VnvalJ9xyB
 csQnL+KOpSk+1wXFrRPopxLv0OYS6CvIswwvG+8+B5WsLM/D9BoZ1bLhT+CF1QHZiHxN
 S4uLSTmf5qQfYHS4GnHm7O08PpOGgdVLWp+NkOF1xobB+GM//5oTFdGg8+sxfPsMZi9O
 oh4Z+dLkgKUhhQCKQBVtYuMOhRDcCcsG0xQY126jdb23e2tgInIXQk7hi+O1FQdyzhEj
 Md+Wc69V4tm0U9s3cx6WXMbQtsen0atVa7Yck1u+BaOIX686bvIVDPJ2452zaPWDwap9 hw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bxfv8gc0q-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 04:54:32 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 04:54:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 04:54:31 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8F0153F709B;
        Tue, 26 Oct 2021 04:54:31 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19QBsVqw027771;
        Tue, 26 Oct 2021 04:54:31 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19QBsV8W027770;
        Tue, 26 Oct 2021 04:54:31 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 09/13] qla2xxx: edif: reduce connection thrash
Date:   Tue, 26 Oct 2021 04:54:08 -0700
Message-ID: <20211026115412.27691-10-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211026115412.27691-1-njavali@marvell.com>
References: <20211026115412.27691-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: _3MmrCwgrmo091ZAneIPFozL6hb-zlmQ
X-Proofpoint-ORIG-GUID: _3MmrCwgrmo091ZAneIPFozL6hb-zlmQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_02,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

On ipsec start by remote port, Target port may use RSCN to
trigger initiator to relogin. If driver is already in the process
of a relogin, then ignore the RSCN and allow the current relogin
to continue. This reduces thrashing of the connection.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |  7 ++++++-
 drivers/scsi/qla2xxx/qla_edif.h |  4 ++++
 drivers/scsi/qla2xxx/qla_init.c | 24 ++++++++++++++++++++++--
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index cb5f2ecb652d..c94f98f4ee68 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2757,7 +2757,12 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 			if (fcport->loop_id != FC_NO_LOOP_ID)
 				fcport->logout_on_delete = 1;
 
-			qlt_schedule_sess_for_deletion(fcport);
+			if (!EDIF_NEGOTIATION_PENDING(fcport)) {
+				ql_dbg(ql_dbg_disc, fcport->vha, 0x911e,
+				       "%s %d schedule session deletion\n", __func__,
+				       __LINE__);
+				qlt_schedule_sess_for_deletion(fcport);
+			}
 		} else {
 			qla2x00_port_logout(fcport->vha, fcport);
 		}
diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
index cd54c1dfe3cb..920b1eace40f 100644
--- a/drivers/scsi/qla2xxx/qla_edif.h
+++ b/drivers/scsi/qla2xxx/qla_edif.h
@@ -132,4 +132,8 @@ struct enode {
 	 _s->disc_state == DSC_DELETED || \
 	 !_s->edif.app_sess_online))
 
+#define EDIF_NEGOTIATION_PENDING(_fcport) \
+	((_fcport->vha.e_dbell.db_flags & EDB_ACTIVE) && \
+	 (_fcport->disc_state == DSC_LOGIN_AUTH_PEND))
+
 #endif	/* __QLA_EDIF_H */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index dbffc59e1677..999e0423891c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1793,8 +1793,28 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 					fcport->d_id.b24, fcport->port_name);
 				return;
 			}
-			fcport->scan_needed = 1;
-			fcport->rscn_gen++;
+
+			if (vha->hw->flags.edif_enabled && vha->e_dbell.db_flags & EDB_ACTIVE) {
+				/*
+				 * On ipsec start by remote port, Target port
+				 * may use RSCN to trigger initiator to
+				 * relogin. If driver is already in the
+				 * process of a relogin, then ignore the RSCN
+				 * and allow the current relogin to continue.
+				 * This reduces thrashing of the connection.
+				 */
+				if (atomic_read(&fcport->state) == FCS_ONLINE) {
+					/*
+					 * If state = online, then set scan_needed=1 to do relogin.
+					 * Otherwise we're already in the middle of a relogin
+					 */
+					fcport->scan_needed = 1;
+					fcport->rscn_gen++;
+				}
+			} else {
+				fcport->scan_needed = 1;
+				fcport->rscn_gen++;
+			}
 		}
 		break;
 	case RSCN_AREA_ADDR:
-- 
2.19.0.rc0


Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB05C4346E
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 07:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFEEF20848
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 07:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgI2HiP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 03:38:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:36298 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgI2HiP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 03:38:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6B5F3AC4D;
        Tue, 29 Sep 2020 07:38:13 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     Nilesh Javali <njavali@marvell.com>, Arun Easi <aeasi@marvell.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] qla2xxx: Do not consume srb greedily
Date:   Tue, 29 Sep 2020 09:38:02 +0200
Message-Id: <20200929073802.18770-1-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qla2xx_process_get_sp_from_handle() will clear the slot which the
current srb is stored. So this function has a side effect. Therefore,
we can't use it in qla24xx_process_mbx_iocb_response() to check
for consistency and later again in qla24xx_mbx_iocb_entry().

Let's move the consistency check directly into
qla24xx_mbx_iocb_entry() and avoid the double call or any open coding
of the qla2xx_process_get_sp_from_handle() functionality.

Fixes: 31a3271ff11b ("scsi: qla2xxx: Handle incorrect entry_type entries")
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
Hi,

Brown bag for me please. My test patch had an open coded version of
qla2xx_process_get_sp_from_handle() which didn't consume the srb. When
I prepared it for sending it out, I 'cleaned' it up by using
qla2xx_process_get_sp_from_handle() twice.

Sorry,
Daniel

 drivers/scsi/qla2xxx/qla_isr.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 96811354f78a..2baba87c4e0c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1839,6 +1839,7 @@ qla24xx_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
     struct mbx_24xx_entry *pkt)
 {
 	const char func[] = "MBX-IOCB2";
+	struct qla_hw_data *ha = vha->hw;
 	srb_t *sp;
 	struct srb_iocb *si;
 	u16 sz, i;
@@ -1848,6 +1849,18 @@ qla24xx_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	if (!sp)
 		return;
 
+	if (sp->type == SRB_SCSI_CMD ||
+	    sp->type == SRB_NVME_CMD ||
+	    sp->type == SRB_TM_CMD) {
+		ql_log(ql_log_warn, vha, 0x509d,
+			"Inconsistent event entry type %d\n", sp->type);
+		if (IS_P3P_TYPE(ha))
+			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
+		else
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		return;
+	}
+
 	si = &sp->u.iocb_cmd;
 	sz = min(ARRAY_SIZE(pkt->mb), ARRAY_SIZE(sp->u.iocb_cmd.u.mbx.in_mb));
 
@@ -3406,32 +3419,6 @@ void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha,
 	sp->done(sp, comp_status);
 }
 
-static void qla24xx_process_mbx_iocb_response(struct scsi_qla_host *vha,
-	struct rsp_que *rsp, struct sts_entry_24xx *pkt)
-{
-	struct qla_hw_data *ha = vha->hw;
-	srb_t *sp;
-	static const char func[] = "MBX-IOCB2";
-
-	sp = qla2x00_get_sp_from_handle(vha, func, rsp->req, pkt);
-	if (!sp)
-		return;
-
-	if (sp->type == SRB_SCSI_CMD ||
-	    sp->type == SRB_NVME_CMD ||
-	    sp->type == SRB_TM_CMD) {
-		ql_log(ql_log_warn, vha, 0x509d,
-			"Inconsistent event entry type %d\n", sp->type);
-		if (IS_P3P_TYPE(ha))
-			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
-		else
-			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-		return;
-	}
-
-	qla24xx_mbx_iocb_entry(vha, rsp->req, (struct mbx_24xx_entry *)pkt);
-}
-
 /**
  * qla24xx_process_response_queue() - Process response queue entries.
  * @vha: SCSI driver HA context
@@ -3539,7 +3526,8 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			    (struct abort_entry_24xx *)pkt);
 			break;
 		case MBX_IOCB_TYPE:
-			qla24xx_process_mbx_iocb_response(vha, rsp, pkt);
+			qla24xx_mbx_iocb_entry(vha, rsp->req,
+			    (struct mbx_24xx_entry *)pkt);
 			break;
 		case VP_CTRL_IOCB_TYPE:
 			qla_ctrlvp_completed(vha, rsp->req,
-- 
2.16.4


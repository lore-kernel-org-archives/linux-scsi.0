Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C525AC43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 08:16:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9778021D7A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 08:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbgIHIP6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 04:15:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:37146 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729733AbgIHIPZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Sep 2020 04:15:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3E022B732;
        Tue,  8 Sep 2020 08:15:24 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Arun Easi <aeasi@marvell.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v3 4/4] qla2xxx: Handle incorrect entry_type entries
Date:   Tue,  8 Sep 2020 10:15:16 +0200
Message-Id: <20200908081516.8561-5-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200908081516.8561-1-dwagner@suse.de>
References: <20200908081516.8561-1-dwagner@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It was observed on an ISP8324 16Gb HBA with fw=8.08.203 (d0d5) in a
PowerPC64 machine that pkt->entry_type was MBX_IOCB_TYPE/0x39 with an
sp->type SRB_SCSI_CMD which is invalid and should not be possible.

Reading the entry_type from the crash dump shows the expected value of
STATUS_TYPE/0x03 but the call trace shows that qla24xx_mbx_iocb_entry()
is used.

Add a check to verify for consistency and reset the HBA if an invalid
state is reached. Obviously, this is only a workaround until the real
problem is solved.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_isr.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b0b6dd2b608d..f953564cbed8 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3406,6 +3406,32 @@ void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha,
 	sp->done(sp, comp_status);
 }
 
+static void qla24xx_process_mbx_iocb_response(struct scsi_qla_host *vha,
+	struct rsp_que *rsp, struct sts_entry_24xx *pkt)
+{
+	struct qla_hw_data *ha = vha->hw;
+	srb_t *sp;
+	const char func[] = "MBX-IOCB2";
+
+	sp = qla2x00_get_sp_from_handle(vha, func, rsp->req, pkt);
+	if (!sp)
+		return;
+
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
+	qla24xx_mbx_iocb_entry(vha, rsp->req, (struct mbx_24xx_entry *)pkt);
+}
+
 /**
  * qla24xx_process_response_queue() - Process response queue entries.
  * @vha: SCSI driver HA context
@@ -3513,8 +3539,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 			    (struct abort_entry_24xx *)pkt);
 			break;
 		case MBX_IOCB_TYPE:
-			qla24xx_mbx_iocb_entry(vha, rsp->req,
-			    (struct mbx_24xx_entry *)pkt);
+			qla24xx_process_mbx_iocb_response(vha, rsp, pkt);
 			break;
 		case VP_CTRL_IOCB_TYPE:
 			qla_ctrlvp_completed(vha, rsp->req,
-- 
2.16.4


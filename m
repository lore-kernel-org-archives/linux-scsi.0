Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF60C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 16:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AB1D20936
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 16:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgHaQTv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 12:19:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:45890 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728404AbgHaQTW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Aug 2020 12:19:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 85518AEA5;
        Mon, 31 Aug 2020 16:19:19 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v2 3/4] qla2xxx: Drop unused function argument from qla2x00_get_sp_from_handle()
Date:   Mon, 31 Aug 2020 18:18:53 +0200
Message-Id: <20200831161854.70879-4-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200831161854.70879-1-dwagner@suse.de>
References: <20200831161854.70879-1-dwagner@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 7c3df1320e5e ("[SCSI] qla2xxx: Code changes to support new
dynamic logging infrastructure.") removed the use of the func
argument.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_gbl.h |  3 +--
 drivers/scsi/qla2xxx/qla_isr.c | 36 ++++++++++++------------------------
 drivers/scsi/qla2xxx/qla_mr.c  |  9 +++------
 3 files changed, 16 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 0ced18f3104e..bbe3dca6d0ab 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -561,8 +561,7 @@ extern void qla2x00_free_irqs(scsi_qla_host_t *);
 extern int qla2x00_get_data_rate(scsi_qla_host_t *);
 extern const char *qla2x00_get_link_speed_str(struct qla_hw_data *, uint16_t);
 extern srb_t *
-qla2x00_get_sp_from_handle(scsi_qla_host_t *, const char *, struct req_que *,
-	void *);
+qla2x00_get_sp_from_handle(scsi_qla_host_t *, struct req_que *, void *);
 extern void
 qla2x00_process_completed_request(struct scsi_qla_host *, struct req_que *,
 	uint32_t);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5d278155e4e7..b787643f5031 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1711,8 +1711,7 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 }
 
 srb_t *
-qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
-    struct req_que *req, void *iocb)
+qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, struct req_que *req, void *iocb)
 {
 	struct qla_hw_data *ha = vha->hw;
 	sts_entry_t *pkt = iocb;
@@ -1750,7 +1749,6 @@ static void
 qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
     struct mbx_entry *mbx)
 {
-	const char func[] = "MBX-IOCB";
 	const char *type;
 	fc_port_t *fcport;
 	srb_t *sp;
@@ -1758,7 +1756,7 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	uint16_t *data;
 	uint16_t status;
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, mbx);
+	sp = qla2x00_get_sp_from_handle(vha, req, mbx);
 	if (!sp)
 		return;
 
@@ -1836,13 +1834,12 @@ static void
 qla24xx_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
     struct mbx_24xx_entry *pkt)
 {
-	const char func[] = "MBX-IOCB2";
 	srb_t *sp;
 	struct srb_iocb *si;
 	u16 sz, i;
 	int res;
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	sp = qla2x00_get_sp_from_handle(vha, req, pkt);
 	if (!sp)
 		return;
 
@@ -1861,11 +1858,10 @@ static void
 qla24xxx_nack_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
     struct nack_to_isp *pkt)
 {
-	const char func[] = "nack";
 	srb_t *sp;
 	int res = 0;
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	sp = qla2x00_get_sp_from_handle(vha, req, pkt);
 	if (!sp)
 		return;
 
@@ -1879,7 +1875,6 @@ static void
 qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
     sts_entry_t *pkt, int iocb_type)
 {
-	const char func[] = "CT_IOCB";
 	const char *type;
 	srb_t *sp;
 	struct bsg_job *bsg_job;
@@ -1887,7 +1882,7 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	uint16_t comp_status;
 	int res = 0;
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	sp = qla2x00_get_sp_from_handle(vha, req, pkt);
 	if (!sp)
 		return;
 
@@ -1952,7 +1947,6 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
     struct sts_entry_24xx *pkt, int iocb_type)
 {
 	struct els_sts_entry_24xx *ese = (struct els_sts_entry_24xx *)pkt;
-	const char func[] = "ELS_CT_IOCB";
 	const char *type;
 	srb_t *sp;
 	struct bsg_job *bsg_job;
@@ -1962,7 +1956,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	int res;
 	struct srb_iocb *els;
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	sp = qla2x00_get_sp_from_handle(vha, req, pkt);
 	if (!sp)
 		return;
 
@@ -2077,7 +2071,6 @@ static void
 qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
     struct logio_entry_24xx *logio)
 {
-	const char func[] = "LOGIO-IOCB";
 	const char *type;
 	fc_port_t *fcport;
 	srb_t *sp;
@@ -2085,7 +2078,7 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 	uint16_t *data;
 	uint32_t iop[2];
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, logio);
+	sp = qla2x00_get_sp_from_handle(vha, req, logio);
 	if (!sp)
 		return;
 
@@ -2206,14 +2199,13 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 static void
 qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
 {
-	const char func[] = "TMF-IOCB";
 	const char *type;
 	fc_port_t *fcport;
 	srb_t *sp;
 	struct srb_iocb *iocb;
 	struct sts_entry_24xx *sts = (struct sts_entry_24xx *)tsk;
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, tsk);
+	sp = qla2x00_get_sp_from_handle(vha, req, tsk);
 	if (!sp)
 		return;
 
@@ -2385,11 +2377,10 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 static void qla_ctrlvp_completed(scsi_qla_host_t *vha, struct req_que *req,
     struct vp_ctrl_entry_24xx *vce)
 {
-	const char func[] = "CTRLVP-IOCB";
 	srb_t *sp;
 	int rval = QLA_SUCCESS;
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, vce);
+	sp = qla2x00_get_sp_from_handle(vha, req, vce);
 	if (!sp)
 		return;
 
@@ -3287,7 +3278,6 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 {
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
-	const char func[] = "ERROR-IOCB";
 	uint16_t que = MSW(pkt->handle);
 	struct req_que *req = NULL;
 	int res = DID_ERROR << 16;
@@ -3317,7 +3307,7 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	case ABORT_IOCB_TYPE:
 	case MBX_IOCB_TYPE:
 	default:
-		sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+		sp = qla2x00_get_sp_from_handle(vha, req, pkt);
 		if (sp) {
 			sp->done(sp, res);
 			return 0;
@@ -3376,11 +3366,10 @@ static void
 qla24xx_abort_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	struct abort_entry_24xx *pkt)
 {
-	const char func[] = "ABT_IOCB";
 	srb_t *sp;
 	struct srb_iocb *abt;
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	sp = qla2x00_get_sp_from_handle(vha, req, pkt);
 	if (!sp)
 		return;
 
@@ -3393,10 +3382,9 @@ void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha,
     struct pt_ls4_request *pkt, struct req_que *req)
 {
 	srb_t *sp;
-	const char func[] = "LS4_IOCB";
 	uint16_t comp_status;
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	sp = qla2x00_get_sp_from_handle(vha, req, pkt);
 	if (!sp)
 		return;
 
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index a8fe4f725fa0..ba41c78d063c 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2187,11 +2187,10 @@ static void
 qlafx00_abort_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 			 struct abort_iocb_entry_fx00 *pkt)
 {
-	const char func[] = "ABT_IOCB";
 	srb_t *sp;
 	struct srb_iocb *abt;
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	sp = qla2x00_get_sp_from_handle(vha, req, pkt);
 	if (!sp)
 		return;
 
@@ -2204,7 +2203,6 @@ static void
 qlafx00_ioctl_iosb_entry(scsi_qla_host_t *vha, struct req_que *req,
 			 struct ioctl_iocb_entry_fx00 *pkt)
 {
-	const char func[] = "IOSB_IOCB";
 	srb_t *sp;
 	struct bsg_job *bsg_job;
 	struct fc_bsg_reply *bsg_reply;
@@ -2213,7 +2211,7 @@ qlafx00_ioctl_iosb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	struct qla_mt_iocb_rsp_fx00 fstatus;
 	uint8_t	*fw_sts_ptr;
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	sp = qla2x00_get_sp_from_handle(vha, req, pkt);
 	if (!sp)
 		return;
 
@@ -2687,14 +2685,13 @@ qlafx00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp,
 {
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
-	const char func[] = "ERROR-IOCB";
 	uint16_t que = 0;
 	struct req_que *req = NULL;
 	int res = DID_ERROR << 16;
 
 	req = ha->req_q_map[que];
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	sp = qla2x00_get_sp_from_handle(vha, req, pkt);
 	if (sp) {
 		sp->done(sp, res);
 		return;
-- 
2.16.4


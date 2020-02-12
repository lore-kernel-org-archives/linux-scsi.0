Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8EACC352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:44:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 950F5217F4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:44:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="D+K6G2eN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgBLVo6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:44:58 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25152 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728447AbgBLVo6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:44:58 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLejZr001670;
        Wed, 12 Feb 2020 13:44:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=/M5Zpxx5mG0ToVLLPYAtNX2y1k83Lm+H/eoiYFsinKs=;
 b=D+K6G2eNeQ3qairEBoTUuN6f2N/x9v71OvvcnWQCj3AySjgS3VUVE25tR9kgArKIIIyp
 DzbWirjoM/yLWBahLtyySpJ6/IhS/I8sd+RwgK3ndQkSh4V0MkUVVNaqZTgS6hyQ3YQZ
 2MNzj4N88xBoOGu0+QLteD7RTpimdwVLZOGCYR0H3UcxI7Yh+mGo5awy58QN+qju33TR
 TH3pcTpwFQ2iswPutuBoDeUVw3LDYJ4itCH1N6qIiJfHoi9tSlKImw+ND+kpQMgo7o/g
 eebZpDhtAH+gJJAbB3i+Q9K3xNzAQQvapAKNUIKvr3mHX14DFP9e5Svp3iRu71FJQSvW tA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt4v9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:44:55 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:44:53 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:44:52 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:44:52 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 618E93F703F;
        Wed, 12 Feb 2020 13:44:52 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLiqjN025588;
        Wed, 12 Feb 2020 13:44:52 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLiqAL025587;
        Wed, 12 Feb 2020 13:44:52 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 05/25] qla2xxx: Add endianizer macro calls to fc host stats
Date:   Wed, 12 Feb 2020 13:44:16 -0800
Message-ID: <20200212214436.25532-6-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200212214436.25532-1-hmadhani@marvell.com>
References: <20200212214436.25532-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_10:2020-02-12,2020-02-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

This patch fixes endian warning for fc_host_stats

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 36 ++++++++++++---------
 drivers/scsi/qla2xxx/qla_def.h  | 69 ++++++++++++++++++++---------------------
 2 files changed, 54 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index becde75d0fbc..d9c8ee820d13 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2745,22 +2745,28 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 	if (rval != QLA_SUCCESS)
 		goto done_free;
 
-	p->link_failure_count = stats->link_fail_cnt;
-	p->loss_of_sync_count = stats->loss_sync_cnt;
-	p->loss_of_signal_count = stats->loss_sig_cnt;
-	p->prim_seq_protocol_err_count = stats->prim_seq_err_cnt;
-	p->invalid_tx_word_count = stats->inval_xmit_word_cnt;
-	p->invalid_crc_count = stats->inval_crc_cnt;
+	p->link_failure_count = le32_to_cpu(stats->link_fail_cnt);
+	p->loss_of_sync_count = le32_to_cpu(stats->loss_sync_cnt);
+	p->loss_of_signal_count = le32_to_cpu(stats->loss_sig_cnt);
+	p->prim_seq_protocol_err_count = le32_to_cpu(stats->prim_seq_err_cnt);
+	p->invalid_tx_word_count = le32_to_cpu(stats->inval_xmit_word_cnt);
+	p->invalid_crc_count = le32_to_cpu(stats->inval_crc_cnt);
 	if (IS_FWI2_CAPABLE(ha)) {
-		p->lip_count = stats->lip_cnt;
-		p->tx_frames = stats->tx_frames;
-		p->rx_frames = stats->rx_frames;
-		p->dumped_frames = stats->discarded_frames;
-		p->nos_count = stats->nos_rcvd;
+		p->lip_count = le32_to_cpu(stats->lip_cnt);
+		p->tx_frames = le32_to_cpu(stats->tx_frames);
+		p->rx_frames = le32_to_cpu(stats->rx_frames);
+		p->dumped_frames = le32_to_cpu(stats->discarded_frames);
+		p->nos_count = le32_to_cpu(stats->nos_rcvd);
 		p->error_frames =
-			stats->dropped_frames + stats->discarded_frames;
-		p->rx_words = vha->qla_stats.input_bytes;
-		p->tx_words = vha->qla_stats.output_bytes;
+		    le32_to_cpu(stats->dropped_frames) +
+		    le32_to_cpu(stats->discarded_frames);
+		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+			p->rx_words = le64_to_cpu(stats->fpm_recv_word_cnt);
+			p->tx_words = le64_to_cpu(stats->fpm_xmit_word_cnt);
+		} else {
+			p->rx_words = vha->qla_stats.input_bytes;
+			p->tx_words = vha->qla_stats.output_bytes;
+		}
 	}
 	p->fcp_control_requests = vha->qla_stats.control_requests;
 	p->fcp_input_requests = vha->qla_stats.input_requests;
@@ -2768,7 +2774,7 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 	p->fcp_input_megabytes = vha->qla_stats.input_bytes >> 20;
 	p->fcp_output_megabytes = vha->qla_stats.output_bytes >> 20;
 	p->seconds_since_last_reset =
-		get_jiffies_64() - vha->qla_stats.jiffies_at_last_reset;
+	    get_jiffies_64() - vha->qla_stats.jiffies_at_last_reset;
 	do_div(p->seconds_since_last_reset, HZ);
 
 done_free:
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 063ba73c7372..209491a1d022 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1475,47 +1475,44 @@ typedef struct {
 #define GLSO_USE_DID	BIT_3
 
 struct link_statistics {
-	uint32_t link_fail_cnt;
-	uint32_t loss_sync_cnt;
-	uint32_t loss_sig_cnt;
-	uint32_t prim_seq_err_cnt;
-	uint32_t inval_xmit_word_cnt;
-	uint32_t inval_crc_cnt;
-	uint32_t lip_cnt;
-	uint32_t link_up_cnt;
-	uint32_t link_down_loop_init_tmo;
-	uint32_t link_down_los;
-	uint32_t link_down_loss_rcv_clk;
+	__le32 link_fail_cnt;
+	__le32 loss_sync_cnt;
+	__le32 loss_sig_cnt;
+	__le32 prim_seq_err_cnt;
+	__le32 inval_xmit_word_cnt;
+	__le32 inval_crc_cnt;
+	__le32 lip_cnt;
+	__le32 link_up_cnt;
+	__le32 link_down_loop_init_tmo;
+	__le32 link_down_los;
+	__le32 link_down_loss_rcv_clk;
 	uint32_t reserved0[5];
-	uint32_t port_cfg_chg;
+	__le32 port_cfg_chg;
 	uint32_t reserved1[11];
-	uint32_t rsp_q_full;
-	uint32_t atio_q_full;
-	uint32_t drop_ae;
-	uint32_t els_proto_err;
-	uint32_t reserved2;
-	uint32_t tx_frames;
-	uint32_t rx_frames;
-	uint32_t discarded_frames;
-	uint32_t dropped_frames;
+	__le32 rsp_q_full;
+	__le32 atio_q_full;
+	__le32 drop_ae;
+	__le32 els_proto_err;
+	__le32 reserved2;
+	__le32 tx_frames;
+	__le32 rx_frames;
+	__le32 discarded_frames;
+	__le32 dropped_frames;
 	uint32_t reserved3;
-	uint32_t nos_rcvd;
+	__le32 nos_rcvd;
 	uint32_t reserved4[4];
-	uint32_t tx_prjt;
-	uint32_t rcv_exfail;
-	uint32_t rcv_abts;
-	uint32_t seq_frm_miss;
-	uint32_t corr_err;
-	uint32_t mb_rqst;
-	uint32_t nport_full;
-	uint32_t eofa;
+	__le32 tx_prjt;
+	__le32 rcv_exfail;
+	__le32 rcv_abts;
+	__le32 seq_frm_miss;
+	__le32 corr_err;
+	__le32 mb_rqst;
+	__le32 nport_full;
+	__le32 eofa;
 	uint32_t reserved5;
-	uint32_t fpm_recv_word_cnt_lo;
-	uint32_t fpm_recv_word_cnt_hi;
-	uint32_t fpm_disc_word_cnt_lo;
-	uint32_t fpm_disc_word_cnt_hi;
-	uint32_t fpm_xmit_word_cnt_lo;
-	uint32_t fpm_xmit_word_cnt_hi;
+	__le64 fpm_recv_word_cnt;
+	__le64 fpm_disc_word_cnt;
+	__le64 fpm_xmit_word_cnt;
 	uint32_t reserved6[70];
 };
 
-- 
2.12.0


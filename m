Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1177CC4320E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 02:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED8696109F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 02:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238098AbhHMCJZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 22:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237496AbhHMCJU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 22:09:20 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E555C061756
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 19:08:54 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id om1-20020a17090b3a8100b0017941c44ce4so125771pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 19:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LkuYj2ysOwnCh8t89oLZM1e5OOYtT3bPSd8gwuIXLt8=;
        b=ecLORe+gFWolhS/FqBjJsiwmpH+JEjkfjKNzT0pvDTXbzGDp28RfFQvR1/x6jToJCp
         0/Kuy4A9y7mJm2YHeCAJjFyotEMDRPe4LtsvWgLBUUhkjdBHEn8cLAFLe+DeR3D+uF5Y
         qRv6Hn27rxTYBjlfBbn7mCCdDkFtbTV0jwGOA8/3cxdlpTNx2WQ6GRh25bu8sqObuol8
         5GrOa08SzGIyiW7ES63CWnTTEFm6UG9dtIbEDL0/LlXHRkItiMKWZSShQHwctKHWsRBg
         /V66eZMyaj6mtZyyVOvNQi75ueU0+IifhCO+0epmQ+SLN7wkH1r1nL8NG9cP7WVooJhM
         1KpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LkuYj2ysOwnCh8t89oLZM1e5OOYtT3bPSd8gwuIXLt8=;
        b=rD/XUvmpybEhtftTJJuccGRNBMGG4BRmB4JzCQW4DQA9sLfuzq3hl3bWBMI447En18
         LM7SQ5YJ639Sb3uIBNJ+52JKh7f7yoXDPx1XLWHtKZHWnqJP6VdTtewdFZOdrsvrTlEM
         jR554M5DeHzaHqUnNWZ9XboLKZvMvcJ14kufcnho0stzBz6ipiB4XuXTHeVnOyj6XiJi
         mAOeSEGJU6p76/C49f1sUwD2x8LEpA/CbA2FlIxl+1UyhWQWVMHW2kE9lp0B4M7Z2qTs
         LwhYT+39wrzXAD4gAj9dG0FhbTUHxv7FDAwWMxz8V4NNAidsE2mrPIkRs0h1EGRTJzg4
         V5+A==
X-Gm-Message-State: AOAM532e7GyimHqX+Gw+clDrSix0Xgq5HqgYL6B5DpyQ29nFnSWAZVqv
        CvRfDHnBLRbqqaFjPsRhpZnmnaTiXu0=
X-Google-Smtp-Source: ABdhPJz3Q2rYhqZ4SobJhWcLpeCyUg7xnYwctjT2c9q5hcQgQkq90ipRexFYtPLA/B9j0BeuepErfw==
X-Received: by 2002:a63:8948:: with SMTP id v69mr81550pgd.132.1628820533959;
        Thu, 12 Aug 2021 19:08:53 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ca7sm102619pjb.11.2021.08.12.19.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 19:08:53 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 08/16] lpfc: add cmfsync WQE support
Date:   Thu, 12 Aug 2021 19:08:04 -0700
Message-Id: <20210813020812.99014-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210813020812.99014-1-jsmart2021@gmail.com>
References: <20210813020812.99014-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When congestion mgmt is enabled, cmf has the driver regularly issue
a command to synchronize reporting of congestion mgmt events such as
fpin and signal delivery.

This patch adds the definition of the CMF_SYNC WQE and its CQE fields
as well as support for issuing the command. The patch also adds the
few remaining cmf-related SLI additions, such as feature definition for
enablement of CMF and notifications to the driver if the cm enablement
mode changes.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h      |   4 +
 drivers/scsi/lpfc/lpfc_crtn.h |   1 +
 drivers/scsi/lpfc/lpfc_hw4.h  |  87 ++++++++++++++++-
 drivers/scsi/lpfc/lpfc_sli.c  | 178 ++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_sli.h  |   1 +
 5 files changed, 268 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 5a356a1d517c..12972bfed923 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1499,6 +1499,10 @@ struct lpfc_hba {
 	u32 cmf_active_mode;
 #define LPFC_CFG_OFF		0
 
+#define LPFC_CMF_INTERVAL 90
+#define  LPFC_CMF_BLK_SIZE 512
+#define LPFC_MAX_CMF_INFO 32
+
 	/* Signal / FPIN handling for Congestion Mgmt */
 	u8 cgn_reg_fpin;           /* Negotiated value from RDF */
 	u8 cgn_init_reg_fpin;      /* Initial value from READ_CONFIG */
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 947c4ba847f6..3621acf9437d 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -79,6 +79,7 @@ void lpfc_init_congestion_stat(struct lpfc_hba *phba);
 void lpfc_init_congestion_buf(struct lpfc_hba *phba);
 int lpfc_sli4_cgn_params_read(struct lpfc_hba *phba);
 int lpfc_config_cgn_signal(struct lpfc_hba *phba);
+int lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total);
 
 void lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 973af1f86d28..73b249d0d964 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -397,6 +397,12 @@ struct lpfc_wcqe_complete {
 #define lpfc_wcqe_c_ersp0_MASK		0x0000FFFF
 #define lpfc_wcqe_c_ersp0_WORD		word0
 	uint32_t total_data_placed;
+#define lpfc_wcqe_c_cmf_cg_SHIFT	31
+#define lpfc_wcqe_c_cmf_cg_MASK		0x00000001
+#define lpfc_wcqe_c_cmf_cg_WORD		total_data_placed
+#define lpfc_wcqe_c_cmf_bw_SHIFT	0
+#define lpfc_wcqe_c_cmf_bw_MASK		0x0FFFFFFF
+#define lpfc_wcqe_c_cmf_bw_WORD		total_data_placed
 	uint32_t parameter;
 #define lpfc_wcqe_c_bg_edir_SHIFT	5
 #define lpfc_wcqe_c_bg_edir_MASK	0x00000001
@@ -691,6 +697,7 @@ struct lpfc_register {
 #define lpfc_sliport_eqdelay_id_MASK	0xfff
 #define lpfc_sliport_eqdelay_id_WORD	word0
 #define LPFC_SEC_TO_USEC		1000000
+#define LPFC_SEC_TO_MSEC		1000
 
 /* The following Registers apply to SLI4 if_type 0 UCNAs. They typically
  * reside in BAR 2.
@@ -3397,12 +3404,13 @@ struct lpfc_sli4_parameters {
 #define cfg_max_tow_xri_WORD			word20
 
 	uint32_t word21;
-#define cfg_mib_bde_cnt_SHIFT			16
-#define cfg_mib_bde_cnt_MASK			0x000000ff
-#define cfg_mib_bde_cnt_WORD			word21
 #define cfg_mi_ver_SHIFT			0
 #define cfg_mi_ver_MASK				0x0000ffff
 #define cfg_mi_ver_WORD				word21
+#define cfg_cmf_SHIFT				24
+#define cfg_cmf_MASK				0x000000ff
+#define cfg_cmf_WORD				word21
+
 	uint32_t mib_size;
 	uint32_t word23;                        /* RESERVED */
 
@@ -3434,6 +3442,7 @@ struct lpfc_sli4_parameters {
 #define LPFC_SET_CGN_SIGNAL		0x1f
 #define LPFC_SET_DUAL_DUMP		0x1e
 #define LPFC_SET_ENABLE_MI		0x21
+#define LPFC_SET_ENABLE_CMF		0x24
 struct lpfc_mbx_set_feature {
 	struct mbox_header header;
 	uint32_t feature;
@@ -3460,6 +3469,9 @@ struct lpfc_mbx_set_feature {
 #define LPFC_DISABLE_DUAL_DUMP		0
 #define LPFC_ENABLE_DUAL_DUMP		1
 #define LPFC_QUERY_OP_DUAL_DUMP		2
+#define lpfc_mbx_set_feature_cmf_SHIFT		0
+#define lpfc_mbx_set_feature_cmf_MASK		0x00000001
+#define lpfc_mbx_set_feature_cmf_WORD		word6
 #define lpfc_mbx_set_feature_mi_SHIFT		0
 #define lpfc_mbx_set_feature_mi_MASK		0x0000ffff
 #define lpfc_mbx_set_feature_mi_WORD		word6
@@ -4005,6 +4017,7 @@ struct lpfc_mcqe {
 #define LPFC_TRAILER_CODE_GRP5	0x5
 #define LPFC_TRAILER_CODE_FC	0x10
 #define LPFC_TRAILER_CODE_SLI	0x11
+#define LPFC_TRAILER_CODE_CMSTAT        0x13
 };
 
 struct lpfc_acqe_link {
@@ -4264,6 +4277,7 @@ struct lpfc_acqe_sli {
 #define LPFC_SLI_EVENT_TYPE_DIAG_DUMP		0x5
 #define LPFC_SLI_EVENT_TYPE_MISCONFIGURED	0x9
 #define LPFC_SLI_EVENT_TYPE_REMOTE_DPORT	0xA
+#define LPFC_SLI_EVENT_TYPE_PORT_PARAMS_CHG	0xE
 #define LPFC_SLI_EVENT_TYPE_MISCONF_FAWWN	0xF
 #define LPFC_SLI_EVENT_TYPE_EEPROM_FAILURE	0x10
 #define LPFC_SLI_EVENT_TYPE_CGN_SIGNAL		0x11
@@ -4674,6 +4688,69 @@ struct create_xri_wqe {
 #define T_REQUEST_TAG 3
 #define T_XRI_TAG 1
 
+struct cmf_sync_wqe {
+	uint32_t rsrvd[3];
+	uint32_t word3;
+#define	cmf_sync_interval_SHIFT	0
+#define	cmf_sync_interval_MASK	0x00000ffff
+#define	cmf_sync_interval_WORD	word3
+#define	cmf_sync_afpin_SHIFT	16
+#define	cmf_sync_afpin_MASK	0x000000001
+#define	cmf_sync_afpin_WORD	word3
+#define	cmf_sync_asig_SHIFT	17
+#define	cmf_sync_asig_MASK	0x000000001
+#define	cmf_sync_asig_WORD	word3
+#define	cmf_sync_op_SHIFT	20
+#define	cmf_sync_op_MASK	0x00000000f
+#define	cmf_sync_op_WORD	word3
+#define	cmf_sync_ver_SHIFT	24
+#define	cmf_sync_ver_MASK	0x0000000ff
+#define	cmf_sync_ver_WORD	word3
+#define LPFC_CMF_SYNC_VER	1
+	uint32_t event_tag;
+	uint32_t word5;
+#define	cmf_sync_wsigmax_SHIFT	0
+#define	cmf_sync_wsigmax_MASK	0x00000ffff
+#define	cmf_sync_wsigmax_WORD	word5
+#define	cmf_sync_wsigcnt_SHIFT	16
+#define	cmf_sync_wsigcnt_MASK	0x00000ffff
+#define	cmf_sync_wsigcnt_WORD	word5
+	uint32_t word6;
+	uint32_t word7;
+#define	cmf_sync_cmnd_SHIFT	8
+#define	cmf_sync_cmnd_MASK	0x0000000ff
+#define	cmf_sync_cmnd_WORD	word7
+	uint32_t word8;
+	uint32_t word9;
+#define	cmf_sync_reqtag_SHIFT	0
+#define	cmf_sync_reqtag_MASK	0x00000ffff
+#define	cmf_sync_reqtag_WORD	word9
+#define	cmf_sync_wfpinmax_SHIFT	16
+#define	cmf_sync_wfpinmax_MASK	0x0000000ff
+#define	cmf_sync_wfpinmax_WORD	word9
+#define	cmf_sync_wfpincnt_SHIFT	24
+#define	cmf_sync_wfpincnt_MASK	0x0000000ff
+#define	cmf_sync_wfpincnt_WORD	word9
+	uint32_t word10;
+#define cmf_sync_qosd_SHIFT	9
+#define cmf_sync_qosd_MASK	0x00000001
+#define cmf_sync_qosd_WORD	word10
+	uint32_t word11;
+#define cmf_sync_cmd_type_SHIFT	0
+#define cmf_sync_cmd_type_MASK	0x0000000f
+#define cmf_sync_cmd_type_WORD	word11
+#define cmf_sync_wqec_SHIFT	7
+#define cmf_sync_wqec_MASK	0x00000001
+#define cmf_sync_wqec_WORD	word11
+#define cmf_sync_cqid_SHIFT	16
+#define cmf_sync_cqid_MASK	0x0000ffff
+#define cmf_sync_cqid_WORD	word11
+	uint32_t read_bytes;
+	uint32_t word13;
+	uint32_t word14;
+	uint32_t word15;
+};
+
 struct abort_cmd_wqe {
 	uint32_t rsrvd[3];
 	uint32_t word3;
@@ -4803,6 +4880,7 @@ union lpfc_wqe {
 	struct fcp_iread64_wqe fcp_iread;
 	struct fcp_iwrite64_wqe fcp_iwrite;
 	struct abort_cmd_wqe abort_cmd;
+	struct cmf_sync_wqe cmf_sync;
 	struct create_xri_wqe create_xri;
 	struct xmit_bcast64_wqe xmit_bcast64;
 	struct xmit_seq64_wqe xmit_sequence;
@@ -4823,6 +4901,7 @@ union lpfc_wqe128 {
 	struct fcp_iread64_wqe fcp_iread;
 	struct fcp_iwrite64_wqe fcp_iwrite;
 	struct abort_cmd_wqe abort_cmd;
+	struct cmf_sync_wqe cmf_sync;
 	struct create_xri_wqe create_xri;
 	struct xmit_bcast64_wqe xmit_bcast64;
 	struct xmit_seq64_wqe xmit_sequence;
@@ -4866,6 +4945,7 @@ struct lpfc_grp_hdr {
 #define FCP_COMMAND_TRSP	0x3
 #define FCP_COMMAND_TSEND	0x7
 #define OTHER_COMMAND		0x8
+#define CMF_SYNC_COMMAND	0xA
 #define ELS_COMMAND_NON_FIP	0xC
 #define ELS_COMMAND_FIP		0xD
 
@@ -4887,6 +4967,7 @@ struct lpfc_grp_hdr {
 #define CMD_FCP_TRECEIVE64_WQE  0xA1
 #define CMD_FCP_TRSP64_WQE      0xA3
 #define CMD_GEN_REQUEST64_WQE   0xC2
+#define CMD_CMF_SYNC_WQE	0xE8
 
 #define CMD_WQE_MASK            0xff
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index b42c2dc49c83..4d1c190823d1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1768,6 +1768,184 @@ lpfc_sli_ringtx_get(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 	return cmd_iocb;
 }
 
+/**
+ * lpfc_cmf_sync_cmpl - Process a CMF_SYNC_WQE cmpl
+ * @phba: Pointer to HBA context object.
+ * @cmdiocb: Pointer to driver command iocb object.
+ * @cmf_cmpl: Pointer to completed WCQE.
+ *
+ * This routine will inform the driver of any BW adjustments we need
+ * to make. These changes will be picked up during the next CMF
+ * timer interrupt. In addition, any BW changes will be logged
+ * with LOG_CGN_MGMT.
+ **/
+static void
+lpfc_cmf_sync_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+		   struct lpfc_wcqe_complete *cmf_cmpl)
+{
+	union lpfc_wqe128 *wqe;
+	uint32_t status, info;
+	uint64_t bw;
+	int asig, afpin, sigcnt, fpincnt;
+	int cg, tdp;
+
+	/* First check for error */
+	status = bf_get(lpfc_wcqe_c_status, cmf_cmpl);
+	if (status) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
+				"6211 CMF_SYNC_WQE Error "
+				"req_tag x%x status x%x hwstatus x%x "
+				"tdatap x%x parm x%x\n",
+				bf_get(lpfc_wcqe_c_request_tag, cmf_cmpl),
+				bf_get(lpfc_wcqe_c_status, cmf_cmpl),
+				bf_get(lpfc_wcqe_c_hw_status, cmf_cmpl),
+				cmf_cmpl->total_data_placed,
+				cmf_cmpl->parameter);
+		goto out;
+	}
+
+	/* Gather congestion information on a successful cmpl */
+	info = cmf_cmpl->parameter;
+	tdp = bf_get(lpfc_wcqe_c_cmf_bw, cmf_cmpl);
+	cg = bf_get(lpfc_wcqe_c_cmf_cg, cmf_cmpl);
+
+	/* Get BW requirement from firmware */
+	bw = (uint64_t)tdp * LPFC_CMF_BLK_SIZE;
+	if (!bw) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
+				"6212 CMF_SYNC_WQE x%x: NULL bw\n",
+				bf_get(lpfc_wcqe_c_request_tag, cmf_cmpl));
+		goto out;
+	}
+
+	/* Gather information needed for logging if a BW change is required */
+	wqe = &cmdiocb->wqe;
+	asig = bf_get(cmf_sync_asig, &wqe->cmf_sync);
+	afpin = bf_get(cmf_sync_afpin, &wqe->cmf_sync);
+	fpincnt = bf_get(cmf_sync_wfpincnt, &wqe->cmf_sync);
+	sigcnt = bf_get(cmf_sync_wsigcnt, &wqe->cmf_sync);
+
+out:
+	lpfc_sli_release_iocbq(phba, cmdiocb);
+}
+
+/**
+ * lpfc_issue_cmf_sync_wqe - Issue a CMF_SYNC_WQE
+ * @phba: Pointer to HBA context object.
+ * @ms:   ms to set in WQE interval, 0 means use init op
+ * @total: Total rcv bytes for this interval
+ *
+ * This routine is called every CMF timer interrupt. Its purpose is
+ * to issue a CMF_SYNC_WQE to the firmware to inform it of any events
+ * that may indicate we have congestion (FPINs or Signals). Upon
+ * completion, the firmware will indicate any BW restrictions the
+ * driver may need to take.
+ **/
+int
+lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
+{
+	union lpfc_wqe128 *wqe;
+	struct lpfc_iocbq *sync_buf;
+	unsigned long iflags;
+	u32 ret_val;
+	u32 atot, wtot, max;
+
+	/* First address any alarm / warning activity */
+	atot = atomic_xchg(&phba->cgn_sync_alarm_cnt, 0);
+	wtot = atomic_xchg(&phba->cgn_sync_warn_cnt, 0);
+
+	/* ONLY Managed mode will send the CMF_SYNC_WQE to the HBA */
+	if (phba->cmf_active_mode != LPFC_CFG_MANAGED ||
+	    phba->link_state == LPFC_LINK_DOWN)
+		return 0;
+
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	sync_buf = __lpfc_sli_get_iocbq(phba);
+	if (!sync_buf) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_CGN_MGMT,
+				"6213 No available WQEs for CMF_SYNC_WQE\n");
+		ret_val = ENOMEM;
+		goto out_unlock;
+	}
+
+	wqe = &sync_buf->wqe;
+
+	/* WQEs are reused.  Clear stale data and set key fields to zero */
+	memset(wqe, 0, sizeof(*wqe));
+
+	/* If this is the very first CMF_SYNC_WQE, issue an init operation */
+	if (!ms) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
+				"6441 CMF Init %d - CMF_SYNC_WQE\n",
+				phba->fc_eventTag);
+		bf_set(cmf_sync_op, &wqe->cmf_sync, 1); /* 1=init */
+		bf_set(cmf_sync_interval, &wqe->cmf_sync, LPFC_CMF_INTERVAL);
+		goto initpath;
+	}
+
+	bf_set(cmf_sync_op, &wqe->cmf_sync, 0); /* 0=recalc */
+	bf_set(cmf_sync_interval, &wqe->cmf_sync, ms);
+
+	/* Check for alarms / warnings */
+	if (atot) {
+		if (phba->cgn_reg_signal == EDC_CG_SIG_WARN_ALARM) {
+			/* We hit an Signal alarm condition */
+			bf_set(cmf_sync_asig, &wqe->cmf_sync, 1);
+		} else {
+			/* We hit a FPIN alarm condition */
+			bf_set(cmf_sync_afpin, &wqe->cmf_sync, 1);
+		}
+	} else if (wtot) {
+		if (phba->cgn_reg_signal == EDC_CG_SIG_WARN_ONLY ||
+		    phba->cgn_reg_signal == EDC_CG_SIG_WARN_ALARM) {
+			/* We hit an Signal warning condition */
+			max = LPFC_SEC_TO_MSEC / lpfc_fabric_cgn_frequency *
+				lpfc_acqe_cgn_frequency;
+			bf_set(cmf_sync_wsigmax, &wqe->cmf_sync, max);
+			bf_set(cmf_sync_wsigcnt, &wqe->cmf_sync, wtot);
+		} else {
+			/* We hit a FPIN warning condition */
+			bf_set(cmf_sync_wfpinmax, &wqe->cmf_sync, 1);
+			bf_set(cmf_sync_wfpincnt, &wqe->cmf_sync, 1);
+		}
+	}
+
+	/* Update total read blocks during previous timer interval */
+	wqe->cmf_sync.read_bytes = (u32)(total / LPFC_CMF_BLK_SIZE);
+
+initpath:
+	bf_set(cmf_sync_ver, &wqe->cmf_sync, LPFC_CMF_SYNC_VER);
+	wqe->cmf_sync.event_tag = phba->fc_eventTag;
+	bf_set(cmf_sync_cmnd, &wqe->cmf_sync, CMD_CMF_SYNC_WQE);
+
+	/* Setup reqtag to match the wqe completion. */
+	bf_set(cmf_sync_reqtag, &wqe->cmf_sync, sync_buf->iotag);
+
+	bf_set(cmf_sync_qosd, &wqe->cmf_sync, 1);
+
+	bf_set(cmf_sync_cmd_type, &wqe->cmf_sync, CMF_SYNC_COMMAND);
+	bf_set(cmf_sync_wqec, &wqe->cmf_sync, 1);
+	bf_set(cmf_sync_cqid, &wqe->cmf_sync, LPFC_WQE_CQ_ID_DEFAULT);
+
+	sync_buf->vport = phba->pport;
+	sync_buf->wqe_cmpl = lpfc_cmf_sync_cmpl;
+	sync_buf->iocb_cmpl = NULL;
+	sync_buf->context1 = NULL;
+	sync_buf->context2 = NULL;
+	sync_buf->context3 = NULL;
+	sync_buf->sli4_xritag = NO_XRI;
+
+	sync_buf->iocb_flag |= LPFC_IO_CMF;
+	ret_val = lpfc_sli4_issue_wqe(phba, &phba->sli4_hba.hdwq[0], sync_buf);
+	if (ret_val)
+		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
+				"6214 Cannot issue CMF_SYNC_WQE: x%x\n",
+				ret_val);
+out_unlock:
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	return ret_val;
+}
+
 /**
  * lpfc_sli_next_iocb_slot - Get next iocb slot in the ring
  * @phba: Pointer to HBA context object.
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index dde8eb9d796d..dc7cc2f37089 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -107,6 +107,7 @@ struct lpfc_iocbq {
 #define LPFC_IO_NVME_LS		0x400000 /* NVME LS command */
 #define LPFC_IO_NVMET		0x800000 /* NVMET command */
 #define LPFC_IO_VMID            0x1000000 /* VMID tagged IO */
+#define LPFC_IO_CMF		0x4000000 /* CMF command */
 
 	uint32_t drvrTimeout;	/* driver timeout in seconds */
 	struct lpfc_vport *vport;/* virtual port pointer */
-- 
2.26.2


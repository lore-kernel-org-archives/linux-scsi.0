Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C86C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 23:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4FE9610CF
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 23:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbhHMXBT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Aug 2021 19:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbhHMXBS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Aug 2021 19:01:18 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47602C061756
        for <linux-scsi@vger.kernel.org>; Fri, 13 Aug 2021 16:00:51 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id e19so13919592pla.10
        for <linux-scsi@vger.kernel.org>; Fri, 13 Aug 2021 16:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HV+mPt6iqIvNf+b8Pv184+3EokhRnXWswjNODyW7aqA=;
        b=DUHJ8Y4+yjxlto9D4CZGpX2EaaffXnquy0dk+fAdh8fbw1nyl2oC7pqg68uyfvccj3
         +DpF7dEmbswspzJOJOGCnRGdbYrzp5aDpijABn/+m05U6ug6x36Z1+xP8rh0Yzsx+pCE
         UUwsqTva0GcNJZaZsseYeP5fdVPNsiQ6gLZ1NhhWBeSld6OB4MCcdvEFsHb5GOJjViF/
         x+krE2oMbG8TGoyMMdRsyPSHI9LFps0dnQQaTZQXXrG3xOXq/HBJTu37Mt5+tTg1Levr
         Tt9cQvTtXk1yjP5vaGOUjnYq36vCtnYrSW9Pk6h+e176NJMbWn19Q54k8aGudtQ3JkwV
         A/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HV+mPt6iqIvNf+b8Pv184+3EokhRnXWswjNODyW7aqA=;
        b=faCk2R69ubwmv3QQ6ap/yfUHrFdLbF69qCvBVIyN3gQp+i3ct2N6qN9XBN85ApSLYY
         ZxRtZ1LaH8Guez5UL1QmNBqNMDk9VlI50PYtrvOktnpN+C/cU2FfmEQRiaiIOO9f9cFi
         6sbZl2QYsaP+FhRCMp8dSd/+YVkEfqk7SHbpiffcf9SYMYcM5AGywVMsxQdq6ZAP/zen
         Piq2HmbgjVJP+1XaOW3nYeM9AMA6mjY/cAEGlKwx9VS7yHfXbP4u0PE6OUiB3fL4VJ/v
         F+SQA7U64LLcAOujhGqd1P07axq9ZahJ6liEQQlBD50rb+kCeX+ETzQQQunbUgY6+jxq
         NlaQ==
X-Gm-Message-State: AOAM53376ObgThZ+sTdqw8SGvjyixVvFf9tMnx5degK8ETJgNnSq49FP
        xjy9aLz9iALa3pDg745V1DrQ07Ca1rc=
X-Google-Smtp-Source: ABdhPJwiDo4SNU7MB/lycK1cI4FxLnOxNI40P1xRBd0eGI2wu84YY8waWro4/T3BUYXtT/kZjB+3Bw==
X-Received: by 2002:a17:902:b692:b029:12b:e0b8:3415 with SMTP id c18-20020a170902b692b029012be0b83415mr3791577pls.32.1628895650739;
        Fri, 13 Aug 2021 16:00:50 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e8sm4001997pgg.31.2021.08.13.16.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 16:00:50 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 01/16] fc: Add EDC ELS definition
Date:   Fri, 13 Aug 2021 16:00:24 -0700
Message-Id: <20210813230039.110546-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210813230039.110546-1-jsmart2021@gmail.com>
References: <20210813230039.110546-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add Exchange Diagnostic Capabilities (EDC) ELS definition and
the following capability descriptors:
  Link Fault Capability Descriptor
  Congestion Signaling Capability Descriptor

Definition taken from FC-LS-5 r5.01

Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 include/uapi/scsi/fc/fc_els.h | 106 ++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/include/uapi/scsi/fc/fc_els.h b/include/uapi/scsi/fc/fc_els.h
index 91d4be987220..c9812c5c2fc4 100644
--- a/include/uapi/scsi/fc/fc_els.h
+++ b/include/uapi/scsi/fc/fc_els.h
@@ -41,6 +41,7 @@ enum fc_els_cmd {
 	ELS_REC =	0x13,	/* read exchange concise */
 	ELS_SRR =	0x14,	/* sequence retransmission request */
 	ELS_FPIN =	0x16,	/* Fabric Performance Impact Notification */
+	ELS_EDC =	0x17,	/* Exchange Diagnostic Capabilities */
 	ELS_RDP =	0x18,	/* Read Diagnostic Parameters */
 	ELS_RDF =	0x19,	/* Register Diagnostic Functions */
 	ELS_PRLI =	0x20,	/* process login */
@@ -111,6 +112,7 @@ enum fc_els_cmd {
 	[ELS_REC] =	"REC",			\
 	[ELS_SRR] =	"SRR",			\
 	[ELS_FPIN] =	"FPIN",			\
+	[ELS_EDC] =	"EDC",			\
 	[ELS_RDP] =	"RDP",			\
 	[ELS_RDF] =	"RDF",			\
 	[ELS_PRLI] =	"PRLI",			\
@@ -218,6 +220,10 @@ enum fc_els_rjt_explan {
 enum fc_ls_tlv_dtag {
 	ELS_DTAG_LS_REQ_INFO =		0x00000001,
 		/* Link Service Request Information Descriptor */
+	ELS_DTAG_LNK_FAULT_CAP =	0x0001000D,
+		/* Link Fault Capability Descriptor */
+	ELS_DTAG_CG_SIGNAL_CAP =	0x0001000F,
+		/* Congestion Signaling Capability Descriptor */
 	ELS_DTAG_LNK_INTEGRITY =	0x00020001,
 		/* Link Integrity Notification Descriptor */
 	ELS_DTAG_DELIVERY =		0x00020002,
@@ -236,6 +242,8 @@ enum fc_ls_tlv_dtag {
  */
 #define FC_LS_TLV_DTAG_INIT {					      \
 	{ ELS_DTAG_LS_REQ_INFO,		"Link Service Request Information" }, \
+	{ ELS_DTAG_LNK_FAULT_CAP,	"Link Fault Capability" },	      \
+	{ ELS_DTAG_CG_SIGNAL_CAP,	"Congestion Signaling Capability" },  \
 	{ ELS_DTAG_LNK_INTEGRITY,	"Link Integrity Notification" },      \
 	{ ELS_DTAG_DELIVERY,		"Delivery Notification Present" },    \
 	{ ELS_DTAG_PEER_CONGEST,	"Peer Congestion Notification" },     \
@@ -1144,4 +1152,102 @@ struct fc_els_rdf_resp {
 };
 
 
+/*
+ * Diagnostic Capability Descriptors for EDC ELS
+ */
+
+/*
+ * Diagnostic: Link Fault Capability Descriptor
+ */
+struct fc_diag_lnkflt_desc {
+	__be32		desc_tag;	/* Descriptor Tag (0x0001000D) */
+	__be32		desc_len;	/* Length of Descriptor (in bytes).
+					 * Size of descriptor excluding
+					 * desc_tag and desc_len fields.
+					 * 12 bytes
+					 */
+	__be32		degrade_activate_threshold;
+	__be32		degrade_deactivate_threshold;
+	__be32		fec_degrade_interval;
+};
+
+enum fc_edc_cg_signal_cap_types {
+	/* Note: Capability: bits 31:4 Rsvd; bits 3:0 are capabilities */
+	EDC_CG_SIG_NOTSUPPORTED =	0x00, /* neither supported */
+	EDC_CG_SIG_WARN_ONLY =		0x01,
+	EDC_CG_SIG_WARN_ALARM =		0x02, /* both supported */
+};
+
+/*
+ * Initializer useful for decoding table.
+ * Please keep this in sync with the above definitions.
+ */
+#define FC_EDC_CG_SIGNAL_CAP_TYPES_INIT {				\
+	{ EDC_CG_SIG_NOTSUPPORTED,	"Signaling Not Supported" },	\
+	{ EDC_CG_SIG_WARN_ONLY,		"Warning Signal" },		\
+	{ EDC_CG_SIG_WARN_ALARM,	"Warning and Alarm Signals" },	\
+}
+
+enum fc_diag_cg_sig_freq_types {
+	EDC_CG_SIGFREQ_CNT_MIN =	1,	/* Min Frequency Count */
+	EDC_CG_SIGFREQ_CNT_MAX =	999,	/* Max Frequency Count */
+
+	EDC_CG_SIGFREQ_SEC =		0x1,	/* Units: seconds */
+	EDC_CG_SIGFREQ_MSEC =		0x2,	/* Units: milliseconds */
+};
+
+struct fc_diag_cg_sig_freq {
+	__be16		count;		/* Time between signals
+					 * note: upper 6 bits rsvd
+					 */
+	__be16		units;		/* Time unit for count
+					 * note: upper 12 bits rsvd
+					 */
+};
+
+/*
+ * Diagnostic: Congestion Signaling Capability Descriptor
+ */
+struct fc_diag_cg_sig_desc {
+	__be32		desc_tag;	/* Descriptor Tag (0x0001000F) */
+	__be32		desc_len;	/* Length of Descriptor (in bytes).
+					 * Size of descriptor excluding
+					 * desc_tag and desc_len fields.
+					 * 16 bytes
+					 */
+	__be32				xmt_signal_capability;
+	struct fc_diag_cg_sig_freq	xmt_signal_frequency;
+	__be32				rcv_signal_capability;
+	struct fc_diag_cg_sig_freq	rcv_signal_frequency;
+};
+
+/*
+ * ELS_EDC - Exchange Diagnostic Capabilities
+ */
+struct fc_els_edc {
+	__u8		edc_cmd;	/* command (0x17) */
+	__u8		edc_zero[3];	/* specified as zero - part of cmd */
+	__be32		desc_len;	/* Length of Descriptor List (in bytes).
+					 * Size of ELS excluding edc_cmd,
+					 * edc_zero and desc_len fields.
+					 */
+	struct fc_tlv_desc	desc[0];
+					/* Diagnostic Descriptor list */
+};
+
+/*
+ * ELS EDC LS_ACC Response.
+ */
+struct fc_els_edc_resp {
+	struct fc_els_ls_acc	acc_hdr;
+	__be32			desc_list_len;	/* Length of response (in
+						 * bytes). Excludes acc_hdr
+						 * and desc_list_len fields.
+						 */
+	struct fc_els_lsri_desc	lsri;
+	struct fc_tlv_desc	desc[0];
+				    /* Supported Diagnostic Descriptor list */
+};
+
+
 #endif /* _FC_ELS_H_ */
-- 
2.26.2


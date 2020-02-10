Return-Path: <SRS0=AJIY=36=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC06C35254
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 17:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7601B2082F
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 17:32:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F+6POtY5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgBJRcL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Feb 2020 12:32:11 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35759 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbgBJRcL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Feb 2020 12:32:11 -0500
Received: by mail-wr1-f65.google.com with SMTP id w12so8854045wrt.2
        for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2020 09:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gXoYs7oObWcgjjLP5ha83eT/VeCli5/wtJyvR1PRYaQ=;
        b=F+6POtY5c3cAOZjdt5U8HZDVmyflQdJCG8CCEVrJzETB+o80xFo8IbjIZ7hXbohcq8
         tcgcqZzDdHFZaj1GlkmuXv2D4dpjTWMzGri94o+3zAiPfmPeY1zQ/3j5hth9GoYAhcBr
         A6FrgfJHYxmWlONf7IW1t+sCka4denTkKG8wak+81Gy7bjkDP7yO4beUDvSE2JWKE6DD
         +tLfgFGiV3kpPhuyI/+i7qZGN9pTForFtP6ELoBXDE6yvZP6BAH4v3X91n20VhsFIWN4
         9J/BIhqKOih4I+8TIRp4Kemwuz9UtDSCdoB5QN+Y8jCLGLZLHURX567AlDhR7skHPqAT
         J44w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gXoYs7oObWcgjjLP5ha83eT/VeCli5/wtJyvR1PRYaQ=;
        b=FXtF4d0c/hRR5napPfWl9sjlUhvnwdP1s87BBcQWsRf0spI6vrebPaoEZUtsWXQpIw
         MfwE1C5nJIpmE/AcpFDFjSL7Jx4CsW4psKbfK13GtFeNMKuUgedLjtozRDceBva1ikbB
         SsWNl1pbLJqSugnDqYoElsFMXKwYepj+d/adnL93cAYVl//kHmbhFFOFEDFfhjnyIWe8
         7ZDSIV+YIhHQ73beqe612RNi4KlVbW9lBBOXa97Bhpm0whgnLxHM5A/llxPbIyfIS1PN
         1U04T2k5vi0wqmEjhIMxhhEKDXXjpT76W164RC97VYIFOJmZD39rf+ZstptS5BngOcBL
         3nBg==
X-Gm-Message-State: APjAAAU69Ys299Quto+SlrjCs4QuSlHGOjcKrP9lFjNIBDykpxwi7upv
        zZH3iqnbgYBCpATh04FzKxC5oDua
X-Google-Smtp-Source: APXvYqzySV8SiSrmHHOYHHe0QtMW6HpKSZG22E4AgwjnPa1kOo+6gb04buWlRbgHR9s5ePpH4VutoQ==
X-Received: by 2002:a5d:66cc:: with SMTP id k12mr3049064wrw.72.1581355927823;
        Mon, 10 Feb 2020 09:32:07 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k10sm1402135wrd.68.2020.02.10.09.32.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 10 Feb 2020 09:32:07 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 1/2] fc: Update Descriptor definition and add RDF and Link Integrity FPINs
Date:   Mon, 10 Feb 2020 09:31:54 -0800
Message-Id: <20200210173155.547-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200210173155.547-1-jsmart2021@gmail.com>
References: <20200210173155.547-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update the fc headers for the RDF ELS and populate out the FPIN ELS and
the Link integrity FPIN payload.

RDF is used to register for diagnostic events.
FPIN is how the fabric reports a diagnostic event.

Specifically, this patch:
- Adds the formal definition of TLV descriptors that are now used
  in a lot of the FC spec. The simplistic fc_fn_desc structure, basically
  no more than the tlv definition, is removed.
- Small tlv helper functions are added as defines.
- The list of known Descriptor tags (identifying the TLV) is expanded
  and a name initializer introduced.
- The LSRI descriptor, returned in many new ELS response payloads is
  added.
- The RDF ELS code is added, and the RDF request response structures
  added.
- The FPIN els definition is corrected.
- A full definition of a Link Integrity Notification descriptor is added,

Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 include/uapi/scsi/fc/fc_els.h | 211 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 196 insertions(+), 15 deletions(-)

diff --git a/include/uapi/scsi/fc/fc_els.h b/include/uapi/scsi/fc/fc_els.h
index 76f627f0d13b..10b609a2f863 100644
--- a/include/uapi/scsi/fc/fc_els.h
+++ b/include/uapi/scsi/fc/fc_els.h
@@ -9,6 +9,7 @@
 #define	_FC_ELS_H_
 
 #include <linux/types.h>
+#include <asm/byteorder.h>
 
 /*
  * Fibre Channel Switch - Enhanced Link Services definitions.
@@ -40,6 +41,7 @@ enum fc_els_cmd {
 	ELS_REC =	0x13,	/* read exchange concise */
 	ELS_SRR =	0x14,	/* sequence retransmission request */
 	ELS_FPIN =	0x16,	/* Fabric Performance Impact Notification */
+	ELS_RDF =	0x19,	/* Register Diagnostic Functions */
 	ELS_PRLI =	0x20,	/* process login */
 	ELS_PRLO =	0x21,	/* process logout */
 	ELS_SCN =	0x22,	/* state change notification */
@@ -108,6 +110,7 @@ enum fc_els_cmd {
 	[ELS_REC] =	"REC",			\
 	[ELS_SRR] =	"SRR",			\
 	[ELS_FPIN] =	"FPIN",			\
+	[ELS_RDF] =	"RDF",			\
 	[ELS_PRLI] =	"PRLI",			\
 	[ELS_PRLO] =	"PRLO",			\
 	[ELS_SCN] =	"SCN",			\
@@ -208,6 +211,99 @@ enum fc_els_rjt_explan {
 };
 
 /*
+ * Link Service TLV Descriptor Tag Values
+ */
+enum fc_ls_tlv_dtag {
+	ELS_DTAG_LS_REQ_INFO =		0x00000001,
+		/* Link Service Request Information Descriptor */
+	ELS_DTAG_LNK_INTEGRITY =	0x00020001,
+		/* Link Integrity Notification Descriptor */
+	ELS_DTAG_DELIVERY =		0x00020002,
+		/* Delivery Notification Descriptor */
+	ELS_DTAG_PEER_CONGEST =		0x00020003,
+		/* Peer Congestion Notification Descriptor */
+	ELS_DTAG_CONGESTION =		0x00020004,
+		/* Congestion Notification Descriptor */
+	ELS_DTAG_FPIN_REGISTER =	0x00030001,
+		/* FPIN Registration Descriptor */
+};
+
+/*
+ * Initializer useful for decoding table.
+ * Please keep this in sync with the above definitions.
+ */
+#define FC_LS_TLV_DTAG_INIT {					      \
+	{ ELS_DTAG_LS_REQ_INFO,		"Link Service Request Information" }, \
+	{ ELS_DTAG_LNK_INTEGRITY,	"Link Integrity Notification" },      \
+	{ ELS_DTAG_DELIVERY,		"Delivery Notification Present" },    \
+	{ ELS_DTAG_PEER_CONGEST,	"Peer Congestion Notification" },     \
+	{ ELS_DTAG_CONGESTION,		"Congestion Notification" },	      \
+	{ ELS_DTAG_FPIN_REGISTER,	"FPIN Registration" },		      \
+}
+
+
+/*
+ * Generic Link Service TLV Descriptor format
+ *
+ * This structure, as it defines no payload, will also be referred to
+ * as the "tlv header" - which contains the tag and len fields.
+ */
+struct fc_tlv_desc {
+	__be32		desc_tag;	/* Notification Descriptor Tag */
+	__be32		desc_len;	/* Length of Descriptor (in bytes).
+					 * Size of descriptor excluding
+					 * desc_tag and desc_len fields.
+					 */
+	__u8		desc_value[0];  /* Descriptor Value */
+};
+
+/* Descriptor tag and len fields are considered the mandatory header
+ * for a descriptor
+ */
+#define FC_TLV_DESC_HDR_SZ	sizeof(struct fc_tlv_desc)
+
+/*
+ * Macro, used when initializing payloads, to return the descriptor length.
+ * Length is size of descriptor minus the tag and len fields.
+ */
+#define FC_TLV_DESC_LENGTH_FROM_SZ(desc)	\
+		(sizeof(desc) - FC_TLV_DESC_HDR_SZ)
+
+/* Macro, used on received payloads, to return the descriptor length */
+#define FC_TLV_DESC_SZ_FROM_LENGTH(tlv)		\
+		(be32_to_cpu((tlv)->desc_len) + FC_TLV_DESC_HDR_SZ)
+
+/*
+ * This helper is used to walk descriptors in a descriptor list.
+ * Given the address of the current descriptor, which minimally contains a
+ * tag and len field, calculate the address of the next descriptor based
+ * on the len field.
+ */
+static inline void *fc_tlv_next_desc(void *desc)
+{
+	struct fc_tlv_desc *tlv = desc;
+
+	return (desc + FC_TLV_DESC_SZ_FROM_LENGTH(tlv));
+}
+
+
+/*
+ * Link Service Request Information Descriptor
+ */
+struct fc_els_lsri_desc {
+	__be32		desc_tag;	/* descriptor tag (0x0000 0001) */
+	__be32		desc_len;	/* Length of Descriptor (in bytes) (4).
+					 * Size of descriptor excluding
+					 * desc_tag and desc_len fields.
+					 */
+	struct {
+		__u8	cmd;		/* ELS cmd byte */
+		__u8	bytes[3];	/* bytes 1..3 */
+	} rqst_w0;			/* Request word 0 */
+};
+
+
+/*
  * Common service parameters (N ports).
  */
 struct fc_els_csp {
@@ -819,24 +915,61 @@ enum fc_els_clid_ic {
 };
 
 
+enum fc_fpin_li_event_types {
+	FPIN_LI_UNKNOWN =		0x0,
+	FPIN_LI_LINK_FAILURE =		0x1,
+	FPIN_LI_LOSS_OF_SYNC =		0x2,
+	FPIN_LI_LOSS_OF_SIG =		0x3,
+	FPIN_LI_PRIM_SEQ_ERR =		0x4,
+	FPIN_LI_INVALID_TX_WD =		0x5,
+	FPIN_LI_INVALID_CRC =		0x6,
+	FPIN_LI_DEVICE_SPEC =		0xF,
+};
+
 /*
- * Fabric Notification Descriptor Tag values
+ * Initializer useful for decoding table.
+ * Please keep this in sync with the above definitions.
  */
-enum fc_fn_dtag {
-	ELS_FN_DTAG_LNK_INTEGRITY =	0x00020001,	/* Link Integrity */
-	ELS_FN_DTAG_PEER_CONGEST =	0x00020003,	/* Peer Congestion */
-	ELS_FN_DTAG_CONGESTION =	0x00020004,	/* Congestion */
-};
+#define FC_FPIN_LI_EVT_TYPES_INIT {					\
+	{ FPIN_LI_UNKNOWN,		"Unknown" },			\
+	{ FPIN_LI_LINK_FAILURE,		"Link Failure" },		\
+	{ FPIN_LI_LOSS_OF_SYNC,		"Loss of Synchronization" },	\
+	{ FPIN_LI_LOSS_OF_SIG,		"Loss of Signal" },		\
+	{ FPIN_LI_PRIM_SEQ_ERR,		"Primitive Sequence Protocol Error" }, \
+	{ FPIN_LI_INVALID_TX_WD,	"Invalid Transmission Word" },	\
+	{ FPIN_LI_INVALID_CRC,		"Invalid CRC" },		\
+	{ FPIN_LI_DEVICE_SPEC,		"Device Specific" },		\
+}
+
 
 /*
- * Fabric Notification Descriptor
+ * Link Integrity Notification Descriptor
  */
-struct fc_fn_desc {
-	__be32		fn_desc_tag;	/* Notification Descriptor Tag */
-	__be32		fn_desc_value_len; /* Length of Descriptor Value field
-					    * (in bytes)
-					    */
-	__u8		fn_desc_value[0];  /* Descriptor Value */
+struct fc_fn_li_desc {
+	__be32		desc_tag;	/* Descriptor Tag (0x00020001) */
+	__be32		desc_len;	/* Length of Descriptor (in bytes).
+					 * Size of descriptor excluding
+					 * desc_tag and desc_len fields.
+					 */
+	__be64		detecting_wwpn;	/* Port Name that detected event */
+	__be64		attached_wwpn;	/* Port Name of device attached to
+					 * detecting Port Name
+					 */
+	__be16		event_type;	/* see enum fc_fpin_li_event_types */
+	__be16		event_modifier;	/* Implementation specific value
+					 * describing the event type
+					 */
+	__be32		event_threshold;/* duration in ms of the link
+					 * integrity detection cycle
+					 */
+	__be32		event_count;	/* minimum number of event
+					 * occurrences during the event
+					 * threshold to caause the LI event
+					 */
+	__be32		pname_count;	/* number of portname_list elements */
+	__be64		pname_list[0];	/* list of N_Port_Names accessible
+					 * through the attached port
+					 */
 };
 
 /*
@@ -845,8 +978,56 @@ struct fc_fn_desc {
 struct fc_els_fpin {
 	__u8		fpin_cmd;	/* command (0x16) */
 	__u8		fpin_zero[3];	/* specified as zero - part of cmd */
-	__be32		fpin_desc_cnt;	/* count of descriptors */
-	struct fc_fn_desc	fpin_desc[0];	/* Descriptor list */
+	__be32		desc_len;	/* Length of Descriptor List (in bytes).
+					 * Size of ELS excluding fpin_cmd,
+					 * fpin_zero and desc_len fields.
+					 */
+	struct fc_tlv_desc	fpin_desc[0];	/* Descriptor list */
+};
+
+/* Diagnostic Function Descriptor - FPIN Registration */
+struct fc_df_desc_fpin_reg {
+	__be32		desc_tag;	/* FPIN Registration (0x00030001) */
+	__be32		desc_len;	/* Length of Descriptor (in bytes).
+					 * Size of descriptor excluding
+					 * desc_tag and desc_len fields.
+					 */
+	__be32		count;		/* Number of desc_tags elements */
+	__be32		desc_tags[0];	/* Array of Descriptor Tags.
+					 * Each tag indicates a function
+					 * supported by the N_Port (request)
+					 * or by the  N_Port and Fabric
+					 * Controller (reply; may be a subset
+					 * of the request).
+					 * See ELS_FN_DTAG_xxx for tag values.
+					 */
 };
 
+/*
+ * ELS_RDF - Register Diagnostic Functions
+ */
+struct fc_els_rdf {
+	__u8		fpin_cmd;	/* command (0x19) */
+	__u8		fpin_zero[3];	/* specified as zero - part of cmd */
+	__be32		desc_len;	/* Length of Descriptor List (in bytes).
+					 * Size of ELS excluding fpin_cmd,
+					 * fpin_zero and desc_len fields.
+					 */
+	struct fc_tlv_desc	desc[0];	/* Descriptor list */
+};
+
+/*
+ * ELS RDF LS_ACC Response.
+ */
+struct fc_els_rdf_resp {
+	struct fc_els_ls_acc	acc_hdr;
+	__be32			desc_list_len;	/* Length of response (in
+						 * bytes). Excludes acc_hdr
+						 * and desc_list_len fields.
+						 */
+	struct fc_els_lsri_desc	lsri;
+	struct fc_tlv_desc	desc[0];	/* Supported Descriptor list */
+};
+
+
 #endif /* _FC_ELS_H_ */
-- 
2.13.7


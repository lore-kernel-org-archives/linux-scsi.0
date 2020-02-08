Return-Path: <SRS0=yjur=34=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BEEDC35250
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Feb 2020 00:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D047206CC
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Feb 2020 00:13:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8ruiuxV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgBHANF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Feb 2020 19:13:05 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34475 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbgBHANE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2020 19:13:04 -0500
Received: by mail-pl1-f195.google.com with SMTP id j7so408250plt.1
        for <linux-scsi@vger.kernel.org>; Fri, 07 Feb 2020 16:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gXoYs7oObWcgjjLP5ha83eT/VeCli5/wtJyvR1PRYaQ=;
        b=e8ruiuxVBWMD5Z9wHBvwT1JwD/mqUd/zn/2lMkIoBWC3SrY54NtPNuf/KeU4xUgVTk
         InMFtxDjAIzkW0saToFbgV4c0I5W3CTen1JFdaJSn1oL+fr5XGZ8pZtel84jNv4PONhL
         sbJZacd7ktRGAINYBitlvZcqNmuMjdmedVwGbjGS+JFcBWZc92/U0ZHUrvxA286bA/KE
         N1BFe79JLCTyXFbSVFNjOX5xAQOXVBE31HlLijy79TCuxpvkzscxUUmHEqEBIwi7bsC+
         zrGAa3J1AkpZweSwG11c0KegzGsMCDzjgnzYg0/gcyUQKSjfqIM95R6QNbEEoyEdSP8h
         g3kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gXoYs7oObWcgjjLP5ha83eT/VeCli5/wtJyvR1PRYaQ=;
        b=YRZlEHhWhRVZMYCO5r6tQ9fwyWTZKle1mGEGB38NR9hdxvKzTxPyoWtPCyW5T1AUyt
         XWxfFzeWUlc6a3RPUHZsHr/E7huN7CsoQ4iiNz1WTUxtiinf7js/2Yc/4LiD8lxK2gTi
         YZavWkSKXYT5mmITwicXWyTMCstwZp6epztBZ1iNZMLjz/CpCPYTf0IviteNRhmqWC6K
         fRf4zJKbkd/YlUmbp2t4GSopgFMufLhvWz2sO3UoR5iFC+FUQybH7gVt9ydIr2YubwiT
         88XgMQYQJs2Nb+u252ULn7eHmxRaP5aCeQDbmalE75qEQU8SUMJ6bNkDxa9c1098hvCq
         7WVw==
X-Gm-Message-State: APjAAAV/uST6pAxMw7QpyQEjb7zFmPL0Owq8dxpr9eSOZMsW/SEkh8KT
        suBVPsdeI/Z4IvCB8U1pXL/45G3Z
X-Google-Smtp-Source: APXvYqz9nfN2p6BNrY/9ksRvrRx7nB1N+5166YouUPEV4vfrn9OYeM/4IkUF682Wsd8B/M2z+FaPjg==
X-Received: by 2002:a17:90a:e2ce:: with SMTP id fr14mr6433092pjb.99.1581120782831;
        Fri, 07 Feb 2020 16:13:02 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y23sm4175827pfn.101.2020.02.07.16.13.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 07 Feb 2020 16:13:02 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 1/2] fc: Update Descriptor definition and add RDF and Link Integrity FPINs
Date:   Fri,  7 Feb 2020 16:12:52 -0800
Message-Id: <20200208001253.30594-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200208001253.30594-1-jsmart2021@gmail.com>
References: <20200208001253.30594-1-jsmart2021@gmail.com>
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


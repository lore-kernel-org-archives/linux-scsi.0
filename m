Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCADC43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E87332082E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GCrqe88Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfLTWhg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:37:36 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39303 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbfLTWhg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:37:36 -0500
Received: by mail-pf1-f194.google.com with SMTP id q10so5993698pfs.6
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p4U4edSnUU5mGqg/AJbDBSVHsqmLRzodL5eb61bJY18=;
        b=GCrqe88Zlz7dsvzpwHYMiRj1vcmv83B5cPQMNMYGVtHegqgZyL+BAPMtK3BhSApM2A
         CbBLboYOIDpLd3KAPWxlV1cKByxUQWv96+CiL0kD0po0Uh4z81Tx/vT4UrjLktBeuwmZ
         T/BXcjufT4AbXXQgXUmtPI4jUElflTRDS5e0YbZq6jD28Zq0lVTLdPoMGseeMxVdPd6F
         Ru9ldLdavRep195pdjTGc9lz/ndIppklpUb305Yy6GhICm6pnKXkw4xmQvqMiVX0MmqG
         wOCFf1iPQRiTPd1uikP1ghu4IPWPsfa8YvKMB7ulwlZ+yyfJDf2p/xNJLy3X2rrPRyTR
         z8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p4U4edSnUU5mGqg/AJbDBSVHsqmLRzodL5eb61bJY18=;
        b=o4R/4iGfRE0KesBpo6ryeJax8GqxDUx3BFpgBvDJkXGSmiD2CvgZl8ornpX8toWhQS
         jzw4IooYmLV912aGWdfEu+q2X4+V3wDnmX0nXUMGU7WxWatYWgsj/9tI5PhZfGDBSsaO
         +HT+Fvqzn1H8fbSgbDnB147g287jADLGfTGbMTyLwTFAtYnd+3QC+VbT/X7oWnYHSERP
         yNdSH4fHmYeMDcoCmC4oVcP5kgWWgPbQvNYxAFU1+cA4+7jNbZCIfzXtXT3c+LWZtC1d
         zOLNL0uq8vQCP0/HM+Nm0K1xn52XrkiWGqP12aBHqKchWgUp31JBdQ1I8tWq51JWvF2a
         v/Sw==
X-Gm-Message-State: APjAAAVUpv0g8tJqy+iO2DJ5leA9mQCBHpKDDP6rok8fmKIHHl/AHDPv
        MnJurcribUAk1ONpWu13wNvpgDPF
X-Google-Smtp-Source: APXvYqwUAfGxWD9i4dPhqFV305TrorfgMvUI2nVlsfnE0js0zOjIhMp3SnBXtw9TACsNU34KPerAPw==
X-Received: by 2002:a62:e80b:: with SMTP id c11mr11871301pfi.28.1576881454017;
        Fri, 20 Dec 2019 14:37:34 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.37.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:37:33 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 02/32] elx: libefc_sli: SLI Descriptors and Queue entries
Date:   Fri, 20 Dec 2019 14:36:53 -0800
Message-Id: <20191220223723.26563-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191220223723.26563-1-jsmart2021@gmail.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the libefc_sli SLI-4 library population.

This patch add SLI-4 Data structures and defines for:
- Buffer Descriptors (BDEs)
- Scatter/Gather List elements (SGEs)
- Queues and their Entry Descriptions for:
   Event Queues (EQs), Completion Queues (CQs),
   Receive Queues (RQs), and the Mailbox Queue (MQ).

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/include/efc_common.h |   25 +
 drivers/scsi/elx/libefc_sli/sli4.h    | 1768 +++++++++++++++++++++++++++++++++
 2 files changed, 1793 insertions(+)
 create mode 100644 drivers/scsi/elx/include/efc_common.h

diff --git a/drivers/scsi/elx/include/efc_common.h b/drivers/scsi/elx/include/efc_common.h
new file mode 100644
index 000000000000..3fc48876c531
--- /dev/null
+++ b/drivers/scsi/elx/include/efc_common.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#ifndef __EFC_COMMON_H__
+#define __EFC_COMMON_H__
+
+#include <linux/pci.h>
+
+#define EFC_SUCCESS 0
+#define EFC_FAIL 1
+
+struct efc_dma {
+	void		*virt;
+	void            *alloc;
+	dma_addr_t	phys;
+
+	size_t		size;
+	size_t          len;
+	struct pci_dev	*pdev;
+};
+
+#endif /* __EFC_COMMON_H__ */
diff --git a/drivers/scsi/elx/libefc_sli/sli4.h b/drivers/scsi/elx/libefc_sli/sli4.h
index 02c671cf57ef..f86a9e72ed43 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.h
+++ b/drivers/scsi/elx/libefc_sli/sli4.h
@@ -12,6 +12,8 @@
 #ifndef _SLI4_H
 #define _SLI4_H
 
+#include "../include/efc_common.h"
+
 /*************************************************************************
  * Common SLI-4 register offsets and field definitions
  */
@@ -236,4 +238,1770 @@ struct sli4_reg {
 	u32	off;
 };
 
+struct sli4_dmaaddr {
+	__le32 low;
+	__le32 high;
+};
+
+/* a 3-word BDE with address 1st 2 words, length last word */
+struct sli4_bufptr {
+	struct sli4_dmaaddr addr;
+	__le32 length;
+};
+
+/* a 3-word BDE with length as first word, address last 2 words */
+struct sli4_bufptr_len1st {
+	__le32 length0;
+	struct sli4_dmaaddr addr;
+};
+
+/* Buffer Descriptor Entry (BDE) */
+enum {
+	SLI4_BDE_MASK_BUFFER_LEN	= 0x00ffffff,
+	SLI4_BDE_MASK_BDE_TYPE		= 0xff000000,
+};
+
+struct sli4_bde {
+	__le32		bde_type_buflen;
+	union {
+		struct sli4_dmaaddr data;
+		struct {
+			__le32	offset;
+			__le32	rsvd2;
+		} imm;
+		struct sli4_dmaaddr blp;
+	} u;
+};
+
+/* Buffer Descriptors */
+enum {
+	BDE_TYPE_SHIFT		= 24,
+	BDE_TYPE_BDE_64		= 0x00,	/* Generic 64-bit data */
+	BDE_TYPE_BDE_IMM	= 0x01,	/* Immediate data */
+	BDE_TYPE_BLP		= 0x40,	/* Buffer List Pointer */
+};
+
+/* Scatter-Gather Entry (SGE) */
+#define SLI4_SGE_MAX_RESERVED			3
+
+enum {
+	/* DW2 */
+	SLI4_SGE_DATA_OFFSET_MASK	= 0x07FFFFFF,
+	/*DW2W1*/
+	SLI4_SGE_TYPE_SHIFT		= 27,
+	SLI4_SGE_TYPE_MASK		= 0xf << SLI4_SGE_TYPE_SHIFT,
+	/*SGE Types*/
+	SLI4_SGE_TYPE_DATA		= 0x00,
+	SLI4_SGE_TYPE_DIF		= 0x04,	/* Data Integrity Field */
+	SLI4_SGE_TYPE_LSP		= 0x05,	/* List Segment Pointer */
+	SLI4_SGE_TYPE_PEDIF		= 0x06,	/* Post Encryption Engine DIF */
+	SLI4_SGE_TYPE_PESEED		= 0x07,	/* Post Encryption DIF Seed */
+	SLI4_SGE_TYPE_DISEED		= 0x08,	/* DIF Seed */
+	SLI4_SGE_TYPE_ENC		= 0x09,	/* Encryption */
+	SLI4_SGE_TYPE_ATM		= 0x0a,	/* DIF Application Tag Mask */
+	SLI4_SGE_TYPE_SKIP		= 0x0c,	/* SKIP */
+
+	SLI4_SGE_LAST			= (1 << 31),
+};
+
+struct sli4_sge {
+	__le32		buffer_address_high;
+	__le32		buffer_address_low;
+	__le32		dw2_flags;
+	__le32		buffer_length;
+};
+
+/* T10 DIF Scatter-Gather Entry (SGE) */
+struct sli4_dif_sge {
+	__le32		buffer_address_high;
+	__le32		buffer_address_low;
+	__le32		dw2_flags;
+	__le32		rsvd12;
+};
+
+/* Data Integrity Seed (DISEED) SGE */
+enum {
+	/* DW2W1 */
+	DISEED_SGE_HS			= (1 << 2),
+	DISEED_SGE_WS			= (1 << 3),
+	DISEED_SGE_IC			= (1 << 4),
+	DISEED_SGE_ICS			= (1 << 5),
+	DISEED_SGE_ATRT			= (1 << 6),
+	DISEED_SGE_AT			= (1 << 7),
+	DISEED_SGE_FAT			= (1 << 8),
+	DISEED_SGE_NA			= (1 << 9),
+	DISEED_SGE_HI			= (1 << 10),
+
+	/* DW3W1 */
+	DISEED_SGE_BS_MASK		= 0x0007,
+	DISEED_SGE_AI			= (1 << 3),
+	DISEED_SGE_ME			= (1 << 4),
+	DISEED_SGE_RE			= (1 << 5),
+	DISEED_SGE_CE			= (1 << 6),
+	DISEED_SGE_NR			= (1 << 7),
+
+	DISEED_SGE_OP_RX_SHIFT		= 8,
+	DISEED_SGE_OP_RX_MASK		= (0xf << DISEED_SGE_OP_RX_SHIFT),
+	DISEED_SGE_OP_TX_SHIFT		= 12,
+	DISEED_SGE_OP_TX_MASK		= (0xf << DISEED_SGE_OP_TX_SHIFT),
+
+	/* Opcode values */
+	DISEED_SGE_OP_IN_NODIF_OUT_CRC	= 0x00,
+	DISEED_SGE_OP_IN_CRC_OUT_NODIF	= 0x01,
+	DISEED_SGE_OP_IN_NODIF_OUT_CSUM	= 0x02,
+	DISEED_SGE_OP_IN_CSUM_OUT_NODIF	= 0x03,
+	DISEED_SGE_OP_IN_CRC_OUT_CRC	= 0x04,
+	DISEED_SGE_OP_IN_CSUM_OUT_CSUM	= 0x05,
+	DISEED_SGE_OP_IN_CRC_OUT_CSUM	= 0x06,
+	DISEED_SGE_OP_IN_CSUM_OUT_CRC	= 0x07,
+	DISEED_SGE_OP_IN_RAW_OUT_RAW	= 0x08,
+
+};
+
+#define DISEED_SGE_OP_RX_VALUE(stype) \
+	(DISEED_SGE_OP_##stype << DISEED_SGE_OP_RX_SHIFT)
+#define DISEED_SGE_OP_TX_VALUE(stype) \
+	(DISEED_SGE_OP_##stype << DISEED_SGE_OP_TX_SHIFT)
+
+struct sli4_diseed_sge {
+	__le32		ref_tag_cmp;
+	__le32		ref_tag_repl;
+	__le16		app_tag_repl;
+	__le16		dw2w1_flags;
+	__le16		app_tag_cmp;
+	__le16		dw3w1_flags;
+};
+
+/* List Segment Pointer Scatter-Gather Entry (SGE) */
+enum {
+	SLI4_LSP_SGE_SEGLEN	= 0x00ffffff,
+};
+
+struct sli4_lsp_sge {
+	__le32		buffer_address_high;
+	__le32		buffer_address_low;
+	__le32		dw2_flags;
+	__le32		dw3_seglen;
+};
+
+enum {
+	SLI4_EQE_VALID	= 1,
+	SLI4_EQE_MJCODE	= 0xe,
+	SLI4_EQE_MNCODE	= 0xfff0,
+};
+
+struct sli4_eqe {
+	__le16		dw0w0_flags;
+	__le16		resource_id;
+};
+
+#define SLI4_MAJOR_CODE_STANDARD	0
+#define SLI4_MAJOR_CODE_SENTINEL	1
+
+enum {
+	SLI4_MCQE_CONSUMED	= (1 << 27),
+	SLI4_MCQE_COMPLETED	= (1 << 28),
+	SLI4_MCQE_AE		= (1 << 30),
+	SLI4_MCQE_VALID		= (1 << 31),
+};
+
+struct sli4_mcqe {
+	__le16		completion_status;
+	__le16		extended_status;
+	__le32		mqe_tag_low;
+	__le32		mqe_tag_high;
+	__le32		dw3_flags;
+};
+
+enum {
+	SLI4_ACQE_AE	= (1 << 6), /* async event - this is an ACQE */
+	SLI4_ACQE_VAL	= (1 << 7), /* valid - contents of CQE are valid */
+};
+
+struct sli4_acqe {
+	__le32		event_data[3];
+	u8		rsvd12;
+	u8		event_code;
+	u8		event_type;
+	u8		ae_val;
+};
+
+#define SLI4_ACQE_EVENT_CODE_LINK_STATE		0x01
+#define SLI4_ACQE_EVENT_CODE_FIP		0x02
+#define SLI4_ACQE_EVENT_CODE_DCBX		0x03
+#define SLI4_ACQE_EVENT_CODE_ISCSI		0x04
+#define SLI4_ACQE_EVENT_CODE_GRP_5		0x05
+#define SLI4_ACQE_EVENT_CODE_FC_LINK_EVENT	0x10
+#define SLI4_ACQE_EVENT_CODE_SLI_PORT_EVENT	0x11
+#define SLI4_ACQE_EVENT_CODE_VF_EVENT		0x12
+#define SLI4_ACQE_EVENT_CODE_MR_EVENT		0x13
+
+enum sli4_qtype {
+	SLI_QTYPE_EQ,
+	SLI_QTYPE_CQ,
+	SLI_QTYPE_MQ,
+	SLI_QTYPE_WQ,
+	SLI_QTYPE_RQ,
+	SLI_QTYPE_MAX,			/* must be last */
+};
+
+#define SLI_USER_MQ_COUNT	1
+#define SLI_MAX_CQ_SET_COUNT	16
+#define SLI_MAX_RQ_SET_COUNT	16
+
+enum sli4_qentry {
+	SLI_QENTRY_ASYNC,
+	SLI_QENTRY_MQ,
+	SLI_QENTRY_RQ,
+	SLI_QENTRY_WQ,
+	SLI_QENTRY_WQ_RELEASE,
+	SLI_QENTRY_OPT_WRITE_CMD,
+	SLI_QENTRY_OPT_WRITE_DATA,
+	SLI_QENTRY_XABT,
+	SLI_QENTRY_MAX			/* must be last */
+};
+
+enum {
+	/* CQ has MQ/Async completion */
+	SLI4_QUEUE_FLAG_MQ	= (1 << 0),
+
+	/* RQ for packet headers */
+	SLI4_QUEUE_FLAG_HDR	= (1 << 1),
+
+	/* RQ index increment by 8 */
+	SLI4_QUEUE_FLAG_RQBATCH	= (1 << 2),
+};
+
+struct sli4_queue {
+	/* Common to all queue types */
+	struct efc_dma	dma;
+	spinlock_t	lock;	/* protect the queue operations */
+	u32	index;		/* current host entry index */
+	u16	size;		/* entry size */
+	u16	length;		/* number of entries */
+	u16	n_posted;	/* number entries posted */
+	u16	id;		/* Port assigned xQ_ID */
+	u16	ulp;		/* ULP assigned to this queue */
+	void __iomem    *db_regaddr;	/* register address for the doorbell */
+	u8		type;		/* queue type ie EQ, CQ, ... */
+	u32	proc_limit;	/* limit CQE processed per iteration */
+	u32	posted_limit;	/* CQE/EQE process before ring doorbel */
+	u32	max_num_processed;
+	time_t		max_process_time;
+	u16	phase;		/* For if_type = 6, this value toggle
+				 * for each iteration of the queue,
+				 * a queue entry is valid when a cqe
+				 * valid bit matches this value
+				 */
+
+	union {
+		u32	r_idx;	/* "read" index (MQ only) */
+		struct {
+			u32	dword;
+		} flag;
+	} u;
+};
+
+/* Generic Command Request header */
+enum {
+	CMD_V0 = 0x00,
+	CMD_V1 = 0x01,
+	CMD_V2 = 0x02,
+};
+
+struct sli4_rqst_hdr {
+	u8		opcode;
+	u8		subsystem;
+	__le16		rsvd2;
+	__le32		timeout;
+	__le32		request_length;
+	__le32		dw3_version;
+};
+
+/* Generic Command Response header */
+struct sli4_rsp_hdr {
+	u8		opcode;
+	u8		subsystem;
+	__le16		rsvd2;
+	u8		status;
+	u8		additional_status;
+	__le16		rsvd6;
+	__le32		response_length;
+	__le32		actual_response_length;
+};
+
+#define SLI4_QUEUE_DEFAULT_CQ	U16_MAX
+
+#define SLI4_QUEUE_RQ_BATCH	8
+
+#define CFG_RQST_CMDSZ(stype)	sizeof(struct sli4_rqst_##stype)
+
+#define CFG_RQST_PYLD_LEN(stype) \
+		cpu_to_le32(sizeof(struct sli4_rqst_##stype) - \
+			sizeof(struct sli4_rqst_hdr))
+
+#define CFG_RQST_PYLD_LEN_VAR(stype, varpyld) \
+		cpu_to_le32((sizeof(struct sli4_rqst_##stype) + \
+			varpyld) - sizeof(struct sli4_rqst_hdr))
+
+#define SZ_DMAADDR		sizeof(struct sli4_dmaaddr)
+
+#define SLI_CONFIG_PYLD_LENGTH(stype) \
+		max(sizeof(struct sli4_rqst_##stype), \
+		sizeof(struct sli4_rsp_##stype))
+
+enum {
+	/* DW5_flags values*/
+	CREATE_CQV2_CLSWM_MASK	= 0x00003000,
+	CREATE_CQV2_NODELAY	= 0x00004000,
+	CREATE_CQV2_AUTOVALID	= 0x00008000,
+	CREATE_CQV2_CQECNT_MASK	= 0x18000000,
+	CREATE_CQV2_VALID	= 0x20000000,
+	CREATE_CQV2_EVT		= 0x80000000,
+	/* DW6W1_flags values*/
+	CREATE_CQV2_ARM		= 0x8000,
+};
+
+struct sli4_rqst_cmn_create_cq_v2 {
+	struct sli4_rqst_hdr	hdr;
+	__le16		num_pages;
+	u8		page_size;
+	u8		rsvd19;
+	__le32		dw5_flags;
+	__le16		eq_id;
+	__le16		dw6w1_arm;
+	__le16		cqe_count;
+	__le16		rsvd30;
+	__le32		rsvd32;
+	struct sli4_dmaaddr page_phys_addr[0];
+};
+
+enum {
+	/* DW5_flags values*/
+	CREATE_CQSETV0_CLSWM_MASK  = 0x00003000,
+	CREATE_CQSETV0_NODELAY	   = 0x00004000,
+	CREATE_CQSETV0_AUTOVALID   = 0x00008000,
+	CREATE_CQSETV0_CQECNT_MASK = 0x18000000,
+	CREATE_CQSETV0_VALID	   = 0x20000000,
+	CREATE_CQSETV0_EVT	   = 0x80000000,
+	/* DW5W1_flags values */
+	CREATE_CQSETV0_CQE_COUNT   = 0x7fff,
+	CREATE_CQSETV0_ARM	   = 0x8000,
+};
+
+struct sli4_rqst_cmn_create_cq_set_v0 {
+	struct sli4_rqst_hdr	hdr;
+	__le16		num_pages;
+	u8		page_size;
+	u8		rsvd19;
+	__le32		dw5_flags;
+	__le16		num_cq_req;
+	__le16		dw6w1_flags;
+	__le16		eq_id[16];
+	struct sli4_dmaaddr page_phys_addr[0];
+};
+
+/* CQE count */
+enum {
+	CQ_CNT_SHIFT	= 27,
+
+	CQ_CNT_256	= 0,
+	CQ_CNT_512	= 1,
+	CQ_CNT_1024	= 2,
+	CQ_CNT_LARGE	= 3,
+};
+#define CQ_CNT_VAL(type)		(CQ_CNT_##type << CQ_CNT_SHIFT)
+
+#define SLI4_CQE_BYTES			(4 * sizeof(u32))
+
+#define SLI4_CMN_CREATE_CQ_V2_MAX_PAGES	8
+
+/* Generic Common Create EQ/CQ/MQ/WQ/RQ Queue completion */
+struct sli4_rsp_cmn_create_queue {
+	struct sli4_rsp_hdr	hdr;
+	__le16	q_id;
+	u8	rsvd18;
+	u8	ulp;
+	__le32	db_offset;
+	__le16	db_rs;
+	__le16	db_fmt;
+};
+
+struct sli4_rsp_cmn_create_queue_set {
+	struct sli4_rsp_hdr	hdr;
+	__le16	q_id;
+	__le16	num_q_allocated;
+};
+
+/* Common Destroy Queue */
+struct sli4_rqst_cmn_destroy_q {
+	struct sli4_rqst_hdr	hdr;
+	__le16	q_id;
+	__le16	rsvd;
+};
+
+struct sli4_rsp_cmn_destroy_q {
+	struct sli4_rsp_hdr	hdr;
+};
+
+/* Modify the delay multiplier for EQs */
+struct sli4_rqst_cmn_modify_eq_delay {
+	struct sli4_rqst_hdr	hdr;
+	__le32	num_eq;
+	struct {
+		__le32	eq_id;
+		__le32	phase;
+		__le32	delay_multiplier;
+	} eq_delay_record[8];
+};
+
+struct sli4_rsp_cmn_modify_eq_delay {
+	struct sli4_rsp_hdr	hdr;
+};
+
+enum {
+	/* DW5 */
+	CREATE_EQ_AUTOVALID		= (1 << 28),
+	CREATE_EQ_VALID			= (1 << 29),
+	CREATE_EQ_EQESZ			= (1 << 31),
+	/* DW6 */
+	CREATE_EQ_COUNT			= (7 << 26),
+	CREATE_EQ_ARM			= (1 << 31),
+	/* DW7 */
+	CREATE_EQ_DELAYMULTI_SHIFT	= 13,
+	CREATE_EQ_DELAYMULTI_MASK	= (0x3FF << CREATE_EQ_DELAYMULTI_SHIFT),
+	CREATE_EQ_DELAYMULTI		= (32 << CREATE_EQ_DELAYMULTI_SHIFT),
+};
+
+struct sli4_rqst_cmn_create_eq {
+	struct sli4_rqst_hdr	hdr;
+	__le16	num_pages;
+	__le16	rsvd18;
+	__le32	dw5_flags;
+	__le32	dw6_flags;
+	__le32	dw7_delaymulti;
+	__le32	rsvd32;
+	struct sli4_dmaaddr page_address[8];
+};
+
+struct sli4_rsp_cmn_create_eq {
+	struct sli4_rsp_cmn_create_queue q_rsp;
+};
+
+/* EQ count */
+enum {
+	EQ_CNT_SHIFT	= 26,
+
+	EQ_CNT_256	= 0,
+	EQ_CNT_512	= 1,
+	EQ_CNT_1024	= 2,
+	EQ_CNT_2048	= 3,
+	EQ_CNT_4096	= 3,
+};
+#define EQ_CNT_VAL(type) (EQ_CNT_##type << EQ_CNT_SHIFT)
+
+#define SLI4_EQE_SIZE_4			0
+#define SLI4_EQE_SIZE_16		1
+
+/* Create a Mailbox Queue; accommodate v0 and v1 forms. */
+enum {
+	/* DW6W1 */
+	CREATE_MQEXT_RINGSIZE		= 0xf,
+	CREATE_MQEXT_CQID_SHIFT		= 6,
+	CREATE_MQEXT_CQIDV0_MASK	= 0xffc0,
+	/* DW7 */
+	CREATE_MQEXT_VAL		= (1 << 31),
+	/* DW8 */
+	CREATE_MQEXT_ACQV		= (1 << 0),
+	CREATE_MQEXT_ASYNC_CQIDV0	= 0x7fe,
+};
+
+struct sli4_rqst_cmn_create_mq_ext {
+	struct sli4_rqst_hdr	hdr;
+	__le16		num_pages;
+	__le16		cq_id_v1;
+	__le32		async_event_bitmap;
+	__le16		async_cq_id_v1;
+	__le16		dw6w1_flags;
+	__le32		dw7_val;
+	__le32		dw8_flags;
+	__le32		rsvd36;
+	struct sli4_dmaaddr page_phys_addr[0];
+};
+
+struct sli4_rsp_cmn_create_mq_ext {
+	struct sli4_rsp_cmn_create_queue q_rsp;
+};
+
+#define SLI4_MQE_SIZE_16		0x05
+#define SLI4_MQE_SIZE_32		0x06
+#define SLI4_MQE_SIZE_64		0x07
+#define SLI4_MQE_SIZE_128		0x08
+
+#define SLI4_ASYNC_EVT_LINK_STATE	(1 << 1)
+#define SLI4_ASYNC_EVT_FIP		(1 << 2)
+#define SLI4_ASYNC_EVT_GRP5		(1 << 5)
+#define SLI4_ASYNC_EVT_FC		(1 << 16)
+#define SLI4_ASYNC_EVT_SLI_PORT		(1 << 17)
+
+#define	SLI4_ASYNC_EVT_FC_ALL \
+		(SLI4_ASYNC_EVT_LINK_STATE	| \
+		 SLI4_ASYNC_EVT_FIP		| \
+		 SLI4_ASYNC_EVT_GRP5		| \
+		 SLI4_ASYNC_EVT_FC		| \
+		 SLI4_ASYNC_EVT_SLI_PORT)
+
+/* Create a Completion Queue. */
+struct sli4_rqst_cmn_create_cq_v0 {
+	struct sli4_rqst_hdr	hdr;
+	__le16		num_pages;
+	__le16		rsvd18;
+	__le32		dw5_flags;
+	__le32		dw6_flags;
+	__le32		rsvd28;
+	__le32		rsvd32;
+	struct sli4_dmaaddr page_phys_addr[0];
+};
+
+enum {
+	SLI4_RQ_CREATE_DUA		= 0x1,
+	SLI4_RQ_CREATE_BQU		= 0x2,
+
+	SLI4_RQE_SIZE			= 8,
+	SLI4_RQE_SIZE_8			= 0x2,
+	SLI4_RQE_SIZE_16		= 0x3,
+	SLI4_RQE_SIZE_32		= 0x4,
+	SLI4_RQE_SIZE_64		= 0x5,
+	SLI4_RQE_SIZE_128		= 0x6,
+
+	SLI4_RQ_PAGE_SIZE_4096		= 0x1,
+	SLI4_RQ_PAGE_SIZE_8192		= 0x2,
+	SLI4_RQ_PAGE_SIZE_16384		= 0x4,
+	SLI4_RQ_PAGE_SIZE_32768		= 0x8,
+	SLI4_RQ_PAGE_SIZE_64536		= 0x10,
+
+	SLI4_RQ_CREATE_V0_MAX_PAGES	= 8,
+	SLI4_RQ_CREATE_V0_MIN_BUF_SIZE	= 128,
+	SLI4_RQ_CREATE_V0_MAX_BUF_SIZE	= 2048,
+};
+
+struct sli4_rqst_rq_create {
+	struct sli4_rqst_hdr	hdr;
+	__le16		num_pages;
+	u8		dua_bqu_byte;
+	u8		ulp;
+	__le16		rsvd16;
+	u8		rqe_count_byte;
+	u8		rsvd19;
+	__le32		rsvd20;
+	__le16		buffer_size;
+	__le16		cq_id;
+	__le32		rsvd28;
+	struct sli4_dmaaddr page_phys_addr[SLI4_RQ_CREATE_V0_MAX_PAGES];
+};
+
+struct sli4_rsp_rq_create {
+	struct sli4_rsp_cmn_create_queue rsp;
+};
+
+enum {
+	SLI4_RQ_CREATE_V1_DNB		= 0x80,
+	SLI4_RQ_CREATE_V1_MAX_PAGES	= 8,
+	SLI4_RQ_CREATE_V1_MIN_BUF_SIZE	= 64,
+	SLI4_RQ_CREATE_V1_MAX_BUF_SIZE	= 2048,
+};
+
+struct sli4_rqst_rq_create_v1 {
+	struct sli4_rqst_hdr	hdr;
+	__le16		num_pages;
+	u8		rsvd14;
+	u8		dim_dfd_dnb;
+	u8		page_size;
+	u8		rqe_size_byte;
+	__le16		rqe_count;
+	__le32		rsvd20;
+	__le16		rsvd24;
+	__le16		cq_id;
+	__le32		buffer_size;
+	struct sli4_dmaaddr page_phys_addr[SLI4_RQ_CREATE_V1_MAX_PAGES];
+};
+
+struct sli4_rsp_rq_create_v1 {
+	struct sli4_rsp_cmn_create_queue rsp;
+};
+
+enum {
+	SLI4_RQCREATEV2_DNB = 0x80,
+};
+
+struct sli4_rqst_rq_create_v2 {
+	struct sli4_rqst_hdr	hdr;
+	__le16		num_pages;
+	u8		rq_count;
+	u8		dim_dfd_dnb;
+	u8		page_size;
+	u8		rqe_size_byte;
+	__le16		rqe_count;
+	__le16		hdr_buffer_size;
+	__le16		payload_buffer_size;
+	__le16		base_cq_id;
+	__le16		rsvd26;
+	__le32		rsvd42;
+	struct sli4_dmaaddr page_phys_addr[0];
+};
+
+struct sli4_rsp_rq_create_v2 {
+	struct sli4_rsp_cmn_create_queue rsp;
+};
+
+#define SLI4_CQE_CODE_OFFSET			14
+
+#define SLI4_CQE_CODE_WORK_REQUEST_COMPLETION	0x01
+#define SLI4_CQE_CODE_RELEASE_WQE		0x02
+#define SLI4_CQE_CODE_RQ_ASYNC			0x04
+#define SLI4_CQE_CODE_XRI_ABORTED		0x05
+#define SLI4_CQE_CODE_RQ_COALESCING		0x06
+#define SLI4_CQE_CODE_RQ_CONSUMPTION		0x07
+#define SLI4_CQE_CODE_MEASUREMENT_REPORTING	0x08
+#define SLI4_CQE_CODE_RQ_ASYNC_V1		0x09
+#define SLI4_CQE_CODE_OPTIMIZED_WRITE_CMD	0x0B
+#define SLI4_CQE_CODE_OPTIMIZED_WRITE_DATA	0x0C
+
+#define SLI4_WQ_CREATE_MAX_PAGES		8
+struct sli4_rqst_wq_create {
+	struct sli4_rqst_hdr	hdr;
+	__le16		num_pages;
+	__le16		cq_id;
+	u8		page_size;
+	u8		wqe_size_byte;
+	__le16		wqe_count;
+	__le32		rsvd;
+	struct	sli4_dmaaddr
+			page_phys_addr[SLI4_WQ_CREATE_MAX_PAGES];
+};
+
+struct sli4_rsp_wq_create {
+	struct sli4_rsp_cmn_create_queue rsp;
+};
+
+enum {
+	LINK_TYPE_SHIFT			= 6,
+	LINK_TYPE_MASK			= 0x03 << LINK_TYPE_SHIFT,
+	LINK_TYPE_ETHERNET		= 0x00 << LINK_TYPE_SHIFT,
+	LINK_TYPE_FC			= 0x01 << LINK_TYPE_SHIFT,
+
+	PORT_SPEED_NO_LINK		= 0x0,
+	PORT_SPEED_10_MBPS		= 0x1,
+	PORT_SPEED_100_MBP		= 0x2,
+	PORT_SPEED_1_GBPS		= 0x3,
+	PORT_SPEED_10_GBPS		= 0x4,
+	PORT_SPEED_20_GBPS		= 0x5,
+	PORT_SPEED_25_GBPS		= 0x6,
+	PORT_SPEED_40_GBPS		= 0x7,
+	PORT_SPEED_100_GBPS		= 0x8,
+
+	PORT_LINK_STATUS_PHYSICAL_DOWN	= 0x0,
+	PORT_LINK_STATUS_PHYSICAL_UP	= 0x1,
+	PORT_LINK_STATUS_LOGICAL_DOWN	= 0x2,
+	PORT_LINK_STATUS_LOGICAL_UP	= 0x3,
+
+	PORT_DUPLEX_NONE		= 0x0,
+	PORT_DUPLEX_HWF			= 0x1,
+	PORT_DUPLEX_FULL		= 0x2,
+
+	/*Link Event Type*/
+	LINK_STATE_PHYSICAL		= 0x00,
+	LINK_STATE_LOGICAL		= 0x01,
+};
+
+struct sli4_link_state {
+	u8		link_num_type;
+	u8		port_link_status;
+	u8		port_duplex;
+	u8		port_speed;
+	u8		port_fault;
+	u8		rsvd5;
+	__le16		logical_link_speed;
+	__le32		event_tag;
+	u8		rsvd12;
+	u8		event_code;
+	u8		event_type;
+	u8		flags;
+};
+
+enum {
+	LINK_ATTN_TYPE_LINK_UP		= 0x01,
+	LINK_ATTN_TYPE_LINK_DOWN	= 0x02,
+	LINK_ATTN_TYPE_NO_HARD_ALPA	= 0x03,
+
+	LINK_ATTN_P2P			= 0x01,
+	LINK_ATTN_FC_AL			= 0x02,
+	LINK_ATTN_INTERNAL_LOOPBACK	= 0x03,
+	LINK_ATTN_SERDES_LOOPBACK	= 0x04,
+
+	LINK_ATTN_1G			= 0x01,
+	LINK_ATTN_2G			= 0x02,
+	LINK_ATTN_4G			= 0x04,
+	LINK_ATTN_8G			= 0x08,
+	LINK_ATTN_10G			= 0x0a,
+	LINK_ATTN_16G			= 0x10,
+};
+
+struct sli4_link_attention {
+	u8		link_number;
+	u8		attn_type;
+	u8		topology;
+	u8		port_speed;
+	u8		port_fault;
+	u8		shared_link_status;
+	__le16		logical_link_speed;
+	__le32		event_tag;
+	u8		rsvd12;
+	u8		event_code;
+	u8		event_type;
+	u8		flags;
+};
+
+enum {
+	FC_EVENT_LINK_ATTENTION		= 0x01,
+	FC_EVENT_SHARED_LINK_ATTENTION	= 0x02,
+};
+
+enum {
+	SLI4_WCQE_XB = 0x10,
+	SLI4_WCQE_QX = 0x80,
+};
+
+struct sli4_fc_wcqe {
+	u8		hw_status;
+	u8		status;
+	__le16		request_tag;
+	__le32		wqe_specific_1;
+	__le32		wqe_specific_2;
+	u8		rsvd12;
+	u8		qx_byte;
+	u8		code;
+	u8		flags;
+};
+
+/* FC WQ consumed CQ queue entry */
+struct sli4_fc_wqec {
+	__le32		rsvd0;
+	__le32		rsvd1;
+	__le16		wqe_index;
+	__le16		wq_id;
+	__le16		rsvd12;
+	u8		code;
+	u8		vld_byte;
+};
+
+/* FC Completion Status Codes. */
+#define SLI4_FC_WCQE_STATUS_SUCCESS			0x00
+#define SLI4_FC_WCQE_STATUS_FCP_RSP_FAILURE		0x01
+#define SLI4_FC_WCQE_STATUS_REMOTE_STOP			0x02
+#define SLI4_FC_WCQE_STATUS_LOCAL_REJECT		0x03
+#define SLI4_FC_WCQE_STATUS_NPORT_RJT			0x04
+#define SLI4_FC_WCQE_STATUS_FABRIC_RJT			0x05
+#define SLI4_FC_WCQE_STATUS_NPORT_BSY			0x06
+#define SLI4_FC_WCQE_STATUS_FABRIC_BSY			0x07
+#define SLI4_FC_WCQE_STATUS_LS_RJT			0x09
+#define SLI4_FC_WCQE_STATUS_CMD_REJECT			0x0b
+#define SLI4_FC_WCQE_STATUS_FCP_TGT_LENCHECK		0x0c
+#define SLI4_FC_WCQE_STATUS_RQ_BUF_LEN_EXCEEDED		0x11
+#define SLI4_FC_WCQE_STATUS_RQ_INSUFF_BUF_NEEDED	0x12
+#define SLI4_FC_WCQE_STATUS_RQ_INSUFF_FRM_DISC		0x13
+#define SLI4_FC_WCQE_STATUS_RQ_DMA_FAILURE		0x14
+#define SLI4_FC_WCQE_STATUS_FCP_RSP_TRUNCATE		0x15
+#define SLI4_FC_WCQE_STATUS_DI_ERROR			0x16
+#define SLI4_FC_WCQE_STATUS_BA_RJT			0x17
+#define SLI4_FC_WCQE_STATUS_RQ_INSUFF_XRI_NEEDED	0x18
+#define SLI4_FC_WCQE_STATUS_RQ_INSUFF_XRI_DISC		0x19
+#define SLI4_FC_WCQE_STATUS_RX_ERROR_DETECT		0x1a
+#define SLI4_FC_WCQE_STATUS_RX_ABORT_REQUEST		0x1b
+
+/* DI_ERROR Extended Status */
+#define SLI4_FC_DI_ERROR_GE			(1 << 0)
+#define SLI4_FC_DI_ERROR_AE			(1 << 1)
+#define SLI4_FC_DI_ERROR_RE			(1 << 2)
+#define SLI4_FC_DI_ERROR_TDPV			(1 << 3)
+#define SLI4_FC_DI_ERROR_UDB			(1 << 4)
+#define SLI4_FC_DI_ERROR_EDIR			(1 << 5)
+
+/* WQE DIF field contents */
+#define SLI4_DIF_DISABLED			0
+#define SLI4_DIF_PASS_THROUGH			1
+#define SLI4_DIF_STRIP				2
+#define SLI4_DIF_INSERT				3
+
+/* driver generated status codes */
+#define SLI4_FC_WCQE_STATUS_TARGET_WQE_TIMEOUT	0xff
+#define SLI4_FC_WCQE_STATUS_SHUTDOWN		0xfe
+#define SLI4_FC_WCQE_STATUS_DISPATCH_ERROR	0xfd
+
+/* Work Queue Entry (WQE) types */
+#define SLI4_WQE_ABORT				0x0f
+#define SLI4_WQE_ELS_REQUEST64			0x8a
+#define SLI4_WQE_FCP_IBIDIR64			0xac
+#define SLI4_WQE_FCP_IREAD64			0x9a
+#define SLI4_WQE_FCP_IWRITE64			0x98
+#define SLI4_WQE_FCP_ICMND64			0x9c
+#define SLI4_WQE_FCP_TRECEIVE64			0xa1
+#define SLI4_WQE_FCP_CONT_TRECEIVE64		0xe5
+#define SLI4_WQE_FCP_TRSP64			0xa3
+#define SLI4_WQE_FCP_TSEND64			0x9f
+#define SLI4_WQE_GEN_REQUEST64			0xc2
+#define SLI4_WQE_SEND_FRAME			0xe1
+#define SLI4_WQE_XMIT_BCAST64			0x84
+#define SLI4_WQE_XMIT_BLS_RSP			0x97
+#define SLI4_WQE_ELS_RSP64			0x95
+#define SLI4_WQE_XMIT_SEQUENCE64		0x82
+#define SLI4_WQE_REQUEUE_XRI			0x93
+
+/* WQE command types */
+#define SLI4_CMD_FCP_IREAD64_WQE		0x00
+#define SLI4_CMD_FCP_ICMND64_WQE		0x00
+#define SLI4_CMD_FCP_IWRITE64_WQE		0x01
+#define SLI4_CMD_FCP_TRECEIVE64_WQE		0x02
+#define SLI4_CMD_FCP_TRSP64_WQE			0x03
+#define SLI4_CMD_FCP_TSEND64_WQE		0x07
+#define SLI4_CMD_GEN_REQUEST64_WQE		0x08
+#define SLI4_CMD_XMIT_BCAST64_WQE		0x08
+#define SLI4_CMD_XMIT_BLS_RSP64_WQE		0x08
+#define SLI4_CMD_ABORT_WQE			0x08
+#define SLI4_CMD_XMIT_SEQUENCE64_WQE		0x08
+#define SLI4_CMD_REQUEUE_XRI_WQE		0x0A
+#define SLI4_CMD_SEND_FRAME_WQE			0x0a
+
+#define SLI4_WQE_SIZE				0x05
+#define SLI4_WQE_EXT_SIZE			0x06
+
+#define SLI4_WQE_BYTES				(16 * sizeof(u32))
+#define SLI4_WQE_EXT_BYTES			(32 * sizeof(u32))
+
+/* Mask for ccp (CS_CTL) */
+#define SLI4_MASK_CCP				0xfe
+
+/* Generic WQE */
+enum {
+	SLI4_GEN_WQE_EBDECNT	= (0xf << 0),
+	SLI4_GEN_WQE_LEN_LOC	= (0x3 << 7),
+	SLI4_GEN_WQE_QOSD	= (1 << 9),
+	SLI4_GEN_WQE_XBL	= (1 << 11),
+	SLI4_GEN_WQE_HLM	= (1 << 12),
+	SLI4_GEN_WQE_IOD	= (1 << 13),
+	SLI4_GEN_WQE_DBDE	= (1 << 14),
+	SLI4_GEN_WQE_WQES	= (1 << 15),
+
+	SLI4_GEN_WQE_PRI	= (0x7),
+	SLI4_GEN_WQE_PV		= (1 << 3),
+	SLI4_GEN_WQE_EAT	= (1 << 4),
+	SLI4_GEN_WQE_XC		= (1 << 5),
+	SLI4_GEN_WQE_CCPE	= (1 << 7),
+
+	SLI4_GEN_WQE_CMDTYPE	= (0xf),
+	SLI4_GEN_WQE_WQEC	= (1 << 7),
+};
+
+struct sli4_generic_wqe {
+	__le32		cmd_spec0_5[6];
+	__le16		xri_tag;
+	__le16		context_tag;
+	u8		ct_byte;
+	u8		command;
+	u8		class_byte;
+	u8		timer;
+	__le32		abort_tag;
+	__le16		request_tag;
+	__le16		rsvd34;
+	__le16		dw10w0_flags;
+	u8		eat_xc_ccpe;
+	u8		ccp;
+	u8		cmdtype_wqec_byte;
+	u8		rsvd41;
+	__le16		cq_id;
+};
+
+/* WQE used to abort exchanges. */
+enum {
+	SLI4_ABRT_WQE_IR	= 0x02,
+
+	SLI4_ABRT_WQE_EBDECNT	= (0xf << 0),
+	SLI4_ABRT_WQE_LEN_LOC	= (0x3 << 7),
+	SLI4_ABRT_WQE_QOSD	= (1 << 9),
+	SLI4_ABRT_WQE_XBL	= (1 << 11),
+	SLI4_ABRT_WQE_IOD	= (1 << 13),
+	SLI4_ABRT_WQE_DBDE	= (1 << 14),
+	SLI4_ABRT_WQE_WQES	= (1 << 15),
+
+	SLI4_ABRT_WQE_PRI	= (0x7),
+	SLI4_ABRT_WQE_PV	= (1 << 3),
+	SLI4_ABRT_WQE_EAT	= (1 << 4),
+	SLI4_ABRT_WQE_XC	= (1 << 5),
+	SLI4_ABRT_WQE_CCPE	= (1 << 7),
+
+	SLI4_ABRT_WQE_CMDTYPE	= (0xf),
+	SLI4_ABRT_WQE_WQEC	= (1 << 7),
+};
+
+struct sli4_abort_wqe {
+	__le32		rsvd0;
+	__le32		rsvd4;
+	__le32		ext_t_tag;
+	u8		ia_ir_byte;
+	u8		criteria;
+	__le16		rsvd10;
+	__le32		ext_t_mask;
+	__le32		t_mask;
+	__le16		xri_tag;
+	__le16		context_tag;
+	u8		ct_byte;
+	u8		command;
+	u8		class_byte;
+	u8		timer;
+	__le32		t_tag;
+	__le16		request_tag;
+	__le16		rsvd34;
+	__le16		dw10w0_flags;
+	u8		eat_xc_ccpe;
+	u8		ccp;
+	u8		cmdtype_wqec_byte;
+	u8		rsvd41;
+	__le16		cq_id;
+};
+
+#define SLI4_ABORT_CRITERIA_XRI_TAG		0x01
+#define SLI4_ABORT_CRITERIA_ABORT_TAG		0x02
+#define SLI4_ABORT_CRITERIA_REQUEST_TAG		0x03
+#define SLI4_ABORT_CRITERIA_EXT_ABORT_TAG	0x04
+
+enum sli4_abort_type {
+	SLI_ABORT_XRI,
+	SLI_ABORT_ABORT_ID,
+	SLI_ABORT_REQUEST_ID,
+	SLI_ABORT_MAX,		/* must be last */
+};
+
+/* WQE used to create an ELS request. */
+enum {
+	SLI4_REQ_WQE_QOSD		= 0x2,
+	SLI4_REQ_WQE_DBDE		= 0x40,
+	SLI4_REQ_WQE_XBL		= 0x8,
+	SLI4_REQ_WQE_XC			= 0x20,
+	SLI4_REQ_WQE_IOD		= 0x20,
+	SLI4_REQ_WQE_HLM		= 0x10,
+	SLI4_REQ_WQE_CCPE		= 0x80,
+	SLI4_REQ_WQE_EAT		= 0x10,
+	SLI4_REQ_WQE_WQES		= 0x80,
+	SLI4_REQ_WQE_PU_SHFT		= 4,
+	SLI4_REQ_WQE_CT_SHFT		= 2,
+	SLI4_REQ_WQE_CT			= 0xc,
+	SLI4_REQ_WQE_ELSID_SHFT		= 4,
+	SLI4_REQ_WQE_SP_SHFT		= 24,
+	SLI4_REQ_WQE_LEN_LOC_BIT1	= 0x80,
+	SLI4_REQ_WQE_LEN_LOC_BIT2	= 0x1,
+};
+
+struct sli4_els_request64_wqe {
+	struct sli4_bde	els_request_payload;
+	__le32		els_request_payload_length;
+	__le32		sid_sp_dword;
+	__le32		remote_id_dword;
+	__le16		xri_tag;
+	__le16		context_tag;
+	u8		ct_byte;
+	u8		command;
+	u8		class_byte;
+	u8		timer;
+	__le32		abort_tag;
+	__le16		request_tag;
+	__le16		temporary_rpi;
+	u8		len_loc1_byte;
+	u8		qosd_xbl_hlm_iod_dbde_wqes;
+	u8		eat_xc_ccpe;
+	u8		ccp;
+	u8		cmdtype_elsid_byte;
+	u8		rsvd41;
+	__le16		cq_id;
+	struct sli4_bde	els_response_payload_bde;
+	__le32		max_response_payload_length;
+};
+
+/* WQE used to create an FCP initiator no data command. */
+enum {
+	SLI4_ICMD_WQE_DBDE		= 0x40,
+	SLI4_ICMD_WQE_XBL		= 0x8,
+	SLI4_ICMD_WQE_XC		= 0x20,
+	SLI4_ICMD_WQE_IOD		= 0x20,
+	SLI4_ICMD_WQE_HLM		= 0x10,
+	SLI4_ICMD_WQE_CCPE		= 0x80,
+	SLI4_ICMD_WQE_EAT		= 0x10,
+	SLI4_ICMD_WQE_APPID		= 0x10,
+	SLI4_ICMD_WQE_WQES		= 0x80,
+	SLI4_ICMD_WQE_PU_SHFT		= 4,
+	SLI4_ICMD_WQE_CT_SHFT		= 2,
+	SLI4_ICMD_WQE_BS_SHFT		= 4,
+	SLI4_ICMD_WQE_LEN_LOC_BIT1	= 0x80,
+	SLI4_ICMD_WQE_LEN_LOC_BIT2	= 0x1,
+};
+
+struct sli4_fcp_icmnd64_wqe {
+	struct sli4_bde	bde;
+	__le16		payload_offset_length;
+	__le16		fcp_cmd_buffer_length;
+	__le32		rsvd12;
+	__le32		remote_n_port_id_dword;
+	__le16		xri_tag;
+	__le16		context_tag;
+	u8		dif_ct_bs_byte;
+	u8		command;
+	u8		class_pu_byte;
+	u8		timer;
+	__le32		abort_tag;
+	__le16		request_tag;
+	__le16		rsvd34;
+	u8		len_loc1_byte;
+	u8		qosd_xbl_hlm_iod_dbde_wqes;
+	u8		eat_xc_ccpe;
+	u8		ccp;
+	u8		cmd_type_byte;
+	u8		rsvd41;
+	__le16		cq_id;
+	__le32		rsvd44;
+	__le32		rsvd48;
+	__le32		rsvd52;
+	__le32		rsvd56;
+};
+
+/* WQE used to create an FCP initiator read. */
+enum {
+	SLI4_IR_WQE_DBDE		= 0x40,
+	SLI4_IR_WQE_XBL			= 0x8,
+	SLI4_IR_WQE_XC			= 0x20,
+	SLI4_IR_WQE_IOD			= 0x20,
+	SLI4_IR_WQE_HLM			= 0x10,
+	SLI4_IR_WQE_CCPE		= 0x80,
+	SLI4_IR_WQE_EAT			= 0x10,
+	SLI4_IR_WQE_APPID		= 0x10,
+	SLI4_IR_WQE_WQES		= 0x80,
+	SLI4_IR_WQE_PU_SHFT		= 4,
+	SLI4_IR_WQE_CT_SHFT		= 2,
+	SLI4_IR_WQE_BS_SHFT		= 4,
+	SLI4_IR_WQE_LEN_LOC_BIT1	= 0x80,
+	SLI4_IR_WQE_LEN_LOC_BIT2	= 0x1,
+};
+
+struct sli4_fcp_iread64_wqe {
+	struct sli4_bde	bde;
+	__le16		payload_offset_length;
+	__le16		fcp_cmd_buffer_length;
+
+	__le32		total_transfer_length;
+
+	__le32		remote_n_port_id_dword;
+
+	__le16		xri_tag;
+	__le16		context_tag;
+
+	u8		dif_ct_bs_byte;
+	u8		command;
+	u8		class_pu_byte;
+	u8		timer;
+
+	__le32		abort_tag;
+
+	__le16		request_tag;
+	__le16		rsvd34;
+
+	u8		len_loc1_byte;
+	u8		qosd_xbl_hlm_iod_dbde_wqes;
+	u8		eat_xc_ccpe;
+	u8		ccp;
+
+	u8		cmd_type_byte;
+	u8		rsvd41;
+	__le16		cq_id;
+
+	__le32		rsvd44;
+	struct sli4_bde	first_data_bde;
+};
+
+/* WQE used to create an FCP initiator write. */
+enum {
+	SLI4_IWR_WQE_DBDE		= 0x40,
+	SLI4_IWR_WQE_XBL		= 0x8,
+	SLI4_IWR_WQE_XC			= 0x20,
+	SLI4_IWR_WQE_IOD		= 0x20,
+	SLI4_IWR_WQE_HLM		= 0x10,
+	SLI4_IWR_WQE_DNRX		= 0x10,
+	SLI4_IWR_WQE_CCPE		= 0x80,
+	SLI4_IWR_WQE_EAT		= 0x10,
+	SLI4_IWR_WQE_APPID		= 0x10,
+	SLI4_IWR_WQE_WQES		= 0x80,
+	SLI4_IWR_WQE_PU_SHFT		= 4,
+	SLI4_IWR_WQE_CT_SHFT		= 2,
+	SLI4_IWR_WQE_BS_SHFT		= 4,
+	SLI4_IWR_WQE_LEN_LOC_BIT1	= 0x80,
+	SLI4_IWR_WQE_LEN_LOC_BIT2	= 0x1,
+};
+
+struct sli4_fcp_iwrite64_wqe {
+	struct sli4_bde	bde;
+	__le16		payload_offset_length;
+	__le16		fcp_cmd_buffer_length;
+	__le16		total_transfer_length;
+	__le16		initial_transfer_length;
+	__le16		xri_tag;
+	__le16		context_tag;
+	u8		dif_ct_bs_byte;
+	u8		command;
+	u8		class_pu_byte;
+	u8		timer;
+	__le32		abort_tag;
+	__le16		request_tag;
+	__le16		rsvd34;
+	u8		len_loc1_byte;
+	u8		qosd_xbl_hlm_iod_dbde_wqes;
+	u8		eat_xc_ccpe;
+	u8		ccp;
+	u8		cmd_type_byte;
+	u8		rsvd41;
+	__le16		cq_id;
+	__le32		remote_n_port_id_dword;
+	struct sli4_bde	first_data_bde;
+};
+
+struct sli4_fcp_128byte_wqe {
+	u32 dw[32];
+};
+
+/* WQE used to create an FCP target receive */
+enum {
+	SLI4_TRCV_WQE_DBDE		= 0x40,
+	SLI4_TRCV_WQE_XBL		= 0x8,
+	SLI4_TRCV_WQE_AR		= 0x8,
+	SLI4_TRCV_WQE_XC		= 0x20,
+	SLI4_TRCV_WQE_IOD		= 0x20,
+	SLI4_TRCV_WQE_HLM		= 0x10,
+	SLI4_TRCV_WQE_DNRX		= 0x10,
+	SLI4_TRCV_WQE_CCPE		= 0x80,
+	SLI4_TRCV_WQE_EAT		= 0x10,
+	SLI4_TRCV_WQE_APPID		= 0x10,
+	SLI4_TRCV_WQE_WQES		= 0x80,
+	SLI4_TRCV_WQE_PU_SHFT		= 4,
+	SLI4_TRCV_WQE_CT_SHFT		= 2,
+	SLI4_TRCV_WQE_BS_SHFT		= 4,
+	SLI4_TRCV_WQE_LEN_LOC_BIT2	= 0x1,
+};
+
+struct sli4_fcp_treceive64_wqe {
+	struct sli4_bde	bde;
+	__le32		payload_offset_length;
+	__le32		relative_offset;
+	union {
+		__le16		sec_xri_tag;
+		__le16		rsvd;
+		__le32		dword;
+	} dword5;
+	__le16		xri_tag;
+	__le16		context_tag;
+	u8		dif_ct_bs_byte;
+	u8		command;
+	u8		class_ar_pu_byte;
+	u8		timer;
+	__le32		abort_tag;
+	__le16		request_tag;
+	__le16		remote_xid;
+	u8		lloc1_appid;
+	u8		qosd_xbl_hlm_iod_dbde_wqes;
+	u8		eat_xc_ccpe;
+	u8		ccp;
+	u8		cmd_type_byte;
+	u8		rsvd41;
+	__le16		cq_id;
+	__le32		fcp_data_receive_length;
+	struct sli4_bde	first_data_bde;
+};
+
+/* WQE used to create an FCP target response */
+enum {
+	SLI4_TRSP_WQE_AG	= 0x8,
+	SLI4_TRSP_WQE_DBDE	= 0x40,
+	SLI4_TRSP_WQE_XBL	= 0x8,
+	SLI4_TRSP_WQE_XC	= 0x20,
+	SLI4_TRSP_WQE_HLM	= 0x10,
+	SLI4_TRSP_WQE_DNRX	= 0x10,
+	SLI4_TRSP_WQE_CCPE	= 0x80,
+	SLI4_TRSP_WQE_EAT	= 0x10,
+	SLI4_TRSP_WQE_APPID	= 0x10,
+	SLI4_TRSP_WQE_WQES	= 0x80,
+};
+
+struct sli4_fcp_trsp64_wqe {
+	struct sli4_bde	bde;
+	__le32		fcp_response_length;
+	__le32		rsvd12;
+	__le32		dword5;
+	__le16		xri_tag;
+	__le16		rpi;
+	u8		ct_dnrx_byte;
+	u8		command;
+	u8		class_ag_byte;
+	u8		timer;
+	__le32		abort_tag;
+	__le16		request_tag;
+	__le16		remote_xid;
+	u8		lloc1_appid;
+	u8		qosd_xbl_hlm_dbde_wqes;
+	u8		eat_xc_ccpe;
+	u8		ccp;
+	u8		cmd_type_byte;
+	u8		rsvd41;
+	__le16		cq_id;
+	__le32		rsvd44;
+	__le32		rsvd48;
+	__le32		rsvd52;
+	__le32		rsvd56;
+};
+
+/* WQE used to create an FCP target send (DATA IN). */
+enum {
+	SLI4_TSEND_WQE_XBL	= 0x8,
+	SLI4_TSEND_WQE_DBDE	= 0x40,
+	SLI4_TSEND_WQE_IOD	= 0x20,
+	SLI4_TSEND_WQE_QOSD	= 0x2,
+	SLI4_TSEND_WQE_HLM	= 0x10,
+	SLI4_TSEND_WQE_PU_SHFT	= 4,
+	SLI4_TSEND_WQE_AR	= 0x8,
+	SLI4_TSEND_CT_SHFT	= 2,
+	SLI4_TSEND_BS_SHFT	= 4,
+	SLI4_TSEND_LEN_LOC_BIT2 = 0x1,
+	SLI4_TSEND_CCPE		= 0x80,
+	SLI4_TSEND_APPID_VALID	= 0x20,
+	SLI4_TSEND_WQES		= 0x80,
+	SLI4_TSEND_XC		= 0x20,
+	SLI4_TSEND_EAT		= 0x10,
+};
+
+struct sli4_fcp_tsend64_wqe {
+	struct sli4_bde	bde;
+	__le32		payload_offset_length;
+	__le32		relative_offset;
+	__le32		dword5;
+	__le16		xri_tag;
+	__le16		rpi;
+	u8		ct_byte;
+	u8		command;
+	u8		class_pu_ar_byte;
+	u8		timer;
+	__le32		abort_tag;
+	__le16		request_tag;
+	__le16		remote_xid;
+	u8		dw10byte0;
+	u8		ll_qd_xbl_hlm_iod_dbde;
+	u8		dw10byte2;
+	u8		ccp;
+	u8		cmd_type_byte;
+	u8		rsvd45;
+	__le16		cq_id;
+	__le32		fcp_data_transmit_length;
+	struct sli4_bde	first_data_bde;
+};
+
+/* WQE used to create a general request. */
+enum {
+	SLI4_GEN_REQ64_WQE_XBL	= 0x8,
+	SLI4_GEN_REQ64_WQE_DBDE	= 0x40,
+	SLI4_GEN_REQ64_WQE_IOD	= 0x20,
+	SLI4_GEN_REQ64_WQE_QOSD	= 0x2,
+	SLI4_GEN_REQ64_WQE_HLM	= 0x10,
+	SLI4_GEN_REQ64_CT_SHFT	= 2,
+};
+
+struct sli4_gen_request64_wqe {
+	struct sli4_bde	bde;
+	__le32		request_payload_length;
+	__le32		relative_offset;
+	u8		rsvd17;
+	u8		df_ctl;
+	u8		type;
+	u8		r_ctl;
+	__le16		xri_tag;
+	__le16		context_tag;
+	u8		ct_byte;
+	u8		command;
+	u8		class_byte;
+	u8		timer;
+	__le32		abort_tag;
+	__le16		request_tag;
+	__le16		rsvd34;
+	u8		dw10flags0;
+	u8		dw10flags1;
+	u8		dw10flags2;
+	u8		ccp;
+	u8		cmd_type_byte;
+	u8		rsvd41;
+	__le16		cq_id;
+	__le32		remote_n_port_id_dword;
+	__le32		rsvd48;
+	__le32		rsvd52;
+	__le32		max_response_payload_length;
+};
+
+/* WQE used to create a send frame request */
+enum {
+	SLI4_SF_WQE_DBDE	= 0x40,
+	SLI4_SF_PU		= 0x30,
+	SLI4_SF_CT		= 0xc,
+	SLI4_SF_QOSD		= 0x2,
+	SLI4_SF_LEN_LOC_BIT1	= 0x80,
+	SLI4_SF_LEN_LOC_BIT2	= 0x1,
+	SLI4_SF_XC		= 0x20,
+	SLI4_SF_XBL		= 0x8,
+};
+
+struct sli4_send_frame_wqe {
+	struct sli4_bde	bde;
+	__le32		frame_length;
+	__le32		fc_header_0_1[2];
+	__le16		xri_tag;
+	__le16		context_tag;
+	u8		ct_byte;
+	u8		command;
+	u8		dw7flags0;
+	u8		timer;
+	__le32		abort_tag;
+	__le16		request_tag;
+	u8		eof;
+	u8		sof;
+	u8		dw10flags0;
+	u8		dw10flags1;
+	u8		dw10flags2;
+	u8		ccp;
+	u8		cmd_type_byte;
+	u8		rsvd41;
+	__le16		cq_id;
+	__le32		fc_header_2_5[4];
+};
+
+/* WQE used to create a transmit sequence */
+enum {
+	SLI4_SEQ_WQE_DBDE		= 0x4000,
+	SLI4_SEQ_WQE_XBL		= 0x800,
+	SLI4_SEQ_WQE_SI			= 0x4,
+	SLI4_SEQ_WQE_FT			= 0x8,
+	SLI4_SEQ_WQE_XO			= 0x40,
+	SLI4_SEQ_WQE_LS			= 0x80,
+	SLI4_SEQ_WQE_DIF		= 0x3,
+	SLI4_SEQ_WQE_BS			= 0x70,
+	SLI4_SEQ_WQE_PU			= 0x30,
+	SLI4_SEQ_WQE_HLM		= 0x1000,
+	SLI4_SEQ_WQE_IOD_SHIFT		= 13,
+	SLI4_SEQ_WQE_CT_SHIFT		= 2,
+	SLI4_SEQ_WQE_LEN_LOC_SHIFT	= 7,
+};
+
+struct sli4_xmit_sequence64_wqe {
+	struct sli4_bde	bde;
+	__le32		remote_n_port_id_dword;
+	__le32		relative_offset;
+	u8		dw5flags0;
+	u8		df_ctl;
+	u8		type;
+	u8		r_ctl;
+	__le16		xri_tag;
+	__le16		context_tag;
+	u8		dw7flags0;
+	u8		command;
+	u8		dw7flags1;
+	u8		timer;
+	__le32		abort_tag;
+	__le16		request_tag;
+	__le16		remote_xid;
+	__le16		dw10w0;
+	u8		dw10flags0;
+	u8		ccp;
+	u8		cmd_type_wqec_byte;
+	u8		rsvd45;
+	__le16		cq_id;
+	__le32		sequence_payload_len;
+	__le32		rsvd48;
+	__le32		rsvd52;
+	__le32		rsvd56;
+};
+
+/*
+ * WQE used unblock the specified XRI and to release
+ * it to the SLI Port's free pool.
+ */
+enum {
+	SLI4_REQU_XRI_WQE_XC	= 0x20,
+	SLI4_REQU_XRI_WQE_QOSD	= 0x2,
+};
+
+struct sli4_requeue_xri_wqe {
+	__le32		rsvd0;
+	__le32		rsvd4;
+	__le32		rsvd8;
+	__le32		rsvd12;
+	__le32		rsvd16;
+	__le32		rsvd20;
+	__le16		xri_tag;
+	__le16		context_tag;
+	u8		ct_byte;
+	u8		command;
+	u8		class_byte;
+	u8		timer;
+	__le32		rsvd32;
+	__le16		request_tag;
+	__le16		rsvd34;
+	__le16		flags0;
+	__le16		flags1;
+	__le16		flags2;
+	u8		ccp;
+	u8		cmd_type_wqec_byte;
+	u8		rsvd42;
+	__le16		cq_id;
+	__le32		rsvd44;
+	__le32		rsvd48;
+	__le32		rsvd52;
+	__le32		rsvd56;
+};
+
+/* WQE used to send a single frame sequence to broadcast address */
+enum {
+	SLI4_BCAST_WQE_DBDE		= 0x4000,
+	SLI4_BCAST_WQE_CT_SHIFT		= 2,
+	SLI4_BCAST_WQE_LEN_LOC_SHIFT	= 7,
+	SLI4_BCAST_WQE_IOD_SHIFT	= 13,
+};
+
+struct sli4_xmit_bcast64_wqe {
+	struct sli4_bde	sequence_payload;
+	__le32		sequence_payload_length;
+	__le32		rsvd16;
+	u8		rsvd17;
+	u8		df_ctl;
+	u8		type;
+	u8		r_ctl;
+	__le16		xri_tag;
+	__le16		context_tag;
+	u8		ct_byte;
+	u8		command;
+	u8		dw7flags0;
+	u8		timer;
+	__le32		abort_tag;
+	__le16		request_tag;
+	__le16		temporary_rpi;
+	__le16		dw10w0;
+	u8		dw10flags1;
+	u8		ccp;
+	u8		dw11flags0;
+	u8		rsvd41;
+	__le16		cq_id;
+	__le32		rsvd44;
+	__le32		rsvd45;
+	__le32		rsvd46;
+	__le32		rsvd47;
+};
+
+/* WQE used to create a BLS response */
+enum {
+	SLI4_BLS_RSP_RID		= 0xffffff,
+	SLI4_BLS_RSP_WQE_AR		= 0x40000000,
+	SLI4_BLS_RSP_WQE_CT_SHFT	= 2,
+	SLI4_BLS_RSP_WQE_QOSD		= 0x2,
+	SLI4_BLS_RSP_WQE_HLM		= 0x10,
+};
+
+struct sli4_xmit_bls_rsp_wqe {
+	__le32		payload_word0;
+	__le16		rx_id;
+	__le16		ox_id;
+	__le16		high_seq_cnt;
+	__le16		low_seq_cnt;
+	__le32		rsvd12;
+	__le32		local_n_port_id_dword;
+	__le32		remote_id_dword;
+	__le16		xri_tag;
+	__le16		context_tag;
+	u8		dw8flags0;
+	u8		command;
+	u8		dw8flags1;
+	u8		timer;
+	__le32		abort_tag;
+	__le16		request_tag;
+	__le16		rsvd38;
+	u8		dw11flags0;
+	u8		dw11flags1;
+	u8		dw11flags2;
+	u8		ccp;
+	u8		dw12flags0;
+	u8		rsvd45;
+	__le16		cq_id;
+	__le16		temporary_rpi;
+	u8		rsvd50;
+	u8		rsvd51;
+	__le32		rsvd52;
+	__le32		rsvd56;
+	__le32		rsvd60;
+};
+
+enum sli_bls_type {
+	SLI4_SLI_BLS_ACC,
+	SLI4_SLI_BLS_RJT,
+	SLI4_SLI_BLS_MAX
+};
+
+struct sli_bls_payload {
+	enum sli_bls_type	type;
+	__le16			ox_id;
+	__le16			rx_id;
+	union {
+		struct {
+			u8	seq_id_validity;
+			u8	seq_id_last;
+			u8	rsvd2;
+			u8	rsvd3;
+			u16	ox_id;
+			u16	rx_id;
+			__le16	low_seq_cnt;
+			__le16	high_seq_cnt;
+		} acc;
+		struct {
+			u8	vendor_unique;
+			u8	reason_explanation;
+			u8	reason_code;
+			u8	rsvd3;
+		} rjt;
+	} u;
+};
+
+/* WQE used to create an ELS response */
+
+enum {
+	SLI4_ELS_SID		= 0xffffff,
+	SLI4_ELS_RID		= 0xffffff,
+	SLI4_ELS_DBDE		= 0x40,
+	SLI4_ELS_XBL		= 0x8,
+	SLI4_ELS_IOD		= 0x20,
+	SLI4_ELS_QOSD		= 0x2,
+	SLI4_ELS_XC		= 0x20,
+	SLI4_ELS_CT_OFFSET	= 0X2,
+	SLI4_ELS_SP		= 0X1000000,
+	SLI4_ELS_HLM		= 0X10,
+};
+
+struct sli4_xmit_els_rsp64_wqe {
+	struct sli4_bde	els_response_payload;
+	__le32		els_response_payload_length;
+	__le32		sid_dw;
+	__le32		rid_dw;
+	__le16		xri_tag;
+	__le16		context_tag;
+	u8		ct_byte;
+	u8		command;
+	u8		class_byte;
+	u8		timer;
+	__le32		abort_tag;
+	__le16		request_tag;
+	__le16		ox_id;
+	u8		flags1;
+	u8		flags2;
+	u8		flags3;
+	u8		flags4;
+	u8		cmd_type_wqec;
+	u8		rsvd34;
+	__le16		cq_id;
+	__le16		temporary_rpi;
+	__le16		rsvd38;
+	u32		rsvd40;
+	u32		rsvd44;
+	u32		rsvd48;
+};
+
+/* Local Reject Reason Codes */
+#define SLI4_FC_LOCAL_REJECT_MISSING_CONTINUE		0x01
+#define SLI4_FC_LOCAL_REJECT_SEQUENCE_TIMEOUT		0x02
+#define SLI4_FC_LOCAL_REJECT_INTERNAL_ERROR		0x03
+#define SLI4_FC_LOCAL_REJECT_INVALID_RPI		0x04
+#define SLI4_FC_LOCAL_REJECT_NO_XRI			0x05
+#define SLI4_FC_LOCAL_REJECT_ILLEGAL_COMMAND		0x06
+#define SLI4_FC_LOCAL_REJECT_XCHG_DROPPED		0x07
+#define SLI4_FC_LOCAL_REJECT_ILLEGAL_FIELD		0x08
+#define SLI4_FC_LOCAL_REJECT_NO_ABORT_MATCH		0x0c
+#define SLI4_FC_LOCAL_REJECT_TX_DMA_FAILED		0x0d
+#define SLI4_FC_LOCAL_REJECT_RX_DMA_FAILED		0x0e
+#define SLI4_FC_LOCAL_REJECT_ILLEGAL_FRAME		0x0f
+#define SLI4_FC_LOCAL_REJECT_NO_RESOURCES		0x11
+#define SLI4_FC_LOCAL_REJECT_FCP_CONF_FAILURE		0x12
+#define SLI4_FC_LOCAL_REJECT_ILLEGAL_LENGTH		0x13
+#define SLI4_FC_LOCAL_REJECT_UNSUPPORTED_FEATURE	0x14
+#define SLI4_FC_LOCAL_REJECT_ABORT_IN_PROGRESS		0x15
+#define SLI4_FC_LOCAL_REJECT_ABORT_REQUESTED		0x16
+#define SLI4_FC_LOCAL_REJECT_RCV_BUFFER_TIMEOUT	0x17
+#define SLI4_FC_LOCAL_REJECT_LOOP_OPEN_FAILURE		0x18
+#define SLI4_FC_LOCAL_REJECT_LINK_DOWN			0x1a
+#define SLI4_FC_LOCAL_REJECT_CORRUPTED_DATA		0x1b
+#define SLI4_FC_LOCAL_REJECT_CORRUPTED_RPI		0x1c
+#define SLI4_FC_LOCAL_REJECT_OUTOFORDER_DATA		0x1d
+#define SLI4_FC_LOCAL_REJECT_OUTOFORDER_ACK		0x1e
+#define SLI4_FC_LOCAL_REJECT_DUP_FRAME			0x1f
+#define SLI4_FC_LOCAL_REJECT_LINK_CONTROL_FRAME	0x20
+#define SLI4_FC_LOCAL_REJECT_BAD_HOST_ADDRESS		0x21
+#define SLI4_FC_LOCAL_REJECT_MISSING_HDR_BUFFER	0x23
+#define SLI4_FC_LOCAL_REJECT_MSEQ_CHAIN_CORRUPTED	0x24
+#define SLI4_FC_LOCAL_REJECT_ABORTMULT_REQUESTED	0x25
+#define SLI4_FC_LOCAL_REJECT_BUFFER_SHORTAGE		0x28
+#define SLI4_FC_LOCAL_REJECT_RCV_XRIBUF_WAITING	0x29
+#define SLI4_FC_LOCAL_REJECT_INVALID_VPI		0x2e
+#define SLI4_FC_LOCAL_REJECT_MISSING_XRIBUF		0x30
+#define SLI4_FC_LOCAL_REJECT_INVALID_RELOFFSET		0x40
+#define SLI4_FC_LOCAL_REJECT_MISSING_RELOFFSET		0x41
+#define SLI4_FC_LOCAL_REJECT_INSUFF_BUFFERSPACE	0x42
+#define SLI4_FC_LOCAL_REJECT_MISSING_SI		0x43
+#define SLI4_FC_LOCAL_REJECT_MISSING_ES		0x44
+#define SLI4_FC_LOCAL_REJECT_INCOMPLETE_XFER		0x45
+#define SLI4_FC_LOCAL_REJECT_SLER_FAILURE		0x46
+#define SLI4_FC_LOCAL_REJECT_SLER_CMD_RCV_FAILURE	0x47
+#define SLI4_FC_LOCAL_REJECT_SLER_REC_RJT_ERR		0x48
+#define SLI4_FC_LOCAL_REJECT_SLER_REC_SRR_RETRY_ERR	0x49
+#define SLI4_FC_LOCAL_REJECT_SLER_SRR_RJT_ERR		0x4a
+#define SLI4_FC_LOCAL_REJECT_SLER_RRQ_RJT_ERR		0x4c
+#define SLI4_FC_LOCAL_REJECT_SLER_RRQ_RETRY_ERR	0x4d
+#define SLI4_FC_LOCAL_REJECT_SLER_ABTS_ERR		0x4e
+
+enum {
+	SLI4_RACQE_RQ_EL_INDX	= 0xfff,
+	SLI4_RACQE_FCFI		= 0x3f,
+	SLI4_RACQE_HDPL		= 0x3f,
+	SLI4_RACQE_RQ_ID	= 0xffc0,
+};
+
+struct sli4_fc_async_rcqe {
+	u8		rsvd0;
+	u8		status;
+	__le16		rq_elmt_indx_word;
+	__le32		rsvd4;
+	__le16		fcfi_rq_id_word;
+	__le16		data_placement_length;
+	u8		sof_byte;
+	u8		eof_byte;
+	u8		code;
+	u8		hdpl_byte;
+};
+
+struct sli4_fc_async_rcqe_v1 {
+	u8		rsvd0;
+	u8		status;
+	__le16		rq_elmt_indx_word;
+	u8		fcfi_byte;
+	u8		rsvd5;
+	__le16		rsvd6;
+	__le16		rq_id;
+	__le16		data_placement_length;
+	u8		sof_byte;
+	u8		eof_byte;
+	u8		code;
+	u8		hdpl_byte;
+};
+
+#define SLI4_FC_ASYNC_RQ_SUCCESS		0x10
+#define SLI4_FC_ASYNC_RQ_BUF_LEN_EXCEEDED	0x11
+#define SLI4_FC_ASYNC_RQ_INSUFF_BUF_NEEDED	0x12
+#define SLI4_FC_ASYNC_RQ_INSUFF_BUF_FRM_DISC	0x13
+#define SLI4_FC_ASYNC_RQ_DMA_FAILURE		0x14
+enum {
+	SLI4_RCQE_RQ_EL_INDX = 0xfff,
+};
+
+struct sli4_fc_coalescing_rcqe {
+	u8		rsvd0;
+	u8		status;
+	__le16		rq_elmt_indx_word;
+	__le32		rsvd4;
+	__le16		rq_id;
+	__le16		sequence_reporting_placement_length;
+	__le16		rsvd14;
+	u8		code;
+	u8		vld_byte;
+};
+
+#define SLI4_FC_COALESCE_RQ_SUCCESS		0x10
+#define SLI4_FC_COALESCE_RQ_INSUFF_XRI_NEEDED	0x18
+/*
+ * @SLI4_OCQE_RQ_EL_INDX: bits 0 to 15 in word1
+ * @SLI4_OCQE_FCFI: bits 0 to 6 in dw1
+ * @SLI4_OCQE_OOX: bit 15 in dw1
+ * @SLI4_OCQE_AGXR: bit 16 in dw1
+ */
+enum {
+	SLI4_OCQE_RQ_EL_INDX = 0x7f,
+	SLI4_OCQE_FCFI = 0x3f,
+	SLI4_OCQE_OOX = (1 << 6),
+	SLI4_OCQE_AGXR = (1 << 7),
+	SLI4_OCQE_HDPL = 0x3f,
+};
+
+struct sli4_fc_optimized_write_cmd_cqe {
+	u8		rsvd0;
+	u8		status;
+	__le16		w1;
+	u8		flags0;
+	u8		flags1;
+	__le16		xri;
+	__le16		rq_id;
+	__le16		data_placement_length;
+	__le16		rpi;
+	u8		code;
+	u8		hdpl_vld;
+};
+
+enum {
+	SLI4_OCQE_XB = (1 << 4),
+};
+
+struct sli4_fc_optimized_write_data_cqe {
+	u8		hw_status;
+	u8		status;
+	__le16		xri;
+	__le32		total_data_placed;
+	__le32		extended_status;
+	__le16		rsvd12;
+	u8		code;
+	u8		flags;
+};
+
+struct sli4_fc_xri_aborted_cqe {
+	u8		rsvd0;
+	u8		status;
+	__le16		rsvd2;
+	__le32		extended_status;
+	__le16		xri;
+	__le16		remote_xid;
+	__le16		rsvd12;
+	u8		code;
+	u8		flags;
+};
+
+#define SLI4_GENERIC_CONTEXT_RPI		0x0
+#define SLI4_GENERIC_CONTEXT_VPI		0x1
+#define SLI4_GENERIC_CONTEXT_VFI		0x2
+#define SLI4_GENERIC_CONTEXT_FCFI		0x3
+
+#define SLI4_GENERIC_CLASS_CLASS_2		0x1
+#define SLI4_GENERIC_CLASS_CLASS_3		0x2
+
+#define SLI4_ELS_REQUEST64_DIR_WRITE		0x0
+#define SLI4_ELS_REQUEST64_DIR_READ		0x1
+
+#define SLI4_ELS_REQUEST64_OTHER		0x0
+#define SLI4_ELS_REQUEST64_LOGO		0x1
+#define SLI4_ELS_REQUEST64_FDISC		0x2
+#define SLI4_ELS_REQUEST64_FLOGIN		0x3
+#define SLI4_ELS_REQUEST64_PLOGI		0x4
+
+#define SLI4_ELS_REQUEST64_CMD_GEN		0x08
+#define SLI4_ELS_REQUEST64_CMD_NON_FABRIC	0x0c
+#define SLI4_ELS_REQUEST64_CMD_FABRIC		0x0d
+
 #endif /* !_SLI4_H */
-- 
2.13.7


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D226DC2D0D5
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99A812082E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nxOPgFhW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfLTWhv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:37:51 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43050 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727337AbfLTWhu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:37:50 -0500
Received: by mail-pl1-f194.google.com with SMTP id p27so4705373pli.10
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ql50XyAX9f9O/ogIGKXpXCc2H39PKesoeWqnFBXlUOk=;
        b=nxOPgFhW1we8DdgghGatQe9VCEEVtZ+IiE+H0KDXHNfZXJI3vqIbgq2Bd2fkpc87XR
         uiDNVk4PNdMuN3rTXKF/uB+FT4NvmLEBhXTunp20c9fSlYYK9+kOwNSsP1FTf37B0BOe
         9na3qcGErTOQJczsFFQ01V0zYYa1UHEWdcQM2wWuEqaO/eg8TlnT1rRWHIEoiUpe08Pu
         QB+jTjMy05DfH3S9uDjP8A7evfMa7W+hdJI/vBT4stkcpYwRGRpvftn1PWkSm7fvVtyO
         pc/No+s2hm3d6kKivLV/cicU4hxQ5LAQutGH750kcOp1UZGGgE85mw11Dh07e1KCq+Vz
         n0Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ql50XyAX9f9O/ogIGKXpXCc2H39PKesoeWqnFBXlUOk=;
        b=Vb8jBtbJw2FQLE7Srei6IOIapr8z4iWpCLH1giyV4uajxnAe7+LbvURsUtSPj2/zsi
         ZlmzE7Cgry/RLnuCw4BFK98lb+wrZLzeIb2Dvv5GoaGi7JLPlyMM8sFmofuVqslegO9J
         6tyQTZdoZv60vJoSeE7+3ygLDed6dVEBDVe9l3Sb8lh+1gJYp7BptQFEYldTYPkTaLhL
         hnQI+JQV0dLVCxi8sAhgnf3pG0MG0y+swrzWAAFyWYl2KHd4wFDjIwEeNkIgvEpqgPYp
         BNLd/DRlnHyVoSQQom7sF/Uhw03Gji1b3NB/chdVUtz9GGVYR83emGR+nMXl+Xc5dIsr
         RCTA==
X-Gm-Message-State: APjAAAXLDku4nNF83j3n+qlOvp/Tk06WLcxsWwOPVSIrS1CUvxcF9/l3
        M427x1csw9Bg2XsW9vAH2KcH4EJC
X-Google-Smtp-Source: APXvYqxo4d9cnWpG2k7n5LS2E3vbKfkmjNafQmE5+PhfhcmXBFegEz/IZuyJZvNhPBne4CWjaJaICg==
X-Received: by 2002:a17:90a:d783:: with SMTP id z3mr18135760pju.3.1576881468473;
        Fri, 20 Dec 2019 14:37:48 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.37.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:37:47 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 15/32] elx: efct: Data structures and defines for hw operations
Date:   Fri, 20 Dec 2019 14:37:06 -0800
Message-Id: <20191220223723.26563-16-jsmart2021@gmail.com>
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

This patch starts the population of the efct target mode
driver.  The driver is contained in the drivers/scsi/elx/efct
subdirectory.

This patch creates the efct directory and starts population of
the driver by adding SLI-4 configuration parameters, data structures
for configuring SLI-4 queues, converting from os to SLI-4 IO requests,
and handling async events.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_hw.h | 852 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 852 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_hw.h

diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
new file mode 100644
index 000000000000..ff6de91923fa
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -0,0 +1,852 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#ifndef _EFCT_HW_H
+#define _EFCT_HW_H
+
+#include "../libefc_sli/sli4.h"
+#include "efct_utils.h"
+
+/*
+ * EFCT PCI IDs
+ */
+#define EFCT_VENDOR_ID			0x10df
+/* LightPulse 16Gb x 4 FC (lancer-g6) */
+#define EFCT_DEVICE_ID_LPE31004		0xe307
+#define PCI_PRODUCT_EMULEX_LPE32002	0xe307
+/* LightPulse 32Gb x 4 FC (lancer-g7) */
+#define EFCT_DEVICE_ID_G7		0xf407
+
+/*Default RQ entries len used by driver*/
+#define EFCT_HW_RQ_ENTRIES_MIN		512
+#define EFCT_HW_RQ_ENTRIES_DEF		1024
+#define EFCT_HW_RQ_ENTRIES_MAX		4096
+
+/*Defines the size of the RQ buffers used for each RQ*/
+#define EFCT_HW_RQ_SIZE_HDR             128
+#define EFCT_HW_RQ_SIZE_PAYLOAD         1024
+
+/*Define the maximum number of multi-receive queues*/
+#define EFCT_HW_MAX_MRQS		8
+
+/*
+ * Define count of when to set the WQEC bit in a submitted
+ * WQE, causing a consummed/released completion to be posted.
+ */
+#define EFCT_HW_WQEC_SET_COUNT		32
+
+/*Send frame timeout in seconds*/
+#define EFCT_HW_SEND_FRAME_TIMEOUT	10
+
+/*
+ * FDT Transfer Hint value, reads greater than this value
+ * will be segmented to implement fairness. A value of zero disables
+ * the feature.
+ */
+#define EFCT_HW_FDT_XFER_HINT		8192
+
+#define EFCT_HW_TIMECHECK_ITERATIONS	100
+#define EFCT_HW_MAX_NUM_MQ		1
+#define EFCT_HW_MAX_NUM_RQ		32
+#define EFCT_HW_MAX_NUM_EQ		16
+#define EFCT_HW_MAX_NUM_WQ		32
+
+#define OCE_HW_MAX_NUM_MRQ_PAIRS	16
+
+#define EFCT_HW_MAX_WQ_CLASS		4
+#define EFCT_HW_MAX_WQ_CPU		128
+
+/*
+ * A CQ will be assinged to each WQ
+ * (CQ must have 2X entries of the WQ for abort
+ * processing), plus a separate one for each RQ PAIR and one for MQ
+ */
+#define EFCT_HW_MAX_NUM_CQ \
+	((EFCT_HW_MAX_NUM_WQ * 2) + 1 + (OCE_HW_MAX_NUM_MRQ_PAIRS * 2))
+
+#define EFCT_HW_Q_HASH_SIZE		128
+#define EFCT_HW_RQ_HEADER_SIZE		128
+#define EFCT_HW_RQ_HEADER_INDEX		0
+
+/* Options for efct_hw_command() */
+enum {
+	/* command executes synchronously and busy-waits for completion */
+	EFCT_CMD_POLL,
+	/* command executes asynchronously. Uses callback */
+	EFCT_CMD_NOWAIT,
+};
+
+enum efct_hw_rtn {
+	EFCT_HW_RTN_SUCCESS = 0,
+	EFCT_HW_RTN_SUCCESS_SYNC = 1,
+	EFCT_HW_RTN_ERROR = -1,
+	EFCT_HW_RTN_NO_RESOURCES = -2,
+	EFCT_HW_RTN_NO_MEMORY = -3,
+	EFCT_HW_RTN_IO_NOT_ACTIVE = -4,
+	EFCT_HW_RTN_IO_ABORT_IN_PROGRESS = -5,
+	EFCT_HW_RTN_IO_PORT_OWNED_ALREADY_ABORTED = -6,
+	EFCT_HW_RTN_INVALID_ARG = -7,
+};
+
+#define EFCT_HW_RTN_IS_ERROR(e)	((e) < 0)
+
+enum efct_hw_reset {
+	EFCT_HW_RESET_FUNCTION,
+	EFCT_HW_RESET_FIRMWARE,
+	EFCT_HW_RESET_MAX
+};
+
+enum efct_hw_property {
+	EFCT_HW_N_IO,
+	EFCT_HW_N_SGL,
+	EFCT_HW_MAX_IO,
+	EFCT_HW_MAX_SGE,
+	EFCT_HW_MAX_SGL,
+	EFCT_HW_MAX_NODES,
+	EFCT_HW_MAX_RQ_ENTRIES,
+	EFCT_HW_TOPOLOGY,
+	EFCT_HW_WWN_NODE,
+	EFCT_HW_WWN_PORT,
+	EFCT_HW_FW_REV,
+	EFCT_HW_FW_REV2,
+	EFCT_HW_IPL,
+	EFCT_HW_VPD,
+	EFCT_HW_VPD_LEN,
+	EFCT_HW_MODE,
+	EFCT_HW_LINK_SPEED,
+	EFCT_HW_IF_TYPE,
+	EFCT_HW_SLI_REV,
+	EFCT_HW_SLI_FAMILY,
+	EFCT_HW_RQ_PROCESS_LIMIT,
+	EFCT_HW_RQ_DEFAULT_BUFFER_SIZE,
+	EFCT_HW_AUTO_XFER_RDY_CAPABLE,
+	EFCT_HW_AUTO_XFER_RDY_XRI_CNT,
+	EFCT_HW_AUTO_XFER_RDY_SIZE,
+	EFCT_HW_AUTO_XFER_RDY_BLK_SIZE,
+	EFCT_HW_AUTO_XFER_RDY_T10_ENABLE,
+	EFCT_HW_AUTO_XFER_RDY_P_TYPE,
+	EFCT_HW_AUTO_XFER_RDY_REF_TAG_IS_LBA,
+	EFCT_HW_AUTO_XFER_RDY_APP_TAG_VALID,
+	EFCT_HW_AUTO_XFER_RDY_APP_TAG_VALUE,
+	EFCT_HW_DIF_CAPABLE,
+	EFCT_HW_DIF_SEED,
+	EFCT_HW_DIF_MODE,
+	EFCT_HW_DIF_MULTI_SEPARATE,
+	EFCT_HW_DUMP_MAX_SIZE,
+	EFCT_HW_DUMP_READY,
+	EFCT_HW_DUMP_PRESENT,
+	EFCT_HW_RESET_REQUIRED,
+	EFCT_HW_FW_ERROR,
+	EFCT_HW_FW_READY,
+	EFCT_HW_HIGH_LOGIN_MODE,
+	EFCT_HW_PREREGISTER_SGL,
+	EFCT_HW_HW_REV1,
+	EFCT_HW_HW_REV2,
+	EFCT_HW_HW_REV3,
+	EFCT_HW_ETH_LICENSE,
+	EFCT_HW_LINK_MODULE_TYPE,
+	EFCT_HW_NUM_CHUTES,
+	EFCT_HW_WAR_VERSION,
+	/* enable driver timeouts for target WQEs */
+	EFCT_HW_EMULATE_TARGET_WQE_TIMEOUT,
+	EFCT_HW_LINK_CONFIG_SPEED,
+	EFCT_HW_CONFIG_TOPOLOGY,
+	EFCT_HW_BOUNCE,
+	EFCT_HW_PORTNUM,
+	EFCT_HW_BIOS_VERSION_STRING,
+	EFCT_HW_RQ_SELECT_POLICY,
+	EFCT_HW_SGL_CHAINING_CAPABLE,
+	EFCT_HW_SGL_CHAINING_ALLOWED,
+	EFCT_HW_SGL_CHAINING_HOST_ALLOCATED,
+	EFCT_HW_SEND_FRAME_CAPABLE,
+	EFCT_HW_RQ_SELECTION_POLICY,
+	EFCT_HW_RR_QUANTA,
+	EFCT_HW_FILTER_DEF,
+	EFCT_HW_MAX_VPORTS,
+	EFCT_ESOC,
+};
+
+enum {
+	EFCT_HW_TOPOLOGY_AUTO,
+	EFCT_HW_TOPOLOGY_NPORT,
+	EFCT_HW_TOPOLOGY_LOOP,
+	EFCT_HW_TOPOLOGY_NONE,
+	EFCT_HW_TOPOLOGY_MAX
+};
+
+enum {
+	EFCT_HW_MODE_INITIATOR,
+	EFCT_HW_MODE_TARGET,
+	EFCT_HW_MODE_BOTH,
+	EFCT_HW_MODE_MAX
+};
+
+/* pack fw revision values into a single uint64_t */
+#define HW_FWREV(a, b, c, d) (((uint64_t)(a) << 48) | ((uint64_t)(b) << 32) \
+			| ((uint64_t)(c) << 16) | ((uint64_t)(d)))
+
+#define EFCT_FW_VER_STR(a, b, c, d) (#a "." #b "." #c "." #d)
+
+/* Defines DIF operation modes */
+enum {
+	EFCT_HW_DIF_MODE_INLINE,
+	EFCT_HW_DIF_MODE_SEPARATE,
+};
+
+/* T10 DIF operations */
+enum efct_hw_dif_oper {
+	EFCT_HW_DIF_OPER_DISABLED,
+	EFCT_HW_SGE_DIFOP_INNODIFOUTCRC,
+	EFCT_HW_SGE_DIFOP_INCRCOUTNODIF,
+	EFCT_HW_SGE_DIFOP_INNODIFOUTCHKSUM,
+	EFCT_HW_SGE_DIFOP_INCHKSUMOUTNODIF,
+	EFCT_HW_SGE_DIFOP_INCRCOUTCRC,
+	EFCT_HW_SGE_DIFOP_INCHKSUMOUTCHKSUM,
+	EFCT_HW_SGE_DIFOP_INCRCOUTCHKSUM,
+	EFCT_HW_SGE_DIFOP_INCHKSUMOUTCRC,
+	EFCT_HW_SGE_DIFOP_INRAWOUTRAW,
+};
+
+#define EFCT_HW_DIF_OPER_PASS_THRU	EFCT_HW_SGE_DIFOP_INCRCOUTCRC
+#define EFCT_HW_DIF_OPER_STRIP		EFCT_HW_SGE_DIFOP_INCRCOUTNODIF
+#define EFCT_HW_DIF_OPER_INSERT		EFCT_HW_SGE_DIFOP_INNODIFOUTCRC
+
+/* T10 DIF block sizes */
+enum efct_hw_dif_blk_size {
+	EFCT_HW_DIF_BK_SIZE_512,
+	EFCT_HW_DIF_BK_SIZE_1024,
+	EFCT_HW_DIF_BK_SIZE_2048,
+	EFCT_HW_DIF_BK_SIZE_4096,
+	EFCT_HW_DIF_BK_SIZE_520,
+	EFCT_HW_DIF_BK_SIZE_4104,
+	EFCT_HW_DIF_BK_SIZE_NA = 0
+};
+
+/* link module types */
+enum {
+	EFCT_HW_LINK_MODULE_TYPE_1GB	= 0x0004,
+	EFCT_HW_LINK_MODULE_TYPE_2GB	= 0x0008,
+	EFCT_HW_LINK_MODULE_TYPE_4GB	= 0x0040,
+	EFCT_HW_LINK_MODULE_TYPE_8GB	= 0x0080,
+	EFCT_HW_LINK_MODULE_TYPE_10GB	= 0x0100,
+	EFCT_HW_LINK_MODULE_TYPE_16GB	= 0x0200,
+	EFCT_HW_LINK_MODULE_TYPE_32GB	= 0x0400,
+};
+
+/* T10 DIF information passed to the transport */
+struct efct_hw_dif_info {
+	enum efct_hw_dif_oper dif_oper;
+	enum efct_hw_dif_blk_size blk_size;
+	u32 ref_tag_cmp;
+	u32 ref_tag_repl;
+	u16 app_tag_cmp;
+	u16 app_tag_repl;
+	bool check_ref_tag;
+	bool check_app_tag;
+	bool check_guard;
+	bool auto_incr_ref_tag;
+	bool repl_app_tag;
+	bool repl_ref_tag;
+	bool dif_separate;
+
+	/* If the APP TAG is 0xFFFF, disable REF TAG and CRC field chk */
+	bool disable_app_ffff;
+
+	/* if the APP TAG is 0xFFFF and REF TAG is 0xFFFF_FFFF,
+	 * disable checking the received CRC field.
+	 */
+	bool disable_app_ref_ffff;
+	u16 dif_seed;
+	u8 dif;
+};
+
+enum efct_hw_io_type {
+	EFCT_HW_ELS_REQ,
+	EFCT_HW_ELS_RSP,
+	EFCT_HW_ELS_RSP_SID,
+	EFCT_HW_FC_CT,
+	EFCT_HW_FC_CT_RSP,
+	EFCT_HW_BLS_ACC,
+	EFCT_HW_BLS_ACC_SID,
+	EFCT_HW_BLS_RJT,
+	EFCT_HW_IO_TARGET_READ,
+	EFCT_HW_IO_TARGET_WRITE,
+	EFCT_HW_IO_TARGET_RSP,
+	EFCT_HW_IO_DNRX_REQUEUE,
+	EFCT_HW_IO_MAX,
+};
+
+enum efct_hw_io_state {
+	EFCT_HW_IO_STATE_FREE,
+	EFCT_HW_IO_STATE_INUSE,
+	EFCT_HW_IO_STATE_WAIT_FREE,
+	EFCT_HW_IO_STATE_WAIT_SEC_HIO,
+};
+
+struct efct_hw;
+
+/**
+ * HW command context.
+ * Stores the state for the asynchronous commands sent to the hardware.
+ */
+struct efct_command_ctx {
+	struct list_head	list_entry;
+	int (*cb)(struct efct_hw *hw, int status, u8 *mqe, void *arg);
+	void			*arg;	/* Argument for callback */
+	u8			*buf;	/* buffer holding command / results */
+	void			*ctx;	/* upper layer context */
+};
+
+struct efct_hw_sgl {
+	uintptr_t		addr;
+	size_t			len;
+};
+
+union efct_hw_io_param_u {
+	struct {
+		u16		ox_id;
+		u16		rx_id;
+		u8		payload[12];
+	} bls;
+	struct {
+		u32		s_id;
+		u16		ox_id;
+		u16		rx_id;
+		u8		payload[12];
+	} bls_sid;
+	struct {
+		u8		r_ctl;
+		u8		type;
+		u8		df_ctl;
+		u8		timeout;
+	} bcast;
+	struct {
+		u16		ox_id;
+		u8		timeout;
+	} els;
+	struct {
+		u32		s_id;
+		u16		ox_id;
+		u8		timeout;
+	} els_sid;
+	struct {
+		u8		r_ctl;
+		u8		type;
+		u8		df_ctl;
+		u8		timeout;
+	} fc_ct;
+	struct {
+		u8		r_ctl;
+		u8		type;
+		u8		df_ctl;
+		u8		timeout;
+		u16		ox_id;
+	} fc_ct_rsp;
+	struct {
+		u32		offset;
+		u16		ox_id;
+		u16		flags;
+		u8		cs_ctl;
+		enum efct_hw_dif_oper dif_oper;
+		enum efct_hw_dif_blk_size blk_size;
+		u8		timeout;
+		u32		app_id;
+	} fcp_tgt;
+	struct {
+		struct efc_dma	*cmnd;
+		struct efc_dma	*rsp;
+		enum efct_hw_dif_oper dif_oper;
+		enum efct_hw_dif_blk_size blk_size;
+		u32		cmnd_size;
+		u16		flags;
+		u8		timeout;
+		u32		first_burst;
+	} fcp_ini;
+};
+
+/* WQ steering mode */
+enum efct_hw_wq_steering {
+	EFCT_HW_WQ_STEERING_CLASS,
+	EFCT_HW_WQ_STEERING_REQUEST,
+	EFCT_HW_WQ_STEERING_CPU,
+};
+
+/* HW wqe object */
+struct efct_hw_wqe {
+	struct list_head	list_entry;
+	bool			abort_wqe_submit_needed;
+	bool			send_abts;
+	u32			id;
+	u32			abort_reqtag;
+	u8			*wqebuf;
+};
+
+/**
+ * HW IO object.
+ *
+ * Stores the per-IO information necessary
+ * for both the lower (SLI) and upper
+ * layers (efct).
+ */
+struct efct_hw_io {
+	/* Owned by HW */
+
+	/* reference counter and callback function */
+	struct kref		ref;
+	void (*release)(struct kref *arg);
+	/* used for busy, wait_free, free lists */
+	struct list_head	list_entry;
+	/* used for timed_wqe list */
+	struct list_head	wqe_link;
+	/* used for io posted dnrx list */
+	struct list_head	dnrx_link;
+	/* state of IO: free, busy, wait_free */
+	enum efct_hw_io_state	state;
+	/* Work queue object, with link for pending */
+	struct efct_hw_wqe	wqe;
+	/* pointer back to hardware context */
+	struct efct_hw		*hw;
+	struct efc_remote_node	*rnode;
+	struct efc_dma		xfer_rdy;
+	u16	type;
+	/* WQ assigned to the exchange */
+	struct hw_wq		*wq;
+	/* Exchange is active in FW */
+	bool			xbusy;
+	/* Function called on IO completion */
+	int
+	(*done)(struct efct_hw_io *hio,
+		struct efc_remote_node *rnode,
+			u32 len, int status,
+			u32 ext, void *ul_arg);
+	/* argument passed to "IO done" callback */
+	void			*arg;
+	/* Function called on abort completion */
+	int
+	(*abort_done)(struct efct_hw_io *hio,
+		      struct efc_remote_node *rnode,
+			u32 len, int status,
+			u32 ext, void *ul_arg);
+	/* argument passed to "abort done" callback */
+	void			*abort_arg;
+	/* needed for bug O127585: length of IO */
+	size_t			length;
+	/* timeout value for target WQEs */
+	u8			tgt_wqe_timeout;
+	/* timestamp when current WQE was submitted */
+	u64			submit_ticks;
+
+	/* if TRUE, latched status shld be returned */
+	bool			status_saved;
+	/* if TRUE, abort is in progress */
+	bool			abort_in_progress;
+	u32			saved_status;
+	u32			saved_len;
+	u32			saved_ext;
+
+	/* EQ that this HIO came up on */
+	struct hw_eq		*eq;
+	/* WQ steering mode request */
+	enum efct_hw_wq_steering wq_steering;
+	/* WQ class if steering mode is Class */
+	u8			wq_class;
+
+	/* request tag for this HW IO */
+	u16			reqtag;
+	/* request tag for an abort of this HW IO
+	 * (note: this is a 32 bit value
+	 * to allow us to use UINT32_MAX as an uninitialized value)
+	 */
+	u32			abort_reqtag;
+	u32			indicator;	/* XRI */
+	struct efc_dma		def_sgl;	/* default SGL*/
+	/* Count of SGEs in default SGL */
+	u32			def_sgl_count;
+	/* pointer to current active SGL */
+	struct efc_dma		*sgl;
+	u32			sgl_count;	/* count of SGEs in io->sgl */
+	u32			first_data_sge;	/* index of first data SGE */
+	struct efc_dma		*ovfl_sgl;	/* overflow SGL */
+	u32			ovfl_sgl_count;
+	 /* pointer to overflow segment len */
+	struct sli4_lsp_sge	*ovfl_lsp;
+	u32			n_sge;		/* number of active SGEs */
+	u32			sge_offset;
+
+	/* where upper layer can store ref to its IO */
+	void			*ul_io;
+};
+
+
+/* Typedef for HW "done" callback */
+typedef int (*efct_hw_done_t)(struct efct_hw_io *, struct efc_remote_node *,
+			      u32 len, int status, u32 ext, void *ul_arg);
+
+enum efct_hw_port {
+	EFCT_HW_PORT_INIT,
+	EFCT_HW_PORT_SHUTDOWN,
+};
+
+/* Node group rpi reference */
+struct efct_hw_rpi_ref {
+	atomic_t rpi_count;
+	atomic_t rpi_attached;
+};
+
+enum efct_hw_link_stat {
+	EFCT_HW_LINK_STAT_LINK_FAILURE_COUNT,
+	EFCT_HW_LINK_STAT_LOSS_OF_SYNC_COUNT,
+	EFCT_HW_LINK_STAT_LOSS_OF_SIGNAL_COUNT,
+	EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_COUNT,
+	EFCT_HW_LINK_STAT_INVALID_XMIT_WORD_COUNT,
+	EFCT_HW_LINK_STAT_CRC_COUNT,
+	EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_TIMEOUT_COUNT,
+	EFCT_HW_LINK_STAT_ELASTIC_BUFFER_OVERRUN_COUNT,
+	EFCT_HW_LINK_STAT_ARB_TIMEOUT_COUNT,
+	EFCT_HW_LINK_STAT_ADVERTISED_RCV_B2B_CREDIT,
+	EFCT_HW_LINK_STAT_CURR_RCV_B2B_CREDIT,
+	EFCT_HW_LINK_STAT_ADVERTISED_XMIT_B2B_CREDIT,
+	EFCT_HW_LINK_STAT_CURR_XMIT_B2B_CREDIT,
+	EFCT_HW_LINK_STAT_RCV_EOFA_COUNT,
+	EFCT_HW_LINK_STAT_RCV_EOFDTI_COUNT,
+	EFCT_HW_LINK_STAT_RCV_EOFNI_COUNT,
+	EFCT_HW_LINK_STAT_RCV_SOFF_COUNT,
+	EFCT_HW_LINK_STAT_RCV_DROPPED_NO_AER_COUNT,
+	EFCT_HW_LINK_STAT_RCV_DROPPED_NO_RPI_COUNT,
+	EFCT_HW_LINK_STAT_RCV_DROPPED_NO_XRI_COUNT,
+	EFCT_HW_LINK_STAT_MAX,
+};
+
+enum efct_hw_host_stat {
+	EFCT_HW_HOST_STAT_TX_KBYTE_COUNT,
+	EFCT_HW_HOST_STAT_RX_KBYTE_COUNT,
+	EFCT_HW_HOST_STAT_TX_FRAME_COUNT,
+	EFCT_HW_HOST_STAT_RX_FRAME_COUNT,
+	EFCT_HW_HOST_STAT_TX_SEQ_COUNT,
+	EFCT_HW_HOST_STAT_RX_SEQ_COUNT,
+	EFCT_HW_HOST_STAT_TOTAL_EXCH_ORIG,
+	EFCT_HW_HOST_STAT_TOTAL_EXCH_RESP,
+	EFCT_HW_HOSY_STAT_RX_P_BSY_COUNT,
+	EFCT_HW_HOST_STAT_RX_F_BSY_COUNT,
+	EFCT_HW_HOST_STAT_DROP_FRM_DUE_TO_NO_RQ_BUF_COUNT,
+	EFCT_HW_HOST_STAT_EMPTY_RQ_TIMEOUT_COUNT,
+	EFCT_HW_HOST_STAT_DROP_FRM_DUE_TO_NO_XRI_COUNT,
+	EFCT_HW_HOST_STAT_EMPTY_XRI_POOL_COUNT,
+	EFCT_HW_HOST_STAT_MAX,
+};
+
+enum efct_hw_state {
+	EFCT_HW_STATE_UNINITIALIZED,
+	EFCT_HW_STATE_QUEUES_ALLOCATED,
+	EFCT_HW_STATE_ACTIVE,
+	EFCT_HW_STATE_RESET_IN_PROGRESS,
+	EFCT_HW_STATE_TEARDOWN_IN_PROGRESS,
+};
+
+struct efct_hw_link_stat_counts {
+	u8		overflow;
+	u32		counter;
+};
+
+struct efct_hw_host_stat_counts {
+	u32		counter;
+};
+
+#include "efct_hw_queues.h"
+
+/* Structure used for the hash lookup of queue IDs */
+struct efct_queue_hash {
+	bool		in_use;
+	u16		id;
+	u16		index;
+};
+
+/* WQ callback object */
+struct hw_wq_callback {
+	u16		instance_index;	/* use for request tag */
+	void (*callback)(void *arg, u8 *cqe, int status);
+	void		*arg;
+};
+
+struct efct_hw_config {
+	u32		n_eq;
+	u32		n_cq;
+	u32		n_mq;
+	u32		n_rq;
+	u32		n_wq;
+	u32		n_io;
+	u32		n_sgl;
+	u32		speed;
+	u32		topology;
+	/* size of the buffers for first burst */
+	u32		rq_default_buffer_size;
+	u8		esoc;
+	/* The seed for the DIF CRC calculation */
+	u16		dif_seed;
+	u8		dif_mode;
+	/* Enable driver target wqe timeouts */
+	u8		emulate_tgt_wqe_timeout;
+	bool		bounce;
+	/* Queue topology string */
+	const char	*queue_topology;
+	/* MRQ RQ selection policy */
+	u8		rq_selection_policy;
+	/* RQ quanta if rq_selection_policy == 2 */
+	u8		rr_quanta;
+	u32		filter_def[SLI4_CMD_REG_FCFI_NUM_RQ_CFG];
+};
+
+struct efct_hw {
+	struct efct		*os;
+	struct sli4		sli;
+	u16			ulp_start;
+	u16			ulp_max;
+	u32			dump_size;
+	enum efct_hw_state	state;
+	bool			hw_setup_called;
+	u8			sliport_healthcheck;
+	u16			watchdog_timeout;
+
+	/* HW configuration, subject to efct_hw_set()  */
+	struct efct_hw_config	config;
+
+	/* calculated queue sizes for each type */
+	u32			num_qentries[SLI_QTYPE_MAX];
+
+	/* Storage for SLI queue objects */
+	struct sli4_queue	wq[EFCT_HW_MAX_NUM_WQ];
+	struct sli4_queue	rq[EFCT_HW_MAX_NUM_RQ];
+	u16			hw_rq_lookup[EFCT_HW_MAX_NUM_RQ];
+	struct sli4_queue	mq[EFCT_HW_MAX_NUM_MQ];
+	struct sli4_queue	cq[EFCT_HW_MAX_NUM_CQ];
+	struct sli4_queue	eq[EFCT_HW_MAX_NUM_EQ];
+
+	/* HW queue */
+	u32			eq_count;
+	u32			cq_count;
+	u32			mq_count;
+	u32			wq_count;
+	u32			rq_count;
+	struct list_head	eq_list;
+
+	struct efct_queue_hash	cq_hash[EFCT_HW_Q_HASH_SIZE];
+	struct efct_queue_hash	rq_hash[EFCT_HW_Q_HASH_SIZE];
+	struct efct_queue_hash	wq_hash[EFCT_HW_Q_HASH_SIZE];
+
+	/* Storage for HW queue objects */
+	struct hw_wq		*hw_wq[EFCT_HW_MAX_NUM_WQ];
+	struct hw_rq		*hw_rq[EFCT_HW_MAX_NUM_RQ];
+	struct hw_mq		*hw_mq[EFCT_HW_MAX_NUM_MQ];
+	struct hw_cq		*hw_cq[EFCT_HW_MAX_NUM_CQ];
+	struct hw_eq		*hw_eq[EFCT_HW_MAX_NUM_EQ];
+	/* count of hw_rq[] entries */
+	u32			hw_rq_count;
+	/* count of multirq RQs */
+	u32			hw_mrq_count;
+
+	 /* pool per class WQs */
+	struct efct_varray	*wq_class_array[EFCT_HW_MAX_WQ_CLASS];
+	/* pool per CPU WQs */
+	struct efct_varray	*wq_cpu_array[EFCT_HW_MAX_WQ_CPU];
+
+	/* Sequence objects used in incoming frame processing */
+	struct efct_array	*seq_pool;
+
+	/* Maintain an ordered, linked list of outstanding HW commands. */
+	spinlock_t		cmd_lock;
+	struct list_head	cmd_head;
+	struct list_head	cmd_pending;
+	u32			cmd_head_count;
+
+	struct sli4_link_event	link;
+	struct efc_domain	*domain;
+
+	u16			fcf_indicator;
+
+	/* pointer array of IO objects */
+	struct efct_hw_io	**io;
+	/* array of WQE buffs mapped to IO objects */
+	u8			*wqe_buffs;
+
+	/* IO lock to synchronize list access */
+	spinlock_t		io_lock;
+	/* IO lock to synchronize IO aborting */
+	spinlock_t		io_abort_lock;
+	/* List of IO objects in use */
+	struct list_head	io_inuse;
+	/* List of IO objects with a timed target WQE */
+	struct list_head	io_timed_wqe;
+	/* List of IO objects waiting to be freed */
+	struct list_head	io_wait_free;
+	/* List of IO objects available for allocation */
+	struct list_head	io_free;
+
+	struct efc_dma		loop_map;
+
+	struct efc_dma		xfer_rdy;
+
+	struct efc_dma		dump_sges;
+
+	struct efc_dma		rnode_mem;
+
+	struct efct_hw_rpi_ref	*rpi_ref;
+
+	atomic_t		io_alloc_failed_count;
+
+	struct efct_hw_qtop	*qtop;
+
+	/* stat: wq sumbit count */
+	u32			tcmd_wq_submit[EFCT_HW_MAX_NUM_WQ];
+	/* stat: wq complete count */
+	u32			tcmd_wq_complete[EFCT_HW_MAX_NUM_WQ];
+	/* Timer to periodically check for WQE timeouts */
+	struct timer_list	wqe_timer;
+	/* Timer for heartbeat */
+	struct timer_list	watchdog_timer;
+	bool			in_active_wqe_timer;
+	bool			active_wqe_timer_shutdown;
+
+	struct efct_pool	*wq_reqtag_pool;
+	atomic_t		send_frame_seq_id;
+};
+
+enum efct_hw_io_count_type {
+	EFCT_HW_IO_INUSE_COUNT,
+	EFCT_HW_IO_FREE_COUNT,
+	EFCT_HW_IO_WAIT_FREE_COUNT,
+	EFCT_HW_IO_N_TOTAL_IO_COUNT,
+};
+
+/* HW queue data structures */
+struct hw_eq {
+	struct list_head	list_entry;
+	enum sli4_qtype		type;
+	u32			instance;
+	u32			entry_count;
+	u32			entry_size;
+	struct efct_hw		*hw;
+	struct sli4_queue	*queue;
+	struct list_head	cq_list;
+	u32			use_count;
+	struct efct_varray	*wq_array;
+};
+
+struct hw_cq {
+	struct list_head	list_entry;
+	enum sli4_qtype		type;
+	u32			instance;
+	u32			entry_count;
+	u32			entry_size;
+	struct hw_eq		*eq;
+	struct sli4_queue	*queue;
+	struct list_head	q_list;
+	u32			use_count;
+};
+
+struct hw_q {
+	struct list_head	list_entry;
+	enum sli4_qtype		type;
+};
+
+struct hw_mq {
+	struct list_head	list_entry;
+	enum sli4_qtype		type;
+	u32			instance;
+
+	u32			entry_count;
+	u32			entry_size;
+	struct hw_cq		*cq;
+	struct sli4_queue	*queue;
+
+	u32			use_count;
+};
+
+struct hw_wq {
+	struct list_head	list_entry;
+	enum sli4_qtype		type;
+	u32			instance;
+	struct efct_hw		*hw;
+
+	u32			entry_count;
+	u32			entry_size;
+	struct hw_cq		*cq;
+	struct sli4_queue	*queue;
+	u32			class;
+	u8			ulp;
+
+	/* WQ consumed */
+	u32			wqec_set_count;
+	u32			wqec_count;
+	u32			free_count;
+	u32			total_submit_count;
+	struct list_head	pending_list;
+
+	/* HW IO allocated for use with Send Frame */
+	struct efct_hw_io	*send_frame_io;
+
+	/* Stats */
+	u32			use_count;
+	u32			wq_pending_count;
+};
+
+struct hw_rq {
+	struct list_head	list_entry;
+	enum sli4_qtype		type;
+	u32			instance;
+
+	u32			entry_count;
+	u32			use_count;
+	u32			hdr_entry_size;
+	u32			first_burst_entry_size;
+	u32			data_entry_size;
+	u8			ulp;
+	bool			is_mrq;
+	u32			base_mrq_id;
+
+	struct hw_cq		*cq;
+
+	u8			filter_mask;
+	struct sli4_queue	*hdr;
+	struct sli4_queue	*first_burst;
+	struct sli4_queue	*data;
+
+	struct efc_hw_rq_buffer	*hdr_buf;
+	struct efc_hw_rq_buffer	*fb_buf;
+	struct efc_hw_rq_buffer	*payload_buf;
+	/* RQ tracker for this RQ */
+	struct efc_hw_sequence	**rq_tracker;
+};
+
+struct efct_hw_global {
+	const char		*queue_topology_string;
+};
+
+extern struct efct_hw_global	hw_global;
+
+struct efct_hw_send_frame_context {
+	struct efct_hw		*hw;
+	struct hw_wq_callback	*wqcb;
+	struct efct_hw_wqe	wqe;
+	void (*callback)(int status, void *arg);
+	void			*arg;
+
+	/* General purpose elements */
+	struct efc_hw_sequence	*seq;
+	struct efc_dma		payload;
+};
+
+#define EFCT_HW_OBJECT_G5              0xfeaa0001
+#define EFCT_HW_OBJECT_G6              0xfeaa0003
+struct efct_hw_grp_hdr {
+	u32			size;
+	__be32			magic_number;
+	u32			word2;
+	u8			rev_name[128];
+	u8			date[12];
+	u8			revision[32];
+};
+
+#endif /* __EFCT_H__ */
-- 
2.13.7


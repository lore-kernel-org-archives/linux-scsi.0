Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D3CC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE8D7206DA
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:07:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="g3uWBojs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbgHDJHS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 05:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgHDJHS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 05:07:18 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F096C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2020 02:07:18 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id d27so30334406qtg.4
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 02:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jMOkDyv9AE1aayQKNJzy70jGa/fr1XqVUN5ZS5zU3hE=;
        b=g3uWBojsoQqU1GBUmzpS9m6FdAbOyykWI4E88qHKnHYqsjVBvI8BvLPt6DeR2EdUHa
         PTGyl16sea2v9tN4Oi3vE/d+0c5dex82rPd/M8rMXt4AczBW1W7UhEdofsbKki3WgjIQ
         wA2pyzigWHIZpN5qhYjyBRcSNi7oUpMVLkt6k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jMOkDyv9AE1aayQKNJzy70jGa/fr1XqVUN5ZS5zU3hE=;
        b=DqzDEefop5E24Z5Q7J16B9Em0RQ4qR0QbfVoLLnSD+W0M1tyy9LSZd3GaHRwNlQCRd
         Uzl0xs6+dnVCs6JfGWsOhlILPsWNJdSsagDMRU1wLJpu96L3lf9ta5NNKyMdTLD0hykf
         Doa59gS0TyRZi4HgHlhXUXvZYbYbNJOxrWgpbaDe0vwuGSvmoUr+9KOTnmq5iHYVqUr7
         xsf20iogHwPMkAxnhHp3hfY40d5zW2M0oRDSaRtvWXyeVtYbZBwuiddT+Pnw5Omuu4s5
         xSX8SS6ujHQVwdBEuzlPoEFTVgOi0+6F9GMJjeOeMubUHCC3sOKNLqJqAIztDTFn3XlR
         bjOg==
X-Gm-Message-State: AOAM533sCQOjj9d7Gor26z/1GLRl52lbPcqSv7+TAcuccYdT7Im8J4LW
        IrrApBdzgI7naCmokt0YQAJayA==
X-Google-Smtp-Source: ABdhPJyuA7an6R9KLkNp+RWftdarKyn8b9URZndTBB658WcZ773Yi0rdO45qQ+vilrEh76g8/DisFg==
X-Received: by 2002:ac8:2a6a:: with SMTP id l39mr17753356qtl.282.1596532037191;
        Tue, 04 Aug 2020 02:07:17 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 65sm19989407qkn.103.2020.08.04.02.07.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Aug 2020 02:07:16 -0700 (PDT)
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     pbonzini@redhat.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Muneendra <muneendra.kumar@broadcom.com>
Subject: [RFC 04/16] lpfc: vmid: Supplementary data structures for vmid
Date:   Tue,  4 Aug 2020 07:43:04 +0530
Message-Id: <1596507196-27417-5-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

This patch adds additional data structures for supporting the two
versions of vmid implementation. First type uses app header while the
other types uses priority tagging mechanism. These data structures
are used mostly for ELS and CT commands for the two vmid implementation.

Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_disc.h |   1 +
 drivers/scsi/lpfc/lpfc_hw.h   | 124 ++++++++++++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_sli.h  |   8 +++
 3 files changed, 129 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 482e4a888dae..c38313ee17dd 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -113,6 +113,7 @@ struct lpfc_nodelist {
 	uint8_t         nlp_fcp_info;	        /* class info, bits 0-3 */
 #define NLP_FCP_2_DEVICE   0x10			/* FCP-2 device */
 	u8		nlp_nvme_info;	        /* NVME NSLER Support */
+	u8		vmid_support;		/* destination VMID support */
 #define NLP_NVME_NSLER     0x1			/* NVME NSLER device */
 
 	uint16_t        nlp_usg_map;	/* ndlp management usage bitmap */
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index c20034b3101c..c6b252fbea40 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -275,6 +275,7 @@ struct lpfc_sli_ct_request {
 #define  SLI_CT_ACCESS_DENIED             0x10
 #define  SLI_CT_INVALID_PORT_ID           0x11
 #define  SLI_CT_DATABASE_EMPTY            0x12
+#define  SLI_CT_APP_ID_NOT_AVAILABLE      0x40
 
 /*
  * Name Server Command Codes
@@ -400,16 +401,16 @@ struct csp {
 	uint16_t altBbCredit:1;	/* FC Word 1, bit 27 */
 	uint16_t edtovResolution:1;	/* FC Word 1, bit 26 */
 	uint16_t multicast:1;	/* FC Word 1, bit 25 */
-	uint16_t broadcast:1;	/* FC Word 1, bit 24 */
+	u16 app_hdr_support:1;	/* FC Word 1, bit 24 */
 
-	uint16_t huntgroup:1;	/* FC Word 1, bit 23 */
+	uint16_t priority_tagging:1;	/* FC Word 1, bit 23 */
 	uint16_t simplex:1;	/* FC Word 1, bit 22 */
 	uint16_t word1Reserved1:3;	/* FC Word 1, bit 21:19 */
 	uint16_t dhd:1;		/* FC Word 1, bit 18 */
 	uint16_t contIncSeqCnt:1;	/* FC Word 1, bit 17 */
 	uint16_t payloadlength:1;	/* FC Word 1, bit 16 */
 #else	/*  __LITTLE_ENDIAN_BITFIELD */
-	uint16_t broadcast:1;	/* FC Word 1, bit 24 */
+	u16 app_hdr_support:1;	/* FC Word 1, bit 24 */
 	uint16_t multicast:1;	/* FC Word 1, bit 25 */
 	uint16_t edtovResolution:1;	/* FC Word 1, bit 26 */
 	uint16_t altBbCredit:1;	/* FC Word 1, bit 27 */
@@ -423,7 +424,7 @@ struct csp {
 	uint16_t dhd:1;		/* FC Word 1, bit 18 */
 	uint16_t word1Reserved1:3;	/* FC Word 1, bit 21:19 */
 	uint16_t simplex:1;	/* FC Word 1, bit 22 */
-	uint16_t huntgroup:1;	/* FC Word 1, bit 23 */
+	uint16_t priority_tagging:1;	/* FC Word 1, bit 23 */
 #endif
 
 	uint8_t bbRcvSizeMsb;	/* Upper nibble is reserved */
@@ -607,6 +608,8 @@ struct fc_vft_header {
 #define ELS_CMD_LIRR      0x7A000000
 #define ELS_CMD_LCB	  0x81000000
 #define ELS_CMD_FPIN	  0x16000000
+#define ELS_CMD_QFPA      0xB0000000
+#define ELS_CMD_UVEM      0xB1000000
 #else	/*  __LITTLE_ENDIAN_BITFIELD */
 #define ELS_CMD_MASK      0xffff
 #define ELS_RSP_MASK      0xff
@@ -649,6 +652,8 @@ struct fc_vft_header {
 #define ELS_CMD_LIRR      0x7A
 #define ELS_CMD_LCB	  0x81
 #define ELS_CMD_FPIN	  ELS_FPIN
+#define ELS_CMD_QFPA      0xB0
+#define ELS_CMD_UVEM      0xB1
 #endif
 
 /*
@@ -1317,6 +1322,117 @@ struct fc_rdp_res_frame {
 };
 
 
+/* UVEM */
+
+#define LPFC_UVEM_SIZE 60
+#define LPFC_UVEM_VEM_ID_DESC_SIZE 16
+#define LPFC_UVEM_VE_MAP_DESC_SIZE 20
+
+#define VEM_ID_DESC_TAG  0x0001000A
+struct lpfc_vem_id_desc {
+	u32 tag;
+	u32 length;
+	u8 vem_id[16];
+};
+
+#define LPFC_QFPA_SIZE	4
+
+#define INSTANTIATED_VE_DESC_TAG  0x0001000B
+struct instantiated_ve_desc {
+	u32 tag;
+	u32 length;
+	u8 global_vem_id[16];
+	u32 word6;
+#define lpfc_instantiated_local_id_SHIFT   0
+#define lpfc_instantiated_local_id_MASK    0x000000ff
+#define lpfc_instantiated_local_id_WORD    word6
+#define lpfc_instantiated_nport_id_SHIFT   8
+#define lpfc_instantiated_nport_id_MASK    0x00ffffff
+#define lpfc_instantiated_nport_id_WORD    word6
+};
+
+#define DEINSTANTIATED_VE_DESC_TAG  0x0001000C
+struct deinstantiated_ve_desc {
+	u32 tag;
+	u32 length;
+	u8 global_vem_id[16];
+	u32 word6;
+#define lpfc_deinstantiated_nport_id_SHIFT   0
+#define lpfc_deinstantiated_nport_id_MASK    0x000000ff
+#define lpfc_deinstantiated_nport_id_WORD    word6
+#define lpfc_deinstantiated_local_id_SHIFT   24
+#define lpfc_deinstantiated_local_id_MASK    0x00ffffff
+#define lpfc_deinstantiated_local_id_WORD    word6
+};
+
+/* Query Fabric Priority Allocation Response */
+#define LPFC_PRIORITY_RANGE_DESC_SIZE 12
+
+struct priority_range_desc {
+	u32 tag;
+	u32 length;
+	u8 lo_range;
+	u8 hi_range;
+	u8 qos_priority;
+	u8 local_ve_id;
+};
+
+struct fc_qfpa_res {
+	u32 reply_sequence;	/* LS_ACC or LS_RJT */
+	u32 length;	/* FC Word 1    */
+	struct priority_range_desc desc[1];
+};
+
+/* Application Server command code */
+/* VMID               */
+
+#define SLI_CT_APP_SEV_Subtypes     0x20	/* Application Server subtype */
+
+#define SLI_CTAS_GAPPIA_ENT    0x0100	/* Get Application Identifier */
+#define SLI_CTAS_GALLAPPIA     0x0101	/* Get All Application Identifier */
+#define SLI_CTAS_GALLAPPIA_ID  0x0102	/* Get All Application Identifier */
+					/* for Nport */
+#define SLI_CTAS_GAPPIA_IDAPP  0x0103	/* Get Application Identifier */
+					/* for Nport */
+#define SLI_CTAS_RAPP_IDENT    0x0200	/* Register Application Identifier */
+#define SLI_CTAS_DAPP_IDENT    0x0300	/* Deregister Application */
+					/* Identifier */
+#define SLI_CTAS_DALLAPP_ID    0x0301	/* Deregister All Application */
+					/* Identifier */
+
+struct entity_id_object {
+	u8 entity_id_len;
+	u8 entity_id[255];	/* VM UUID */
+};
+
+struct app_id_object {
+	u32 port_id;
+	u32 app_id;
+	struct entity_id_object obj;
+};
+
+struct lpfc_vmid_rapp_ident_list {
+	u32 no_of_objects;
+	struct entity_id_object obj[1];
+};
+
+struct lpfc_vmid_dapp_ident_list {
+	u32 no_of_objects;
+	struct entity_id_object obj[1];
+};
+
+#define GALLAPPIA_ID_LAST  0x80
+struct lpfc_vmid_gallapp_ident_list {
+	u8 control;
+	u8 reserved[3];
+	struct app_id_object app_id;
+};
+
+#define RAPP_IDENT_OFFSET  (offsetof(struct lpfc_sli_ct_request, un) + 4)
+#define DAPP_IDENT_OFFSET  (offsetof(struct lpfc_sli_ct_request, un) + 4)
+#define GALLAPPIA_ID_SIZE  (offsetof(struct lpfc_sli_ct_request, un) + 4)
+#define DALLAPP_ID_SIZE    (offsetof(struct lpfc_sli_ct_request, un) + 4)
+
 /******** FDMI ********/
 
 /* lpfc_sli_ct_request defines the CT_IU preamble for FDMI commands */
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 93d976ea8c5d..6dd45885df4f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -35,6 +35,12 @@ typedef enum _lpfc_ctx_cmd {
 	LPFC_CTX_HOST
 } lpfc_ctx_cmd;
 
+union lpfc_vmid_iocb_tag {
+	u32 app_id;
+	u8 cs_ctl_vmid;
+	struct lpfc_vmid_context *vmid_context;	/* UVEM context information */
+};
+
 struct lpfc_cq_event {
 	struct list_head list;
 	uint16_t hdwq;
@@ -100,6 +106,7 @@ struct lpfc_iocbq {
 #define LPFC_IO_NVME	        0x200000 /* NVME FCP command */
 #define LPFC_IO_NVME_LS		0x400000 /* NVME LS command */
 #define LPFC_IO_NVMET		0x800000 /* NVMET command */
+#define LPFC_IO_VMID            0x1000000 /* VMID tagged IO */
 
 	uint32_t drvrTimeout;	/* driver timeout in seconds */
 	struct lpfc_vport *vport;/* virtual port pointer */
@@ -114,6 +121,7 @@ struct lpfc_iocbq {
 		struct lpfc_node_rrq *rrq;
 	} context_un;
 
+	union lpfc_vmid_iocb_tag vmid_tag;
 	void (*fabric_iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
 			   struct lpfc_iocbq *);
 	void (*wait_iocb_cmpl)(struct lpfc_hba *, struct lpfc_iocbq *,
-- 
2.18.2


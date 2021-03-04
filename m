Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673B5C4332E
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 12:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3816B64F34
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 12:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240575AbhCDM2f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 07:28:35 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.221.30]:40454 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240484AbhCDM2D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 07:28:03 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2021 07:28:02 EST
Received: from localhost.localdomain (unknown [10.157.2.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id 7A95A22587;
        Thu,  4 Mar 2021 04:19:57 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 7A95A22587
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1614860397;
        bh=zxstVFaqC/LputN00cwbT2ogQOK9gy2SfAvRn35SPKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Od7Y5dIyr322EPRVIhbybKmys+eYreOFE8GtJz4EyfYpt8ylWyvDba4VfPVis5tSp
         dqlAQIkswBdkHgZncPMbQV4Dtg35t2Abowd7Ar4CBy/saxMgRRr8lvkxJa5ssP9S0i
         Y1jiCntjjuWO7RVtSHsxWEpsynuVzBG6ceXt5xZw=
From:   Muneendra <muneendra.kumar@broadcom.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Subject: [PATCH v8 05/16] lpfc: vmid: Supplementary data structures for vmid and APIs
Date:   Thu,  4 Mar 2021 10:57:15 +0530
Message-Id: <1614835646-16217-6-git-send-email-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1614835646-16217-1-git-send-email-muneendra.kumar@broadcom.com>
References: <1614835646-16217-1-git-send-email-muneendra.kumar@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>

This patch adds additional data structures for supporting the two
versions of vmid implementation. First type uses app header while
the other types uses priority tagging mechanism. These data
structures are used mostly for ELS andCT commands for the two
vmid implementation.

The API determines if VMID is enabled by the user or not.

Signed-off-by: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v8:
No Change

v7:
No change

v6:
No change

v5:
Merged the patch5 of v4 to this patch
Uniform data type naming scheme

v4:
No change

v3:
No change

v2:
Ported the patch on top of 5.10/scsi-queue
---
 drivers/scsi/lpfc/lpfc.h      |  24 +++++++
 drivers/scsi/lpfc/lpfc_disc.h |   1 +
 drivers/scsi/lpfc/lpfc_hw.h   | 124 ++++++++++++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_sli.h  |   8 +++
 4 files changed, 153 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index dccebe3aae68..d794c3d00f70 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1515,3 +1515,27 @@ static const char *routine(enum enum_name table_key)			\
 	}								\
 	return name;							\
 }
+
+/**
+ * lpfc_is_vmid_enabled - returns if VMID is enabled for either switch types
+ * @phba: Pointer to HBA context object.
+ *
+ * Relationship between the enable, target support and if vmid tag is required
+ * for the particular combination
+ * ---------------------------------------------------
+ * Switch    Enable Flag  Target Support  VMID Needed
+ * ---------------------------------------------------
+ * App Id     0              NA              N
+ * App Id     1               0              N
+ * App Id     1               1              Y
+ * Pr Tag     0              NA              N
+ * Pr Tag     1               0              N
+ * Pr Tag     1               1              Y
+ * Pr Tag     2               *              Y
+ ---------------------------------------------------
+ *
+ **/
+static inline int lpfc_is_vmid_enabled(struct lpfc_hba *phba)
+{
+	return phba->cfg_vmid_app_header || phba->cfg_vmid_priority_tagging;
+}
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 8ce13ef3cac3..1d91609c3533 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -124,6 +124,7 @@ struct lpfc_nodelist {
 	uint8_t         nlp_fcp_info;	        /* class info, bits 0-3 */
 #define NLP_FCP_2_DEVICE   0x10			/* FCP-2 device */
 	u8		nlp_nvme_info;	        /* NVME NSLER Support */
+	uint8_t		vmid_support;		/* destination VMID support */
 #define NLP_NVME_NSLER     0x1			/* NVME NSLER device */
 
 	struct timer_list   nlp_delayfunc;	/* Used for delayed ELS cmds */
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 42682d95af52..4a5a85ed42ec 100644
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
+	uint16_t app_hdr_support:1;	/* FC Word 1, bit 24 */
 
-	uint16_t huntgroup:1;	/* FC Word 1, bit 23 */
+	uint16_t priority_tagging:1;	/* FC Word 1, bit 23 */
 	uint16_t simplex:1;	/* FC Word 1, bit 22 */
 	uint16_t word1Reserved1:3;	/* FC Word 1, bit 21:19 */
 	uint16_t dhd:1;		/* FC Word 1, bit 18 */
 	uint16_t contIncSeqCnt:1;	/* FC Word 1, bit 17 */
 	uint16_t payloadlength:1;	/* FC Word 1, bit 16 */
 #else	/*  __LITTLE_ENDIAN_BITFIELD */
-	uint16_t broadcast:1;	/* FC Word 1, bit 24 */
+	uint16_t app_hdr_support:1;	/* FC Word 1, bit 24 */
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
+	uint32_t tag;
+	uint32_t length;
+	uint8_t vem_id[16];
+};
+
+#define LPFC_QFPA_SIZE	4
+
+#define INSTANTIATED_VE_DESC_TAG  0x0001000B
+struct instantiated_ve_desc {
+	uint32_t tag;
+	uint32_t length;
+	uint8_t global_vem_id[16];
+	uint32_t word6;
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
+	uint32_t tag;
+	uint32_t length;
+	uint8_t global_vem_id[16];
+	uint32_t word6;
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
+	uint32_t tag;
+	uint32_t length;
+	uint8_t lo_range;
+	uint8_t hi_range;
+	uint8_t qos_priority;
+	uint8_t local_ve_id;
+};
+
+struct fc_qfpa_res {
+	uint32_t reply_sequence;	/* LS_ACC or LS_RJT */
+	uint32_t length;	/* FC Word 1    */
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
+	uint8_t entity_id_len;
+	uint8_t entity_id[255];	/* VM UUID */
+};
+
+struct app_id_object {
+	uint32_t port_id;
+	uint32_t app_id;
+	struct entity_id_object obj;
+};
+
+struct lpfc_vmid_rapp_ident_list {
+	uint32_t no_of_objects;
+	struct entity_id_object obj[1];
+};
+
+struct lpfc_vmid_dapp_ident_list {
+	uint32_t no_of_objects;
+	struct entity_id_object obj[1];
+};
+
+#define GALLAPPIA_ID_LAST  0x80
+struct lpfc_vmid_gallapp_ident_list {
+	uint8_t control;
+	uint8_t reserved[3];
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
index 4f6936014ff5..ff5a2a492405 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -35,6 +35,12 @@ typedef enum _lpfc_ctx_cmd {
 	LPFC_CTX_HOST
 } lpfc_ctx_cmd;
 
+union lpfc_vmid_iocb_tag {
+	uint32_t app_id;
+	uint8_t cs_ctl_vmid;
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
2.26.2


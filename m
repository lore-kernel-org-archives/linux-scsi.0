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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A71C6C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 00:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79DB723123
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 00:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbhAGAvY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 19:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbhAGAvX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 19:51:23 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDC9C0612F6
        for <linux-scsi@vger.kernel.org>; Wed,  6 Jan 2021 16:50:39 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id x12so2464893plr.10
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jan 2021 16:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kVSA73VQSiDKXrDRJh8fYEYPFPd6AbTKAwuhRwhNv9E=;
        b=smvbPbcERLD7va3FbXRYlqLNFu/dxsubkGv+L9/dzeFsMDnNgoSOqMf32KH82hB+NE
         t0GufZzaS7OR4uIdEiHn/1OUOS17fmTDqhAXVtbAFuGVXgvQ6ClrftWErtKuPDEBIAqQ
         BfgFCVQFSd8BasFSpYEJCrjLzWj3cG/b2mRK0eqPMCoAdkAT5fvcCsajAZOVwk8UPW7v
         B0AkTSbyheoU6krpt72Xi6ry18XahY3AKYi8Za77mRPtHK8x5GIXs9u/rsr4Y8TZ7aOw
         2fbkSU83TdvTBc6DBBJlQVtI3zZrWLH/+7r2UsB7sN7DiyMxyBeC7epQk2c8vNOk94uI
         Ut0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kVSA73VQSiDKXrDRJh8fYEYPFPd6AbTKAwuhRwhNv9E=;
        b=Mi+95ABLJOyZsX6f9+Aoxhhun3R3LBaZYe0fnpX6iSD9hSn1hDErWS5EkwXCW2lG2R
         5X3prC/6Ftf0hLsCznvtoPLHNFppKFZT3j6NLIMPZvuK6j29RvEFzM7t0ayhHudQf/V8
         78Z7bIvkBXbTJmk/xlvWfqrr11WWnLgbiuFxBOJjqFOEsdyQrnKtHIwjmA5PzQiwXDEy
         MjlkipiLdlJdnq6ubTSrpyAWU4xtuWepQfcHFUM1LtvEHZ6W5gDu8JymSRELZDdQrfbP
         VuZrgjIDc5BSCjTQxskDZ5hZoVXE7f3hsmZXow8DxEPCK1Wp6Y7u8eBDFvmjQR7NogUN
         Zwww==
X-Gm-Message-State: AOAM5327GvoyiQtg6T3PWKVJOsv/1/SamWP/P68Ocxh2psriLvB0C4aq
        n+Ca6jvuGX1mLtd83FdOoV9q4DMEpi4WzQ==
X-Google-Smtp-Source: ABdhPJx/b+5ltdDjqaAyOQp0Pxm+GYrBwJSfzq5LX/fi3NPlTiC3pVTa/Nr+NC8IwHfMtRcmeA+ZKg==
X-Received: by 2002:a17:902:bc47:b029:da:cbd5:dbdf with SMTP id t7-20020a170902bc47b02900dacbd5dbdfmr6753462plz.77.1609980638298;
        Wed, 06 Jan 2021 16:50:38 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w27sm3600634pfq.104.2021.01.06.16.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 16:50:37 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v6 04/31] elx: libefc_sli: queue create/destroy/parse routines
Date:   Wed,  6 Jan 2021 16:50:03 -0800
Message-Id: <20210107005030.2929-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107005030.2929-1-jsmart2021@gmail.com>
References: <20210107005030.2929-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the libefc_sli SLI-4 library population.

This patch adds service routines to create mailbox commands
and adds APIs to create/destroy/parse SLI-4 EQ, CQ, RQ and MQ queues.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v6:
 Code reorg for better indentation and reduced else's
 Refactor to use structure elements directly and avoid local vars
v5:
 Remove efc_log_test.
---
 drivers/scsi/elx/include/efc_common.h |   16 +
 drivers/scsi/elx/libefc_sli/sli4.c    | 1347 +++++++++++++++++++++++++
 drivers/scsi/elx/libefc_sli/sli4.h    |    9 +
 3 files changed, 1372 insertions(+)

diff --git a/drivers/scsi/elx/include/efc_common.h b/drivers/scsi/elx/include/efc_common.h
index e0dbecbc4518..b6849d168bff 100644
--- a/drivers/scsi/elx/include/efc_common.h
+++ b/drivers/scsi/elx/include/efc_common.h
@@ -22,4 +22,20 @@ struct efc_dma {
 	struct pci_dev	*pdev;
 };
 
+#define efc_log_crit(efc, fmt, args...) \
+		dev_crit(&((efc)->pci)->dev, fmt, ##args)
+
+#define efc_log_err(efc, fmt, args...) \
+		dev_err(&((efc)->pci)->dev, fmt, ##args)
+
+#define efc_log_warn(efc, fmt, args...) \
+		dev_warn(&((efc)->pci)->dev, fmt, ##args)
+
+#define efc_log_info(efc, fmt, args...) \
+		dev_info(&((efc)->pci)->dev, fmt, ##args)
+
+#define efc_log_debug(efc, fmt, args...) \
+		dev_dbg(&((efc)->pci)->dev, fmt, ##args)
+
+
 #endif /* __EFC_COMMON_H__ */
diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
index 5396e14e7bf8..47e6200a20e6 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.c
+++ b/drivers/scsi/elx/libefc_sli/sli4.c
@@ -19,3 +19,1350 @@ static struct sli4_asic_entry_t sli4_asic_table[] = {
 	{ SLI4_ASIC_REV_A3, SLI4_ASIC_GEN_6},
 	{ SLI4_ASIC_REV_A1, SLI4_ASIC_GEN_7},
 };
+
+/* Convert queue type enum (SLI_QTYPE_*) into a string */
+static char *SLI4_QNAME[] = {
+	"Event Queue",
+	"Completion Queue",
+	"Mailbox Queue",
+	"Work Queue",
+	"Receive Queue",
+	"Undefined"
+};
+
+/**
+ * sli_config_cmd_init() - Write a SLI_CONFIG command to the provided buffer.
+ *
+ * @sli4: SLI context pointer.
+ * @buf: Destination buffer for the command.
+ * @length: Length in bytes of attached command.
+ * @dma: DMA buffer for non-embedded commands.
+ * Return: Command payload buffer.
+ */
+static void *
+sli_config_cmd_init(struct sli4 *sli4, void *buf, u32 length,
+		    struct efc_dma *dma)
+{
+	struct sli4_cmd_sli_config *config;
+	u32 flags;
+
+	if (length > sizeof(config->payload.embed) && !dma) {
+		efc_log_err(sli4, "Too big for an embedded cmd with len(%d)\n",
+			    length);
+		return NULL;
+	}
+
+	memset(buf, 0, SLI4_BMBX_SIZE);
+
+	config = buf;
+
+	config->hdr.command = SLI4_MBX_CMD_SLI_CONFIG;
+	if (!dma) {
+		flags = SLI4_SLICONF_EMB;
+		config->dw1_flags = cpu_to_le32(flags);
+		config->payload_len = cpu_to_le32(length);
+		return config->payload.embed;
+	}
+
+	flags = SLI4_SLICONF_PMDCMD_VAL_1;
+	flags &= ~SLI4_SLICONF_EMB;
+	config->dw1_flags = cpu_to_le32(flags);
+
+	config->payload.mem.addr.low = cpu_to_le32(lower_32_bits(dma->phys));
+	config->payload.mem.addr.high =	cpu_to_le32(upper_32_bits(dma->phys));
+	config->payload.mem.length =
+				cpu_to_le32(dma->size & SLI4_SLICONF_PMD_LEN);
+	config->payload_len = cpu_to_le32(dma->size);
+	/* save pointer to DMA for BMBX dumping purposes */
+	sli4->bmbx_non_emb_pmd = dma;
+	return dma->virt;
+}
+
+/**
+ * sli_cmd_common_create_cq() - Write a COMMON_CREATE_CQ V2 command.
+ *
+ * @sli4: SLI context pointer.
+ * @buf: Destination buffer for the command.
+ * @qmem: DMA memory for queue.
+ * @eq_id: EQ id assosiated with this cq.
+ * Return: status EFC_FAIL/EFC_SUCCESS.
+ */
+static int
+sli_cmd_common_create_cq(struct sli4 *sli4, void *buf, struct efc_dma *qmem,
+			 u16 eq_id)
+{
+	struct sli4_rqst_cmn_create_cq_v2 *cqv2 = NULL;
+	u32 p;
+	uintptr_t addr;
+	u32 num_pages = 0;
+	size_t cmd_size = 0;
+	u32 page_size = 0;
+	u32 n_cqe = 0;
+	u32 dw5_flags = 0;
+	u16 dw6w1_arm = 0;
+	__le32 len;
+
+	/* First calculate number of pages and the mailbox cmd length */
+	n_cqe = qmem->size / SLI4_CQE_BYTES;
+	switch (n_cqe) {
+	case 256:
+	case 512:
+	case 1024:
+	case 2048:
+		page_size = SZ_4K;
+		break;
+	case 4096:
+		page_size = SZ_8K;
+		break;
+	default:
+		return EFC_FAIL;
+	}
+	num_pages = sli_page_count(qmem->size, page_size);
+
+	cmd_size = SLI4_RQST_CMDSZ(cmn_create_cq_v2)
+		   + SZ_DMAADDR * num_pages;
+
+	cqv2 = sli_config_cmd_init(sli4, buf, cmd_size, NULL);
+	if (!cqv2)
+		return EFC_FAIL;
+
+	len = SLI4_RQST_PYLD_LEN_VAR(cmn_create_cq_v2, SZ_DMAADDR * num_pages);
+	sli_cmd_fill_hdr(&cqv2->hdr, SLI4_CMN_CREATE_CQ, SLI4_SUBSYSTEM_COMMON,
+			 CMD_V2, len);
+	cqv2->page_size = page_size / SLI_PAGE_SIZE;
+
+	/* valid values for number of pages: 1, 2, 4, 8 (sec 4.4.3) */
+	cqv2->num_pages = cpu_to_le16(num_pages);
+	if (!num_pages || num_pages > SLI4_CREATE_CQV2_MAX_PAGES)
+		return EFC_FAIL;
+
+	switch (num_pages) {
+	case 1:
+		dw5_flags |= SLI4_CQ_CNT_VAL(256);
+		break;
+	case 2:
+		dw5_flags |= SLI4_CQ_CNT_VAL(512);
+		break;
+	case 4:
+		dw5_flags |= SLI4_CQ_CNT_VAL(1024);
+		break;
+	case 8:
+		dw5_flags |= SLI4_CQ_CNT_VAL(LARGE);
+		cqv2->cqe_count = cpu_to_le16(n_cqe);
+		break;
+	default:
+		efc_log_err(sli4, "num_pages %d not valid\n", num_pages);
+		return EFC_FAIL;
+	}
+
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+		dw5_flags |= SLI4_CREATE_CQV2_AUTOVALID;
+
+	dw5_flags |= SLI4_CREATE_CQV2_EVT;
+	dw5_flags |= SLI4_CREATE_CQV2_VALID;
+
+	cqv2->dw5_flags = cpu_to_le32(dw5_flags);
+	cqv2->dw6w1_arm = cpu_to_le16(dw6w1_arm);
+	cqv2->eq_id = cpu_to_le16(eq_id);
+
+	for (p = 0, addr = qmem->phys; p < num_pages; p++, addr += page_size) {
+		cqv2->page_phys_addr[p].low = cpu_to_le32(lower_32_bits(addr));
+		cqv2->page_phys_addr[p].high = cpu_to_le32(upper_32_bits(addr));
+	}
+
+	return EFC_SUCCESS;
+}
+
+static int
+sli_cmd_common_create_eq(struct sli4 *sli4, void *buf, struct efc_dma *qmem)
+{
+	struct sli4_rqst_cmn_create_eq *eq;
+	u32 p;
+	uintptr_t addr;
+	u16 num_pages;
+	u32 dw5_flags = 0;
+	u32 dw6_flags = 0, ver;
+
+	eq = sli_config_cmd_init(sli4, buf, SLI4_CFG_PYLD_LENGTH(cmn_create_eq),
+				 NULL);
+	if (!eq)
+		return EFC_FAIL;
+
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+		ver = CMD_V2;
+	else
+		ver = CMD_V0;
+
+	sli_cmd_fill_hdr(&eq->hdr, SLI4_CMN_CREATE_EQ, SLI4_SUBSYSTEM_COMMON,
+			 ver, SLI4_RQST_PYLD_LEN(cmn_create_eq));
+
+	/* valid values for number of pages: 1, 2, 4 (sec 4.4.3) */
+	num_pages = qmem->size / SLI_PAGE_SIZE;
+	eq->num_pages = cpu_to_le16(num_pages);
+
+	switch (num_pages) {
+	case 1:
+		dw5_flags |= SLI4_EQE_SIZE_4;
+		dw6_flags |= SLI4_EQ_CNT_VAL(1024);
+		break;
+	case 2:
+		dw5_flags |= SLI4_EQE_SIZE_4;
+		dw6_flags |= SLI4_EQ_CNT_VAL(2048);
+		break;
+	case 4:
+		dw5_flags |= SLI4_EQE_SIZE_4;
+		dw6_flags |= SLI4_EQ_CNT_VAL(4096);
+		break;
+	default:
+		efc_log_err(sli4, "num_pages %d not valid\n", num_pages);
+		return EFC_FAIL;
+	}
+
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+		dw5_flags |= SLI4_CREATE_EQ_AUTOVALID;
+
+	dw5_flags |= SLI4_CREATE_EQ_VALID;
+	dw6_flags &= (~SLI4_CREATE_EQ_ARM);
+	eq->dw5_flags = cpu_to_le32(dw5_flags);
+	eq->dw6_flags = cpu_to_le32(dw6_flags);
+	eq->dw7_delaymulti = cpu_to_le32(SLI4_CREATE_EQ_DELAYMULTI);
+
+	for (p = 0, addr = qmem->phys; p < num_pages;
+	     p++, addr += SLI_PAGE_SIZE) {
+		eq->page_address[p].low = cpu_to_le32(lower_32_bits(addr));
+		eq->page_address[p].high = cpu_to_le32(upper_32_bits(addr));
+	}
+
+	return EFC_SUCCESS;
+}
+
+static int
+sli_cmd_common_create_mq_ext(struct sli4 *sli4, void *buf, struct efc_dma *qmem,
+			     u16 cq_id)
+{
+	struct sli4_rqst_cmn_create_mq_ext *mq;
+	u32 p;
+	uintptr_t addr;
+	u32 num_pages;
+	u16 dw6w1_flags = 0;
+
+	mq = sli_config_cmd_init(sli4, buf,
+				 SLI4_CFG_PYLD_LENGTH(cmn_create_mq_ext), NULL);
+	if (!mq)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&mq->hdr, SLI4_CMN_CREATE_MQ_EXT,
+			 SLI4_SUBSYSTEM_COMMON, CMD_V0,
+			 SLI4_RQST_PYLD_LEN(cmn_create_mq_ext));
+
+	/* valid values for number of pages: 1, 2, 4, 8 (sec 4.4.12) */
+	num_pages = qmem->size / SLI_PAGE_SIZE;
+	mq->num_pages = cpu_to_le16(num_pages);
+	switch (num_pages) {
+	case 1:
+		dw6w1_flags |= SLI4_MQE_SIZE_16;
+		break;
+	case 2:
+		dw6w1_flags |= SLI4_MQE_SIZE_32;
+		break;
+	case 4:
+		dw6w1_flags |= SLI4_MQE_SIZE_64;
+		break;
+	case 8:
+		dw6w1_flags |= SLI4_MQE_SIZE_128;
+		break;
+	default:
+		efc_log_info(sli4, "num_pages %d not valid\n", num_pages);
+		return EFC_FAIL;
+	}
+
+	mq->async_event_bitmap = cpu_to_le32(SLI4_ASYNC_EVT_FC_ALL);
+
+	if (sli4->params.mq_create_version) {
+		mq->cq_id_v1 = cpu_to_le16(cq_id);
+		mq->hdr.dw3_version = cpu_to_le32(CMD_V1);
+	} else {
+		dw6w1_flags |= (cq_id << SLI4_CREATE_MQEXT_CQID_SHIFT);
+	}
+	mq->dw7_val = cpu_to_le32(SLI4_CREATE_MQEXT_VAL);
+
+	mq->dw6w1_flags = cpu_to_le16(dw6w1_flags);
+	for (p = 0, addr = qmem->phys; p < num_pages;
+	     p++, addr += SLI_PAGE_SIZE) {
+		mq->page_phys_addr[p].low = cpu_to_le32(lower_32_bits(addr));
+		mq->page_phys_addr[p].high = cpu_to_le32(upper_32_bits(addr));
+	}
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_wq_create(struct sli4 *sli4, void *buf, struct efc_dma *qmem, u16 cq_id)
+{
+	struct sli4_rqst_wq_create *wq;
+	u32 p;
+	uintptr_t addr;
+	u32 page_size = 0;
+	u32 n_wqe = 0;
+	u16 num_pages;
+
+	wq = sli_config_cmd_init(sli4, buf, SLI4_CFG_PYLD_LENGTH(wq_create),
+				 NULL);
+	if (!wq)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&wq->hdr, SLI4_OPC_WQ_CREATE, SLI4_SUBSYSTEM_FC,
+			 CMD_V1, SLI4_RQST_PYLD_LEN(wq_create));
+	n_wqe = qmem->size / sli4->wqe_size;
+
+	switch (qmem->size) {
+	case 4096:
+	case 8192:
+	case 16384:
+	case 32768:
+		page_size = SZ_4K;
+		break;
+	case 65536:
+		page_size = SZ_8K;
+		break;
+	case 131072:
+		page_size = SZ_16K;
+		break;
+	case 262144:
+		page_size = SZ_32K;
+		break;
+	case 524288:
+		page_size = SZ_64K;
+		break;
+	default:
+		return EFC_FAIL;
+	}
+
+	/* valid values for number of pages(num_pages): 1-8 */
+	num_pages = sli_page_count(qmem->size, page_size);
+	wq->num_pages = cpu_to_le16(num_pages);
+	if (!num_pages || num_pages > SLI4_WQ_CREATE_MAX_PAGES)
+		return EFC_FAIL;
+
+	wq->cq_id = cpu_to_le16(cq_id);
+
+	wq->page_size = page_size / SLI_PAGE_SIZE;
+
+	if (sli4->wqe_size == SLI4_WQE_EXT_BYTES)
+		wq->wqe_size_byte |= SLI4_WQE_EXT_SIZE;
+	else
+		wq->wqe_size_byte |= SLI4_WQE_SIZE;
+
+	wq->wqe_count = cpu_to_le16(n_wqe);
+
+	for (p = 0, addr = qmem->phys; p < num_pages; p++, addr += page_size) {
+		wq->page_phys_addr[p].low  = cpu_to_le32(lower_32_bits(addr));
+		wq->page_phys_addr[p].high = cpu_to_le32(upper_32_bits(addr));
+	}
+
+	return EFC_SUCCESS;
+}
+
+static int
+sli_cmd_rq_create_v1(struct sli4 *sli4, void *buf, struct efc_dma *qmem,
+		     u16 cq_id, u16 buffer_size)
+{
+	struct sli4_rqst_rq_create_v1 *rq;
+	u32 p;
+	uintptr_t addr;
+	u32 num_pages;
+
+	rq = sli_config_cmd_init(sli4, buf, SLI4_CFG_PYLD_LENGTH(rq_create_v1),
+				 NULL);
+	if (!rq)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&rq->hdr, SLI4_OPC_RQ_CREATE, SLI4_SUBSYSTEM_FC,
+			 CMD_V1, SLI4_RQST_PYLD_LEN(rq_create_v1));
+	/* Disable "no buffer warnings" to avoid Lancer bug */
+	rq->dim_dfd_dnb |= SLI4_RQ_CREATE_V1_DNB;
+
+	/* valid values for number of pages: 1-8 (sec 4.5.6) */
+	num_pages = sli_page_count(qmem->size, SLI_PAGE_SIZE);
+	rq->num_pages = cpu_to_le16(num_pages);
+	if (!num_pages ||
+	    num_pages > SLI4_RQ_CREATE_V1_MAX_PAGES) {
+		efc_log_info(sli4, "num_pages %d not valid, max %d\n",
+			num_pages, SLI4_RQ_CREATE_V1_MAX_PAGES);
+		return EFC_FAIL;
+	}
+
+	/*
+	 * RQE count is the total number of entries (note not lg2(# entries))
+	 */
+	rq->rqe_count = cpu_to_le16(qmem->size / SLI4_RQE_SIZE);
+
+	rq->rqe_size_byte |= SLI4_RQE_SIZE_8;
+
+	rq->page_size = SLI4_RQ_PAGE_SIZE_4096;
+
+	if (buffer_size < sli4->rq_min_buf_size ||
+	    buffer_size > sli4->rq_max_buf_size) {
+		efc_log_err(sli4, "buffer_size %d out of range (%d-%d)\n",
+		       buffer_size,
+				sli4->rq_min_buf_size,
+				sli4->rq_max_buf_size);
+		return EFC_FAIL;
+	}
+	rq->buffer_size = cpu_to_le32(buffer_size);
+
+	rq->cq_id = cpu_to_le16(cq_id);
+
+	for (p = 0, addr = qmem->phys;
+			p < num_pages;
+			p++, addr += SLI_PAGE_SIZE) {
+		rq->page_phys_addr[p].low  = cpu_to_le32(lower_32_bits(addr));
+		rq->page_phys_addr[p].high = cpu_to_le32(upper_32_bits(addr));
+	}
+
+	return EFC_SUCCESS;
+}
+
+static int
+sli_cmd_rq_create_v2(struct sli4 *sli4, u32 num_rqs,
+		     struct sli4_queue *qs[], u32 base_cq_id,
+		     u32 header_buffer_size,
+		     u32 payload_buffer_size, struct efc_dma *dma)
+{
+	struct sli4_rqst_rq_create_v2 *req = NULL;
+	u32 i, p, offset = 0;
+	u32 payload_size, page_count;
+	uintptr_t addr;
+	u32 num_pages;
+	__le32 len;
+
+	page_count =  sli_page_count(qs[0]->dma.size, SLI_PAGE_SIZE) * num_rqs;
+
+	/* Payload length must accommodate both request and response */
+	payload_size = max(SLI4_RQST_CMDSZ(rq_create_v2) +
+			   SZ_DMAADDR * page_count,
+			   sizeof(struct sli4_rsp_cmn_create_queue_set));
+
+	dma->size = payload_size;
+	dma->virt = dma_alloc_coherent(&sli4->pci->dev, dma->size,
+				      &dma->phys, GFP_DMA);
+	if (!dma->virt)
+		return EFC_FAIL;
+
+	memset(dma->virt, 0, payload_size);
+
+	req = sli_config_cmd_init(sli4, sli4->bmbx.virt, payload_size, dma);
+	if (!req)
+		return EFC_FAIL;
+
+	len =  SLI4_RQST_PYLD_LEN_VAR(rq_create_v2, SZ_DMAADDR * page_count);
+	sli_cmd_fill_hdr(&req->hdr, SLI4_OPC_RQ_CREATE, SLI4_SUBSYSTEM_FC,
+			 CMD_V2, len);
+	/* Fill Payload fields */
+	req->dim_dfd_dnb |= SLI4_RQCREATEV2_DNB;
+	num_pages = sli_page_count(qs[0]->dma.size, SLI_PAGE_SIZE);
+	req->num_pages = cpu_to_le16(num_pages);
+	req->rqe_count = cpu_to_le16(qs[0]->dma.size / SLI4_RQE_SIZE);
+	req->rqe_size_byte |= SLI4_RQE_SIZE_8;
+	req->page_size = SLI4_RQ_PAGE_SIZE_4096;
+	req->rq_count = num_rqs;
+	req->base_cq_id = cpu_to_le16(base_cq_id);
+	req->hdr_buffer_size = cpu_to_le16(header_buffer_size);
+	req->payload_buffer_size = cpu_to_le16(payload_buffer_size);
+
+	for (i = 0; i < num_rqs; i++) {
+		for (p = 0, addr = qs[i]->dma.phys; p < num_pages;
+		     p++, addr += SLI_PAGE_SIZE) {
+			req->page_phys_addr[offset].low =
+					cpu_to_le32(lower_32_bits(addr));
+			req->page_phys_addr[offset].high =
+					cpu_to_le32(upper_32_bits(addr));
+			offset++;
+		}
+	}
+
+	return EFC_SUCCESS;
+}
+
+static void
+__sli_queue_destroy(struct sli4 *sli4, struct sli4_queue *q)
+{
+	if (!q->dma.size)
+		return;
+
+	dma_free_coherent(&sli4->pci->dev, q->dma.size,
+			  q->dma.virt, q->dma.phys);
+	memset(&q->dma, 0, sizeof(struct efc_dma));
+}
+
+int
+__sli_queue_init(struct sli4 *sli4, struct sli4_queue *q, u32 qtype,
+		 size_t size, u32 n_entries, u32 align)
+{
+	if (q->dma.virt) {
+		efc_log_err(sli4, "%s failed\n", __func__);
+		return EFC_FAIL;
+	}
+
+	memset(q, 0, sizeof(struct sli4_queue));
+
+	q->dma.size = size * n_entries;
+	q->dma.virt = dma_alloc_coherent(&sli4->pci->dev, q->dma.size,
+					 &q->dma.phys, GFP_DMA);
+	if (!q->dma.virt) {
+		memset(&q->dma, 0, sizeof(struct efc_dma));
+		efc_log_err(sli4, "%s allocation failed\n", SLI4_QNAME[qtype]);
+		return EFC_FAIL;
+	}
+
+	memset(q->dma.virt, 0, size * n_entries);
+
+	spin_lock_init(&q->lock);
+
+	q->type = qtype;
+	q->size = size;
+	q->length = n_entries;
+
+	if (q->type == SLI4_QTYPE_EQ || q->type == SLI4_QTYPE_CQ) {
+		/* For prism, phase will be flipped after
+		 * a sweep through eq and cq
+		 */
+		q->phase = 1;
+	}
+
+	/* Limit to hwf the queue size per interrupt */
+	q->proc_limit = n_entries / 2;
+
+	if (q->type == SLI4_QTYPE_EQ)
+		q->posted_limit = q->length / 2;
+	else
+		q->posted_limit = 64;
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_fc_rq_alloc(struct sli4 *sli4, struct sli4_queue *q,
+		u32 n_entries, u32 buffer_size,
+		struct sli4_queue *cq, bool is_hdr)
+{
+	if (__sli_queue_init(sli4, q, SLI4_QTYPE_RQ, SLI4_RQE_SIZE,
+			     n_entries, SLI_PAGE_SIZE))
+		return EFC_FAIL;
+
+	if (sli_cmd_rq_create_v1(sli4, sli4->bmbx.virt, &q->dma, cq->id,
+				 buffer_size))
+		goto error;
+
+	if (__sli_create_queue(sli4, q))
+		goto error;
+
+	if (is_hdr && q->id & 1) {
+		efc_log_info(sli4, "bad header RQ_ID %d\n", q->id);
+		goto error;
+	} else if (!is_hdr  && (q->id & 1) == 0) {
+		efc_log_info(sli4, "bad data RQ_ID %d\n", q->id);
+		goto error;
+	}
+
+	if (is_hdr)
+		q->u.flag |= SLI4_QUEUE_FLAG_HDR;
+	else
+		q->u.flag &= ~SLI4_QUEUE_FLAG_HDR;
+
+	return EFC_SUCCESS;
+
+error:
+	__sli_queue_destroy(sli4, q);
+	return EFC_FAIL;
+}
+
+int
+sli_fc_rq_set_alloc(struct sli4 *sli4, u32 num_rq_pairs,
+		    struct sli4_queue *qs[], u32 base_cq_id,
+		    u32 n_entries, u32 header_buffer_size,
+		    u32 payload_buffer_size)
+{
+	u32 i;
+	struct efc_dma dma = {0};
+	struct sli4_rsp_cmn_create_queue_set *rsp = NULL;
+	void __iomem *db_regaddr = NULL;
+	u32 num_rqs = num_rq_pairs * 2;
+
+	for (i = 0; i < num_rqs; i++) {
+		if (__sli_queue_init(sli4, qs[i], SLI4_QTYPE_RQ,
+				     SLI4_RQE_SIZE, n_entries,
+				     SLI_PAGE_SIZE)) {
+			goto error;
+		}
+	}
+
+	if (sli_cmd_rq_create_v2(sli4, num_rqs, qs, base_cq_id,
+			       header_buffer_size, payload_buffer_size, &dma)) {
+		goto error;
+	}
+
+	if (sli_bmbx_command(sli4)) {
+		efc_log_err(sli4, "bootstrap mailbox write failed RQSet\n");
+		goto error;
+	}
+
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+		db_regaddr = sli4->reg[1] + SLI4_IF6_RQ_DB_REG;
+	else
+		db_regaddr = sli4->reg[0] + SLI4_RQ_DB_REG;
+
+	rsp = dma.virt;
+	if (rsp->hdr.status) {
+		efc_log_err(sli4, "bad create RQSet status=%#x addl=%#x\n",
+		       rsp->hdr.status, rsp->hdr.additional_status);
+		goto error;
+	}
+
+	for (i = 0; i < num_rqs; i++) {
+		qs[i]->id = i + le16_to_cpu(rsp->q_id);
+		if ((qs[i]->id & 1) == 0)
+			qs[i]->u.flag |= SLI4_QUEUE_FLAG_HDR;
+		else
+			qs[i]->u.flag &= ~SLI4_QUEUE_FLAG_HDR;
+
+		qs[i]->db_regaddr = db_regaddr;
+	}
+
+	dma_free_coherent(&sli4->pci->dev, dma.size, dma.virt, dma.phys);
+
+	return EFC_SUCCESS;
+
+error:
+	for (i = 0; i < num_rqs; i++)
+		__sli_queue_destroy(sli4, qs[i]);
+
+	if (dma.virt)
+		dma_free_coherent(&sli4->pci->dev, dma.size, dma.virt,
+				  dma.phys);
+
+	return EFC_FAIL;
+}
+
+static int
+sli_res_sli_config(struct sli4 *sli4, void *buf)
+{
+	struct sli4_cmd_sli_config *sli_config = buf;
+
+	/* sanity check */
+	if (!buf || sli_config->hdr.command !=
+		    SLI4_MBX_CMD_SLI_CONFIG) {
+		efc_log_err(sli4, "bad parameter buf=%p cmd=%#x\n", buf,
+		       buf ? sli_config->hdr.command : -1);
+		return EFC_FAIL;
+	}
+
+	if (le16_to_cpu(sli_config->hdr.status))
+		return le16_to_cpu(sli_config->hdr.status);
+
+	if (le32_to_cpu(sli_config->dw1_flags) & SLI4_SLICONF_EMB)
+		return sli_config->payload.embed[4];
+
+	efc_log_info(sli4, "external buffers not supported\n");
+	return EFC_FAIL;
+}
+
+int
+__sli_create_queue(struct sli4 *sli4, struct sli4_queue *q)
+{
+	struct sli4_rsp_cmn_create_queue *res_q = NULL;
+
+	if (sli_bmbx_command(sli4)) {
+		efc_log_crit(sli4, "bootstrap mailbox write fail %s\n",
+			SLI4_QNAME[q->type]);
+		return EFC_FAIL;
+	}
+	if (sli_res_sli_config(sli4, sli4->bmbx.virt)) {
+		efc_log_err(sli4, "bad status create %s\n",
+		       SLI4_QNAME[q->type]);
+		return EFC_FAIL;
+	}
+	res_q = (void *)((u8 *)sli4->bmbx.virt +
+			offsetof(struct sli4_cmd_sli_config, payload));
+
+	if (res_q->hdr.status) {
+		efc_log_err(sli4, "bad create %s status=%#x addl=%#x\n",
+		       SLI4_QNAME[q->type], res_q->hdr.status,
+			    res_q->hdr.additional_status);
+		return EFC_FAIL;
+	}
+	q->id = le16_to_cpu(res_q->q_id);
+	switch (q->type) {
+	case SLI4_QTYPE_EQ:
+		if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+			q->db_regaddr = sli4->reg[1] + SLI4_IF6_EQ_DB_REG;
+		else
+			q->db_regaddr =	sli4->reg[0] + SLI4_EQCQ_DB_REG;
+		break;
+	case SLI4_QTYPE_CQ:
+		if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+			q->db_regaddr = sli4->reg[1] + SLI4_IF6_CQ_DB_REG;
+		else
+			q->db_regaddr =	sli4->reg[0] + SLI4_EQCQ_DB_REG;
+		break;
+	case SLI4_QTYPE_MQ:
+		if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+			q->db_regaddr = sli4->reg[1] + SLI4_IF6_MQ_DB_REG;
+		else
+			q->db_regaddr =	sli4->reg[0] + SLI4_MQ_DB_REG;
+		break;
+	case SLI4_QTYPE_RQ:
+		if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+			q->db_regaddr = sli4->reg[1] + SLI4_IF6_RQ_DB_REG;
+		else
+			q->db_regaddr =	sli4->reg[0] + SLI4_RQ_DB_REG;
+		break;
+	case SLI4_QTYPE_WQ:
+		if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+			q->db_regaddr = sli4->reg[1] + SLI4_IF6_WQ_DB_REG;
+		else
+			q->db_regaddr =	sli4->reg[0] + SLI4_IO_WQ_DB_REG;
+		break;
+	default:
+		break;
+	}
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_get_queue_entry_size(struct sli4 *sli4, u32 qtype)
+{
+	u32 size = 0;
+
+	switch (qtype) {
+	case SLI4_QTYPE_EQ:
+		size = sizeof(u32);
+		break;
+	case SLI4_QTYPE_CQ:
+		size = 16;
+		break;
+	case SLI4_QTYPE_MQ:
+		size = 256;
+		break;
+	case SLI4_QTYPE_WQ:
+		size = sli4->wqe_size;
+		break;
+	case SLI4_QTYPE_RQ:
+		size = SLI4_RQE_SIZE;
+		break;
+	default:
+		efc_log_info(sli4, "unknown queue type %d\n", qtype);
+		return -1;
+	}
+	return size;
+}
+
+int
+sli_queue_alloc(struct sli4 *sli4, u32 qtype,
+		struct sli4_queue *q, u32 n_entries,
+		     struct sli4_queue *assoc)
+{
+	int size;
+	u32 align = 0;
+
+	/* get queue size */
+	size = sli_get_queue_entry_size(sli4, qtype);
+	if (size < 0)
+		return EFC_FAIL;
+	align = SLI_PAGE_SIZE;
+
+	if (__sli_queue_init(sli4, q, qtype, size, n_entries, align))
+		return EFC_FAIL;
+
+	switch (qtype) {
+	case SLI4_QTYPE_EQ:
+		if (!sli_cmd_common_create_eq(sli4, sli4->bmbx.virt, &q->dma) &&
+		    !__sli_create_queue(sli4, q))
+			return EFC_SUCCESS;
+
+		break;
+	case SLI4_QTYPE_CQ:
+		if (!sli_cmd_common_create_cq(sli4, sli4->bmbx.virt, &q->dma,
+						assoc ? assoc->id : 0) &&
+		    !__sli_create_queue(sli4, q))
+			return EFC_SUCCESS;
+
+		break;
+	case SLI4_QTYPE_MQ:
+		assoc->u.flag |= SLI4_QUEUE_FLAG_MQ;
+		if (!sli_cmd_common_create_mq_ext(sli4, sli4->bmbx.virt,
+						  &q->dma, assoc->id) &&
+		    !__sli_create_queue(sli4, q))
+			return EFC_SUCCESS;
+
+		break;
+	case SLI4_QTYPE_WQ:
+		if (!sli_cmd_wq_create(sli4, sli4->bmbx.virt, &q->dma,
+						assoc ? assoc->id : 0) &&
+		    !__sli_create_queue(sli4, q))
+			return EFC_SUCCESS;
+
+		break;
+	default:
+		efc_log_info(sli4, "unknown queue type %d\n", qtype);
+	}
+
+	__sli_queue_destroy(sli4, q);
+	return EFC_FAIL;
+}
+
+static int sli_cmd_cq_set_create(struct sli4 *sli4,
+				 struct sli4_queue *qs[], u32 num_cqs,
+				 struct sli4_queue *eqs[],
+				 struct efc_dma *dma)
+{
+	struct sli4_rqst_cmn_create_cq_set_v0 *req = NULL;
+	uintptr_t addr;
+	u32 i, offset = 0,  page_bytes = 0, payload_size;
+	u32 p = 0, page_size = 0, n_cqe = 0, num_pages_cq;
+	u32 dw5_flags = 0;
+	u16 dw6w1_flags = 0;
+	__le32 req_len;
+
+	n_cqe = qs[0]->dma.size / SLI4_CQE_BYTES;
+	switch (n_cqe) {
+	case 256:
+	case 512:
+	case 1024:
+	case 2048:
+		page_size = 1;
+		break;
+	case 4096:
+		page_size = 2;
+		break;
+	default:
+		return EFC_FAIL;
+	}
+
+	page_bytes = page_size * SLI_PAGE_SIZE;
+	num_pages_cq = sli_page_count(qs[0]->dma.size, page_bytes);
+	payload_size = max(SLI4_RQST_CMDSZ(cmn_create_cq_set_v0) +
+			   (SZ_DMAADDR * num_pages_cq * num_cqs),
+			   sizeof(struct sli4_rsp_cmn_create_queue_set));
+
+	dma->size = payload_size;
+	dma->virt = dma_alloc_coherent(&sli4->pci->dev, dma->size,
+				      &dma->phys, GFP_DMA);
+	if (!dma->virt)
+		return EFC_FAIL;
+
+	memset(dma->virt, 0, payload_size);
+
+	req = sli_config_cmd_init(sli4, sli4->bmbx.virt, payload_size, dma);
+	if (!req)
+		return EFC_FAIL;
+
+	req_len = SLI4_RQST_PYLD_LEN_VAR(cmn_create_cq_set_v0,
+					SZ_DMAADDR * num_pages_cq * num_cqs);
+	sli_cmd_fill_hdr(&req->hdr, SLI4_CMN_CREATE_CQ_SET, SLI4_SUBSYSTEM_FC,
+			 CMD_V0, req_len);
+	req->page_size = page_size;
+
+	req->num_pages = cpu_to_le16(num_pages_cq);
+	switch (num_pages_cq) {
+	case 1:
+		dw5_flags |= SLI4_CQ_CNT_VAL(256);
+		break;
+	case 2:
+		dw5_flags |= SLI4_CQ_CNT_VAL(512);
+		break;
+	case 4:
+		dw5_flags |= SLI4_CQ_CNT_VAL(1024);
+		break;
+	case 8:
+		dw5_flags |= SLI4_CQ_CNT_VAL(LARGE);
+		dw6w1_flags |= (n_cqe & SLI4_CREATE_CQSETV0_CQE_COUNT);
+		break;
+	default:
+		efc_log_info(sli4, "num_pages %d not valid\n", num_pages_cq);
+		return EFC_FAIL;
+	}
+
+	dw5_flags |= SLI4_CREATE_CQSETV0_EVT;
+	dw5_flags |= SLI4_CREATE_CQSETV0_VALID;
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+		dw5_flags |= SLI4_CREATE_CQSETV0_AUTOVALID;
+
+	dw6w1_flags &= ~SLI4_CREATE_CQSETV0_ARM;
+
+	req->dw5_flags = cpu_to_le32(dw5_flags);
+	req->dw6w1_flags = cpu_to_le16(dw6w1_flags);
+
+	req->num_cq_req = cpu_to_le16(num_cqs);
+
+	/* Fill page addresses of all the CQs. */
+	for (i = 0; i < num_cqs; i++) {
+		req->eq_id[i] = cpu_to_le16(eqs[i]->id);
+		for (p = 0, addr = qs[i]->dma.phys; p < num_pages_cq;
+		     p++, addr += page_bytes) {
+			req->page_phys_addr[offset].low =
+				cpu_to_le32(lower_32_bits(addr));
+			req->page_phys_addr[offset].high =
+				cpu_to_le32(upper_32_bits(addr));
+			offset++;
+		}
+	}
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cq_alloc_set(struct sli4 *sli4, struct sli4_queue *qs[],
+		 u32 num_cqs, u32 n_entries, struct sli4_queue *eqs[])
+{
+	u32 i;
+	struct efc_dma dma = {0};
+	struct sli4_rsp_cmn_create_queue_set *res;
+	void __iomem *db_regaddr;
+
+	/* Align the queue DMA memory */
+	for (i = 0; i < num_cqs; i++) {
+		if (__sli_queue_init(sli4, qs[i], SLI4_QTYPE_CQ,
+				SLI4_CQE_BYTES, n_entries, SLI_PAGE_SIZE))
+			goto error;
+	}
+
+	if (sli_cmd_cq_set_create(sli4, qs, num_cqs, eqs, &dma))
+		goto error;
+
+	if (sli_bmbx_command(sli4))
+		goto error;
+
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+		db_regaddr = sli4->reg[1] + SLI4_IF6_CQ_DB_REG;
+	else
+		db_regaddr = sli4->reg[0] + SLI4_EQCQ_DB_REG;
+
+	res = dma.virt;
+	if (res->hdr.status) {
+		efc_log_err(sli4, "bad create CQSet status=%#x addl=%#x\n",
+		       res->hdr.status, res->hdr.additional_status);
+		goto error;
+	}
+
+	/* Check if we got all requested CQs. */
+	if (le16_to_cpu(res->num_q_allocated) != num_cqs) {
+		efc_log_crit(sli4, "Requested count CQs doesn't match.\n");
+		goto error;
+	}
+	/* Fill the resp cq ids. */
+	for (i = 0; i < num_cqs; i++) {
+		qs[i]->id = le16_to_cpu(res->q_id) + i;
+		qs[i]->db_regaddr = db_regaddr;
+	}
+
+	dma_free_coherent(&sli4->pci->dev, dma.size, dma.virt, dma.phys);
+
+	return EFC_SUCCESS;
+
+error:
+	for (i = 0; i < num_cqs; i++)
+		__sli_queue_destroy(sli4, qs[i]);
+
+	if (dma.virt)
+		dma_free_coherent(&sli4->pci->dev, dma.size, dma.virt,
+				  dma.phys);
+
+	return EFC_FAIL;
+}
+
+static int
+sli_cmd_common_destroy_q(struct sli4 *sli4, u8 opc, u8 subsystem, u16 q_id)
+{
+	struct sli4_rqst_cmn_destroy_q *req;
+
+	/* Payload length must accommodate both request and response */
+	req = sli_config_cmd_init(sli4, sli4->bmbx.virt,
+				  SLI4_CFG_PYLD_LENGTH(cmn_destroy_q), NULL);
+	if (!req)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&req->hdr, opc, subsystem,
+			 CMD_V0, SLI4_RQST_PYLD_LEN(cmn_destroy_q));
+	req->q_id = cpu_to_le16(q_id);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_queue_free(struct sli4 *sli4, struct sli4_queue *q,
+	       u32 destroy_queues, u32 free_memory)
+{
+	int rc = EFC_SUCCESS;
+	u8 opcode, subsystem;
+	struct sli4_rsp_hdr *res;
+
+	if (!q) {
+		efc_log_err(sli4, "bad parameter sli4=%p q=%p\n", sli4, q);
+		return EFC_FAIL;
+	}
+
+	if (!destroy_queues)
+		goto free_mem;
+
+	switch (q->type) {
+	case SLI4_QTYPE_EQ:
+		opcode = SLI4_CMN_DESTROY_EQ;
+		subsystem = SLI4_SUBSYSTEM_COMMON;
+		break;
+	case SLI4_QTYPE_CQ:
+		opcode = SLI4_CMN_DESTROY_CQ;
+		subsystem = SLI4_SUBSYSTEM_COMMON;
+		break;
+	case SLI4_QTYPE_MQ:
+		opcode = SLI4_CMN_DESTROY_MQ;
+		subsystem = SLI4_SUBSYSTEM_COMMON;
+		break;
+	case SLI4_QTYPE_WQ:
+		opcode = SLI4_OPC_WQ_DESTROY;
+		subsystem = SLI4_SUBSYSTEM_FC;
+		break;
+	case SLI4_QTYPE_RQ:
+		opcode = SLI4_OPC_RQ_DESTROY;
+		subsystem = SLI4_SUBSYSTEM_FC;
+		break;
+	default:
+		efc_log_info(sli4, "bad queue type %d\n", q->type);
+		rc = EFC_FAIL;
+		goto free_mem;
+	}
+
+	rc = sli_cmd_common_destroy_q(sli4, opcode, subsystem, q->id);
+	if (rc)
+		goto free_mem;
+
+	rc = sli_bmbx_command(sli4);
+	if (rc)
+		goto free_mem;
+
+	rc = sli_res_sli_config(sli4, sli4->bmbx.virt);
+	if (rc)
+		goto free_mem;
+
+	res = (void *)((u8 *)sli4->bmbx.virt +
+			     offsetof(struct sli4_cmd_sli_config, payload));
+	if (res->status) {
+		efc_log_err(sli4, "destroy %s st=%#x addl=%#x\n",
+				   SLI4_QNAME[q->type], res->status,
+				   res->additional_status);
+		rc = EFC_FAIL;
+		goto free_mem;
+	}
+
+free_mem:
+	if (free_memory)
+		__sli_queue_destroy(sli4, q);
+
+	return rc;
+}
+
+int
+sli_queue_eq_arm(struct sli4 *sli4, struct sli4_queue *q, bool arm)
+{
+	u32 val;
+	unsigned long flags = 0;
+	u32 a = arm ? SLI4_EQCQ_ARM : SLI4_EQCQ_UNARM;
+
+	spin_lock_irqsave(&q->lock, flags);
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+		val = sli_format_if6_eq_db_data(q->n_posted, q->id, a);
+	else
+		val = sli_format_eq_db_data(q->n_posted, q->id, a);
+
+	writel(val, q->db_regaddr);
+	q->n_posted = 0;
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_queue_arm(struct sli4 *sli4, struct sli4_queue *q, bool arm)
+{
+	u32 val = 0;
+	unsigned long flags = 0;
+	u32 a = arm ? SLI4_EQCQ_ARM : SLI4_EQCQ_UNARM;
+
+	spin_lock_irqsave(&q->lock, flags);
+
+	switch (q->type) {
+	case SLI4_QTYPE_EQ:
+		if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+			val = sli_format_if6_eq_db_data(q->n_posted, q->id, a);
+		else
+			val = sli_format_eq_db_data(q->n_posted, q->id, a);
+
+		writel(val, q->db_regaddr);
+		q->n_posted = 0;
+		break;
+	case SLI4_QTYPE_CQ:
+		if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+			val = sli_format_if6_cq_db_data(q->n_posted, q->id, a);
+		else
+			val = sli_format_cq_db_data(q->n_posted, q->id, a);
+
+		writel(val, q->db_regaddr);
+		q->n_posted = 0;
+		break;
+	default:
+		efc_log_info(sli4, "should only be used for EQ/CQ, not %s\n",
+			SLI4_QNAME[q->type]);
+	}
+
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_wq_write(struct sli4 *sli4, struct sli4_queue *q, u8 *entry)
+{
+	u8 *qe = q->dma.virt;
+	u32 qindex;
+	u32 val = 0;
+
+	qindex = q->index;
+	qe += q->index * q->size;
+
+	if (sli4->params.perf_wq_id_association)
+		sli_set_wq_id_association(entry, q->id);
+
+	memcpy(qe, entry, q->size);
+	val = sli_format_wq_db_data(q->id);
+
+	writel(val, q->db_regaddr);
+	q->index = (q->index + 1) & (q->length - 1);
+
+	return qindex;
+}
+
+int
+sli_mq_write(struct sli4 *sli4, struct sli4_queue *q, u8 *entry)
+{
+	u8 *qe = q->dma.virt;
+	u32 qindex;
+	u32 val = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+	qindex = q->index;
+	qe += q->index * q->size;
+
+	memcpy(qe, entry, q->size);
+	val = sli_format_mq_db_data(q->id);
+	writel(val, q->db_regaddr);
+	q->index = (q->index + 1) & (q->length - 1);
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return qindex;
+}
+
+int
+sli_rq_write(struct sli4 *sli4, struct sli4_queue *q, u8 *entry)
+{
+	u8 *qe = q->dma.virt;
+	u32 qindex;
+	u32 val = 0;
+
+	qindex = q->index;
+	qe += q->index * q->size;
+
+	memcpy(qe, entry, q->size);
+
+	/*
+	 * In RQ-pair, an RQ either contains the FC header
+	 * (i.e. is_hdr == TRUE) or the payload.
+	 *
+	 * Don't ring doorbell for payload RQ
+	 */
+	if (!(q->u.flag & SLI4_QUEUE_FLAG_HDR))
+		goto skip;
+
+	val = sli_format_rq_db_data(q->id);
+	writel(val, q->db_regaddr);
+skip:
+	q->index = (q->index + 1) & (q->length - 1);
+
+	return qindex;
+}
+
+int
+sli_eq_read(struct sli4 *sli4, struct sli4_queue *q, u8 *entry)
+{
+	u8 *qe = q->dma.virt;
+	unsigned long flags = 0;
+	u16 wflags = 0;
+
+	spin_lock_irqsave(&q->lock, flags);
+
+	qe += q->index * q->size;
+
+	/* Check if eqe is valid */
+	wflags = le16_to_cpu(((struct sli4_eqe *)qe)->dw0w0_flags);
+
+	if ((wflags & SLI4_EQE_VALID) != q->phase) {
+		spin_unlock_irqrestore(&q->lock, flags);
+		return EFC_FAIL;
+	}
+
+	if (sli4->if_type != SLI4_INTF_IF_TYPE_6) {
+		wflags &= ~SLI4_EQE_VALID;
+		((struct sli4_eqe *)qe)->dw0w0_flags = cpu_to_le16(wflags);
+	}
+
+	memcpy(entry, qe, q->size);
+	q->index = (q->index + 1) & (q->length - 1);
+	q->n_posted++;
+	/*
+	 * For prism, the phase value will be used
+	 * to check the validity of eq/cq entries.
+	 * The value toggles after a complete sweep
+	 * through the queue.
+	 */
+
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6 && q->index == 0)
+		q->phase ^= (u16)0x1;
+
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cq_read(struct sli4 *sli4, struct sli4_queue *q, u8 *entry)
+{
+	u8 *qe = q->dma.virt;
+	unsigned long flags = 0;
+	u32 dwflags = 0;
+	bool valid_bit_set;
+
+	spin_lock_irqsave(&q->lock, flags);
+
+	qe += q->index * q->size;
+
+	/* Check if cqe is valid */
+	dwflags = le32_to_cpu(((struct sli4_mcqe *)qe)->dw3_flags);
+	valid_bit_set = (dwflags & SLI4_MCQE_VALID) != 0;
+
+	if (valid_bit_set != q->phase) {
+		spin_unlock_irqrestore(&q->lock, flags);
+		return EFC_FAIL;
+	}
+
+	if (sli4->if_type != SLI4_INTF_IF_TYPE_6) {
+		dwflags &= ~SLI4_MCQE_VALID;
+		((struct sli4_mcqe *)qe)->dw3_flags = cpu_to_le32(dwflags);
+	}
+
+	memcpy(entry, qe, q->size);
+	q->index = (q->index + 1) & (q->length - 1);
+	q->n_posted++;
+	/*
+	 * For prism, the phase value will be used
+	 * to check the validity of eq/cq entries.
+	 * The value toggles after a complete sweep
+	 * through the queue.
+	 */
+
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6 && q->index == 0)
+		q->phase ^= (u16)0x1;
+
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_mq_read(struct sli4 *sli4, struct sli4_queue *q, u8 *entry)
+{
+	u8 *qe = q->dma.virt;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&q->lock, flags);
+
+	qe += q->u.r_idx * q->size;
+
+	/* Check if mqe is valid */
+	if (q->index == q->u.r_idx) {
+		spin_unlock_irqrestore(&q->lock, flags);
+		return EFC_FAIL;
+	}
+
+	memcpy(entry, qe, q->size);
+	q->u.r_idx = (q->u.r_idx + 1) & (q->length - 1);
+
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_eq_parse(struct sli4 *sli4, u8 *buf, u16 *cq_id)
+{
+	struct sli4_eqe *eqe = (void *)buf;
+	int rc = EFC_SUCCESS;
+	u16 flags = 0;
+	u16 majorcode;
+	u16 minorcode;
+
+	if (!buf || !cq_id) {
+		efc_log_err(sli4, "bad parameters sli4=%p buf=%p cq_id=%p\n",
+		       sli4, buf, cq_id);
+		return EFC_FAIL;
+	}
+
+	flags = le16_to_cpu(eqe->dw0w0_flags);
+	majorcode = (flags & SLI4_EQE_MJCODE) >> 1;
+	minorcode = (flags & SLI4_EQE_MNCODE) >> 4;
+	switch (majorcode) {
+	case SLI4_MAJOR_CODE_STANDARD:
+		*cq_id = le16_to_cpu(eqe->resource_id);
+		break;
+	case SLI4_MAJOR_CODE_SENTINEL:
+		efc_log_info(sli4, "sentinel EQE\n");
+		rc = SLI4_EQE_STATUS_EQ_FULL;
+		break;
+	default:
+		efc_log_info(sli4, "Unsupported EQE: major %x minor %x\n",
+			majorcode, minorcode);
+		rc = EFC_FAIL;
+	}
+
+	return rc;
+}
+
+int
+sli_cq_parse(struct sli4 *sli4, struct sli4_queue *cq, u8 *cqe,
+	     enum sli4_qentry *etype, u16 *q_id)
+{
+	int rc = EFC_SUCCESS;
+
+	if (!cq || !cqe || !etype) {
+		efc_log_err(sli4, "bad params sli4=%p cq=%p cqe=%p etype=%p q_id=%p\n",
+		       sli4, cq, cqe, etype, q_id);
+		return -EINVAL;
+	}
+
+	/* Parse a CQ entry to retrieve the event type and the queue id */
+	if (cq->u.flag & SLI4_QUEUE_FLAG_MQ) {
+		struct sli4_mcqe	*mcqe = (void *)cqe;
+
+		if (le32_to_cpu(mcqe->dw3_flags) & SLI4_MCQE_AE) {
+			*etype = SLI4_QENTRY_ASYNC;
+		} else {
+			*etype = SLI4_QENTRY_MQ;
+			rc = sli_cqe_mq(sli4, mcqe);
+		}
+		*q_id = -1;
+	} else {
+		rc = sli_fc_cqe_parse(sli4, cq, cqe, etype, q_id);
+	}
+
+	return rc;
+}
diff --git a/drivers/scsi/elx/libefc_sli/sli4.h b/drivers/scsi/elx/libefc_sli/sli4.h
index 39b6fceed85e..5bc9e8b8ffd1 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.h
+++ b/drivers/scsi/elx/libefc_sli/sli4.h
@@ -3707,4 +3707,13 @@ struct sli4 {
 	struct efc_dma		vpd_data;
 };
 
+static inline void
+sli_cmd_fill_hdr(struct sli4_rqst_hdr *hdr, u8 opc, u8 sub, u32 ver, __le32 len)
+{
+	hdr->opcode = opc;
+	hdr->subsystem = sub;
+	hdr->dw3_version = cpu_to_le32(ver);
+	hdr->request_length = len;
+}
+
 #endif /* !_SLI4_H */
-- 
2.26.2


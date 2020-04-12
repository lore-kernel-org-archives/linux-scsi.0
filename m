Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C561AC352B6
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EA8F20739
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 03:33:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q9qg4ccC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgDLDdW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 23:33:22 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33036 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgDLDdW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Apr 2020 23:33:22 -0400
Received: by mail-pg1-f194.google.com with SMTP id d17so2950970pgo.0
        for <linux-scsi@vger.kernel.org>; Sat, 11 Apr 2020 20:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lsciE5BRTqq9G4EKvXczlAUPisVaFLjHrwLxQy3s+DQ=;
        b=q9qg4ccCcBNKSmL/5tFsbk9A7mkBZOk6PxBe695NeEK3OJ+XslYRsc11XJg5xTysmw
         YdkSwD7enWSxNY8ypAC6FM6b3wAB2He7G93OTQbe0Qf1RzxFl+cjD1w4bIaZlP26IcSR
         Ic+FV/sizYtKDz18cvOD3DgWqNXAKF4j8k3Ztt49aWqKL4lcZf9sHpOiEuC+tvcowFfg
         X5QM8McQ4I3fp61Pv8WYZFcexBj0q/m5yrmoxl9H4toscT69qDs5oLQqgzaWynKusMsJ
         PIsbzWuKwf3hNCPioyCxuBW27a9/JVb3Ss9gskCbebssP5xR9DXvBZFYTARZjzMa+gRK
         uOVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lsciE5BRTqq9G4EKvXczlAUPisVaFLjHrwLxQy3s+DQ=;
        b=PcYeTXJj+gdgBpdznIInJ2N7Pd6hQTMiYocroxQUPOXrQPe8h78qdjWiIsyYG/BOQV
         bwC30rQdE8qTj2hJYvQx/74MTL9hGekjJcuSuJLQ5elFzDSmOskPfhnsR5DjfDzkgWqT
         PyfP+ffa9giUv5PKrCj0beTctmEPxwmdvRLeRFRFMj/zOGkpQc+/4/xf7aFWkiaKOfJd
         kqOq3Ft4YuDe9MByAMWxwMVU9wPo9ep9nbVBm1a2BHYT7UJFlVnzxzPzH+shAnMgx9PQ
         OPm4o4mY0+0DM4Fn5ReNiL2RA68HrgMi4YfMeew1Kk3geT1VCbaxYdAedpxDtPEODLQ7
         b3eg==
X-Gm-Message-State: AGi0PubNIDFcwDESx39G9MY8TCTLuSlLgVpLB3snFReWz21RfsgvrOAa
        VMpUTrdp815vSVjqeQIBIx5Hcucm
X-Google-Smtp-Source: APiQypIEy0idWCjm8hDLUWGNBz+DWQG5wKu8LWt8rU/Wj8T8DWiopQn8KsXngGkbf/ctZwcA0yymRg==
X-Received: by 2002:a63:49:: with SMTP id 70mr3044411pga.275.1586662396858;
        Sat, 11 Apr 2020 20:33:16 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id i4sm5614694pjg.4.2020.04.11.20.33.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Apr 2020 20:33:16 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        hare@suse.de, James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v3 04/31] elx: libefc_sli: queue create/destroy/parse routines
Date:   Sat, 11 Apr 2020 20:32:36 -0700
Message-Id: <20200412033303.29574-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200412033303.29574-1-jsmart2021@gmail.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the libefc_sli SLI-4 library population.

This patch adds service routines to create mailbox commands
and adds APIs to create/destroy/parse SLI-4 EQ, CQ, RQ and MQ queues.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v3:
  Removed efc_assert define. Replaced with WARN_ON.
  Returned defined return values EFC_SUCCESS/FAIL
---
 drivers/scsi/elx/include/efc_common.h |   18 +
 drivers/scsi/elx/libefc_sli/sli4.c    | 1514 +++++++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc_sli/sli4.h    |    9 +
 3 files changed, 1541 insertions(+)

diff --git a/drivers/scsi/elx/include/efc_common.h b/drivers/scsi/elx/include/efc_common.h
index c427f75da4d5..4c7574dacb99 100644
--- a/drivers/scsi/elx/include/efc_common.h
+++ b/drivers/scsi/elx/include/efc_common.h
@@ -22,4 +22,22 @@ struct efc_dma {
 	struct pci_dev	*pdev;
 };
 
+#define efc_log_crit(efc, fmt, args...) \
+		dev_crit(&((efc)->pcidev)->dev, fmt, ##args)
+
+#define efc_log_err(efc, fmt, args...) \
+		dev_err(&((efc)->pcidev)->dev, fmt, ##args)
+
+#define efc_log_warn(efc, fmt, args...) \
+		dev_warn(&((efc)->pcidev)->dev, fmt, ##args)
+
+#define efc_log_info(efc, fmt, args...) \
+		dev_info(&((efc)->pcidev)->dev, fmt, ##args)
+
+#define efc_log_test(efc, fmt, args...) \
+		dev_dbg(&((efc)->pcidev)->dev, fmt, ##args)
+
+#define efc_log_debug(efc, fmt, args...) \
+		dev_dbg(&((efc)->pcidev)->dev, fmt, ##args)
+
 #endif /* __EFC_COMMON_H__ */
diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
index 29d33becd334..224a06610c78 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.c
+++ b/drivers/scsi/elx/libefc_sli/sli4.c
@@ -24,3 +24,1517 @@ static struct sli4_asic_entry_t sli4_asic_table[] = {
 	{ SLI4_ASIC_REV_A3, SLI4_ASIC_GEN_6},
 	{ SLI4_ASIC_REV_A1, SLI4_ASIC_GEN_7},
 };
+
+/* Convert queue type enum (SLI_QTYPE_*) into a string */
+static char *SLI_QNAME[] = {
+	"Event Queue",
+	"Completion Queue",
+	"Mailbox Queue",
+	"Work Queue",
+	"Receive Queue",
+	"Undefined"
+};
+
+/*
+ * Write a SLI_CONFIG command to the provided buffer.
+ *
+ * @sli4 SLI context pointer.
+ * @buf Destination buffer for the command.
+ * @size size of the destination buffer(buf).
+ * @length Length in bytes of attached command.
+ * @dma DMA buffer for non-embedded commands.
+ *
+ */
+static void *
+sli_config_cmd_init(struct sli4 *sli4, void *buf,
+		    size_t size, u32 length,
+		    struct efc_dma *dma)
+{
+	struct sli4_cmd_sli_config *config = NULL;
+	u32 flags = 0;
+
+	if (length > sizeof(config->payload.embed) && !dma) {
+		efc_log_err(sli4, "Too big for an embedded cmd with len(%d)\n",
+			    length);
+		return NULL;
+	}
+
+	config = buf;
+
+	memset(buf, 0, size);
+
+	config->hdr.command = MBX_CMD_SLI_CONFIG;
+	if (!dma) {
+		flags |= SLI4_SLICONF_EMB;
+		config->dw1_flags = cpu_to_le32(flags);
+		config->payload_len = cpu_to_le32(length);
+		buf += offsetof(struct sli4_cmd_sli_config, payload.embed);
+		return buf;
+	}
+
+	flags = SLI4_SLICONF_PMDCMD_VAL_1;
+	flags &= ~SLI4_SLICONF_EMB;
+	config->dw1_flags = cpu_to_le32(flags);
+
+	config->payload.mem.addr.low = cpu_to_le32(lower_32_bits(dma->phys));
+	config->payload.mem.addr.high =	cpu_to_le32(upper_32_bits(dma->phys));
+	config->payload.mem.length =
+			cpu_to_le32(dma->size & SLI4_SLICONFIG_PMD_LEN);
+	config->payload_len = cpu_to_le32(dma->size);
+	/* save pointer to DMA for BMBX dumping purposes */
+	sli4->bmbx_non_emb_pmd = dma;
+	return dma->virt;
+}
+
+/*
+ * Write a COMMON_CREATE_CQ command.
+ *
+ * This creates a Version 2 message.
+ *
+ * Returns 0 on success, or non-zero otherwise.
+ */
+static int
+sli_cmd_common_create_cq(struct sli4 *sli4, void *buf, size_t size,
+			 struct efc_dma *qmem,
+			 u16 eq_id)
+{
+	struct sli4_rqst_cmn_create_cq_v2 *cqv2 = NULL;
+	u32 p;
+	uintptr_t addr;
+	u32 page_bytes = 0;
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
+		page_size = 1;
+		break;
+	case 4096:
+		page_size = 2;
+		break;
+	default:
+		return EFC_FAIL;
+	}
+	page_bytes = page_size * SLI_PAGE_SIZE;
+	num_pages = sli_page_count(qmem->size, page_bytes);
+
+	cmd_size = CFG_RQST_CMDSZ(cmn_create_cq_v2) + SZ_DMAADDR * num_pages;
+
+	cqv2 = sli_config_cmd_init(sli4, buf, size, cmd_size, NULL);
+	if (!cqv2)
+		return EFC_FAIL;
+
+	len = CFG_RQST_PYLD_LEN_VAR(cmn_create_cq_v2,
+					 SZ_DMAADDR * num_pages);
+	sli_cmd_fill_hdr(&cqv2->hdr, CMN_CREATE_CQ, SLI4_SUBSYSTEM_COMMON,
+			 CMD_V2, len);
+	cqv2->page_size = page_size;
+
+	/* valid values for number of pages: 1, 2, 4, 8 (sec 4.4.3) */
+	cqv2->num_pages = cpu_to_le16(num_pages);
+	if (!num_pages || num_pages > SLI4_CMN_CREATE_CQ_V2_MAX_PAGES)
+		return EFC_FAIL;
+
+	switch (num_pages) {
+	case 1:
+		dw5_flags |= CQ_CNT_VAL(256);
+		break;
+	case 2:
+		dw5_flags |= CQ_CNT_VAL(512);
+		break;
+	case 4:
+		dw5_flags |= CQ_CNT_VAL(1024);
+		break;
+	case 8:
+		dw5_flags |= CQ_CNT_VAL(LARGE);
+		cqv2->cqe_count = cpu_to_le16(n_cqe);
+		break;
+	default:
+		efc_log_err(sli4, "num_pages %d not valid\n", num_pages);
+		return EFC_FAIL;
+	}
+
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+		dw5_flags |= CREATE_CQV2_AUTOVALID;
+
+	dw5_flags |= CREATE_CQV2_EVT;
+	dw5_flags |= CREATE_CQV2_VALID;
+
+	cqv2->dw5_flags = cpu_to_le32(dw5_flags);
+	cqv2->dw6w1_arm = cpu_to_le16(dw6w1_arm);
+	cqv2->eq_id = cpu_to_le16(eq_id);
+
+	for (p = 0, addr = qmem->phys; p < num_pages; p++, addr += page_bytes) {
+		cqv2->page_phys_addr[p].low = cpu_to_le32(lower_32_bits(addr));
+		cqv2->page_phys_addr[p].high = cpu_to_le32(upper_32_bits(addr));
+	}
+
+	return EFC_SUCCESS;
+}
+
+/* Write a COMMON_CREATE_EQ command */
+static int
+sli_cmd_common_create_eq(struct sli4 *sli4, void *buf, size_t size,
+			 struct efc_dma *qmem)
+{
+	struct sli4_rqst_cmn_create_eq *eq;
+	u32 p;
+	uintptr_t addr;
+	u16 num_pages;
+	u32 dw5_flags = 0;
+	u32 dw6_flags = 0, ver = CMD_V0;
+
+	eq = sli_config_cmd_init(sli4, buf, size,
+				 SLI_CONFIG_PYLD_LENGTH(cmn_create_eq), NULL);
+	if (!eq)
+		return EFC_FAIL;
+
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+		ver = CMD_V2;
+
+	sli_cmd_fill_hdr(&eq->hdr, CMN_CREATE_EQ, SLI4_SUBSYSTEM_COMMON,
+			 ver, CFG_RQST_PYLD_LEN(cmn_create_eq));
+
+	/* valid values for number of pages: 1, 2, 4 (sec 4.4.3) */
+	num_pages = qmem->size / SLI_PAGE_SIZE;
+	eq->num_pages = cpu_to_le16(num_pages);
+
+	switch (num_pages) {
+	case 1:
+		dw5_flags |= SLI4_EQE_SIZE_4;
+		dw6_flags |= EQ_CNT_VAL(1024);
+		break;
+	case 2:
+		dw5_flags |= SLI4_EQE_SIZE_4;
+		dw6_flags |= EQ_CNT_VAL(2048);
+		break;
+	case 4:
+		dw5_flags |= SLI4_EQE_SIZE_4;
+		dw6_flags |= EQ_CNT_VAL(4096);
+		break;
+	default:
+		efc_log_err(sli4, "num_pages %d not valid\n", num_pages);
+		return EFC_FAIL;
+	}
+
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+		dw5_flags |= CREATE_EQ_AUTOVALID;
+
+	dw5_flags |= CREATE_EQ_VALID;
+	dw6_flags &= (~CREATE_EQ_ARM);
+	eq->dw5_flags = cpu_to_le32(dw5_flags);
+	eq->dw6_flags = cpu_to_le32(dw6_flags);
+	eq->dw7_delaymulti = cpu_to_le32(CREATE_EQ_DELAYMULTI);
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
+sli_cmd_common_create_mq_ext(struct sli4 *sli4, void *buf, size_t size,
+			     struct efc_dma *qmem,
+			     u16 cq_id)
+{
+	struct sli4_rqst_cmn_create_mq_ext *mq;
+	u32 p;
+	uintptr_t addr;
+	u32 num_pages;
+	u16 dw6w1_flags = 0;
+
+	mq = sli_config_cmd_init(sli4, buf, size,
+				 SLI_CONFIG_PYLD_LENGTH(cmn_create_mq_ext),
+				 NULL);
+	if (!mq)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&mq->hdr, CMN_CREATE_MQ_EXT, SLI4_SUBSYSTEM_COMMON,
+			 CMD_V0, CFG_RQST_PYLD_LEN(cmn_create_mq_ext));
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
+	if (sli4->mq_create_version) {
+		mq->cq_id_v1 = cpu_to_le16(cq_id);
+		mq->hdr.dw3_version = cpu_to_le32(CMD_V1);
+	} else {
+		dw6w1_flags |= (cq_id << CREATE_MQEXT_CQID_SHIFT);
+	}
+	mq->dw7_val = cpu_to_le32(CREATE_MQEXT_VAL);
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
+sli_cmd_wq_create(struct sli4 *sli4, void *buf, size_t size,
+		     struct efc_dma *qmem, u16 cq_id)
+{
+	struct sli4_rqst_wq_create *wq;
+	u32 p;
+	uintptr_t addr;
+	u32 page_size = 0;
+	u32 page_bytes = 0;
+	u32 n_wqe = 0;
+	u16 num_pages;
+
+	wq = sli_config_cmd_init(sli4, buf, size,
+				 SLI_CONFIG_PYLD_LENGTH(wq_create), NULL);
+	if (!wq)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&wq->hdr, SLI4_OPC_WQ_CREATE, SLI4_SUBSYSTEM_FC,
+			 CMD_V1, CFG_RQST_PYLD_LEN(wq_create));
+	n_wqe = qmem->size / sli4->wqe_size;
+
+	switch (qmem->size) {
+	case 4096:
+	case 8192:
+	case 16384:
+	case 32768:
+		page_size = 1;
+		break;
+	case 65536:
+		page_size = 2;
+		break;
+	case 131072:
+		page_size = 4;
+		break;
+	case 262144:
+		page_size = 8;
+		break;
+	case 524288:
+		page_size = 10;
+		break;
+	default:
+		return EFC_FAIL;
+	}
+	page_bytes = page_size * SLI_PAGE_SIZE;
+
+	/* valid values for number of pages(num_pages): 1-8 */
+	num_pages = sli_page_count(qmem->size, page_bytes);
+	wq->num_pages = cpu_to_le16(num_pages);
+	if (!num_pages || num_pages > SLI4_WQ_CREATE_MAX_PAGES)
+		return EFC_FAIL;
+
+	wq->cq_id = cpu_to_le16(cq_id);
+
+	wq->page_size = page_size;
+
+	if (sli4->wqe_size == SLI4_WQE_EXT_BYTES)
+		wq->wqe_size_byte |= SLI4_WQE_EXT_SIZE;
+	else
+		wq->wqe_size_byte |= SLI4_WQE_SIZE;
+
+	wq->wqe_count = cpu_to_le16(n_wqe);
+
+	for (p = 0, addr = qmem->phys; p < num_pages; p++, addr += page_bytes) {
+		wq->page_phys_addr[p].low  = cpu_to_le32(lower_32_bits(addr));
+		wq->page_phys_addr[p].high = cpu_to_le32(upper_32_bits(addr));
+	}
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_rq_create(struct sli4 *sli4, void *buf, size_t size,
+		  struct efc_dma *qmem,
+		  u16 cq_id, u16 buffer_size)
+{
+	struct sli4_rqst_rq_create *rq;
+	u32 p;
+	uintptr_t addr;
+	u16 num_pages;
+
+	rq = sli_config_cmd_init(sli4, buf, size,
+				 SLI_CONFIG_PYLD_LENGTH(rq_create), NULL);
+	if (!rq)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&rq->hdr, SLI4_OPC_RQ_CREATE, SLI4_SUBSYSTEM_FC,
+			 CMD_V0, CFG_RQST_PYLD_LEN(rq_create));
+	/* valid values for number of pages: 1-8 (sec 4.5.6) */
+	num_pages = sli_page_count(qmem->size, SLI_PAGE_SIZE);
+	rq->num_pages = cpu_to_le16(num_pages);
+	if (!num_pages ||
+	    num_pages > SLI4_RQ_CREATE_V0_MAX_PAGES) {
+		efc_log_info(sli4, "num_pages %d not valid\n", num_pages);
+		return EFC_FAIL;
+	}
+
+	/*
+	 * RQE count is the log base 2 of the total number of entries
+	 */
+	rq->rqe_count_byte |= 31 - __builtin_clz(qmem->size / SLI4_RQE_SIZE);
+
+	if (buffer_size < SLI4_RQ_CREATE_V0_MIN_BUF_SIZE ||
+	    buffer_size > SLI4_RQ_CREATE_V0_MAX_BUF_SIZE) {
+		efc_log_err(sli4, "buffer_size %d out of range (%d-%d)\n",
+		       buffer_size,
+		       SLI4_RQ_CREATE_V0_MIN_BUF_SIZE,
+		       SLI4_RQ_CREATE_V0_MAX_BUF_SIZE);
+		return EFC_FAIL;
+	}
+	rq->buffer_size = cpu_to_le16(buffer_size);
+
+	rq->cq_id = cpu_to_le16(cq_id);
+
+	for (p = 0, addr = qmem->phys; p < num_pages;
+	     p++, addr += SLI_PAGE_SIZE) {
+		rq->page_phys_addr[p].low  = cpu_to_le32(lower_32_bits(addr));
+		rq->page_phys_addr[p].high = cpu_to_le32(upper_32_bits(addr));
+	}
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_rq_create_v1(struct sli4 *sli4, void *buf, size_t size,
+		     struct efc_dma *qmem, u16 cq_id,
+		     u16 buffer_size)
+{
+	struct sli4_rqst_rq_create_v1 *rq;
+	u32 p;
+	uintptr_t addr;
+	u32 num_pages;
+
+	rq = sli_config_cmd_init(sli4, buf, size,
+				 SLI_CONFIG_PYLD_LENGTH(rq_create_v1), NULL);
+	if (!rq)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&rq->hdr, SLI4_OPC_RQ_CREATE, SLI4_SUBSYSTEM_FC,
+			 CMD_V1, CFG_RQST_PYLD_LEN(rq_create_v1));
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
+	__le32 req_len;
+
+	page_count =  sli_page_count(qs[0]->dma.size, SLI_PAGE_SIZE) * num_rqs;
+
+	/* Payload length must accommodate both request and response */
+	payload_size = max(CFG_RQST_CMDSZ(rq_create_v2) +
+			   SZ_DMAADDR * page_count,
+			   sizeof(struct sli4_rsp_cmn_create_queue_set));
+
+	dma->size = payload_size;
+	dma->virt = dma_alloc_coherent(&sli4->pcidev->dev, dma->size,
+				      &dma->phys, GFP_DMA);
+	if (!dma->virt)
+		return EFC_FAIL;
+
+	memset(dma->virt, 0, payload_size);
+
+	req = sli_config_cmd_init(sli4, sli4->bmbx.virt, SLI4_BMBX_SIZE,
+			       payload_size, dma);
+	if (!req)
+		return EFC_FAIL;
+
+	req_len = CFG_RQST_PYLD_LEN_VAR(rq_create_v2, SZ_DMAADDR * page_count);
+	sli_cmd_fill_hdr(&req->hdr, SLI4_OPC_RQ_CREATE, SLI4_SUBSYSTEM_FC,
+			 CMD_V2, req_len);
+	/* Fill Payload fields */
+	req->dim_dfd_dnb  |= SLI4_RQCREATEV2_DNB;
+	num_pages = sli_page_count(qs[0]->dma.size, SLI_PAGE_SIZE);
+	req->num_pages	   = cpu_to_le16(num_pages);
+	req->rqe_count     = cpu_to_le16(qs[0]->dma.size / SLI4_RQE_SIZE);
+	req->rqe_size_byte |= SLI4_RQE_SIZE_8;
+	req->page_size     = SLI4_RQ_PAGE_SIZE_4096;
+	req->rq_count      = num_rqs;
+	req->base_cq_id    = cpu_to_le16(base_cq_id);
+	req->hdr_buffer_size     = cpu_to_le16(header_buffer_size);
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
+	dma_free_coherent(&sli4->pcidev->dev, q->dma.size,
+			  q->dma.virt, q->dma.phys);
+	memset(&q->dma, 0, sizeof(struct efc_dma));
+}
+
+int
+__sli_queue_init(struct sli4 *sli4, struct sli4_queue *q,
+		 u32 qtype, size_t size, u32 n_entries,
+		      u32 align)
+{
+	if (!q->dma.virt || size != q->size ||
+	    n_entries != q->length) {
+		if (q->dma.size)
+			__sli_queue_destroy(sli4, q);
+
+		memset(q, 0, sizeof(struct sli4_queue));
+
+		q->dma.size = size * n_entries;
+		q->dma.virt = dma_alloc_coherent(&sli4->pcidev->dev,
+						 q->dma.size, &q->dma.phys,
+						 GFP_DMA);
+		if (!q->dma.virt) {
+			memset(&q->dma, 0, sizeof(struct efc_dma));
+			efc_log_err(sli4, "%s allocation failed\n",
+			       SLI_QNAME[qtype]);
+			return EFC_FAIL;
+		}
+
+		memset(q->dma.virt, 0, size * n_entries);
+
+		spin_lock_init(&q->lock);
+
+		q->type = qtype;
+		q->size = size;
+		q->length = n_entries;
+
+		if (q->type == SLI_QTYPE_EQ || q->type == SLI_QTYPE_CQ) {
+			/* For prism, phase will be flipped after
+			 * a sweep through eq and cq
+			 */
+			q->phase = 1;
+		}
+
+		/* Limit to hwf the queue size per interrupt */
+		q->proc_limit = n_entries / 2;
+
+		switch (q->type) {
+		case SLI_QTYPE_EQ:
+			q->posted_limit = q->length / 2;
+			break;
+		default:
+			q->posted_limit = 64;
+			break;
+		}
+	} else {
+		efc_log_err(sli4, "%s failed\n", __func__);
+		return EFC_FAIL;
+	}
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_fc_rq_alloc(struct sli4 *sli4, struct sli4_queue *q,
+		u32 n_entries, u32 buffer_size,
+		struct sli4_queue *cq, bool is_hdr)
+{
+	if (__sli_queue_init(sli4, q, SLI_QTYPE_RQ, SLI4_RQE_SIZE,
+			     n_entries, SLI_PAGE_SIZE))
+		return EFC_FAIL;
+
+	if (!sli_cmd_rq_create_v1(sli4, sli4->bmbx.virt, SLI4_BMBX_SIZE,
+				  &q->dma, cq->id, buffer_size)) {
+		if (__sli_create_queue(sli4, q)) {
+			efc_log_info(sli4, "Create queue failed %d\n", q->id);
+			goto error;
+		}
+		if (is_hdr && q->id & 1) {
+			efc_log_info(sli4, "bad header RQ_ID %d\n", q->id);
+			goto error;
+		} else if (!is_hdr  && (q->id & 1) == 0) {
+			efc_log_info(sli4, "bad data RQ_ID %d\n", q->id);
+			goto error;
+		}
+	} else {
+		goto error;
+	}
+	if (is_hdr)
+		q->u.flag.dword |= SLI4_QUEUE_FLAG_HDR;
+	else
+		q->u.flag.dword &= ~SLI4_QUEUE_FLAG_HDR;
+	return EFC_SUCCESS;
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
+	struct efc_dma dma;
+	struct sli4_rsp_cmn_create_queue_set *rsp = NULL;
+	void __iomem *db_regaddr = NULL;
+	u32 num_rqs = num_rq_pairs * 2;
+
+	for (i = 0; i < num_rqs; i++) {
+		if (__sli_queue_init(sli4, qs[i], SLI_QTYPE_RQ,
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
+	} else {
+		for (i = 0; i < num_rqs; i++) {
+			qs[i]->id = i + le16_to_cpu(rsp->q_id);
+			if ((qs[i]->id & 1) == 0)
+				qs[i]->u.flag.dword |= SLI4_QUEUE_FLAG_HDR;
+			else
+				qs[i]->u.flag.dword &= ~SLI4_QUEUE_FLAG_HDR;
+
+			qs[i]->db_regaddr = db_regaddr;
+		}
+	}
+
+	dma_free_coherent(&sli4->pcidev->dev, dma.size, dma.virt, dma.phys);
+
+	return EFC_SUCCESS;
+
+error:
+	for (i = 0; i < num_rqs; i++)
+		__sli_queue_destroy(sli4, qs[i]);
+
+	if (dma.virt)
+		dma_free_coherent(&sli4->pcidev->dev, dma.size, dma.virt,
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
+		    MBX_CMD_SLI_CONFIG) {
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
+			SLI_QNAME[q->type]);
+		return EFC_FAIL;
+	}
+	if (sli_res_sli_config(sli4, sli4->bmbx.virt)) {
+		efc_log_err(sli4, "bad status create %s\n",
+		       SLI_QNAME[q->type]);
+		return EFC_FAIL;
+	}
+	res_q = (void *)((u8 *)sli4->bmbx.virt +
+			offsetof(struct sli4_cmd_sli_config, payload));
+
+	if (res_q->hdr.status) {
+		efc_log_err(sli4, "bad create %s status=%#x addl=%#x\n",
+		       SLI_QNAME[q->type], res_q->hdr.status,
+			    res_q->hdr.additional_status);
+		return EFC_FAIL;
+	}
+	q->id = le16_to_cpu(res_q->q_id);
+	switch (q->type) {
+	case SLI_QTYPE_EQ:
+		if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+			q->db_regaddr = sli4->reg[1] + SLI4_IF6_EQ_DB_REG;
+		else
+			q->db_regaddr =	sli4->reg[0] + SLI4_EQCQ_DB_REG;
+		break;
+	case SLI_QTYPE_CQ:
+		if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+			q->db_regaddr = sli4->reg[1] + SLI4_IF6_CQ_DB_REG;
+		else
+			q->db_regaddr =	sli4->reg[0] + SLI4_EQCQ_DB_REG;
+		break;
+	case SLI_QTYPE_MQ:
+		if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+			q->db_regaddr = sli4->reg[1] + SLI4_IF6_MQ_DB_REG;
+		else
+			q->db_regaddr =	sli4->reg[0] + SLI4_MQ_DB_REG;
+		break;
+	case SLI_QTYPE_RQ:
+		if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+			q->db_regaddr = sli4->reg[1] + SLI4_IF6_RQ_DB_REG;
+		else
+			q->db_regaddr =	sli4->reg[0] + SLI4_RQ_DB_REG;
+		break;
+	case SLI_QTYPE_WQ:
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
+	case SLI_QTYPE_EQ:
+		size = sizeof(u32);
+		break;
+	case SLI_QTYPE_CQ:
+		size = 16;
+		break;
+	case SLI_QTYPE_MQ:
+		size = 256;
+		break;
+	case SLI_QTYPE_WQ:
+		size = sli4->wqe_size;
+		break;
+	case SLI_QTYPE_RQ:
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
+	if (__sli_queue_init(sli4, q, qtype, size, n_entries, align)) {
+		efc_log_err(sli4, "%s allocation failed\n",
+		       SLI_QNAME[qtype]);
+		return EFC_FAIL;
+	}
+
+	switch (qtype) {
+	case SLI_QTYPE_EQ:
+		if (!sli_cmd_common_create_eq(sli4, sli4->bmbx.virt,
+					     SLI4_BMBX_SIZE, &q->dma)) {
+			if (__sli_create_queue(sli4, q)) {
+				efc_log_err(sli4, "create %s failed\n",
+					    SLI_QNAME[qtype]);
+				goto error;
+			}
+		} else {
+			efc_log_err(sli4, "cannot create %s\n",
+				    SLI_QNAME[qtype]);
+			goto error;
+		}
+
+		break;
+	case SLI_QTYPE_CQ:
+		if (!sli_cmd_common_create_cq(sli4, sli4->bmbx.virt,
+					     SLI4_BMBX_SIZE, &q->dma,
+						assoc ? assoc->id : 0)) {
+			if (__sli_create_queue(sli4, q)) {
+				efc_log_err(sli4, "create %s failed\n",
+					    SLI_QNAME[qtype]);
+				goto error;
+			}
+		} else {
+			efc_log_err(sli4, "cannot create %s\n",
+				    SLI_QNAME[qtype]);
+			goto error;
+		}
+		break;
+	case SLI_QTYPE_MQ:
+		assoc->u.flag.dword |= SLI4_QUEUE_FLAG_MQ;
+		if (!sli_cmd_common_create_mq_ext(sli4, sli4->bmbx.virt,
+						  SLI4_BMBX_SIZE, &q->dma,
+						  assoc->id)) {
+			if (__sli_create_queue(sli4, q)) {
+				efc_log_err(sli4, "create %s failed\n",
+					    SLI_QNAME[qtype]);
+				goto error;
+			}
+		} else {
+			efc_log_err(sli4, "cannot create %s\n",
+				    SLI_QNAME[qtype]);
+			goto error;
+		}
+
+		break;
+	case SLI_QTYPE_WQ:
+		if (!sli_cmd_wq_create(sli4, sli4->bmbx.virt,
+					 SLI4_BMBX_SIZE, &q->dma,
+					assoc ? assoc->id : 0)) {
+			if (__sli_create_queue(sli4, q)) {
+				efc_log_err(sli4, "create %s failed\n",
+					    SLI_QNAME[qtype]);
+				goto error;
+			}
+		} else {
+			efc_log_err(sli4, "cannot create %s\n",
+				    SLI_QNAME[qtype]);
+			goto error;
+		}
+		break;
+	default:
+		efc_log_info(sli4, "unknown queue type %d\n", qtype);
+		goto error;
+	}
+
+	return EFC_SUCCESS;
+error:
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
+	payload_size = max(CFG_RQST_CMDSZ(cmn_create_cq_set_v0) +
+			   (SZ_DMAADDR * num_pages_cq * num_cqs),
+			   sizeof(struct sli4_rsp_cmn_create_queue_set));
+
+	dma->size = payload_size;
+	dma->virt = dma_alloc_coherent(&sli4->pcidev->dev, dma->size,
+				      &dma->phys, GFP_DMA);
+	if (!dma->virt)
+		return EFC_FAIL;
+
+	memset(dma->virt, 0, payload_size);
+
+	req = sli_config_cmd_init(sli4, sli4->bmbx.virt, SLI4_BMBX_SIZE,
+				  payload_size, dma);
+	if (!req)
+		return EFC_FAIL;
+
+	req_len = CFG_RQST_PYLD_LEN_VAR(cmn_create_cq_set_v0,
+					SZ_DMAADDR * num_pages_cq * num_cqs);
+	sli_cmd_fill_hdr(&req->hdr, CMN_CREATE_CQ_SET, SLI4_SUBSYSTEM_FC,
+			 CMD_V0, req_len);
+	req->page_size = page_size;
+
+	req->num_pages = cpu_to_le16(num_pages_cq);
+	switch (num_pages_cq) {
+	case 1:
+		dw5_flags |= CQ_CNT_VAL(256);
+		break;
+	case 2:
+		dw5_flags |= CQ_CNT_VAL(512);
+		break;
+	case 4:
+		dw5_flags |= CQ_CNT_VAL(1024);
+		break;
+	case 8:
+		dw5_flags |= CQ_CNT_VAL(LARGE);
+		dw6w1_flags |= (n_cqe & CREATE_CQSETV0_CQE_COUNT);
+		break;
+	default:
+		efc_log_info(sli4, "num_pages %d not valid\n", num_pages_cq);
+		return EFC_FAIL;
+	}
+
+	dw5_flags |= CREATE_CQSETV0_EVT;
+	dw5_flags |= CREATE_CQSETV0_VALID;
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+		dw5_flags |= CREATE_CQSETV0_AUTOVALID;
+
+	dw6w1_flags &= (~CREATE_CQSETV0_ARM);
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
+	struct efc_dma dma;
+	struct sli4_rsp_cmn_create_queue_set *res = NULL;
+	void __iomem *db_regaddr = NULL;
+
+	/* Align the queue DMA memory */
+	for (i = 0; i < num_cqs; i++) {
+		if (__sli_queue_init(sli4, qs[i], SLI_QTYPE_CQ,
+				     SLI4_CQE_BYTES,
+					  n_entries, SLI_PAGE_SIZE)) {
+			efc_log_err(sli4, "Queue init failed.\n");
+			goto error;
+		}
+	}
+
+	if (sli_cmd_cq_set_create(sli4, qs, num_cqs, eqs, &dma))
+		goto error;
+
+	if (sli_bmbx_command(sli4)) {
+		efc_log_crit(sli4, "bootstrap mailbox write fail CQSet\n");
+		goto error;
+	}
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
+	} else {
+		/* Check if we got all requested CQs. */
+		if (le16_to_cpu(res->num_q_allocated) != num_cqs) {
+			efc_log_crit(sli4, "Requested count CQs doesn't match.\n");
+			goto error;
+		}
+		/* Fill the resp cq ids. */
+		for (i = 0; i < num_cqs; i++) {
+			qs[i]->id = le16_to_cpu(res->q_id) + i;
+			qs[i]->db_regaddr = db_regaddr;
+		}
+	}
+
+	dma_free_coherent(&sli4->pcidev->dev, dma.size, dma.virt, dma.phys);
+
+	return EFC_SUCCESS;
+
+error:
+	for (i = 0; i < num_cqs; i++)
+		__sli_queue_destroy(sli4, qs[i]);
+
+	if (dma.virt)
+		dma_free_coherent(&sli4->pcidev->dev, dma.size, dma.virt,
+				  dma.phys);
+
+	return EFC_FAIL;
+}
+
+static int
+sli_cmd_common_destroy_q(struct sli4 *sli4, u8 opc, u8 subsystem, u16 q_id)
+{
+	struct sli4_rqst_cmn_destroy_q *req = NULL;
+
+	/* Payload length must accommodate both request and response */
+	req = sli_config_cmd_init(sli4, sli4->bmbx.virt, SLI4_BMBX_SIZE,
+				  SLI_CONFIG_PYLD_LENGTH(cmn_destroy_q), NULL);
+	if (!req)
+		return EFC_FAIL;
+
+	sli_cmd_fill_hdr(&req->hdr, opc, subsystem,
+			 CMD_V0, CFG_RQST_PYLD_LEN(cmn_destroy_q));
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
+	case SLI_QTYPE_EQ:
+		opcode = CMN_DESTROY_EQ;
+		subsystem = SLI4_SUBSYSTEM_COMMON;
+		break;
+	case SLI_QTYPE_CQ:
+		opcode = CMN_DESTROY_CQ;
+		subsystem = SLI4_SUBSYSTEM_COMMON;
+		break;
+	case SLI_QTYPE_MQ:
+		opcode = CMN_DESTROY_MQ;
+		subsystem = SLI4_SUBSYSTEM_COMMON;
+		break;
+	case SLI_QTYPE_WQ:
+		opcode = SLI4_OPC_WQ_DESTROY;
+		subsystem = SLI4_SUBSYSTEM_FC;
+		break;
+	case SLI_QTYPE_RQ:
+		opcode = SLI4_OPC_RQ_DESTROY;
+		subsystem = SLI4_SUBSYSTEM_FC;
+		break;
+	default:
+		efc_log_info(sli4, "bad queue type %d\n", q->type);
+		return EFC_FAIL;
+	}
+
+	rc = sli_cmd_common_destroy_q(sli4, opcode, subsystem, q->id);
+	if (!rc)
+		goto free_mem;
+
+	if (sli_bmbx_command(sli4)) {
+		efc_log_crit(sli4, "bootstrap mailbox fail destroy %s\n",
+			     SLI_QNAME[q->type]);
+	} else if (sli_res_sli_config(sli4, sli4->bmbx.virt)) {
+		efc_log_err(sli4, "bad status %s\n", SLI_QNAME[q->type]);
+	} else {
+		res = (void *)((u8 *)sli4->bmbx.virt +
+				offsetof(struct sli4_cmd_sli_config, payload));
+
+		if (res->status) {
+			efc_log_err(sli4, "destroy %s st=%#x addl=%#x\n",
+				    SLI_QNAME[q->type],	res->status,
+				    res->additional_status);
+		} else {
+			rc = EFC_SUCCESS;
+		}
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
+	u32 val = 0;
+	unsigned long flags = 0;
+	u32 a = arm ? SLI4_EQCQ_ARM : SLI4_EQCQ_UNARM;
+
+	spin_lock_irqsave(&q->lock, flags);
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+		val = SLI4_IF6_EQ_DOORBELL(q->n_posted, q->id, a);
+	else
+		val = SLI4_EQ_DOORBELL(q->n_posted, q->id, a);
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
+	case SLI_QTYPE_EQ:
+		if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+			val = SLI4_IF6_EQ_DOORBELL(q->n_posted, q->id, a);
+		else
+			val = SLI4_EQ_DOORBELL(q->n_posted, q->id, a);
+
+		writel(val, q->db_regaddr);
+		q->n_posted = 0;
+		break;
+	case SLI_QTYPE_CQ:
+		if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+			val = SLI4_IF6_CQ_DOORBELL(q->n_posted, q->id, a);
+		else
+			val = SLI4_CQ_DOORBELL(q->n_posted, q->id, a);
+
+		writel(val, q->db_regaddr);
+		q->n_posted = 0;
+		break;
+	default:
+		efc_log_info(sli4, "should only be used for EQ/CQ, not %s\n",
+			SLI_QNAME[q->type]);
+	}
+
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_wq_write(struct sli4 *sli4, struct sli4_queue *q,
+	     u8 *entry)
+{
+	u8		*qe = q->dma.virt;
+	u32	qindex;
+	u32	val = 0;
+
+	qindex = q->index;
+	qe += q->index * q->size;
+
+	if (sli4->perf_wq_id_association)
+		sli_set_wq_id_association(entry, q->id);
+
+	memcpy(qe, entry, q->size);
+	q->n_posted = 1;
+
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
+		/* non-dpp write for iftype = 6 */
+		val = SLI4_WQ_DOORBELL(q->n_posted, 0, q->id);
+	else
+		val = SLI4_WQ_DOORBELL(q->n_posted, q->index, q->id);
+
+	writel(val, q->db_regaddr);
+	q->index = (q->index + q->n_posted) & (q->length - 1);
+	q->n_posted = 0;
+
+	return qindex;
+}
+
+int
+sli_mq_write(struct sli4 *sli4, struct sli4_queue *q,
+	     u8 *entry)
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
+	q->n_posted = 1;
+
+	val = SLI4_MQ_DOORBELL(q->n_posted, q->id);
+	writel(val, q->db_regaddr);
+	q->index = (q->index + q->n_posted) & (q->length - 1);
+	q->n_posted = 0;
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return qindex;
+}
+
+int
+sli_rq_write(struct sli4 *sli4, struct sli4_queue *q,
+	     u8 *entry)
+{
+	u8 *qe = q->dma.virt;
+	u32 qindex, n_posted;
+	u32 val = 0;
+
+	qindex = q->index;
+	qe += q->index * q->size;
+
+	memcpy(qe, entry, q->size);
+	q->n_posted = 1;
+
+	n_posted = q->n_posted;
+
+	/*
+	 * In RQ-pair, an RQ either contains the FC header
+	 * (i.e. is_hdr == TRUE) or the payload.
+	 *
+	 * Don't ring doorbell for payload RQ
+	 */
+	if (!(q->u.flag.dword & SLI4_QUEUE_FLAG_HDR))
+		goto skip;
+
+	/*
+	 * Some RQ cannot be incremented one entry at a time.
+	 * Instead, the driver collects a number of entries
+	 * and updates the RQ in batches.
+	 */
+	if (q->u.flag.dword & SLI4_QUEUE_FLAG_RQBATCH) {
+		if (((q->index + q->n_posted) %
+		    SLI4_QUEUE_RQ_BATCH)) {
+			goto skip;
+		}
+		n_posted = SLI4_QUEUE_RQ_BATCH;
+	}
+
+	val = SLI4_RQ_DOORBELL(n_posted, q->id);
+	writel(val, q->db_regaddr);
+skip:
+	q->index = (q->index + q->n_posted) & (q->length - 1);
+	q->n_posted = 0;
+
+	return qindex;
+}
+
+int
+sli_eq_read(struct sli4 *sli4,
+	    struct sli4_queue *q, u8 *entry)
+{
+	u8 *qe = q->dma.virt;
+	u32 *qindex = NULL;
+	unsigned long flags = 0;
+	u8 clear = false, valid = false;
+	u16 wflags = 0;
+
+	clear = (sli4->if_type == SLI4_INTF_IF_TYPE_6) ?  false : true;
+
+	qindex = &q->index;
+
+	spin_lock_irqsave(&q->lock, flags);
+
+	qe += *qindex * q->size;
+
+	/* Check if eqe is valid */
+	wflags = le16_to_cpu(((struct sli4_eqe *)qe)->dw0w0_flags);
+	valid = ((wflags & SLI4_EQE_VALID) == q->phase);
+	if (!valid) {
+		spin_unlock_irqrestore(&q->lock, flags);
+		return EFC_FAIL;
+	}
+
+	if (valid && clear) {
+		wflags &= ~SLI4_EQE_VALID;
+		((struct sli4_eqe *)qe)->dw0w0_flags =
+						cpu_to_le16(wflags);
+	}
+
+	memcpy(entry, qe, q->size);
+	*qindex = (*qindex + 1) & (q->length - 1);
+	q->n_posted++;
+	/*
+	 * For prism, the phase value will be used
+	 * to check the validity of eq/cq entries.
+	 * The value toggles after a complete sweep
+	 * through the queue.
+	 */
+
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6 && *qindex == 0)
+		q->phase ^= (u16)0x1;
+
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cq_read(struct sli4 *sli4,
+	    struct sli4_queue *q, u8 *entry)
+{
+	u8 *qe = q->dma.virt;
+	u32 *qindex = NULL;
+	unsigned long	flags = 0;
+	u8 clear = false;
+	u32 dwflags = 0;
+	bool valid = false, valid_bit_set = false;
+
+	clear = (sli4->if_type == SLI4_INTF_IF_TYPE_6) ?  false : true;
+
+	qindex = &q->index;
+
+	spin_lock_irqsave(&q->lock, flags);
+
+	qe += *qindex * q->size;
+
+	/* Check if cqe is valid */
+	dwflags = le32_to_cpu(((struct sli4_mcqe *)qe)->dw3_flags);
+	valid_bit_set = (dwflags & SLI4_MCQE_VALID) != 0;
+
+	valid = (valid_bit_set == q->phase);
+	if (!valid) {
+		spin_unlock_irqrestore(&q->lock, flags);
+		return EFC_FAIL;
+	}
+
+	if (valid && clear) {
+		dwflags &= ~SLI4_MCQE_VALID;
+		((struct sli4_mcqe *)qe)->dw3_flags =
+					cpu_to_le32(dwflags);
+	}
+
+	memcpy(entry, qe, q->size);
+	*qindex = (*qindex + 1) & (q->length - 1);
+	q->n_posted++;
+	/*
+	 * For prism, the phase value will be used
+	 * to check the validity of eq/cq entries.
+	 * The value toggles after a complete sweep
+	 * through the queue.
+	 */
+
+	if (sli4->if_type == SLI4_INTF_IF_TYPE_6 && *qindex == 0)
+		q->phase ^= (u16)0x1;
+
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_mq_read(struct sli4 *sli4,
+	    struct sli4_queue *q, u8 *entry)
+{
+	u8 *qe = q->dma.virt;
+	u32 *qindex = NULL;
+	unsigned long flags = 0;
+
+	qindex = &q->u.r_idx;
+
+	spin_lock_irqsave(&q->lock, flags);
+
+	qe += *qindex * q->size;
+
+	/* Check if mqe is valid */
+	if (q->index == q->u.r_idx) {
+		spin_unlock_irqrestore(&q->lock, flags);
+		return EFC_FAIL;
+	}
+
+	memcpy(entry, qe, q->size);
+	*qindex = (*qindex + 1) & (q->length - 1);
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
+/* Parse a CQ entry to retrieve the event type and the associated queue */
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
+	if (cq->u.flag.dword & SLI4_QUEUE_FLAG_MQ) {
+		struct sli4_mcqe	*mcqe = (void *)cqe;
+
+		if (le32_to_cpu(mcqe->dw3_flags) & SLI4_MCQE_AE) {
+			*etype = SLI_QENTRY_ASYNC;
+		} else {
+			*etype = SLI_QENTRY_MQ;
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
index b360d809f144..13f5a0d8d31c 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.h
+++ b/drivers/scsi/elx/libefc_sli/sli4.h
@@ -3687,4 +3687,13 @@ struct sli4 {
 	u32			vpd_length;
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
2.16.4


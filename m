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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9649C2D0C8
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9616A2146E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JUTrIA5T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfLTWhm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:37:42 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45725 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbfLTWhl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:37:41 -0500
Received: by mail-pl1-f196.google.com with SMTP id b22so4698934pls.12
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=B1aQ3xzX1zp9pBk0oJ4jaz1LBKrGmdCbkd7hn7JntqA=;
        b=JUTrIA5T7rC3Vx4X0dfm7bwVmXjBDwyClaOtAno48Az2YwdmxWP6b+OraOMkQOV6BV
         slAXibBHxYaZYULJ104RFvHnJYTKQraIzIGZb0Bg/WP7KxKsSi5EStdk1uaBPl5Dc7tD
         gwHZZ2qAhoM8PbkMRSTVLcXDWFn8jc5MwagX3Ni4u8ex+lzw64yckVOs3bqcDr/RbuJU
         J0OLAxxEzpnje9KYS2YwApra5Nf7pvW7SNsj+x9Q75gosmSI1sELAp0B/KOipSyJW1gJ
         Nx3uAdhhqQcTJo25fuuD6mW30wvOURRiVccMHNg9wAwfKCPXqX7DZlm5iwzij4P9eIhf
         IN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=B1aQ3xzX1zp9pBk0oJ4jaz1LBKrGmdCbkd7hn7JntqA=;
        b=Xg8kl4oHtgG8JJjtSpYPc/lmfTIUbRa93RD0jJ2BPfsaf0PBHLtF2ezu2MEXplrdGX
         IBHDgRj+DzXA5v+bT86HWoGRaNwiCH5RaE08DQShaw/qPlsgDrTqeITuDW/WrDPnP8BP
         UIkh9WREOU0ahrs4sN1Clrnz8vOr4caKJBTM1KT+G0WcRXPk6nRvSbk1/AMaEVNhwPSd
         eCX1BzvJYf8JIZdaQCgLb7G4g3lW444hykl0mFmRrtFlEM+aAG9m+rpzJFtMLCLUivBE
         Eti2+Pa1XvEwqWFmBhFhJvA/EBJDhwMzVEsGJA6rcBiKZFSClYdv4tgupT19vsFsGFwY
         52fw==
X-Gm-Message-State: APjAAAVPHZvh2Ha1QuG7tcq3MRTWYJbs3TQhHA47PutvaFe7Thjn6KYK
        LUChixMlo6b2Oq2ZobquwVyp6jfz
X-Google-Smtp-Source: APXvYqwUEPsNYr6rZpMB23Axn+qhuBA+jmCn25+ocrfRtgS6KsAgcxfiRNxfSLehm4hpSmSjT8h2eg==
X-Received: by 2002:a17:902:bb93:: with SMTP id m19mr17641328pls.37.1576881459524;
        Fri, 20 Dec 2019 14:37:39 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.37.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:37:38 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 07/32] elx: libefc_sli: APIs to setup SLI library
Date:   Fri, 20 Dec 2019 14:36:58 -0800
Message-Id: <20191220223723.26563-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191220223723.26563-1-jsmart2021@gmail.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the libefc_sli SLI-4 library population.

This patch adds APIS to initialize the library, initialize
the SLI Port, reset firmware, terminate the SLI Port, and
terminate the library.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/libefc_sli/sli4.c | 1222 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc_sli/sli4.h |  552 +++++++++++++++-
 2 files changed, 1773 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
index 3cdabb917df6..e2bea34b445a 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.c
+++ b/drivers/scsi/elx/libefc_sli/sli4.c
@@ -4524,3 +4524,1225 @@ sli_cqe_async(struct sli4 *sli4, void *buf)
 
 	return rc;
 }
+
+/* Determine if the chip FW is in a ready state */
+int
+sli_fw_ready(struct sli4 *sli4)
+{
+	u32 val;
+	/*
+	 * Is firmware ready for operation? Check needed depends on IF_TYPE
+	 */
+	val = sli_reg_read_status(sli4);
+	return (val & SLI4_PORT_STATUS_RDY) ? 1 : 0;
+}
+
+static int
+sli_sliport_reset(struct sli4 *sli4)
+{
+	u32 iter, val;
+	int rc = -1;
+
+	val = SLI4_PORT_CTRL_IP;
+	/* Initialize port, endian */
+	writel(val, (sli4->reg[0] + SLI4_PORT_CTRL_REG));
+
+	for (iter = 0; iter < 3000; iter++) {
+		mdelay(10);	/* 10 ms */
+		if (sli_fw_ready(sli4) == 1) {
+			rc = 0;
+			break;
+		}
+	}
+
+	if (rc != 0)
+		efc_log_crit(sli4, "port failed to become ready after initialization\n");
+
+	return rc;
+}
+
+static bool
+sli_wait_for_fw_ready(struct sli4 *sli4, u32 timeout_ms)
+{
+	u32 iter = timeout_ms / (SLI4_INIT_PORT_DELAY_US / 1000);
+	bool ready = false;
+
+	do {
+		iter--;
+		mdelay(10);	/* 10 ms */
+		if (sli_fw_ready(sli4) == 1)
+			ready = true;
+	} while (!ready && (iter > 0));
+
+	return ready;
+}
+
+static int
+sli_fw_init(struct sli4 *sli4)
+{
+	bool ready;
+
+	/*
+	 * Is firmware ready for operation?
+	 */
+	ready = sli_wait_for_fw_ready(sli4, SLI4_FW_READY_TIMEOUT_MSEC);
+	if (!ready) {
+		efc_log_crit(sli4, "FW status is NOT ready\n");
+		return -1;
+	}
+
+	/*
+	 * Reset port to a known state
+	 */
+	if (sli_sliport_reset(sli4))
+		return -1;
+
+	return 0;
+}
+
+static int
+sli_fw_term(struct sli4 *sli4)
+{
+	/* type 2 etc. use SLIPORT_CONTROL to initialize port */
+	sli_sliport_reset(sli4);
+	return 0;
+}
+
+static int
+sli_request_features(struct sli4 *sli4, u32 *features, bool query)
+{
+	if (!sli_cmd_request_features(sli4, sli4->bmbx.virt, SLI4_BMBX_SIZE,
+				     *features, query)) {
+		struct sli4_cmd_request_features *req_features =
+							sli4->bmbx.virt;
+
+		if (sli_bmbx_command(sli4)) {
+			efc_log_crit(sli4, "%s: bootstrap mailbox write fail\n",
+				__func__);
+			return -1;
+		}
+		if (le16_to_cpu(req_features->hdr.status)) {
+			efc_log_err(sli4, "REQUEST_FEATURES bad status %#x\n",
+			       le16_to_cpu(req_features->hdr.status));
+			return -1;
+		}
+		*features = le32_to_cpu(req_features->resp);
+	} else {
+		efc_log_err(sli4, "bad REQUEST_FEATURES write\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+void
+sli_calc_max_qentries(struct sli4 *sli4)
+{
+	enum sli4_qtype q;
+	u32 qentries;
+
+	for (q = SLI_QTYPE_EQ; q < SLI_QTYPE_MAX; q++) {
+		sli4->qinfo.max_qentries[q] =
+			sli_convert_mask_to_count(sli4->qinfo.count_method[q],
+						  sli4->qinfo.count_mask[q]);
+	}
+
+	/* single, continguous DMA allocations will be called for each queue
+	 * of size (max_qentries * queue entry size); since these can be large,
+	 * check against the OS max DMA allocation size
+	 */
+	for (q = SLI_QTYPE_EQ; q < SLI_QTYPE_MAX; q++) {
+		qentries = sli4->qinfo.max_qentries[q];
+
+		efc_log_info(sli4, "[%s]: max_qentries from %d to %d\n",
+			     SLI_QNAME[q],
+			     sli4->qinfo.max_qentries[q], qentries);
+		sli4->qinfo.max_qentries[q] = qentries;
+	}
+}
+
+static int
+sli_get_config(struct sli4 *sli4)
+{
+	struct efc_dma data;
+	u32 psize;
+
+	/*
+	 * Read the device configuration
+	 */
+	if (!sli_cmd_read_config(sli4, sli4->bmbx.virt, SLI4_BMBX_SIZE)) {
+		struct sli4_rsp_read_config	*read_config = sli4->bmbx.virt;
+		u32 i;
+		u32 total, total_size;
+
+		if (sli_bmbx_command(sli4)) {
+			efc_log_crit(sli4, "bootstrap mailbox fail (READ_CONFIG)\n");
+			return -1;
+		}
+		if (le16_to_cpu(read_config->hdr.status)) {
+			efc_log_err(sli4, "READ_CONFIG bad status %#x\n",
+			       le16_to_cpu(read_config->hdr.status));
+			return -1;
+		}
+
+		sli4->has_extents =
+			le32_to_cpu(read_config->ext_dword) &
+				    SLI4_READ_CFG_RESP_RESOURCE_EXT;
+		if (!sli4->has_extents) {
+			u32	i = 0, size = 0;
+			u32	*base = sli4->extent[0].base;
+
+			if (!base) {
+				size = SLI_RSRC_MAX * sizeof(u32);
+				base = kzalloc(size, GFP_ATOMIC);
+				if (!base)
+					return -1;
+
+				memset(base, 0,
+				       SLI_RSRC_MAX * sizeof(u32));
+			}
+
+			for (i = 0; i < SLI_RSRC_MAX; i++) {
+				sli4->extent[i].number = 1;
+				sli4->extent[i].n_alloc = 0;
+				sli4->extent[i].base = &base[i];
+			}
+
+			sli4->extent[SLI_RSRC_VFI].base[0] =
+				le16_to_cpu(read_config->vfi_base);
+			sli4->extent[SLI_RSRC_VFI].size =
+				le16_to_cpu(read_config->vfi_count);
+
+			sli4->extent[SLI_RSRC_VPI].base[0] =
+				le16_to_cpu(read_config->vpi_base);
+			sli4->extent[SLI_RSRC_VPI].size =
+				le16_to_cpu(read_config->vpi_count);
+
+			sli4->extent[SLI_RSRC_RPI].base[0] =
+				le16_to_cpu(read_config->rpi_base);
+			sli4->extent[SLI_RSRC_RPI].size =
+				le16_to_cpu(read_config->rpi_count);
+
+			sli4->extent[SLI_RSRC_XRI].base[0] =
+				le16_to_cpu(read_config->xri_base);
+			sli4->extent[SLI_RSRC_XRI].size =
+				le16_to_cpu(read_config->xri_count);
+
+			sli4->extent[SLI_RSRC_FCFI].base[0] = 0;
+			sli4->extent[SLI_RSRC_FCFI].size =
+				le16_to_cpu(read_config->fcfi_count);
+		}
+
+		for (i = 0; i < SLI_RSRC_MAX; i++) {
+			total = sli4->extent[i].number *
+				sli4->extent[i].size;
+			total_size = BITS_TO_LONGS(total) * sizeof(long);
+			sli4->extent[i].use_map =
+				kzalloc(total_size, GFP_ATOMIC);
+			if (!sli4->extent[i].use_map) {
+				efc_log_err(sli4, "bitmap memory allocation failed %d\n",
+				       i);
+				return -1;
+			}
+			sli4->extent[i].map_size = total;
+		}
+
+		sli4->topology =
+				(le32_to_cpu(read_config->topology_dword) &
+				 SLI4_READ_CFG_RESP_TOPOLOGY) >> 24;
+		switch (sli4->topology) {
+		case SLI4_READ_CFG_TOPO_FC:
+			efc_log_info(sli4, "FC (unknown)\n");
+			break;
+		case SLI4_READ_CFG_TOPO_FC_DA:
+			efc_log_info(sli4, "FC (direct attach)\n");
+			break;
+		case SLI4_READ_CFG_TOPO_FC_AL:
+			efc_log_info(sli4, "FC (arbitrated loop)\n");
+			break;
+		default:
+			efc_log_info(sli4, "bad topology %#x\n",
+				sli4->topology);
+		}
+
+		sli4->e_d_tov = le16_to_cpu(read_config->e_d_tov);
+		sli4->r_a_tov = le16_to_cpu(read_config->r_a_tov);
+
+		sli4->link_module_type = le16_to_cpu(read_config->lmt);
+
+		sli4->qinfo.max_qcount[SLI_QTYPE_EQ] =
+				le16_to_cpu(read_config->eq_count);
+		sli4->qinfo.max_qcount[SLI_QTYPE_CQ] =
+				le16_to_cpu(read_config->cq_count);
+		sli4->qinfo.max_qcount[SLI_QTYPE_WQ] =
+				le16_to_cpu(read_config->wq_count);
+		sli4->qinfo.max_qcount[SLI_QTYPE_RQ] =
+				le16_to_cpu(read_config->rq_count);
+
+		/*
+		 * READ_CONFIG doesn't give the max number of MQ. Applications
+		 * will typically want 1, but we may need another at some future
+		 * date. Dummy up a "max" MQ count here.
+		 */
+		sli4->qinfo.max_qcount[SLI_QTYPE_MQ] = SLI_USER_MQ_COUNT;
+	} else {
+		efc_log_err(sli4, "bad READ_CONFIG write\n");
+		return -1;
+	}
+
+	if (!sli_cmd_common_get_sli4_parameters(sli4, sli4->bmbx.virt,
+					       SLI4_BMBX_SIZE)) {
+		struct sli4_rsp_cmn_get_sli4_params	*parms =
+			(struct sli4_rsp_cmn_get_sli4_params *)
+			(((u8 *)sli4->bmbx.virt) +
+			offsetof(struct sli4_cmd_sli_config, payload.embed));
+		u32 dwflags_loopback;
+		u32 dwflags_eq_page_cnt;
+		u32 dwflags_cq_page_cnt;
+		u32 dwflags_mq_page_cnt;
+		u32 dwflags_wq_page_cnt;
+		u32 dwflags_rq_page_cnt;
+		u32 dwflags_sgl_page_cnt;
+
+		if (sli_bmbx_command(sli4)) {
+			efc_log_crit(sli4, "%s: bootstrap mailbox write fail\n",
+				__func__);
+			return -1;
+		} else if (parms->hdr.status) {
+			efc_log_err(sli4, "COMMON_GET_SLI4_PARAMETERS bad status %#x",
+			       parms->hdr.status);
+			efc_log_err(sli4, "additional status %#x\n",
+			       parms->hdr.additional_status);
+			return -1;
+		}
+
+		dwflags_loopback = le32_to_cpu(parms->dw16_loopback_scope);
+		dwflags_eq_page_cnt = le32_to_cpu(parms->dw6_eq_page_cnt);
+		dwflags_cq_page_cnt = le32_to_cpu(parms->dw8_cq_page_cnt);
+		dwflags_mq_page_cnt = le32_to_cpu(parms->dw10_mq_page_cnt);
+		dwflags_wq_page_cnt = le32_to_cpu(parms->dw12_wq_page_cnt);
+		dwflags_rq_page_cnt = le32_to_cpu(parms->dw14_rq_page_cnt);
+
+		sli4->auto_reg =
+			(dwflags_loopback & RSP_GET_PARAM_AREG);
+		sli4->auto_xfer_rdy =
+			(dwflags_loopback & RSP_GET_PARAM_AGXF);
+		sli4->hdr_template_req =
+			(dwflags_loopback & RSP_GET_PARAM_HDRR);
+		sli4->t10_dif_inline_capable =
+			(dwflags_loopback & RSP_GET_PARAM_TIMM);
+		sli4->t10_dif_separate_capable =
+			(dwflags_loopback & RSP_GET_PARAM_TSMM);
+
+		sli4->mq_create_version =
+				GET_Q_CREATE_VERSION(dwflags_mq_page_cnt);
+		sli4->cq_create_version =
+				GET_Q_CREATE_VERSION(dwflags_cq_page_cnt);
+
+		sli4->rq_min_buf_size =
+			le16_to_cpu(parms->min_rq_buffer_size);
+		sli4->rq_max_buf_size =
+			le32_to_cpu(parms->max_rq_buffer_size);
+
+		sli4->qinfo.qpage_count[SLI_QTYPE_EQ] =
+			(dwflags_eq_page_cnt & RSP_GET_PARAM_EQ_PAGE_CNT_MASK);
+		sli4->qinfo.qpage_count[SLI_QTYPE_CQ] =
+			(dwflags_cq_page_cnt & RSP_GET_PARAM_CQ_PAGE_CNT_MASK);
+		sli4->qinfo.qpage_count[SLI_QTYPE_MQ] =
+			(dwflags_mq_page_cnt & RSP_GET_PARAM_MQ_PAGE_CNT_MASK);
+		sli4->qinfo.qpage_count[SLI_QTYPE_WQ] =
+			(dwflags_wq_page_cnt & RSP_GET_PARAM_WQ_PAGE_CNT_MASK);
+		sli4->qinfo.qpage_count[SLI_QTYPE_RQ] =
+			(dwflags_rq_page_cnt & RSP_GET_PARAM_RQ_PAGE_CNT_MASK);
+
+		/* save count methods and masks for each queue type */
+
+		sli4->qinfo.count_mask[SLI_QTYPE_EQ] =
+				le16_to_cpu(parms->eqe_count_mask);
+		sli4->qinfo.count_method[SLI_QTYPE_EQ] =
+				GET_Q_CNT_METHOD(dwflags_eq_page_cnt);
+
+		sli4->qinfo.count_mask[SLI_QTYPE_CQ] =
+				le16_to_cpu(parms->cqe_count_mask);
+		sli4->qinfo.count_method[SLI_QTYPE_CQ] =
+				GET_Q_CNT_METHOD(dwflags_cq_page_cnt);
+
+		sli4->qinfo.count_mask[SLI_QTYPE_MQ] =
+				le16_to_cpu(parms->mqe_count_mask);
+		sli4->qinfo.count_method[SLI_QTYPE_MQ] =
+				GET_Q_CNT_METHOD(dwflags_mq_page_cnt);
+
+		sli4->qinfo.count_mask[SLI_QTYPE_WQ] =
+				le16_to_cpu(parms->wqe_count_mask);
+		sli4->qinfo.count_method[SLI_QTYPE_WQ] =
+				GET_Q_CNT_METHOD(dwflags_wq_page_cnt);
+
+		sli4->qinfo.count_mask[SLI_QTYPE_RQ] =
+				le16_to_cpu(parms->rqe_count_mask);
+		sli4->qinfo.count_method[SLI_QTYPE_RQ] =
+				GET_Q_CNT_METHOD(dwflags_rq_page_cnt);
+
+		/* now calculate max queue entries */
+		sli_calc_max_qentries(sli4);
+
+		dwflags_sgl_page_cnt = le32_to_cpu(parms->dw18_sgl_page_cnt);
+
+		/* max # of pages */
+		sli4->max_sgl_pages =
+				(dwflags_sgl_page_cnt &
+				 RSP_GET_PARAM_SGL_PAGE_CNT_MASK);
+
+		/* bit map of available sizes */
+		sli4->sgl_page_sizes =
+				(dwflags_sgl_page_cnt &
+				 RSP_GET_PARAM_SGL_PAGE_SZS_MASK) >> 8;
+		/* ignore HLM here. Use value from REQUEST_FEATURES */
+		sli4->sge_supported_length =
+				le32_to_cpu(parms->sge_supported_length);
+		sli4->sgl_pre_registration_required =
+			(dwflags_loopback & RSP_GET_PARAM_SGLR);
+		/* default to using pre-registered SGL's */
+		sli4->sgl_pre_registered = true;
+
+		sli4->perf_hint =
+			(dwflags_loopback & RSP_GET_PARAM_PHON);
+		sli4->perf_wq_id_association =
+			(dwflags_loopback & RSP_GET_PARAM_PHWQ);
+
+		sli4->rq_batch =
+			(le16_to_cpu(parms->dw15w1_rq_db_window) &
+			 RSP_GET_PARAM_RQ_DB_WINDOW_MASK) >> 12;
+
+		/* Use the highest available WQE size. */
+		if (((dwflags_wq_page_cnt &
+		    RSP_GET_PARAM_WQE_SZS_MASK) >> 8) &
+		    SLI4_128BYTE_WQE_SUPPORT)
+			sli4->wqe_size = SLI4_WQE_EXT_BYTES;
+		else
+			sli4->wqe_size = SLI4_WQE_BYTES;
+	}
+
+	sli4->port_number = 0;
+
+	/*
+	 * Issue COMMON_GET_CNTL_ATTRIBUTES to get port_number. Temporarily
+	 * uses VPD DMA buffer as the response won't fit in the embedded
+	 * buffer.
+	 */
+	if (!sli_cmd_common_get_cntl_attributes(sli4, sli4->bmbx.virt,
+					       SLI4_BMBX_SIZE,
+					       &sli4->vpd_data)) {
+		struct sli4_rsp_cmn_get_cntl_attributes *attr =
+			sli4->vpd_data.virt;
+
+		if (sli_bmbx_command(sli4)) {
+			efc_log_crit(sli4, "%s: bootstrap mailbox write fail\n",
+				__func__);
+			return -1;
+		} else if (attr->hdr.status) {
+			efc_log_err(sli4, "COMMON_GET_CNTL_ATTRIBUTES bad status %#x",
+			       attr->hdr.status);
+			efc_log_err(sli4, "additional status %#x\n",
+			       attr->hdr.additional_status);
+			return -1;
+		}
+
+		sli4->port_number = (attr->port_num_type_flags &
+					    SLI4_CNTL_ATTR_PORTNUM);
+
+		memcpy(sli4->bios_version_string,
+		       attr->bios_version_str,
+		       sizeof(sli4->bios_version_string));
+	} else {
+		efc_log_err(sli4, "bad COMMON_GET_CNTL_ATTRIBUTES write\n");
+		return -1;
+	}
+
+	psize = sizeof(struct sli4_rsp_cmn_get_cntl_addl_attributes);
+	data.size = psize;
+	data.virt = dma_alloc_coherent(&sli4->pcidev->dev, data.size,
+				       &data.phys, GFP_DMA);
+	if (!data.virt) {
+		memset(&data, 0, sizeof(struct efc_dma));
+		efc_log_err(sli4, "Failed to allocate memory for GET_CNTL_ADDL_ATTR\n");
+	} else {
+		if (!sli_cmd_common_get_cntl_addl_attributes(sli4,
+							    sli4->bmbx.virt,
+							    SLI4_BMBX_SIZE,
+							    &data)) {
+			struct sli4_rsp_cmn_get_cntl_addl_attributes *attr;
+
+			attr = data.virt;
+			if (sli_bmbx_command(sli4)) {
+				efc_log_crit(sli4, "mailbox fail (GET_CNTL_ADDL_ATTR)\n");
+				dma_free_coherent(&sli4->pcidev->dev, data.size,
+						  data.virt, data.phys);
+				return -1;
+			}
+			if (attr->hdr.status) {
+				efc_log_err(sli4, "GET_CNTL_ADDL_ATTR bad status %#x\n",
+				       attr->hdr.status);
+				dma_free_coherent(&sli4->pcidev->dev, data.size,
+						  data.virt, data.phys);
+				return -1;
+			}
+
+			memcpy(sli4->ipl_name, attr->ipl_file_name,
+			       sizeof(sli4->ipl_name));
+
+			efc_log_info(sli4, "IPL:%s\n",
+				(char *)sli4->ipl_name);
+		} else {
+			efc_log_err(sli4, "bad GET_CNTL_ADDL_ATTR write\n");
+			dma_free_coherent(&sli4->pcidev->dev, data.size,
+					  data.virt, data.phys);
+			return -1;
+		}
+
+		dma_free_coherent(&sli4->pcidev->dev, data.size, data.virt,
+				  data.phys);
+		memset(&data, 0, sizeof(struct efc_dma));
+	}
+
+	if (!sli_cmd_common_get_port_name(sli4, sli4->bmbx.virt,
+					 SLI4_BMBX_SIZE)) {
+		struct sli4_rsp_cmn_get_port_name	*port_name =
+			(struct sli4_rsp_cmn_get_port_name *)
+			(((u8 *)sli4->bmbx.virt) +
+			offsetof(struct sli4_cmd_sli_config, payload.embed));
+
+		if (sli_bmbx_command(sli4)) {
+			efc_log_crit(sli4, "%s: bootstrap mailbox write fail\n",
+				__func__);
+			return -1;
+		}
+
+		sli4->port_name[0] =
+			port_name->port_name[sli4->port_number];
+	}
+	sli4->port_name[1] = '\0';
+
+	if (!sli_cmd_read_rev(sli4, sli4->bmbx.virt, SLI4_BMBX_SIZE,
+			     &sli4->vpd_data)) {
+		struct sli4_cmd_read_rev	*read_rev = sli4->bmbx.virt;
+
+		if (sli_bmbx_command(sli4)) {
+			efc_log_crit(sli4, "bootstrap mailbox write fail (READ_REV)\n");
+			return -1;
+		}
+		if (le16_to_cpu(read_rev->hdr.status)) {
+			efc_log_err(sli4, "READ_REV bad status %#x\n",
+			       le16_to_cpu(read_rev->hdr.status));
+			return -1;
+		}
+
+		sli4->fw_rev[0] =
+				le32_to_cpu(read_rev->first_fw_id);
+		memcpy(sli4->fw_name[0], read_rev->first_fw_name,
+		       sizeof(sli4->fw_name[0]));
+
+		sli4->fw_rev[1] =
+				le32_to_cpu(read_rev->second_fw_id);
+		memcpy(sli4->fw_name[1], read_rev->second_fw_name,
+		       sizeof(sli4->fw_name[1]));
+
+		sli4->hw_rev[0] = le32_to_cpu(read_rev->first_hw_rev);
+		sli4->hw_rev[1] = le32_to_cpu(read_rev->second_hw_rev);
+		sli4->hw_rev[2] = le32_to_cpu(read_rev->third_hw_rev);
+
+		efc_log_info(sli4, "FW1:%s (%08x) / FW2:%s (%08x)\n",
+			read_rev->first_fw_name,
+			      le32_to_cpu(read_rev->first_fw_id),
+			      read_rev->second_fw_name,
+			      le32_to_cpu(read_rev->second_fw_id));
+
+		efc_log_info(sli4, "HW1: %08x / HW2: %08x\n",
+			le32_to_cpu(read_rev->first_hw_rev),
+			      le32_to_cpu(read_rev->second_hw_rev));
+
+		/* Check that all VPD data was returned */
+		if (le32_to_cpu(read_rev->returned_vpd_length) !=
+		    le32_to_cpu(read_rev->actual_vpd_length)) {
+			efc_log_info(sli4, "VPD length: avail=%d returned=%d actual=%d\n",
+				le32_to_cpu(read_rev->available_length_dword) &
+					    SLI4_READ_REV_AVAILABLE_LENGTH,
+				le32_to_cpu(read_rev->returned_vpd_length),
+				le32_to_cpu(read_rev->actual_vpd_length));
+		}
+		sli4->vpd_length = le32_to_cpu(read_rev->returned_vpd_length);
+	} else {
+		efc_log_err(sli4, "bad READ_REV write\n");
+		return -1;
+	}
+
+	if (!sli_cmd_read_nvparms(sli4, sli4->bmbx.virt, SLI4_BMBX_SIZE)) {
+		struct sli4_cmd_read_nvparms *read_nvparms = sli4->bmbx.virt;
+
+		if (sli_bmbx_command(sli4)) {
+			efc_log_crit(sli4, "bootstrap mailbox fail (READ_NVPARMS)\n");
+			return -1;
+		}
+		if (le16_to_cpu(read_nvparms->hdr.status)) {
+			efc_log_err(sli4, "READ_NVPARMS bad status %#x\n",
+			       le16_to_cpu(read_nvparms->hdr.status));
+			return -1;
+		}
+
+		memcpy(sli4->wwpn, read_nvparms->wwpn,
+		       sizeof(sli4->wwpn));
+		memcpy(sli4->wwnn, read_nvparms->wwnn,
+		       sizeof(sli4->wwnn));
+
+		efc_log_info(sli4, "WWPN %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+			sli4->wwpn[0],
+			      sli4->wwpn[1],
+			      sli4->wwpn[2],
+			      sli4->wwpn[3],
+			      sli4->wwpn[4],
+			      sli4->wwpn[5],
+			      sli4->wwpn[6],
+			      sli4->wwpn[7]);
+		efc_log_info(sli4, "WWNN %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x\n",
+			sli4->wwnn[0],
+			      sli4->wwnn[1],
+			      sli4->wwnn[2],
+			      sli4->wwnn[3],
+			      sli4->wwnn[4],
+			      sli4->wwnn[5],
+			      sli4->wwnn[6],
+			      sli4->wwnn[7]);
+	} else {
+		efc_log_err(sli4, "bad READ_NVPARMS write\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+int
+sli_setup(struct sli4 *sli4, void *os, struct pci_dev  *pdev,
+	  void __iomem *reg[])
+{
+	u32 intf = U32_MAX;
+	u32 pci_class_rev = 0;
+	u32 rev_id = 0;
+	u32 family = 0;
+	u32 asic_id = 0;
+	u32 i;
+	struct sli4_asic_entry_t *asic;
+
+	memset(sli4, 0, sizeof(struct sli4));
+
+	sli4->os = os;
+	sli4->pcidev = pdev;
+
+	for (i = 0; i < 6; i++)
+		sli4->reg[i] = reg[i];
+	/*
+	 * Read the SLI_INTF register to discover the register layout
+	 * and other capability information
+	 */
+	pci_read_config_dword(pdev, SLI4_INTF_REG, &intf);
+
+	if ((intf & SLI4_INTF_VALID_MASK) != (u32)SLI4_INTF_VALID_VALUE) {
+		efc_log_err(sli4, "SLI_INTF is not valid\n");
+		return -1;
+	}
+
+	/* driver only support SLI-4 */
+	if ((intf & SLI4_INTF_REV_MASK) != SLI4_INTF_REV_S4) {
+		efc_log_err(sli4, "Unsupported SLI revision (intf=%#x)\n",
+		       intf);
+		return -1;
+	}
+
+	sli4->sli_family = intf & SLI4_INTF_FAMILY_MASK;
+
+	sli4->if_type = intf & SLI4_INTF_IF_TYPE_MASK;
+	efc_log_info(sli4, "status=%#x error1=%#x error2=%#x\n",
+		sli_reg_read_status(sli4),
+			sli_reg_read_err1(sli4),
+			sli_reg_read_err2(sli4));
+
+	/*
+	 * set the ASIC type and revision
+	 */
+	pci_read_config_dword(pdev, PCI_CLASS_REVISION, &pci_class_rev);
+	rev_id = pci_class_rev & 0xff;
+	family = sli4->sli_family;
+	if (family == SLI4_FAMILY_CHECK_ASIC_TYPE) {
+		pci_read_config_dword(pdev, SLI4_ASIC_ID_REG, &asic_id);
+
+		family = asic_id & SLI4_ASIC_GEN_MASK;
+	}
+
+	for (i = 0, asic = sli4_asic_table; i < ARRAY_SIZE(sli4_asic_table);
+	     i++, asic++) {
+		if (rev_id == asic->rev_id && family == asic->family) {
+			sli4->asic_type = family;
+			sli4->asic_rev = rev_id;
+			break;
+		}
+	}
+	/* Fail if no matching asic type/rev was found */
+	if (!sli4->asic_type || !sli4->asic_rev) {
+		efc_log_err(sli4, "no matching asic family/rev found: %02x/%02x\n",
+		       family, rev_id);
+		return -1;
+	}
+
+	/*
+	 * The bootstrap mailbox is equivalent to a MQ with a single 256 byte
+	 * entry, a CQ with a single 16 byte entry, and no event queue.
+	 * Alignment must be 16 bytes as the low order address bits in the
+	 * address register are also control / status.
+	 */
+	sli4->bmbx.size = SLI4_BMBX_SIZE + sizeof(struct sli4_mcqe);
+	sli4->bmbx.virt = dma_alloc_coherent(&pdev->dev, sli4->bmbx.size,
+					     &sli4->bmbx.phys, GFP_DMA);
+	if (!sli4->bmbx.virt) {
+		memset(&sli4->bmbx, 0, sizeof(struct efc_dma));
+		efc_log_err(sli4, "bootstrap mailbox allocation failed\n");
+		return -1;
+	}
+
+	if (sli4->bmbx.phys & SLI4_BMBX_MASK_LO) {
+		efc_log_err(sli4, "bad alignment for bootstrap mailbox\n");
+		return -1;
+	}
+
+	efc_log_info(sli4, "bmbx v=%p p=0x%x %08x s=%zd\n", sli4->bmbx.virt,
+		upper_32_bits(sli4->bmbx.phys),
+		      lower_32_bits(sli4->bmbx.phys), sli4->bmbx.size);
+
+	/* 4096 is arbitrary. What should this value actually be? */
+	sli4->vpd_data.size = 4096;
+	sli4->vpd_data.virt = dma_alloc_coherent(&pdev->dev,
+						 sli4->vpd_data.size,
+						 &sli4->vpd_data.phys,
+						 GFP_DMA);
+	if (!sli4->vpd_data.virt) {
+		memset(&sli4->vpd_data, 0, sizeof(struct efc_dma));
+		/* Note that failure isn't fatal in this specific case */
+		efc_log_info(sli4, "VPD buffer allocation failed\n");
+	}
+
+	if (sli_fw_init(sli4)) {
+		efc_log_err(sli4, "FW initialization failed\n");
+		return -1;
+	}
+
+	/*
+	 * Set one of fcpi(initiator), fcpt(target), fcpc(combined) to true
+	 * in addition to any other desired features
+	 */
+	sli4->features = (SLI4_REQFEAT_IAAB | SLI4_REQFEAT_NPIV |
+				 SLI4_REQFEAT_DIF | SLI4_REQFEAT_VF |
+				 SLI4_REQFEAT_FCPC | SLI4_REQFEAT_IAAR |
+				 SLI4_REQFEAT_HLM | SLI4_REQFEAT_PERFH |
+				 SLI4_REQFEAT_RXSEQ | SLI4_REQFEAT_RXRI |
+				 SLI4_REQFEAT_MRQP);
+
+	/* use performance hints if available */
+	if (sli4->perf_hint)
+		sli4->features |= SLI4_REQFEAT_PERFH;
+
+	if (sli_request_features(sli4, &sli4->features, true))
+		return -1;
+
+	if (sli_get_config(sli4))
+		return -1;
+
+	return 0;
+}
+
+int
+sli_init(struct sli4 *sli4)
+{
+	if (sli4->has_extents) {
+		efc_log_info(sli4, "XXX need to implement extent allocation\n");
+		return -1;
+	}
+
+	if (sli4->high_login_mode)
+		sli4->features |= SLI4_REQFEAT_HLM;
+	else
+		sli4->features &= (~SLI4_REQFEAT_HLM);
+	sli4->features &= (~SLI4_REQFEAT_RXSEQ);
+	sli4->features &= (~SLI4_REQFEAT_RXRI);
+
+	if (sli_request_features(sli4, &sli4->features, false))
+		return -1;
+
+	return 0;
+}
+
+int
+sli_reset(struct sli4 *sli4)
+{
+	u32	i;
+
+	if (sli_fw_init(sli4)) {
+		efc_log_crit(sli4, "FW initialization failed\n");
+		return -1;
+	}
+
+	kfree(sli4->extent[0].base);
+	sli4->extent[0].base = NULL;
+
+	for (i = 0; i < SLI_RSRC_MAX; i++) {
+		kfree(sli4->extent[i].use_map);
+		sli4->extent[i].use_map = NULL;
+		sli4->extent[i].base = NULL;
+	}
+
+	if (sli_get_config(sli4))
+		return -1;
+
+	return 0;
+}
+
+int
+sli_fw_reset(struct sli4 *sli4)
+{
+	u32 val;
+	bool ready;
+
+	/*
+	 * Firmware must be ready before issuing the reset.
+	 */
+	ready = sli_wait_for_fw_ready(sli4, SLI4_FW_READY_TIMEOUT_MSEC);
+	if (!ready) {
+		efc_log_crit(sli4, "FW status is NOT ready\n");
+		return -1;
+	}
+	/* Lancer uses PHYDEV_CONTROL */
+
+	val = SLI4_PHYDEV_CTRL_FRST;
+	writel(val, (sli4->reg[0] + SLI4_PHYDEV_CTRL_REG));
+
+	/* wait for the FW to become ready after the reset */
+	ready = sli_wait_for_fw_ready(sli4, SLI4_FW_READY_TIMEOUT_MSEC);
+	if (!ready) {
+		efc_log_crit(sli4, "Failed to become ready after firmware reset\n");
+		return -1;
+	}
+	return 0;
+}
+
+int
+sli_teardown(struct sli4 *sli4)
+{
+	u32 i;
+
+	kfree(sli4->extent[0].base);
+	sli4->extent[0].base = NULL;
+
+	for (i = 0; i < SLI_RSRC_MAX; i++) {
+		sli4->extent[i].base = NULL;
+
+		kfree(sli4->extent[i].use_map);
+		sli4->extent[i].use_map = NULL;
+	}
+
+	if (sli_fw_term(sli4))
+		efc_log_err(sli4, "FW deinitialization failed\n");
+
+	dma_free_coherent(&sli4->pcidev->dev, sli4->vpd_data.size,
+			  sli4->vpd_data.virt, sli4->vpd_data.phys);
+	dma_free_coherent(&sli4->pcidev->dev, sli4->bmbx.size,
+			  sli4->bmbx.virt, sli4->bmbx.phys);
+
+	return 0;
+}
+
+int
+sli_callback(struct sli4 *sli4, enum sli4_callback which,
+	     void *func, void *arg)
+{
+	if (!func) {
+		efc_log_err(sli4, "bad parameter sli4=%p which=%#x func=%p\n",
+		       sli4, which, func);
+		return -1;
+	}
+
+	switch (which) {
+	case SLI4_CB_LINK:
+		sli4->link = func;
+		sli4->link_arg = arg;
+		break;
+	default:
+		efc_log_info(sli4, "unknown callback %#x\n", which);
+		return -1;
+	}
+
+	return 0;
+}
+
+int
+sli_eq_modify_delay(struct sli4 *sli4, struct sli4_queue *eq,
+		    u32 num_eq, u32 shift, u32 delay_mult)
+{
+	sli_cmd_common_modify_eq_delay(sli4, sli4->bmbx.virt, SLI4_BMBX_SIZE,
+				       eq, num_eq, shift, delay_mult);
+
+	if (sli_bmbx_command(sli4)) {
+		efc_log_crit(sli4, "bootstrap mailbox write fail (MODIFY EQ DELAY)\n");
+		return -1;
+	}
+	if (sli_res_sli_config(sli4, sli4->bmbx.virt)) {
+		efc_log_err(sli4, "bad status MODIFY EQ DELAY\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+int
+sli_resource_alloc(struct sli4 *sli4, enum sli4_resource rtype,
+		   u32 *rid, u32 *index)
+{
+	int rc = 0;
+	u32 size;
+	u32 extent_idx;
+	u32 item_idx;
+	u32 position;
+
+	*rid = U32_MAX;
+	*index = U32_MAX;
+
+	switch (rtype) {
+	case SLI_RSRC_VFI:
+	case SLI_RSRC_VPI:
+	case SLI_RSRC_RPI:
+	case SLI_RSRC_XRI:
+		position =
+		find_first_zero_bit(sli4->extent[rtype].use_map,
+				    sli4->extent[rtype].map_size);
+		if (position >= sli4->extent[rtype].map_size) {
+			efc_log_err(sli4, "out of resource %d (alloc=%d)\n",
+				    rtype, sli4->extent[rtype].n_alloc);
+			rc = -1;
+			break;
+		}
+		set_bit(position, sli4->extent[rtype].use_map);
+		*index = position;
+
+		size = sli4->extent[rtype].size;
+
+		extent_idx = *index / size;
+		item_idx   = *index % size;
+
+		*rid = sli4->extent[rtype].base[extent_idx] + item_idx;
+
+		sli4->extent[rtype].n_alloc++;
+		break;
+	default:
+		rc = -1;
+	}
+
+	return rc;
+}
+
+int
+sli_resource_free(struct sli4 *sli4,
+		  enum sli4_resource rtype, u32 rid)
+{
+	int rc = -1;
+	u32 x;
+	u32 size, *base;
+
+	switch (rtype) {
+	case SLI_RSRC_VFI:
+	case SLI_RSRC_VPI:
+	case SLI_RSRC_RPI:
+	case SLI_RSRC_XRI:
+		/*
+		 * Figure out which extent contains the resource ID. I.e. find
+		 * the extent such that
+		 *   extent->base <= resource ID < extent->base + extent->size
+		 */
+		base = sli4->extent[rtype].base;
+		size = sli4->extent[rtype].size;
+
+		/*
+		 * In the case of FW reset, this may be cleared
+		 * but the force_free path will still attempt to
+		 * free the resource. Prevent a NULL pointer access.
+		 */
+		if (base) {
+			for (x = 0; x < sli4->extent[rtype].number;
+			     x++) {
+				if (rid >= base[x] &&
+				    (rid < (base[x] + size))) {
+					rid -= base[x];
+					clear_bit((x * size) + rid,
+						  sli4->extent[rtype].use_map);
+					rc = 0;
+					break;
+				}
+			}
+		}
+		break;
+	default:
+		break;
+	}
+
+	return rc;
+}
+
+int
+sli_resource_reset(struct sli4 *sli4, enum sli4_resource rtype)
+{
+	int rc = -1;
+	u32 i;
+
+	switch (rtype) {
+	case SLI_RSRC_VFI:
+	case SLI_RSRC_VPI:
+	case SLI_RSRC_RPI:
+	case SLI_RSRC_XRI:
+		for (i = 0; i < sli4->extent[rtype].map_size; i++)
+			clear_bit(i, sli4->extent[rtype].use_map);
+		rc = 0;
+		break;
+	default:
+		break;
+	}
+
+	return rc;
+}
+
+int sli_raise_ue(struct sli4 *sli4, u8 dump)
+{
+	u32 val = 0;
+#define FDD 2
+	if (dump == FDD) {
+		val = SLI4_PORT_CTRL_FDD | SLI4_PORT_CTRL_IP;
+		writel(val, (sli4->reg[0] + SLI4_PORT_CTRL_REG));
+	} else {
+		val = SLI4_PHYDEV_CTRL_FRST;
+
+		if (dump == 1)
+			val |= SLI4_PHYDEV_CTRL_DD;
+		writel(val, (sli4->reg[0] + SLI4_PHYDEV_CTRL_REG));
+	}
+
+	return 0;
+}
+
+int sli_dump_is_ready(struct sli4 *sli4)
+{
+	int rc = 0;
+	u32 port_val;
+	u32 bmbx_val;
+
+	/*
+	 * Ensure that the port is ready AND the mailbox is
+	 * ready before signaling that the dump is ready to go.
+	 */
+	port_val = sli_reg_read_status(sli4);
+	bmbx_val = readl(sli4->reg[0] + SLI4_BMBX_REG);
+
+	if ((bmbx_val & SLI4_BMBX_RDY) &&
+	    (port_val & SLI4_PORT_STATUS_RDY)) {
+		if (port_val & SLI4_PORT_STATUS_DIP)
+			rc = 1;
+		else if (port_val & SLI4_PORT_STATUS_FDP)
+			rc = 2;
+	}
+
+	return rc;
+}
+
+int sli_dump_is_present(struct sli4 *sli4)
+{
+	u32 val;
+	bool ready;
+
+	/* If the chip is not ready, then there cannot be a dump */
+	ready = sli_wait_for_fw_ready(sli4, SLI4_INIT_PORT_DELAY_US);
+	if (!ready)
+		return 0;
+
+	val = sli_reg_read_status(sli4);
+	if (val == U32_MAX) {
+		efc_log_err(sli4, "error reading SLIPORT_STATUS\n");
+		return -1;
+	} else {
+		return (val & SLI4_PORT_STATUS_DIP) ? 1 : 0;
+	}
+}
+
+int sli_reset_required(struct sli4 *sli4)
+{
+	u32 val;
+
+	val = sli_reg_read_status(sli4);
+	if (val == U32_MAX) {
+		efc_log_err(sli4, "error reading SLIPORT_STATUS\n");
+		return -1;
+	} else {
+		return (val & SLI4_PORT_STATUS_RN) ? 1 : 0;
+	}
+}
+
+int
+sli_cmd_post_sgl_pages(struct sli4 *sli4, void *buf, size_t size,
+		       u16 xri,
+		       u32 xri_count, struct efc_dma *page0[],
+		       struct efc_dma *page1[], struct efc_dma *dma)
+{
+	struct sli4_rqst_post_sgl_pages *post = NULL;
+	u32 i;
+	__le32 req_len;
+
+	post = sli_config_cmd_init(sli4, buf, size,
+				   SLI_CONFIG_PYLD_LENGTH(post_sgl_pages),
+				   dma);
+	if (!post)
+		return EFC_FAIL;
+
+	/* payload size calculation */
+	/* 4 = xri_start + xri_count */
+	/* xri_count = # of XRI's registered */
+	/* sizeof(uint64_t) = physical address size */
+	/* 2 = # of physical addresses per page set */
+	req_len = cpu_to_le32(4 + (xri_count * (sizeof(uint64_t) * 2)));
+	sli_cmd_fill_hdr(&post->hdr, SLI4_OPC_POST_SGL_PAGES, SLI4_SUBSYSTEM_FC,
+			 CMD_V0, req_len);
+	post->xri_start = cpu_to_le16(xri);
+	post->xri_count = cpu_to_le16(xri_count);
+
+	for (i = 0; i < xri_count; i++) {
+		post->page_set[i].page0_low  =
+				cpu_to_le32(lower_32_bits(page0[i]->phys));
+		post->page_set[i].page0_high =
+				cpu_to_le32(upper_32_bits(page0[i]->phys));
+	}
+
+	if (page1) {
+		for (i = 0; i < xri_count; i++) {
+			post->page_set[i].page1_low =
+				cpu_to_le32(lower_32_bits(page1[i]->phys));
+			post->page_set[i].page1_high =
+				cpu_to_le32(upper_32_bits(page1[i]->phys));
+		}
+	}
+
+	return EFC_SUCCESS;
+}
+
+int
+sli_cmd_post_hdr_templates(struct sli4 *sli4, void *buf,
+			   size_t size, struct efc_dma *dma,
+			   u16 rpi,
+			   struct efc_dma *payload_dma)
+{
+	struct sli4_rqst_post_hdr_templates *req = NULL;
+	uintptr_t phys = 0;
+	u32 i = 0;
+	u32 page_count, payload_size;
+
+	page_count = sli_page_count(dma->size, SLI_PAGE_SIZE);
+
+	payload_size = ((sizeof(struct sli4_rqst_post_hdr_templates) +
+		(page_count * SZ_DMAADDR)) - sizeof(struct sli4_rqst_hdr));
+
+	if (page_count > 16) {
+		/*
+		 * We can't fit more than 16 descriptors into an embedded mbox
+		 * command, it has to be non-embedded
+		 */
+		payload_dma->size = payload_size;
+		payload_dma->virt = dma_alloc_coherent(&sli4->pcidev->dev,
+						       payload_dma->size,
+					     &payload_dma->phys, GFP_DMA);
+		if (!payload_dma->virt) {
+			memset(payload_dma, 0, sizeof(struct efc_dma));
+			efc_log_err(sli4, "mbox payload memory allocation fail\n");
+			return EFC_FAIL;
+		}
+		req = sli_config_cmd_init(sli4, buf, size,
+					  payload_size, payload_dma);
+	} else {
+		req = sli_config_cmd_init(sli4, buf, size,
+					  payload_size, NULL);
+	}
+
+	if (!req)
+		return EFC_FAIL;
+
+	if (rpi == U16_MAX)
+		rpi = sli4->extent[SLI_RSRC_RPI].base[0];
+
+	sli_cmd_fill_hdr(&req->hdr, SLI4_OPC_POST_HDR_TEMPLATES,
+			 SLI4_SUBSYSTEM_FC, CMD_V0,
+			 CFG_RQST_PYLD_LEN(post_hdr_templates));
+
+	req->rpi_offset = cpu_to_le16(rpi);
+	req->page_count = cpu_to_le16(page_count);
+	phys = dma->phys;
+	for (i = 0; i < page_count; i++) {
+		req->page_descriptor[i].low  = cpu_to_le32(lower_32_bits(phys));
+		req->page_descriptor[i].high = cpu_to_le32(upper_32_bits(phys));
+
+		phys += SLI_PAGE_SIZE;
+	}
+
+	return EFC_SUCCESS;
+}
+
+u32
+sli_fc_get_rpi_requirements(struct sli4 *sli4, u32 n_rpi)
+{
+	u32 bytes = 0;
+
+	/* Check if header templates needed */
+	if (sli4->hdr_template_req)
+		/* round up to a page */
+		bytes = SLI_ROUND_PAGE(n_rpi * SLI4_HDR_TEMPLATE_SIZE);
+
+	return bytes;
+}
+
+const char *
+sli_fc_get_status_string(u32 status)
+{
+	static struct {
+		u32 code;
+		const char *label;
+	} lookup[] = {
+		{SLI4_FC_WCQE_STATUS_SUCCESS,		"SUCCESS"},
+		{SLI4_FC_WCQE_STATUS_FCP_RSP_FAILURE,	"FCP_RSP_FAILURE"},
+		{SLI4_FC_WCQE_STATUS_REMOTE_STOP,	"REMOTE_STOP"},
+		{SLI4_FC_WCQE_STATUS_LOCAL_REJECT,	"LOCAL_REJECT"},
+		{SLI4_FC_WCQE_STATUS_NPORT_RJT,		"NPORT_RJT"},
+		{SLI4_FC_WCQE_STATUS_FABRIC_RJT,	"FABRIC_RJT"},
+		{SLI4_FC_WCQE_STATUS_NPORT_BSY,		"NPORT_BSY"},
+		{SLI4_FC_WCQE_STATUS_FABRIC_BSY,	"FABRIC_BSY"},
+		{SLI4_FC_WCQE_STATUS_LS_RJT,		"LS_RJT"},
+		{SLI4_FC_WCQE_STATUS_CMD_REJECT,	"CMD_REJECT"},
+		{SLI4_FC_WCQE_STATUS_FCP_TGT_LENCHECK,	"FCP_TGT_LENCHECK"},
+		{SLI4_FC_WCQE_STATUS_RQ_BUF_LEN_EXCEEDED, "BUF_LEN_EXCEEDED"},
+		{SLI4_FC_WCQE_STATUS_RQ_INSUFF_BUF_NEEDED,
+				"RQ_INSUFF_BUF_NEEDED"},
+		{SLI4_FC_WCQE_STATUS_RQ_INSUFF_FRM_DISC, "RQ_INSUFF_FRM_DESC"},
+		{SLI4_FC_WCQE_STATUS_RQ_DMA_FAILURE,	"RQ_DMA_FAILURE"},
+		{SLI4_FC_WCQE_STATUS_FCP_RSP_TRUNCATE,	"FCP_RSP_TRUNCATE"},
+		{SLI4_FC_WCQE_STATUS_DI_ERROR,		"DI_ERROR"},
+		{SLI4_FC_WCQE_STATUS_BA_RJT,		"BA_RJT"},
+		{SLI4_FC_WCQE_STATUS_RQ_INSUFF_XRI_NEEDED,
+				"RQ_INSUFF_XRI_NEEDED"},
+		{SLI4_FC_WCQE_STATUS_RQ_INSUFF_XRI_DISC, "INSUFF_XRI_DISC"},
+		{SLI4_FC_WCQE_STATUS_RX_ERROR_DETECT,	"RX_ERROR_DETECT"},
+		{SLI4_FC_WCQE_STATUS_RX_ABORT_REQUEST,	"RX_ABORT_REQUEST"},
+		};
+	u32 i;
+
+	for (i = 0; i < ARRAY_SIZE(lookup); i++) {
+		if (status == lookup[i].code)
+			return lookup[i].label;
+	}
+	return "unknown";
+}
diff --git a/drivers/scsi/elx/libefc_sli/sli4.h b/drivers/scsi/elx/libefc_sli/sli4.h
index 4184a7e0069a..212ed7fc6b83 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.h
+++ b/drivers/scsi/elx/libefc_sli/sli4.h
@@ -3731,7 +3731,7 @@ struct sli4 {
 	struct efc_dma		*bmbx_non_emb_pmd;
 
 	struct efc_dma		vpd_data;
-	u32				vpd_length;
+	u32			vpd_length;
 };
 
 static inline void
@@ -3743,4 +3743,554 @@ sli_cmd_fill_hdr(struct sli4_rqst_hdr *hdr, u8 opc, u8 sub, u32 ver, __le32 len)
 	hdr->request_length = len;
 }
 
+/**
+ * Get / set parameter functions
+ */
+
+static inline int
+sli_set_hlm(struct sli4 *sli4, u32 value)
+{
+	if (value && !(sli4->features & SLI4_REQFEAT_HLM)) {
+		efc_log_err(sli4, "HLM not supported\n");
+		return -1;
+	}
+
+	sli4->high_login_mode = value != 0 ? true : false;
+
+	return 0;
+}
+
+static inline int
+sli_set_sgl_preregister(struct sli4 *sli4, u32 value)
+{
+	if (value == 0 && sli4->sgl_pre_registration_required) {
+		efc_log_err(sli4, "SGL pre-registration required\n");
+		return -1;
+	}
+
+	sli4->sgl_pre_registered = value != 0 ? true : false;
+
+	return 0;
+}
+
+static inline u32
+sli_get_max_sgl(struct sli4 *sli4)
+{
+	if (sli4->sgl_page_sizes != 1) {
+		efc_log_err(sli4, "unsupported SGL page sizes %#x\n",
+			sli4->sgl_page_sizes);
+		return 0;
+	}
+
+	return ((sli4->max_sgl_pages * SLI_PAGE_SIZE)
+		/ sizeof(struct sli4_sge));
+}
+
+static inline enum sli4_link_medium
+sli_get_medium(struct sli4 *sli4)
+{
+	switch (sli4->topology) {
+	case SLI4_READ_CFG_TOPO_FC:
+	case SLI4_READ_CFG_TOPO_FC_DA:
+	case SLI4_READ_CFG_TOPO_FC_AL:
+		return SLI_LINK_MEDIUM_FC;
+	default:
+		return SLI_LINK_MEDIUM_MAX;
+	}
+}
+
+static inline int
+sli_set_topology(struct sli4 *sli4, u32 value)
+{
+	int	rc = 0;
+
+	switch (value) {
+	case SLI4_READ_CFG_TOPO_FC:
+	case SLI4_READ_CFG_TOPO_FC_DA:
+	case SLI4_READ_CFG_TOPO_FC_AL:
+		sli4->topology = value;
+		break;
+	default:
+		efc_log_err(sli4, "unsupported topology %#x\n", value);
+		rc = -1;
+	}
+
+	return rc;
+}
+
+static inline u32
+sli_convert_mask_to_count(u32 method, u32 mask)
+{
+	u32 count = 0;
+
+	if (method) {
+		count = 1 << (31 - __builtin_clz(mask));
+		count *= 16;
+	} else {
+		count = mask;
+	}
+
+	return count;
+}
+
+static inline u32
+sli_reg_read_status(struct sli4 *sli)
+{
+	return readl(sli->reg[0] + SLI4_PORT_STATUS_REGOFF);
+}
+
+static inline int
+sli_fw_error_status(struct sli4 *sli4)
+{
+	return ((sli_reg_read_status(sli4) & SLI4_PORT_STATUS_ERR) ? 1 : 0);
+}
+
+static inline u32
+sli_reg_read_err1(struct sli4 *sli)
+{
+	return readl(sli->reg[0] + SLI4_PORT_ERROR1);
+}
+
+static inline u32
+sli_reg_read_err2(struct sli4 *sli)
+{
+	return readl(sli->reg[0] + SLI4_PORT_ERROR2);
+}
+
+static inline int
+sli_fc_rqe_length(struct sli4 *sli4, void *cqe, u32 *len_hdr,
+		  u32 *len_data)
+{
+	struct sli4_fc_async_rcqe	*rcqe = cqe;
+
+	*len_hdr = *len_data = 0;
+
+	if (rcqe->status == SLI4_FC_ASYNC_RQ_SUCCESS) {
+		*len_hdr  = rcqe->hdpl_byte & SLI4_RACQE_HDPL;
+		*len_data = le16_to_cpu(rcqe->data_placement_length);
+		return 0;
+	} else {
+		return -1;
+	}
+}
+
+static inline u8
+sli_fc_rqe_fcfi(struct sli4 *sli4, void *cqe)
+{
+	u8 code = ((u8 *)cqe)[SLI4_CQE_CODE_OFFSET];
+	u8 fcfi = U8_MAX;
+
+	switch (code) {
+	case SLI4_CQE_CODE_RQ_ASYNC: {
+		struct sli4_fc_async_rcqe *rcqe = cqe;
+
+		fcfi = le16_to_cpu(rcqe->fcfi_rq_id_word) & SLI4_RACQE_FCFI;
+		break;
+	}
+	case SLI4_CQE_CODE_RQ_ASYNC_V1: {
+		struct sli4_fc_async_rcqe_v1 *rcqev1 = cqe;
+
+		fcfi = rcqev1->fcfi_byte & SLI4_RACQE_FCFI;
+		break;
+	}
+	case SLI4_CQE_CODE_OPTIMIZED_WRITE_CMD: {
+		struct sli4_fc_optimized_write_cmd_cqe *opt_wr = cqe;
+
+		fcfi = opt_wr->flags0 & SLI4_OCQE_FCFI;
+		break;
+	}
+	}
+
+	return fcfi;
+}
+
+/****************************************************************************
+ * Function prototypes
+ */
+extern int
+sli_cmd_config_link(struct sli4 *sli4, void *buf, size_t size);
+extern int
+sli_cmd_down_link(struct sli4 *sli4, void *buf, size_t size);
+extern int
+sli_cmd_dump_type4(struct sli4 *sli4, void *buf,
+		   size_t size, u16 wki);
+extern int
+sli_cmd_common_read_transceiver_data(struct sli4 *sli4, void *buf,
+				     size_t size, u32 page_num,
+				     struct efc_dma *dma);
+extern int
+sli_cmd_read_link_stats(struct sli4 *sli4, void *buf, size_t size,
+			u8 req_ext_counters, u8 clear_overflow_flags,
+			u8 clear_all_counters);
+extern int
+sli_cmd_read_status(struct sli4 *sli4, void *buf, size_t size,
+		    u8 clear_counters);
+extern int
+sli_cmd_init_link(struct sli4 *sli4, void *buf, size_t size,
+		  u32 speed, u8 reset_alpa);
+extern int
+sli_cmd_init_vfi(struct sli4 *sli4, void *buf, size_t size, u16 vfi,
+		 u16 fcfi, u16 vpi);
+extern int
+sli_cmd_init_vpi(struct sli4 *sli4, void *buf, size_t size, u16 vpi,
+		 u16 vfi);
+extern int
+sli_cmd_post_xri(struct sli4 *sli4, void *buf, size_t size,
+		 u16 xri_base, u16 xri_count);
+extern int
+sli_cmd_release_xri(struct sli4 *sli4, void *buf, size_t size,
+		    u8 num_xri);
+extern int
+sli_cmd_read_sparm64(struct sli4 *sli4, void *buf, size_t size,
+		     struct efc_dma *dma, u16 vpi);
+extern int
+sli_cmd_read_topology(struct sli4 *sli4, void *buf, size_t size,
+		      struct efc_dma *dma);
+extern int
+sli_cmd_read_nvparms(struct sli4 *sli4, void *buf, size_t size);
+extern int
+sli_cmd_write_nvparms(struct sli4 *sli4, void *buf, size_t size,
+		      u8 *wwpn, u8 *wwnn, u8 hard_alpa,
+		      u32 preferred_d_id);
+struct sli4_cmd_rq_cfg {
+	__le16	rq_id;
+	u8	r_ctl_mask;
+	u8	r_ctl_match;
+	u8	type_mask;
+	u8	type_match;
+};
+
+extern int
+sli_cmd_reg_fcfi(struct sli4 *sli4, void *buf, size_t size,
+		 u16 index,
+		struct sli4_cmd_rq_cfg rq_cfg[SLI4_CMD_REG_FCFI_NUM_RQ_CFG]);
+extern int
+sli_cmd_reg_fcfi_mrq(struct sli4 *sli4, void *buf, size_t size,
+		     u8 mode, u16 fcf_index,
+	    u8 rq_selection_policy, u8 mrq_bit_mask,
+	    u16 num_mrqs,
+	    struct sli4_cmd_rq_cfg rq_cfg[SLI4_CMD_REG_FCFI_NUM_RQ_CFG]);
+
+extern int
+sli_cmd_reg_rpi(struct sli4 *sli4, void *buf, size_t size,
+		u32 nport_id, u16 rpi, u16 vpi,
+		     struct efc_dma *dma, u8 update,
+		     u8 enable_t10_pi);
+extern int
+sli_cmd_sli_config(struct sli4 *sli4, void *buf, size_t size,
+		   u32 length, struct efc_dma *dma);
+extern int
+sli_cmd_unreg_fcfi(struct sli4 *sli4, void *buf, size_t size,
+		   u16 indicator);
+extern int
+sli_cmd_unreg_rpi(struct sli4 *sli4, void *buf, size_t size,
+		  u16 indicator,
+		  enum sli4_resource which, u32 fc_id);
+extern int
+sli_cmd_reg_vpi(struct sli4 *sli4, void *buf, size_t size,
+		u32 fc_id, __be64 sli_wwpn, u16 vpi, u16 vfi,
+		bool update);
+extern int
+sli_cmd_reg_vfi(struct sli4 *sli4, void *buf, size_t size,
+		u16 vfi, u16 fcfi, struct efc_dma dma,
+		u16 vpi, __be64 sli_wwpn, u32 fc_id);
+extern int
+sli_cmd_unreg_vpi(struct sli4 *sli4, void *buf, size_t size,
+		  u16 indicator, u32 which);
+extern int
+sli_cmd_unreg_vfi(struct sli4 *sli4, void *buf, size_t size,
+		  u16 index, u32 which);
+extern int
+sli_cmd_common_nop(struct sli4 *sli4, void *buf, size_t size,
+		   uint64_t context);
+extern int
+sli_cmd_common_get_resource_extent_info(struct sli4 *sli4, void *buf,
+					size_t size, u16 rtype);
+extern int
+sli_cmd_common_get_sli4_parameters(struct sli4 *sli4,
+				   void *buf, size_t size);
+extern int
+sli_cmd_common_write_object(struct sli4 *sli4, void *buf, size_t size,
+			    u16 noc, u16 eof, u32 desired_write_length,
+		u32 offset, char *object_name, struct efc_dma *dma);
+extern int
+sli_cmd_common_delete_object(struct sli4 *sli4, void *buf, size_t size,
+			     char *object_name);
+extern int
+sli_cmd_common_read_object(struct sli4 *sli4, void *buf, size_t size,
+			   u32 desired_read_length, u32 offset,
+			   char *object_name, struct efc_dma *dma);
+extern int
+sli_cmd_dmtf_exec_clp_cmd(struct sli4 *sli4, void *buf, size_t size,
+			  struct efc_dma *cmd, struct efc_dma *resp);
+extern int
+sli_cmd_common_set_dump_location(struct sli4 *sli4,
+				 void *buf, size_t size, bool query,
+				 bool is_buffer_list,
+				 struct efc_dma *buffer, u8 fdb);
+extern int
+sli_cmd_common_set_features(struct sli4 *sli4, void *buf, size_t size,
+			    u32 feature, u32 param_len,
+			    void *parameter);
+
+int sli_cqe_mq(struct sli4 *sli4, void *buf);
+int sli_cqe_async(struct sli4 *sli4, void *buf);
+
+extern int
+sli_setup(struct sli4 *sli4, void *os, struct pci_dev  *pdev,
+	  void __iomem *reg[]);
+void sli_calc_max_qentries(struct sli4 *sli4);
+int sli_init(struct sli4 *sli4);
+int sli_reset(struct sli4 *sli4);
+int sli_fw_reset(struct sli4 *sli4);
+int sli_teardown(struct sli4 *sli4);
+extern int
+sli_callback(struct sli4 *sli4, enum sli4_callback which,
+	     void *func, void *arg);
+extern int
+sli_bmbx_command(struct sli4 *sli4);
+extern int
+__sli_queue_init(struct sli4 *sli4, struct sli4_queue *q,
+		 u32 qtype, size_t size, u32 n_entries,
+		      u32 align);
+extern int
+__sli_create_queue(struct sli4 *sli4, struct sli4_queue *q);
+extern int
+sli_eq_modify_delay(struct sli4 *sli4, struct sli4_queue *eq,
+		    u32 num_eq, u32 shift, u32 delay_mult);
+extern int
+sli_queue_alloc(struct sli4 *sli4, u32 qtype,
+		struct sli4_queue *q, u32 n_entries,
+		     struct sli4_queue *assoc);
+extern int
+sli_cq_alloc_set(struct sli4 *sli4, struct sli4_queue *qs[],
+		 u32 num_cqs, u32 n_entries, struct sli4_queue *eqs[]);
+extern int
+sli_get_queue_entry_size(struct sli4 *sli4, u32 qtype);
+extern int
+sli_queue_free(struct sli4 *sli4, struct sli4_queue *q,
+	       u32 destroy_queues, u32 free_memory);
+extern int
+sli_queue_eq_arm(struct sli4 *sli4, struct sli4_queue *q, bool arm);
+extern int
+sli_queue_arm(struct sli4 *sli4, struct sli4_queue *q, bool arm);
+
+extern int
+sli_wq_write(struct sli4 *sli4, struct sli4_queue *q,
+	     u8 *entry);
+extern int
+sli_mq_write(struct sli4 *sli4, struct sli4_queue *q,
+	     u8 *entry);
+extern int
+sli_rq_write(struct sli4 *sli4, struct sli4_queue *q,
+	     u8 *entry);
+extern int
+sli_eq_read(struct sli4 *sli4, struct sli4_queue *q,
+	    u8 *entry);
+extern int
+sli_cq_read(struct sli4 *sli4, struct sli4_queue *q,
+	    u8 *entry);
+extern int
+sli_mq_read(struct sli4 *sli4, struct sli4_queue *q,
+	    u8 *entry);
+extern int
+sli_queue_index(struct sli4 *sli4, struct sli4_queue *q);
+extern int
+_sli_queue_poke(struct sli4 *sli4, struct sli4_queue *q,
+		u32 index, u8 *entry);
+extern int
+sli_queue_poke(struct sli4 *sli4, struct sli4_queue *q, u32 index,
+	       u8 *entry);
+extern int
+sli_resource_alloc(struct sli4 *sli4, enum sli4_resource rtype,
+		   u32 *rid, u32 *index);
+extern int
+sli_resource_free(struct sli4 *sli4, enum sli4_resource rtype,
+		  u32 rid);
+extern int
+sli_resource_reset(struct sli4 *sli4, enum sli4_resource rtype);
+extern int
+sli_eq_parse(struct sli4 *sli4, u8 *buf, u16 *cq_id);
+extern int
+sli_cq_parse(struct sli4 *sli4, struct sli4_queue *cq, u8 *cqe,
+	     enum sli4_qentry *etype, u16 *q_id);
+
+int sli_raise_ue(struct sli4 *sli4, u8 dump);
+int sli_dump_is_ready(struct sli4 *sli4);
+int sli_dump_is_present(struct sli4 *sli4);
+int sli_reset_required(struct sli4 *sli4);
+int sli_fw_ready(struct sli4 *sli4);
+
+extern int
+sli_fc_process_link_state(struct sli4 *sli4, void *acqe);
+extern int
+sli_fc_process_link_attention(struct sli4 *sli4, void *acqe);
+extern int
+sli_fc_cqe_parse(struct sli4 *sli4, struct sli4_queue *cq,
+		 u8 *cqe, enum sli4_qentry *etype,
+		 u16 *rid);
+u32 sli_fc_response_length(struct sli4 *sli4, u8 *cqe);
+u32 sli_fc_io_length(struct sli4 *sli4, u8 *cqe);
+int sli_fc_els_did(struct sli4 *sli4, u8 *cqe,
+		   u32 *d_id);
+u32 sli_fc_ext_status(struct sli4 *sli4, u8 *cqe);
+extern int
+sli_fc_rqe_rqid_and_index(struct sli4 *sli4, u8 *cqe,
+			  u16 *rq_id, u32 *index);
+extern int
+sli_cmd_wq_create(struct sli4 *sli4, void *buf, size_t size,
+		  struct efc_dma *qmem, u16 cq_id);
+int sli_cmd_post_sgl_pages(struct sli4 *sli4, void *buf,
+			   size_t size, u16 xri, u32 xri_count,
+			   struct efc_dma *page0[],
+			   struct efc_dma *page1[], struct efc_dma *dma);
+extern int
+sli_cmd_rq_create(struct sli4 *sli4, void *buf, size_t size,
+		  struct efc_dma *qmem,
+		       u16 cq_id, u16 buffer_size);
+extern int
+sli_cmd_rq_create_v1(struct sli4 *sli4, void *buf, size_t size,
+		     struct efc_dma *qmem, u16 cq_id,
+			  u16 buffer_size);
+extern int
+sli_cmd_read_fcf_table(struct sli4 *sli4, void *buf, size_t size,
+		       struct efc_dma *dma, u16 index);
+extern int
+sli_cmd_post_hdr_templates(struct sli4 *sli4, void *buf,
+			   size_t size, struct efc_dma *dma,
+				     u16 rpi,
+				     struct efc_dma *payload_dma);
+extern int
+sli_cmd_rediscover_fcf(struct sli4 *sli4, void *buf, size_t size,
+		       u16 index);
+extern int
+sli_fc_rq_alloc(struct sli4 *sli4, struct sli4_queue *q,
+		u32 n_entries, u32 buffer_size,
+		struct sli4_queue *cq, bool is_hdr);
+extern int
+sli_fc_rq_set_alloc(struct sli4 *sli4, u32 num_rq_pairs,
+		    struct sli4_queue *qs[], u32 base_cq_id,
+		    u32 n_entries, u32 header_buffer_size,
+		    u32 payload_buffer_size);
+u32 sli_fc_get_rpi_requirements(struct sli4 *sli4,
+				u32 n_rpi);
+extern int
+sli_abort_wqe(struct sli4 *sli4, void *buf, size_t size,
+	      enum sli4_abort_type type, bool send_abts,
+	u32 ids, u32 mask, u16 tag, u16 cq_id);
+
+extern int
+sli_send_frame_wqe(struct sli4 *sli4, void *buf, size_t size,
+		   u8 sof, u8 eof, u32 *hdr,
+			struct efc_dma *payload, u32 req_len,
+			u8 timeout, u16 xri, u16 req_tag);
+
+extern int
+sli_xmit_els_rsp64_wqe(struct sli4 *sli4, void *buf, size_t size,
+		       struct efc_dma *rsp, u32 rsp_len,
+		u16 xri, u16 tag, u16 cq_id,
+		u16 ox_id, u16 rnodeindicator,
+		u16 sportindicator, bool hlm, bool rnodeattached,
+		u32 rnode_fcid, u32 flags, u32 s_id);
+
+extern int
+sli_els_request64_wqe(struct sli4 *sli4, void *buf, size_t size,
+		      struct efc_dma *sgl,
+		u8 req_type, u32 req_len, u32 max_rsp_len,
+		u8 timeout, u16 xri, u16 tag,
+		u16 cq_id, u16 rnodeindicator,
+		u16 sportindicator, bool hlm, bool rnodeattached,
+		u32 rnode_fcid, u32 sport_fcid);
+
+extern int
+sli_fcp_icmnd64_wqe(struct sli4 *sli4, void *buf, size_t size,
+		    struct efc_dma *sgl, u16 xri, u16 tag,
+		u16 cq_id, u32 rpi, bool hlm,
+		u32 rnode_fcid, u8 timeout);
+
+extern int
+sli_fcp_iread64_wqe(struct sli4 *sli4, void *buf, size_t size,
+		    struct efc_dma *sgl, u32 first_data_sge,
+		u32 xfer_len, u16 xri, u16 tag,
+		u16 cq_id, u32 rpi, bool hlm, u32 rnode_fcid,
+		u8 dif, u8 bs, u8 timeout);
+
+extern int
+sli_fcp_iwrite64_wqe(struct sli4 *sli4, void *buf, size_t size,
+		     struct efc_dma *sgl,
+		u32 first_data_sge, u32 xfer_len,
+		u32 first_burst, u16 xri, u16 tag,
+		u16 cq_id, u32 rpi,
+		bool hlm, u32 rnode_fcid,
+		u8 dif, u8 bs, u8 timeout);
+
+extern int
+sli_fcp_treceive64_wqe(struct sli4 *sli4, void *buf, size_t size,
+		       struct efc_dma *sgl,
+		u32 first_data_sge, u32 relative_off,
+		u32 xfer_len, u16 xri, u16 tag,
+		u16 cq_id, u16 xid, u32 rpi, bool hlm,
+		u32 rnode_fcid, u32 flags, u8 dif,
+		u8 bs, u8 csctl, u32 app_id);
+
+extern int
+sli_fcp_cont_treceive64_wqe(struct sli4 *sli4, void *buf, size_t size,
+			    struct efc_dma *sgl, u32 first_data_sge,
+		u32 relative_off, u32 xfer_len,
+		u16 xri, u16 sec_xri, u16 tag,
+		u16 cq_id, u16 xid, u32 rpi,
+		bool hlm, u32 rnode_fcid, u32 flags,
+		u8 dif, u8 bs, u8 csctl,
+		u32 app_id);
+
+extern int
+sli_fcp_trsp64_wqe(struct sli4 *sli4, void *buf, size_t size,
+		   struct efc_dma *sgl,
+		u32 rsp_len, u16 xri, u16 tag, u16 cq_id,
+		u16 xid, u32 rpi, bool hlm, u32 rnode_fcid,
+		u32 flags, u8 csctl, u8 port_owned,
+		u32 app_id);
+
+extern int
+sli_fcp_tsend64_wqe(struct sli4 *sli4, void *buf, size_t size,
+		    struct efc_dma *sgl,
+		u32 first_data_sge, u32 relative_off,
+		u32 xfer_len, u16 xri, u16 tag,
+		u16 cq_id, u16 xid, u32 rpi,
+		bool hlm, u32 rnode_fcid, u32 flags, u8 dif,
+		u8 bs, u8 csctl, u32 app_id);
+
+extern int
+sli_gen_request64_wqe(struct sli4 *sli4, void *buf, size_t size,
+		      struct efc_dma *sgl, u32 req_len,
+		u32 max_rsp_len, u8 timeout, u16 xri,
+		u16 tag, u16 cq_id, bool hlm, u32 rnode_fcid,
+		u16 rnodeindicator, u8 r_ctl, u8 type,
+		u8 df_ctl);
+
+extern int
+sli_xmit_bls_rsp64_wqe(struct sli4 *sli4, void *buf, size_t size,
+		       struct sli_bls_payload *payload, u16 xri,
+		u16 tag, u16 cq_id,
+		bool rnodeattached, bool hlm, u16 rnodeindicator,
+		u16 sportindicator, u32 rnode_fcid,
+		u32 sport_fcid, u32 s_id);
+
+extern int
+sli_xmit_sequence64_wqe(struct sli4 *sli4, void *buf, size_t size,
+			struct efc_dma *payload, u32 payload_len,
+		u8 timeout, u16 ox_id, u16 xri,
+		u16 tag, bool hlm, u32 rnode_fcid,
+		u16 rnodeindicator, u8 r_ctl,
+		u8 type, u8 df_ctl);
+
+extern int
+sli_requeue_xri_wqe(struct sli4 *sli4, void *buf, size_t size,
+		    u16 xri, u16 tag, u16 cq_id);
+extern void
+sli4_cmd_lowlevel_set_watchdog(struct sli4 *sli4, void *buf,
+			       size_t size, u16 timeout);
+
+const char *sli_fc_get_status_string(u32 status);
+
 #endif /* !_SLI4_H */
-- 
2.13.7


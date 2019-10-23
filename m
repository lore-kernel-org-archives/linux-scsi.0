Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A1ECA9EB9
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEA3F21906
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HSbg4//y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406139AbfJWV4W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:22 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38806 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405939AbfJWV4W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:22 -0400
Received: by mail-wr1-f68.google.com with SMTP id v9so12436591wrq.5
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XC32wRfxX3IA2RhFg/GX73Mceq8wnltzcKHWrEjLDjA=;
        b=HSbg4//y6D+Z5dpBBS1jWE7uTSF9zRyeKq7f42culsh6eapXUqsueZJF6DPV1t7Nzl
         7JKUZIik5n68niamCByCEq07m/pqrKvverfk32AX2mQ6WJLiejlRLjERbbMOfk+SglPw
         thJa+6jWzyUAYxO9icLU7572SepUEOBABipVg1lNa+d5QUiOV8XB+vDK3Xgh34LdSW8n
         9zdgOj96NA/v9wMx5dp2mfWjlbc30bBsKKddVkS+GaTutEkUuWBHMRHgV+OVRgC+KlF+
         9zIzJfoOEfR6/Hi0RyPdgqvaY5/N636dBXFMTUt5dUg4qEj4cjLl2MxA0lnPAaQJvFG2
         xatw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XC32wRfxX3IA2RhFg/GX73Mceq8wnltzcKHWrEjLDjA=;
        b=A8H9Hu+rGnrvWRaMr91DPBmjZ7pflK1ijolthRMX25V0bJimQ0NjdV3dfaK2noX2s/
         E0UziC7WDb4P6Y3/Puhm9/V9BgX8qMnj0OvQCCA0X9N1UWmPaIp6jnTs6csHK8STc9qD
         Qr8DNSDFBFVKNbHUvoCiwPWikOepr4FaKS/Kpd7jkQLzMgOyI59K8U490gGcJ0E0Q32f
         Y03cRQJ9drDCF4eQ7tMhHUtPV+ZGsE+ux+WfwjPEnYVZ7IEy0AvSTml3cth+plL9BApx
         bVak3BUDGrmByTmECy4j5mgRj0cuBRvcmRuVLrYuIlKKDn6GJ+OFBE/bojQ9gJvjgHwl
         ICxg==
X-Gm-Message-State: APjAAAVOMo5B9OEVxzw6IEKHKJyRCeklOJKxCx7NY8yrHunMW0M+DYkY
        Cly3IyoU8zuYfGAq+8JISHwYts48
X-Google-Smtp-Source: APXvYqxsKdVmp0vuzywO3tAJb2ddIvHP6WgibG8ZTovQCQBFpxPxiu6DFarEaQeHyRy5UX2iehtbIg==
X-Received: by 2002:adf:e74c:: with SMTP id c12mr735473wrn.133.1571867775392;
        Wed, 23 Oct 2019 14:56:15 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:14 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 05/32] elx: libefc_sli: Populate and post different WQEs
Date:   Wed, 23 Oct 2019 14:55:30 -0700
Message-Id: <20191023215557.12581-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191023215557.12581-1-jsmart2021@gmail.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the libefc_sli SLI-4 library population.

This patch adds service routines to create different WQEs and adds
APIs to issue iread, iwrite, treceive, tsend and other work queue
entries.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/libefc_sli/sli4.c | 2102 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc_sli/sli4.h |    2 +
 2 files changed, 2104 insertions(+)

diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
index 6b62b7d8b5a4..9e57fa850da6 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.c
+++ b/drivers/scsi/elx/libefc_sli/sli4.c
@@ -2179,3 +2179,2105 @@ sli_cq_parse(struct sli4_s *sli4, struct sli4_queue_s *cq, u8 *cqe,
 
 	return rc;
 }
+
+/**
+ * @ingroup sli_fc
+ * @brief Write an ABORT_WQE work queue entry.
+ *
+ * @param sli4 SLI context.
+ * @param buf Destination buffer for the WQE.
+ * @param size Buffer size, in bytes.
+ * @param type Abort type, such as XRI, abort tag, and request tag.
+ * @param send_abts Boolean to cause the hardware to automatically generate an
+ * ABTS.
+ * @param ids ID of IOs to abort.
+ * @param mask Mask applied to the ID values to abort.
+ * @param tag Tag value associated with this abort.
+ * @param cq_id The id of the completion queue where the WQE response is sent.
+ * @param dnrx When set to 1, this field indicates that the SLI Port must not
+ * return the associated XRI to the SLI
+ *             Port's optimized write XRI pool.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_abort_wqe(struct sli4_s *sli4, void *buf, size_t size,
+	      enum sli4_abort_type_e type, bool send_abts, u32 ids,
+	      u32 mask, u16 tag, u16 cq_id)
+{
+	struct sli4_abort_wqe_s	*abort = buf;
+
+	memset(buf, 0, size);
+
+	switch (type) {
+	case SLI_ABORT_XRI:
+		abort->criteria = SLI4_ABORT_CRITERIA_XRI_TAG;
+		if (mask) {
+			efc_log_warn(sli4, "%#x aborting XRI %#x warning non-zero mask",
+				mask, ids);
+			mask = 0;
+		}
+		break;
+	case SLI_ABORT_ABORT_ID:
+		abort->criteria = SLI4_ABORT_CRITERIA_ABORT_TAG;
+		break;
+	case SLI_ABORT_REQUEST_ID:
+		abort->criteria = SLI4_ABORT_CRITERIA_REQUEST_TAG;
+		break;
+	default:
+		efc_log_info(sli4, "unsupported type %#x\n", type);
+		return EFC_FAIL;
+	}
+
+	abort->ia_ir_byte |= send_abts ? 0 : 1;
+
+	/* Suppress ABTS retries */
+	abort->ia_ir_byte |= SLI4_ABRT_WQE_IR;
+
+	abort->t_mask = cpu_to_le32(mask);
+	abort->t_tag  = cpu_to_le32(ids);
+	abort->command = SLI4_WQE_ABORT;
+	abort->request_tag = cpu_to_le16(tag);
+
+	abort->dw10w0_flags = cpu_to_le16(SLI4_ABRT_WQE_QOSD);
+
+	abort->cq_id = cpu_to_le16(cq_id);
+	abort->cmdtype_wqec_byte |= SLI4_CMD_ABORT_WQE;
+
+	return EFC_SUCCESS;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Write an ELS_REQUEST64_WQE work queue entry.
+ *
+ * @param sli4 SLI context.
+ * @param buf Destination buffer for the WQE.
+ * @param size Buffer size, in bytes.
+ * @param sgl DMA memory for the ELS request.
+ * @param req_type ELS request type.
+ * @param req_len Length of ELS request in bytes.
+ * @param max_rsp_len Max length of ELS response in bytes.
+ * @param timeout Time, in seconds, before an IO times out. Zero means 2 *
+ *  R_A_TOV.
+ * @param xri XRI for this exchange.
+ * @param tag IO tag value.
+ * @param cq_id The id of the completion queue where the WQE response is sent.
+ * @param rnode Destination of ELS request (that is, the remote node).
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_els_request64_wqe(struct sli4_s *sli4, void *buf, size_t size,
+		      struct efc_dma_s *sgl,
+		      u8 req_type, u32 req_len, u32 max_rsp_len,
+		      u8 timeout, u16 xri, u16 tag,
+		      u16 cq_id, u16 rnodeindicator, u16 sportindicator,
+		      bool hlm, bool rnodeattached, u32 rnode_fcid,
+		      u32 sport_fcid)
+{
+	struct sli4_els_request64_wqe_s	*els = buf;
+	struct sli4_sge_s *sge = sgl->virt;
+	bool is_fabric = false;
+	struct sli4_bde_s *bptr;
+
+	memset(buf, 0, size);
+
+	bptr = &els->els_request_payload;
+	if (sli4->sgl_pre_registered) {
+		els->qosd_xbl_hlm_iod_dbde_wqes &= ~SLI4_REQ_WQE_XBL;
+
+		els->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_REQ_WQE_DBDE;
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+				    (req_len & SLI4_BDE_MASK_BUFFER_LEN));
+
+		bptr->u.data.low  = sge[0].buffer_address_low;
+		bptr->u.data.high = sge[0].buffer_address_high;
+	} else {
+		els->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_REQ_WQE_XBL;
+
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BLP << BDE_TYPE_SHIFT) |
+				    ((2 * sizeof(struct sli4_sge_s)) &
+				     SLI4_BDE_MASK_BUFFER_LEN));
+		bptr->u.blp.low  = cpu_to_le32(lower_32_bits(sgl->phys));
+		bptr->u.blp.high = cpu_to_le32(upper_32_bits(sgl->phys));
+	}
+
+	els->els_request_payload_length = cpu_to_le32(req_len);
+	els->max_response_payload_length = cpu_to_le32(max_rsp_len);
+
+	els->xri_tag = cpu_to_le16(xri);
+	els->timer = timeout;
+	els->class_byte |= SLI4_GENERIC_CLASS_CLASS_3;
+
+	els->command = SLI4_WQE_ELS_REQUEST64;
+
+	els->request_tag = cpu_to_le16(tag);
+
+	if (hlm) {
+		els->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_REQ_WQE_HLM;
+		els->remote_id_dword = cpu_to_le32(rnode_fcid & 0x00ffffff);
+	}
+
+	els->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_REQ_WQE_IOD;
+
+	els->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_REQ_WQE_QOSD;
+
+	/* figure out the ELS_ID value from the request buffer */
+
+	switch (req_type) {
+	case ELS_LOGO:
+		els->cmdtype_elsid_byte |=
+			SLI4_ELS_REQUEST64_LOGO << SLI4_REQ_WQE_ELSID_SHFT;
+		if (rnodeattached) {
+			els->ct_byte |= (SLI4_GENERIC_CONTEXT_RPI <<
+					 SLI4_REQ_WQE_CT_SHFT);
+			els->context_tag = cpu_to_le16(rnodeindicator);
+		} else {
+			els->ct_byte |=
+			SLI4_GENERIC_CONTEXT_VPI << SLI4_REQ_WQE_CT_SHFT;
+			els->context_tag =
+				cpu_to_le16(sportindicator);
+		}
+		if (rnode_fcid == FC_FID_FLOGI)
+			is_fabric = true;
+		break;
+	case ELS_FDISC:
+		if (rnode_fcid == FC_FID_FLOGI)
+			is_fabric = true;
+		if (sport_fcid == 0) {
+			els->cmdtype_elsid_byte |=
+			SLI4_ELS_REQUEST64_FDISC << SLI4_REQ_WQE_ELSID_SHFT;
+			is_fabric = true;
+		} else {
+			els->cmdtype_elsid_byte |=
+			SLI4_ELS_REQUEST64_OTHER << SLI4_REQ_WQE_ELSID_SHFT;
+		}
+		els->ct_byte |= (SLI4_GENERIC_CONTEXT_VPI <<
+				 SLI4_REQ_WQE_CT_SHFT);
+		els->context_tag = cpu_to_le16(sportindicator);
+		els->sid_sp_dword |= cpu_to_le32(1 << SLI4_REQ_WQE_SP_SHFT);
+		break;
+	case ELS_FLOGI:
+		els->ct_byte |=
+			SLI4_GENERIC_CONTEXT_VPI << SLI4_REQ_WQE_CT_SHFT;
+		els->context_tag = cpu_to_le16(sportindicator);
+		/*
+		 * Set SP here ... we haven't done a REG_VPI yet
+		 * need to maybe not set this when we have
+		 * completed VFI/VPI registrations ...
+		 *
+		 * Use the FC_ID of the SPORT if it has been allocated,
+		 * otherwise use an S_ID of zero.
+		 */
+		els->sid_sp_dword |= cpu_to_le32(1 << SLI4_REQ_WQE_SP_SHFT);
+		if (sport_fcid != U32_MAX)
+			els->sid_sp_dword |= cpu_to_le32(sport_fcid);
+		break;
+	case ELS_PLOGI:
+		els->cmdtype_elsid_byte |=
+			SLI4_ELS_REQUEST64_PLOGI << SLI4_REQ_WQE_ELSID_SHFT;
+		els->ct_byte |=
+			SLI4_GENERIC_CONTEXT_VPI << SLI4_REQ_WQE_CT_SHFT;
+		els->context_tag = cpu_to_le16(sportindicator);
+		break;
+	case ELS_SCR:
+		els->cmdtype_elsid_byte |=
+			SLI4_ELS_REQUEST64_OTHER << SLI4_REQ_WQE_ELSID_SHFT;
+		els->ct_byte |=
+			SLI4_GENERIC_CONTEXT_VPI << SLI4_REQ_WQE_CT_SHFT;
+		els->context_tag = cpu_to_le16(sportindicator);
+		break;
+	default:
+		els->cmdtype_elsid_byte |=
+			SLI4_ELS_REQUEST64_OTHER << SLI4_REQ_WQE_ELSID_SHFT;
+		if (rnodeattached) {
+			els->ct_byte |= (SLI4_GENERIC_CONTEXT_RPI <<
+					 SLI4_REQ_WQE_CT_SHFT);
+			els->context_tag = cpu_to_le16(sportindicator);
+		} else {
+			els->ct_byte |=
+			SLI4_GENERIC_CONTEXT_VPI << SLI4_REQ_WQE_CT_SHFT;
+			els->context_tag =
+				cpu_to_le16(sportindicator);
+		}
+		break;
+	}
+
+	if (is_fabric)
+		els->cmdtype_elsid_byte |= SLI4_ELS_REQUEST64_CMD_FABRIC;
+	else
+		els->cmdtype_elsid_byte |= SLI4_ELS_REQUEST64_CMD_NON_FABRIC;
+
+	els->cq_id = cpu_to_le16(cq_id);
+
+	if (((els->ct_byte & SLI4_REQ_WQE_CT) >> SLI4_REQ_WQE_CT_SHFT) !=
+					SLI4_GENERIC_CONTEXT_RPI)
+		els->remote_id_dword = cpu_to_le32(rnode_fcid);
+
+	if (((els->ct_byte & SLI4_REQ_WQE_CT) >> SLI4_REQ_WQE_CT_SHFT) ==
+					SLI4_GENERIC_CONTEXT_VPI)
+		els->temporary_rpi = cpu_to_le16(rnodeindicator);
+
+	return EFC_SUCCESS;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Write an FCP_ICMND64_WQE work queue entry.
+ *
+ * @param sli4 SLI context.
+ * @param buf Destination buffer for the WQE.
+ * @param size Buffer size, in bytes.
+ * @param sgl DMA memory for the scatter gather list.
+ * @param xri XRI for this exchange.
+ * @param tag IO tag value.
+ * @param cq_id The id of the completion queue where the WQE response is sent.
+ * @param rpi remote node indicator (RPI)
+ * @param rnode Destination request (that is, the remote node).
+ * @param timeout Time, in seconds, before an IO times out. Zero means no
+ * timeout.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_fcp_icmnd64_wqe(struct sli4_s *sli4, void *buf, size_t size,
+		    struct efc_dma_s *sgl, u16 xri, u16 tag,
+		    u16 cq_id, u32 rpi, bool hlm,
+		    u32 rnode_fcid, u8 timeout)
+{
+	struct sli4_fcp_icmnd64_wqe_s *icmnd = buf;
+	struct sli4_sge_s *sge = NULL;
+	struct sli4_bde_s *bptr;
+
+	memset(buf, 0, size);
+
+	if (!sgl || !sgl->virt) {
+		efc_log_err(sli4, "bad parameter sgl=%p virt=%p\n",
+		       sgl, sgl ? sgl->virt : NULL);
+		return -1;
+	}
+	sge = sgl->virt;
+	bptr = &icmnd->bde;
+	if (sli4->sgl_pre_registered) {
+		icmnd->qosd_xbl_hlm_iod_dbde_wqes &= ~SLI4_ICMD_WQE_XBL;
+
+		icmnd->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_ICMD_WQE_DBDE;
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+				    (le32_to_cpu(sge[0].buffer_length) &
+				     SLI4_BDE_MASK_BUFFER_LEN));
+
+		bptr->u.data.low  = sge[0].buffer_address_low;
+		bptr->u.data.high = sge[0].buffer_address_high;
+	} else {
+		icmnd->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_ICMD_WQE_XBL;
+
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BLP << BDE_TYPE_SHIFT) |
+				    (sgl->size & SLI4_BDE_MASK_BUFFER_LEN));
+
+		bptr->u.blp.low  = cpu_to_le32(lower_32_bits(sgl->phys));
+		bptr->u.blp.high = cpu_to_le32(upper_32_bits(sgl->phys));
+	}
+
+	icmnd->payload_offset_length = (sge[0].buffer_length +
+					 sge[1].buffer_length);
+	icmnd->xri_tag = cpu_to_le16(xri);
+	icmnd->context_tag = cpu_to_le16(rpi);
+	icmnd->timer = timeout;
+
+	/* WQE word 4 contains read transfer length */
+	icmnd->class_pu_byte |= 2 << SLI4_ICMD_WQE_PU_SHFT;
+	icmnd->class_pu_byte |= SLI4_GENERIC_CLASS_CLASS_3;
+	icmnd->command = SLI4_WQE_FCP_ICMND64;
+	icmnd->dif_ct_bs_byte |=
+		SLI4_GENERIC_CONTEXT_RPI << SLI4_ICMD_WQE_CT_SHFT;
+
+	icmnd->abort_tag = cpu_to_le32(xri);
+
+	icmnd->request_tag = cpu_to_le16(tag);
+	icmnd->len_loc1_byte |= SLI4_ICMD_WQE_LEN_LOC_BIT1;
+	icmnd->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_ICMD_WQE_LEN_LOC_BIT2;
+	if (hlm) {
+		icmnd->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_ICMD_WQE_HLM;
+		icmnd->remote_n_port_id_dword =
+				cpu_to_le32(rnode_fcid & 0x00ffffff);
+	}
+	icmnd->cmd_type_byte |= SLI4_CMD_FCP_ICMND64_WQE;
+	icmnd->cq_id = cpu_to_le16(cq_id);
+
+	return  0;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Write an FCP_IREAD64_WQE work queue entry.
+ *
+ * @param sli4 SLI context.
+ * @param buf Destination buffer for the WQE.
+ * @param size Buffer size, in bytes.
+ * @param sgl DMA memory for the scatter gather list.
+ * @param first_data_sge Index of first data sge (used if perf hints are
+ * enabled)
+ * @param xfer_len Data transfer length.
+ * @param xri XRI for this exchange.
+ * @param tag IO tag value.
+ * @param cq_id The id of the completion queue where the WQE response is sent.
+ * @param rpi remote node indicator (RPI)
+ * @param rnode Destination request (i.e. remote node).
+ * @param dif T10 DIF operation, or 0 to disable.
+ * @param bs T10 DIF block size, or 0 if DIF is disabled.
+ * @param timeout Time, in seconds, before an IO times out. Zero means no
+ * timeout.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_fcp_iread64_wqe(struct sli4_s *sli4, void *buf, size_t size,
+		    struct efc_dma_s *sgl, u32 first_data_sge,
+		    u32 xfer_len, u16 xri, u16 tag,
+		    u16 cq_id, u32 rpi, bool hlm, u32 rnode_fcid,
+		    u8 dif, u8 bs, u8 timeout)
+{
+	struct sli4_fcp_iread64_wqe_s *iread = buf;
+	struct sli4_sge_s *sge = NULL;
+	struct sli4_bde_s *bptr;
+	u32 sge_flags = 0;
+
+	memset(buf, 0, size);
+
+	if (!sgl || !sgl->virt) {
+		efc_log_err(sli4, "bad parameter sgl=%p virt=%p\n",
+		       sgl, sgl ? sgl->virt : NULL);
+		return -1;
+	}
+	sge = sgl->virt;
+	bptr = &iread->bde;
+	if (sli4->sgl_pre_registered) {
+		iread->qosd_xbl_hlm_iod_dbde_wqes &= ~SLI4_IR_WQE_XBL;
+
+		iread->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_IR_WQE_DBDE;
+
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+				    (le32_to_cpu(sge[0].buffer_length) &
+				     SLI4_BDE_MASK_BUFFER_LEN));
+
+		bptr->u.blp.low  = sge[0].buffer_address_low;
+		bptr->u.blp.high = sge[0].buffer_address_high;
+	} else {
+		iread->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_IR_WQE_XBL;
+
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BLP << BDE_TYPE_SHIFT) |
+				    (sgl->size & SLI4_BDE_MASK_BUFFER_LEN));
+
+		bptr->u.blp.low  =
+				cpu_to_le32(lower_32_bits(sgl->phys));
+		bptr->u.blp.high =
+				cpu_to_le32(upper_32_bits(sgl->phys));
+
+		/*
+		 * fill out fcp_cmnd buffer len and change resp buffer to be of
+		 * type "skip" (note: response will still be written to sge[1]
+		 * if necessary)
+		 */
+		iread->fcp_cmd_buffer_length =
+					cpu_to_le16(sge[0].buffer_length);
+
+		sge_flags = sge[1].dw2_flags;
+		sge_flags &= (~SLI4_SGE_TYPE_MASK);
+		sge_flags |= (SLI4_SGE_TYPE_SKIP << SLI4_SGE_TYPE_SHIFT);
+		sge[1].dw2_flags = sge_flags;
+	}
+
+	iread->payload_offset_length = (sge[0].buffer_length +
+					 sge[1].buffer_length);
+	iread->total_transfer_length = cpu_to_le32(xfer_len);
+
+	iread->xri_tag = cpu_to_le16(xri);
+	iread->context_tag = cpu_to_le16(rpi);
+
+	iread->timer = timeout;
+
+	/* WQE word 4 contains read transfer length */
+	iread->class_pu_byte |= 2 << SLI4_IR_WQE_PU_SHFT;
+	iread->class_pu_byte |= SLI4_GENERIC_CLASS_CLASS_3;
+	iread->command = SLI4_WQE_FCP_IREAD64;
+	iread->dif_ct_bs_byte |=
+		SLI4_GENERIC_CONTEXT_RPI << SLI4_IR_WQE_CT_SHFT;
+	iread->dif_ct_bs_byte |= dif;
+	iread->dif_ct_bs_byte  |= bs << SLI4_IR_WQE_BS_SHFT;
+
+	iread->abort_tag = cpu_to_le32(xri);
+
+	iread->request_tag = cpu_to_le16(tag);
+	iread->len_loc1_byte |= SLI4_IR_WQE_LEN_LOC_BIT1;
+	iread->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_IR_WQE_LEN_LOC_BIT2;
+	if (hlm) {
+		iread->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_IR_WQE_HLM;
+		iread->remote_n_port_id_dword =
+				cpu_to_le32(rnode_fcid & 0x00ffffff);
+	}
+	iread->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_IR_WQE_IOD;
+	iread->cmd_type_byte |= SLI4_CMD_FCP_IREAD64_WQE;
+	iread->cq_id = cpu_to_le16(cq_id);
+
+	if (sli4->perf_hint) {
+		bptr = &iread->first_data_bde;
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+			  (le32_to_cpu(sge[first_data_sge].buffer_length) &
+			     SLI4_BDE_MASK_BUFFER_LEN));
+		bptr->u.data.low =
+			sge[first_data_sge].buffer_address_low;
+		bptr->u.data.high =
+			sge[first_data_sge].buffer_address_high;
+	}
+
+	return  0;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Write an FCP_IWRITE64_WQE work queue entry.
+ *
+ * @param sli4 SLI context.
+ * @param buf Destination buffer for the WQE.
+ * @param size Buffer size, in bytes.
+ * @param sgl DMA memory for the scatter gather list.
+ * @param first_data_sge Index of first data sge (used if perf hints are
+ * enabled)
+ * @param xfer_len Data transfer length.
+ * @param first_burst The number of first burst bytes
+ * @param xri XRI for this exchange.
+ * @param tag IO tag value.
+ * @param cq_id The id of the completion queue where the WQE response is sent.
+ * @param rpi remote node indicator (RPI)
+ * @param rnode Destination request (i.e. remote node)
+ * @param dif T10 DIF operation, or 0 to disable
+ * @param bs T10 DIF block size, or 0 if DIF is disabled
+ * @param timeout Time, in seconds, before an IO times out. Zero means no
+ * timeout.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_fcp_iwrite64_wqe(struct sli4_s *sli4, void *buf, size_t size,
+		     struct efc_dma_s *sgl,
+		     u32 first_data_sge, u32 xfer_len,
+		     u32 first_burst, u16 xri, u16 tag,
+		     u16 cq_id, u32 rpi,
+		     bool hlm, u32 rnode_fcid,
+		     u8 dif, u8 bs, u8 timeout)
+{
+	struct sli4_fcp_iwrite64_wqe_s *iwrite = buf;
+	struct sli4_sge_s *sge = NULL;
+	struct sli4_bde_s *bptr;
+	u32 sge_flags = 0, min = 0;
+
+	memset(buf, 0, size);
+
+	if (!sgl || !sgl->virt) {
+		efc_log_err(sli4, "bad parameter sgl=%p virt=%p\n",
+		       sgl, sgl ? sgl->virt : NULL);
+		return -1;
+	}
+	sge = sgl->virt;
+	bptr = &iwrite->bde;
+	if (sli4->sgl_pre_registered) {
+		iwrite->qosd_xbl_hlm_iod_dbde_wqes &= ~SLI4_IWR_WQE_XBL;
+
+		iwrite->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_IWR_WQE_DBDE;
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+				     (le32_to_cpu(sge[0].buffer_length) &
+				      SLI4_BDE_MASK_BUFFER_LEN));
+		bptr->u.data.low  = sge[0].buffer_address_low;
+		bptr->u.data.high = sge[0].buffer_address_high;
+	} else {
+		iwrite->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_IWR_WQE_XBL;
+
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+				    (sgl->size & SLI4_BDE_MASK_BUFFER_LEN));
+
+		bptr->u.blp.low  =
+			cpu_to_le32(lower_32_bits(sgl->phys));
+		bptr->u.blp.high =
+			cpu_to_le32(upper_32_bits(sgl->phys));
+
+		/*
+		 * fill out fcp_cmnd buffer len and change resp buffer to be of
+		 * type "skip" (note: response will still be written to sge[1]
+		 * if necessary)
+		 */
+		iwrite->fcp_cmd_buffer_length =
+					cpu_to_le16(sge[0].buffer_length);
+		sge_flags = sge[1].dw2_flags;
+		sge_flags &= ~SLI4_SGE_TYPE_MASK;
+		sge_flags |= (SLI4_SGE_TYPE_SKIP << SLI4_SGE_TYPE_SHIFT);
+		sge[1].dw2_flags = sge_flags;
+	}
+
+	iwrite->payload_offset_length = (sge[0].buffer_length +
+					 sge[1].buffer_length);
+	iwrite->total_transfer_length = cpu_to_le16(xfer_len);
+	min = (xfer_len < first_burst) ? xfer_len : first_burst;
+	iwrite->initial_transfer_length = cpu_to_le16(min);
+
+	iwrite->xri_tag = cpu_to_le16(xri);
+	iwrite->context_tag = cpu_to_le16(rpi);
+
+	iwrite->timer = timeout;
+	/* WQE word 4 contains read transfer length */
+	iwrite->class_pu_byte |= 2 << SLI4_IWR_WQE_PU_SHFT;
+	iwrite->class_pu_byte |= SLI4_GENERIC_CLASS_CLASS_3;
+	iwrite->command = SLI4_WQE_FCP_IWRITE64;
+	iwrite->dif_ct_bs_byte |=
+			SLI4_GENERIC_CONTEXT_RPI << SLI4_IWR_WQE_CT_SHFT;
+	iwrite->dif_ct_bs_byte |= dif;
+	iwrite->dif_ct_bs_byte |= bs << SLI4_IWR_WQE_BS_SHFT;
+
+	iwrite->abort_tag = cpu_to_le32(xri);
+
+	iwrite->request_tag = cpu_to_le16(tag);
+	iwrite->len_loc1_byte |= SLI4_IWR_WQE_LEN_LOC_BIT1;
+	iwrite->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_IWR_WQE_LEN_LOC_BIT2;
+	if (hlm) {
+		iwrite->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_IWR_WQE_HLM;
+		iwrite->remote_n_port_id_dword =
+			cpu_to_le32(rnode_fcid & 0x00ffffff);
+	}
+	iwrite->cmd_type_byte |= SLI4_CMD_FCP_IWRITE64_WQE;
+	iwrite->cq_id = cpu_to_le16(cq_id);
+
+	if (sli4->perf_hint) {
+		bptr = &iwrite->first_data_bde;
+
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+			 (le32_to_cpu(sge[first_data_sge].buffer_length) &
+			     SLI4_BDE_MASK_BUFFER_LEN));
+
+		bptr->u.data.low =
+			sge[first_data_sge].buffer_address_low;
+		bptr->u.data.high =
+			sge[first_data_sge].buffer_address_high;
+	}
+
+	return  0;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Write an FCP_TRECEIVE64_WQE work queue entry.
+ *
+ * @param sli4 SLI context.
+ * @param buf Destination buffer for the WQE.
+ * @param size Buffer size, in bytes.
+ * @param sgl DMA memory for the Scatter-Gather List.
+ * @param first_data_sge Index of first data sge (used if perf hints are
+ * enabled)
+ * @param relative_off Relative offset of the IO (if any).
+ * @param xfer_len Data transfer length.
+ * @param xri XRI for this exchange.
+ * @param tag IO tag value.
+ * @param xid OX_ID for the exchange.
+ * @param cq_id The id of the completion queue where the WQE response is sent.
+ * @param rpi remote node indicator (RPI)
+ * @param rnode Destination request (i.e. remote node).
+ * @param flags Optional attributes, including:
+ *  - ACTIVE - IO is already active.
+ *  - AUTO RSP - Automatically generate a good FCP_RSP.
+ * @param dif T10 DIF operation, or 0 to disable.
+ * @param bs T10 DIF block size, or 0 if DIF is disabled.
+ * @param csctl value of csctl field.
+ * @param app_id value for VM application header.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_fcp_treceive64_wqe(struct sli4_s *sli4, void *buf, size_t size,
+		       struct efc_dma_s *sgl,
+		       u32 first_data_sge, u32 relative_off,
+		       u32 xfer_len, u16 xri, u16 tag,
+		       u16 cq_id, u16 xid, u32 rpi, bool hlm,
+		       u32 rnode_fcid, u32 flags, u8 dif,
+		       u8 bs, u8 csctl, u32 app_id)
+{
+	struct sli4_fcp_treceive64_wqe_s *trecv = buf;
+	struct sli4_fcp_128byte_wqe_s *trecv_128 = buf;
+	struct sli4_sge_s *sge = NULL;
+	struct sli4_bde_s *bptr;
+
+	memset(buf, 0, size);
+
+	if (!sgl || !sgl->virt) {
+		efc_log_err(sli4, "bad parameter sgl=%p virt=%p\n",
+		       sgl, sgl ? sgl->virt : NULL);
+		return -1;
+	}
+	sge = sgl->virt;
+	bptr = &trecv->bde;
+	if (sli4->sgl_pre_registered) {
+		trecv->qosd_xbl_hlm_iod_dbde_wqes &= ~SLI4_TRCV_WQE_XBL;
+
+		trecv->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_TRCV_WQE_DBDE;
+
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+				    (le32_to_cpu(sge[0].buffer_length)
+					& SLI4_BDE_MASK_BUFFER_LEN));
+
+		bptr->u.data.low  = sge[0].buffer_address_low;
+		bptr->u.data.high = sge[0].buffer_address_high;
+
+		trecv->payload_offset_length = sge[0].buffer_length;
+	} else {
+		trecv->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_TRCV_WQE_XBL;
+
+		/* if data is a single physical address, use a BDE */
+		if (!dif && xfer_len <= le32_to_cpu(sge[2].buffer_length)) {
+			trecv->qosd_xbl_hlm_iod_dbde_wqes |=
+							SLI4_TRCV_WQE_DBDE;
+			bptr->bde_type_buflen =
+			      cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+					  (le32_to_cpu(sge[2].buffer_length)
+					  & SLI4_BDE_MASK_BUFFER_LEN));
+
+			bptr->u.data.low =
+				sge[2].buffer_address_low;
+			bptr->u.data.high =
+				sge[2].buffer_address_high;
+		} else {
+			bptr->bde_type_buflen =
+				cpu_to_le32((BDE_TYPE_BLP << BDE_TYPE_SHIFT) |
+				(sgl->size & SLI4_BDE_MASK_BUFFER_LEN));
+			bptr->u.blp.low =
+				cpu_to_le32(lower_32_bits(sgl->phys));
+			bptr->u.blp.high =
+				cpu_to_le32(upper_32_bits(sgl->phys));
+		}
+	}
+
+	trecv->relative_offset = cpu_to_le32(relative_off);
+
+	if (flags & SLI4_IO_CONTINUATION)
+		trecv->eat_xc_ccpe |= SLI4_TRCV_WQE_XC;
+
+	trecv->xri_tag = cpu_to_le16(xri);
+
+	trecv->context_tag = cpu_to_le16(rpi);
+
+	/* WQE uses relative offset */
+	trecv->class_ar_pu_byte |= 1 << SLI4_TRCV_WQE_PU_SHFT;
+
+	if (flags & SLI4_IO_AUTO_GOOD_RESPONSE)
+		trecv->class_ar_pu_byte |= SLI4_TRCV_WQE_AR;
+
+	trecv->command = SLI4_WQE_FCP_TRECEIVE64;
+	trecv->class_ar_pu_byte |= SLI4_GENERIC_CLASS_CLASS_3;
+	trecv->dif_ct_bs_byte |=
+		SLI4_GENERIC_CONTEXT_RPI << SLI4_TRCV_WQE_CT_SHFT;
+	trecv->dif_ct_bs_byte |= bs << SLI4_TRCV_WQE_BS_SHFT;
+
+	trecv->remote_xid = cpu_to_le16(xid);
+
+	trecv->request_tag = cpu_to_le16(tag);
+
+	trecv->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_TRCV_WQE_IOD;
+
+	trecv->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_TRCV_WQE_LEN_LOC_BIT2;
+
+	if (hlm) {
+		trecv->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_TRCV_WQE_HLM;
+		trecv->dword5.dword = cpu_to_le32(rnode_fcid & 0x00ffffff);
+	}
+
+	trecv->cmd_type_byte |= SLI4_CMD_FCP_TRECEIVE64_WQE;
+
+	trecv->cq_id = cpu_to_le16(cq_id);
+
+	trecv->fcp_data_receive_length = cpu_to_le32(xfer_len);
+
+	if (sli4->perf_hint) {
+		bptr = &trecv->first_data_bde;
+
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+			    (le32_to_cpu(sge[first_data_sge].buffer_length) &
+			     SLI4_BDE_MASK_BUFFER_LEN));
+		bptr->u.data.low =
+			sge[first_data_sge].buffer_address_low;
+		bptr->u.data.high =
+			sge[first_data_sge].buffer_address_high;
+	}
+
+	/* The upper 7 bits of csctl is the priority */
+	if (csctl & SLI4_MASK_CCP) {
+		trecv->eat_xc_ccpe |= SLI4_TRCV_WQE_CCPE;
+		trecv->ccp = (csctl & SLI4_MASK_CCP);
+	}
+
+	if (app_id && sli4->wqe_size == SLI4_WQE_EXT_BYTES &&
+	    !(trecv->eat_xc_ccpe & SLI4_TRSP_WQE_EAT)) {
+		trecv->lloc1_appid |= SLI4_TRCV_WQE_APPID;
+		trecv->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_TRCV_WQE_WQES;
+		trecv_128->dw[31] = cpu_to_le32(app_id);
+	}
+	return 0;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Write an FCP_CONT_TRECEIVE64_WQE work queue entry.
+ *
+ * @param sli4 SLI context.
+ * @param buf Destination buffer for the WQE.
+ * @param size Buffer size, in bytes.
+ * @param sgl DMA memory for the Scatter-Gather List.
+ * @param first_data_sge Index of first data sge (used if perf hints are
+ * enabled)
+ * @param relative_off Relative offset of the IO (if any).
+ * @param xfer_len Data transfer length.
+ * @param xri XRI for this exchange.
+ * @param tag IO tag value.
+ * @param xid OX_ID for the exchange.
+ * @param cq_id The id of the completion queue where the WQE response is sent.
+ * @param rpi remote node indicator (RPI)
+ * @param rnode Destination request (i.e. remote node).
+ * @param flags Optional attributes, including:
+ *  - ACTIVE - IO is already active.
+ *  - AUTO RSP - Automatically generate a good FCP_RSP.
+ * @param dif T10 DIF operation, or 0 to disable.
+ * @param bs T10 DIF block size, or 0 if DIF is disabled.
+ * @param csctl value of csctl field.
+ * @param app_id value for VM application header.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_fcp_cont_treceive64_wqe(struct sli4_s *sli4, void *buf, size_t size,
+			    struct efc_dma_s *sgl, u32 first_data_sge,
+			    u32 relative_off, u32 xfer_len,
+			    u16 xri, u16 sec_xri, u16 tag,
+			    u16 cq_id, u16 xid, u32 rpi,
+			    bool hlm, u32 rnode_fcid, u32 flags,
+			    u8 dif, u8 bs, u8 csctl,
+			    u32 app_id)
+{
+	int rc;
+
+	rc = sli_fcp_treceive64_wqe(sli4, buf, size, sgl, first_data_sge,
+				    relative_off, xfer_len, xri, tag, cq_id,
+				    xid, rpi, hlm, rnode_fcid, flags, dif, bs,
+				    csctl, app_id);
+	if (rc == 0) {
+		struct sli4_fcp_treceive64_wqe_s *trecv = buf;
+
+		trecv->command = SLI4_WQE_FCP_CONT_TRECEIVE64;
+		trecv->dword5.sec_xri_tag = cpu_to_le16(sec_xri);
+	}
+	return rc;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Write an FCP_TRSP64_WQE work queue entry.
+ *
+ * @param sli4 SLI context.
+ * @param buf Destination buffer for the WQE.
+ * @param size Buffer size, in bytes.
+ * @param sgl DMA memory for the Scatter-Gather List.
+ * @param rsp_len Response data length.
+ * @param xri XRI for this exchange.
+ * @param tag IO tag value.
+ * @param cq_id The id of the completion queue where the WQE response is sent.
+ * @param xid OX_ID for the exchange.
+ * @param rpi remote node indicator (RPI)
+ * @param rnode Destination request (i.e. remote node).
+ * @param flags Optional attributes, including:
+ *  - ACTIVE - IO is already active
+ *  - AUTO RSP - Automatically generate a good FCP_RSP.
+ * @param csctl value of csctl field.
+ * @param port_owned 0/1 to indicate if the XRI is port owned (used to seti
+ * XBL=0)
+ * @param app_id value for VM application header.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_fcp_trsp64_wqe(struct sli4_s *sli4, void *buf, size_t size,
+		   struct efc_dma_s *sgl,
+		   u32 rsp_len, u16 xri, u16 tag, u16 cq_id,
+		   u16 xid, u32 rpi, bool hlm, u32 rnode_fcid,
+		   u32 flags, u8 csctl, u8 port_owned,
+		   u32 app_id)
+{
+	struct sli4_fcp_trsp64_wqe_s *trsp = buf;
+	struct sli4_fcp_128byte_wqe_s *trsp_128 = buf;
+	struct sli4_bde_s *bptr;
+
+	memset(buf, 0, size);
+
+	if (flags & SLI4_IO_AUTO_GOOD_RESPONSE) {
+		trsp->class_ag_byte |= SLI4_TRSP_WQE_AG;
+	} else {
+		struct sli4_sge_s	*sge = sgl->virt;
+
+		if (sli4->sgl_pre_registered || port_owned)
+			trsp->qosd_xbl_hlm_dbde_wqes |= SLI4_TRSP_WQE_DBDE;
+		else
+			trsp->qosd_xbl_hlm_dbde_wqes |= SLI4_TRSP_WQE_XBL;
+		bptr = &trsp->bde;
+
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+				     (le32_to_cpu(sge[0].buffer_length) &
+				      SLI4_BDE_MASK_BUFFER_LEN));
+		bptr->u.data.low  = sge[0].buffer_address_low;
+		bptr->u.data.high = sge[0].buffer_address_high;
+
+		trsp->fcp_response_length = cpu_to_le32(rsp_len);
+	}
+
+	if (flags & SLI4_IO_CONTINUATION)
+		trsp->eat_xc_ccpe |= SLI4_TRSP_WQE_XC;
+
+	if (hlm) {
+		trsp->qosd_xbl_hlm_dbde_wqes |= SLI4_TRSP_WQE_HLM;
+		trsp->dword5 = cpu_to_le32(rnode_fcid & 0x00ffffff);
+	}
+
+	trsp->xri_tag = cpu_to_le16(xri);
+	trsp->rpi = cpu_to_le16(rpi);
+
+	trsp->command = SLI4_WQE_FCP_TRSP64;
+	trsp->class_ag_byte |= SLI4_GENERIC_CLASS_CLASS_3;
+
+	trsp->remote_xid = cpu_to_le16(xid);
+	trsp->request_tag = cpu_to_le16(tag);
+	if (flags & SLI4_IO_DNRX)
+		trsp->ct_dnrx_byte |= SLI4_TRSP_WQE_DNRX;
+	else
+		trsp->ct_dnrx_byte &= ~SLI4_TRSP_WQE_DNRX;
+
+	trsp->lloc1_appid |= 0x1;
+	trsp->cq_id = cpu_to_le16(cq_id);
+	trsp->cmd_type_byte = SLI4_CMD_FCP_TRSP64_WQE;
+
+	/* The upper 7 bits of csctl is the priority */
+	if (csctl & SLI4_MASK_CCP) {
+		trsp->eat_xc_ccpe |= SLI4_TRSP_WQE_CCPE;
+		trsp->ccp = (csctl & SLI4_MASK_CCP);
+	}
+
+	if (app_id && sli4->wqe_size == SLI4_WQE_EXT_BYTES &&
+	    !(trsp->eat_xc_ccpe & SLI4_TRSP_WQE_EAT)) {
+		trsp->lloc1_appid |= SLI4_TRSP_WQE_APPID;
+		trsp->qosd_xbl_hlm_dbde_wqes |= SLI4_TRSP_WQE_WQES;
+		trsp_128->dw[31] = cpu_to_le32(app_id);
+	}
+	return 0;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Write an FCP_TSEND64_WQE work queue entry.
+ *
+ * @param sli4 SLI context.
+ * @param buf Destination buffer for the WQE.
+ * @param size Buffer size, in bytes.
+ * @param sgl DMA memory for the scatter gather list.
+ * @param first_data_sge Index of first data sge (used if perf hints are
+ * enabled)
+ * @param relative_off Relative offset of the IO (if any).
+ * @param xfer_len Data transfer length.
+ * @param xri XRI for this exchange.
+ * @param tag IO tag value.
+ * @param cq_id The id of the completion queue where the WQE response is sent.
+ * @param xid OX_ID for the exchange.
+ * @param rpi remote node indicator (RPI)
+ * @param rnode Destination request (i.e. remote node).
+ * @param flags Optional attributes, including:
+ *  - ACTIVE - IO is already active.
+ *  - AUTO RSP - Automatically generate a good FCP_RSP.
+ * @param dif T10 DIF operation, or 0 to disable.
+ * @param bs T10 DIF block size, or 0 if DIF is disabled.
+ * @param csctl value of csctl field.
+ * @param app_id value for VM application header.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_fcp_tsend64_wqe(struct sli4_s *sli4, void *buf, size_t size,
+		    struct efc_dma_s *sgl,
+		    u32 first_data_sge, u32 relative_off,
+		    u32 xfer_len, u16 xri, u16 tag,
+		    u16 cq_id, u16 xid, u32 rpi,
+		    bool hlm, u32 rnode_fcid, u32 flags, u8 dif,
+		    u8 bs, u8 csctl, u32 app_id)
+{
+	struct sli4_fcp_tsend64_wqe_s *tsend = buf;
+	struct sli4_fcp_128byte_wqe_s *tsend_128 = buf;
+	struct sli4_sge_s *sge = NULL;
+	struct sli4_bde_s *bptr;
+
+	memset(buf, 0, size);
+
+	if (!sgl || !sgl->virt) {
+		efc_log_err(sli4, "bad parameter sgl=%p virt=%p\n",
+		       sgl, sgl ? sgl->virt : NULL);
+		return -1;
+	}
+	sge = sgl->virt;
+
+	bptr = &tsend->bde;
+	if (sli4->sgl_pre_registered) {
+		tsend->ll_qd_xbl_hlm_iod_dbde &= ~SLI4_TSEND_WQE_XBL;
+
+		tsend->ll_qd_xbl_hlm_iod_dbde |= SLI4_TSEND_WQE_DBDE;
+
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+				   (le32_to_cpu(sge[2].buffer_length) &
+				    SLI4_BDE_MASK_BUFFER_LEN));
+
+		/* TSEND64_WQE specifies first two SGE are skipped (3rd is
+		 * valid)
+		 */
+		bptr->u.data.low  = sge[2].buffer_address_low;
+		bptr->u.data.high = sge[2].buffer_address_high;
+	} else {
+		tsend->ll_qd_xbl_hlm_iod_dbde |= SLI4_TSEND_WQE_XBL;
+
+		/* if data is a single physical address, use a BDE */
+		if (!dif && xfer_len <= sge[2].buffer_length) {
+			tsend->ll_qd_xbl_hlm_iod_dbde |= SLI4_TSEND_WQE_DBDE;
+
+			bptr->bde_type_buflen =
+			    cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+					(le32_to_cpu(sge[2].buffer_length) &
+					SLI4_BDE_MASK_BUFFER_LEN));
+			/*
+			 * TSEND64_WQE specifies first two SGE are skipped
+			 * (i.e. 3rd is valid)
+			 */
+			bptr->u.data.low =
+				sge[2].buffer_address_low;
+			bptr->u.data.high =
+				sge[2].buffer_address_high;
+		} else {
+			bptr->bde_type_buflen =
+				cpu_to_le32((BDE_TYPE_BLP << BDE_TYPE_SHIFT) |
+					    (sgl->size &
+					     SLI4_BDE_MASK_BUFFER_LEN));
+			bptr->u.blp.low =
+				cpu_to_le32(lower_32_bits(sgl->phys));
+			bptr->u.blp.high =
+				cpu_to_le32(upper_32_bits(sgl->phys));
+		}
+	}
+
+	tsend->relative_offset = cpu_to_le32(relative_off);
+
+	if (flags & SLI4_IO_CONTINUATION)
+		tsend->dw10byte2 |= SLI4_TSEND_XC;
+
+	tsend->xri_tag = cpu_to_le16(xri);
+
+	tsend->rpi = cpu_to_le16(rpi);
+	/* WQE uses relative offset */
+	tsend->class_pu_ar_byte |= 1 << SLI4_TSEND_WQE_PU_SHFT;
+
+	if (flags & SLI4_IO_AUTO_GOOD_RESPONSE)
+		tsend->class_pu_ar_byte |= SLI4_TSEND_WQE_AR;
+
+	tsend->command = SLI4_WQE_FCP_TSEND64;
+	tsend->class_pu_ar_byte |= SLI4_GENERIC_CLASS_CLASS_3;
+	tsend->ct_byte |= SLI4_GENERIC_CONTEXT_RPI << SLI4_TSEND_CT_SHFT;
+	tsend->ct_byte |= dif;
+	tsend->ct_byte |= bs << SLI4_TSEND_BS_SHFT;
+
+	tsend->remote_xid = cpu_to_le16(xid);
+
+	tsend->request_tag = cpu_to_le16(tag);
+
+	tsend->ll_qd_xbl_hlm_iod_dbde |= SLI4_TSEND_LEN_LOC_BIT2;
+
+	if (hlm) {
+		tsend->ll_qd_xbl_hlm_iod_dbde |= SLI4_TSEND_WQE_HLM;
+		tsend->dword5 = cpu_to_le32(rnode_fcid & 0x00ffffff);
+	}
+
+	tsend->cq_id = cpu_to_le16(cq_id);
+
+	tsend->cmd_type_byte |= SLI4_CMD_FCP_TSEND64_WQE;
+
+	tsend->fcp_data_transmit_length = cpu_to_le32(xfer_len);
+
+	if (sli4->perf_hint) {
+		bptr = &tsend->first_data_bde;
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+			    (le32_to_cpu(sge[first_data_sge].buffer_length) &
+			     SLI4_BDE_MASK_BUFFER_LEN));
+		bptr->u.data.low =
+			sge[first_data_sge].buffer_address_low;
+		bptr->u.data.high =
+			sge[first_data_sge].buffer_address_high;
+	}
+
+	/* The upper 7 bits of csctl is the priority */
+	if (csctl & SLI4_MASK_CCP) {
+		tsend->dw10byte2 |= SLI4_TSEND_CCPE;
+		tsend->ccp = (csctl & SLI4_MASK_CCP);
+	}
+
+	if (app_id && sli4->wqe_size == SLI4_WQE_EXT_BYTES &&
+	    !(tsend->dw10byte2 & SLI4_TSEND_EAT)) {
+		tsend->dw10byte0 |= SLI4_TSEND_APPID_VALID;
+		tsend->ll_qd_xbl_hlm_iod_dbde |= SLI4_TSEND_WQES;
+		tsend_128->dw[31] = cpu_to_le32(app_id);
+	}
+	return 0;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Write a GEN_REQUEST64 work queue entry.
+ *
+ * @note This WQE is only used to send FC-CT commands.
+ *
+ * @param sli4 SLI context.
+ * @param buf Destination buffer for the WQE.
+ * @param size Buffer size, in bytes.
+ * @param sgl DMA memory for the request.
+ * @param req_len Length of request.
+ * @param max_rsp_len Max length of response.
+ * @param timeout Time, in seconds, before an IO times out.
+ * Zero means infinite.
+ * @param xri XRI for this exchange.
+ * @param tag IO tag value.
+ * @param cq_id The id of the completion queue where the WQE response is sent.
+ * @param rnode Destination of request (that is, the remote node).
+ * @param r_ctl R_CTL value for sequence.
+ * @param type TYPE value for sequence.
+ * @param df_ctl DF_CTL value for sequence.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_gen_request64_wqe(struct sli4_s *sli4, void *buf, size_t size,
+		      struct efc_dma_s *sgl, u32 req_len,
+		      u32 max_rsp_len, u8 timeout, u16 xri,
+		      u16 tag, u16 cq_id, bool hlm, u32 rnode_fcid,
+		      u16 rnodeindicator, u8 r_ctl,
+		      u8 type, u8 df_ctl)
+{
+	struct sli4_gen_request64_wqe_s	*gen = buf;
+	struct sli4_sge_s *sge = NULL;
+	struct sli4_bde_s *bptr;
+
+	memset(buf, 0, size);
+
+	if (!sgl || !sgl->virt) {
+		efc_log_err(sli4, "bad parameter sgl=%p virt=%p\n",
+		       sgl, sgl ? sgl->virt : NULL);
+		return -1;
+	}
+	sge = sgl->virt;
+	bptr = &gen->bde;
+
+	if (sli4->sgl_pre_registered) {
+		gen->dw10flags1 &= ~SLI4_GEN_REQ64_WQE_XBL;
+
+		gen->dw10flags1 |= SLI4_GEN_REQ64_WQE_DBDE;
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+				    (req_len & SLI4_BDE_MASK_BUFFER_LEN));
+
+		bptr->u.data.low  = sge[0].buffer_address_low;
+		bptr->u.data.high = sge[0].buffer_address_high;
+	} else {
+		gen->dw10flags1 |= SLI4_GEN_REQ64_WQE_XBL;
+
+		bptr->bde_type_buflen =
+			cpu_to_le32((BDE_TYPE_BLP << BDE_TYPE_SHIFT) |
+				    ((2 * sizeof(struct sli4_sge_s)) &
+				     SLI4_BDE_MASK_BUFFER_LEN));
+
+		bptr->u.blp.low =
+			cpu_to_le32(lower_32_bits(sgl->phys));
+		bptr->u.blp.high =
+			cpu_to_le32(upper_32_bits(sgl->phys));
+	}
+
+	gen->request_payload_length = cpu_to_le32(req_len);
+	gen->max_response_payload_length = cpu_to_le32(max_rsp_len);
+
+	gen->df_ctl = df_ctl;
+	gen->type = type;
+	gen->r_ctl = r_ctl;
+
+	gen->xri_tag = cpu_to_le16(xri);
+
+	gen->ct_byte = SLI4_GENERIC_CONTEXT_RPI << SLI4_GEN_REQ64_CT_SHFT;
+	gen->context_tag = cpu_to_le16(rnodeindicator);
+
+	gen->class_byte = SLI4_GENERIC_CLASS_CLASS_3;
+
+	gen->command = SLI4_WQE_GEN_REQUEST64;
+
+	gen->timer = timeout;
+
+	gen->request_tag = cpu_to_le16(tag);
+
+	gen->dw10flags1 |= SLI4_GEN_REQ64_WQE_IOD;
+
+	gen->dw10flags0 |= SLI4_GEN_REQ64_WQE_QOSD;
+
+	if (hlm) {
+		gen->dw10flags1 |= SLI4_GEN_REQ64_WQE_HLM;
+		gen->remote_n_port_id_dword =
+			cpu_to_le32(rnode_fcid & 0x00ffffff);
+	}
+
+	gen->cmd_type_byte = SLI4_CMD_GEN_REQUEST64_WQE;
+
+	gen->cq_id = cpu_to_le16(cq_id);
+
+	return 0;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Write a SEND_FRAME work queue entry
+ *
+ * @param sli4 SLI context.
+ * @param buf Destination buffer for the WQE.
+ * @param size Buffer size, in bytes.
+ * @param sof Start of frame value
+ * @param eof End of frame value
+ * @param hdr Pointer to FC header data
+ * @param payload DMA memory for the payload.
+ * @param req_len Length of payload.
+ * @param timeout Time, in seconds, before an IO times out. Zero means infinite.
+ * @param xri XRI for this exchange.
+ * @param req_tag IO tag value.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_send_frame_wqe(struct sli4_s *sli4, void *buf, size_t size,
+		   u8 sof, u8 eof, u32 *hdr,
+			struct efc_dma_s *payload, u32 req_len,
+			u8 timeout, u16 xri, u16 req_tag)
+{
+	struct sli4_send_frame_wqe_s *sf = buf;
+
+	memset(buf, 0, size);
+
+	sf->dw10flags1 |= SLI4_SF_WQE_DBDE;
+	sf->bde.bde_type_buflen = cpu_to_le32(req_len &
+					      SLI4_BDE_MASK_BUFFER_LEN);
+	sf->bde.u.data.low =
+		cpu_to_le32(lower_32_bits(payload->phys));
+	sf->bde.u.data.high =
+		cpu_to_le32(upper_32_bits(payload->phys));
+
+	/* Copy FC header */
+	sf->fc_header_0_1[0] = cpu_to_le32(hdr[0]);
+	sf->fc_header_0_1[1] = cpu_to_le32(hdr[1]);
+	sf->fc_header_2_5[0] = cpu_to_le32(hdr[2]);
+	sf->fc_header_2_5[1] = cpu_to_le32(hdr[3]);
+	sf->fc_header_2_5[2] = cpu_to_le32(hdr[4]);
+	sf->fc_header_2_5[3] = cpu_to_le32(hdr[5]);
+
+	sf->frame_length = cpu_to_le32(req_len);
+
+	sf->xri_tag = cpu_to_le16(xri);
+	sf->dw7flags0 &= ~SLI4_SF_PU;
+	sf->context_tag = 0;
+
+	sf->ct_byte &= ~SLI4_SF_CT;
+	sf->command = SLI4_WQE_SEND_FRAME;
+	sf->dw7flags0 |= SLI4_GENERIC_CLASS_CLASS_3;
+	sf->timer = timeout;
+
+	sf->request_tag = cpu_to_le16(req_tag);
+	sf->eof = eof;
+	sf->sof = sof;
+
+	sf->dw10flags1 &= ~SLI4_SF_QOSD;
+	sf->dw10flags0 |= SLI4_SF_LEN_LOC_BIT1;
+	sf->dw10flags2 &= ~SLI4_SF_XC;
+
+	sf->dw10flags1 |= SLI4_SF_XBL;
+
+	sf->cmd_type_byte |= SLI4_CMD_SEND_FRAME_WQE;
+	sf->cq_id = 0xffff;
+
+	return 0;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Write an XMIT_BLS_RSP64_WQE work queue entry.
+ *
+ * @param sli4 SLI context.
+ * @param buf Destination buffer for the WQE.
+ * @param size Buffer size, in bytes.
+ * @param payload Contents of the BLS payload to be sent.
+ * @param xri XRI for this exchange.
+ * @param tag IO tag value.
+ * @param cq_id The id of the completion queue where the WQE response is sent.
+ * @param rnode Destination of request (that is, the remote node).
+ * @param s_id Source ID to use in the response. If U32_MAX, use SLI Port's
+ * ID.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_xmit_bls_rsp64_wqe(struct sli4_s *sli4, void *buf, size_t size,
+		       struct sli_bls_payload_s *payload, u16 xri,
+		       u16 tag, u16 cq_id,
+		       bool rnodeattached, bool hlm, u16 rnodeindicator,
+		       u16 sportindicator, u32 rnode_fcid,
+		       u32 sport_fcid, u32 s_id)
+{
+	struct sli4_xmit_bls_rsp_wqe_s *bls = buf;
+	u32 dw_ridflags = 0;
+
+	/*
+	 * Callers can either specify RPI or S_ID, but not both
+	 */
+	if (rnodeattached && s_id != U32_MAX) {
+		efc_log_info(sli4, "S_ID specified for attached remote node %d\n",
+			rnodeindicator);
+		return -1;
+	}
+
+	memset(buf, 0, size);
+
+	if (payload->type == SLI4_SLI_BLS_ACC) {
+		bls->payload_word0 =
+			cpu_to_le32((payload->u.acc.seq_id_last << 16) |
+				    (payload->u.acc.seq_id_validity << 24));
+		bls->high_seq_cnt = cpu_to_le16(payload->u.acc.high_seq_cnt);
+		bls->low_seq_cnt = cpu_to_le16(payload->u.acc.low_seq_cnt);
+	} else if (payload->type == SLI4_SLI_BLS_RJT) {
+		bls->payload_word0 =
+				cpu_to_le32(*((u32 *)&payload->u.rjt));
+		dw_ridflags |= SLI4_BLS_RSP_WQE_AR;
+	} else {
+		efc_log_info(sli4, "bad BLS type %#x\n", payload->type);
+		return -1;
+	}
+
+	bls->ox_id = cpu_to_le16(payload->ox_id);
+	bls->rx_id = cpu_to_le16(payload->rx_id);
+
+	if (rnodeattached) {
+		bls->dw8flags0 |=
+		SLI4_GENERIC_CONTEXT_RPI << SLI4_BLS_RSP_WQE_CT_SHFT;
+		bls->context_tag = cpu_to_le16(rnodeindicator);
+	} else {
+		bls->dw8flags0 |=
+		SLI4_GENERIC_CONTEXT_VPI << SLI4_BLS_RSP_WQE_CT_SHFT;
+		bls->context_tag = cpu_to_le16(sportindicator);
+
+		if (s_id != U32_MAX)
+			bls->local_n_port_id_dword |=
+				cpu_to_le32(s_id & 0x00ffffff);
+		else
+			bls->local_n_port_id_dword |=
+				cpu_to_le32(sport_fcid & 0x00ffffff);
+
+		dw_ridflags = (dw_ridflags & ~SLI4_BLS_RSP_RID) |
+			       (rnode_fcid & SLI4_BLS_RSP_RID);
+
+		bls->temporary_rpi = cpu_to_le16(rnodeindicator);
+	}
+
+	bls->xri_tag = cpu_to_le16(xri);
+
+	bls->dw8flags1 |= SLI4_GENERIC_CLASS_CLASS_3;
+
+	bls->command = SLI4_WQE_XMIT_BLS_RSP;
+
+	bls->request_tag = cpu_to_le16(tag);
+
+	bls->dw11flags1 |= SLI4_BLS_RSP_WQE_QOSD;
+
+	if (hlm) {
+		bls->dw11flags1 |= SLI4_BLS_RSP_WQE_HLM;
+		dw_ridflags = (dw_ridflags & ~SLI4_BLS_RSP_RID) |
+			       (rnode_fcid & SLI4_BLS_RSP_RID);
+	}
+
+	bls->remote_id_dword = cpu_to_le32(dw_ridflags);
+	bls->cq_id = cpu_to_le16(cq_id);
+
+	bls->dw12flags0 |= SLI4_CMD_XMIT_BLS_RSP64_WQE;
+
+	return 0;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Write a XMIT_ELS_RSP64_WQE work queue entry.
+ *
+ * @param sli4 SLI context.
+ * @param buf Destination buffer for the WQE.
+ * @param size Buffer size, in bytes.
+ * @param rsp DMA memory for the ELS response.
+ * @param rsp_len Length of ELS response, in bytes.
+ * @param xri XRI for this exchange.
+ * @param tag IO tag value.
+ * @param cq_id The id of the completion queue where the WQE response is sent.
+ * @param ox_id OX_ID of the exchange containing the request.
+ * @param rnode Destination of the ELS response (that is, the remote node).
+ * @param flags Optional attributes, including:
+ *  - SLI4_IO_CONTINUATION - IO is already active.
+ * @param s_id S_ID used for special responses.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_xmit_els_rsp64_wqe(struct sli4_s *sli4, void *buf, size_t size,
+		       struct efc_dma_s *rsp, u32 rsp_len,
+				u16 xri, u16 tag, u16 cq_id,
+				u16 ox_id, u16 rnodeindicator,
+				u16 sportindicator, bool hlm,
+				bool rnodeattached, u32 rnode_fcid,
+				u32 flags, u32 s_id)
+{
+	struct sli4_xmit_els_rsp64_wqe_s *els = buf;
+
+	memset(buf, 0, size);
+
+	if (sli4->sgl_pre_registered)
+		els->flags2 |= SLI4_ELS_DBDE;
+	else
+		els->flags2 |= SLI4_ELS_XBL;
+
+	els->els_response_payload.bde_type_buflen =
+		cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+			    (rsp_len & SLI4_BDE_MASK_BUFFER_LEN));
+	els->els_response_payload.u.data.low =
+		cpu_to_le32(lower_32_bits(rsp->phys));
+	els->els_response_payload.u.data.high =
+		cpu_to_le32(upper_32_bits(rsp->phys));
+
+	els->els_response_payload_length = rsp_len;
+
+	els->xri_tag = cpu_to_le16(xri);
+
+	els->class_byte |= SLI4_GENERIC_CLASS_CLASS_3;
+
+	els->command = SLI4_WQE_ELS_RSP64;
+
+	els->request_tag = cpu_to_le16(tag);
+
+	els->ox_id = cpu_to_le16(ox_id);
+
+	els->flags2 |= (SLI4_ELS_IOD & SLI4_ELS_REQUEST64_DIR_WRITE);
+
+	els->flags2 |= SLI4_ELS_QOSD;
+
+	if (flags & SLI4_IO_CONTINUATION)
+		els->flags3 |= SLI4_ELS_XC;
+
+	if (rnodeattached) {
+		els->ct_byte |=
+			SLI4_GENERIC_CONTEXT_RPI << SLI4_ELS_CT_OFFSET;
+		els->context_tag = cpu_to_le16(rnodeindicator);
+	} else {
+		els->ct_byte |=
+			SLI4_GENERIC_CONTEXT_VPI << SLI4_ELS_CT_OFFSET;
+		els->context_tag = cpu_to_le16(sportindicator);
+		els->rid_dw = cpu_to_le32(rnode_fcid & SLI4_ELS_RID);
+		els->temporary_rpi = cpu_to_le16(rnodeindicator);
+		if (s_id != U32_MAX) {
+			els->sid_dw |= cpu_to_le32(SLI4_ELS_SP |
+						   (s_id & SLI4_ELS_SID));
+		}
+	}
+
+	if (hlm) {
+		els->flags2 |= SLI4_ELS_HLM;
+		els->rid_dw = cpu_to_le32(rnode_fcid & SLI4_ELS_RID);
+	}
+
+	els->cmd_type_wqec = SLI4_ELS_REQUEST64_CMD_GEN;
+
+	els->cq_id = cpu_to_le16(cq_id);
+
+	return 0;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Write a XMIT_SEQUENCE64 work queue entry.
+ *
+ * This WQE is used to send FC-CT response frames.
+ *
+ * @note This API implements a restricted use for this WQE,
+ *
+ * @param sli4 SLI context.
+ * @param buf Destination buffer for the WQE.
+ * @param size Buffer size, in bytes.
+ * @param payload DMA memory for the request.
+ * @param payload_len Length of request.
+ * @param timeout Time, in seconds, before an IO times out.
+ * Zero means infinite.
+ * @param ox_id originator exchange ID
+ * @param xri XRI for this exchange.
+ * @param tag IO tag value.
+ * @param rnode Destination of request (that is, the remote node).
+ * @param r_ctl R_CTL value for sequence.
+ * @param type TYPE value for sequence.
+ * @param df_ctl DF_CTL value for sequence.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_xmit_sequence64_wqe(struct sli4_s *sli4, void *buf, size_t size,
+			struct efc_dma_s *payload, u32 payload_len,
+		u8 timeout, u16 ox_id, u16 xri,
+		u16 tag, bool hlm, u32 rnode_fcid,
+		u16 rnodeindicator, u8 r_ctl,
+		u8 type, u8 df_ctl)
+{
+	struct sli4_xmit_sequence64_wqe_s *xmit = buf;
+
+	memset(buf, 0, size);
+
+	if (!payload || !payload->virt) {
+		efc_log_err(sli4, "bad parameter sgl=%p virt=%p\n",
+		       payload, payload ? payload->virt : NULL);
+		return -1;
+	}
+
+	if (sli4->sgl_pre_registered)
+		xmit->dw10w0 |= cpu_to_le16(SLI4_SEQ_WQE_DBDE);
+	else
+		xmit->dw10w0 |= cpu_to_le16(SLI4_SEQ_WQE_XBL);
+
+	xmit->bde.bde_type_buflen =
+		cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
+			(payload_len & SLI4_BDE_MASK_BUFFER_LEN));
+	xmit->bde.u.data.low  =
+			cpu_to_le32(lower_32_bits(payload->phys));
+	xmit->bde.u.data.high =
+			cpu_to_le32(upper_32_bits(payload->phys));
+	xmit->sequence_payload_len = cpu_to_le32(payload_len);
+
+	xmit->remote_n_port_id_dword |= rnode_fcid & 0x00ffffff;
+
+	xmit->relative_offset = 0;
+
+	/* sequence initiative - this matches what is seen from
+	 * FC switches in response to FCGS commands
+	 */
+	xmit->dw5flags0 &= (~SLI4_SEQ_WQE_SI);
+	xmit->dw5flags0 &= (~SLI4_SEQ_WQE_FT);/* force transmit */
+	xmit->dw5flags0 &= (~SLI4_SEQ_WQE_XO);/* exchange responder */
+	xmit->dw5flags0 |= SLI4_SEQ_WQE_LS;/* last in seqence */
+	xmit->df_ctl = df_ctl;
+	xmit->type = type;
+	xmit->r_ctl = r_ctl;
+
+	xmit->xri_tag = cpu_to_le16(xri);
+	xmit->context_tag = cpu_to_le16(rnodeindicator);
+
+	xmit->dw7flags0 &= (~SLI4_SEQ_WQE_DIF);
+	xmit->dw7flags0 |=
+		SLI4_GENERIC_CONTEXT_RPI << SLI4_SEQ_WQE_CT_SHIFT;
+	xmit->dw7flags0 &= (~SLI4_SEQ_WQE_BS);
+
+	xmit->command = SLI4_WQE_XMIT_SEQUENCE64;
+	xmit->dw7flags1 |= SLI4_GENERIC_CLASS_CLASS_3;
+	xmit->dw7flags1 &= (~SLI4_SEQ_WQE_PU);
+	xmit->timer = timeout;
+
+	xmit->abort_tag = 0;
+	xmit->request_tag = cpu_to_le16(tag);
+	xmit->remote_xid = cpu_to_le16(ox_id);
+
+	xmit->dw10w0 |=
+	cpu_to_le16(SLI4_ELS_REQUEST64_DIR_READ << SLI4_SEQ_WQE_IOD_SHIFT);
+
+	if (hlm) {
+		xmit->dw10w0 |= cpu_to_le16(SLI4_SEQ_WQE_HLM);
+		xmit->remote_n_port_id_dword |= rnode_fcid & 0x00ffffff;
+	}
+
+	xmit->cmd_type_wqec_byte |= SLI4_CMD_XMIT_SEQUENCE64_WQE;
+
+	xmit->dw10w0 |= cpu_to_le16(2 << SLI4_SEQ_WQE_LEN_LOC_SHIFT);
+
+	xmit->cq_id = cpu_to_le16(0xFFFF);
+
+	return 0;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Write a REQUEUE_XRI_WQE work queue entry.
+ *
+ * @param sli4 SLI context.
+ * @param buf Destination buffer for the WQE.
+ * @param size Buffer size, in bytes.
+ * @param xri XRI for this exchange.
+ * @param tag IO tag value.
+ * @param cq_id The id of the completion queue where the WQE response is sent.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_requeue_xri_wqe(struct sli4_s *sli4, void *buf, size_t size,
+		    u16 xri, u16 tag, u16 cq_id)
+{
+	struct sli4_requeue_xri_wqe_s *requeue = buf;
+
+	memset(buf, 0, size);
+
+	requeue->command = SLI4_WQE_REQUEUE_XRI;
+	requeue->xri_tag = cpu_to_le16(xri);
+	requeue->request_tag = cpu_to_le16(tag);
+	requeue->flags2 |= SLI4_REQU_XRI_WQE_XC;
+	requeue->flags1 |= SLI4_REQU_XRI_WQE_QOSD;
+	requeue->cq_id = cpu_to_le16(cq_id);
+	requeue->cmd_type_wqec_byte = SLI4_CMD_REQUEUE_XRI_WQE;
+	return 0;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Process an asynchronous Link State event entry.
+ *
+ * @par Description
+ * Parses Asynchronous Completion Queue Entry (ACQE),
+ * creates an abstracted event, and calls registered callback functions.
+ *
+ * @param sli4 SLI context.
+ * @param acqe Pointer to the ACQE.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_fc_process_link_state(struct sli4_s *sli4, void *acqe)
+{
+	struct sli4_link_state_s *link_state = acqe;
+	struct sli4_link_event_s event = { 0 };
+	int rc = 0;
+	u8 link_type = (link_state->link_num_type & LINK_TYPE_MASK);
+
+	if (!sli4->link) {
+		/* bail if there is no callback */
+		return 0;
+	}
+
+	if (link_type == LINK_TYPE_ETHERNET) {
+		event.topology = SLI_LINK_TOPO_NPORT;
+		event.medium   = SLI_LINK_MEDIUM_ETHERNET;
+	} else {
+		efc_log_info(sli4, "unsupported link type %#x\n",
+			link_type);
+		event.topology = SLI_LINK_TOPO_MAX;
+		event.medium   = SLI_LINK_MEDIUM_MAX;
+		rc = -1;
+	}
+
+	switch (link_state->port_link_status) {
+	case PORT_LINK_STATUS_PHYSICAL_DOWN:
+	case PORT_LINK_STATUS_LOGICAL_DOWN:
+		event.status = SLI_LINK_STATUS_DOWN;
+		break;
+	case PORT_LINK_STATUS_PHYSICAL_UP:
+	case PORT_LINK_STATUS_LOGICAL_UP:
+		event.status = SLI_LINK_STATUS_UP;
+		break;
+	default:
+		efc_log_info(sli4, "unsupported link status %#x\n",
+			link_state->port_link_status);
+		event.status = SLI_LINK_STATUS_MAX;
+		rc = -1;
+	}
+
+	switch (link_state->port_speed) {
+	case PORT_SPEED_NO_LINK:
+		event.speed = 0;
+		break;
+	case PORT_SPEED_10_MBPS:
+		event.speed = 10;
+		break;
+	case PORT_SPEED_100_MBP:
+		event.speed = 100;
+		break;
+	case PORT_SPEED_1_GBPS:
+		event.speed = 1000;
+		break;
+	case PORT_SPEED_10_GBPS:
+		event.speed = 10000;
+		break;
+	case PORT_SPEED_20_GBPS:
+		event.speed = 20000;
+		break;
+	case PORT_SPEED_25_GBPS:
+		event.speed = 25000;
+		break;
+	case PORT_SPEED_40_GBPS:
+		event.speed = 40000;
+		break;
+	case PORT_SPEED_100_GBPS:
+		event.speed = 100000;
+		break;
+	default:
+		efc_log_info(sli4, "unsupported port_speed %#x\n",
+			link_state->port_speed);
+		rc = -1;
+	}
+
+	sli4->link(sli4->link_arg, (void *)&event);
+
+	return rc;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Process an asynchronous Link Attention event entry.
+ *
+ * @par Description
+ * Parses Asynchronous Completion Queue Entry (ACQE),
+ * creates an abstracted event, and calls the registered callback functions.
+ *
+ * @param sli4 SLI context.
+ * @param acqe Pointer to the ACQE.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_fc_process_link_attention(struct sli4_s *sli4, void *acqe)
+{
+	struct sli4_link_attention_s *link_attn = acqe;
+	struct sli4_link_event_s event = { 0 };
+
+	efc_log_info(sli4, "link=%d attn_type=%#x top=%#x speed=%#x pfault=%#x\n",
+		link_attn->link_number, link_attn->attn_type,
+		      link_attn->topology, link_attn->port_speed,
+		      link_attn->port_fault);
+	efc_log_info(sli4, "shared_lnk_status=%#x logl_lnk_speed=%#x evnttag=%#x\n",
+		link_attn->shared_link_status,
+		      le16_to_cpu(link_attn->logical_link_speed),
+		      le32_to_cpu(link_attn->event_tag));
+
+	if (!sli4->link)
+		return 0;
+
+	event.medium   = SLI_LINK_MEDIUM_FC;
+
+	switch (link_attn->attn_type) {
+	case LINK_ATTN_TYPE_LINK_UP:
+		event.status = SLI_LINK_STATUS_UP;
+		break;
+	case LINK_ATTN_TYPE_LINK_DOWN:
+		event.status = SLI_LINK_STATUS_DOWN;
+		break;
+	case LINK_ATTN_TYPE_NO_HARD_ALPA:
+		efc_log_info(sli4, "attn_type: no hard alpa\n");
+		event.status = SLI_LINK_STATUS_NO_ALPA;
+		break;
+	default:
+		efc_log_info(sli4, "attn_type: unknown\n");
+		break;
+	}
+
+	switch (link_attn->event_type) {
+	case FC_EVENT_LINK_ATTENTION:
+		break;
+	case FC_EVENT_SHARED_LINK_ATTENTION:
+		efc_log_info(sli4, "event_type: FC shared link event\n");
+		break;
+	default:
+		efc_log_info(sli4, "event_type: unknown\n");
+		break;
+	}
+
+	switch (link_attn->topology) {
+	case LINK_ATTN_P2P:
+		event.topology = SLI_LINK_TOPO_NPORT;
+		break;
+	case LINK_ATTN_FC_AL:
+		event.topology = SLI_LINK_TOPO_LOOP;
+		break;
+	case LINK_ATTN_INTERNAL_LOOPBACK:
+		efc_log_info(sli4, "topology Internal loopback\n");
+		event.topology = SLI_LINK_TOPO_LOOPBACK_INTERNAL;
+		break;
+	case LINK_ATTN_SERDES_LOOPBACK:
+		efc_log_info(sli4, "topology serdes loopback\n");
+		event.topology = SLI_LINK_TOPO_LOOPBACK_EXTERNAL;
+		break;
+	default:
+		efc_log_info(sli4, "topology: unknown\n");
+		break;
+	}
+
+	event.speed    = link_attn->port_speed * 1000;
+
+	sli4->link(sli4->link_arg, (void *)&event);
+
+	return 0;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Parse an FC/FCoE work queue CQ entry.
+ *
+ * @param sli4 SLI context.
+ * @param cq CQ to process.
+ * @param cqe Pointer to the CQ entry.
+ * @param etype CQ event type.
+ * @param r_id Resource ID associated with this completion message (such as the
+ * IO tag).
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_fc_cqe_parse(struct sli4_s *sli4, struct sli4_queue_s *cq,
+		 u8 *cqe, enum sli4_qentry_e *etype, u16 *r_id)
+{
+	u8 code = cqe[SLI4_CQE_CODE_OFFSET];
+	int rc = -1;
+
+	switch (code) {
+	case SLI4_CQE_CODE_WORK_REQUEST_COMPLETION:
+	{
+		struct sli4_fc_wcqe_s *wcqe = (void *)cqe;
+
+		*etype = SLI_QENTRY_WQ;
+		*r_id = le16_to_cpu(wcqe->request_tag);
+		rc = wcqe->status;
+
+		/* Flag errors except for FCP_RSP_FAILURE */
+		if (rc && rc != SLI4_FC_WCQE_STATUS_FCP_RSP_FAILURE) {
+			efc_log_info(sli4, "WCQE: status=%#x hw_status=%#x tag=%#x\n",
+				wcqe->status, wcqe->hw_status,
+				le16_to_cpu(wcqe->request_tag));
+			efc_log_info(sli4, "w1=%#x w2=%#x xb=%d\n",
+				le32_to_cpu(wcqe->wqe_specific_1),
+				     le32_to_cpu(wcqe->wqe_specific_2),
+				     (wcqe->flags & SLI4_WCQE_XB));
+			efc_log_info(sli4, "      %08X %08X %08X %08X\n",
+				((u32 *)cqe)[0],
+				     ((u32 *)cqe)[1],
+				     ((u32 *)cqe)[2],
+				     ((u32 *)cqe)[3]);
+		}
+
+		break;
+	}
+	case SLI4_CQE_CODE_RQ_ASYNC:
+	{
+		struct sli4_fc_async_rcqe_s *rcqe = (void *)cqe;
+
+		*etype = SLI_QENTRY_RQ;
+		*r_id = le16_to_cpu(rcqe->fcfi_rq_id_word) & SLI4_RACQE_RQ_ID;
+		rc = rcqe->status;
+		break;
+	}
+	case SLI4_CQE_CODE_RQ_ASYNC_V1:
+	{
+		struct sli4_fc_async_rcqe_v1_s *rcqe = (void *)cqe;
+
+		*etype = SLI_QENTRY_RQ;
+		*r_id = rcqe->rq_id;
+		rc = rcqe->status;
+		break;
+	}
+	case SLI4_CQE_CODE_OPTIMIZED_WRITE_CMD:
+	{
+		struct sli4_fc_optimized_write_cmd_cqe_s *optcqe = (void *)cqe;
+
+		*etype = SLI_QENTRY_OPT_WRITE_CMD;
+		*r_id = le16_to_cpu(optcqe->rq_id);
+		rc = optcqe->status;
+		break;
+	}
+	case SLI4_CQE_CODE_OPTIMIZED_WRITE_DATA:
+	{
+		struct sli4_fc_optimized_write_data_cqe_s *dcqe = (void *)cqe;
+
+		*etype = SLI_QENTRY_OPT_WRITE_DATA;
+		*r_id = le16_to_cpu(dcqe->xri);
+		rc = dcqe->status;
+
+		/* Flag errors */
+		if (rc != SLI4_FC_WCQE_STATUS_SUCCESS) {
+			efc_log_info(sli4, "Optimized DATA CQE: status=%#x\n",
+				dcqe->status);
+			efc_log_info(sli4, "hstat=%#x xri=%#x dpl=%#x w3=%#x xb=%d\n",
+				dcqe->hw_status, le16_to_cpu(dcqe->xri),
+				le32_to_cpu(dcqe->total_data_placed),
+				((u32 *)cqe)[3],
+				(dcqe->flags & SLI4_OCQE_XB));
+		}
+		break;
+	}
+	case SLI4_CQE_CODE_RQ_COALESCING:
+	{
+		struct sli4_fc_coalescing_rcqe_s *rcqe = (void *)cqe;
+
+		*etype = SLI_QENTRY_RQ;
+		*r_id = le16_to_cpu(rcqe->rq_id);
+		rc = rcqe->status;
+		break;
+	}
+	case SLI4_CQE_CODE_XRI_ABORTED:
+	{
+		struct sli4_fc_xri_aborted_cqe_s *xa = (void *)cqe;
+
+		*etype = SLI_QENTRY_XABT;
+		*r_id = le16_to_cpu(xa->xri);
+		rc = 0;
+		break;
+	}
+	case SLI4_CQE_CODE_RELEASE_WQE: {
+		struct sli4_fc_wqec_s *wqec = (void *)cqe;
+
+		*etype = SLI_QENTRY_WQ_RELEASE;
+		*r_id = le16_to_cpu(wqec->wq_id);
+		rc = 0;
+		break;
+	}
+	default:
+		efc_log_info(sli4, "CQE completion code %d not handled\n",
+			code);
+		*etype = SLI_QENTRY_MAX;
+		*r_id = U16_MAX;
+	}
+
+	return rc;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Return the ELS/CT response length.
+ *
+ * @param sli4 SLI context.
+ * @param cqe Pointer to the CQ entry.
+ *
+ * @return Returns the length, in bytes.
+ */
+u32
+sli_fc_response_length(struct sli4_s *sli4, u8 *cqe)
+{
+	struct sli4_fc_wcqe_s *wcqe = (void *)cqe;
+
+	return le32_to_cpu(wcqe->wqe_specific_1);
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Return the FCP IO length.
+ *
+ * @param sli4 SLI context.
+ * @param cqe Pointer to the CQ entry.
+ *
+ * @return Returns the length, in bytes.
+ */
+u32
+sli_fc_io_length(struct sli4_s *sli4, u8 *cqe)
+{
+	struct sli4_fc_wcqe_s *wcqe = (void *)cqe;
+
+	return le32_to_cpu(wcqe->wqe_specific_1);
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Retrieve the D_ID from the completion.
+ *
+ * @param sli4 SLI context.
+ * @param cqe Pointer to the CQ entry.
+ * @param d_id Pointer where the D_ID is written.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_fc_els_did(struct sli4_s *sli4, u8 *cqe, u32 *d_id)
+{
+	struct sli4_fc_wcqe_s *wcqe = (void *)cqe;
+
+	*d_id = 0;
+
+	if (wcqe->status)
+		return -1;
+	*d_id = le32_to_cpu(wcqe->wqe_specific_2) & 0x00ffffff;
+	return 0;
+}
+
+u32
+sli_fc_ext_status(struct sli4_s *sli4, u8 *cqe)
+{
+	struct sli4_fc_wcqe_s *wcqe = (void *)cqe;
+	u32	mask;
+
+	switch (wcqe->status) {
+	case SLI4_FC_WCQE_STATUS_FCP_RSP_FAILURE:
+		mask = U32_MAX;
+		break;
+	case SLI4_FC_WCQE_STATUS_LOCAL_REJECT:
+	case SLI4_FC_WCQE_STATUS_CMD_REJECT:
+		mask = 0xff;
+		break;
+	case SLI4_FC_WCQE_STATUS_NPORT_RJT:
+	case SLI4_FC_WCQE_STATUS_FABRIC_RJT:
+	case SLI4_FC_WCQE_STATUS_NPORT_BSY:
+	case SLI4_FC_WCQE_STATUS_FABRIC_BSY:
+	case SLI4_FC_WCQE_STATUS_LS_RJT:
+		mask = U32_MAX;
+		break;
+	case SLI4_FC_WCQE_STATUS_DI_ERROR:
+		mask = U32_MAX;
+		break;
+	default:
+		mask = 0;
+	}
+
+	return le32_to_cpu(wcqe->wqe_specific_2) & mask;
+}
+
+/**
+ * @ingroup sli_fc
+ * @brief Retrieve the RQ index from the completion.
+ *
+ * @param sli4 SLI context.
+ * @param cqe Pointer to the CQ entry.
+ * @param rq_id Pointer where the rq_id is written.
+ * @param index Pointer where the index is written.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+sli_fc_rqe_rqid_and_index(struct sli4_s *sli4, u8 *cqe,
+			  u16 *rq_id, u32 *index)
+{
+	struct sli4_fc_async_rcqe_s *rcqe = (void *)cqe;
+	struct sli4_fc_async_rcqe_v1_s *rcqe_v1 = (void *)cqe;
+	int rc = -1;
+	u8 code = 0;
+	u16 rq_element_index;
+
+	*rq_id = 0;
+	*index = U32_MAX;
+
+	code = cqe[SLI4_CQE_CODE_OFFSET];
+
+	if (code == SLI4_CQE_CODE_RQ_ASYNC) {
+		*rq_id = le16_to_cpu(rcqe->fcfi_rq_id_word) & SLI4_RACQE_RQ_ID;
+		rq_element_index =
+		le16_to_cpu(rcqe->rq_elmt_indx_word) & SLI4_RACQE_RQ_EL_INDX;
+		*index = rq_element_index;
+		if (rcqe->status == SLI4_FC_ASYNC_RQ_SUCCESS) {
+			rc = 0;
+		} else {
+			rc = rcqe->status;
+			efc_log_info(sli4, "status=%02x (%s) rq_id=%d\n",
+				rcqe->status,
+				sli_fc_get_status_string(rcqe->status),
+				le16_to_cpu(rcqe->fcfi_rq_id_word) &
+				SLI4_RACQE_RQ_ID);
+
+			efc_log_info(sli4, "pdpl=%x sof=%02x eof=%02x hdpl=%x\n",
+				le16_to_cpu(rcqe->data_placement_length),
+				rcqe->sof_byte, rcqe->eof_byte,
+				rcqe->hdpl_byte & SLI4_RACQE_HDPL);
+		}
+	} else if (code == SLI4_CQE_CODE_RQ_ASYNC_V1) {
+		*rq_id = le16_to_cpu(rcqe_v1->rq_id);
+		rq_element_index =
+			(le16_to_cpu(rcqe_v1->rq_elmt_indx_word) &
+			 SLI4_RACQE_RQ_EL_INDX);
+		*index = rq_element_index;
+		if (rcqe_v1->status == SLI4_FC_ASYNC_RQ_SUCCESS) {
+			rc = 0;
+		} else {
+			rc = rcqe_v1->status;
+			efc_log_info(sli4, "status=%02x (%s) rq_id=%d, index=%x\n",
+				rcqe_v1->status,
+				sli_fc_get_status_string(rcqe_v1->status),
+				le16_to_cpu(rcqe_v1->rq_id), rq_element_index);
+
+			efc_log_info(sli4, "pdpl=%x sof=%02x eof=%02x hdpl=%x\n",
+				le16_to_cpu(rcqe_v1->data_placement_length),
+			rcqe_v1->sof_byte, rcqe_v1->eof_byte,
+			rcqe_v1->hdpl_byte & SLI4_RACQE_HDPL);
+		}
+	} else if (code == SLI4_CQE_CODE_OPTIMIZED_WRITE_CMD) {
+		struct sli4_fc_optimized_write_cmd_cqe_s *optcqe = (void *)cqe;
+
+		*rq_id = le16_to_cpu(optcqe->rq_id);
+		*index = le16_to_cpu(optcqe->w1) & SLI4_OCQE_RQ_EL_INDX;
+		if (optcqe->status == SLI4_FC_ASYNC_RQ_SUCCESS) {
+			rc = 0;
+		} else {
+			rc = optcqe->status;
+			efc_log_info(sli4, "stat=%02x (%s) rqid=%d, idx=%x pdpl=%x\n",
+				optcqe->status,
+				sli_fc_get_status_string(optcqe->status),
+				le16_to_cpu(optcqe->rq_id), *index,
+				le16_to_cpu(optcqe->data_placement_length));
+
+			efc_log_info(sli4, "hdpl=%x oox=%d agxr=%d xri=0x%x rpi=%x\n",
+				(optcqe->hdpl_vld & SLI4_OCQE_HDPL),
+				(optcqe->flags1 & SLI4_OCQE_OOX),
+				(optcqe->flags1 & SLI4_OCQE_AGXR), optcqe->xri,
+				le16_to_cpu(optcqe->rpi));
+		}
+	} else if (code == SLI4_CQE_CODE_RQ_COALESCING) {
+		struct sli4_fc_coalescing_rcqe_s	*rcqe = (void *)cqe;
+		u16 rq_element_index =
+				(le16_to_cpu(rcqe->rq_elmt_indx_word) &
+				 SLI4_RCQE_RQ_EL_INDX);
+
+		*rq_id = le16_to_cpu(rcqe->rq_id);
+		if (rcqe->status == SLI4_FC_COALESCE_RQ_SUCCESS) {
+			*index = rq_element_index;
+			rc = 0;
+		} else {
+			*index = U32_MAX;
+			rc = rcqe->status;
+
+			efc_log_info(sli4, "stat=%02x (%s) rq_id=%d, idx=%x\n",
+				rcqe->status,
+				sli_fc_get_status_string(rcqe->status),
+				le16_to_cpu(rcqe->rq_id), rq_element_index);
+			efc_log_info(sli4, "rq_id=%#x sdpl=%x\n",
+				le16_to_cpu(rcqe->rq_id),
+		    le16_to_cpu(rcqe->sequence_reporting_placement_length));
+		}
+	} else {
+		*index = U32_MAX;
+
+		rc = rcqe->status;
+
+		efc_log_info(sli4, "status=%02x rq_id=%d, index=%x pdpl=%x\n",
+			rcqe->status,
+		le16_to_cpu(rcqe->fcfi_rq_id_word) & SLI4_RACQE_RQ_ID,
+		(le16_to_cpu(rcqe->rq_elmt_indx_word) & SLI4_RACQE_RQ_EL_INDX),
+		le16_to_cpu(rcqe->data_placement_length));
+		efc_log_info(sli4, "sof=%02x eof=%02x hdpl=%x\n",
+			rcqe->sof_byte, rcqe->eof_byte,
+			rcqe->hdpl_byte & SLI4_RACQE_HDPL);
+	}
+
+	return rc;
+}
diff --git a/drivers/scsi/elx/libefc_sli/sli4.h b/drivers/scsi/elx/libefc_sli/sli4.h
index b36d67abf219..20ab558db2d2 100644
--- a/drivers/scsi/elx/libefc_sli/sli4.h
+++ b/drivers/scsi/elx/libefc_sli/sli4.h
@@ -12,6 +12,8 @@
 #ifndef _SLI4_H
 #define _SLI4_H
 
+#include "scsi/fc/fc_els.h"
+#include "scsi/fc/fc_fs.h"
 #include "../include/efc_common.h"
 
 /*************************************************************************
-- 
2.13.7


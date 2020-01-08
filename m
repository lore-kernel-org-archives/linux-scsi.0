Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1E3C00523
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 07:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6534F2082E
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 07:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgAHHyp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 02:54:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:42030 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgAHHyo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jan 2020 02:54:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7BCA7AD2C;
        Wed,  8 Jan 2020 07:54:41 +0000 (UTC)
Subject: Re: [PATCH v2 05/32] elx: libefc_sli: Populate and post different
 WQEs
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-6-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <e643b215-133b-5740-9e41-9f59129d6ac4@suse.de>
Date:   Wed, 8 Jan 2020 08:54:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-6-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/20/19 11:36 PM, James Smart wrote:
> This patch continues the libefc_sli SLI-4 library population.
> 
> This patch adds service routines to create different WQEs and adds
> APIs to issue iread, iwrite, treceive, tsend and other work queue
> entries.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/libefc_sli/sli4.c | 1717 ++++++++++++++++++++++++++++++++++++
>  drivers/scsi/elx/libefc_sli/sli4.h |    2 +
>  2 files changed, 1719 insertions(+)
> 
> diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
> index 7061f7980fad..2ebe0235bc9e 100644
> --- a/drivers/scsi/elx/libefc_sli/sli4.c
> +++ b/drivers/scsi/elx/libefc_sli/sli4.c
> @@ -1580,3 +1580,1720 @@ sli_cq_parse(struct sli4 *sli4, struct sli4_queue *cq, u8 *cqe,
>  
>  	return rc;
>  }
> +
> +/* Write an ABORT_WQE work queue entry */
> +int
> +sli_abort_wqe(struct sli4 *sli4, void *buf, size_t size,
> +	      enum sli4_abort_type type, bool send_abts, u32 ids,
> +	      u32 mask, u16 tag, u16 cq_id)
> +{
> +	struct sli4_abort_wqe	*abort = buf;
> +
> +	memset(buf, 0, size);
> +
> +	switch (type) {
> +	case SLI_ABORT_XRI:
> +		abort->criteria = SLI4_ABORT_CRITERIA_XRI_TAG;
> +		if (mask) {
> +			efc_log_warn(sli4, "%#x aborting XRI %#x warning non-zero mask",
> +				mask, ids);
> +			mask = 0;
> +		}
> +		break;
> +	case SLI_ABORT_ABORT_ID:
> +		abort->criteria = SLI4_ABORT_CRITERIA_ABORT_TAG;
> +		break;
> +	case SLI_ABORT_REQUEST_ID:
> +		abort->criteria = SLI4_ABORT_CRITERIA_REQUEST_TAG;
> +		break;
> +	default:
> +		efc_log_info(sli4, "unsupported type %#x\n", type);
> +		return EFC_FAIL;
> +	}
> +
> +	abort->ia_ir_byte |= send_abts ? 0 : 1;
> +
> +	/* Suppress ABTS retries */
> +	abort->ia_ir_byte |= SLI4_ABRT_WQE_IR;
> +
> +	abort->t_mask = cpu_to_le32(mask);
> +	abort->t_tag  = cpu_to_le32(ids);
> +	abort->command = SLI4_WQE_ABORT;
> +	abort->request_tag = cpu_to_le16(tag);
> +
> +	abort->dw10w0_flags = cpu_to_le16(SLI4_ABRT_WQE_QOSD);
> +
> +	abort->cq_id = cpu_to_le16(cq_id);
> +	abort->cmdtype_wqec_byte |= SLI4_CMD_ABORT_WQE;
> +
> +	return EFC_SUCCESS;
> +}
> +
> +/* Write an ELS_REQUEST64_WQE work queue entry */
> +int
> +sli_els_request64_wqe(struct sli4 *sli4, void *buf, size_t size,
> +		      struct efc_dma *sgl,
> +		      u8 req_type, u32 req_len, u32 max_rsp_len,
> +		      u8 timeout, u16 xri, u16 tag,
> +		      u16 cq_id, u16 rnodeindicator, u16 sportindicator,
> +		      bool hlm, bool rnodeattached, u32 rnode_fcid,
> +		      u32 sport_fcid)
> +{
> +	struct sli4_els_request64_wqe	*els = buf;
> +	struct sli4_sge *sge = sgl->virt;
> +	bool is_fabric = false;
> +	struct sli4_bde *bptr;
> +
> +	memset(buf, 0, size);
> +
> +	bptr = &els->els_request_payload;
> +	if (sli4->sgl_pre_registered) {
> +		els->qosd_xbl_hlm_iod_dbde_wqes &= ~SLI4_REQ_WQE_XBL;
> +
> +		els->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_REQ_WQE_DBDE;
> +		bptr->bde_type_buflen =
> +			cpu_to_le32((BDE_TYPE_BDE_64 << BDE_TYPE_SHIFT) |
> +				    (req_len & SLI4_BDE_MASK_BUFFER_LEN));
> +
> +		bptr->u.data.low  = sge[0].buffer_address_low;
> +		bptr->u.data.high = sge[0].buffer_address_high;
> +	} else {
> +		els->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_REQ_WQE_XBL;
> +
> +		bptr->bde_type_buflen =
> +			cpu_to_le32((BDE_TYPE_BLP << BDE_TYPE_SHIFT) |
> +				    ((2 * sizeof(struct sli4_sge)) &
> +				     SLI4_BDE_MASK_BUFFER_LEN));
> +		bptr->u.blp.low  = cpu_to_le32(lower_32_bits(sgl->phys));
> +		bptr->u.blp.high = cpu_to_le32(upper_32_bits(sgl->phys));
> +	}
> +
> +	els->els_request_payload_length = cpu_to_le32(req_len);
> +	els->max_response_payload_length = cpu_to_le32(max_rsp_len);
> +
> +	els->xri_tag = cpu_to_le16(xri);
> +	els->timer = timeout;
> +	els->class_byte |= SLI4_GENERIC_CLASS_CLASS_3;
> +
> +	els->command = SLI4_WQE_ELS_REQUEST64;
> +
> +	els->request_tag = cpu_to_le16(tag);
> +
> +	if (hlm) {
> +		els->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_REQ_WQE_HLM;
> +		els->remote_id_dword = cpu_to_le32(rnode_fcid & 0x00ffffff);
> +	}
> +
> +	els->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_REQ_WQE_IOD;
> +
> +	els->qosd_xbl_hlm_iod_dbde_wqes |= SLI4_REQ_WQE_QOSD;
> +
> +	/* figure out the ELS_ID value from the request buffer */
> +
> +	switch (req_type) {
> +	case ELS_LOGO:
> +		els->cmdtype_elsid_byte |=
> +			SLI4_ELS_REQUEST64_LOGO << SLI4_REQ_WQE_ELSID_SHFT;
> +		if (rnodeattached) {
> +			els->ct_byte |= (SLI4_GENERIC_CONTEXT_RPI <<
> +					 SLI4_REQ_WQE_CT_SHFT);
> +			els->context_tag = cpu_to_le16(rnodeindicator);
> +		} else {
> +			els->ct_byte |=
> +			SLI4_GENERIC_CONTEXT_VPI << SLI4_REQ_WQE_CT_SHFT;
> +			els->context_tag =
> +				cpu_to_le16(sportindicator);
> +		}
> +		if (rnode_fcid == FC_FID_FLOGI)
> +			is_fabric = true;
> +		break;
> +	case ELS_FDISC:
> +		if (rnode_fcid == FC_FID_FLOGI)
> +			is_fabric = true;
> +		if (sport_fcid == 0) {
> +			els->cmdtype_elsid_byte |=
> +			SLI4_ELS_REQUEST64_FDISC << SLI4_REQ_WQE_ELSID_SHFT;
> +			is_fabric = true;
> +		} else {
> +			els->cmdtype_elsid_byte |=
> +			SLI4_ELS_REQUEST64_OTHER << SLI4_REQ_WQE_ELSID_SHFT;
> +		}
> +		els->ct_byte |= (SLI4_GENERIC_CONTEXT_VPI <<
> +				 SLI4_REQ_WQE_CT_SHFT);
> +		els->context_tag = cpu_to_le16(sportindicator);
> +		els->sid_sp_dword |= cpu_to_le32(1 << SLI4_REQ_WQE_SP_SHFT);
> +		break;
> +	case ELS_FLOGI:
> +		els->ct_byte |=
> +			SLI4_GENERIC_CONTEXT_VPI << SLI4_REQ_WQE_CT_SHFT;
> +		els->context_tag = cpu_to_le16(sportindicator);
> +		/*
> +		 * Set SP here ... we haven't done a REG_VPI yet
> +		 * need to maybe not set this when we have
> +		 * completed VFI/VPI registrations ...
> +		 *
> +		 * Use the FC_ID of the SPORT if it has been allocated,
> +		 * otherwise use an S_ID of zero.
> +		 */
> +		els->sid_sp_dword |= cpu_to_le32(1 << SLI4_REQ_WQE_SP_SHFT);
> +		if (sport_fcid != U32_MAX)
> +			els->sid_sp_dword |= cpu_to_le32(sport_fcid);
> +		break;
> +	case ELS_PLOGI:
> +		els->cmdtype_elsid_byte |=
> +			SLI4_ELS_REQUEST64_PLOGI << SLI4_REQ_WQE_ELSID_SHFT;
> +		els->ct_byte |=
> +			SLI4_GENERIC_CONTEXT_VPI << SLI4_REQ_WQE_CT_SHFT;
> +		els->context_tag = cpu_to_le16(sportindicator);
> +		break;
> +	case ELS_SCR:
> +		els->cmdtype_elsid_byte |=
> +			SLI4_ELS_REQUEST64_OTHER << SLI4_REQ_WQE_ELSID_SHFT;
> +		els->ct_byte |=
> +			SLI4_GENERIC_CONTEXT_VPI << SLI4_REQ_WQE_CT_SHFT;
> +		els->context_tag = cpu_to_le16(sportindicator);
> +		break;
> +	default:
> +		els->cmdtype_elsid_byte |=
> +			SLI4_ELS_REQUEST64_OTHER << SLI4_REQ_WQE_ELSID_SHFT;
> +		if (rnodeattached) {
> +			els->ct_byte |= (SLI4_GENERIC_CONTEXT_RPI <<
> +					 SLI4_REQ_WQE_CT_SHFT);
> +			els->context_tag = cpu_to_le16(sportindicator);
> +		} else {
> +			els->ct_byte |=
> +			SLI4_GENERIC_CONTEXT_VPI << SLI4_REQ_WQE_CT_SHFT;
> +			els->context_tag =
> +				cpu_to_le16(sportindicator);
> +		}
> +		break;
> +	}
> +
> +	if (is_fabric)
> +		els->cmdtype_elsid_byte |= SLI4_ELS_REQUEST64_CMD_FABRIC;
> +	else
> +		els->cmdtype_elsid_byte |= SLI4_ELS_REQUEST64_CMD_NON_FABRIC;
> +
> +	els->cq_id = cpu_to_le16(cq_id);
> +
> +	if (((els->ct_byte & SLI4_REQ_WQE_CT) >> SLI4_REQ_WQE_CT_SHFT) !=
> +					SLI4_GENERIC_CONTEXT_RPI)
> +		els->remote_id_dword = cpu_to_le32(rnode_fcid);
> +
> +	if (((els->ct_byte & SLI4_REQ_WQE_CT) >> SLI4_REQ_WQE_CT_SHFT) ==
> +					SLI4_GENERIC_CONTEXT_VPI)
> +		els->temporary_rpi = cpu_to_le16(rnodeindicator);
> +
> +	return EFC_SUCCESS;
> +}
> +
You seem to have given up using EFC_SUCCESS / EFC_FAIL for the next few
functions.
Please be consistent here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

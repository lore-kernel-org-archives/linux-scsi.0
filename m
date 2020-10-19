Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBB5C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 15:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 117AB22363
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 15:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbgJSPVv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 11:21:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:49350 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729075AbgJSPVv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Oct 2020 11:21:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F323FAD2C;
        Mon, 19 Oct 2020 15:21:47 +0000 (UTC)
Subject: Re: [PATCH v4 02/31] elx: libefc_sli: SLI Descriptors and Queue
 entries
To:     James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
 <20201012225147.54404-3-james.smart@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <71db0b09-67a4-5e8b-36a7-f8d1de9c566f@suse.de>
Date:   Mon, 19 Oct 2020 17:21:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201012225147.54404-3-james.smart@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/13/20 12:51 AM, James Smart wrote:
> This patch continues the libefc_sli SLI-4 library population.
> 
> This patch add SLI-4 Data structures and defines for:
> - Buffer Descriptors (BDEs)
> - Scatter/Gather List elements (SGEs)
> - Queues and their Entry Descriptions for:
>     Event Queues (EQs), Completion Queues (CQs),
>     Receive Queues (RQs), and the Mailbox Queue (MQ).
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> 
> ---
> v4:
>    Added SLI4_ prefix to missing defines
>    Indentation changes.
>    Moved driver specific structures to the end of the file.
> ---
>   drivers/scsi/elx/include/efc_common.h |   25 +
>   drivers/scsi/elx/libefc_sli/sli4.h    | 1783 +++++++++++++++++++++++++
>   2 files changed, 1808 insertions(+)
>   create mode 100644 drivers/scsi/elx/include/efc_common.h
> 
> diff --git a/drivers/scsi/elx/include/efc_common.h b/drivers/scsi/elx/include/efc_common.h
> new file mode 100644
> index 000000000000..a3f0465b1fd7
> --- /dev/null
> +++ b/drivers/scsi/elx/include/efc_common.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +#ifndef __EFC_COMMON_H__
> +#define __EFC_COMMON_H__
> +
> +#include <linux/pci.h>
> +
> +#define EFC_SUCCESS	0
> +#define EFC_FAIL	1
> +

You said you were going to kill this ...

[ .. ]
> +	SLI4_LNK_ATTN_TYPE_NO_HARD_ALPA		= 0x03,
> +
> +	SLI4_LNK_ATTN_P2P			= 0x01,
> +	SLI4_LNK_ATTN_FC_AL			= 0x02,
> +	SLI4_LNK_ATTN_INTERNAL_LOOPBACK		= 0x03,
> +	SLI4_LNK_ATTN_SERDES_LOOPBACK		= 0x04,
> +
> +	SLI4_LNK_ATTN_1G			= 0x01,
> +	SLI4_LNK_ATTN_2G			= 0x02,
> +	SLI4_LNK_ATTN_4G			= 0x04,
> +	SLI4_LNK_ATTN_8G			= 0x08,
> +	SLI4_LNK_ATTN_10G			= 0x0a,
> +	SLI4_LNK_ATTN_16G			= 0x10,
> +};
> +

Ah. 16G Only?

> +struct sli4_link_attention {
> +	u8		link_number;
> +	u8		attn_type;
> +	u8		topology;
> +	u8		port_speed;
> +	u8		port_fault;
> +	u8		shared_link_status;
> +	__le16		logical_link_speed;
> +	__le32		event_tag;
> +	u8		rsvd12;
> +	u8		event_code;
> +	u8		event_type;
> +	u8		flags;
> +};
> +
> +enum sli4_link_event_type {
> +	SLI4_EVENT_LINK_ATTENTION		= 0x01,
> +	SLI4_EVENT_SHARED_LINK_ATTENTION	= 0x02,
> +};
> +
> +enum sli4_wcqe_flags {
> +	SLI4_WCQE_XB = 0x10,
> +	SLI4_WCQE_QX = 0x80,
> +};
> +
> +struct sli4_fc_wcqe {
> +	u8		hw_status;
> +	u8		status;
> +	__le16		request_tag;
> +	__le32		wqe_specific_1;
> +	__le32		wqe_specific_2;
> +	u8		rsvd12;
> +	u8		qx_byte;
> +	u8		code;
> +	u8		flags;
> +};
> +
> +/* FC WQ consumed CQ queue entry */
> +struct sli4_fc_wqec {
> +	__le32		rsvd0;
> +	__le32		rsvd1;
> +	__le16		wqe_index;
> +	__le16		wq_id;
> +	__le16		rsvd12;
> +	u8		code;
> +	u8		vld_byte;
> +};
> +
> +/* FC Completion Status Codes. */
> +enum sli4_wcqe_status {
> +	SLI4_FC_WCQE_STATUS_SUCCESS,
> +	SLI4_FC_WCQE_STATUS_FCP_RSP_FAILURE,
> +	SLI4_FC_WCQE_STATUS_REMOTE_STOP,
> +	SLI4_FC_WCQE_STATUS_LOCAL_REJECT,
> +	SLI4_FC_WCQE_STATUS_NPORT_RJT,
> +	SLI4_FC_WCQE_STATUS_FABRIC_RJT,
> +	SLI4_FC_WCQE_STATUS_NPORT_BSY,
> +	SLI4_FC_WCQE_STATUS_FABRIC_BSY,
> +	SLI4_FC_WCQE_STATUS_RSVD,
> +	SLI4_FC_WCQE_STATUS_LS_RJT,
> +	SLI4_FC_WCQE_STATUS_RX_BUF_OVERRUN,
> +	SLI4_FC_WCQE_STATUS_CMD_REJECT,
> +	SLI4_FC_WCQE_STATUS_FCP_TGT_LENCHECK,
> +	SLI4_FC_WCQE_STATUS_RSVD1,
> +	SLI4_FC_WCQE_STATUS_ELS_CMPLT_NO_AUTOREG,
> +	SLI4_FC_WCQE_STATUS_RSVD2,
> +	SLI4_FC_WCQE_STATUS_RQ_SUCCESS,
> +	SLI4_FC_WCQE_STATUS_RQ_BUF_LEN_EXCEEDED,
> +	SLI4_FC_WCQE_STATUS_RQ_INSUFF_BUF_NEEDED,
> +	SLI4_FC_WCQE_STATUS_RQ_INSUFF_FRM_DISC,
> +	SLI4_FC_WCQE_STATUS_RQ_DMA_FAILURE,
> +	SLI4_FC_WCQE_STATUS_FCP_RSP_TRUNCATE,
> +	SLI4_FC_WCQE_STATUS_DI_ERROR,
> +	SLI4_FC_WCQE_STATUS_BA_RJT,
> +	SLI4_FC_WCQE_STATUS_RQ_INSUFF_XRI_NEEDED,
> +	SLI4_FC_WCQE_STATUS_RQ_INSUFF_XRI_DISC,
> +	SLI4_FC_WCQE_STATUS_RX_ERROR_DETECT,
> +	SLI4_FC_WCQE_STATUS_RX_ABORT_REQUEST,
> +
> +	/* driver generated status codes */
> +	SLI4_FC_WCQE_STATUS_DISPATCH_ERROR	= 0xfd,
> +	SLI4_FC_WCQE_STATUS_SHUTDOWN		= 0xfe,
> +	SLI4_FC_WCQE_STATUS_TARGET_WQE_TIMEOUT	= 0xff,
> +};
> +
> +/* DI_ERROR Extended Status */
> +enum sli4_fc_di_error_status {
> +	SLI4_FC_DI_ERROR_GE			= 1 << 0,
> +	SLI4_FC_DI_ERROR_AE			= 1 << 1,
> +	SLI4_FC_DI_ERROR_RE			= 1 << 2,
> +	SLI4_FC_DI_ERROR_TDPV			= 1 << 3,
> +	SLI4_FC_DI_ERROR_UDB			= 1 << 4,
> +	SLI4_FC_DI_ERROR_EDIR			= 1 << 5,
> +};
> +
> +/* WQE DIF field contents */
> +enum sli4_dif_fields {
> +	SLI4_DIF_DISABLED,
> +	SLI4_DIF_PASS_THROUGH,
> +	SLI4_DIF_STRIP,
> +	SLI4_DIF_INSERT,
> +};
> +
> +/* Work Queue Entry (WQE) types */
> +enum sli4_wqe_types {
> +	SLI4_WQE_ABORT				= 0x0f,
> +	SLI4_WQE_ELS_REQUEST64			= 0x8a,
> +	SLI4_WQE_FCP_IBIDIR64			= 0xac,
> +	SLI4_WQE_FCP_IREAD64			= 0x9a,
> +	SLI4_WQE_FCP_IWRITE64			= 0x98,
> +	SLI4_WQE_FCP_ICMND64			= 0x9c,
> +	SLI4_WQE_FCP_TRECEIVE64			= 0xa1,
> +	SLI4_WQE_FCP_CONT_TRECEIVE64		= 0xe5,
> +	SLI4_WQE_FCP_TRSP64			= 0xa3,
> +	SLI4_WQE_FCP_TSEND64			= 0x9f,
> +	SLI4_WQE_GEN_REQUEST64			= 0xc2,
> +	SLI4_WQE_SEND_FRAME			= 0xe1,
> +	SLI4_WQE_XMIT_BCAST64			= 0x84,
> +	SLI4_WQE_XMIT_BLS_RSP			= 0x97,
> +	SLI4_WQE_ELS_RSP64			= 0x95,
> +	SLI4_WQE_XMIT_SEQUENCE64		= 0x82,
> +	SLI4_WQE_REQUEUE_XRI			= 0x93,
> +};
> +
> +/* WQE command types */
> +enum sli4_wqe_cmds {
> +	SLI4_CMD_FCP_IREAD64_WQE		= 0x00,
> +	SLI4_CMD_FCP_ICMND64_WQE		= 0x00,
> +	SLI4_CMD_FCP_IWRITE64_WQE		= 0x01,
> +	SLI4_CMD_FCP_TRECEIVE64_WQE		= 0x02,
> +	SLI4_CMD_FCP_TRSP64_WQE			= 0x03,
> +	SLI4_CMD_FCP_TSEND64_WQE		= 0x07,
> +	SLI4_CMD_GEN_REQUEST64_WQE		= 0x08,
> +	SLI4_CMD_XMIT_BCAST64_WQE		= 0x08,
> +	SLI4_CMD_XMIT_BLS_RSP64_WQE		= 0x08,
> +	SLI4_CMD_ABORT_WQE			= 0x08,
> +	SLI4_CMD_XMIT_SEQUENCE64_WQE		= 0x08,
> +	SLI4_CMD_REQUEUE_XRI_WQE		= 0x0a,
> +	SLI4_CMD_SEND_FRAME_WQE			= 0x0a,
> +};
> +
> +#define SLI4_WQE_SIZE		0x05
> +#define SLI4_WQE_EXT_SIZE	0x06
> +
> +#define SLI4_WQE_BYTES		(16 * sizeof(u32))
> +#define SLI4_WQE_EXT_BYTES	(32 * sizeof(u32))
> +
> +/* Mask for ccp (CS_CTL) */
> +#define SLI4_MASK_CCP		0xfe
> +
> +/* Generic WQE */
> +enum sli4_gen_wqe_flags {
> +	SLI4_GEN_WQE_EBDECNT	= 0xf,
> +	SLI4_GEN_WQE_LEN_LOC	= 0x3 << 7,
> +	SLI4_GEN_WQE_QOSD	= 1 << 9,
> +	SLI4_GEN_WQE_XBL	= 1 << 11,
> +	SLI4_GEN_WQE_HLM	= 1 << 12,
> +	SLI4_GEN_WQE_IOD	= 1 << 13,
> +	SLI4_GEN_WQE_DBDE	= 1 << 14,
> +	SLI4_GEN_WQE_WQES	= 1 << 15,
> +
> +	SLI4_GEN_WQE_PRI	= 0x7,
> +	SLI4_GEN_WQE_PV		= 1 << 3,
> +	SLI4_GEN_WQE_EAT	= 1 << 4,
> +	SLI4_GEN_WQE_XC		= 1 << 5,
> +	SLI4_GEN_WQE_CCPE	= 1 << 7,
> +
> +	SLI4_GEN_WQE_CMDTYPE	= 0xf,
> +	SLI4_GEN_WQE_WQEC	= 1 << 7,
> +};
> +
> +struct sli4_generic_wqe {
> +	__le32		cmd_spec0_5[6];
> +	__le16		xri_tag;
> +	__le16		context_tag;
> +	u8		ct_byte;
> +	u8		command;
> +	u8		class_byte;
> +	u8		timer;
> +	__le32		abort_tag;
> +	__le16		request_tag;
> +	__le16		rsvd34;
> +	__le16		dw10w0_flags;
> +	u8		eat_xc_ccpe;
> +	u8		ccp;
> +	u8		cmdtype_wqec_byte;
> +	u8		rsvd41;
> +	__le16		cq_id;
> +};
> +
> +/* WQE used to abort exchanges. */
> +enum sli4_abort_wqe_flags {
> +	SLI4_ABRT_WQE_IR	= 0x02,
> +
> +	SLI4_ABRT_WQE_EBDECNT	= 0xf,
> +	SLI4_ABRT_WQE_LEN_LOC	= 0x3 << 7,
> +	SLI4_ABRT_WQE_QOSD	= 1 << 9,
> +	SLI4_ABRT_WQE_XBL	= 1 << 11,
> +	SLI4_ABRT_WQE_IOD	= 1 << 13,
> +	SLI4_ABRT_WQE_DBDE	= 1 << 14,
> +	SLI4_ABRT_WQE_WQES	= 1 << 15,
> +
> +	SLI4_ABRT_WQE_PRI	= 0x7,
> +	SLI4_ABRT_WQE_PV	= 1 << 3,
> +	SLI4_ABRT_WQE_EAT	= 1 << 4,
> +	SLI4_ABRT_WQE_XC	= 1 << 5,
> +	SLI4_ABRT_WQE_CCPE	= 1 << 7,
> +
> +	SLI4_ABRT_WQE_CMDTYPE	= 0xf,
> +	SLI4_ABRT_WQE_WQEC	= 1 << 7,
> +};
> +
> +struct sli4_abort_wqe {
> +	__le32		rsvd0;
> +	__le32		rsvd4;
> +	__le32		ext_t_tag;
> +	u8		ia_ir_byte;
> +	u8		criteria;
> +	__le16		rsvd10;
> +	__le32		ext_t_mask;
> +	__le32		t_mask;
> +	__le16		xri_tag;
> +	__le16		context_tag;
> +	u8		ct_byte;
> +	u8		command;
> +	u8		class_byte;
> +	u8		timer;
> +	__le32		t_tag;
> +	__le16		request_tag;
> +	__le16		rsvd34;
> +	__le16		dw10w0_flags;
> +	u8		eat_xc_ccpe;
> +	u8		ccp;
> +	u8		cmdtype_wqec_byte;
> +	u8		rsvd41;
> +	__le16		cq_id;
> +};
> +
> +enum sli4_abort_criteria {
> +	SLI4_ABORT_CRITERIA_XRI_TAG = 0x01,
> +	SLI4_ABORT_CRITERIA_ABORT_TAG,
> +	SLI4_ABORT_CRITERIA_REQUEST_TAG,
> +	SLI4_ABORT_CRITERIA_EXT_ABORT_TAG,
> +};
> +
> +enum sli4_abort_type {
> +	SLI4_ABORT_XRI,
> +	SLI4_ABORT_ABORT_ID,
> +	SLI4_ABORT_REQUEST_ID,
> +	SLI4_ABORT_MAX,		/* must be last */
> +};
> +
> +/* WQE used to create an ELS request. */
> +enum sli4_els_req_wqe_flags {
> +	SLI4_REQ_WQE_QOSD		= 0x2,
> +	SLI4_REQ_WQE_DBDE		= 0x40,
> +	SLI4_REQ_WQE_XBL		= 0x8,
> +	SLI4_REQ_WQE_XC			= 0x20,
> +	SLI4_REQ_WQE_IOD		= 0x20,
> +	SLI4_REQ_WQE_HLM		= 0x10,
> +	SLI4_REQ_WQE_CCPE		= 0x80,
> +	SLI4_REQ_WQE_EAT		= 0x10,
> +	SLI4_REQ_WQE_WQES		= 0x80,
> +	SLI4_REQ_WQE_PU_SHFT		= 4,
> +	SLI4_REQ_WQE_CT_SHFT		= 2,
> +	SLI4_REQ_WQE_CT			= 0xc,
> +	SLI4_REQ_WQE_ELSID_SHFT		= 4,
> +	SLI4_REQ_WQE_SP_SHFT		= 24,
> +	SLI4_REQ_WQE_LEN_LOC_BIT1	= 0x80,
> +	SLI4_REQ_WQE_LEN_LOC_BIT2	= 0x1,
> +};
> +
> +struct sli4_els_request64_wqe {
> +	struct sli4_bde	els_request_payload;
> +	__le32		els_request_payload_length;
> +	__le32		sid_sp_dword;
> +	__le32		remote_id_dword;
> +	__le16		xri_tag;
> +	__le16		context_tag;
> +	u8		ct_byte;
> +	u8		command;
> +	u8		class_byte;
> +	u8		timer;
> +	__le32		abort_tag;
> +	__le16		request_tag;
> +	__le16		temporary_rpi;
> +	u8		len_loc1_byte;
> +	u8		qosd_xbl_hlm_iod_dbde_wqes;
> +	u8		eat_xc_ccpe;
> +	u8		ccp;
> +	u8		cmdtype_elsid_byte;
> +	u8		rsvd41;
> +	__le16		cq_id;
> +	struct sli4_bde	els_response_payload_bde;
> +	__le32		max_response_payload_length;
> +};
> +
> +/* WQE used to create an FCP initiator no data command. */
> +enum sli4_icmd_wqe_flags {
> +	SLI4_ICMD_WQE_DBDE		= 0x40,
> +	SLI4_ICMD_WQE_XBL		= 0x8,
> +	SLI4_ICMD_WQE_XC		= 0x20,
> +	SLI4_ICMD_WQE_IOD		= 0x20,
> +	SLI4_ICMD_WQE_HLM		= 0x10,
> +	SLI4_ICMD_WQE_CCPE		= 0x80,
> +	SLI4_ICMD_WQE_EAT		= 0x10,
> +	SLI4_ICMD_WQE_APPID		= 0x10,
> +	SLI4_ICMD_WQE_WQES		= 0x80,
> +	SLI4_ICMD_WQE_PU_SHFT		= 4,
> +	SLI4_ICMD_WQE_CT_SHFT		= 2,
> +	SLI4_ICMD_WQE_BS_SHFT		= 4,
> +	SLI4_ICMD_WQE_LEN_LOC_BIT1	= 0x80,
> +	SLI4_ICMD_WQE_LEN_LOC_BIT2	= 0x1,
> +};
> +
> +struct sli4_fcp_icmnd64_wqe {
> +	struct sli4_bde	bde;
> +	__le16		payload_offset_length;
> +	__le16		fcp_cmd_buffer_length;
> +	__le32		rsvd12;
> +	__le32		remote_n_port_id_dword;
> +	__le16		xri_tag;
> +	__le16		context_tag;
> +	u8		dif_ct_bs_byte;
> +	u8		command;
> +	u8		class_pu_byte;
> +	u8		timer;
> +	__le32		abort_tag;
> +	__le16		request_tag;
> +	__le16		rsvd34;
> +	u8		len_loc1_byte;
> +	u8		qosd_xbl_hlm_iod_dbde_wqes;
> +	u8		eat_xc_ccpe;
> +	u8		ccp;
> +	u8		cmd_type_byte;
> +	u8		rsvd41;
> +	__le16		cq_id;
> +	__le32		rsvd44;
> +	__le32		rsvd48;
> +	__le32		rsvd52;
> +	__le32		rsvd56;
> +};
> +
> +/* WQE used to create an FCP initiator read. */
> +enum sli4_ir_wqe_flags {
> +	SLI4_IR_WQE_DBDE		= 0x40,
> +	SLI4_IR_WQE_XBL			= 0x8,
> +	SLI4_IR_WQE_XC			= 0x20,
> +	SLI4_IR_WQE_IOD			= 0x20,
> +	SLI4_IR_WQE_HLM			= 0x10,
> +	SLI4_IR_WQE_CCPE		= 0x80,
> +	SLI4_IR_WQE_EAT			= 0x10,
> +	SLI4_IR_WQE_APPID		= 0x10,
> +	SLI4_IR_WQE_WQES		= 0x80,
> +	SLI4_IR_WQE_PU_SHFT		= 4,
> +	SLI4_IR_WQE_CT_SHFT		= 2,
> +	SLI4_IR_WQE_BS_SHFT		= 4,
> +	SLI4_IR_WQE_LEN_LOC_BIT1	= 0x80,
> +	SLI4_IR_WQE_LEN_LOC_BIT2	= 0x1,
> +};
> +
> +struct sli4_fcp_iread64_wqe {
> +	struct sli4_bde	bde;
> +	__le16		payload_offset_length;
> +	__le16		fcp_cmd_buffer_length;
> +
> +	__le32		total_transfer_length;
> +
> +	__le32		remote_n_port_id_dword;
> +
> +	__le16		xri_tag;
> +	__le16		context_tag;
> +
> +	u8		dif_ct_bs_byte;
> +	u8		command;
> +	u8		class_pu_byte;
> +	u8		timer;
> +
> +	__le32		abort_tag;
> +
> +	__le16		request_tag;
> +	__le16		rsvd34;
> +
> +	u8		len_loc1_byte;
> +	u8		qosd_xbl_hlm_iod_dbde_wqes;
> +	u8		eat_xc_ccpe;
> +	u8		ccp;
> +
> +	u8		cmd_type_byte;
> +	u8		rsvd41;
> +	__le16		cq_id;
> +
> +	__le32		rsvd44;
> +	struct sli4_bde	first_data_bde;
> +};
> +
> +/* WQE used to create an FCP initiator write. */
> +enum sli4_iwr_wqe_flags {
> +	SLI4_IWR_WQE_DBDE		= 0x40,
> +	SLI4_IWR_WQE_XBL		= 0x8,
> +	SLI4_IWR_WQE_XC			= 0x20,
> +	SLI4_IWR_WQE_IOD		= 0x20,
> +	SLI4_IWR_WQE_HLM		= 0x10,
> +	SLI4_IWR_WQE_DNRX		= 0x10,
> +	SLI4_IWR_WQE_CCPE		= 0x80,
> +	SLI4_IWR_WQE_EAT		= 0x10,
> +	SLI4_IWR_WQE_APPID		= 0x10,
> +	SLI4_IWR_WQE_WQES		= 0x80,
> +	SLI4_IWR_WQE_PU_SHFT		= 4,
> +	SLI4_IWR_WQE_CT_SHFT		= 2,
> +	SLI4_IWR_WQE_BS_SHFT		= 4,
> +	SLI4_IWR_WQE_LEN_LOC_BIT1	= 0x80,
> +	SLI4_IWR_WQE_LEN_LOC_BIT2	= 0x1,
> +};
> +
> +struct sli4_fcp_iwrite64_wqe {
> +	struct sli4_bde	bde;
> +	__le16		payload_offset_length;
> +	__le16		fcp_cmd_buffer_length;
> +	__le16		total_transfer_length;
> +	__le16		initial_transfer_length;
> +	__le16		xri_tag;
> +	__le16		context_tag;
> +	u8		dif_ct_bs_byte;
> +	u8		command;
> +	u8		class_pu_byte;
> +	u8		timer;
> +	__le32		abort_tag;
> +	__le16		request_tag;
> +	__le16		rsvd34;
> +	u8		len_loc1_byte;
> +	u8		qosd_xbl_hlm_iod_dbde_wqes;
> +	u8		eat_xc_ccpe;
> +	u8		ccp;
> +	u8		cmd_type_byte;
> +	u8		rsvd41;
> +	__le16		cq_id;
> +	__le32		remote_n_port_id_dword;
> +	struct sli4_bde	first_data_bde;
> +};
> +
> +struct sli4_fcp_128byte_wqe {
> +	u32 dw[32];
> +};
> +
> +/* WQE used to create an FCP target receive */
> +enum sli4_trcv_wqe_flags {
> +	SLI4_TRCV_WQE_DBDE		= 0x40,
> +	SLI4_TRCV_WQE_XBL		= 0x8,
> +	SLI4_TRCV_WQE_AR		= 0x8,
> +	SLI4_TRCV_WQE_XC		= 0x20,
> +	SLI4_TRCV_WQE_IOD		= 0x20,
> +	SLI4_TRCV_WQE_HLM		= 0x10,
> +	SLI4_TRCV_WQE_DNRX		= 0x10,
> +	SLI4_TRCV_WQE_CCPE		= 0x80,
> +	SLI4_TRCV_WQE_EAT		= 0x10,
> +	SLI4_TRCV_WQE_APPID		= 0x10,
> +	SLI4_TRCV_WQE_WQES		= 0x80,
> +	SLI4_TRCV_WQE_PU_SHFT		= 4,
> +	SLI4_TRCV_WQE_CT_SHFT		= 2,
> +	SLI4_TRCV_WQE_BS_SHFT		= 4,
> +	SLI4_TRCV_WQE_LEN_LOC_BIT2	= 0x1,
> +};
> +
> +struct sli4_fcp_treceive64_wqe {
> +	struct sli4_bde	bde;
> +	__le32		payload_offset_length;
> +	__le32		relative_offset;
> +	union {
> +		__le16	sec_xri_tag;
> +		__le16	rsvd;
> +		__le32	dword;
> +	} dword5;
> +	__le16		xri_tag;
> +	__le16		context_tag;
> +	u8		dif_ct_bs_byte;
> +	u8		command;
> +	u8		class_ar_pu_byte;
> +	u8		timer;
> +	__le32		abort_tag;
> +	__le16		request_tag;
> +	__le16		remote_xid;
> +	u8		lloc1_appid;
> +	u8		qosd_xbl_hlm_iod_dbde_wqes;
> +	u8		eat_xc_ccpe;
> +	u8		ccp;
> +	u8		cmd_type_byte;
> +	u8		rsvd41;
> +	__le16		cq_id;
> +	__le32		fcp_data_receive_length;
> +	struct sli4_bde	first_data_bde;
> +};
> +
> +/* WQE used to create an FCP target response */
> +enum sli4_trsp_wqe_flags {
> +	SLI4_TRSP_WQE_AG	= 0x8,
> +	SLI4_TRSP_WQE_DBDE	= 0x40,
> +	SLI4_TRSP_WQE_XBL	= 0x8,
> +	SLI4_TRSP_WQE_XC	= 0x20,
> +	SLI4_TRSP_WQE_HLM	= 0x10,
> +	SLI4_TRSP_WQE_DNRX	= 0x10,
> +	SLI4_TRSP_WQE_CCPE	= 0x80,
> +	SLI4_TRSP_WQE_EAT	= 0x10,
> +	SLI4_TRSP_WQE_APPID	= 0x10,
> +	SLI4_TRSP_WQE_WQES	= 0x80,
> +};
> +
> +struct sli4_fcp_trsp64_wqe {
> +	struct sli4_bde	bde;
> +	__le32		fcp_response_length;
> +	__le32		rsvd12;
> +	__le32		dword5;
> +	__le16		xri_tag;
> +	__le16		rpi;
> +	u8		ct_dnrx_byte;
> +	u8		command;
> +	u8		class_ag_byte;
> +	u8		timer;
> +	__le32		abort_tag;
> +	__le16		request_tag;
> +	__le16		remote_xid;
> +	u8		lloc1_appid;
> +	u8		qosd_xbl_hlm_dbde_wqes;
> +	u8		eat_xc_ccpe;
> +	u8		ccp;
> +	u8		cmd_type_byte;
> +	u8		rsvd41;
> +	__le16		cq_id;
> +	__le32		rsvd44;
> +	__le32		rsvd48;
> +	__le32		rsvd52;
> +	__le32		rsvd56;
> +};
> +
> +/* WQE used to create an FCP target send (DATA IN). */
> +enum sli4_tsend_wqe_flags {
> +	SLI4_TSEND_WQE_XBL	= 0x8,
> +	SLI4_TSEND_WQE_DBDE	= 0x40,
> +	SLI4_TSEND_WQE_IOD	= 0x20,
> +	SLI4_TSEND_WQE_QOSD	= 0x2,
> +	SLI4_TSEND_WQE_HLM	= 0x10,
> +	SLI4_TSEND_WQE_PU_SHFT	= 4,
> +	SLI4_TSEND_WQE_AR	= 0x8,
> +	SLI4_TSEND_CT_SHFT	= 2,
> +	SLI4_TSEND_BS_SHFT	= 4,
> +	SLI4_TSEND_LEN_LOC_BIT2 = 0x1,
> +	SLI4_TSEND_CCPE		= 0x80,
> +	SLI4_TSEND_APPID_VALID	= 0x20,
> +	SLI4_TSEND_WQES		= 0x80,
> +	SLI4_TSEND_XC		= 0x20,
> +	SLI4_TSEND_EAT		= 0x10,
> +};
> +
> +struct sli4_fcp_tsend64_wqe {
> +	struct sli4_bde	bde;
> +	__le32		payload_offset_length;
> +	__le32		relative_offset;
> +	__le32		dword5;
> +	__le16		xri_tag;
> +	__le16		rpi;
> +	u8		ct_byte;
> +	u8		command;
> +	u8		class_pu_ar_byte;
> +	u8		timer;
> +	__le32		abort_tag;
> +	__le16		request_tag;
> +	__le16		remote_xid;
> +	u8		dw10byte0;
> +	u8		ll_qd_xbl_hlm_iod_dbde;
> +	u8		dw10byte2;
> +	u8		ccp;
> +	u8		cmd_type_byte;
> +	u8		rsvd45;
> +	__le16		cq_id;
> +	__le32		fcp_data_transmit_length;
> +	struct sli4_bde	first_data_bde;
> +};
> +
> +/* WQE used to create a general request. */
> +enum sli4_gen_req_wqe_flags {
> +	SLI4_GEN_REQ64_WQE_XBL	= 0x8,
> +	SLI4_GEN_REQ64_WQE_DBDE	= 0x40,
> +	SLI4_GEN_REQ64_WQE_IOD	= 0x20,
> +	SLI4_GEN_REQ64_WQE_QOSD	= 0x2,
> +	SLI4_GEN_REQ64_WQE_HLM	= 0x10,
> +	SLI4_GEN_REQ64_CT_SHFT	= 2,
> +};
> +
> +struct sli4_gen_request64_wqe {
> +	struct sli4_bde	bde;
> +	__le32		request_payload_length;
> +	__le32		relative_offset;
> +	u8		rsvd17;
> +	u8		df_ctl;
> +	u8		type;
> +	u8		r_ctl;
> +	__le16		xri_tag;
> +	__le16		context_tag;
> +	u8		ct_byte;
> +	u8		command;
> +	u8		class_byte;
> +	u8		timer;
> +	__le32		abort_tag;
> +	__le16		request_tag;
> +	__le16		rsvd34;
> +	u8		dw10flags0;
> +	u8		dw10flags1;
> +	u8		dw10flags2;
> +	u8		ccp;
> +	u8		cmd_type_byte;
> +	u8		rsvd41;
> +	__le16		cq_id;
> +	__le32		remote_n_port_id_dword;
> +	__le32		rsvd48;
> +	__le32		rsvd52;
> +	__le32		max_response_payload_length;
> +};
> +
> +/* WQE used to create a send frame request */
> +enum sli4_sf_wqe_flags {
> +	SLI4_SF_WQE_DBDE	= 0x40,
> +	SLI4_SF_PU		= 0x30,
> +	SLI4_SF_CT		= 0xc,
> +	SLI4_SF_QOSD		= 0x2,
> +	SLI4_SF_LEN_LOC_BIT1	= 0x80,
> +	SLI4_SF_LEN_LOC_BIT2	= 0x1,
> +	SLI4_SF_XC		= 0x20,
> +	SLI4_SF_XBL		= 0x8,
> +};
> +
> +struct sli4_send_frame_wqe {
> +	struct sli4_bde	bde;
> +	__le32		frame_length;
> +	__le32		fc_header_0_1[2];
> +	__le16		xri_tag;
> +	__le16		context_tag;
> +	u8		ct_byte;
> +	u8		command;
> +	u8		dw7flags0;
> +	u8		timer;
> +	__le32		abort_tag;
> +	__le16		request_tag;
> +	u8		eof;
> +	u8		sof;
> +	u8		dw10flags0;
> +	u8		dw10flags1;
> +	u8		dw10flags2;
> +	u8		ccp;
> +	u8		cmd_type_byte;
> +	u8		rsvd41;
> +	__le16		cq_id;
> +	__le32		fc_header_2_5[4];
> +};
> +
> +/* WQE used to create a transmit sequence */
> +enum sli4_seq_wqe_flags {
> +	SLI4_SEQ_WQE_DBDE		= 0x4000,
> +	SLI4_SEQ_WQE_XBL		= 0x800,
> +	SLI4_SEQ_WQE_SI			= 0x4,
> +	SLI4_SEQ_WQE_FT			= 0x8,
> +	SLI4_SEQ_WQE_XO			= 0x40,
> +	SLI4_SEQ_WQE_LS			= 0x80,
> +	SLI4_SEQ_WQE_DIF		= 0x3,
> +	SLI4_SEQ_WQE_BS			= 0x70,
> +	SLI4_SEQ_WQE_PU			= 0x30,
> +	SLI4_SEQ_WQE_HLM		= 0x1000,
> +	SLI4_SEQ_WQE_IOD_SHIFT		= 13,
> +	SLI4_SEQ_WQE_CT_SHIFT		= 2,
> +	SLI4_SEQ_WQE_LEN_LOC_SHIFT	= 7,
> +};
> +
> +struct sli4_xmit_sequence64_wqe {
> +	struct sli4_bde	bde;
> +	__le32		remote_n_port_id_dword;
> +	__le32		relative_offset;
> +	u8		dw5flags0;
> +	u8		df_ctl;
> +	u8		type;
> +	u8		r_ctl;
> +	__le16		xri_tag;
> +	__le16		context_tag;
> +	u8		dw7flags0;
> +	u8		command;
> +	u8		dw7flags1;
> +	u8		timer;
> +	__le32		abort_tag;
> +	__le16		request_tag;
> +	__le16		remote_xid;
> +	__le16		dw10w0;
> +	u8		dw10flags0;
> +	u8		ccp;
> +	u8		cmd_type_wqec_byte;
> +	u8		rsvd45;
> +	__le16		cq_id;
> +	__le32		sequence_payload_len;
> +	__le32		rsvd48;
> +	__le32		rsvd52;
> +	__le32		rsvd56;
> +};
> +
> +/*
> + * WQE used unblock the specified XRI and to release
> + * it to the SLI Port's free pool.
> + */
> +enum sli4_requeue_wqe_flags {
> +	SLI4_REQU_XRI_WQE_XC	= 0x20,
> +	SLI4_REQU_XRI_WQE_QOSD	= 0x2,
> +};
> +
> +struct sli4_requeue_xri_wqe {
> +	__le32		rsvd0;
> +	__le32		rsvd4;
> +	__le32		rsvd8;
> +	__le32		rsvd12;
> +	__le32		rsvd16;
> +	__le32		rsvd20;
> +	__le16		xri_tag;
> +	__le16		context_tag;
> +	u8		ct_byte;
> +	u8		command;
> +	u8		class_byte;
> +	u8		timer;
> +	__le32		rsvd32;
> +	__le16		request_tag;
> +	__le16		rsvd34;
> +	__le16		flags0;
> +	__le16		flags1;
> +	__le16		flags2;
> +	u8		ccp;
> +	u8		cmd_type_wqec_byte;
> +	u8		rsvd42;
> +	__le16		cq_id;
> +	__le32		rsvd44;
> +	__le32		rsvd48;
> +	__le32		rsvd52;
> +	__le32		rsvd56;
> +};
> +
> +/* WQE used to create a BLS response */
> +enum sli4_bls_rsp_wqe_flags {
> +	SLI4_BLS_RSP_RID		= 0xffffff,
> +	SLI4_BLS_RSP_WQE_AR		= 0x40000000,
> +	SLI4_BLS_RSP_WQE_CT_SHFT	= 2,
> +	SLI4_BLS_RSP_WQE_QOSD		= 0x2,
> +	SLI4_BLS_RSP_WQE_HLM		= 0x10,
> +};
> +
> +struct sli4_xmit_bls_rsp_wqe {
> +	__le32		payload_word0;
> +	__le16		rx_id;
> +	__le16		ox_id;
> +	__le16		high_seq_cnt;
> +	__le16		low_seq_cnt;
> +	__le32		rsvd12;
> +	__le32		local_n_port_id_dword;
> +	__le32		remote_id_dword;
> +	__le16		xri_tag;
> +	__le16		context_tag;
> +	u8		dw8flags0;
> +	u8		command;
> +	u8		dw8flags1;
> +	u8		timer;
> +	__le32		abort_tag;
> +	__le16		request_tag;
> +	__le16		rsvd38;
> +	u8		dw11flags0;
> +	u8		dw11flags1;
> +	u8		dw11flags2;
> +	u8		ccp;
> +	u8		dw12flags0;
> +	u8		rsvd45;
> +	__le16		cq_id;
> +	__le16		temporary_rpi;
> +	u8		rsvd50;
> +	u8		rsvd51;
> +	__le32		rsvd52;
> +	__le32		rsvd56;
> +	__le32		rsvd60;
> +};
> +
> +enum sli_bls_type {
> +	SLI4_SLI_BLS_ACC,
> +	SLI4_SLI_BLS_RJT,
> +	SLI4_SLI_BLS_MAX
> +};
> +
> +struct sli_bls_payload {
> +	enum sli_bls_type	type;
> +	__le16			ox_id;
> +	__le16			rx_id;
> +	union {
> +		struct {
> +			u8	seq_id_validity;
> +			u8	seq_id_last;
> +			u8	rsvd2;
> +			u8	rsvd3;
> +			u16	ox_id;
> +			u16	rx_id;
> +			__le16	low_seq_cnt;
> +			__le16	high_seq_cnt;
> +		} acc;
> +		struct {
> +			u8	vendor_unique;
> +			u8	reason_explanation;
> +			u8	reason_code;
> +			u8	rsvd3;
> +		} rjt;
> +	} u;
> +};
> +
> +/* WQE used to create an ELS response */
> +
> +enum sli4_els_rsp_flags {
> +	SLI4_ELS_SID		= 0xffffff,
> +	SLI4_ELS_RID		= 0xffffff,
> +	SLI4_ELS_DBDE		= 0x40,
> +	SLI4_ELS_XBL		= 0x8,
> +	SLI4_ELS_IOD		= 0x20,
> +	SLI4_ELS_QOSD		= 0x2,
> +	SLI4_ELS_XC		= 0x20,
> +	SLI4_ELS_CT_OFFSET	= 0X2,
> +	SLI4_ELS_SP		= 0X1000000,
> +	SLI4_ELS_HLM		= 0X10,
> +};
> +
> +struct sli4_xmit_els_rsp64_wqe {
> +	struct sli4_bde	els_response_payload;
> +	__le32		els_response_payload_length;
> +	__le32		sid_dw;
> +	__le32		rid_dw;
> +	__le16		xri_tag;
> +	__le16		context_tag;
> +	u8		ct_byte;
> +	u8		command;
> +	u8		class_byte;
> +	u8		timer;
> +	__le32		abort_tag;
> +	__le16		request_tag;
> +	__le16		ox_id;
> +	u8		flags1;
> +	u8		flags2;
> +	u8		flags3;
> +	u8		flags4;
> +	u8		cmd_type_wqec;
> +	u8		rsvd34;
> +	__le16		cq_id;
> +	__le16		temporary_rpi;
> +	__le16		rsvd38;
> +	u32		rsvd40;
> +	u32		rsvd44;
> +	u32		rsvd48;
> +};
> +
> +/* Local Reject Reason Codes */
> +enum sli4_fc_local_rej_codes {
> +	SLI4_FC_LOCAL_REJECT_UNKNOWN,
> +	SLI4_FC_LOCAL_REJECT_MISSING_CONTINUE,
> +	SLI4_FC_LOCAL_REJECT_SEQUENCE_TIMEOUT,
> +	SLI4_FC_LOCAL_REJECT_INTERNAL_ERROR,
> +	SLI4_FC_LOCAL_REJECT_INVALID_RPI,
> +	SLI4_FC_LOCAL_REJECT_NO_XRI,
> +	SLI4_FC_LOCAL_REJECT_ILLEGAL_COMMAND,
> +	SLI4_FC_LOCAL_REJECT_XCHG_DROPPED,
> +	SLI4_FC_LOCAL_REJECT_ILLEGAL_FIELD,
> +	SLI4_FC_LOCAL_REJECT_RPI_SUSPENDED,
> +	SLI4_FC_LOCAL_REJECT_RSVD,
> +	SLI4_FC_LOCAL_REJECT_RSVD1,
> +	SLI4_FC_LOCAL_REJECT_NO_ABORT_MATCH,
> +	SLI4_FC_LOCAL_REJECT_TX_DMA_FAILED,
> +	SLI4_FC_LOCAL_REJECT_RX_DMA_FAILED,
> +	SLI4_FC_LOCAL_REJECT_ILLEGAL_FRAME,
> +	SLI4_FC_LOCAL_REJECT_RSVD2,
> +	SLI4_FC_LOCAL_REJECT_NO_RESOURCES, //0x11
> +	SLI4_FC_LOCAL_REJECT_FCP_CONF_FAILURE,
> +	SLI4_FC_LOCAL_REJECT_ILLEGAL_LENGTH,
> +	SLI4_FC_LOCAL_REJECT_UNSUPPORTED_FEATURE,
> +	SLI4_FC_LOCAL_REJECT_ABORT_IN_PROGRESS,
> +	SLI4_FC_LOCAL_REJECT_ABORT_REQUESTED,
> +	SLI4_FC_LOCAL_REJECT_RCV_BUFFER_TIMEOUT,
> +	SLI4_FC_LOCAL_REJECT_LOOP_OPEN_FAILURE,
> +	SLI4_FC_LOCAL_REJECT_RSVD3,
> +	SLI4_FC_LOCAL_REJECT_LINK_DOWN,
> +	SLI4_FC_LOCAL_REJECT_CORRUPTED_DATA,
> +	SLI4_FC_LOCAL_REJECT_CORRUPTED_RPI,
> +	SLI4_FC_LOCAL_REJECT_OUTOFORDER_DATA,
> +	SLI4_FC_LOCAL_REJECT_OUTOFORDER_ACK,
> +	SLI4_FC_LOCAL_REJECT_DUP_FRAME,
> +	SLI4_FC_LOCAL_REJECT_LINK_CONTROL_FRAME, //0x20
> +	SLI4_FC_LOCAL_REJECT_BAD_HOST_ADDRESS,
> +	SLI4_FC_LOCAL_REJECT_RSVD4,
> +	SLI4_FC_LOCAL_REJECT_MISSING_HDR_BUFFER,
> +	SLI4_FC_LOCAL_REJECT_MSEQ_CHAIN_CORRUPTED,
> +	SLI4_FC_LOCAL_REJECT_ABORTMULT_REQUESTED,
> +	SLI4_FC_LOCAL_REJECT_BUFFER_SHORTAGE	= 0x28,
> +	SLI4_FC_LOCAL_REJECT_RCV_XRIBUF_WAITING,
> +	SLI4_FC_LOCAL_REJECT_INVALID_VPI	= 0x2e,
> +	SLI4_FC_LOCAL_REJECT_NO_FPORT_DETECTED,
> +	SLI4_FC_LOCAL_REJECT_MISSING_XRIBUF,
> +	SLI4_FC_LOCAL_REJECT_RSVD5,
> +	SLI4_FC_LOCAL_REJECT_INVALID_XRI,
> +	SLI4_FC_LOCAL_REJECT_INVALID_RELOFFSET	= 0x40,
> +	SLI4_FC_LOCAL_REJECT_MISSING_RELOFFSET,
> +	SLI4_FC_LOCAL_REJECT_INSUFF_BUFFERSPACE,
> +	SLI4_FC_LOCAL_REJECT_MISSING_SI,
> +	SLI4_FC_LOCAL_REJECT_MISSING_ES,
> +	SLI4_FC_LOCAL_REJECT_INCOMPLETE_XFER,
> +	SLI4_FC_LOCAL_REJECT_SLER_FAILURE,
> +	SLI4_FC_LOCAL_REJECT_SLER_CMD_RCV_FAILURE,
> +	SLI4_FC_LOCAL_REJECT_SLER_REC_RJT_ERR,
> +	SLI4_FC_LOCAL_REJECT_SLER_REC_SRR_RETRY_ERR,
> +	SLI4_FC_LOCAL_REJECT_SLER_SRR_RJT_ERR,
> +	SLI4_FC_LOCAL_REJECT_RSVD6,
> +	SLI4_FC_LOCAL_REJECT_SLER_RRQ_RJT_ERR,
> +	SLI4_FC_LOCAL_REJECT_SLER_RRQ_RETRY_ERR,
> +	SLI4_FC_LOCAL_REJECT_SLER_ABTS_ERR,
> +};
> +
> +enum sli4_async_rcqe_flags {
> +	SLI4_RACQE_RQ_EL_INDX	= 0xfff,
> +	SLI4_RACQE_FCFI		= 0x3f,
> +	SLI4_RACQE_HDPL		= 0x3f,
> +	SLI4_RACQE_RQ_ID	= 0xffc0,
> +};
> +
> +struct sli4_fc_async_rcqe {
> +	u8		rsvd0;
> +	u8		status;
> +	__le16		rq_elmt_indx_word;
> +	__le32		rsvd4;
> +	__le16		fcfi_rq_id_word;
> +	__le16		data_placement_length;
> +	u8		sof_byte;
> +	u8		eof_byte;
> +	u8		code;
> +	u8		hdpl_byte;
> +};
> +
> +struct sli4_fc_async_rcqe_v1 {
> +	u8		rsvd0;
> +	u8		status;
> +	__le16		rq_elmt_indx_word;
> +	u8		fcfi_byte;
> +	u8		rsvd5;
> +	__le16		rsvd6;
> +	__le16		rq_id;
> +	__le16		data_placement_length;
> +	u8		sof_byte;
> +	u8		eof_byte;
> +	u8		code;
> +	u8		hdpl_byte;
> +};
> +
> +enum sli4_fc_async_rq_status {
> +	SLI4_FC_ASYNC_RQ_SUCCESS = 0x10,
> +	SLI4_FC_ASYNC_RQ_BUF_LEN_EXCEEDED,
> +	SLI4_FC_ASYNC_RQ_INSUFF_BUF_NEEDED,
> +	SLI4_FC_ASYNC_RQ_INSUFF_BUF_FRM_DISC,
> +	SLI4_FC_ASYNC_RQ_DMA_FAILURE,
> +};
> +
> +#define SLI4_RCQE_RQ_EL_INDX	0xfff
> +
> +struct sli4_fc_coalescing_rcqe {
> +	u8		rsvd0;
> +	u8		status;
> +	__le16		rq_elmt_indx_word;
> +	__le32		rsvd4;
> +	__le16		rq_id;
> +	__le16		sequence_reporting_placement_length;
> +	__le16		rsvd14;
> +	u8		code;
> +	u8		vld_byte;
> +};
> +
> +#define SLI4_FC_COALESCE_RQ_SUCCESS		0x10
> +#define SLI4_FC_COALESCE_RQ_INSUFF_XRI_NEEDED	0x18
> +
> +enum sli4_optimized_write_cmd_cqe_flags {
> +	SLI4_OCQE_RQ_EL_INDX	= 0x7f,		/* DW0 bits 16:30 */
> +	SLI4_OCQE_FCFI		= 0x3f,		/* DW1 bits 0:6 */
> +	SLI4_OCQE_OOX		= 1 << 6,	/* DW1 bit 15 */
> +	SLI4_OCQE_AGXR		= 1 << 7,	/* DW1 bit 16 */
> +	SLI4_OCQE_HDPL		= 0x3f,		/* DW3 bits 24:29*/
> +};
> +
> +struct sli4_fc_optimized_write_cmd_cqe {
> +	u8		rsvd0;
> +	u8		status;
> +	__le16		w1;
> +	u8		flags0;
> +	u8		flags1;
> +	__le16		xri;
> +	__le16		rq_id;
> +	__le16		data_placement_length;
> +	__le16		rpi;
> +	u8		code;
> +	u8		hdpl_vld;
> +};
> +
> +#define	SLI4_OCQE_XB		0x10
> +
> +struct sli4_fc_optimized_write_data_cqe {
> +	u8		hw_status;
> +	u8		status;
> +	__le16		xri;
> +	__le32		total_data_placed;
> +	__le32		extended_status;
> +	__le16		rsvd12;
> +	u8		code;
> +	u8		flags;
> +};
> +
> +struct sli4_fc_xri_aborted_cqe {
> +	u8		rsvd0;
> +	u8		status;
> +	__le16		rsvd2;
> +	__le32		extended_status;
> +	__le16		xri;
> +	__le16		remote_xid;
> +	__le16		rsvd12;
> +	u8		code;
> +	u8		flags;
> +};
> +
> +enum sli4_generic_ctx {
> +	SLI4_GENERIC_CONTEXT_RPI,
> +	SLI4_GENERIC_CONTEXT_VPI,
> +	SLI4_GENERIC_CONTEXT_VFI,
> +	SLI4_GENERIC_CONTEXT_FCFI,
> +};
> +
> +#define SLI4_GENERIC_CLASS_CLASS_2		0x1
> +#define SLI4_GENERIC_CLASS_CLASS_3		0x2
> +
> +#define SLI4_ELS_REQUEST64_DIR_WRITE		0x0
> +#define SLI4_ELS_REQUEST64_DIR_READ		0x1
> +
> +enum sli4_els_request {
> +	SLI4_ELS_REQUEST64_OTHER,
> +	SLI4_ELS_REQUEST64_LOGO,
> +	SLI4_ELS_REQUEST64_FDISC,
> +	SLI4_ELS_REQUEST64_FLOGIN,
> +	SLI4_ELS_REQUEST64_PLOGI,
> +};
> +
> +enum sli4_els_cmd_type {
> +	SLI4_ELS_REQUEST64_CMD_GEN		= 0x08,
> +	SLI4_ELS_REQUEST64_CMD_NON_FABRIC	= 0x0c,
> +	SLI4_ELS_REQUEST64_CMD_FABRIC		= 0x0d,
> +};
> +
> +/******Driver specific structures******/
> +
> +struct sli4_queue {
> +	/* Common to all queue types */
> +	struct efc_dma	dma;
> +	spinlock_t	lock;		/* Lock to protect the doorbell register
> +					 * writes and queue reads
> +					 */
> +	u32		index;		/* current host entry index */
> +	u16		size;		/* entry size */
> +	u16		length;		/* number of entries */
> +	u16		n_posted;	/* number entries posted for CQ, EQ */
> +	u16		id;		/* Port assigned xQ_ID */
> +	u8		type;		/* queue type ie EQ, CQ, ... */
> +	void __iomem    *db_regaddr;	/* register address for the doorbell */
> +	u16		phase;		/* For if_type = 6, this value toggle
> +					 * for each iteration of the queue,
> +					 * a queue entry is valid when a cqe
> +					 * valid bit matches this value
> +					 */
> +	u32		proc_limit;	/* limit CQE processed per iteration */
> +	u32		posted_limit;	/* CQE/EQE process before ring db */
> +	u32		max_num_processed;
> +	u64		max_process_time;
> +	union {
> +		u32	r_idx;		/* "read" index (MQ only) */
> +		u32	flag;
> +	} u;
> +};
> +
> +/* Prameters used to populate WQE*/

Parameters ...

> +struct sli_bls_params {
> +	u32		s_id;
> +	u32		d_id;
> +	u16		ox_id;
> +	u16		rx_id;
> +	u32		rpi;
> +	u32		vpi;
> +	bool		rpi_registered;
> +	u8		payload[12];
> +	u16		xri;
> +	u16		tag;
> +};
> +
> +struct sli_els_params {
> +	u32		s_id;
> +	u32		d_id;
> +	u16		ox_id;
> +	u32		rpi;
> +	u32		vpi;
> +	bool		rpi_registered;
> +	u32		xmit_len;
> +	u32		rsp_len;
> +	u8		timeout;
> +	u8		cmd;
> +	u16		xri;
> +	u16		tag;
> +};
> +
> +struct sli_ct_params {
> +	u8		r_ctl;
> +	u8		type;
> +	u8		df_ctl;
> +	u8		timeout;
> +	u16		ox_id;
> +	u32		d_id;
> +	u32		rpi;
> +	u32		vpi;
> +	bool		rpi_registered;
> +	u32		xmit_len;
> +	u32		rsp_len;
> +	u16		xri;
> +	u16		tag;
> +};
> +
> +struct sli_fcp_tgt_params {
> +	u32		s_id;
> +	u32		d_id;
> +	u32		rpi;
> +	u32		vpi;
> +	u32		offset;
> +	u16		ox_id;
> +	u16		flags;
> +	u8		cs_ctl;
> +	u8		timeout;
> +	u32		app_id;
> +	u32		xmit_len;
> +	u16		xri;
> +	u16		tag;
> +};
> +
>   #endif /* !_SLI4_H */
> 
Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

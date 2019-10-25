Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBB4CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 09:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 015DA21929
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 09:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408994AbfJYJ7Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 05:59:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:58964 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2408510AbfJYJ7Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 05:59:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 81552B6FA;
        Fri, 25 Oct 2019 09:59:22 +0000 (UTC)
Date:   Fri, 25 Oct 2019 11:59:22 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH 02/32] elx: libefc_sli: SLI Descriptors and Queue entries
Message-ID: <20191025095922.spyfsn5wlnou2xj2@beryllium.lan>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
 <20191023215557.12581-3-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191023215557.12581-3-jsmart2021@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +#if !defined(__EFC_COMMON_H__)

What about #ifndef which is more commonly used.

> +enum {
> +	/* DW2W1 */
> +	DISEED_SGE_HS			= (1 << 2),
> +	DISEED_SGE_WS			= (1 << 3),
> +	DISEED_SGE_IC			= (1 << 4),
> +	DISEED_SGE_ICS			= (1 << 5),
> +	DISEED_SGE_ATRT			= (1 << 6),
> +	DISEED_SGE_AT			= (1 << 7),
> +	DISEED_SGE_FAT			= (1 << 8),
> +	DISEED_SGE_NA			= (1 << 9),
> +	DISEED_SGE_HI			= (1 << 10),

I noticed sometimes there are also BIT() used. Wouldn't it make sense
to the whole driver to use one or the other version of bit
definitions?

> +#define SLI4_QUEUE_DEFAULT_CQ	U16_MAX /** Use the default CQ */
> +
> +#define SLI4_QUEUE_RQ_BATCH	8
> +
> +#define CFG_RQST_CMDSZ(stype)    sizeof(struct sli4_rqst_##stype##_s)

The alignment of sizeof is off. Suppose it should be a tab there instead spaces.

> +
> +#define CFG_RQST_PYLD_LEN(stype)	\
> +		cpu_to_le32(sizeof(struct sli4_rqst_##stype##_s) -	\
> +			sizeof(struct sli4_rqst_hdr_s))
> +
> +#define CFG_RQST_PYLD_LEN_VAR(stype, varpyld)	\
> +		cpu_to_le32((sizeof(struct sli4_rqst_##stype##_s) +	\
> +			varpyld) - sizeof(struct sli4_rqst_hdr_s))
> +
> +#define SZ_DMAADDR              sizeof(struct sli4_dmaaddr_s)
> +
> +/* Payload length must accommodate both request and response */
> +#define SLI_CONFIG_PYLD_LENGTH(stype)	\
> +	max(sizeof(struct sli4_rqst_##stype##_s),		\
> +		sizeof(struct sli4_rsp_##stype##_s))

Here are the '\' have more indention compared to patch #1.

> +#define CQ_CNT_VAL(type) (CQ_CNT_##type << CQ_CNT_SHIFT)
> +
> +#define SLI4_CQE_BYTES			(4 * sizeof(u32))
> +
> +#define SLI4_COMMON_CREATE_CQ_V2_MAX_PAGES 8

Maybe use the same indention for the first to defines?

> +
> +/**
> + * @brief Generic Common Create EQ/CQ/MQ/WQ/RQ Queue completion
> + */
> +struct sli4_rsp_cmn_create_queue_s {
> +	struct sli4_rsp_hdr_s	hdr;
> +	__le16	q_id;
> +	u8	rsvd18;
> +	u8	ulp;
> +	__le32	db_offset;
> +	__le16	db_rs;
> +	__le16	db_fmt;
> +};

Just wondering about all these definitions here: These structs
describes the wire format, no? Shouldn't this marked with __packed? I
keep forgetting the rules.

> +/**
> + * EQ count.
> + */
> +enum {
> +	EQ_CNT_SHIFT	= 26,
> +
> +	EQ_CNT_256	= 0,
> +	EQ_CNT_512	= 1,
> +	EQ_CNT_1024	= 2,
> +	EQ_CNT_2048	= 3,
> +	EQ_CNT_4096	= 3,
> +};
> +#define EQ_CNT_VAL(type) (EQ_CNT_##type << EQ_CNT_SHIFT)
> +
> +#define SLI4_EQE_SIZE_4			0
> +#define SLI4_EQE_SIZE_16		1

Picking up my question from patch #1, what's the idea about the enums
and defines? Why are the last two ones not an enum?

> +/**
> + * @brief WQ_CREATE
> + *
> + * Create a Work Queue for FC.
> + */
> +#define SLI4_WQ_CREATE_V0_MAX_PAGES	4
> +struct sli4_rqst_wq_create_s {
> +	struct sli4_rqst_hdr_s	hdr;
> +	u8		num_pages;
> +	u8		dua_byte;
> +	__le16		cq_id;
> +	struct sli4_dmaaddr_s page_phys_addr[SLI4_WQ_CREATE_V0_MAX_PAGES];
> +	u8		bqu_byte;
> +	u8		ulp;
> +	__le16		rsvd;
> +};
> +
> +struct sli4_rsp_wq_create_s {
> +	struct sli4_rsp_cmn_create_queue_s q_rsp;
> +};
> +
> +/**
> + * @brief WQ_CREATE_V1
> + *
> + * Create a version 1 Work Queue for FC use.
> + */

Why does the workqueue code encode a version? Isn't this pure driver
code?

> +#define SLI4_WQ_CREATE_V1_MAX_PAGES	8
> +struct sli4_rqst_wq_create_v1_s {
> +	struct sli4_rqst_hdr_s	hdr;
> +	__le16		num_pages;
> +	__le16		cq_id;
> +	u8		page_size;
> +	u8		wqe_size_byte;
> +	__le16		wqe_count;
> +	__le32		rsvd;
> +	struct	sli4_dmaaddr_s page_phys_addr[SLI4_WQ_CREATE_V1_MAX_PAGES];
> +};
> +
> +struct sli4_rsp_wq_create_v1_s {
> +	struct sli4_rsp_cmn_create_queue_s rsp;
> +};
> +/**

Empty line missing.

> + * @brief WQ_DESTROY
> + *
> + * Destroy an FC Work Queue.
> + */


> +enum {
> +	LINK_ATTN_TYPE_LINK_UP		= 0x01,
> +	LINK_ATTN_TYPE_LINK_DOWN	= 0x02,
> +	LINK_ATTN_TYPE_NO_HARD_ALPA	= 0x03,
> +
> +	LINK_ATTN_P2P			= 0x01,
> +	LINK_ATTN_FC_AL			= 0x02,
> +	LINK_ATTN_INTERNAL_LOOPBACK	= 0x03,
> +	LINK_ATTN_SERDES_LOOPBACK	= 0x04,
> +
> +	LINK_ATTN_1G			= 0x01,
> +	LINK_ATTN_2G			= 0x02,
> +	LINK_ATTN_4G			= 0x04,
> +	LINK_ATTN_8G			= 0x08,
> +	LINK_ATTN_10G			= 0x0a,
> +	LINK_ATTN_16G			= 0x10,
> +

One empty line too much.

> +};
> +

> +/**
> + * @brief FC Completion Status Codes.
> + */
> +#define SLI4_FC_WCQE_STATUS_SUCCESS		0x00
> +#define SLI4_FC_WCQE_STATUS_FCP_RSP_FAILURE	0x01
> +#define SLI4_FC_WCQE_STATUS_REMOTE_STOP		0x02
> +#define SLI4_FC_WCQE_STATUS_LOCAL_REJECT	0x03
> +#define SLI4_FC_WCQE_STATUS_NPORT_RJT		0x04
> +#define SLI4_FC_WCQE_STATUS_FABRIC_RJT		0x05
> +#define SLI4_FC_WCQE_STATUS_NPORT_BSY		0x06
> +#define SLI4_FC_WCQE_STATUS_FABRIC_BSY		0x07
> +#define SLI4_FC_WCQE_STATUS_LS_RJT		0x09
> +#define SLI4_FC_WCQE_STATUS_CMD_REJECT		0x0b
> +#define SLI4_FC_WCQE_STATUS_FCP_TGT_LENCHECK	0x0c
> +#define SLI4_FC_WCQE_STATUS_RQ_BUF_LEN_EXCEEDED	0x11
> +#define SLI4_FC_WCQE_STATUS_RQ_INSUFF_BUF_NEEDED 0x12
> +#define SLI4_FC_WCQE_STATUS_RQ_INSUFF_FRM_DISC	0x13
> +#define SLI4_FC_WCQE_STATUS_RQ_DMA_FAILURE	0x14
> +#define SLI4_FC_WCQE_STATUS_FCP_RSP_TRUNCATE	0x15
> +#define SLI4_FC_WCQE_STATUS_DI_ERROR		0x16
> +#define SLI4_FC_WCQE_STATUS_BA_RJT		0x17
> +#define SLI4_FC_WCQE_STATUS_RQ_INSUFF_XRI_NEEDED 0x18
> +#define SLI4_FC_WCQE_STATUS_RQ_INSUFF_XRI_DISC	0x19
> +#define SLI4_FC_WCQE_STATUS_RX_ERROR_DETECT	0x1a
> +#define SLI4_FC_WCQE_STATUS_RX_ABORT_REQUEST	0x1b

Here are defines and no enums.

> +/**
> + * @brief WQE used to create an FCP initiator write.
> + */
> +enum {
> +	SLI4_IWR_WQE_DBDE	= 0x40,
> +	SLI4_IWR_WQE_XBL	= 0x8,
> +	SLI4_IWR_WQE_XC		= 0x20,
> +	SLI4_IWR_WQE_IOD	= 0x20,
> +	SLI4_IWR_WQE_HLM	= 0x10,
> +	SLI4_IWR_WQE_DNRX	= 0x10,
> +	SLI4_IWR_WQE_CCPE	= 0x80,
> +	SLI4_IWR_WQE_EAT	= 0x10,
> +	SLI4_IWR_WQE_APPID	= 0x10,
> +	SLI4_IWR_WQE_WQES	= 0x80,
> +	SLI4_IWR_WQE_PU_SHFT	= 4,
> +	SLI4_IWR_WQE_CT_SHFT	= 2,
> +	SLI4_IWR_WQE_BS_SHFT	= 4,
> +	SLI4_IWR_WQE_LEN_LOC_BIT1 = 0x80,
> +	SLI4_IWR_WQE_LEN_LOC_BIT2 = 0x1,
> +};

There are a couple of the same patters above. There is still enough
space for adding another level of indention so that all '=' are align.

> +/**
> + * @brief Local Reject Reason Codes.
> + */
> +#define SLI4_FC_LOCAL_REJECT_MISSING_CONTINUE	0x01
> +#define SLI4_FC_LOCAL_REJECT_SEQUENCE_TIMEOUT	0x02
> +#define SLI4_FC_LOCAL_REJECT_INTERNAL_ERROR	0x03
> +#define SLI4_FC_LOCAL_REJECT_INVALID_RPI	0x04
> +#define SLI4_FC_LOCAL_REJECT_NO_XRI		0x05
> +#define SLI4_FC_LOCAL_REJECT_ILLEGAL_COMMAND	0x06
> +#define SLI4_FC_LOCAL_REJECT_XCHG_DROPPED	0x07
> +#define SLI4_FC_LOCAL_REJECT_ILLEGAL_FIELD	0x08
> +#define SLI4_FC_LOCAL_REJECT_NO_ABORT_MATCH	0x0c
> +#define SLI4_FC_LOCAL_REJECT_TX_DMA_FAILED	0x0d
> +#define SLI4_FC_LOCAL_REJECT_RX_DMA_FAILED	0x0e
> +#define SLI4_FC_LOCAL_REJECT_ILLEGAL_FRAME	0x0f
> +#define SLI4_FC_LOCAL_REJECT_NO_RESOURCES	0x11
> +#define SLI4_FC_LOCAL_REJECT_FCP_CONF_FAILURE	0x12
> +#define SLI4_FC_LOCAL_REJECT_ILLEGAL_LENGTH	0x13
> +#define SLI4_FC_LOCAL_REJECT_UNSUPPORTED_FEATURE 0x14
> +#define SLI4_FC_LOCAL_REJECT_ABORT_IN_PROGRESS	0x15
> +#define SLI4_FC_LOCAL_REJECT_ABORT_REQUESTED	0x16
> +#define SLI4_FC_LOCAL_REJECT_RCV_BUFFER_TIMEOUT	0x17
> +#define SLI4_FC_LOCAL_REJECT_LOOP_OPEN_FAILURE	0x18
> +#define SLI4_FC_LOCAL_REJECT_LINK_DOWN		0x1a
> +#define SLI4_FC_LOCAL_REJECT_CORRUPTED_DATA	0x1b
> +#define SLI4_FC_LOCAL_REJECT_CORRUPTED_RPI	0x1c
> +#define SLI4_FC_LOCAL_REJECT_OUTOFORDER_DATA	0x1d
> +#define SLI4_FC_LOCAL_REJECT_OUTOFORDER_ACK	0x1e
> +#define SLI4_FC_LOCAL_REJECT_DUP_FRAME		0x1f
> +#define SLI4_FC_LOCAL_REJECT_LINK_CONTROL_FRAME	0x20
> +#define SLI4_FC_LOCAL_REJECT_BAD_HOST_ADDRESS	0x21
> +#define SLI4_FC_LOCAL_REJECT_MISSING_HDR_BUFFER	0x23
> +#define SLI4_FC_LOCAL_REJECT_MSEQ_CHAIN_CORRUPTED 0x24
> +#define SLI4_FC_LOCAL_REJECT_ABORTMULT_REQUESTED 0x25
> +#define SLI4_FC_LOCAL_REJECT_BUFFER_SHORTAGE	0x28
> +#define SLI4_FC_LOCAL_REJECT_RCV_XRIBUF_WAITING	0x29
> +#define SLI4_FC_LOCAL_REJECT_INVALID_VPI	0x2e
> +#define SLI4_FC_LOCAL_REJECT_MISSING_XRIBUF	0x30
> +#define SLI4_FC_LOCAL_REJECT_INVALID_RELOFFSET	0x40
> +#define SLI4_FC_LOCAL_REJECT_MISSING_RELOFFSET	0x41
> +#define SLI4_FC_LOCAL_REJECT_INSUFF_BUFFERSPACE	0x42
> +#define SLI4_FC_LOCAL_REJECT_MISSING_SI		0x43
> +#define SLI4_FC_LOCAL_REJECT_MISSING_ES		0x44
> +#define SLI4_FC_LOCAL_REJECT_INCOMPLETE_XFER	0x45
> +#define SLI4_FC_LOCAL_REJECT_SLER_FAILURE	0x46
> +#define SLI4_FC_LOCAL_REJECT_SLER_CMD_RCV_FAILURE 0x47
> +#define SLI4_FC_LOCAL_REJECT_SLER_REC_RJT_ERR	0x48
> +#define SLI4_FC_LOCAL_REJECT_SLER_REC_SRR_RETRY_ERR 0x49
> +#define SLI4_FC_LOCAL_REJECT_SLER_SRR_RJT_ERR	0x4a
> +#define SLI4_FC_LOCAL_REJECT_SLER_RRQ_RJT_ERR	0x4c
> +#define SLI4_FC_LOCAL_REJECT_SLER_RRQ_RETRY_ERR	0x4d
> +#define SLI4_FC_LOCAL_REJECT_SLER_ABTS_ERR	0x4e

There are a bunch of not align values. Having another tab wouldn't hurt.

> +
> +enum {
> +	SLI4_RACQE_RQ_EL_INDX = 0xfff,
> +	SLI4_RACQE_FCFI = 0x3f,
> +	SLI4_RACQE_HDPL = 0x3f,
> +	SLI4_RACQE_RQ_ID = 0xffc0,
> +};

And here the values are not aligned.

Thanks,
Daniel

Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40875C2BB55
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 12:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2404A20936
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 12:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368706AbgDOMOx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 08:14:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:44484 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368696AbgDOMOv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 08:14:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 155CEAD48;
        Wed, 15 Apr 2020 12:14:48 +0000 (UTC)
Subject: Re: [PATCH v3 02/31] elx: libefc_sli: SLI Descriptors and Queue
 entries
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-3-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e02f4879-9d7e-e37d-b1ea-db6305ac6308@suse.de>
Date:   Wed, 15 Apr 2020 14:14:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200412033303.29574-3-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/20 5:32 AM, James Smart wrote:
> This patch continues the libefc_sli SLI-4 library population.
> 
> This patch add SLI-4 Data structures and defines for:
> - Buffer Descriptors (BDEs)
> - Scatter/Gather List elements (SGEs)
> - Queues and their Entry Descriptions for:
>     Event Queues (EQs), Completion Queues (CQs),
>     Receive Queues (RQs), and the Mailbox Queue (MQ).
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>    Changed anonymous enums to named.
>    SLI defines to spell out _MASK value directly.
>    Change multiple defines to named Enums for consistency.
>    Single Enum to #define.
> ---
>   drivers/scsi/elx/include/efc_common.h |   25 +
>   drivers/scsi/elx/libefc_sli/sli4.h    | 1761 +++++++++++++++++++++++++++++++++
>   2 files changed, 1786 insertions(+)
>   create mode 100644 drivers/scsi/elx/include/efc_common.h
> 
> diff --git a/drivers/scsi/elx/include/efc_common.h b/drivers/scsi/elx/include/efc_common.h
> new file mode 100644
> index 000000000000..c427f75da4d5
> --- /dev/null
> +++ b/drivers/scsi/elx/include/efc_common.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
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
> +struct efc_dma {
> +	void		*virt;
> +	void            *alloc;
> +	dma_addr_t	phys;
> +
> +	size_t		size;
> +	size_t          len;
> +	struct pci_dev	*pdev;
> +};
> +
> +#endif /* __EFC_COMMON_H__ */
> diff --git a/drivers/scsi/elx/libefc_sli/sli4.h b/drivers/scsi/elx/libefc_sli/sli4.h
> index 1fad48643f94..07eef8df9690 100644
> --- a/drivers/scsi/elx/libefc_sli/sli4.h
> +++ b/drivers/scsi/elx/libefc_sli/sli4.h
> @@ -249,4 +249,1765 @@ struct sli4_reg {
>   	u32	off;
>   };
>   
> +struct sli4_dmaaddr {
> +	__le32 low;
> +	__le32 high;
> +};
> +
> +/* a 3-word BDE with address 1st 2 words, length last word */
> +struct sli4_bufptr {
> +	struct sli4_dmaaddr addr;
> +	__le32 length;
> +};
> +
> +/* a 3-word BDE with length as first word, address last 2 words */
> +struct sli4_bufptr_len1st {
> +	__le32 length0;
> +	struct sli4_dmaaddr addr;
> +};
> +
> +/* Buffer Descriptor Entry (BDE) */
> +enum sli4_bde_e {
> +	SLI4_BDE_MASK_BUFFER_LEN	= 0x00ffffff,
> +	SLI4_BDE_MASK_BDE_TYPE		= 0xff000000,
> +};
> +
> +struct sli4_bde {
> +	__le32		bde_type_buflen;
> +	union {
> +		struct sli4_dmaaddr data;
> +		struct {
> +			__le32	offset;
> +			__le32	rsvd2;
> +		} imm;
> +		struct sli4_dmaaddr blp;
> +	} u;
> +};
> +
> +/* Buffer Descriptors */
> +enum sli4_bde_type {
> +	BDE_TYPE_SHIFT		= 24,
> +	BDE_TYPE_BDE_64		= 0x00,	/* Generic 64-bit data */
> +	BDE_TYPE_BDE_IMM	= 0x01,	/* Immediate data */
> +	BDE_TYPE_BLP		= 0x40,	/* Buffer List Pointer */
> +};
> +
> +/* Scatter-Gather Entry (SGE) */
> +#define SLI4_SGE_MAX_RESERVED			3
> +
> +enum sli4_sge_type {
> +	/* DW2 */
> +	SLI4_SGE_DATA_OFFSET_MASK	= 0x07FFFFFF,
> +	/*DW2W1*/
> +	SLI4_SGE_TYPE_SHIFT		= 27,
> +	SLI4_SGE_TYPE_MASK		= 0x78000000,
> +	/*SGE Types*/
> +	SLI4_SGE_TYPE_DATA		= 0x00,
> +	SLI4_SGE_TYPE_DIF		= 0x04,	/* Data Integrity Field */
> +	SLI4_SGE_TYPE_LSP		= 0x05,	/* List Segment Pointer */
> +	SLI4_SGE_TYPE_PEDIF		= 0x06,	/* Post Encryption Engine DIF */
> +	SLI4_SGE_TYPE_PESEED		= 0x07,	/* Post Encryption DIF Seed */
> +	SLI4_SGE_TYPE_DISEED		= 0x08,	/* DIF Seed */
> +	SLI4_SGE_TYPE_ENC		= 0x09,	/* Encryption */
> +	SLI4_SGE_TYPE_ATM		= 0x0a,	/* DIF Application Tag Mask */
> +	SLI4_SGE_TYPE_SKIP		= 0x0c,	/* SKIP */
> +
> +	SLI4_SGE_LAST			= (1 << 31),
> +};
> +
> +struct sli4_sge {
> +	__le32		buffer_address_high;
> +	__le32		buffer_address_low;
> +	__le32		dw2_flags;
> +	__le32		buffer_length;
> +};
> +
> +/* T10 DIF Scatter-Gather Entry (SGE) */
> +struct sli4_dif_sge {
> +	__le32		buffer_address_high;
> +	__le32		buffer_address_low;
> +	__le32		dw2_flags;
> +	__le32		rsvd12;
> +};
> +
> +/* Data Integrity Seed (DISEED) SGE */
> +enum sli4_diseed_sge_flags {
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
> +
> +	/* DW3W1 */
> +	DISEED_SGE_BS_MASK		= 0x0007,
> +	DISEED_SGE_AI			= (1 << 3),
> +	DISEED_SGE_ME			= (1 << 4),
> +	DISEED_SGE_RE			= (1 << 5),
> +	DISEED_SGE_CE			= (1 << 6),
> +	DISEED_SGE_NR			= (1 << 7),
> +
> +	DISEED_SGE_OP_RX_SHIFT		= 8,
> +	DISEED_SGE_OP_RX_MASK		= 0x0F00,
> +	DISEED_SGE_OP_TX_SHIFT		= 12,
> +	DISEED_SGE_OP_TX_MASK		= 0xF000,
> +};
> +
> +/* Opcode values */
> +enum sli4_diseed_sge_opcodes {
> +	DISEED_SGE_OP_IN_NODIF_OUT_CRC,
> +	DISEED_SGE_OP_IN_CRC_OUT_NODIF,
> +	DISEED_SGE_OP_IN_NODIF_OUT_CSUM,
> +	DISEED_SGE_OP_IN_CSUM_OUT_NODIF,
> +	DISEED_SGE_OP_IN_CRC_OUT_CRC,
> +	DISEED_SGE_OP_IN_CSUM_OUT_CSUM,
> +	DISEED_SGE_OP_IN_CRC_OUT_CSUM,
> +	DISEED_SGE_OP_IN_CSUM_OUT_CRC,
> +	DISEED_SGE_OP_IN_RAW_OUT_RAW,
> +};
> +
> +#define DISEED_SGE_OP_RX_VALUE(stype) \
> +	(DISEED_SGE_OP_##stype << DISEED_SGE_OP_RX_SHIFT)
> +#define DISEED_SGE_OP_TX_VALUE(stype) \
> +	(DISEED_SGE_OP_##stype << DISEED_SGE_OP_TX_SHIFT)
> +
> +struct sli4_diseed_sge {
> +	__le32		ref_tag_cmp;
> +	__le32		ref_tag_repl;
> +	__le16		app_tag_repl;
> +	__le16		dw2w1_flags;
> +	__le16		app_tag_cmp;
> +	__le16		dw3w1_flags;
> +};
> +
> +/* List Segment Pointer Scatter-Gather Entry (SGE) */
> +#define SLI4_LSP_SGE_SEGLEN	0x00ffffff
> +
> +struct sli4_lsp_sge {
> +	__le32		buffer_address_high;
> +	__le32		buffer_address_low;
> +	__le32		dw2_flags;
> +	__le32		dw3_seglen;
> +};
> +
> +enum sli4_eqe_e {
> +	SLI4_EQE_VALID	= 1,
> +	SLI4_EQE_MJCODE	= 0xe,
> +	SLI4_EQE_MNCODE	= 0xfff0,
> +};
> +
> +struct sli4_eqe {
> +	__le16		dw0w0_flags;
> +	__le16		resource_id;
> +};
> +
> +#define SLI4_MAJOR_CODE_STANDARD	0
> +#define SLI4_MAJOR_CODE_SENTINEL	1
> +
> +/* Sentinel EQE indicating the EQ is full */
> +#define SLI4_EQE_STATUS_EQ_FULL		2
> +
> +enum sli4_mcqe_e {
> +	SLI4_MCQE_CONSUMED	= (1 << 27),
> +	SLI4_MCQE_COMPLETED	= (1 << 28),
> +	SLI4_MCQE_AE		= (1 << 30),
> +	SLI4_MCQE_VALID		= (1 << 31),
> +};
> +
> +/* Entry was consumed but not completed */
> +#define SLI4_MCQE_STATUS_NOT_COMPLETED	-2
> +
> +struct sli4_mcqe {
> +	__le16		completion_status;
> +	__le16		extended_status;
> +	__le32		mqe_tag_low;
> +	__le32		mqe_tag_high;
> +	__le32		dw3_flags;
> +};
> +
> +enum sli4_acqe_e {
> +	SLI4_ACQE_AE	= (1 << 6), /* async event - this is an ACQE */
> +	SLI4_ACQE_VAL	= (1 << 7), /* valid - contents of CQE are valid */
> +};
> +
> +struct sli4_acqe {
> +	__le32		event_data[3];
> +	u8		rsvd12;
> +	u8		event_code;
> +	u8		event_type;
> +	u8		ae_val;
> +};
> +
> +enum sli4_acqe_event_code {
> +	SLI4_ACQE_EVENT_CODE_LINK_STATE		= 0x01,
> +	SLI4_ACQE_EVENT_CODE_FIP		= 0x02,
> +	SLI4_ACQE_EVENT_CODE_DCBX		= 0x03,
> +	SLI4_ACQE_EVENT_CODE_ISCSI		= 0x04,
> +	SLI4_ACQE_EVENT_CODE_GRP_5		= 0x05,
> +	SLI4_ACQE_EVENT_CODE_FC_LINK_EVENT	= 0x10,
> +	SLI4_ACQE_EVENT_CODE_SLI_PORT_EVENT	= 0x11,
> +	SLI4_ACQE_EVENT_CODE_VF_EVENT		= 0x12,
> +	SLI4_ACQE_EVENT_CODE_MR_EVENT		= 0x13,
> +};
> +
> +enum sli4_qtype {
> +	SLI_QTYPE_EQ,
> +	SLI_QTYPE_CQ,
> +	SLI_QTYPE_MQ,
> +	SLI_QTYPE_WQ,
> +	SLI_QTYPE_RQ,
> +	SLI_QTYPE_MAX,			/* must be last */
> +};
> +
> +#define SLI_USER_MQ_COUNT	1
> +#define SLI_MAX_CQ_SET_COUNT	16
> +#define SLI_MAX_RQ_SET_COUNT	16
> +
> +enum sli4_qentry {
> +	SLI_QENTRY_ASYNC,
> +	SLI_QENTRY_MQ,
> +	SLI_QENTRY_RQ,
> +	SLI_QENTRY_WQ,
> +	SLI_QENTRY_WQ_RELEASE,
> +	SLI_QENTRY_OPT_WRITE_CMD,
> +	SLI_QENTRY_OPT_WRITE_DATA,
> +	SLI_QENTRY_XABT,
> +	SLI_QENTRY_MAX			/* must be last */
> +};
> +
> +enum sli4_queue_flags {
> +	/* CQ has MQ/Async completion */
> +	SLI4_QUEUE_FLAG_MQ	= (1 << 0),
> +
> +	/* RQ for packet headers */
> +	SLI4_QUEUE_FLAG_HDR	= (1 << 1),
> +
> +	/* RQ index increment by 8 */
> +	SLI4_QUEUE_FLAG_RQBATCH	= (1 << 2),
> +};
> +
> +struct sli4_queue {
> +	/* Common to all queue types */
> +	struct efc_dma	dma;
> +	spinlock_t	lock;	/* protect the queue operations */
> +	u32	index;		/* current host entry index */
> +	u16	size;		/* entry size */
> +	u16	length;		/* number of entries */
> +	u16	n_posted;	/* number entries posted */
> +	u16	id;		/* Port assigned xQ_ID */
> +	u16	ulp;		/* ULP assigned to this queue */
> +	void __iomem    *db_regaddr;	/* register address for the doorbell */
> +	u8		type;		/* queue type ie EQ, CQ, ... */

Alignment?
Having an u8 following a pointer is a guaranteed misalignment for the 
remaining entries.
Also, consider casting it to the above qtype enum.

> +	u32	proc_limit;	/* limit CQE processed per iteration */
> +	u32	posted_limit;	/* CQE/EQE process before ring doorbel */
> +	u32	max_num_processed;
> +	time_t		max_process_time;
> +	u16	phase;		/* For if_type = 6, this value toggle
> +				 * for each iteration of the queue,
> +				 * a queue entry is valid when a cqe
> +				 * valid bit matches this value
> +				 */
> +
Same here. u16 between u32 is not making the cachline happy.

> +	union {
> +		u32	r_idx;	/* "read" index (MQ only) */
> +		struct {
> +			u32	dword;
> +		} flag;
> +	} u;
> +};
> +
> +/* Generic Command Request header */

And the remainder seems to be all hardware-dependent structures.
Would it be possible to rearrange stuff so that hardware/SLI related 
structures are being kept separate from the software/driver dependent ones?
Just so that one is clear which structures can or must mot be changed.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B7DCA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 15:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 128C921D7F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 15:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbfJYPfZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:35:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:42114 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727068AbfJYPfZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 11:35:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C8B9EB126;
        Fri, 25 Oct 2019 15:35:20 +0000 (UTC)
Date:   Fri, 25 Oct 2019 17:35:20 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH 04/32] elx: libefc_sli: queue create/destroy/parse
 routines
Message-ID: <20191025153520.w3rppjka4jpcqfvl@beryllium.lan>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
 <20191023215557.12581-5-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023215557.12581-5-jsmart2021@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Wed, Oct 23, 2019 at 02:55:29PM -0700, James Smart wrote:
> This patch continues the libefc_sli SLI-4 library population.
> 
> This patch adds service routines to create mailbox commands
> and adds APIs to create/destroy/parse SLI-4 EQ, CQ, RQ and MQ queues.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/include/efc_common.h |   18 +
>  drivers/scsi/elx/libefc_sli/sli4.c    | 2155 +++++++++++++++++++++++++++++++++
>  2 files changed, 2173 insertions(+)
> 
> diff --git a/drivers/scsi/elx/include/efc_common.h b/drivers/scsi/elx/include/efc_common.h
> index dbabc4f6ee5e..62d0f3b3f936 100644
> --- a/drivers/scsi/elx/include/efc_common.h
> +++ b/drivers/scsi/elx/include/efc_common.h
> @@ -23,4 +23,22 @@ struct efc_dma_s {
>  	struct pci_dev	*pdev;
>  };
>  
> +#define efc_log_crit(efc, fmt, args...) \
> +		dev_crit(&((efc)->pcidev)->dev, fmt, ##args)
> +
> +#define efc_log_err(efc, fmt, args...) \
> +		dev_err(&((efc)->pcidev)->dev, fmt, ##args)
> +
> +#define efc_log_warn(efc, fmt, args...) \
> +		dev_warn(&((efc)->pcidev)->dev, fmt, ##args)
> +
> +#define efc_log_info(efc, fmt, args...) \
> +		dev_info(&((efc)->pcidev)->dev, fmt, ##args)
> +
> +#define efc_log_test(efc, fmt, args...) \
> +		dev_dbg(&((efc)->pcidev)->dev, fmt, ##args)
> +
> +#define efc_log_debug(efc, fmt, args...) \
> +		dev_dbg(&((efc)->pcidev)->dev, fmt, ##args)
> +
>  #endif /* __EFC_COMMON_H__ */
> diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
> index 68ccd3ad8ac8..6b62b7d8b5a4 100644
> --- a/drivers/scsi/elx/libefc_sli/sli4.c
> +++ b/drivers/scsi/elx/libefc_sli/sli4.c
> @@ -24,3 +24,2158 @@ static struct sli4_asic_entry_t sli4_asic_table[] = {
>  	{ SLI4_ASIC_REV_A3, SLI4_ASIC_GEN_6},
>  	{ SLI4_ASIC_REV_A1, SLI4_ASIC_GEN_7},
>  };
> +
> +/*
> + * @brief Convert queue type enum (SLI_QTYPE_*) into a string.
> + */
> +static char *SLI_QNAME[] = {
> +	"Event Queue",
> +	"Completion Queue",
> +	"Mailbox Queue",
> +	"Work Queue",
> +	"Receive Queue",
> +	"Undefined"
> +};
> +
> +/**
> + * @ingroup sli
> + * @brief Write a SLI_CONFIG command to the provided buffer.
> + *

Could add some additional comments about the size and dma parameter...

> + * @param sli4 SLI context pointer.
> + * @param buf Virtual pointer to the destination buffer.
> + * @param size Buffer size, in bytes.
> + * @param length Length in bytes of attached command.
> + * @param dma DMA buffer for non-embedded commands.
> + *
> + * @return Returns the number of bytes written.
> + */
> +static void *
> +sli_config_cmd_init(struct sli4_s *sli4, void *buf,
> +		    size_t size, u32 length,
> +		    struct efc_dma_s *dma)
> +{
> +	struct sli4_cmd_sli_config_s *sli_config = NULL;
> +	u32 flags = 0;
> +
> +	if (length > sizeof(sli_config->payload.embed) && !dma) {
> +		efc_log_info(sli4, "length(%d) > payload(%ld)\n",
> +			length, sizeof(sli_config->payload.embed));
> +		return NULL;
> +	}

...this logs something but what does it tell? I suppose it has
something to do if a data are embedded or not.

> +	sli_config = buf;
> +
> +	memset(buf, 0, size);
> +
> +	sli_config->hdr.command = MBX_CMD_SLI_CONFIG;
> +	if (!dma) {
> +		flags |= SLI4_SLICONF_EMB;
> +		sli_config->dw1_flags = cpu_to_le32(flags);
> +		sli_config->payload_len = cpu_to_le32(length);

Could you move the last return here ...

> +	} else {

... and get rid of this else here? Easier to read in my opinion
because the control flow is not splittet over the else part.

> +		flags = SLI4_SLICONF_PMDCMD_VAL_1;	/* pmd_count = 1 */
> +		flags &= ~SLI4_SLICONF_EMB;
> +		sli_config->dw1_flags = cpu_to_le32(flags);
> +
> +		sli_config->payload.mem.addr.low =
> +			cpu_to_le32(lower_32_bits(dma->phys));
> +		sli_config->payload.mem.addr.high =
> +			cpu_to_le32(upper_32_bits(dma->phys));
> +		sli_config->payload.mem.length =
> +			cpu_to_le32(dma->size & SLI4_SLICONFIG_PMD_LEN);
> +		sli_config->payload_len = cpu_to_le32(dma->size);
> +		/* save pointer to DMA for BMBX dumping purposes */
> +		sli4->bmbx_non_emb_pmd = dma;
> +		return dma->virt;
> +	}
> +
> +	return buf + offsetof(struct sli4_cmd_sli_config_s, payload.embed);
> +}
> +
> +/**
> + * @brief Write a COMMON_CREATE_CQ command.
> + *
> + * @param sli4 SLI context.
> + * @param buf Destination buffer for the command.
> + * @param size Buffer size, in bytes.
> + * @param qmem DMA memory for the queue.
> + * @param eq_id Associated EQ_ID
> + * @param ignored This parameter carries the ULP
> + * which is only used for WQ and RQs
> + *
> + * @note This creates a Version 0 message.

I wonder if this should be encoded into the function name?

> + *
> + * @return Returns 0 on success, or non-zero otherwise.
> + */
> +static int
> +sli_cmd_common_create_cq(struct sli4_s *sli4, void *buf, size_t size,
> +			 struct efc_dma_s *qmem,
> +			 u16 eq_id)
> +{
> +	struct sli4_rqst_cmn_create_cq_v2_s	*cqv2 = NULL;

too many spaces between the type and the variable name.

> +	u32 p;
> +	uintptr_t addr;
> +	u32 page_bytes = 0;
> +	u32 num_pages = 0;
> +	size_t cmd_size = 0;
> +	u32 page_size = 0;
> +	u32 n_cqe = 0;
> +	u32 dw5_flags = 0;
> +	u16 dw6w1_arm = 0;
> +
> +	/* First calculate number of pages and the mailbox cmd length */
> +	n_cqe = qmem->size / SLI4_CQE_BYTES;
> +	switch (n_cqe) {
> +	case 256:
> +	case 512:
> +	case 1024:
> +	case 2048:
> +		page_size = 1;
> +		break;
> +	case 4096:
> +		page_size = 2;
> +		break;
> +	default:
> +		return EFC_FAIL;

If it's an error code it should probably be an negative value.

I would also go with something like

	if (n_cqe <= 2048)
		page_size = 1;
	else if (n_cqe == 4096)
		page_size = 2;
	else
		return -EFC_FAIL;

since this results into a smaller code and I find simpler to read. It
is not completely equivalent since your version limits the values to
256, 512, 1024, 2048 and 4096. My version tolerates all values below
2048. Since the same switch pattern is repeated below (see
sli_cmd_wq_create_v1) am not utterly sure if my idea is good.

> +	}
> +	page_bytes = page_size * SLI_PAGE_SIZE;
> +	num_pages = sli_page_count(qmem->size, page_bytes);
> +
> +	cmd_size = CFG_RQST_CMDSZ(cmn_create_cq_v2) + SZ_DMAADDR * num_pages;
> +
> +	cqv2 = sli_config_cmd_init(sli4, buf, size, cmd_size, NULL);
> +	if (!cqv2)
> +		return EFC_FAIL;
> +
> +	cqv2->hdr.opcode = CMN_CREATE_CQ;
> +	cqv2->hdr.subsystem = SLI4_SUBSYSTEM_COMMON;
> +	cqv2->hdr.dw3_version = cpu_to_le32(CMD_V2);

Is this now a the command version? Shouldn't it be V0 as the
documentation writes?

> +	cmd_size = CFG_RQST_PYLD_LEN_VAR(cmn_create_cq_v2,
> +					 SZ_DMAADDR * num_pages);
> +	cqv2->hdr.request_length = cmd_size;
> +	cqv2->page_size = page_size;
> +
> +	/* valid values for number of pages: 1, 2, 4, 8 (sec 4.4.3) */
> +	cqv2->num_pages = cpu_to_le16(num_pages);
> +	if (!num_pages ||
> +	    num_pages > SLI4_COMMON_CREATE_CQ_V2_MAX_PAGES) {

I would write the condition on one line. There is still enough space left on the line.

> +		return EFC_FAIL;
> +	}
> +
> +	switch (num_pages) {
> +	case 1:
> +		dw5_flags |= CQ_CNT_VAL(256);
> +		break;
> +	case 2:
> +		dw5_flags |= CQ_CNT_VAL(512);
> +		break;
> +	case 4:
> +		dw5_flags |= CQ_CNT_VAL(1024);
> +		break;
> +	case 8:
> +		dw5_flags |= CQ_CNT_VAL(LARGE);
> +		cqv2->cqe_count = cpu_to_le16(n_cqe);
> +		break;
> +	default:
> +		efc_log_info(sli4, "num_pages %d not valid\n", num_pages);
> +		return -1;

return -EFC_FAIL; ?

> +	}
> +
> +	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
> +		dw5_flags |= CREATE_CQV2_AUTOVALID;
> +
> +	dw5_flags |= CREATE_CQV2_EVT;
> +	dw5_flags |= CREATE_CQV2_VALID;
> +
> +	cqv2->dw5_flags = cpu_to_le32(dw5_flags);
> +	cqv2->dw6w1_arm = cpu_to_le16(dw6w1_arm);
> +	cqv2->eq_id = cpu_to_le16(eq_id);
> +
> +	for (p = 0, addr = qmem->phys; p < num_pages;
> +	     p++, addr += page_bytes) {

This fits on one line, exact 80 chars :)

> +		cqv2->page_phys_addr[p].low =
> +			cpu_to_le32(lower_32_bits(addr));
> +		cqv2->page_phys_addr[p].high =
> +			cpu_to_le32(upper_32_bits(addr));
> +	}

Also these two assignment fit into 80 chars.

> +
> +	return EFC_SUCCESS;
> +}
> +
> +/**
> + * @brief Write a COMMON_DESTROY_CQ command.
> + *
> + * @param sli4 SLI context.
> + * @param buf Destination buffer for the command.
> + * @param size Buffer size, in bytes.
> + * @param cq_id CQ ID
> + *
> + * @note This creates a Version 0 message.
> + *
> + * @return Returns 0 on success, or non-zero otherwise.
> + */
> +static int
> +sli_cmd_common_destroy_cq(struct sli4_s *sli4, void *buf,
> +			  size_t size, u16 cq_id)
> +{
> +	struct sli4_rqst_cmn_destroy_cq_s *cq = NULL;
> +
> +	/* Payload length must accommodate both request and response */

Is this common? Is this true for all commands? If so maybe have this
kind of information at the beginning of the file explaining some of
the inner workings of the code would certainly help.

> +	cq = sli_config_cmd_init(sli4, buf, size,
> +				 SLI_CONFIG_PYLD_LENGTH(cmn_destroy_cq), NULL);
> +	if (!cq)
> +		return EFC_FAIL;

return -EFC_FAIL ?

(I stop report this one now)

> +
> +	cq->hdr.opcode = CMN_DESTROY_CQ;
> +	cq->hdr.subsystem = SLI4_SUBSYSTEM_COMMON;
> +	cq->hdr.request_length = CFG_RQST_PYLD_LEN(cmn_destroy_cq);
> +	cq->cq_id = cpu_to_le16(cq_id);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +/**
> + * @brief Write a COMMON_CREATE_EQ command.
> + *
> + * @param sli4 SLI context.
> + * @param buf Destination buffer for the command.
> + * @param size Buffer size, in bytes.
> + * @param qmem DMA memory for the queue.
> + * @param ignored1 Ignored
> + * (used for consistency among queue creation functions).
> + * @param ignored2 Ignored
> + * (used for consistency among queue creation functions).

There is no ignored2 in the function declarations.

> + *
> + * @note Other queue creation routines use the last parameter to pass in
> + * the associated Q_ID and ULP. EQ doesn't have an associated queue or ULP,
> + * so these parameters are ignored
> + *
> + * @note This creates a Version 0 message
> + *
> + * @return Returns 0 on success, or non-zero otherwise.
> + */
> +static int
> +sli_cmd_common_create_eq(struct sli4_s *sli4, void *buf, size_t size,
> +			 struct efc_dma_s *qmem,
> +			 u16 ignored1)

If you want to be consistent with the other function declarations,
ignored1 should go on the same line as qmem.

> +{
> +	struct sli4_rqst_cmn_create_eq_s *eq = NULL;

No need to set eq to NULL because it will set as first thing in the function

> +	u32 p;
> +	uintptr_t addr;
> +	u16 num_pages;
> +	u32 dw5_flags = 0;
> +	u32 dw6_flags = 0;
> +
> +	eq = sli_config_cmd_init(sli4, buf, size,
> +				 SLI_CONFIG_PYLD_LENGTH(cmn_create_eq), NULL);

You should test for NULL since sli_config_cmd_init() can return NULL.

> +
> +	eq->hdr.opcode = CMN_CREATE_EQ;
> +	eq->hdr.subsystem = SLI4_SUBSYSTEM_COMMON;
> +	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
> +		eq->hdr.dw3_version = cpu_to_le32(CMD_V2);

Same question on the command version number as above.

> +
> +	eq->hdr.request_length = CFG_RQST_PYLD_LEN(cmn_create_eq);
> +
> +	/* valid values for number of pages: 1, 2, 4 (sec 4.4.3) */
> +	num_pages = qmem->size / SLI_PAGE_SIZE;
> +	eq->num_pages = cpu_to_le16(num_pages);
> +
> +	switch (num_pages) {
> +	case 1:
> +		dw5_flags |= SLI4_EQE_SIZE_4;
> +		dw6_flags |= EQ_CNT_VAL(1024);
> +		break;
> +	case 2:
> +		dw5_flags |= SLI4_EQE_SIZE_4;
> +		dw6_flags |= EQ_CNT_VAL(2048);
> +		break;
> +	case 4:
> +		dw5_flags |= SLI4_EQE_SIZE_4;
> +		dw6_flags |= EQ_CNT_VAL(4096);
> +		break;
> +	default:
> +		efc_log_info(sli4, "num_pages %d not valid\n", num_pages);
> +		return EFC_FAIL;
> +	}
> +
> +	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
> +		dw5_flags |= CREATE_EQ_AUTOVALID;
> +
> +	dw5_flags |= CREATE_EQ_VALID;
> +	dw6_flags &= (~CREATE_EQ_ARM);
> +	eq->dw5_flags = cpu_to_le32(dw5_flags);
> +	eq->dw6_flags = cpu_to_le32(dw6_flags);
> +	eq->dw7_delaymulti = cpu_to_le32(CREATE_EQ_DELAYMULTI);
> +
> +	for (p = 0, addr = qmem->phys; p < num_pages;
> +	     p++, addr += SLI_PAGE_SIZE) {

One line?

> +		eq->page_address[p].low = cpu_to_le32(lower_32_bits(addr));
> +		eq->page_address[p].high = cpu_to_le32(upper_32_bits(addr));
> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +/**
> + * @brief Write a COMMON_DESTROY_EQ command.
> + *
> + * @param sli4 SLI context.
> + * @param buf Destination buffer for the command.
> + * @param size Buffer size, in bytes.
> + * @param eq_id Queue ID to destroy.
> + *
> + * @note Other queue creation routines use the last parameter to pass in
> + * the associated Q_ID. EQ doesn't have an associated queue so this
> + * parameter is ignored.

Too much copy paste?

> + *
> + * @note This creates a Version 0 message.
> + *
> + * @return Returns zero for success and non-zero for failure.
> + */
> +static int
> +sli_md_common_destroy_eq(struct sli4_s *sli4, void *buf, size_t size,
> +			  u16 eq_id)
> +{
> +	struct sli4_rqst_cmn_destroy_eq_s *eq = NULL;

No need to initialized eq

> +
> +	eq = sli_config_cmd_init(sli4, buf, size,
> +				 SLI_CONFIG_PYLD_LENGTH(cmn_destroy_eq), NULL);
> +	if (!eq)
> +		return EFC_FAIL;
> +
> +	eq->hdr.opcode = CMN_DESTROY_EQ;
> +	eq->hdr.subsystem = SLI4_SUBSYSTEM_COMMON;
> +	eq->hdr.request_length = CFG_RQST_PYLD_LEN(cmn_destroy_eq);
> +
> +	eq->eq_id = cpu_to_le16(eq_id);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +/**
> + * @brief Write a COMMON_CREATE_MQ_EXT command.
> + *
> + * @param sli4 SLI context.
> + * @param buf Destination buffer for the command.
> + * @param size Buffer size, in bytes.
> + * @param qmem DMA memory for the queue.
> + * @param cq_id Associated CQ_ID.
> + * @param ignored This parameter carries the ULP
> + * which is only used for WQ and RQs
> + *
> + * @note This creates a Version 0 message.
> + *
> + * @return Returns zero for success and non-zero for failure.
> + */
> +static int
> +sli_cmd_common_create_mq_ext(struct sli4_s *sli4, void *buf, size_t size,
> +			     struct efc_dma_s *qmem,
> +			     u16 cq_id)
> +{
> +	struct sli4_rqst_cmn_create_mq_ext_s	*mq = NULL;

Too many spaces between type and variable.

> +	u32 p;
> +	uintptr_t addr;
> +	u32 num_pages;
> +	u16 dw6w1_flags = 0;
> +
> +	mq = sli_config_cmd_init(sli4, buf, size,
> +				 SLI_CONFIG_PYLD_LENGTH(cmn_create_mq_ext),
> +				 NULL);
> +	if (!mq)
> +		return EFC_FAIL;
> +
> +	mq->hdr.opcode = CMN_CREATE_MQ_EXT;
> +	mq->hdr.subsystem = SLI4_SUBSYSTEM_COMMON;
> +	mq->hdr.request_length = CFG_RQST_PYLD_LEN(cmn_create_mq_ext);
> +
> +	/* valid values for number of pages: 1, 2, 4, 8 (sec 4.4.12) */
> +	num_pages = qmem->size / SLI_PAGE_SIZE;
> +	mq->num_pages = cpu_to_le16(num_pages);
> +	switch (num_pages) {
> +	case 1:
> +		dw6w1_flags |= SLI4_MQE_SIZE_16;
> +		break;
> +	case 2:
> +		dw6w1_flags |= SLI4_MQE_SIZE_32;
> +		break;
> +	case 4:
> +		dw6w1_flags |= SLI4_MQE_SIZE_64;
> +		break;
> +	case 8:
> +		dw6w1_flags |= SLI4_MQE_SIZE_128;
> +		break;
> +	default:
> +		efc_log_info(sli4, "num_pages %d not valid\n", num_pages);
> +		return EFC_FAIL;
> +	}
> +
> +	mq->async_event_bitmap = cpu_to_le32(SLI4_ASYNC_EVT_FC_ALL);
> +
> +	if (sli4->mq_create_version) {
> +		mq->cq_id_v1 = cpu_to_le16(cq_id);
> +		mq->hdr.dw3_version = cpu_to_le32(CMD_V1);
> +	} else {
> +		dw6w1_flags |= (cq_id << CREATE_MQEXT_CQID_SHIFT);
> +	}
> +	mq->dw7_val = cpu_to_le32(CREATE_MQEXT_VAL);
> +
> +	mq->dw6w1_flags = cpu_to_le16(dw6w1_flags);
> +	for (p = 0, addr = qmem->phys; p < num_pages;
> +	     p++, addr += SLI_PAGE_SIZE) {

On one line?

> +		mq->page_phys_addr[p].low =
> +			cpu_to_le32(lower_32_bits(addr));
> +		mq->page_phys_addr[p].high =
> +			cpu_to_le32(upper_32_bits(addr));

And these as well?

> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +/**
> + * @brief Write a COMMON_DESTROY_MQ command.
> + *
> + * @param sli4 SLI context.
> + * @param buf Destination buffer for the command.
> + * @param size Buffer size, in bytes.
> + * @param mq_id MQ ID
> + *
> + * @note This creates a Version 0 message.
> + *
> + * @return Returns zero for success and non-zero for failure.
> + */
> +static int
> +sli_cmd_common_destroy_mq(struct sli4_s *sli4, void *buf, size_t size,
> +			  u16 mq_id)
> +{
> +	struct sli4_rqst_cmn_destroy_mq_s *mq = NULL;
> +
> +	mq = sli_config_cmd_init(sli4, buf, size,
> +				 SLI_CONFIG_PYLD_LENGTH(cmn_destroy_mq), NULL);
> +	if (!mq)
> +		return EFC_FAIL;
> +
> +	mq->hdr.opcode = CMN_DESTROY_MQ;
> +	mq->hdr.subsystem = SLI4_SUBSYSTEM_COMMON;
> +	mq->hdr.request_length = CFG_RQST_PYLD_LEN(cmn_destroy_mq);
> +
> +	mq->mq_id = cpu_to_le16(mq_id);
> +
> +	return EFC_SUCCESS;
> +}

sli_cmd_common_destroy_eq(), sli_cmd_common_destroy_cq() and
sli_cmd_common_destroy_mq() look almost identically. Could those
function be unified?

> +
> +/**
> + * @ingroup sli_fc
> + * @brief Write an WQ_CREATE command.
> + *
> + * @param sli4 SLI context.
> + * @param buf Destination buffer for the command.
> + * @param size Buffer size, in bytes.
> + * @param qmem DMA memory for the queue.
> + * @param cq_id Associated CQ_ID.
> + *
> + * @note This creates a Version 0 message.
> + *
> + * @return Returns zero for success and non-zero for failure.
> + */
> +int
> +sli_cmd_wq_create(struct sli4_s *sli4, void *buf, size_t size,
> +		  struct efc_dma_s *qmem, u16 cq_id)
> +{
> +	struct sli4_rqst_wq_create_s	*wq = NULL;

Too many spaces between type and variable.

> +	u32 p;
> +	uintptr_t addr;
> +
> +	wq = sli_config_cmd_init(sli4, buf, size,
> +				 SLI_CONFIG_PYLD_LENGTH(wq_create), NULL);
> +	if (!wq)
> +		return EFC_FAIL;
> +
> +	wq->hdr.opcode = SLI4_OPC_WQ_CREATE;
> +	wq->hdr.subsystem = SLI4_SUBSYSTEM_FC;
> +	wq->hdr.request_length = CFG_RQST_PYLD_LEN(wq_create);
> +
> +	/* valid values for number of pages: 1-4 (sec 4.5.1) */
> +	wq->num_pages = sli_page_count(qmem->size, SLI_PAGE_SIZE);
> +	if (!wq->num_pages ||
> +	    wq->num_pages > SLI4_WQ_CREATE_V0_MAX_PAGES)

On one line

> +		return EFC_FAIL;
> +
> +	wq->cq_id = cpu_to_le16(cq_id);
> +
> +	for (p = 0, addr = qmem->phys;
> +			p < wq->num_pages;
> +			p++, addr += SLI_PAGE_SIZE) {
> +		wq->page_phys_addr[p].low  =
> +				cpu_to_le32(lower_32_bits(addr));
> +		wq->page_phys_addr[p].high =
> +				cpu_to_le32(upper_32_bits(addr));

At least the last two assignments fit on one line.

> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +/**
> + * @ingroup sli_fc
> + * @brief Write an WQ_CREATE_V1 command.
> + *
> + * @param sli4 SLI context.
> + * @param buf Destination buffer for the command.
> + * @param size Buffer size, in bytes.
> + * @param qmem DMA memory for the queue.
> + * @param cq_id Associated CQ_ID.
> + *
> + * @return Returns zero for success and non-zero for failure.
> + */
> +int
> +sli_cmd_wq_create_v1(struct sli4_s *sli4, void *buf, size_t size,
> +		     struct efc_dma_s *qmem,
> +		     u16 cq_id)

cq_id on the same line as qmem?

> +{
> +	struct sli4_rqst_wq_create_v1_s *wq = NULL;
> +	u32 p;
> +	uintptr_t addr;
> +	u32 page_size = 0;
> +	u32 page_bytes = 0;
> +	u32 n_wqe = 0;
> +	u16 num_pages;
> +
> +	wq = sli_config_cmd_init(sli4, buf, size,
> +				 SLI_CONFIG_PYLD_LENGTH(wq_create_v1), NULL);
> +	if (!wq)
> +		return EFC_FAIL;
> +
> +	wq->hdr.opcode = SLI4_OPC_WQ_CREATE;
> +	wq->hdr.subsystem = SLI4_SUBSYSTEM_FC;
> +	wq->hdr.request_length = CFG_RQST_PYLD_LEN(wq_create_v1);
> +	wq->hdr.dw3_version = cpu_to_le32(CMD_V1);
> +
> +	n_wqe = qmem->size / sli4->wqe_size;
> +
> +	/*
> +	 * This heuristic to determine the page size is simplistic but could
> +	 * be made more sophisticated

Okay, but what is too simple?

> +	 */
> +	switch (qmem->size) {
> +	case 4096:
> +	case 8192:
> +	case 16384:
> +	case 32768:
> +		page_size = 1;
> +		break;
> +	case 65536:
> +		page_size = 2;
> +		break;
> +	case 131072:
> +		page_size = 4;
> +		break;
> +	case 262144:
> +		page_size = 8;
> +		break;
> +	case 524288:
> +		page_size = 10;
> +		break;
> +	default:
> +		return 0;

Isn't this an error?

> +	}
> +	page_bytes = page_size * SLI_PAGE_SIZE;
> +
> +	/* valid values for number of pages: 1-8 */

This comment is for num_pages, right? If so maybe it helps to add the
variable name to the comment "... number of pages (num_pages): 1.8". I
got slightly distracted by page_size :)

> +	num_pages = sli_page_count(qmem->size, page_bytes);
> +	wq->num_pages = cpu_to_le16(num_pages);
> +	if (!num_pages ||
> +	    num_pages > SLI4_WQ_CREATE_V1_MAX_PAGES)

On one line?

> +		return EFC_FAIL;
> +
> +	wq->cq_id = cpu_to_le16(cq_id);
> +
> +	wq->page_size = page_size;
> +
> +	if (sli4->wqe_size == SLI4_WQE_EXT_BYTES)
> +		wq->wqe_size_byte |= SLI4_WQE_EXT_SIZE;
> +	else
> +		wq->wqe_size_byte |= SLI4_WQE_SIZE;
> +
> +	wq->wqe_count = cpu_to_le16(n_wqe);
> +
> +	for (p = 0, addr = qmem->phys;
> +			p < num_pages;
> +			p++, addr += page_bytes) {
> +		wq->page_phys_addr[p].low  =
> +					cpu_to_le32(lower_32_bits(addr));
> +		wq->page_phys_addr[p].high =
> +					cpu_to_le32(upper_32_bits(addr));

These assignments fit on one line

> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +/**
> + * @ingroup sli_fc
> + * @brief Write an WQ_DESTROY command.
> + *
> + * @param sli4 SLI context.
> + * @param buf Destination buffer for the command.
> + * @param size Buffer size, in bytes.
> + * @param wq_id WQ_ID.
> + *
> + * @return Returns zero for success and non-zero for failure.
> + */
> +int
> +sli_cmd_wq_destroy(struct sli4_s *sli4, void *buf, size_t size,
> +		   u16 wq_id)
> +{
> +	struct sli4_rqst_wq_destroy_s *wq = NULL;
> +
> +	wq = sli_config_cmd_init(sli4, buf, size,
> +				 SLI_CONFIG_PYLD_LENGTH(wq_destroy), NULL);
> +	if (!wq)
> +		return EFC_FAIL;
> +
> +	wq->hdr.opcode = SLI4_OPC_WQ_DESTROY;
> +	wq->hdr.subsystem = SLI4_SUBSYSTEM_FC;
> +	wq->hdr.request_length = CFG_RQST_PYLD_LEN(wq_destroy);
> +
> +	wq->wq_id = cpu_to_le16(wq_id);
> +
> +	return EFC_SUCCESS;
> +}

So many function look almost identical. Is there no better way to
create the commands? Or is something like a generic command creation
function worse to maintain? There is so much copy paste... I stop now
pointing out the same issues again.

Thanks,
Daniel

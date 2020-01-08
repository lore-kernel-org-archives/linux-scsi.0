Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E60C00523
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 07:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A0E32053B
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 07:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgAHHp3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 02:45:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:39542 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgAHHp3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jan 2020 02:45:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1CB07AD2C;
        Wed,  8 Jan 2020 07:45:27 +0000 (UTC)
Subject: Re: [PATCH v2 04/32] elx: libefc_sli: queue create/destroy/parse
 routines
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-5-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <07c171f7-3d2c-a3ce-37ed-2b02f00fa6b2@suse.de>
Date:   Wed, 8 Jan 2020 08:45:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-5-jsmart2021@gmail.com>
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
> This patch adds service routines to create mailbox commands
> and adds APIs to create/destroy/parse SLI-4 EQ, CQ, RQ and MQ queues.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/include/efc_common.h |   27 +
>  drivers/scsi/elx/libefc_sli/sli4.c    | 1556 +++++++++++++++++++++++++++++++++
>  drivers/scsi/elx/libefc_sli/sli4.h    |    9 +
>  3 files changed, 1592 insertions(+)
> 
> diff --git a/drivers/scsi/elx/include/efc_common.h b/drivers/scsi/elx/include/efc_common.h
> index 3fc48876c531..c339b22c35b5 100644
> --- a/drivers/scsi/elx/include/efc_common.h
> +++ b/drivers/scsi/elx/include/efc_common.h
> @@ -22,4 +22,31 @@ struct efc_dma {
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
> +#define efc_assert(cond, ...) \
> +	do { \
> +		if (!(cond)) { \
> +			pr_err("%s(%d) assertion (%s) failed\n", \
> +				__FILE__, __LINE__, #cond); \
> +			dump_stack(); \
> +		} \
> +	} while (0)
> +
>  #endif /* __EFC_COMMON_H__ */
> diff --git a/drivers/scsi/elx/libefc_sli/sli4.c b/drivers/scsi/elx/libefc_sli/sli4.c
> index 29d33becd334..7061f7980fad 100644
> --- a/drivers/scsi/elx/libefc_sli/sli4.c
> +++ b/drivers/scsi/elx/libefc_sli/sli4.c
> @@ -24,3 +24,1559 @@ static struct sli4_asic_entry_t sli4_asic_table[] = {
>  	{ SLI4_ASIC_REV_A3, SLI4_ASIC_GEN_6},
>  	{ SLI4_ASIC_REV_A1, SLI4_ASIC_GEN_7},
>  };
> +
> +/* Convert queue type enum (SLI_QTYPE_*) into a string */
> +static char *SLI_QNAME[] = {
> +	"Event Queue",
> +	"Completion Queue",
> +	"Mailbox Queue",
> +	"Work Queue",
> +	"Receive Queue",
> +	"Undefined"
> +};
> +
> +/*
> + * Write a SLI_CONFIG command to the provided buffer.
> + *
> + * @sli4 SLI context pointer.
> + * @buf Destination buffer for the command.
> + * @size size of the destination buffer(buf).
> + * @length Length in bytes of attached command.
> + * @dma DMA buffer for non-embedded commands.
> + *
> + */
> +static void *
> +sli_config_cmd_init(struct sli4 *sli4, void *buf,
> +		    size_t size, u32 length,
> +		    struct efc_dma *dma)
> +{
> +	struct sli4_cmd_sli_config *config = NULL;
> +	u32 flags = 0;
> +
> +	if (length > sizeof(config->payload.embed) && !dma) {
> +		efc_log_err(sli4, "Too big for an embedded cmd with len(%d)\n",
> +			    length);
> +		return NULL;
> +	}
> +
> +	config = buf;
> +
> +	memset(buf, 0, size);
> +
> +	config->hdr.command = MBX_CMD_SLI_CONFIG;
> +	if (!dma) {
> +		flags |= SLI4_SLICONF_EMB;
> +		config->dw1_flags = cpu_to_le32(flags);
> +		config->payload_len = cpu_to_le32(length);
> +		buf += offsetof(struct sli4_cmd_sli_config, payload.embed);
> +		return buf;
> +	}
> +
> +	flags = SLI4_SLICONF_PMDCMD_VAL_1;
> +	flags &= ~SLI4_SLICONF_EMB;
> +	config->dw1_flags = cpu_to_le32(flags);
> +
> +	config->payload.mem.addr.low = cpu_to_le32(lower_32_bits(dma->phys));
> +	config->payload.mem.addr.high =	cpu_to_le32(upper_32_bits(dma->phys));
> +	config->payload.mem.length =
> +			cpu_to_le32(dma->size & SLI4_SLICONFIG_PMD_LEN);
> +	config->payload_len = cpu_to_le32(dma->size);
> +	/* save pointer to DMA for BMBX dumping purposes */
> +	sli4->bmbx_non_emb_pmd = dma;
> +	return dma->virt;
> +}
> +
> +/*
> + * Write a COMMON_CREATE_CQ command.
> + *
> + * This creates a Version 2 message.
> + *
> + * Returns 0 on success, or non-zero otherwise.
> + */
> +static int
> +sli_cmd_common_create_cq(struct sli4 *sli4, void *buf, size_t size,
> +			 struct efc_dma *qmem,
> +			 u16 eq_id)
> +{
> +	struct sli4_rqst_cmn_create_cq_v2 *cqv2 = NULL;
> +	u32 p;
> +	uintptr_t addr;
> +	u32 page_bytes = 0;
> +	u32 num_pages = 0;
> +	size_t cmd_size = 0;
> +	u32 page_size = 0;
> +	u32 n_cqe = 0;
> +	u32 dw5_flags = 0;
> +	u16 dw6w1_arm = 0;
> +	__le32 len;
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
> +	len = CFG_RQST_PYLD_LEN_VAR(cmn_create_cq_v2,
> +					 SZ_DMAADDR * num_pages);
> +	sli_cmd_fill_hdr(&cqv2->hdr, CMN_CREATE_CQ, SLI4_SUBSYSTEM_COMMON,
> +			 CMD_V2, len);
> +	cqv2->page_size = page_size;
> +
> +	/* valid values for number of pages: 1, 2, 4, 8 (sec 4.4.3) */
> +	cqv2->num_pages = cpu_to_le16(num_pages);
> +	if (!num_pages || num_pages > SLI4_CMN_CREATE_CQ_V2_MAX_PAGES)
> +		return EFC_FAIL;
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
> +		return -EFC_FAIL;
> +	}
> +
Hmm. Why do you return -EFC_FAIL here, and EFC_FAIL in the two cases above?
Do you differentiate between EFC_FAIL and -EFC_FAIL?
If so you should probably use different #defines ...

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
> +	for (p = 0, addr = qmem->phys; p < num_pages; p++, addr += page_bytes) {
> +		cqv2->page_phys_addr[p].low = cpu_to_le32(lower_32_bits(addr));
> +		cqv2->page_phys_addr[p].high = cpu_to_le32(upper_32_bits(addr));
> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +/* Write a COMMON_CREATE_EQ command */
> +static int
> +sli_cmd_common_create_eq(struct sli4 *sli4, void *buf, size_t size,
> +			 struct efc_dma *qmem)
> +{
> +	struct sli4_rqst_cmn_create_eq *eq;
> +	u32 p;
> +	uintptr_t addr;
> +	u16 num_pages;
> +	u32 dw5_flags = 0;
> +	u32 dw6_flags = 0, ver;
> +
> +	eq = sli_config_cmd_init(sli4, buf, size,
> +				 SLI_CONFIG_PYLD_LENGTH(cmn_create_eq), NULL);
> +	if (!eq)
> +		return EFC_FAIL;
> +
> +	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
> +		ver = CMD_V2;
> +
> +	sli_cmd_fill_hdr(&eq->hdr, CMN_CREATE_EQ, SLI4_SUBSYSTEM_COMMON,
> +			 ver, CFG_RQST_PYLD_LEN(cmn_create_eq));
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
> +		efc_log_err(sli4, "num_pages %d not valid\n", num_pages);
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
> +		eq->page_address[p].low = cpu_to_le32(lower_32_bits(addr));
> +		eq->page_address[p].high = cpu_to_le32(upper_32_bits(addr));
> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +static int
> +sli_cmd_common_create_mq_ext(struct sli4 *sli4, void *buf, size_t size,
> +			     struct efc_dma *qmem,
> +			     u16 cq_id)
> +{
> +	struct sli4_rqst_cmn_create_mq_ext *mq;
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
> +	sli_cmd_fill_hdr(&mq->hdr, CMN_CREATE_MQ_EXT, SLI4_SUBSYSTEM_COMMON,
> +			 CMD_V0, CFG_RQST_PYLD_LEN(cmn_create_mq_ext));
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
> +		mq->page_phys_addr[p].low = cpu_to_le32(lower_32_bits(addr));
> +		mq->page_phys_addr[p].high = cpu_to_le32(upper_32_bits(addr));
> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_cmd_wq_create(struct sli4 *sli4, void *buf, size_t size,
> +		     struct efc_dma *qmem, u16 cq_id)
> +{
> +	struct sli4_rqst_wq_create *wq;
> +	u32 p;
> +	uintptr_t addr;
> +	u32 page_size = 0;
> +	u32 page_bytes = 0;
> +	u32 n_wqe = 0;
> +	u16 num_pages;
> +
> +	wq = sli_config_cmd_init(sli4, buf, size,
> +				 SLI_CONFIG_PYLD_LENGTH(wq_create), NULL);
> +	if (!wq)
> +		return EFC_FAIL;
> +
> +	sli_cmd_fill_hdr(&wq->hdr, SLI4_OPC_WQ_CREATE, SLI4_SUBSYSTEM_FC,
> +			 CMD_V1, CFG_RQST_PYLD_LEN(wq_create));
> +	n_wqe = qmem->size / sli4->wqe_size;
> +
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
> +		return EFC_FAIL;
> +	}
> +	page_bytes = page_size * SLI_PAGE_SIZE;
> +
> +	/* valid values for number of pages(num_pages): 1-8 */
> +	num_pages = sli_page_count(qmem->size, page_bytes);
> +	wq->num_pages = cpu_to_le16(num_pages);
> +	if (!num_pages || num_pages > SLI4_WQ_CREATE_MAX_PAGES)
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
> +	for (p = 0, addr = qmem->phys; p < num_pages; p++, addr += page_bytes) {
> +		wq->page_phys_addr[p].low  = cpu_to_le32(lower_32_bits(addr));
> +		wq->page_phys_addr[p].high = cpu_to_le32(upper_32_bits(addr));
> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_cmd_rq_create(struct sli4 *sli4, void *buf, size_t size,
> +		  struct efc_dma *qmem,
> +		  u16 cq_id, u16 buffer_size)
> +{
> +	struct sli4_rqst_rq_create *rq;
> +	u32 p;
> +	uintptr_t addr;
> +	u16 num_pages;
> +
> +	rq = sli_config_cmd_init(sli4, buf, size,
> +				 SLI_CONFIG_PYLD_LENGTH(rq_create), NULL);
> +	if (!rq)
> +		return EFC_FAIL;
> +
> +	sli_cmd_fill_hdr(&rq->hdr, SLI4_OPC_RQ_CREATE, SLI4_SUBSYSTEM_FC,
> +			 CMD_V0, CFG_RQST_PYLD_LEN(rq_create));
> +	/* valid values for number of pages: 1-8 (sec 4.5.6) */
> +	num_pages = sli_page_count(qmem->size, SLI_PAGE_SIZE);
> +	rq->num_pages = cpu_to_le16(num_pages);
> +	if (!num_pages ||
> +	    num_pages > SLI4_RQ_CREATE_V0_MAX_PAGES) {
> +		efc_log_info(sli4, "num_pages %d not valid\n", num_pages);
> +		return 0;
> +	}
> +

'0'? Why not EFC_FAIL/EFC_SUCCESS?

> +	/*
> +	 * RQE count is the log base 2 of the total number of entries
> +	 */
> +	rq->rqe_count_byte |= 31 - __builtin_clz(qmem->size / SLI4_RQE_SIZE);
> +
> +	if (buffer_size < SLI4_RQ_CREATE_V0_MIN_BUF_SIZE ||
> +	    buffer_size > SLI4_RQ_CREATE_V0_MAX_BUF_SIZE) {
> +		efc_log_err(sli4, "buffer_size %d out of range (%d-%d)\n",
> +		       buffer_size,
> +		       SLI4_RQ_CREATE_V0_MIN_BUF_SIZE,
> +		       SLI4_RQ_CREATE_V0_MAX_BUF_SIZE);
> +		return -1;
> +	}

'-1'? Not EFC_FAIL?

[ .. ]
> +int
> +__sli_queue_init(struct sli4 *sli4, struct sli4_queue *q,
> +		 u32 qtype, size_t size, u32 n_entries,
> +		      u32 align)
> +{
> +	if (!q->dma.virt || size != q->size ||
> +	    n_entries != q->length) {
> +		if (q->dma.size)
> +			__sli_queue_destroy(sli4, q);
> +
> +		memset(q, 0, sizeof(struct sli4_queue));
> +
> +		q->dma.size = size * n_entries;
> +		q->dma.virt = dma_alloc_coherent(&sli4->pcidev->dev,
> +						 q->dma.size, &q->dma.phys,
> +						 GFP_DMA);> +		if (!q->dma.virt) {
> +			memset(&q->dma, 0, sizeof(struct efc_dma));
> +			efc_log_err(sli4, "%s allocation failed\n",
> +			       SLI_QNAME[qtype]);
> +			return -1;
> +		}

EFC_FAIL?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

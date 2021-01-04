Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E04C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 13:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 996A8207B1
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 13:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbhADNlV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 08:41:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:58538 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbhADNlV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 08:41:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E0B22B7CF;
        Mon,  4 Jan 2021 13:40:38 +0000 (UTC)
Date:   Mon, 4 Jan 2021 14:40:38 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v5 04/31] elx: libefc_sli: queue create/destroy/parse
 routines
Message-ID: <20210104134038.lu35z7y6z4zqdxfn@beryllium.lan>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
 <20210103171134.39878-5-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210103171134.39878-5-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Sun, Jan 03, 2021 at 09:11:07AM -0800, James Smart wrote:
> +int
> +sli_fc_rq_alloc(struct sli4 *sli4, struct sli4_queue *q,
> +		u32 n_entries, u32 buffer_size,
> +		struct sli4_queue *cq, bool is_hdr)
> +{
> +	if (__sli_queue_init(sli4, q, SLI4_QTYPE_RQ, SLI4_RQE_SIZE,
> +			     n_entries, SLI_PAGE_SIZE))
> +		return EFC_FAIL;
> +
> +	if (!sli_cmd_rq_create_v1(sli4, sli4->bmbx.virt, &q->dma, cq->id,
> +				  buffer_size)) {
> +		if (__sli_create_queue(sli4, q)) {
> +			efc_log_info(sli4, "Create queue failed %d\n", q->id);
> +			goto error;
> +		}
> +		if (is_hdr && q->id & 1) {
> +			efc_log_info(sli4, "bad header RQ_ID %d\n", q->id);
> +			goto error;
> +		} else if (!is_hdr  && (q->id & 1) == 0) {
> +			efc_log_info(sli4, "bad data RQ_ID %d\n", q->id);
> +			goto error;
> +		}
> +	} else {
> +		goto error;
> +	}

This could be written as

	if (sli_cmd_rq_create_v1())
		goto error;
        if (__sli_create_queue())
		goto error;



> +	if (is_hdr)
> +		q->u.flag |= SLI4_QUEUE_FLAG_HDR;
> +	else
> +		q->u.flag &= ~SLI4_QUEUE_FLAG_HDR;
> +	return EFC_SUCCESS;
> +error:
> +	__sli_queue_destroy(sli4, q);
> +	return EFC_FAIL;
> +}
> +
> +int
> +sli_fc_rq_set_alloc(struct sli4 *sli4, u32 num_rq_pairs,
> +		    struct sli4_queue *qs[], u32 base_cq_id,
> +		    u32 n_entries, u32 header_buffer_size,
> +		    u32 payload_buffer_size)
> +{
> +	u32 i;
> +	struct efc_dma dma = {0};
> +	struct sli4_rsp_cmn_create_queue_set *rsp = NULL;
> +	void __iomem *db_regaddr = NULL;
> +	u32 num_rqs = num_rq_pairs * 2;
> +
> +	for (i = 0; i < num_rqs; i++) {
> +		if (__sli_queue_init(sli4, qs[i], SLI4_QTYPE_RQ,
> +				     SLI4_RQE_SIZE, n_entries,
> +				     SLI_PAGE_SIZE)) {
> +			goto error;
> +		}
> +	}
> +
> +	if (sli_cmd_rq_create_v2(sli4, num_rqs, qs, base_cq_id,
> +			       header_buffer_size, payload_buffer_size, &dma)) {
> +		goto error;
> +	}
> +
> +	if (sli_bmbx_command(sli4)) {
> +		efc_log_err(sli4, "bootstrap mailbox write failed RQSet\n");
> +		goto error;
> +	}
> +
> +	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
> +		db_regaddr = sli4->reg[1] + SLI4_IF6_RQ_DB_REG;
> +	else
> +		db_regaddr = sli4->reg[0] + SLI4_RQ_DB_REG;
> +
> +	rsp = dma.virt;
> +	if (rsp->hdr.status) {
> +		efc_log_err(sli4, "bad create RQSet status=%#x addl=%#x\n",
> +		       rsp->hdr.status, rsp->hdr.additional_status);
> +		goto error;
> +	} else {
> +		for (i = 0; i < num_rqs; i++) {
> +			qs[i]->id = i + le16_to_cpu(rsp->q_id);
> +			if ((qs[i]->id & 1) == 0)
> +				qs[i]->u.flag |= SLI4_QUEUE_FLAG_HDR;
> +			else
> +				qs[i]->u.flag &= ~SLI4_QUEUE_FLAG_HDR;
> +
> +			qs[i]->db_regaddr = db_regaddr;
> +		}
> +	}

With the goto in first block you don't need the else block.

> +
> +	dma_free_coherent(&sli4->pci->dev, dma.size, dma.virt, dma.phys);
> +
> +	return EFC_SUCCESS;
> +
> +error:
> +	for (i = 0; i < num_rqs; i++)
> +		__sli_queue_destroy(sli4, qs[i]);
> +
> +	if (dma.virt)
> +		dma_free_coherent(&sli4->pci->dev, dma.size, dma.virt,
> +				  dma.phys);
> +
> +	return EFC_FAIL;
> +}

[...]

> +int
> +sli_cq_alloc_set(struct sli4 *sli4, struct sli4_queue *qs[],
> +		 u32 num_cqs, u32 n_entries, struct sli4_queue *eqs[])
> +{
> +	u32 i;
> +	struct efc_dma dma = {0};
> +	struct sli4_rsp_cmn_create_queue_set *res;
> +	void __iomem *db_regaddr;
> +
> +	/* Align the queue DMA memory */
> +	for (i = 0; i < num_cqs; i++) {
> +		if (__sli_queue_init(sli4, qs[i], SLI4_QTYPE_CQ,
> +				SLI4_CQE_BYTES, n_entries, SLI_PAGE_SIZE))
> +			goto error;
> +	}
> +
> +	if (sli_cmd_cq_set_create(sli4, qs, num_cqs, eqs, &dma))
> +		goto error;
> +
> +	if (sli_bmbx_command(sli4))
> +		goto error;
> +
> +	if (sli4->if_type == SLI4_INTF_IF_TYPE_6)
> +		db_regaddr = sli4->reg[1] + SLI4_IF6_CQ_DB_REG;
> +	else
> +		db_regaddr = sli4->reg[0] + SLI4_EQCQ_DB_REG;
> +
> +	res = dma.virt;
> +	if (res->hdr.status) {
> +		efc_log_err(sli4, "bad create CQSet status=%#x addl=%#x\n",
> +		       res->hdr.status, res->hdr.additional_status);
> +		goto error;
> +	} else {
> +		/* Check if we got all requested CQs. */
> +		if (le16_to_cpu(res->num_q_allocated) != num_cqs) {
> +			efc_log_crit(sli4, "Requested count CQs doesn't match.\n");
> +			goto error;
> +		}
> +		/* Fill the resp cq ids. */
> +		for (i = 0; i < num_cqs; i++) {
> +			qs[i]->id = le16_to_cpu(res->q_id) + i;
> +			qs[i]->db_regaddr = db_regaddr;
> +		}
> +	}

With the goto in the true block the else block is not needed.

> +
> +	dma_free_coherent(&sli4->pci->dev, dma.size, dma.virt, dma.phys);
> +
> +	return EFC_SUCCESS;
> +
> +error:
> +	for (i = 0; i < num_cqs; i++)
> +		__sli_queue_destroy(sli4, qs[i]);
> +
> +	if (dma.virt)
> +		dma_free_coherent(&sli4->pci->dev, dma.size, dma.virt,
> +				  dma.phys);
> +
> +	return EFC_FAIL;
> +}

[...]

> +int
> +sli_eq_read(struct sli4 *sli4, struct sli4_queue *q, u8 *entry)
> +{
> +	u8 *qe = q->dma.virt;
> +	u32 *qindex = NULL;
> +	unsigned long flags = 0;
> +	u8 clear = false, valid = false;
> +	u16 wflags = 0;
> +
> +	clear = (sli4->if_type == SLI4_INTF_IF_TYPE_6) ?  false : true;
> +
> +	qindex = &q->index;
> +
> +	spin_lock_irqsave(&q->lock, flags);

First, why does the q->index access not be protected by the lock and
second, why do you need the variable anyway? Can't you just use
q->index directly?

> +
> +	qe += *qindex * q->size;
> +
> +	/* Check if eqe is valid */
> +	wflags = le16_to_cpu(((struct sli4_eqe *)qe)->dw0w0_flags);
> +	valid = ((wflags & SLI4_EQE_VALID) == q->phase);
> +	if (!valid) {

valid is not used anywhere else. It could be avoided.

> +		spin_unlock_irqrestore(&q->lock, flags);
> +		return EFC_FAIL;
> +	}
> +
> +	if (clear) {

Clear is a local variable only used once here. And why do the
comparison right here where it's needed?

> +		wflags &= ~SLI4_EQE_VALID;
> +		((struct sli4_eqe *)qe)->dw0w0_flags =
> +						cpu_to_le16(wflags);
> +	}
> +
> +	memcpy(entry, qe, q->size);
> +	*qindex = (*qindex + 1) & (q->length - 1);
> +	q->n_posted++;
> +	/*
> +	 * For prism, the phase value will be used
> +	 * to check the validity of eq/cq entries.
> +	 * The value toggles after a complete sweep
> +	 * through the queue.
> +	 */
> +
> +	if (sli4->if_type == SLI4_INTF_IF_TYPE_6 && *qindex == 0)
> +		q->phase ^= (u16)0x1;
> +
> +	spin_unlock_irqrestore(&q->lock, flags);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_cq_read(struct sli4 *sli4, struct sli4_queue *q, u8 *entry)
> +{
> +	u8 *qe = q->dma.virt;
> +	u32 *qindex = NULL;
> +	unsigned long	flags = 0;
> +	u8 clear = false;
> +	u32 dwflags = 0;
> +	bool valid_bit_set;
> +
> +	clear = (sli4->if_type == SLI4_INTF_IF_TYPE_6) ?  false : true;
> +
> +	qindex = &q->index;
> +
> +	spin_lock_irqsave(&q->lock, flags);

The same question as above about q->index.

> +
> +	qe += *qindex * q->size;
> +
> +	/* Check if cqe is valid */
> +	dwflags = le32_to_cpu(((struct sli4_mcqe *)qe)->dw3_flags);
> +	valid_bit_set = (dwflags & SLI4_MCQE_VALID) != 0;
> +
> +	if (valid_bit_set != q->phase) {
> +		spin_unlock_irqrestore(&q->lock, flags);
> +		return EFC_FAIL;
> +	}
> +
> +	if (clear) {

Same comment as in the above function on 'clear'.

> +		dwflags &= ~SLI4_MCQE_VALID;
> +		((struct sli4_mcqe *)qe)->dw3_flags =
> +					cpu_to_le32(dwflags);
> +	}
> +
> +	memcpy(entry, qe, q->size);
> +	*qindex = (*qindex + 1) & (q->length - 1);
> +	q->n_posted++;
> +	/*
> +	 * For prism, the phase value will be used
> +	 * to check the validity of eq/cq entries.
> +	 * The value toggles after a complete sweep
> +	 * through the queue.
> +	 */
> +
> +	if (sli4->if_type == SLI4_INTF_IF_TYPE_6 && *qindex == 0)
> +		q->phase ^= (u16)0x1;
> +
> +	spin_unlock_irqrestore(&q->lock, flags);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +int
> +sli_mq_read(struct sli4 *sli4, struct sli4_queue *q, u8 *entry)
> +{
> +	u8 *qe = q->dma.virt;
> +	u32 *qindex = NULL;
> +	unsigned long flags = 0;
> +
> +	qindex = &q->u.r_idx;
> +
> +	spin_lock_irqsave(&q->lock, flags);

qindex again.

> +
> +	qe += *qindex * q->size;
> +
> +	/* Check if mqe is valid */
> +	if (q->index == q->u.r_idx) {
> +		spin_unlock_irqrestore(&q->lock, flags);
> +		return EFC_FAIL;
> +	}
> +
> +	memcpy(entry, qe, q->size);
> +	*qindex = (*qindex + 1) & (q->length - 1);
> +
> +	spin_unlock_irqrestore(&q->lock, flags);
> +
> +	return EFC_SUCCESS;
> +}

Thanks,
Daniel

Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CEFEC352BE
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 08:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BE7820787
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 08:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440757AbgDPI0J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 04:26:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:53120 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441395AbgDPIZQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 04:25:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 10F3EACD8;
        Thu, 16 Apr 2020 08:24:13 +0000 (UTC)
Date:   Thu, 16 Apr 2020 10:24:12 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v3 17/31] elx: efct: Hardware queues creation and deletion
Message-ID: <20200416082412.i3z5dswnsgmrximd@carbon>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-18-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200412033303.29574-18-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Apr 11, 2020 at 08:32:49PM -0700, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Routines for queue creation, deletion, and configuration.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>   Removed all Queue topology parsing code
>   Reworked queue creation code.
> ---
>  drivers/scsi/elx/efct/efct_hw_queues.c | 765 +++++++++++++++++++++++++++++++++
>  1 file changed, 765 insertions(+)
>  create mode 100644 drivers/scsi/elx/efct/efct_hw_queues.c
> 
> diff --git a/drivers/scsi/elx/efct/efct_hw_queues.c b/drivers/scsi/elx/efct/efct_hw_queues.c
> new file mode 100644
> index 000000000000..c343e7c5b20d
> --- /dev/null
> +++ b/drivers/scsi/elx/efct/efct_hw_queues.c
> @@ -0,0 +1,765 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +#include "efct_driver.h"
> +#include "efct_hw.h"
> +#include "efct_unsol.h"
> +
> +/**
> + * SLI queues are created and initialized
> + */
> +enum efct_hw_rtn
> +efct_hw_init_queues(struct efct_hw *hw)
> +{
> +	struct hw_eq *eq = NULL;
> +	struct hw_cq *cq = NULL;
> +	struct hw_wq *wq = NULL;
> +	struct hw_rq *rq = NULL;
> +	struct hw_mq *mq = NULL;
> +
> +	hw->eq_count = 0;
> +	hw->cq_count = 0;
> +	hw->mq_count = 0;
> +	hw->wq_count = 0;
> +	hw->rq_count = 0;
> +	hw->hw_rq_count = 0;
> +	INIT_LIST_HEAD(&hw->eq_list);
> +
> +	/* Create EQ */
> +	eq = efct_hw_new_eq(hw, EFCT_HW_EQ_DEPTH);
> +	if (!eq) {
> +		efct_hw_queue_teardown(hw);
> +		return EFCT_HW_RTN_NO_MEMORY;

Not sure if it's worth to intorduce EFCT_HW_RTN_NO_MEMORY, because
ENOMEM is pretty good match and ENOMEM is used in other places
already.

> +	}
> +
> +	/* Create RQ*/
> +	cq = efct_hw_new_cq(eq, hw->num_qentries[SLI_QTYPE_CQ]);
> +	if (!cq) {
> +		efct_hw_queue_teardown(hw);
> +		return EFCT_HW_RTN_NO_MEMORY;
> +	}
> +
> +	rq = efct_hw_new_rq(cq, EFCT_HW_RQ_ENTRIES_DEF);
> +	if (!rq) {
> +		efct_hw_queue_teardown(hw);
> +		return EFCT_HW_RTN_NO_MEMORY;
> +	}
> +
> +	/* Create MQ*/
> +	cq = efct_hw_new_cq(eq, hw->num_qentries[SLI_QTYPE_CQ]);
> +	if (!cq) {
> +		efct_hw_queue_teardown(hw);
> +		return EFCT_HW_RTN_NO_MEMORY;
> +	}
> +
> +	mq = efct_hw_new_mq(cq, EFCT_HW_MQ_DEPTH);
> +	if (!mq) {
> +		efct_hw_queue_teardown(hw);
> +		return EFCT_HW_RTN_NO_MEMORY;
> +	}
> +
> +	/* Create WQ */
> +	cq = efct_hw_new_cq(eq, hw->num_qentries[SLI_QTYPE_CQ]);
> +	if (!cq) {
> +		efct_hw_queue_teardown(hw);
> +		return EFCT_HW_RTN_NO_MEMORY;
> +	}
> +
> +	wq = efct_hw_new_wq(cq, hw->num_qentries[SLI_QTYPE_WQ]);
> +	if (!wq) {
> +		efct_hw_queue_teardown(hw);
> +		return EFCT_HW_RTN_NO_MEMORY;
> +	}
> +
> +	return EFCT_HW_RTN_SUCCESS;
> +}
> +
> +/* Allocate a new EQ object */
> +struct hw_eq *
> +efct_hw_new_eq(struct efct_hw *hw, u32 entry_count)
> +{
> +	struct hw_eq *eq = kmalloc(sizeof(*eq), GFP_KERNEL);
> +
> +	if (eq) {

	if (!eq)
		return NULL;

> +		memset(eq, 0, sizeof(*eq));

kzalloc instead kmalloc + memset

> +		eq->type = SLI_QTYPE_EQ;
> +		eq->hw = hw;
> +		eq->entry_count = entry_count;
> +		eq->instance = hw->eq_count++;
> +		eq->queue = &hw->eq[eq->instance];
> +		INIT_LIST_HEAD(&eq->cq_list);
> +
> +		if (sli_queue_alloc(&hw->sli, SLI_QTYPE_EQ,
> +					eq->queue,
> +					entry_count, NULL)) {
> +			efc_log_err(hw->os,
> +					"EQ[%d] allocation failure\n",
> +					eq->instance);
> +			kfree(eq);
> +			eq = NULL;
			return NULL;
> +		} else {
> +			sli_eq_modify_delay(&hw->sli, eq->queue,
> +					1, 0, 8);
> +			hw->hw_eq[eq->instance] = eq;
> +			INIT_LIST_HEAD(&eq->list_entry);
> +			list_add_tail(&eq->list_entry, &hw->eq_list);
> +			efc_log_debug(hw->os,
> +					"create eq[%2d] id %3d len %4d\n",
> +					eq->instance, eq->queue->id,
> +					eq->entry_count);
> +		}
> +	}
> +	return eq;
> +}
> +
> +/* Allocate a new CQ object */
> +struct hw_cq *
> +efct_hw_new_cq(struct hw_eq *eq, u32 entry_count)
> +{
> +	struct efct_hw *hw = eq->hw;
> +	struct hw_cq *cq = kmalloc(sizeof(*cq), GFP_KERNEL);
> +
> +	if (cq) {

	if (!cq)
		return NULL;

> +		memset(cq, 0, sizeof(*cq));

kzalloc instead of kmalloc + memset


> +		cq->eq = eq;
> +		cq->type = SLI_QTYPE_CQ;
> +		cq->instance = eq->hw->cq_count++;
> +		cq->entry_count = entry_count;
> +		cq->queue = &hw->cq[cq->instance];
> +
> +		INIT_LIST_HEAD(&cq->q_list);
> +
> +		if (sli_queue_alloc(&hw->sli, SLI_QTYPE_CQ, cq->queue,
> +				    cq->entry_count, eq->queue)) {
> +			efc_log_err(hw->os,
> +				     "CQ[%d] allocation failure len=%d\n",
> +				    eq->instance,
> +				    eq->entry_count);
> +			kfree(cq);
> +			cq = NULL;

			return NULL;

> +		} else {
> +			hw->hw_cq[cq->instance] = cq;
> +			INIT_LIST_HEAD(&cq->list_entry);
> +			list_add_tail(&cq->list_entry, &eq->cq_list);
> +			efc_log_debug(hw->os,
> +				       "create cq[%2d] id %3d len %4d\n",
> +				      cq->instance, cq->queue->id,
> +				      cq->entry_count);
> +		}
> +	}
> +	return cq;
> +}
> +
> +/* Allocate a new CQ Set of objects */
> +u32
> +efct_hw_new_cq_set(struct hw_eq *eqs[], struct hw_cq *cqs[],
> +		   u32 num_cqs, u32 entry_count)
> +{
> +	u32 i;
> +	struct efct_hw *hw = eqs[0]->hw;
> +	struct sli4 *sli4 = &hw->sli;
> +	struct hw_cq *cq = NULL;
> +	struct sli4_queue *qs[SLI_MAX_CQ_SET_COUNT];
> +	struct sli4_queue *assefct[SLI_MAX_CQ_SET_COUNT];
> +
> +	/* Initialise CQS pointers to NULL */
> +	for (i = 0; i < num_cqs; i++)
> +		cqs[i] = NULL;
> +
> +	for (i = 0; i < num_cqs; i++) {
> +		cq = kmalloc(sizeof(*cq), GFP_KERNEL);
> +		if (!cq)
> +			goto error;
> +
> +		memset(cq, 0, sizeof(*cq));

kzalloc()

> +		cqs[i]          = cq;
> +		cq->eq          = eqs[i];
> +		cq->type        = SLI_QTYPE_CQ;
> +		cq->instance    = hw->cq_count++;
> +		cq->entry_count = entry_count;
> +		cq->queue       = &hw->cq[cq->instance];
> +		qs[i]           = cq->queue;
> +		assefct[i]       = eqs[i]->queue;
> +		INIT_LIST_HEAD(&cq->q_list);
> +	}
> +
> +	if (!sli_cq_alloc_set(sli4, qs, num_cqs, entry_count, assefct)) {
> +		efc_log_err(hw->os, "Failed to create CQ Set.\n");
> +		goto error;
> +	}
> +
> +	for (i = 0; i < num_cqs; i++) {
> +		hw->hw_cq[cqs[i]->instance] = cqs[i];
> +		INIT_LIST_HEAD(&cqs[i]->list_entry);
> +		list_add_tail(&cqs[i]->list_entry, &cqs[i]->eq->cq_list);
> +	}
> +
> +	return EFC_SUCCESS;
> +
> +error:
> +	for (i = 0; i < num_cqs; i++) {
> +		kfree(cqs[i]);

		if (cqs[i])
			kfree(cqs[i]);

> +		cqs[i] = NULL;
> +	}
> +	return EFC_FAIL;
> +}
> +
> +/* Allocate a new MQ object */
> +struct hw_mq *
> +efct_hw_new_mq(struct hw_cq *cq, u32 entry_count)
> +{
> +	struct efct_hw *hw = cq->eq->hw;
> +	struct hw_mq *mq = kmalloc(sizeof(*mq), GFP_KERNEL);
> +
> +	if (mq) {

if (!mq)
	return

> +		memset(mq, 0, sizeof(*mq));

kzalloc

> +		mq->cq = cq;
> +		mq->type = SLI_QTYPE_MQ;
> +		mq->instance = cq->eq->hw->mq_count++;
> +		mq->entry_count = entry_count;
> +		mq->entry_size = EFCT_HW_MQ_DEPTH;
> +		mq->queue = &hw->mq[mq->instance];
> +
> +		if (sli_queue_alloc(&hw->sli, SLI_QTYPE_MQ,
> +				    mq->queue,
> +				    mq->entry_size,
> +				    cq->queue)) {
> +			efc_log_err(hw->os, "MQ allocation failure\n");
> +			kfree(mq);
> +			mq = NULL;
> +		} else {
> +			hw->hw_mq[mq->instance] = mq;
> +			INIT_LIST_HEAD(&mq->list_entry);
> +			list_add_tail(&mq->list_entry, &cq->q_list);
> +			efc_log_debug(hw->os,
> +				       "create mq[%2d] id %3d len %4d\n",
> +				      mq->instance, mq->queue->id,
> +				      mq->entry_count);
> +		}
> +	}
> +	return mq;
> +}
> +
> +/* Allocate a new WQ object */
> +struct hw_wq *
> +efct_hw_new_wq(struct hw_cq *cq, u32 entry_count)
> +{
> +	struct efct_hw *hw = cq->eq->hw;
> +	struct hw_wq *wq = kmalloc(sizeof(*wq), GFP_KERNEL);
> +
> +	if (wq) {
> +		memset(wq, 0, sizeof(*wq));

same above


> +		wq->hw = cq->eq->hw;
> +		wq->cq = cq;
> +		wq->type = SLI_QTYPE_WQ;
> +		wq->instance = cq->eq->hw->wq_count++;
> +		wq->entry_count = entry_count;
> +		wq->queue = &hw->wq[wq->instance];
> +		wq->wqec_set_count = EFCT_HW_WQEC_SET_COUNT;
> +		wq->wqec_count = wq->wqec_set_count;
> +		wq->free_count = wq->entry_count - 1;
> +		INIT_LIST_HEAD(&wq->pending_list);
> +
> +		if (sli_queue_alloc(&hw->sli, SLI_QTYPE_WQ, wq->queue,
> +				    wq->entry_count, cq->queue)) {
> +			efc_log_err(hw->os, "WQ allocation failure\n");
> +			kfree(wq);
> +			wq = NULL;

return NULL;

> +		} else {
> +			hw->hw_wq[wq->instance] = wq;
> +			INIT_LIST_HEAD(&wq->list_entry);
> +			list_add_tail(&wq->list_entry, &cq->q_list);
> +			efc_log_debug(hw->os,
> +				       "create wq[%2d] id %3d len %4d cls %d\n",
> +				wq->instance, wq->queue->id,
> +				wq->entry_count, wq->class);
> +		}
> +	}
> +	return wq;
> +}
> +
> +/* Allocate an RQ object, which encapsulates 2 SLI queues (for rq pair) */
> +struct hw_rq *
> +efct_hw_new_rq(struct hw_cq *cq, u32 entry_count)
> +{
> +	struct efct_hw *hw = cq->eq->hw;
> +	struct hw_rq *rq = kmalloc(sizeof(*rq), GFP_KERNEL);
> +
> +	if (rq) {
> +		memset(rq, 0, sizeof(*rq));

and again :)

> +		rq->instance = hw->hw_rq_count++;
> +		rq->cq = cq;
> +		rq->type = SLI_QTYPE_RQ;
> +		rq->entry_count = entry_count;
> +
> +		/* Create the header RQ */
> +		rq->hdr = &hw->rq[hw->rq_count];
> +		rq->hdr_entry_size = EFCT_HW_RQ_HEADER_SIZE;
> +
> +		if (sli_fc_rq_alloc(&hw->sli, rq->hdr,
> +				    rq->entry_count,
> +				    rq->hdr_entry_size,
> +				    cq->queue,
> +				    true)) {
> +			efc_log_err(hw->os,
> +				     "RQ allocation failure - header\n");
> +			kfree(rq);
> +			return NULL;
> +		}
> +		/* Update hw_rq_lookup[] */
> +		hw->hw_rq_lookup[hw->rq_count] = rq->instance;
> +		hw->rq_count++;
> +		efc_log_debug(hw->os,
> +			      "create rq[%2d] id %3d len %4d hdr  size %4d\n",
> +			      rq->instance, rq->hdr->id, rq->entry_count,
> +			      rq->hdr_entry_size);
> +
> +		/* Create the default data RQ */
> +		rq->data = &hw->rq[hw->rq_count];
> +		rq->data_entry_size = hw->config.rq_default_buffer_size;
> +
> +		if (sli_fc_rq_alloc(&hw->sli, rq->data,
> +				    rq->entry_count,
> +				    rq->data_entry_size,
> +				    cq->queue,
> +				    false)) {
> +			efc_log_err(hw->os,
> +				     "RQ allocation failure - first burst\n");
> +			kfree(rq);
> +			return NULL;
> +		}
> +		/* Update hw_rq_lookup[] */
> +		hw->hw_rq_lookup[hw->rq_count] = rq->instance;
> +		hw->rq_count++;
> +		efc_log_debug(hw->os,
> +			       "create rq[%2d] id %3d len %4d data size %4d\n",
> +			 rq->instance, rq->data->id, rq->entry_count,
> +			 rq->data_entry_size);
> +
> +		hw->hw_rq[rq->instance] = rq;
> +		INIT_LIST_HEAD(&rq->list_entry);
> +		list_add_tail(&rq->list_entry, &cq->q_list);
> +
> +		rq->rq_tracker = kmalloc_array(rq->entry_count,
> +					sizeof(struct efc_hw_sequence *),
> +					GFP_ATOMIC);
> +		if (!rq->rq_tracker)
> +			return NULL;
> +
> +		memset(rq->rq_tracker, 0,
> +		       rq->entry_count * sizeof(struct efc_hw_sequence *));
> +	}
> +	return rq;
> +}
> +
> +/**
> + * Allocate an RQ object SET, where each element in set
> + * encapsulates 2 SLI queues (for rq pair)
> + */
> +u32
> +efct_hw_new_rq_set(struct hw_cq *cqs[], struct hw_rq *rqs[],
> +		   u32 num_rq_pairs, u32 entry_count)
> +{
> +	struct efct_hw *hw = cqs[0]->eq->hw;
> +	struct hw_rq *rq = NULL;
> +	struct sli4_queue *qs[SLI_MAX_RQ_SET_COUNT * 2] = { NULL };
> +	u32 i, q_count, size;
> +
> +	/* Initialise RQS pointers */
> +	for (i = 0; i < num_rq_pairs; i++)
> +		rqs[i] = NULL;
> +
> +	for (i = 0, q_count = 0; i < num_rq_pairs; i++, q_count += 2) {
> +		rq = kmalloc(sizeof(*rq), GFP_KERNEL);
> +		if (!rq)
> +			goto error;
> +
> +		memset(rq, 0, sizeof(*rq));

kzalloc

> +		rqs[i] = rq;
> +		rq->instance = hw->hw_rq_count++;
> +		rq->cq = cqs[i];
> +		rq->type = SLI_QTYPE_RQ;
> +		rq->entry_count = entry_count;
> +
> +		/* Header RQ */
> +		rq->hdr = &hw->rq[hw->rq_count];
> +		rq->hdr_entry_size = EFCT_HW_RQ_HEADER_SIZE;
> +		hw->hw_rq_lookup[hw->rq_count] = rq->instance;
> +		hw->rq_count++;
> +		qs[q_count] = rq->hdr;
> +
> +		/* Data RQ */
> +		rq->data = &hw->rq[hw->rq_count];
> +		rq->data_entry_size = hw->config.rq_default_buffer_size;
> +		hw->hw_rq_lookup[hw->rq_count] = rq->instance;
> +		hw->rq_count++;
> +		qs[q_count + 1] = rq->data;
> +
> +		rq->rq_tracker = NULL;
> +	}
> +
> +	if (!sli_fc_rq_set_alloc(&hw->sli, num_rq_pairs, qs,
> +				cqs[0]->queue->id,
> +			    rqs[0]->entry_count,
> +			    rqs[0]->hdr_entry_size,
> +			    rqs[0]->data_entry_size)) {
> +		efc_log_err(hw->os,
> +			     "RQ Set allocation failure for base CQ=%d\n",
> +			    cqs[0]->queue->id);
> +		goto error;
> +	}
> +
> +	for (i = 0; i < num_rq_pairs; i++) {
> +		hw->hw_rq[rqs[i]->instance] = rqs[i];
> +		INIT_LIST_HEAD(&rqs[i]->list_entry);
> +		list_add_tail(&rqs[i]->list_entry, &cqs[i]->q_list);
> +		size = sizeof(struct efc_hw_sequence *) * rqs[i]->entry_count;
> +		rqs[i]->rq_tracker = kmalloc(size, GFP_KERNEL);
> +		if (!rqs[i]->rq_tracker)
> +			goto error;
> +	}
> +
> +	return EFC_SUCCESS;
> +
> +error:
> +	for (i = 0; i < num_rq_pairs; i++) {
> +		if (rqs[i]) {
> +			kfree(rqs[i]->rq_tracker);

Is rq_tracker always a valid pointer?

> +			kfree(rqs[i]);
> +		}
> +	}
> +
> +	return EFC_FAIL;
> +}
> +
> +void
> +efct_hw_del_eq(struct hw_eq *eq)
> +{
> +	if (eq) {
> +		struct hw_cq *cq;
> +		struct hw_cq *cq_next;
> +
> +		list_for_each_entry_safe(cq, cq_next, &eq->cq_list, list_entry)
> +			efct_hw_del_cq(cq);
> +		list_del(&eq->list_entry);
> +		eq->hw->hw_eq[eq->instance] = NULL;
> +		kfree(eq);
> +	}
> +}
> +
> +void
> +efct_hw_del_cq(struct hw_cq *cq)
> +{
> +	if (cq) {

if (!cq)
	return;

> +		struct hw_q *q;
> +		struct hw_q *q_next;
> +
> +		list_for_each_entry_safe(q, q_next, &cq->q_list, list_entry) {
> +			switch (q->type) {
> +			case SLI_QTYPE_MQ:
> +				efct_hw_del_mq((struct hw_mq *)q);
> +				break;
> +			case SLI_QTYPE_WQ:
> +				efct_hw_del_wq((struct hw_wq *)q);
> +				break;
> +			case SLI_QTYPE_RQ:
> +				efct_hw_del_rq((struct hw_rq *)q);
> +				break;
> +			default:
> +				break;
> +			}
> +		}
> +		list_del(&cq->list_entry);
> +		cq->eq->hw->hw_cq[cq->instance] = NULL;
> +		kfree(cq);
> +	}
> +}
> +
> +void
> +efct_hw_del_mq(struct hw_mq *mq)
> +{
> +	if (mq) {

if (!mq)
	return;

> +		list_del(&mq->list_entry);
> +		mq->cq->eq->hw->hw_mq[mq->instance] = NULL;
> +		kfree(mq);
> +	}
> +}
> +
> +void
> +efct_hw_del_wq(struct hw_wq *wq)
> +{
> +	if (wq) {

if (!wq)
	return;

> +		list_del(&wq->list_entry);
> +		wq->cq->eq->hw->hw_wq[wq->instance] = NULL;
> +		kfree(wq);
> +	}
> +}
> +
> +void
> +efct_hw_del_rq(struct hw_rq *rq)
> +{
> +	struct efct_hw *hw = NULL;
> +
> +	if (rq) {

if (!rq)
	return;

> +		/* Free RQ tracker */
> +		kfree(rq->rq_tracker);
> +		rq->rq_tracker = NULL;
> +		list_del(&rq->list_entry);
> +		hw = rq->cq->eq->hw;
> +		hw->hw_rq[rq->instance] = NULL;
> +		kfree(rq);
> +	}
> +}
> +
> +void
> +efct_hw_queue_dump(struct efct_hw *hw)
> +{
> +	struct hw_eq *eq;
> +	struct hw_cq *cq;
> +	struct hw_q *q;
> +	struct hw_mq *mq;
> +	struct hw_wq *wq;
> +	struct hw_rq *rq;
> +
> +	list_for_each_entry(eq, &hw->eq_list, list_entry) {
> +		efc_log_debug(hw->os, "eq[%d] id %2d\n",
> +			       eq->instance, eq->queue->id);
> +		list_for_each_entry(cq, &eq->cq_list, list_entry) {
> +			efc_log_debug(hw->os, "cq[%d] id %2d current\n",
> +				       cq->instance, cq->queue->id);
> +			list_for_each_entry(q, &cq->q_list, list_entry) {
> +				switch (q->type) {
> +				case SLI_QTYPE_MQ:
> +					mq = (struct hw_mq *)q;
> +					efc_log_debug(hw->os,
> +						       "    mq[%d] id %2d\n",
> +					       mq->instance, mq->queue->id);
> +					break;
> +				case SLI_QTYPE_WQ:
> +					wq = (struct hw_wq *)q;
> +					efc_log_debug(hw->os,
> +						       "    wq[%d] id %2d\n",
> +						wq->instance, wq->queue->id);
> +					break;
> +				case SLI_QTYPE_RQ:
> +					rq = (struct hw_rq *)q;
> +					efc_log_debug(hw->os,
> +						       "    rq[%d] hdr id %2d\n",
> +					       rq->instance, rq->hdr->id);
> +					break;
> +				default:
> +					break;
> +				}
> +			}
> +		}

Maybe move inner loop into function.

> +	}
> +}
> +
> +void
> +efct_hw_queue_teardown(struct efct_hw *hw)
> +{
> +	struct hw_eq *eq;
> +	struct hw_eq *eq_next;
> +
> +	if (hw->eq_list.next) {

	if (!hw->eq_list.next)
		return;



> +		list_for_each_entry_safe(eq, eq_next, &hw->eq_list,
> +					 list_entry) {
> +			efct_hw_del_eq(eq);
> +		}
> +	}
> +}
> +
> +static inline int
> +efct_hw_rqpair_find(struct efct_hw *hw, u16 rq_id)
> +{
> +	return efct_hw_queue_hash_find(hw->rq_hash, rq_id);
> +}
> +
> +static struct efc_hw_sequence *
> +efct_hw_rqpair_get(struct efct_hw *hw, u16 rqindex, u16 bufindex)
> +{
> +	struct sli4_queue *rq_hdr = &hw->rq[rqindex];
> +	struct efc_hw_sequence *seq = NULL;
> +	struct hw_rq *rq = hw->hw_rq[hw->hw_rq_lookup[rqindex]];
> +	unsigned long flags = 0;
> +
> +	if (bufindex >= rq_hdr->length) {
> +		efc_log_err(hw->os,
> +				"RQidx %d bufidx %d exceed ring len %d for id %d\n",
> +				rqindex, bufindex, rq_hdr->length, rq_hdr->id);
> +		return NULL;
> +	}
> +
> +	/* rq_hdr lock also covers rqindex+1 queue */
> +	spin_lock_irqsave(&rq_hdr->lock, flags);
> +
> +	seq = rq->rq_tracker[bufindex];
> +	rq->rq_tracker[bufindex] = NULL;
> +
> +	if (!seq) {
> +		efc_log_err(hw->os,
> +			     "RQbuf NULL, rqidx %d, bufidx %d, cur q idx = %d\n",
> +			     rqindex, bufindex, rq_hdr->index);
> +	}
> +
> +	spin_unlock_irqrestore(&rq_hdr->lock, flags);
> +	return seq;
> +}
> +
> +int
> +efct_hw_rqpair_process_rq(struct efct_hw *hw, struct hw_cq *cq,
> +			  u8 *cqe)
> +{
> +	u16 rq_id;
> +	u32 index;
> +	int rqindex;
> +	int	 rq_status;
> +	u32 h_len;
> +	u32 p_len;
> +	struct efc_hw_sequence *seq;
> +	struct hw_rq *rq;

the alignemnt of the variables is inconsistent

> +
> +	rq_status = sli_fc_rqe_rqid_and_index(&hw->sli, cqe,
> +					      &rq_id, &index);
> +	if (rq_status != 0) {
> +		switch (rq_status) {
> +		case SLI4_FC_ASYNC_RQ_BUF_LEN_EXCEEDED:
> +		case SLI4_FC_ASYNC_RQ_DMA_FAILURE:
> +			/* just get RQ buffer then return to chip */
> +			rqindex = efct_hw_rqpair_find(hw, rq_id);
> +			if (rqindex < 0) {
> +				efc_log_test(hw->os,
> +					      "status=%#x: lookup fail id=%#x\n",
> +					     rq_status, rq_id);
> +				break;
> +			}
> +
> +			/* get RQ buffer */
> +			seq = efct_hw_rqpair_get(hw, rqindex, index);
> +
> +			/* return to chip */
> +			if (efct_hw_rqpair_sequence_free(hw, seq)) {
> +				efc_log_test(hw->os,
> +					      "status=%#x,fail rtrn buf to RQ\n",
> +					     rq_status);
> +				break;
> +			}
> +			break;
> +		case SLI4_FC_ASYNC_RQ_INSUFF_BUF_NEEDED:
> +		case SLI4_FC_ASYNC_RQ_INSUFF_BUF_FRM_DISC:
> +			/*
> +			 * since RQ buffers were not consumed, cannot return
> +			 * them to chip
> +			 * fall through
> +			 */
> +			efc_log_debug(hw->os, "Warning: RCQE status=%#x,\n",
> +				       rq_status);
> +		default:
> +			break;
> +		}
> +		return EFC_FAIL;
> +	}
> +
> +	rqindex = efct_hw_rqpair_find(hw, rq_id);
> +	if (rqindex < 0) {
> +		efc_log_test(hw->os, "Error: rq_id lookup failed for id=%#x\n",
> +			      rq_id);
> +		return EFC_FAIL;
> +	}
> +
> +	rq = hw->hw_rq[hw->hw_rq_lookup[rqindex]];
> +	rq->use_count++;
> +
> +	seq = efct_hw_rqpair_get(hw, rqindex, index);
> +	if (WARN_ON(!seq))
> +		return EFC_FAIL;
> +
> +	seq->hw = hw;
> +	seq->auto_xrdy = 0;
> +	seq->out_of_xris = 0;
> +	seq->hio = NULL;
> +
> +	sli_fc_rqe_length(&hw->sli, cqe, &h_len, &p_len);
> +	seq->header->dma.len = h_len;
> +	seq->payload->dma.len = p_len;
> +	seq->fcfi = sli_fc_rqe_fcfi(&hw->sli, cqe);
> +	seq->hw_priv = cq->eq;
> +
> +	efct_unsolicited_cb(hw->os, seq);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +static int
> +efct_hw_rqpair_put(struct efct_hw *hw, struct efc_hw_sequence *seq)
> +{
> +	struct sli4_queue *rq_hdr = &hw->rq[seq->header->rqindex];
> +	struct sli4_queue *rq_payload = &hw->rq[seq->payload->rqindex];
> +	u32 hw_rq_index = hw->hw_rq_lookup[seq->header->rqindex];
> +	struct hw_rq *rq = hw->hw_rq[hw_rq_index];
> +	u32     phys_hdr[2];
> +	u32     phys_payload[2];
> +	int      qindex_hdr;
> +	int      qindex_payload;
> +	unsigned long flags = 0;

the alignemnt of the variables is inconsistent

> +
> +	/* Update the RQ verification lookup tables */
> +	phys_hdr[0] = upper_32_bits(seq->header->dma.phys);
> +	phys_hdr[1] = lower_32_bits(seq->header->dma.phys);
> +	phys_payload[0] = upper_32_bits(seq->payload->dma.phys);
> +	phys_payload[1] = lower_32_bits(seq->payload->dma.phys);
> +
> +	/* rq_hdr lock also covers payload / header->rqindex+1 queue */
> +	spin_lock_irqsave(&rq_hdr->lock, flags);
> +
> +	/*
> +	 * Note: The header must be posted last for buffer pair mode because
> +	 *       posting on the header queue posts the payload queue as well.
> +	 *       We do not ring the payload queue independently in RQ pair mode.
> +	 */
> +	qindex_payload = sli_rq_write(&hw->sli, rq_payload,
> +				      (void *)phys_payload);
> +	qindex_hdr = sli_rq_write(&hw->sli, rq_hdr, (void *)phys_hdr);
> +	if (qindex_hdr < 0 ||
> +	    qindex_payload < 0) {
> +		efc_log_err(hw->os, "RQ_ID=%#x write failed\n", rq_hdr->id);
> +		spin_unlock_irqrestore(&rq_hdr->lock, flags);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	/* ensure the indexes are the same */
> +	WARN_ON(qindex_hdr != qindex_payload);
> +
> +	/* Update the lookup table */
> +	if (!rq->rq_tracker[qindex_hdr]) {
> +		rq->rq_tracker[qindex_hdr] = seq;
> +	} else {
> +		efc_log_test(hw->os,
> +			      "expected rq_tracker[%d][%d] buffer to be NULL\n",
> +			     hw_rq_index, qindex_hdr);
> +	}
> +
> +	spin_unlock_irqrestore(&rq_hdr->lock, flags);
> +	return EFCT_HW_RTN_SUCCESS;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_rqpair_sequence_free(struct efct_hw *hw,
> +			     struct efc_hw_sequence *seq)
> +{
> +	enum efct_hw_rtn   rc = EFCT_HW_RTN_SUCCESS;
> +
> +	/*
> +	 * Post the data buffer first. Because in RQ pair mode, ringing the
> +	 * doorbell of the header ring will post the data buffer as well.
> +	 */
> +	if (efct_hw_rqpair_put(hw, seq)) {
> +		efc_log_err(hw->os, "error writing buffers\n");
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	return rc;
> +}
> -- 
> 2.16.4
> 

Thanks,
Daniel

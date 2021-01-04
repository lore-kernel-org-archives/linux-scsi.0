Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEB6C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 17:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 194A3206CB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 17:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbhADRlP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:41:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:39572 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726124AbhADRlO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 12:41:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 495ADAD29;
        Mon,  4 Jan 2021 17:40:31 +0000 (UTC)
Date:   Mon, 4 Jan 2021 18:40:29 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v5 20/31] elx: efct: RQ buffer, memory pool allocation
 and deallocation APIs
Message-ID: <20210104174029.s5pumutkb24sr33u@beryllium.lan>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
 <20210103171134.39878-21-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210103171134.39878-21-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Sun, Jan 03, 2021 at 09:11:23AM -0800, James Smart wrote:
> +static struct efc_hw_rq_buffer *
> +efct_hw_rx_buffer_alloc(struct efct_hw *hw, u32 rqindex, u32 count,
> +			u32 size)
> +{
> +	struct efct *efct = hw->os;
> +	struct efc_hw_rq_buffer *rq_buf = NULL;
> +	struct efc_hw_rq_buffer *prq;
> +	u32 i;
> +
> +	if (count != 0) {

	if (!count)
		return NULL;


> +		rq_buf = kmalloc_array(count, sizeof(*rq_buf), GFP_KERNEL);
> +		if (!rq_buf)
> +			return NULL;
> +		memset(rq_buf, 0, sizeof(*rq_buf) * count);
> +
> +		for (i = 0, prq = rq_buf; i < count; i ++, prq++) {
> +			prq->rqindex = rqindex;
> +			prq->dma.size = size;
> +			prq->dma.virt = dma_alloc_coherent(&efct->pci->dev,
> +							   prq->dma.size,
> +							   &prq->dma.phys,
> +							   GFP_DMA);
> +			if (!prq->dma.virt) {
> +				efc_log_err(hw->os, "DMA allocation failed\n");
> +				kfree(rq_buf);
> +				rq_buf = NULL;
> +				break;

				return NULL;

> +			}
> +		}
> +	}
> +	return rq_buf;
> +}
> +
> +static void
> +efct_hw_rx_buffer_free(struct efct_hw *hw,
> +		       struct efc_hw_rq_buffer *rq_buf,
> +			u32 count)
> +{
> +	struct efct *efct = hw->os;
> +	u32 i;
> +	struct efc_hw_rq_buffer *prq;
> +
> +	if (rq_buf) {
> +		for (i = 0, prq = rq_buf; i < count; i++, prq++) {
> +			dma_free_coherent(&efct->pci->dev,
> +					  prq->dma.size, prq->dma.virt,
> +					  prq->dma.phys);
> +			memset(&prq->dma, 0, sizeof(struct efc_dma));
> +		}
> +
> +		kfree(rq_buf);
> +	}
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_rx_allocate(struct efct_hw *hw)
> +{
> +	struct efct *efct = hw->os;
> +	u32 i;
> +	int rc = EFCT_HW_RTN_SUCCESS;
> +	u32 rqindex = 0;
> +	u32 hdr_size = EFCT_HW_RQ_SIZE_HDR;
> +	u32 payload_size = hw->config.rq_default_buffer_size;
> +
> +	rqindex = 0;
> +
> +	for (i = 0; i < hw->hw_rq_count; i++) {
> +		struct hw_rq *rq = hw->hw_rq[i];
> +
> +		/* Allocate header buffers */
> +		rq->hdr_buf = efct_hw_rx_buffer_alloc(hw, rqindex,
> +						      rq->entry_count,
> +						      hdr_size);
> +		if (!rq->hdr_buf) {
> +			efc_log_err(efct,
> +				     "efct_hw_rx_buffer_alloc hdr_buf failed\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +			break;
> +		}
> +
> +		efc_log_debug(hw->os,
> +			       "rq[%2d] rq_id %02d header  %4d by %4d bytes\n",
> +			      i, rq->hdr->id, rq->entry_count, hdr_size);
> +
> +		rqindex++;
> +
> +		/* Allocate payload buffers */
> +		rq->payload_buf = efct_hw_rx_buffer_alloc(hw, rqindex,
> +							  rq->entry_count,
> +							  payload_size);
> +		if (!rq->payload_buf) {
> +			efc_log_err(efct,
> +				     "efct_hw_rx_buffer_alloc fb_buf failed\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +			break;
> +		}
> +		efc_log_debug(hw->os,
> +			       "rq[%2d] rq_id %02d default %4d by %4d bytes\n",
> +			      i, rq->data->id, rq->entry_count, payload_size);
> +		rqindex++;
> +	}
> +
> +	return rc ? EFCT_HW_RTN_ERROR : EFCT_HW_RTN_SUCCESS;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_rx_post(struct efct_hw *hw)
> +{
> +	u32 i;
> +	u32 idx;
> +	u32 rq_idx;
> +	int rc = 0;

rc = EFCT_HW_RTN_SUCCESS. And what's about the type? Shouldn't it be
enum efct_hw_rtn?

Could you please double check all the return values/types in the rest of
the patches. If the initial code base is not consistent things will go
south from there and we end up with a mix between two styles, which is
just annoying.

> +
> +	if (!hw->seq_pool) {
> +		u32 count = 0;
> +
> +		for (i = 0; i < hw->hw_rq_count; i++)
> +			count += hw->hw_rq[i]->entry_count;
> +
> +		hw->seq_pool = kmalloc_array(count,
> +				sizeof(struct efc_hw_sequence),	GFP_KERNEL);
> +		if (!hw->seq_pool)
> +			return EFCT_HW_RTN_NO_MEMORY;
> +	}
> +
> +	/*
> +	 * In RQ pair mode, we MUST post the header and payload buffer at the
> +	 * same time.
> +	 */
> +	for (rq_idx = 0, idx = 0; rq_idx < hw->hw_rq_count; rq_idx++) {
> +		struct hw_rq *rq = hw->hw_rq[rq_idx];
> +
> +		for (i = 0; i < rq->entry_count - 1; i++) {
> +			struct efc_hw_sequence *seq;
> +
> +			seq = hw->seq_pool + idx;
> +			idx++;
> +			seq->header = &rq->hdr_buf[i];
> +			seq->payload = &rq->payload_buf[i];
> +			rc = efct_hw_sequence_free(hw, seq);
> +			if (rc)
> +				break;
> +		}
> +		if (rc)
> +			break;
> +	}
> +
> +	if (rc && hw->seq_pool)
> +		kfree(hw->seq_pool);
> +
> +	return rc;
> +}
> +
> +void
> +efct_hw_rx_free(struct efct_hw *hw)
> +{
> +	u32 i;
> +
> +	/* Free hw_rq buffers */
> +	for (i = 0; i < hw->hw_rq_count; i++) {
> +		struct hw_rq *rq = hw->hw_rq[i];
> +
> +		if (rq) {
> +			efct_hw_rx_buffer_free(hw, rq->hdr_buf,
> +					       rq->entry_count);
> +			rq->hdr_buf = NULL;
> +			efct_hw_rx_buffer_free(hw, rq->payload_buf,
> +					       rq->entry_count);
> +			rq->payload_buf = NULL;
> +		}
> +	}
> +}
> +
> +static int
> +efct_hw_cmd_submit_pending(struct efct_hw *hw)
> +{
> +	struct efct_command_ctx *ctx = NULL;
> +	int rc = 0;
> +
> +	/* Assumes lock held */
> +
> +	/* Only submit MQE if there's room */
> +	while (hw->cmd_head_count < (EFCT_HW_MQ_DEPTH - 1) &&
> +	       !list_empty(&hw->cmd_pending)) {
> +		ctx = list_first_entry(&hw->cmd_pending,
> +				       struct efct_command_ctx, list_entry);
> +		if (!ctx)
> +			break;
> +
> +		list_del_init(&ctx->list_entry);
> +
> +		list_add_tail(&ctx->list_entry, &hw->cmd_head);
> +		hw->cmd_head_count++;
> +		if (sli_mq_write(&hw->sli, hw->mq, ctx->buf) < 0) {
> +			efc_log_debug(hw->os,
> +				      "sli_queue_write failed: %d\n", rc);
> +			rc = -1;
> +			break;
> +		}
> +	}
> +	return rc;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_command(struct efct_hw *hw, u8 *cmd, u32 opts, void *cb, void *arg)
> +{
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
> +	unsigned long flags = 0;
> +	void *bmbx = NULL;
> +
> +	/*
> +	 * If the chip is in an error state (UE'd) then reject this mailbox
> +	 * command.
> +	 */
> +	if (sli_fw_error_status(&hw->sli) > 0) {
> +		efc_log_crit(hw->os,
> +			      "Chip is in an error state - reset needed\n");
> +		efc_log_crit(hw->os,
> +			      "status=%#x error1=%#x error2=%#x\n",
> +			sli_reg_read_status(&hw->sli),
> +			sli_reg_read_err1(&hw->sli),
> +			sli_reg_read_err2(&hw->sli));
> +
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	/*
> +	 * Send a mailbox command to the hardware, and either wait for
> +	 * a completion (EFCT_CMD_POLL) or get an optional asynchronous
> +	 * completion (EFCT_CMD_NOWAIT).
> +	 */
> +
> +	if (opts == EFCT_CMD_POLL) {
> +		mutex_lock(&hw->bmbx_lock);
> +		bmbx = hw->sli.bmbx.virt;
> +
> +		memset(bmbx, 0, SLI4_BMBX_SIZE);
> +		memcpy(bmbx, cmd, SLI4_BMBX_SIZE);
> +
> +		if (sli_bmbx_command(&hw->sli) == 0) {
> +			rc = EFCT_HW_RTN_SUCCESS;
> +			memcpy(cmd, bmbx, SLI4_BMBX_SIZE);
> +		}
> +		mutex_unlock(&hw->bmbx_lock);
> +	} else if (opts == EFCT_CMD_NOWAIT) {
> +		struct efct_command_ctx	*ctx = NULL;
> +
> +		if (hw->state != EFCT_HW_STATE_ACTIVE) {
> +			efc_log_err(hw->os,
> +				     "Can't send command, HW state=%d\n",
> +				    hw->state);
> +			return EFCT_HW_RTN_ERROR;
> +		}
> +
> +		ctx = mempool_alloc(hw->cmd_ctx_pool, GFP_ATOMIC);
> +		if (!ctx)
> +			return EFCT_HW_RTN_NO_RESOURCES;
> +
> +		memset(ctx, 0, sizeof(struct efct_command_ctx));
> +
> +		if (cb) {
> +			ctx->cb = cb;
> +			ctx->arg = arg;
> +		}
> +
> +		memcpy(ctx->buf, cmd, SLI4_BMBX_SIZE);
> +		ctx->ctx = hw;
> +
> +		spin_lock_irqsave(&hw->cmd_lock, flags);
> +
> +		/* Add to pending list */
> +		INIT_LIST_HEAD(&ctx->list_entry);
> +		list_add_tail(&ctx->list_entry, &hw->cmd_pending);
> +
> +		/* Submit as much of the pending list as we can */
> +		rc = efct_hw_cmd_submit_pending(hw);
> +
> +		spin_unlock_irqrestore(&hw->cmd_lock, flags);
> +	}
> +
> +	return rc;
> +}
> +
> +static int
> +efct_hw_command_process(struct efct_hw *hw, int status, u8 *mqe,
> +			size_t size)
> +{
> +	struct efct_command_ctx *ctx = NULL;
> +	unsigned long flags = 0;
> +
> +	spin_lock_irqsave(&hw->cmd_lock, flags);
> +	if (!list_empty(&hw->cmd_head)) {
> +		ctx = list_first_entry(&hw->cmd_head,
> +				       struct efct_command_ctx, list_entry);
> +		list_del_init(&ctx->list_entry);
> +	}
> +	if (!ctx) {
> +		efc_log_err(hw->os, "no command context?!?\n");
> +		spin_unlock_irqrestore(&hw->cmd_lock, flags);
> +		return EFC_FAIL;
> +	}
> +
> +	hw->cmd_head_count--;
> +
> +	/* Post any pending requests */
> +	efct_hw_cmd_submit_pending(hw);
> +
> +	spin_unlock_irqrestore(&hw->cmd_lock, flags);
> +
> +	if (ctx->cb) {
> +		memcpy(ctx->buf, mqe, size);
> +		ctx->cb(hw, status, ctx->buf, ctx->arg);
> +	}
> +
> +	mempool_free(ctx, hw->cmd_ctx_pool);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +static int
> +efct_hw_mq_process(struct efct_hw *hw,
> +		   int status, struct sli4_queue *mq)
> +{
> +	u8 mqe[SLI4_BMBX_SIZE];
> +
> +	if (!sli_mq_read(&hw->sli, mq, mqe))
> +		efct_hw_command_process(hw, status, mqe, mq->size);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +static int
> +efct_hw_command_cancel(struct efct_hw *hw)
> +{
> +	unsigned long flags = 0;
> +
> +	spin_lock_irqsave(&hw->cmd_lock, flags);
> +
> +	/*
> +	 * Manually clean up remaining commands. Note: since this calls
> +	 * efct_hw_command_process(), we'll also process the cmd_pending
> +	 * list, so no need to manually clean that out.
> +	 */
> +	while (!list_empty(&hw->cmd_head)) {
> +		u8		mqe[SLI4_BMBX_SIZE] = { 0 };
> +		struct efct_command_ctx *ctx =
> +	list_first_entry(&hw->cmd_head, struct efct_command_ctx, list_entry);

This looks a bit ugly. What about

		struct efct_command_ctx *ctx;
		ctx = list_first_entry(&hw->cmd_head,
				       struct efct_command_ctx,
                                       list_entry);

?

> +
> +		efc_log_debug(hw->os, "hung command %08x\n",
> +			      !ctx ? U32_MAX :
> +			      (!ctx->buf ? U32_MAX :
> +			       *((u32 *)ctx->buf)));
> +		spin_unlock_irqrestore(&hw->cmd_lock, flags);
> +		efct_hw_command_process(hw, -1, mqe, SLI4_BMBX_SIZE);
> +		spin_lock_irqsave(&hw->cmd_lock, flags);
> +	}
> +
> +	spin_unlock_irqrestore(&hw->cmd_lock, flags);
> +
> +	return EFC_SUCCESS;
> +}

Thanks,
Daniel

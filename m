Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA536C2D0EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 08:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4AAA20644
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 08:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502510AbgDPInA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 04:43:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:32874 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502725AbgDPImM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 04:42:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 165D3AC4D;
        Thu, 16 Apr 2020 08:41:19 +0000 (UTC)
Date:   Thu, 16 Apr 2020 10:41:18 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v3 18/31] elx: efct: RQ buffer, memory pool allocation
 and deallocation APIs
Message-ID: <20200416084118.geuymznnl63ezqyr@carbon>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-19-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412033303.29574-19-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Apr 11, 2020 at 08:32:50PM -0700, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> RQ data buffer allocation and deallocate.
> Memory pool allocation and deallocation APIs.
> Mailbox command submission and completion routines.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>   efct_utils.c file is removed. Replaced efct_pool, efct_varray and
>   efct_array with other alternatives.
> ---
>  drivers/scsi/elx/efct/efct_hw.c | 375 ++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/elx/efct/efct_hw.h |   7 +
>  2 files changed, 382 insertions(+)
> 
> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
> index 21fcaf7b3d2b..3e9906749da2 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -1114,3 +1114,378 @@ efct_get_wwpn(struct efct_hw *hw)
>  	memcpy(p, sli->wwpn, sizeof(p));
>  	return get_unaligned_be64(p);
>  }
> +
> +/*
> + * An efct_hw_rx_buffer_t array is allocated,
> + * along with the required DMA mem
> + */
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

if (count == 0)
	return NULL;

and then there is no need to pre-initialize rq_buf

> +		rq_buf = kmalloc_array(count, sizeof(*rq_buf), GFP_ATOMIC);
> +		if (!rq_buf)
> +			return NULL;
> +		memset(rq_buf, 0, sizeof(*rq_buf) * count);

kzalloc

> +
> +		for (i = 0, prq = rq_buf; i < count; i ++, prq++) {
> +			prq->rqindex = rqindex;
> +			prq->dma.size = size;
> +			prq->dma.virt = dma_alloc_coherent(&efct->pcidev->dev,
> +							   prq->dma.size,
> +							   &prq->dma.phys,
> +							   GFP_DMA);

GFP_KERNEL

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

if (!rq_buf)
	return;

> +		for (i = 0, prq = rq_buf; i < count; i++, prq++) {
> +			dma_free_coherent(&efct->pcidev->dev,
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
> +	struct hw_rq *rq;
> +	u32 hdr_size = EFCT_HW_RQ_SIZE_HDR;
> +	u32 payload_size = hw->config.rq_default_buffer_size;
> +
> +	rqindex = 0;
> +
> +	for (i = 0; i < hw->hw_rq_count; i++) {
> +		rq = hw->hw_rq[i];
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
> +/* Post the RQ data buffers to the chip */
> +enum efct_hw_rtn
> +efct_hw_rx_post(struct efct_hw *hw)
> +{
> +	u32 i;
> +	u32 idx;
> +	u32 rq_idx;
> +	int rc = 0;
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
> +			seq = hw->seq_pool + idx * sizeof(*seq);
> +			if (!seq) {
> +				rc = -1;
> +				break;
> +			}
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
> +	struct hw_rq *rq;
> +	u32 i;
> +
> +	/* Free hw_rq buffers */
> +	for (i = 0; i < hw->hw_rq_count; i++) {
> +		rq = hw->hw_rq[i];
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

back to plain numbers.

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
> +		list_del(&ctx->list_entry);
> +
> +		INIT_LIST_HEAD(&ctx->list_entry);
> +		list_add_tail(&ctx->list_entry, &hw->cmd_head);
> +		hw->cmd_head_count++;
> +		if (sli_mq_write(&hw->sli, hw->mq, ctx->buf) < 0) {
> +			efc_log_test(hw->os,
> +				      "sli_queue_write failed: %d\n", rc);
> +			rc = -1;
> +			break;
> +		}
> +	}
> +	return rc;
> +}
> +
> +/*
> + * Send a mailbox command to the hardware, and either wait for a completion
> + * (EFCT_CMD_POLL) or get an optional asynchronous completion (EFCT_CMD_NOWAIT).
> + */
> +enum efct_hw_rtn
> +efct_hw_command(struct efct_hw *hw, u8 *cmd, u32 opts, void *cb, void *arg)
> +{
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
> +	unsigned long flags = 0;
> +	void *bmbx = NULL;
> +
> +	/*
> +	 * If the chip is in an error state (UE'd) then reject this mailbox
> +	 *  command.
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
> +	if (opts == EFCT_CMD_POLL) {
> +		spin_lock_irqsave(&hw->cmd_lock, flags);
> +		bmbx = hw->sli.bmbx.virt;
> +
> +		memset(bmbx, 0, SLI4_BMBX_SIZE);
> +		memcpy(bmbx, cmd, SLI4_BMBX_SIZE);
> +
> +		if (sli_bmbx_command(&hw->sli) == 0) {
> +			rc = EFCT_HW_RTN_SUCCESS;
> +			memcpy(cmd, bmbx, SLI4_BMBX_SIZE);
> +		}
> +		spin_unlock_irqrestore(&hw->cmd_lock, flags);
> +	} else if (opts == EFCT_CMD_NOWAIT) {
> +		struct efct_command_ctx	*ctx = NULL;
> +
> +		ctx = kmalloc(sizeof(*ctx), GFP_ATOMIC);

GPF_KERNEL

> +		if (!ctx)
> +			return EFCT_HW_RTN_NO_RESOURCES;
> +
> +		memset(ctx, 0, sizeof(struct efct_command_ctx));

kzalloc

> +
> +		if (hw->state != EFCT_HW_STATE_ACTIVE) {
> +			efc_log_err(hw->os,
> +				     "Can't send command, HW state=%d\n",
> +				    hw->state);
> +			kfree(ctx);
> +			return EFCT_HW_RTN_ERROR;
> +		}
> +
> +		if (cb) {
> +			ctx->cb = cb;
> +			ctx->arg = arg;
> +		}
> +		ctx->buf = cmd;
> +		ctx->ctx = hw;
> +
> +		spin_lock_irqsave(&hw->cmd_lock, flags);
> +
> +			/* Add to pending list */
> +			INIT_LIST_HEAD(&ctx->list_entry);
> +			list_add_tail(&ctx->list_entry, &hw->cmd_pending);
> +
> +			/* Submit as much of the pending list as we can */
> +			if (efct_hw_cmd_submit_pending(hw) == 0)
> +				rc = EFCT_HW_RTN_SUCCESS;
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
> +		list_del(&ctx->list_entry);
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
> +		if (ctx->buf)
> +			memcpy(ctx->buf, mqe, size);
> +
> +		ctx->cb(hw, status, ctx->buf, ctx->arg);
> +	}
> +
> +	memset(ctx, 0, sizeof(struct efct_command_ctx));

memset is no needed before kfree

> +	kfree(ctx);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +static int
> +efct_hw_mq_process(struct efct_hw *hw,
> +		   int status, struct sli4_queue *mq)
> +{
> +	u8		mqe[SLI4_BMBX_SIZE];
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

		struct eftc_command_ctx *ctx;

		ctx = list_first_entry(&hw->cmd_head,
				       struct efct_command_ctx,
				       list_entry);


> +
> +		efc_log_test(hw->os, "hung command %08x\n",
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
> diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
> index e5839254c730..1b67e0721936 100644
> --- a/drivers/scsi/elx/efct/efct_hw.h
> +++ b/drivers/scsi/elx/efct/efct_hw.h
> @@ -629,4 +629,11 @@ efct_get_wwnn(struct efct_hw *hw);
>  extern uint64_t
>  efct_get_wwpn(struct efct_hw *hw);
>  
> +enum efct_hw_rtn efct_hw_rx_allocate(struct efct_hw *hw);
> +enum efct_hw_rtn efct_hw_rx_post(struct efct_hw *hw);
> +void efct_hw_rx_free(struct efct_hw *hw);
> +extern enum efct_hw_rtn
> +efct_hw_command(struct efct_hw *hw, u8 *cmd, u32 opts, void *cb,
> +		void *arg);
> +
>  #endif /* __EFCT_H__ */
> -- 
> 2.16.4
> 

Thanks,
Daniel

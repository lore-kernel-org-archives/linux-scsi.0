Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA90DC2BA2B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 07:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC840206D5
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 07:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438733AbgDPHYf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 03:24:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:55556 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438711AbgDPHYc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 03:24:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 71F5EAD08;
        Thu, 16 Apr 2020 07:24:28 +0000 (UTC)
Subject: Re: [PATCH v3 18/31] elx: efct: RQ buffer, memory pool allocation and
 deallocation APIs
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-19-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f9aa3ecc-5d59-e3ce-57d7-f7aceb460679@suse.de>
Date:   Thu, 16 Apr 2020 09:24:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200412033303.29574-19-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/20 5:32 AM, James Smart wrote:
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
>    efct_utils.c file is removed. Replaced efct_pool, efct_varray and
>    efct_array with other alternatives.
> ---
>   drivers/scsi/elx/efct/efct_hw.c | 375 ++++++++++++++++++++++++++++++++++++++++
>   drivers/scsi/elx/efct/efct_hw.h |   7 +
>   2 files changed, 382 insertions(+)
> 
> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
> index 21fcaf7b3d2b..3e9906749da2 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -1114,3 +1114,378 @@ efct_get_wwpn(struct efct_hw *hw)
>   	memcpy(p, sli->wwpn, sizeof(p));
>   	return get_unaligned_be64(p);
>   }
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
> +		rq_buf = kmalloc_array(count, sizeof(*rq_buf), GFP_ATOMIC);
> +		if (!rq_buf)
> +			return NULL;
> +		memset(rq_buf, 0, sizeof(*rq_buf) * count);
> +
> +		for (i = 0, prq = rq_buf; i < count; i ++, prq++) {
> +			prq->rqindex = rqindex;
> +			prq->dma.size = size;
> +			prq->dma.virt = dma_alloc_coherent(&efct->pcidev->dev,
> +							   prq->dma.size,
> +							   &prq->dma.phys,
> +							   GFP_DMA);
> +			if (!prq->dma.virt) {
> +				efc_log_err(hw->os, "DMA allocation failed\n");
> +				kfree(rq_buf);
> +				rq_buf = NULL;
> +				break;
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
> +
> +	/* Assumes lock held */
> +

So make it a regular lockdep annotation then.

> +	/* Only submit MQE if there's room */
> +	while (hw->cmd_head_count < (EFCT_HW_MQ_DEPTH - 1) &&
> +	       !list_empty(&hw->cmd_pending))  > +		ctx = list_first_entry(&hw->cmd_pending,
> +				       struct efct_command_ctx, list_entry);
> +		if (!ctx)
> +			break;
> +

Seeing that you always check for !ctx you might as well drop the 
'!list_empty' condition from the while() statement.

> +		list_del(&ctx->list_entry);
> +

And it might even be better to use 'list_for_each_entry_safe()' here

> +		INIT_LIST_HEAD(&ctx->list_entry);
> +		list_add_tail(&ctx->list_entry, &hw->cmd_head);
> +		hw->cmd_head_count++;
> +		if (sli_mq_write(&hw->sli, hw->mq, ctx->buf) < 0) {
> +			efc_log_test(hw->os,
> +				      "sli_queue_write failed: %d\n", rc);
> +			rc = -1;
> +			break;
> +		}

and break here for the 'cmd_head_count' condition.

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

See? You even _have_ a preallocated mailbox.
So you could use that to facilitate the loop topology detection I've 
commented on in an earlier patch.

> +	} else if (opts == EFCT_CMD_NOWAIT) {
> +		struct efct_command_ctx	*ctx = NULL;
> +
> +		ctx = kmalloc(sizeof(*ctx), GFP_ATOMIC);
> +		if (!ctx)
> +			return EFCT_HW_RTN_NO_RESOURCES;
> +
> +		memset(ctx, 0, sizeof(struct efct_command_ctx));
> +

But now you go and spoil it all again.
At the very least use a mempool here; not sure how frequent these calls 
are, but we're talking to the hardware here, so I assume it'll happen 
more than just once.

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

Indentation?

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
> +	kfree(ctx);
> +
memset() before kfree() is pointless.
Use KASAN et al if you suspect memory issues.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F936C32771
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 10:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E45BB2072E
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 10:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgAIKOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 05:14:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:46276 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728588AbgAIKOy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Jan 2020 05:14:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7C24769C1F;
        Thu,  9 Jan 2020 10:14:49 +0000 (UTC)
Subject: Re: [PATCH v2 27/32] elx: efct: xport and hardware teardown routines
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-28-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <79540c3b-ead7-792f-b2d7-b33fd587548f@suse.de>
Date:   Thu, 9 Jan 2020 11:14:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-28-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/20/19 11:37 PM, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Routines to detach xport and hardware objects.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/efct/efct_hw.c    | 437 +++++++++++++++++++++++++++++++++++++
>  drivers/scsi/elx/efct/efct_hw.h    |  31 +++
>  drivers/scsi/elx/efct/efct_xport.c | 389 +++++++++++++++++++++++++++++++++
>  3 files changed, 857 insertions(+)
> 
> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
> index 33eefda7ba51..fb33317caa0d 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -4483,3 +4483,440 @@ efct_hw_get_host_stats(struct efct_hw *hw, u8 cc,
>  
>  	return rc;
>  }
> +
> +static int
> +efct_hw_cb_port_control(struct efct_hw *hw, int status, u8 *mqe,
> +			void  *arg)
> +{
> +	kfree(mqe);
> +	return 0;
> +}
> +
> +/* Control a port (initialize, shutdown, or set link configuration) */
> +enum efct_hw_rtn
> +efct_hw_port_control(struct efct_hw *hw, enum efct_hw_port ctrl,
> +		     uintptr_t value,
> +		void (*cb)(int status, uintptr_t value, void *arg),
> +		void *arg)
> +{
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
> +
> +	switch (ctrl) {
> +	case EFCT_HW_PORT_INIT:
> +	{
> +		u8	*init_link;
> +		u32 speed = 0;
> +		u8 reset_alpa = 0;
> +
> +		u8	*cfg_link;
> +
> +		cfg_link = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +		if (!cfg_link)
> +			return EFCT_HW_RTN_NO_MEMORY;
> +
> +		if (!sli_cmd_config_link(&hw->sli, cfg_link,
> +					SLI4_BMBX_SIZE))
> +			rc = efct_hw_command(hw, cfg_link,
> +					     EFCT_CMD_NOWAIT,
> +					     efct_hw_cb_port_control,
> +					     NULL);
> +
> +		if (rc != EFCT_HW_RTN_SUCCESS) {
> +			kfree(cfg_link);
> +			efc_log_err(hw->os, "CONFIG_LINK failed\n");
> +			break;
> +		}
> +		speed = hw->config.speed;
> +		reset_alpa = (u8)(value & 0xff);
> +
> +		/* Allocate a new buffer for the init_link command */
> +		init_link = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +		if (!init_link)
> +			return EFCT_HW_RTN_NO_MEMORY;
> +
> +		rc = EFCT_HW_RTN_ERROR;
> +		if (!sli_cmd_init_link(&hw->sli, init_link, SLI4_BMBX_SIZE,
> +				      speed, reset_alpa))
> +			rc = efct_hw_command(hw, init_link, EFCT_CMD_NOWAIT,
> +					     efct_hw_cb_port_control, NULL);
> +		/* Free buffer on error, since no callback is coming */
> +		if (rc != EFCT_HW_RTN_SUCCESS) {
> +			kfree(init_link);
> +			efc_log_err(hw->os, "INIT_LINK failed\n");
> +		}
> +		break;
> +	}
> +	case EFCT_HW_PORT_SHUTDOWN:
> +	{
> +		u8	*down_link;
> +
> +		down_link = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +		if (!down_link)
> +			return EFCT_HW_RTN_NO_MEMORY;
> +
> +		if (!sli_cmd_down_link(&hw->sli, down_link, SLI4_BMBX_SIZE))
> +			rc = efct_hw_command(hw, down_link, EFCT_CMD_NOWAIT,
> +					     efct_hw_cb_port_control, NULL);
> +		/* Free buffer on error, since no callback is coming */
> +		if (rc != EFCT_HW_RTN_SUCCESS) {
> +			kfree(down_link);
> +			efc_log_err(hw->os, "DOWN_LINK failed\n");
> +		}
> +		break;
> +	}
> +	default:
> +		efc_log_test(hw->os, "unhandled control %#x\n", ctrl);
> +		break;
> +	}
> +
> +	return rc;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_teardown(struct efct_hw *hw)
> +{
> +	u32	i = 0;
> +	u32	iters = 10;
> +	u32	max_rpi;
> +	u32 destroy_queues;
> +	u32 free_memory;
> +	struct efc_dma *dma;
> +	struct efct *efct = hw->os;
> +
> +	destroy_queues = (hw->state == EFCT_HW_STATE_ACTIVE);
> +	free_memory = (hw->state != EFCT_HW_STATE_UNINITIALIZED);
> +
> +	/* shutdown target wqe timer */
> +	shutdown_target_wqe_timer(hw);
> +
> +	/* Cancel watchdog timer if enabled */
> +	if (hw->watchdog_timeout) {
> +		hw->watchdog_timeout = 0;
> +		efct_hw_config_watchdog_timer(hw);
> +	}
> +
> +	/* Cancel Sliport Healthcheck */
> +	if (hw->sliport_healthcheck) {
> +		hw->sliport_healthcheck = 0;
> +		efct_hw_config_sli_port_health_check(hw, 0, 0);
> +	}
> +
> +	if (hw->state != EFCT_HW_STATE_QUEUES_ALLOCATED) {
> +		hw->state = EFCT_HW_STATE_TEARDOWN_IN_PROGRESS;
> +
> +		efct_hw_flush(hw);
> +
> +		/*
> +		 * If there are outstanding commands, wait for them to complete
> +		 */
> +		while (!list_empty(&hw->cmd_head) && iters) {
> +			mdelay(10);
> +			efct_hw_flush(hw);
> +			iters--;
> +		}
> +
> +		if (list_empty(&hw->cmd_head))
> +			efc_log_debug(hw->os,
> +				       "All commands completed on MQ queue\n");
> +		else
> +			efc_log_debug(hw->os,
> +				       "Some cmds still pending on MQ queue\n");
> +
> +		/* Cancel any remaining commands */
> +		efct_hw_command_cancel(hw);
> +	} else {
> +		hw->state = EFCT_HW_STATE_TEARDOWN_IN_PROGRESS;
> +	}
> +
> +	max_rpi = hw->sli.qinfo.max_qcount[SLI_RSRC_RPI];
> +	if (hw->rpi_ref) {
> +		for (i = 0; i < max_rpi; i++) {
> +			u32 count;
> +
> +			count = atomic_read(&hw->rpi_ref[i].rpi_count);
> +			if (count)
> +				efc_log_debug(hw->os,
> +					       "non-zero ref [%d]=%d\n",
> +					       i, count);
> +		}
> +		kfree(hw->rpi_ref);
> +		hw->rpi_ref = NULL;
> +	}
> +
> +	dma_free_coherent(&efct->pcidev->dev,
> +			  hw->rnode_mem.size, hw->rnode_mem.virt,
> +			  hw->rnode_mem.phys);
> +	memset(&hw->rnode_mem, 0, sizeof(struct efc_dma));
> +
> +	if (hw->io) {
> +		for (i = 0; i < hw->config.n_io; i++) {
> +			if (hw->io[i] && hw->io[i]->sgl &&
> +			    hw->io[i]->sgl->virt) {
> +				dma_free_coherent(&efct->pcidev->dev,
> +						  hw->io[i]->sgl->size,
> +						  hw->io[i]->sgl->virt,
> +						  hw->io[i]->sgl->phys);
> +				memset(&hw->io[i]->sgl, 0,
> +				       sizeof(struct efc_dma));
> +			}
> +			kfree(hw->io[i]);
> +			hw->io[i] = NULL;
> +		}
> +		kfree(hw->io);
> +		hw->io = NULL;
> +		kfree(hw->wqe_buffs);
> +		hw->wqe_buffs = NULL;
> +	}
> +
> +	dma = &hw->xfer_rdy;
> +	dma_free_coherent(&efct->pcidev->dev,
> +			  dma->size, dma->virt, dma->phys);
> +	memset(dma, 0, sizeof(struct efc_dma));
> +
> +	dma = &hw->dump_sges;
> +	dma_free_coherent(&efct->pcidev->dev,
> +			  dma->size, dma->virt, dma->phys);
> +	memset(dma, 0, sizeof(struct efc_dma));
> +
> +	dma = &hw->loop_map;
> +	dma_free_coherent(&efct->pcidev->dev,
> +			  dma->size, dma->virt, dma->phys);
> +	memset(dma, 0, sizeof(struct efc_dma));
> +
> +	for (i = 0; i < hw->wq_count; i++)
> +		sli_queue_free(&hw->sli, &hw->wq[i], destroy_queues,
> +			       free_memory);
> +
> +	for (i = 0; i < hw->rq_count; i++)
> +		sli_queue_free(&hw->sli, &hw->rq[i], destroy_queues,
> +			       free_memory);
> +
> +	for (i = 0; i < hw->mq_count; i++)
> +		sli_queue_free(&hw->sli, &hw->mq[i], destroy_queues,
> +			       free_memory);
> +
> +	for (i = 0; i < hw->cq_count; i++)
> +		sli_queue_free(&hw->sli, &hw->cq[i], destroy_queues,
> +			       free_memory);
> +
> +	for (i = 0; i < hw->eq_count; i++)
> +		sli_queue_free(&hw->sli, &hw->eq[i], destroy_queues,
> +			       free_memory);
> +
> +	efct_hw_qtop_free(hw->qtop);
> +
> +	/* Free rq buffers */
> +	efct_hw_rx_free(hw);
> +
> +	efct_hw_queue_teardown(hw);
> +
> +	if (sli_teardown(&hw->sli))
> +		efc_log_err(hw->os, "SLI teardown failed\n");
> +
> +	/* record the fact that the queues are non-functional */
> +	hw->state = EFCT_HW_STATE_UNINITIALIZED;
> +
> +	/* free sequence free pool */
> +	efct_array_free(hw->seq_pool);
> +	hw->seq_pool = NULL;
> +
> +	/* free hw_wq_callback pool */
> +	efct_pool_free(hw->wq_reqtag_pool);
> +
> +	/* Mark HW setup as not having been called */
> +	hw->hw_setup_called = false;
> +
> +	return EFCT_HW_RTN_SUCCESS;
> +}
> +
> +static enum efct_hw_rtn
> +efct_hw_sli_reset(struct efct_hw *hw, enum efct_hw_reset reset,
> +		  enum efct_hw_state prev_state)
> +{
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +
> +	switch (reset) {
> +	case EFCT_HW_RESET_FUNCTION:
> +		efc_log_debug(hw->os, "issuing function level reset\n");
> +		if (sli_reset(&hw->sli)) {
> +			efc_log_err(hw->os, "sli_reset failed\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +		break;
> +	case EFCT_HW_RESET_FIRMWARE:
> +		efc_log_debug(hw->os, "issuing firmware reset\n");
> +		if (sli_fw_reset(&hw->sli)) {
> +			efc_log_err(hw->os, "sli_soft_reset failed\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +		/*
> +		 * Because the FW reset leaves the FW in a non-running state,
> +		 * follow that with a regular reset.
> +		 */
> +		efc_log_debug(hw->os, "issuing function level reset\n");
> +		if (sli_reset(&hw->sli)) {
> +			efc_log_err(hw->os, "sli_reset failed\n");
> +			rc = EFCT_HW_RTN_ERROR;
> +		}
> +		break;
> +	default:
> +		efc_log_err(hw->os,
> +			     "unknown reset type - no reset performed\n");
> +		hw->state = prev_state;
> +		rc = EFCT_HW_RTN_INVALID_ARG;
> +		break;
> +	}
> +
> +	return rc;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_reset(struct efct_hw *hw, enum efct_hw_reset reset)
> +{
> +	u32	i;
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +	u32	iters;
> +	enum efct_hw_state prev_state = hw->state;
> +	unsigned long flags = 0;
> +	struct efct_hw_io *temp;
> +	u32 destroy_queues;
> +	u32 free_memory;
> +
> +	if (hw->state != EFCT_HW_STATE_ACTIVE)
> +		efc_log_test(hw->os,
> +			      "HW state %d is not active\n", hw->state);
> +
> +	destroy_queues = (hw->state == EFCT_HW_STATE_ACTIVE);
> +	free_memory = (hw->state != EFCT_HW_STATE_UNINITIALIZED);
> +	hw->state = EFCT_HW_STATE_RESET_IN_PROGRESS;
> +
> +	/*
> +	 * If the prev_state is already reset/teardown in progress,
> +	 * don't continue further
> +	 */
> +	if (prev_state == EFCT_HW_STATE_RESET_IN_PROGRESS ||
> +	    prev_state == EFCT_HW_STATE_TEARDOWN_IN_PROGRESS)
> +		return efct_hw_sli_reset(hw, reset, prev_state);
> +
> +	/* shutdown target wqe timer */
> +	shutdown_target_wqe_timer(hw);
> +
> +	if (prev_state != EFCT_HW_STATE_UNINITIALIZED) {
> +		efct_hw_flush(hw);
> +
> +		/*
> +		 * If an mailbox command requiring a DMA is outstanding
> +		 * (SFP/DDM), then the FW will UE when the reset is issued.
> +		 * So attempt to complete all mailbox commands.
> +		 */
> +		iters = 10;
> +		while (!list_empty(&hw->cmd_head) && iters) {
> +			mdelay(10);
> +			efct_hw_flush(hw);
> +			iters--;
> +		}
> +
> +		if (list_empty(&hw->cmd_head))
> +			efc_log_debug(hw->os,
> +				       "All commands completed on MQ queue\n");
> +		else
> +			efc_log_debug(hw->os,
> +				       "Some commands still pending on MQ queue\n");
> +	}
> +
> +	/* Reset the chip */
> +	rc = efct_hw_sli_reset(hw, reset, prev_state);
> +	if (rc == EFCT_HW_RTN_INVALID_ARG)
> +		return EFCT_HW_RTN_ERROR;
> +
> +	/* Not safe to walk command/io lists unless they've been initialized */
> +	if (prev_state != EFCT_HW_STATE_UNINITIALIZED) {
> +		efct_hw_command_cancel(hw);
> +
> +		/* Try to clean up the io_inuse list */
> +		efct_hw_io_cancel(hw);
> +
> +		efct_hw_link_event_init(hw);
> +
> +		spin_lock_irqsave(&hw->io_lock, flags);
> +			/*
> +			 * The io lists should be empty, but remove any that
> +			 * didn't get cleaned up.
> +			 */
> +			while (!list_empty(&hw->io_timed_wqe)) {
> +				temp = list_first_entry(&hw->io_timed_wqe,
> +							struct efct_hw_io,
> +							list_entry);
> +				list_del(&temp->wqe_link);
> +			}
> +
> +			while (!list_empty(&hw->io_free)) {
> +				temp = list_first_entry(&hw->io_free,
> +							struct efct_hw_io,
> +							list_entry);
> +				list_del(&temp->list_entry);
> +			}
> +
> +			while (!list_empty(&hw->io_wait_free)) {
> +				temp = list_first_entry(&hw->io_wait_free,
> +							struct efct_hw_io,
> +							list_entry);
> +				list_del(&temp->list_entry);
> +			}
> +		spin_unlock_irqrestore(&hw->io_lock, flags);
> +
> +		for (i = 0; i < hw->wq_count; i++)
> +			sli_queue_free(&hw->sli, &hw->wq[i],
> +				       destroy_queues, free_memory);
> +
> +		for (i = 0; i < hw->rq_count; i++)
> +			sli_queue_free(&hw->sli, &hw->rq[i],
> +				       destroy_queues, free_memory);
> +
> +		for (i = 0; i < hw->hw_rq_count; i++) {
> +			struct hw_rq *rq = hw->hw_rq[i];
> +
> +			if (rq->rq_tracker) {
> +				u32 j;
> +
> +				for (j = 0; j < rq->entry_count; j++)
> +					rq->rq_tracker[j] = NULL;
> +			}
> +		}
> +
> +		for (i = 0; i < hw->mq_count; i++)
> +			sli_queue_free(&hw->sli, &hw->mq[i],
> +				       destroy_queues, free_memory);
> +
> +		for (i = 0; i < hw->cq_count; i++)
> +			sli_queue_free(&hw->sli, &hw->cq[i],
> +				       destroy_queues, free_memory);
> +
> +		for (i = 0; i < hw->eq_count; i++)
> +			sli_queue_free(&hw->sli, &hw->eq[i],
> +				       destroy_queues, free_memory);
> +
> +		/* Free rq buffers */
> +		efct_hw_rx_free(hw);
> +
> +		/* Teardown the HW queue topology */
> +		efct_hw_queue_teardown(hw);
> +
> +		/*
> +		 * Reset the request tag pool, the HW IO request tags
> +		 * are reassigned in efct_hw_setup_io()
> +		 */
> +		efct_hw_reqtag_reset(hw);
> +	} else {
> +		/* Free rq buffers */
> +		efct_hw_rx_free(hw);
> +	}
> +
> +	return rc;
> +}
> +
> +int
> +efct_hw_get_num_eq(struct efct_hw *hw)
> +{
> +	return hw->eq_count;
> +}
> diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
> index 278f241e8705..862504b96a23 100644
> --- a/drivers/scsi/elx/efct/efct_hw.h
> +++ b/drivers/scsi/elx/efct/efct_hw.h
> @@ -1009,5 +1009,36 @@ efct_hw_get_host_stats(struct efct_hw *hw,
>  			void *arg),
>  		void *arg);
>  
> +struct hw_eq *efct_hw_new_eq(struct efct_hw *hw, u32 entry_count);
> +struct hw_cq *efct_hw_new_cq(struct hw_eq *eq, u32 entry_count);
> +extern u32
> +efct_hw_new_cq_set(struct hw_eq *eqs[], struct hw_cq *cqs[],
> +		   u32 num_cqs, u32 entry_count);
> +struct hw_mq *efct_hw_new_mq(struct hw_cq *cq, u32 entry_count);
> +extern struct hw_wq
> +*efct_hw_new_wq(struct hw_cq *cq, u32 entry_count,
> +		u32 class, u32 ulp);
> +extern struct hw_rq
> +*efct_hw_new_rq(struct hw_cq *cq, u32 entry_count, u32 ulp);
> +extern u32
> +efct_hw_new_rq_set(struct hw_cq *cqs[], struct hw_rq *rqs[],
> +		   u32 num_rq_pairs, u32 entry_count);
> +void efct_hw_del_eq(struct hw_eq *eq);
> +void efct_hw_del_cq(struct hw_cq *cq);
> +void efct_hw_del_mq(struct hw_mq *mq);
> +void efct_hw_del_wq(struct hw_wq *wq);
> +void efct_hw_del_rq(struct hw_rq *rq);
> +void efct_hw_queue_dump(struct efct_hw *hw);
> +void efct_hw_queue_teardown(struct efct_hw *hw);
> +enum efct_hw_rtn efct_hw_teardown(struct efct_hw *hw);
> +enum efct_hw_rtn
> +efct_hw_reset(struct efct_hw *hw, enum efct_hw_reset reset);
> +int efct_hw_get_num_eq(struct efct_hw *hw);
> +
> +extern enum efct_hw_rtn
> +efct_hw_port_control(struct efct_hw *hw, enum efct_hw_port ctrl,
> +		     uintptr_t value,
> +		void (*cb)(int status, uintptr_t value, void *arg),
> +		void *arg);
>  
>  #endif /* __EFCT_H__ */
> diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
> index e6d6f2000168..6d8e0cefa903 100644
> --- a/drivers/scsi/elx/efct/efct_xport.c
> +++ b/drivers/scsi/elx/efct/efct_xport.c
> @@ -146,6 +146,80 @@ efct_xport_attach(struct efct_xport *xport)
>  }
>  
>  static void
> +efct_xport_link_stats_cb(int status, u32 num_counters,
> +			 struct efct_hw_link_stat_counts *counters, void *arg)
> +{
> +	union efct_xport_stats_u *result = arg;
> +
> +	result->stats.link_stats.link_failure_error_count =
> +		counters[EFCT_HW_LINK_STAT_LINK_FAILURE_COUNT].counter;
> +	result->stats.link_stats.loss_of_sync_error_count =
> +		counters[EFCT_HW_LINK_STAT_LOSS_OF_SYNC_COUNT].counter;
> +	result->stats.link_stats.primitive_sequence_error_count =
> +		counters[EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_COUNT].counter;
> +	result->stats.link_stats.invalid_transmission_word_error_count =
> +		counters[EFCT_HW_LINK_STAT_INVALID_XMIT_WORD_COUNT].counter;
> +	result->stats.link_stats.crc_error_count =
> +		counters[EFCT_HW_LINK_STAT_CRC_COUNT].counter;
> +
> +	complete(&result->stats.done);
> +}
> +
> +static void
> +efct_xport_host_stats_cb(int status, u32 num_counters,
> +			 struct efct_hw_host_stat_counts *counters, void *arg)
> +{
> +	union efct_xport_stats_u *result = arg;
> +
> +	result->stats.host_stats.transmit_kbyte_count =
> +		counters[EFCT_HW_HOST_STAT_TX_KBYTE_COUNT].counter;
> +	result->stats.host_stats.receive_kbyte_count =
> +		counters[EFCT_HW_HOST_STAT_RX_KBYTE_COUNT].counter;
> +	result->stats.host_stats.transmit_frame_count =
> +		counters[EFCT_HW_HOST_STAT_TX_FRAME_COUNT].counter;
> +	result->stats.host_stats.receive_frame_count =
> +		counters[EFCT_HW_HOST_STAT_RX_FRAME_COUNT].counter;
> +
> +	complete(&result->stats.done);
> +}
> +
> +static void
> +efct_xport_async_link_stats_cb(int status, u32 num_counters,
> +			       struct efct_hw_link_stat_counts *counters,
> +			       void *arg)
> +{
> +	union efct_xport_stats_u *result = arg;
> +
> +	result->stats.link_stats.link_failure_error_count =
> +		counters[EFCT_HW_LINK_STAT_LINK_FAILURE_COUNT].counter;
> +	result->stats.link_stats.loss_of_sync_error_count =
> +		counters[EFCT_HW_LINK_STAT_LOSS_OF_SYNC_COUNT].counter;
> +	result->stats.link_stats.primitive_sequence_error_count =
> +		counters[EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_COUNT].counter;
> +	result->stats.link_stats.invalid_transmission_word_error_count =
> +		counters[EFCT_HW_LINK_STAT_INVALID_XMIT_WORD_COUNT].counter;
> +	result->stats.link_stats.crc_error_count =
> +		counters[EFCT_HW_LINK_STAT_CRC_COUNT].counter;
> +}
> +
> +static void
> +efct_xport_async_host_stats_cb(int status, u32 num_counters,
> +			       struct efct_hw_host_stat_counts *counters,
> +			       void *arg)
> +{
> +	union efct_xport_stats_u *result = arg;
> +
> +	result->stats.host_stats.transmit_kbyte_count =
> +		counters[EFCT_HW_HOST_STAT_TX_KBYTE_COUNT].counter;
> +	result->stats.host_stats.receive_kbyte_count =
> +		counters[EFCT_HW_HOST_STAT_RX_KBYTE_COUNT].counter;
> +	result->stats.host_stats.transmit_frame_count =
> +		counters[EFCT_HW_HOST_STAT_TX_FRAME_COUNT].counter;
> +	result->stats.host_stats.receive_frame_count =
> +		counters[EFCT_HW_HOST_STAT_RX_FRAME_COUNT].counter;
> +}
> +
> +static void
>  efct_xport_config_stats_timer(struct efct *efct);
>  
>  static void
> @@ -585,3 +659,318 @@ efct_scsi_release_fc_transport(void)
>  
>  	return 0;
>  }
> +
> +int
> +efct_xport_detach(struct efct_xport *xport)
> +{
> +	struct efct *efct = xport->efct;
> +
> +	/* free resources associated with target-server and initiator-client */
> +	efct_scsi_tgt_del_device(efct);
> +
> +	efct_scsi_del_device(efct);
> +
> +	/*Shutdown FC Statistics timer*/
> +	del_timer(&efct->xport->stats_timer);
> +
> +	efct_hw_teardown(&efct->hw);
> +
> +	efct_xport_delete_debugfs(efct);
> +
> +	return 0;
> +}
> +
> +static void
> +efct_xport_domain_free_cb(struct efc *efc, void *arg)
> +{
> +	struct completion *done = arg;
> +
> +	complete(done);
> +}
> +
> +static int
> +efct_xport_post_node_event_cb(struct efct_hw *hw, int status,
> +			      u8 *mqe, void *arg)
> +{
> +	struct efct_xport_post_node_event *payload = arg;
> +
> +	if (payload) {
> +		efc_node_post_shutdown(payload->node, payload->evt,
> +				       payload->context);
> +		complete(&payload->done);
> +		if (atomic_sub_and_test(1, &payload->refcnt))
> +			kfree(payload);
> +	}
> +	return 0;
> +}
> +
> +static void
> +efct_xport_force_free(struct efct_xport *xport)
> +{
> +	struct efct *efct = xport->efct;
> +	struct efc *efc = efct->efcport;
> +
> +	efc_log_debug(efct, "reset required, do force shutdown\n");
> +
> +	if (!efc->domain) {
> +		efc_log_err(efct, "Domain is already freed\n");
> +		return;
> +	}
> +
> +	efc_domain_force_free(efc->domain);
> +}
> +
> +int
> +efct_xport_control(struct efct_xport *xport, enum efct_xport_ctrl cmd, ...)
> +{
> +	u32 rc = 0;
> +	struct efct *efct = NULL;
> +	va_list argp;
> +
> +	efct = xport->efct;
> +
> +	switch (cmd) {
> +	case EFCT_XPORT_PORT_ONLINE: {
> +		/* Bring the port on-line */
> +		rc = efct_hw_port_control(&efct->hw, EFCT_HW_PORT_INIT, 0,
> +					  NULL, NULL);
> +		if (rc)
> +			efc_log_err(efct,
> +				     "%s: Can't init port\n", efct->desc);
> +		else
> +			xport->configured_link_state = cmd;
> +		break;
> +	}
> +	case EFCT_XPORT_PORT_OFFLINE: {
> +		if (efct_hw_port_control(&efct->hw, EFCT_HW_PORT_SHUTDOWN, 0,
> +					 NULL, NULL))
> +			efc_log_err(efct, "port shutdown failed\n");
> +		else
> +			xport->configured_link_state = cmd;
> +		break;
> +	}
> +
> +	case EFCT_XPORT_SHUTDOWN: {
> +		struct completion done;
> +		u32 reset_required;
> +		unsigned long timeout;
> +
> +		/* if a PHYSDEV reset was performed (e.g. hw dump), will affect
> +		 * all PCI functions; orderly shutdown won't work,
> +		 * just force free
> +		 */
> +		if (efct_hw_get(&efct->hw, EFCT_HW_RESET_REQUIRED,
> +				&reset_required) != EFCT_HW_RTN_SUCCESS)
> +			reset_required = 0;
> +
> +		if (reset_required) {
> +			efc_log_debug(efct,
> +				       "reset required, do force shutdown\n");
> +			efct_xport_force_free(xport);
> +			break;
> +		}
> +		init_completion(&done);
> +
> +		efc_register_domain_free_cb(efct->efcport,
> +					efct_xport_domain_free_cb, &done);
> +
> +		if (efct_hw_port_control(&efct->hw, EFCT_HW_PORT_SHUTDOWN, 0,
> +					 NULL, NULL)) {
> +			efc_log_debug(efct,
> +				       "port shutdown failed, do force shutdown\n");
> +			efct_xport_force_free(xport);
> +		} else {
> +			efc_log_debug(efct,
> +				       "Waiting %d seconds for domain shutdown.\n",
> +			(EFCT_FC_DOMAIN_SHUTDOWN_TIMEOUT_USEC / 1000000));
> +
> +			timeout = usecs_to_jiffies(
> +					EFCT_FC_DOMAIN_SHUTDOWN_TIMEOUT_USEC);
> +			if (!wait_for_completion_timeout(&done, timeout)) {
> +				efc_log_debug(efct,
> +					       "Domain shutdown timed out!!\n");
> +				efct_xport_force_free(xport);
> +			}
> +		}
> +
> +		efc_register_domain_free_cb(efct->efcport, NULL, NULL);
> +
> +		/* Free up any saved virtual ports */
> +		efc_vport_del_all(efct->efcport);
> +		break;
> +	}
> +
> +	/*
> +	 * POST_NODE_EVENT:  post an event to a node object
> +	 *
> +	 * This transport function is used to post an event to a node object.
> +	 * It does this by submitting a NOP mailbox command to defer execution
> +	 * to the interrupt context (thereby enforcing the serialized execution
> +	 * of event posting to the node state machine instances)
> +	 */
> +	case EFCT_XPORT_POST_NODE_EVENT: {
> +		struct efc_node *node;
> +		u32	evt;
> +		void *context;
> +		struct efct_xport_post_node_event *payload = NULL;
> +		struct efct *efct;
> +		struct efct_hw *hw;
> +
> +		/* Retrieve arguments */
> +		va_start(argp, cmd);
> +		node = va_arg(argp, struct efc_node *);
> +		evt = va_arg(argp, u32);
> +		context = va_arg(argp, void *);
> +		va_end(argp);
> +
> +		payload = kmalloc(sizeof(*payload), GFP_KERNEL);
> +		if (!payload)
> +			return -1;
> +
> +		memset(payload, 0, sizeof(*payload));
> +
> +		efct = node->efc->base;
> +		hw = &efct->hw;
> +
> +		/* if node's state machine is disabled,
> +		 * don't bother continuing
> +		 */
> +		if (!node->sm.current_state) {
> +			efc_log_test(efct, "node %p state machine disabled\n",
> +				      node);
> +			kfree(payload);
> +			rc = -1;
> +			break;
> +		}
> +
> +		/* Setup payload */
> +		init_completion(&payload->done);
> +
> +		/* one for self and one for callback */
> +		atomic_set(&payload->refcnt, 2);
> +		payload->node = node;
> +		payload->evt = evt;
> +		payload->context = context;
> +
> +		if (efct_hw_async_call(hw, efct_xport_post_node_event_cb,
> +				       payload)) {
> +			efc_log_test(efct, "efct_hw_async_call failed\n");
> +			kfree(payload);
> +			rc = -1;
> +			break;
> +		}
> +
> +		/* Wait for completion */
> +		if (wait_for_completion_interruptible(&payload->done)) {
> +			efc_log_test(efct,
> +				      "POST_NODE_EVENT: completion failed\n");
> +			rc = -1;
> +		}
> +		if (atomic_sub_and_test(1, &payload->refcnt))
> +			kfree(payload);
> +
> +		break;
> +	}
> +	/*
> +	 * Set wwnn for the port. This will be used instead of the default
> +	 * provided by FW.
> +	 */
> +	case EFCT_XPORT_WWNN_SET: {
> +		u64 wwnn;
> +
> +		/* Retrieve arguments */
> +		va_start(argp, cmd);
> +		wwnn = va_arg(argp, uint64_t);
> +		va_end(argp);
> +
> +		efc_log_debug(efct, " WWNN %016llx\n", wwnn);
> +		xport->req_wwnn = wwnn;
> +
> +		break;
> +	}
> +	/*
> +	 * Set wwpn for the port. This will be used instead of the default
> +	 * provided by FW.
> +	 */
> +	case EFCT_XPORT_WWPN_SET: {
> +		u64 wwpn;
> +
> +		/* Retrieve arguments */
> +		va_start(argp, cmd);
> +		wwpn = va_arg(argp, uint64_t);
> +		va_end(argp);
> +
> +		efc_log_debug(efct, " WWPN %016llx\n", wwpn);
> +		xport->req_wwpn = wwpn;
> +
> +		break;
> +	}
> +
> +	default:
> +		break;
> +	}
> +	return rc;
> +}
> +
> +void
> +efct_xport_free(struct efct_xport *xport)
> +{
> +	if (xport) {
> +		efct_io_pool_free(xport->io_pool);
> +
> +		kfree(xport);
> +	}
> +}
> +
> +void
> +efct_release_fc_transport(struct scsi_transport_template *transport_template)
> +{
> +	if (transport_template)
> +		pr_err("releasing transport layer\n");
> +
> +	/* Releasing FC transport */
> +	fc_release_transport(transport_template);
> +}
> +
> +static void
> +efct_xport_remove_host(struct Scsi_Host *shost)
> +{
> +	/*
> +	 * Remove host from FC Transport layer
> +	 *
> +	 * 1. fc_remove_host()
> +	 * a. for each vport: queue vport_delete_work (fc_vport_sched_delete())
> +	 *	b. for each rport: queue rport_delete_work
> +	 *		(fc_rport_final_delete())
> +	 *	c. scsi_flush_work()
> +	 * 2. fc_rport_final_delete()
> +	 * a. fc_terminate_rport_io
> +	 *		i. call LLDD's terminate_rport_io()
> +	 *		ii. scsi_target_unblock()
> +	 *	b. fc_starget_delete()
> +	 *		i. fc_terminate_rport_io()
> +	 *			1. call LLDD's terminate_rport_io()
> +	 *			2. scsi_target_unblock()
> +	 *		ii. scsi_remove_target()
> +	 *      c. invoke LLDD devloss callback
> +	 *      d. transport_remove_device(&rport->dev)
> +	 *      e. device_del(&rport->dev)
> +	 *      f. transport_destroy_device(&rport->dev)
> +	 *      g. put_device(&shost->shost_gendev) (for fc_host->rport list)
> +	 *      h. put_device(&rport->dev)
> +	 */
> +	fc_remove_host(shost);
> +}
> +

That looks a bit strange.
Citing several steps, but calling only the first.
Please explain.

> +int efct_scsi_del_device(struct efct *efct)
> +{
> +	if (efct->shost) {
> +		efc_log_debug(efct, "Unregistering with Transport Layer\n");
> +		efct_xport_remove_host(efct->shost);
> +		efc_log_debug(efct, "Unregistering with SCSI Midlayer\n");
> +		scsi_remove_host(efct->shost);
> +		scsi_host_put(efct->shost);
> +		efct->shost = NULL;
> +	}
> +	return 0;
> +}
> 

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E9FC2BB85
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 13:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B3BE206B9
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 13:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894700AbgDPNB4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 09:01:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:33778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2894744AbgDPNBy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 09:01:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 31C6CAFB2;
        Thu, 16 Apr 2020 13:01:51 +0000 (UTC)
Date:   Thu, 16 Apr 2020 15:01:50 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v3 27/31] elx: efct: xport and hardware teardown routines
Message-ID: <20200416130150.vfmjlb3nda5lyonv@carbon>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-28-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412033303.29574-28-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Apr 11, 2020 at 08:32:59PM -0700, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Routines to detach xport and hardware objects.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>    Removed old patch 28 and merged with 27
> ---
>  drivers/scsi/elx/efct/efct_hw.c    | 333 +++++++++++++++++++++++++++++++++++++
>  drivers/scsi/elx/efct/efct_hw.h    |  31 ++++
>  drivers/scsi/elx/efct/efct_xport.c | 291 ++++++++++++++++++++++++++++++++
>  3 files changed, 655 insertions(+)
> 
> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
> index ca2fd237c7d6..a007ca98895d 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -3503,3 +3503,336 @@ efct_hw_get_host_stats(struct efct_hw *hw, u8 cc,
>  
>  	return rc;
>  }
> +
> +static int
> +efct_hw_cb_port_control(struct efct_hw *hw, int status, u8 *mqe,
> +			void  *arg)
> +{
> +	kfree(mqe);
> +	return EFC_SUCCESS;
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

GFP_KERNEL

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

GFP_KERNEL

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

GFP_KERNEL

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
> +	kfree(hw->seq_pool);
> +	hw->seq_pool = NULL;
> +
> +	/* free hw_wq_callback pool */
> +	efct_hw_reqtag_pool_free(hw);
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
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +	u32	iters;
> +	enum efct_hw_state prev_state = hw->state;
> +
> +	if (hw->state != EFCT_HW_STATE_ACTIVE)
> +		efc_log_debug(hw->os,
> +			      "HW state %d is not active\n", hw->state);
> +
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
> +	return rc;
> +}
> +
> +int
> +efct_hw_get_num_eq(struct efct_hw *hw)
> +{
> +	return hw->eq_count;
> +}
> diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
> index 0b6838c7f924..9c025a1709e3 100644
> --- a/drivers/scsi/elx/efct/efct_hw.h
> +++ b/drivers/scsi/elx/efct/efct_hw.h
> @@ -772,4 +772,35 @@ efct_hw_get_host_stats(struct efct_hw *hw,
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
> +*efct_hw_new_wq(struct hw_cq *cq, u32 entry_count);
> +extern struct hw_rq
> +*efct_hw_new_rq(struct hw_cq *cq, u32 entry_count);
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
> +
>  #endif /* __EFCT_H__ */
> diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
> index b683208d396f..fef7f427dbbf 100644
> --- a/drivers/scsi/elx/efct/efct_xport.c
> +++ b/drivers/scsi/elx/efct/efct_xport.c
> @@ -521,3 +521,294 @@ efct_scsi_release_fc_transport(void)
>  
>  	return EFC_SUCCESS;
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
> +	if (timer_pending(&xport->stats_timer))
> +		del_timer(&xport->stats_timer);
> +
> +	efct_hw_teardown(&efct->hw);
> +
> +	efct_xport_delete_debugfs(efct);
> +
> +	return EFC_SUCCESS;
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
> +	return EFC_SUCCESS;
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
> +		bool reset_required;
> +		unsigned long timeout;
> +
> +		/* if a PHYSDEV reset was performed (e.g. hw dump), will affect
> +		 * all PCI functions; orderly shutdown won't work,
> +		 * just force free
> +		 */
> +
> +		reset_required = sli_reset_required(&efct->hw.sli);
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
> +			return EFC_FAIL;
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
> +	fc_remove_host(shost);
> +}
> +
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
> +	return EFC_SUCCESS;
> +}
> -- 
> 2.16.4
> 

Thanks,
Daniel

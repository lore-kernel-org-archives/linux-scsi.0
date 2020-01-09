Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB50C32771
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 09:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADE5A2067D
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 09:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbgAIJ14 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 04:27:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:53506 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729269AbgAIJ14 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Jan 2020 04:27:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 30BE0BCEC;
        Thu,  9 Jan 2020 09:27:49 +0000 (UTC)
Subject: Re: [PATCH v2 19/32] elx: efct: Hardware IO and SGL initialization
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-20-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <283ff0c9-58f7-65ff-6bd4-2715554bccc3@suse.de>
Date:   Thu, 9 Jan 2020 10:22:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-20-jsmart2021@gmail.com>
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
> Routines to create IO interfaces (wqs, etc), SGL initialization,
> and configure hardware features.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/efct/efct_hw.c | 1480 ++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/elx/efct/efct_hw.h |   46 ++
>  2 files changed, 1427 insertions(+), 99 deletions(-)
> 
> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
> index 339e904b0276..beca8534813d 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -240,6 +240,505 @@ efct_logfcfi(struct efct_hw *hw, u32 j, u32 i, u32 id)
>  		     j, hw->config.filter_def[j], i, id);
>  }
>  
> +static inline void
> +efct_hw_init_free_io(struct efct_hw_io *io)
> +{
> +	/*
> +	 * Set io->done to NULL, to avoid any callbacks, should
> +	 * a completion be received for one of these IOs
> +	 */
> +	io->done = NULL;
> +	io->abort_done = NULL;
> +	io->status_saved = false;
> +	io->abort_in_progress = false;
> +	io->rnode = NULL;
> +	io->type = 0xFFFF;
> +	io->wq = NULL;
> +	io->ul_io = NULL;
> +	io->tgt_wqe_timeout = 0;
> +}
> +
> +static void
> +efct_hw_io_restore_sgl(struct efct_hw *hw, struct efct_hw_io *io)
> +{
> +	/* Restore the default */
> +	io->sgl = &io->def_sgl;
> +	io->sgl_count = io->def_sgl_count;
> +
> +	/* Clear the overflow SGL */
> +	io->ovfl_sgl = NULL;
> +	io->ovfl_sgl_count = 0;
> +	io->ovfl_lsp = NULL;
> +}
> +
> +/* Initialize the pool of HW IO objects */
> +static enum efct_hw_rtn
> +efct_hw_setup_io(struct efct_hw *hw)
> +{
> +	u32	i = 0;
> +	struct efct_hw_io	*io = NULL;
> +	uintptr_t	xfer_virt = 0;
> +	uintptr_t	xfer_phys = 0;
> +	u32	index;
> +	bool new_alloc = true;
> +	struct efc_dma *dma;
> +	struct efct *efct = hw->os;
> +
> +	if (!hw->io) {
> +		hw->io = kmalloc_array(hw->config.n_io, sizeof(io),
> +				 GFP_KERNEL);
> +
> +		if (!hw->io)
> +			return EFCT_HW_RTN_NO_MEMORY;
> +
> +		memset(hw->io, 0, hw->config.n_io * sizeof(io));
> +
> +		for (i = 0; i < hw->config.n_io; i++) {
> +			hw->io[i] = kmalloc(sizeof(*io), GFP_KERNEL);
> +			if (!hw->io[i])
> +				goto error;
> +
> +			memset(hw->io[i], 0, sizeof(struct efct_hw_io));
> +		}
> +
> +		/* Create WQE buffs for IO */
> +		hw->wqe_buffs = kmalloc((hw->config.n_io *
> +					     hw->sli.wqe_size),
> +					     GFP_ATOMIC);
> +		if (!hw->wqe_buffs) {
> +			kfree(hw->io);
> +			return EFCT_HW_RTN_NO_MEMORY;
> +		}
> +		memset(hw->wqe_buffs, 0, (hw->config.n_io *
> +					hw->sli.wqe_size));
> +
> +	} else {
> +		/* re-use existing IOs, including SGLs */
> +		new_alloc = false;
> +	}
> +
> +	if (new_alloc) {
> +		dma = &hw->xfer_rdy;
> +		dma->size = sizeof(struct fcp_txrdy) * hw->config.n_io;
> +		dma->virt = dma_alloc_coherent(&efct->pcidev->dev,
> +					       dma->size, &dma->phys, GFP_DMA);
> +		if (!dma->virt)
> +			return EFCT_HW_RTN_NO_MEMORY;
> +	}
> +	xfer_virt = (uintptr_t)hw->xfer_rdy.virt;
> +	xfer_phys = hw->xfer_rdy.phys;
> +
> +	for (i = 0; i < hw->config.n_io; i++) {
> +		struct hw_wq_callback *wqcb;
> +
> +		io = hw->io[i];
> +
> +		/* initialize IO fields */
> +		io->hw = hw;
> +
> +		/* Assign a WQE buff */
> +		io->wqe.wqebuf = &hw->wqe_buffs[i * hw->sli.wqe_size];
> +
> +		/* Allocate the request tag for this IO */
> +		wqcb = efct_hw_reqtag_alloc(hw, efct_hw_wq_process_io, io);
> +		if (!wqcb) {
> +			efc_log_err(hw->os, "can't allocate request tag\n");
> +			return EFCT_HW_RTN_NO_RESOURCES;
> +		}
> +		io->reqtag = wqcb->instance_index;
> +
> +		/* Now for the fields that are initialized on each free */
> +		efct_hw_init_free_io(io);
> +
> +		/* The XB flag isn't cleared on IO free, so init to zero */
> +		io->xbusy = 0;
> +
> +		if (sli_resource_alloc(&hw->sli, SLI_RSRC_XRI,
> +				       &io->indicator, &index)) {
> +			efc_log_err(hw->os,
> +				     "sli_resource_alloc failed @ %d\n", i);
> +			return EFCT_HW_RTN_NO_MEMORY;
> +		}
> +		if (new_alloc) {
> +			dma = &io->def_sgl;
> +			dma->size = hw->config.n_sgl *
> +					sizeof(struct sli4_sge);
> +			dma->virt = dma_alloc_coherent(&efct->pcidev->dev,
> +						       dma->size, &dma->phys,
> +						       GFP_DMA);
> +			if (!dma->virt) {
> +				efc_log_err(hw->os, "dma_alloc fail %d\n", i);
> +				memset(&io->def_sgl, 0,
> +				       sizeof(struct efc_dma));
> +				return EFCT_HW_RTN_NO_MEMORY;
> +			}
> +		}
> +		io->def_sgl_count = hw->config.n_sgl;
> +		io->sgl = &io->def_sgl;
> +		io->sgl_count = io->def_sgl_count;
> +
> +		if (hw->xfer_rdy.size) {
> +			io->xfer_rdy.virt = (void *)xfer_virt;
> +			io->xfer_rdy.phys = xfer_phys;
> +			io->xfer_rdy.size = sizeof(struct fcp_txrdy);
> +
> +			xfer_virt += sizeof(struct fcp_txrdy);
> +			xfer_phys += sizeof(struct fcp_txrdy);
> +		}
> +	}
> +
> +	return EFCT_HW_RTN_SUCCESS;
> +error:
> +	for (i = 0; i < hw->config.n_io && hw->io[i]; i++) {
> +		kfree(hw->io[i]);
> +		hw->io[i] = NULL;
> +	}
> +
> +	kfree(hw->io);
> +	hw->io = NULL;
> +
> +	return EFCT_HW_RTN_NO_MEMORY;
> +}
> +
> +static enum efct_hw_rtn
> +efct_hw_init_io(struct efct_hw *hw)
> +{
> +	u32	i = 0, io_index = 0;
> +	bool prereg = false;
> +	struct efct_hw_io	*io = NULL;
> +	u8		cmd[SLI4_BMBX_SIZE];
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +	u32	nremaining;
> +	u32	n = 0;
> +	u32	sgls_per_request = 256;
> +	struct efc_dma	**sgls = NULL;
> +	struct efc_dma	reqbuf;
> +	struct efct *efct = hw->os;
> +
> +	prereg = hw->sli.sgl_pre_registered;
> +
> +	memset(&reqbuf, 0, sizeof(struct efc_dma));
> +	if (prereg) {
> +		sgls = kmalloc_array(sgls_per_request, sizeof(*sgls),
> +				     GFP_ATOMIC);
> +		if (!sgls)
> +			return EFCT_HW_RTN_NO_MEMORY;
> +
> +		reqbuf.size = 32 + sgls_per_request * 16;
> +		reqbuf.virt = dma_alloc_coherent(&efct->pcidev->dev,
> +						 reqbuf.size, &reqbuf.phys,
> +						 GFP_DMA);
> +		if (!reqbuf.virt) {
> +			efc_log_err(hw->os, "dma_alloc reqbuf failed\n");
> +			kfree(sgls);
> +			return EFCT_HW_RTN_NO_MEMORY;
> +		}
> +	}
> +
> +	for (nremaining = hw->config.n_io; nremaining; nremaining -= n) {
> +		if (prereg) {
> +			/* Copy address of SGL's into local sgls[] array, break
> +			 * out if the xri is not contiguous.
> +			 */
> +			u32 min = (sgls_per_request < nremaining)
> +					? sgls_per_request : nremaining;
> +			for (n = 0; n < min; n++) {
> +				/* Check that we have contiguous xri values */
> +				if (n > 0) {
> +					if (hw->io[io_index + n]->indicator !=
> +					    hw->io[io_index + n - 1]->indicator
> +					    + 1)
> +						break;
> +				}
> +				sgls[n] = hw->io[io_index + n]->sgl;
> +			}
> +
> +			if (!sli_cmd_post_sgl_pages(&hw->sli, cmd,
> +						   sizeof(cmd),
> +						hw->io[io_index]->indicator,
> +						n, sgls, NULL, &reqbuf)) {
> +				if (efct_hw_command(hw, cmd, EFCT_CMD_POLL,
> +						    NULL, NULL)) {
> +					rc = EFCT_HW_RTN_ERROR;
> +					efc_log_err(hw->os,
> +						     "SGL post failed\n");
> +					break;
> +				}
> +			}
> +		} else {
> +			n = nremaining;
> +		}
> +
> +		/* Add to tail if successful */
> +		for (i = 0; i < n; i++, io_index++) {
> +			io = hw->io[io_index];
> +			io->state = EFCT_HW_IO_STATE_FREE;
> +			INIT_LIST_HEAD(&io->list_entry);
> +			list_add_tail(&io->list_entry, &hw->io_free);
> +		}
> +	}
> +
> +	if (prereg) {
> +		dma_free_coherent(&efct->pcidev->dev,
> +				  reqbuf.size, reqbuf.virt, reqbuf.phys);
> +		memset(&reqbuf, 0, sizeof(struct efc_dma));
> +		kfree(sgls);
> +	}
> +
> +	return rc;
> +}
> +
> +static enum efct_hw_rtn
> +efct_hw_config_set_fdt_xfer_hint(struct efct_hw *hw, u32 fdt_xfer_hint)
> +{
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +	u8 buf[SLI4_BMBX_SIZE];
> +	struct sli4_rqst_cmn_set_features_set_fdt_xfer_hint param;
> +
> +	memset(&param, 0, sizeof(param));
> +	param.fdt_xfer_hint = cpu_to_le32(fdt_xfer_hint);
> +	/* build the set_features command */
> +	sli_cmd_common_set_features(&hw->sli, buf, SLI4_BMBX_SIZE,
> +				    SLI4_SET_FEATURES_SET_FTD_XFER_HINT,
> +				    sizeof(param),
> +				    &param);
> +
> +	rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
> +	if (rc)
> +		efc_log_warn(hw->os, "set FDT hint %d failed: %d\n",
> +			      fdt_xfer_hint, rc);
> +	else
> +		efc_log_info(hw->os, "Set FTD transfer hint to %d\n",
> +			      le32_to_cpu(param.fdt_xfer_hint));
> +
> +	return rc;
> +}
> +
> +/**
> + * efct_hw_config_mrq() - Configure Multi-RQ
> + *
> + * @hw: Hardware context allocated by the caller.
> + * @mode: 1 to set MRQ filters and 0 to set FCFI index
> + * @fcf_index: valid in mode 0
> + *
> + * Returns 0 on success, or a non-zero value on failure.
> + */
> +static int
> +efct_hw_config_mrq(struct efct_hw *hw, u8 mode, u16 fcf_index)
> +{
> +	u8 buf[SLI4_BMBX_SIZE], mrq_bitmask = 0;
> +	struct hw_rq *rq;
> +	struct sli4_cmd_reg_fcfi_mrq *rsp = NULL;
> +	u32 i, j;
> +	struct sli4_cmd_rq_cfg rq_filter[SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG];
> +	int rc;
> +
> +	if (mode == SLI4_CMD_REG_FCFI_SET_FCFI_MODE)
> +		goto issue_cmd;
> +
> +	/* Set the filter match/mask values from hw's filter_def values */
> +	for (i = 0; i < SLI4_CMD_REG_FCFI_NUM_RQ_CFG; i++) {
> +		rq_filter[i].rq_id = cpu_to_le16(0xffff);
> +		rq_filter[i].r_ctl_mask  = (u8)hw->config.filter_def[i];
> +		rq_filter[i].r_ctl_match = (u8)(hw->config.filter_def[i] >> 8);
> +		rq_filter[i].type_mask   = (u8)(hw->config.filter_def[i] >> 16);
> +		rq_filter[i].type_match  = (u8)(hw->config.filter_def[i] >> 24);
> +	}
> +
> +	/* Accumulate counts for each filter type used, build rq_ids[] list */
> +	for (i = 0; i < hw->hw_rq_count; i++) {
> +		rq = hw->hw_rq[i];
> +		for (j = 0; j < SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG; j++) {
> +			if (!(rq->filter_mask & (1U << j)))
> +				continue;
> +
> +			if (rq_filter[j].rq_id != cpu_to_le16(0xffff)) {
> +				/*
> +				 * Already used. Bailout ifts not RQset
> +				 * case
> +				 */
> +				if (!rq->is_mrq ||
> +				    rq_filter[j].rq_id !=
> +				    cpu_to_le16(rq->base_mrq_id)) {
> +					efc_log_err(hw->os, "Wrong q top.\n");
> +					return EFCT_HW_RTN_ERROR;
> +				}
> +				continue;
> +			}
> +
> +			if (!rq->is_mrq) {
> +				rq_filter[j].rq_id = cpu_to_le16(rq->hdr->id);
> +				continue;
> +			}
> +
> +			rq_filter[j].rq_id = cpu_to_le16(rq->base_mrq_id);
> +			mrq_bitmask |= (1U << j);
> +		}
> +	}
> +
> +issue_cmd:
> +	/* Invoke REG_FCFI_MRQ */
> +	rc = sli_cmd_reg_fcfi_mrq(&hw->sli,
> +				  buf,	/* buf */
> +				 SLI4_BMBX_SIZE, /* size */
> +				 mode, /* mode 1 */
> +				 fcf_index, /* fcf_index */
> +				 /* RQ selection policy*/
> +				 hw->config.rq_selection_policy,
> +				 mrq_bitmask, /* MRQ bitmask */
> +				 hw->hw_mrq_count, /* num_mrqs */
> +				 rq_filter);/* RQ filter */
> +	if (rc) {
> +		efc_log_err(hw->os,
> +			     "sli_cmd_reg_fcfi_mrq() failed: %d\n", rc);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
> +
> +	rsp = (struct sli4_cmd_reg_fcfi_mrq *)buf;
> +
> +	if (rc != EFCT_HW_RTN_SUCCESS ||
> +	    le16_to_cpu(rsp->hdr.status)) {
> +		efc_log_err(hw->os,
> +			     "FCFI MRQ reg failed. cmd = %x status = %x\n",
> +			     rsp->hdr.command,
> +			     le16_to_cpu(rsp->hdr.status));
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	if (mode == SLI4_CMD_REG_FCFI_SET_FCFI_MODE)
> +		hw->fcf_indicator = le16_to_cpu(rsp->fcfi);
> +	return 0;
> +}
> +
> +static enum efct_hw_rtn
> +efct_hw_config_watchdog_timer(struct efct_hw *hw);
> +
> +static void
> +efct_hw_watchdog_timer_cb(struct timer_list *t)
> +{
> +	struct efct_hw *hw = from_timer(hw, t, watchdog_timer);
> +
> +	efct_hw_config_watchdog_timer(hw);
> +}
> +
> +static void
> +efct_hw_cb_cfg_watchdog(struct efct_hw *hw, int status, u8 *mqe,
> +			void  *arg)
> +{
> +	u16 timeout = hw->watchdog_timeout;
> +
> +	if (status != 0) {
> +		efc_log_err(hw->os, "config watchdog timer failed, rc = %d\n",
> +			     status);
> +	} else {
> +		if (timeout != 0) {
> +			/*
> +			 * keeping callback 500ms before timeout to keep
> +			 * heartbeat alive
> +			 */
> +			timer_setup(&hw->watchdog_timer,
> +				    &efct_hw_watchdog_timer_cb, 0);
> +
> +			mod_timer(&hw->watchdog_timer,
> +				  jiffies +
> +				  msecs_to_jiffies(timeout * 1000 - 500));
> +		} else {
> +			del_timer(&hw->watchdog_timer);
> +		}
> +	}
> +
> +	kfree(mqe);
> +}
> +
> +/* Set configuration parameters for watchdog timer feature */
> +static enum efct_hw_rtn
> +efct_hw_config_watchdog_timer(struct efct_hw *hw)
> +{
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +	u8 *buf = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +
> +	if (!buf)
> +		return EFCT_HW_RTN_ERROR;
> +
> +	sli4_cmd_lowlevel_set_watchdog(&hw->sli, buf, SLI4_BMBX_SIZE,
> +				       hw->watchdog_timeout);
> +	rc = efct_hw_command(hw, buf, EFCT_CMD_NOWAIT, efct_hw_cb_cfg_watchdog,
> +			     NULL);
> +	if (rc) {
> +		kfree(buf);
> +		efc_log_err(hw->os, "config watchdog timer failed, rc = %d\n",
> +			     rc);
> +	}
> +	return rc;
> +}
> +
> +static enum efct_hw_rtn
> +efct_hw_set_dif_seed(struct efct_hw *hw)
> +{
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +	u8 buf[SLI4_BMBX_SIZE];
> +	struct sli4_rqst_cmn_set_features_dif_seed seed_param;
> +
> +	memset(&seed_param, 0, sizeof(seed_param));
> +	seed_param.seed = cpu_to_le16(hw->config.dif_seed);
> +
> +	/* send set_features command */
> +	if (!sli_cmd_common_set_features(&hw->sli, buf, SLI4_BMBX_SIZE,
> +					SLI4_SET_FEATURES_DIF_SEED,
> +					4,
> +					(u32 *)&seed_param)) {
> +		rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
> +		if (rc)
> +			efc_log_err(hw->os,
> +				     "efct_hw_command returns %d\n", rc);
> +		else
> +			efc_log_debug(hw->os, "DIF seed set to 0x%x\n",
> +				       hw->config.dif_seed);
> +	} else {
> +		efc_log_err(hw->os,
> +			     "sli_cmd_common_set_features failed\n");
> +		rc = EFCT_HW_RTN_ERROR;
> +	}
> +	return rc;
> +}
> +
> +/* enable sli port health check */
> +static enum efct_hw_rtn
> +efct_hw_config_sli_port_health_check(struct efct_hw *hw, u8 query,
> +				     u8 enable)
> +{
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +	u8 buf[SLI4_BMBX_SIZE];
> +	struct sli4_rqst_cmn_set_features_health_check param;
> +	u32	health_check_flag = 0;
> +
> +	memset(&param, 0, sizeof(param));
> +
> +	if (enable)
> +		health_check_flag |= SLI4_RQ_HEALTH_CHECK_ENABLE;
> +
> +	if (query)
> +		health_check_flag |= SLI4_RQ_HEALTH_CHECK_QUERY;
> +
> +	param.health_check_dword = cpu_to_le32(health_check_flag);
> +
> +	/* build the set_features command */
> +	sli_cmd_common_set_features(&hw->sli, buf, SLI4_BMBX_SIZE,
> +				    SLI4_SET_FEATURES_SLI_PORT_HEALTH_CHECK,
> +				    sizeof(param),
> +				    &param);
> +
> +	rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
> +	if (rc)
> +		efc_log_err(hw->os, "efct_hw_command returns %d\n", rc);
> +	else
> +		efc_log_test(hw->os, "SLI Port Health Check is enabled\n");
> +
> +	return rc;
> +}
> +
>  enum efct_hw_rtn
>  efct_hw_init(struct efct_hw *hw)
>  {
> @@ -712,104 +1211,6 @@ efct_hw_init(struct efct_hw *hw)
>  	return EFCT_HW_RTN_SUCCESS;
>  }
>  
> -/**
> - * efct_hw_config_mrq() - Configure Multi-RQ
> - *
> - * @hw: Hardware context allocated by the caller.
> - * @mode: 1 to set MRQ filters and 0 to set FCFI index
> - * @fcf_index: valid in mode 0
> - *
> - * Returns 0 on success, or a non-zero value on failure.
> - */
> -static int
> -efct_hw_config_mrq(struct efct_hw *hw, u8 mode, u16 fcf_index)
> -{
> -	u8 buf[SLI4_BMBX_SIZE], mrq_bitmask = 0;
> -	struct hw_rq *rq;
> -	struct sli4_cmd_reg_fcfi_mrq *rsp = NULL;
> -	u32 i, j;
> -	struct sli4_cmd_rq_cfg rq_filter[SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG];
> -	int rc;
> -
> -	if (mode == SLI4_CMD_REG_FCFI_SET_FCFI_MODE)
> -		goto issue_cmd;
> -
> -	/* Set the filter match/mask values from hw's filter_def values */
> -	for (i = 0; i < SLI4_CMD_REG_FCFI_NUM_RQ_CFG; i++) {
> -		rq_filter[i].rq_id = cpu_to_le16(0xffff);
> -		rq_filter[i].r_ctl_mask  = (u8)hw->config.filter_def[i];
> -		rq_filter[i].r_ctl_match = (u8)(hw->config.filter_def[i] >> 8);
> -		rq_filter[i].type_mask   = (u8)(hw->config.filter_def[i] >> 16);
> -		rq_filter[i].type_match  = (u8)(hw->config.filter_def[i] >> 24);
> -	}
> -
> -	/* Accumulate counts for each filter type used, build rq_ids[] list */
> -	for (i = 0; i < hw->hw_rq_count; i++) {
> -		rq = hw->hw_rq[i];
> -		for (j = 0; j < SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG; j++) {
> -			if (!(rq->filter_mask & (1U << j)))
> -				continue;
> -
> -			if (rq_filter[j].rq_id != cpu_to_le16(0xffff)) {
> -				/*
> -				 * Already used. Bailout ifts not RQset
> -				 * case
> -				 */
> -				if (!rq->is_mrq ||
> -				    rq_filter[j].rq_id !=
> -				    cpu_to_le16(rq->base_mrq_id)) {
> -					efc_log_err(hw->os, "Wrong q top.\n");
> -					return EFCT_HW_RTN_ERROR;
> -				}
> -				continue;
> -			}
> -
> -			if (!rq->is_mrq) {
> -				rq_filter[j].rq_id = cpu_to_le16(rq->hdr->id);
> -				continue;
> -			}
> -
> -			rq_filter[j].rq_id = cpu_to_le16(rq->base_mrq_id);
> -			mrq_bitmask |= (1U << j);
> -		}
> -	}
> -
> -issue_cmd:
> -	/* Invoke REG_FCFI_MRQ */
> -	rc = sli_cmd_reg_fcfi_mrq(&hw->sli,
> -				  buf,	/* buf */
> -				 SLI4_BMBX_SIZE, /* size */
> -				 mode, /* mode 1 */
> -				 fcf_index, /* fcf_index */
> -				 /* RQ selection policy*/
> -				 hw->config.rq_selection_policy,
> -				 mrq_bitmask, /* MRQ bitmask */
> -				 hw->hw_mrq_count, /* num_mrqs */
> -				 rq_filter);/* RQ filter */
> -	if (rc) {
> -		efc_log_err(hw->os,
> -			     "sli_cmd_reg_fcfi_mrq() failed: %d\n", rc);
> -		return EFCT_HW_RTN_ERROR;
> -	}
> -
> -	rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
> -
> -	rsp = (struct sli4_cmd_reg_fcfi_mrq *)buf;
> -
> -	if (rc != EFCT_HW_RTN_SUCCESS ||
> -	    le16_to_cpu(rsp->hdr.status)) {
> -		efc_log_err(hw->os,
> -			     "FCFI MRQ reg failed. cmd = %x status = %x\n",
> -			     rsp->hdr.command,
> -			     le16_to_cpu(rsp->hdr.status));
> -		return EFCT_HW_RTN_ERROR;
> -	}
> -
> -	if (mode == SLI4_CMD_REG_FCFI_SET_FCFI_MODE)
> -		hw->fcf_indicator = le16_to_cpu(rsp->fcfi);
> -	return 0;
> -}
> -
>  enum efct_hw_rtn
>  efct_hw_set(struct efct_hw *hw, enum efct_hw_property prop, u32 value)
>  {
> @@ -1221,6 +1622,10 @@ efct_get_wwn(struct efct_hw *hw, enum efct_hw_property prop)
>  	return value;
>  }
>  
> +/*
> + * An efct_hw_rx_buffer_t array is allocated,
> + * along with the required DMA mem
> + */
>  static struct efc_hw_rq_buffer *
>  efct_hw_rx_buffer_alloc(struct efct_hw *hw, u32 rqindex, u32 count,
>  			u32 size)
> @@ -1327,6 +1732,7 @@ efct_hw_rx_allocate(struct efct_hw *hw)
>  	return rc ? EFCT_HW_RTN_ERROR : EFCT_HW_RTN_SUCCESS;
>  }
>  
> +/* Post the RQ data buffers to the chip */
>  enum efct_hw_rtn
>  efct_hw_rx_post(struct efct_hw *hw)
>  {
> @@ -1414,7 +1820,7 @@ efct_hw_cmd_submit_pending(struct efct_hw *hw)
>  	return rc;
>  }
>  
> -/**
> +/*
>   * Send a mailbox command to the hardware, and either wait for a completion
>   * (EFCT_CMD_POLL) or get an optional asynchronous completion (EFCT_CMD_NOWAIT).
>   */

Pointless hunk.

> @@ -1575,3 +1981,879 @@ efct_hw_command_cancel(struct efct_hw *hw)
>  
>  	return 0;
>  }
> +
> +static inline struct efct_hw_io *
> +_efct_hw_io_alloc(struct efct_hw *hw)
> +{
> +	struct efct_hw_io	*io = NULL;
> +
> +	if (!list_empty(&hw->io_free)) {
> +		io = list_first_entry(&hw->io_free, struct efct_hw_io,
> +				      list_entry);
> +		list_del(&io->list_entry);
> +	}
> +	if (io) {
> +		INIT_LIST_HEAD(&io->list_entry);
> +		INIT_LIST_HEAD(&io->wqe_link);
> +		INIT_LIST_HEAD(&io->dnrx_link);
> +		list_add_tail(&io->list_entry, &hw->io_inuse);
> +		io->state = EFCT_HW_IO_STATE_INUSE;
> +		io->abort_reqtag = U32_MAX;
> +		kref_init(&io->ref);
> +		io->release = efct_hw_io_free_internal;
> +	} else {
> +		atomic_add_return(1, &hw->io_alloc_failed_count);
> +	}
> +
> +	return io;
> +}
> +
> +struct efct_hw_io *
> +efct_hw_io_alloc(struct efct_hw *hw)
> +{
> +	struct efct_hw_io	*io = NULL;
> +	unsigned long flags = 0;
> +
> +	spin_lock_irqsave(&hw->io_lock, flags);
> +	io = _efct_hw_io_alloc(hw);
> +	spin_unlock_irqrestore(&hw->io_lock, flags);
> +
> +	return io;
> +}
> +
> +/*
> + * When an IO is freed, depending on the exchange busy flag, and other
> + * workarounds, move it to the correct list.
> + */
> +static void
> +efct_hw_io_free_move_correct_list(struct efct_hw *hw,
> +				  struct efct_hw_io *io)
> +{
> +	if (io->xbusy) {
> +		/*
> +		 * add to wait_free list and wait for XRI_ABORTED CQEs to clean
> +		 * up
> +		 */
> +		INIT_LIST_HEAD(&io->list_entry);
> +		list_add_tail(&io->list_entry, &hw->io_wait_free);
> +		io->state = EFCT_HW_IO_STATE_WAIT_FREE;
> +	} else {
> +		/* IO not busy, add to free list */
> +		INIT_LIST_HEAD(&io->list_entry);
> +		list_add_tail(&io->list_entry, &hw->io_free);
> +		io->state = EFCT_HW_IO_STATE_FREE;
> +	}
> +}
> +
> +static inline void
> +efct_hw_io_free_common(struct efct_hw *hw, struct efct_hw_io *io)
> +{
> +	/* initialize IO fields */
> +	efct_hw_init_free_io(io);
> +
> +	/* Restore default SGL */
> +	efct_hw_io_restore_sgl(hw, io);
> +}
> +
> +/**
> + * Free a previously-allocated HW IO object. Called when
> + * IO refcount goes to zero (host-owned IOs only).
> + */
> +void
> +efct_hw_io_free_internal(struct kref *arg)
> +{
> +	unsigned long flags = 0;
> +	struct efct_hw_io *io =
> +			container_of(arg, struct efct_hw_io, ref);
> +	struct efct_hw *hw = io->hw;
> +
> +	/* perform common cleanup */
> +	efct_hw_io_free_common(hw, io);
> +
> +	spin_lock_irqsave(&hw->io_lock, flags);
> +		/* remove from in-use list */
> +		if (io->list_entry.next &&
> +		    !list_empty(&hw->io_inuse)) {
> +			list_del(&io->list_entry);
> +			efct_hw_io_free_move_correct_list(hw, io);
> +		}
> +	spin_unlock_irqrestore(&hw->io_lock, flags);
> +}
> +
> +int
> +efct_hw_io_free(struct efct_hw *hw, struct efct_hw_io *io)
> +{
> +	/* just put refcount */
> +	if (refcount_read(&io->ref.refcount) <= 0) {
> +		efc_log_err(hw->os,
> +			     "Bad parameter: refcount <= 0 xri=%x tag=%x\n",
> +			    io->indicator, io->reqtag);
> +		return -1;
> +	}
> +
> +	return kref_put(&io->ref, io->release);
> +}
> +

Why this check? Shouldn't kref_get_unless_zero() protect against this?

> +u8
> +efct_hw_io_inuse(struct efct_hw *hw, struct efct_hw_io *io)
> +{
> +	return (refcount_read(&io->ref.refcount) > 0);
> +}
> +
> +struct efct_hw_io *
> +efct_hw_io_lookup(struct efct_hw *hw, u32 xri)
> +{
> +	u32 ioindex;
> +
> +	ioindex = xri - hw->sli.extent[SLI_RSRC_XRI].base[0];
> +	return hw->io[ioindex];
> +}
> +
> +/**
> + * Issue any pending callbacks for an IO and remove off the timer and
> + * pending lists.
> + */
> +static void
> +efct_hw_io_cancel_cleanup(struct efct_hw *hw, struct efct_hw_io *io)
> +{
> +	efct_hw_done_t done = io->done;
> +	efct_hw_done_t abort_done = io->abort_done;
> +	unsigned long flags = 0;
> +
> +	/* first check active_wqe list and remove if there */
> +	if (io->wqe_link.next)
> +		list_del(&io->wqe_link);
> +
> +	/* Remove from WQ pending list */
> +	if (io->wq && io->wq->pending_list.next)
> +		list_del(&io->list_entry);
> +
> +	if (io->done) {
> +		void *arg = io->arg;
> +
> +		io->done = NULL;
> +		spin_unlock_irqrestore(&hw->io_lock, flags);
> +		done(io, io->rnode, 0, SLI4_FC_WCQE_STATUS_SHUTDOWN, 0, arg);
> +		spin_lock_irqsave(&hw->io_lock, flags);
> +	}
> +
> +	if (io->abort_done) {
> +		void		*abort_arg = io->abort_arg;
> +
> +		io->abort_done = NULL;
> +		spin_unlock_irqrestore(&hw->io_lock, flags);
> +		abort_done(io, io->rnode, 0, SLI4_FC_WCQE_STATUS_SHUTDOWN, 0,
> +			   abort_arg);
> +		spin_lock_irqsave(&hw->io_lock, flags);
> +	}
> +}
> +
> +static int
> +efct_hw_io_cancel(struct efct_hw *hw)
> +{
> +	struct efct_hw_io *io = NULL;
> +	struct efct_hw_io *tmp_io = NULL;
> +	u32 iters = 100; /* One second limit */
> +	unsigned long flags = 0;
> +
> +	/*
> +	 * Manually clean up outstanding IO.
> +	 * Only walk through list once: the backend will cleanup any IOs when
> +	 * done/abort_done is called.
> +	 */
> +	spin_lock_irqsave(&hw->io_lock, flags);
> +	list_for_each_entry_safe(io, tmp_io, &hw->io_inuse, list_entry) {
> +		efct_hw_done_t  done = io->done;
> +		efct_hw_done_t  abort_done = io->abort_done;
> +
> +		efct_hw_io_cancel_cleanup(hw, io);
> +
> +		/*
> +		 * Since this is called in a reset/shutdown
> +		 * case, If there is no callback, then just
> +		 * free the IO.
> +		 *
> +		 * Note: A port owned XRI cannot be on
> +		 *       the in use list. We cannot call
> +		 *       efct_hw_io_free() because we already
> +		 *       hold the io_lock.
> +		 */
> +		if (!done &&
> +		    !abort_done) {
> +			/*
> +			 * Since this is called in a reset/shutdown
> +			 * case, If there is no callback, then just
> +			 * free the IO.
> +			 */
> +			efct_hw_io_free_common(hw, io);
> +			list_del(&io->list_entry);
> +			efct_hw_io_free_move_correct_list(hw, io);
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&hw->io_lock, flags);
> +
> +	/* Give time for the callbacks to complete */
> +	do {
> +		mdelay(10);
> +		iters--;
> +	} while (!list_empty(&hw->io_inuse) && iters);
> +

That is pretty lame.
Can't you use refcounts for 'hw' just call 'kref_put(hw)'?


Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

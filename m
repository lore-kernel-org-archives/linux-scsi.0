Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E57C2BA2B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 07:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F12F720784
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 07:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441043AbgDPH6T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 03:58:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:38982 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440900AbgDPH6M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 03:58:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1A2E1AE6E;
        Thu, 16 Apr 2020 07:58:09 +0000 (UTC)
Subject: Re: [PATCH v3 22/31] elx: efct: Extended link Service IO handling
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-23-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e574f136-656a-78c9-f062-554ae15f0899@suse.de>
Date:   Thu, 16 Apr 2020 09:58:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200412033303.29574-23-jsmart2021@gmail.com>
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
> Functions to build and send ELS/CT/BLS commands and responses.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>    Unified log message using cmd_name
>    Return and drop else, for better indentation and consistency.
>    Changed assertion log messages.
> ---
>   drivers/scsi/elx/efct/efct_els.c | 1928 ++++++++++++++++++++++++++++++++++++++
>   drivers/scsi/elx/efct/efct_els.h |  133 +++
>   2 files changed, 2061 insertions(+)
>   create mode 100644 drivers/scsi/elx/efct/efct_els.c
>   create mode 100644 drivers/scsi/elx/efct/efct_els.h
> 
> diff --git a/drivers/scsi/elx/efct/efct_els.c b/drivers/scsi/elx/efct/efct_els.c
> new file mode 100644
> index 000000000000..8a2598a83445
> --- /dev/null
> +++ b/drivers/scsi/elx/efct/efct_els.c
> @@ -0,0 +1,1928 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +/*
> + * Functions to build and send ELS/CT/BLS commands and responses.
> + */
> +
> +#include "efct_driver.h"
> +#include "efct_els.h"
> +
> +#define ELS_IOFMT "[i:%04x t:%04x h:%04x]"
> +
> +#define EFCT_LOG_ENABLE_ELS_TRACE(efct)		\
> +		(((efct) != NULL) ? (((efct)->logmask & (1U << 1)) != 0) : 0)
> +
> +#define node_els_trace()  \
> +	do { \
> +		if (EFCT_LOG_ENABLE_ELS_TRACE(efct)) \
> +			efc_log_info(efct, "[%s] %-20s\n", \
> +				node->display_name, __func__); \
> +	} while (0)
> +
> +#define els_io_printf(els, fmt, ...) \
> +	efc_log_debug((struct efct *)els->node->efc->base,\
> +		      "[%s]" ELS_IOFMT " %-8s " fmt, \
> +		      els->node->display_name,\
> +		      els->init_task_tag, els->tgt_task_tag, els->hw_tag,\
> +		      els->display_name, ##__VA_ARGS__)
> +

Why not simply use dyndebug here?

> +#define EFCT_ELS_RSP_LEN		1024
> +#define EFCT_ELS_GID_PT_RSP_LEN		8096
> +
> +static char *cmd_name[] = FC_ELS_CMDS_INIT;
> +
> +void *
> +efct_els_req_send(struct efc *efc, struct efc_node *node, u32 cmd,
> +		  u32 timeout_sec, u32 retries)
> +{
> +	struct efct *efct = efc->base;
> +
> +	efc_log_debug(efct, "send %s\n", cmd_name[cmd]);
> +
> +	switch (cmd) {
> +	case ELS_PLOGI:
> +		return efct_send_plogi(node, timeout_sec, retries, NULL, NULL);
> +	case ELS_FLOGI:
> +		return efct_send_flogi(node, timeout_sec, retries, NULL, NULL);
> +	case ELS_FDISC:
> +		return efct_send_fdisc(node, timeout_sec, retries, NULL, NULL);
> +	case ELS_LOGO:
> +		return efct_send_logo(node, timeout_sec, retries, NULL, NULL);
> +	case ELS_PRLI:
> +		return efct_send_prli(node, timeout_sec, retries, NULL, NULL);
> +	case ELS_ADISC:
> +		return efct_send_adisc(node, timeout_sec, retries, NULL, NULL);
> +	case ELS_SCR:
> +		return efct_send_scr(node, timeout_sec, retries, NULL, NULL);
> +	default:
> +		efc_log_err(efct, "Unhandled command cmd: %x\n", cmd);
> +	}
> +
> +	return NULL;
> +}
> +

You and your 'void *' functions always returning NULL ...
Please make them normal void functions.

> +void *
> +efct_els_resp_send(struct efc *efc, struct efc_node *node,
> +		   u32 cmd, u16 ox_id)
> +{
> +	struct efct *efct = efc->base;
> +
> +	switch (cmd) {
> +	case ELS_PLOGI:
> +		efct_send_plogi_acc(node, ox_id, NULL, NULL);
> +		break;
> +	case ELS_FLOGI:
> +		efct_send_flogi_acc(node, ox_id, 0, NULL, NULL);
> +		break;
> +	case ELS_LOGO:
> +		efct_send_logo_acc(node, ox_id, NULL, NULL);
> +		break;
> +	case ELS_PRLI:
> +		efct_send_prli_acc(node, ox_id, NULL, NULL);
> +		break;
> +	case ELS_PRLO:
> +		efct_send_prlo_acc(node, ox_id, NULL, NULL);
> +		break;
> +	case ELS_ADISC:
> +		efct_send_adisc_acc(node, ox_id, NULL, NULL);
> +		break;
> +	case ELS_LS_ACC:
> +		efct_send_ls_acc(node, ox_id, NULL, NULL);
> +		break;
> +	case ELS_PDISC:
> +	case ELS_FDISC:
> +	case ELS_RSCN:
> +	case ELS_SCR:
> +		efct_send_ls_rjt(efc, node, ox_id, ELS_RJT_UNAB,
> +				 ELS_EXPL_NONE, 0);
> +		break;
> +	default:
> +		efc_log_err(efct, "Unhandled command cmd: %x\n", cmd);
> +	}
> +
> +	return NULL;
> +}
> +

Same here.

> +struct efct_io *
> +efct_els_io_alloc(struct efc_node *node, u32 reqlen,
> +		  enum efct_els_role role)
> +{
> +	return efct_els_io_alloc_size(node, reqlen, EFCT_ELS_RSP_LEN, role);
> +}
> +
> +struct efct_io *
> +efct_els_io_alloc_size(struct efc_node *node, u32 reqlen,
> +		       u32 rsplen, enum efct_els_role role)
> +{
> +	struct efct *efct;
> +	struct efct_xport *xport;
> +	struct efct_io *els;
> +	unsigned long flags = 0;
> +
> +	efct = node->efc->base;
> +
> +	xport = efct->xport;
> +
> +	spin_lock_irqsave(&node->active_ios_lock, flags);
> +
> +	if (!node->io_alloc_enabled) {
> +		efc_log_debug(efct,
> +			       "called with io_alloc_enabled = FALSE\n");
> +		spin_unlock_irqrestore(&node->active_ios_lock, flags);
> +		return NULL;
> +	}
> +
> +	els = efct_io_pool_io_alloc(efct->xport->io_pool);
> +	if (!els) {
> +		atomic_add_return(1, &xport->io_alloc_failed_count);
> +		spin_unlock_irqrestore(&node->active_ios_lock, flags);
> +		return NULL;
> +	}
> +
> +	/* initialize refcount */
> +	kref_init(&els->ref);
> +	els->release = _efct_els_io_free;
> +
> +	switch (role) {
> +	case EFCT_ELS_ROLE_ORIGINATOR:
> +		els->cmd_ini = true;
> +		els->cmd_tgt = false;
> +		break;
> +	case EFCT_ELS_ROLE_RESPONDER:
> +		els->cmd_ini = false;
> +		els->cmd_tgt = true;
> +		break;
> +	}
> +
> +	/* IO should not have an associated HW IO yet.
> +	 * Assigned below.
> +	 */
> +	if (els->hio) {
> +		efc_log_err(efct, "Error: HW io not null hio:%p\n", els->hio);
> +		efct_io_pool_io_free(efct->xport->io_pool, els);
> +		spin_unlock_irqrestore(&node->active_ios_lock, flags);
> +		return NULL;
> +	}
> +
> +	/* populate generic io fields */
> +	els->efct = efct;
> +	els->node = node;
> +
> +	/* set type and ELS-specific fields */
> +	els->io_type = EFCT_IO_TYPE_ELS;
> +	els->display_name = "pending";
> +
> +	/* now allocate DMA for request and response */
> +	els->els_req.size = reqlen;
> +	els->els_req.virt = dma_alloc_coherent(&efct->pcidev->dev,
> +					       els->els_req.size,
> +					       &els->els_req.phys,
> +					       GFP_DMA);
> +	if (els->els_req.virt) {
> +		els->els_rsp.size = rsplen;
> +		els->els_rsp.virt = dma_alloc_coherent(&efct->pcidev->dev,
> +						       els->els_rsp.size,
> +						       &els->els_rsp.phys,
> +						       GFP_DMA);
> +		if (!els->els_rsp.virt) {
> +			efc_log_err(efct, "dma_alloc rsp\n");
> +			dma_free_coherent(&efct->pcidev->dev,
> +					  els->els_req.size,
> +				els->els_req.virt, els->els_req.phys);
> +			memset(&els->els_req, 0, sizeof(struct efc_dma));
> +			efct_io_pool_io_free(efct->xport->io_pool, els);
> +			els = NULL;
> +		}
> +	} else {
> +		efc_log_err(efct, "dma_alloc req\n");
> +		efct_io_pool_io_free(efct->xport->io_pool, els);
> +		els = NULL;
> +	}
> +
> +	if (els) {
> +		/* initialize fields */
> +		els->els_retries_remaining =
> +					EFCT_FC_ELS_DEFAULT_RETRIES;
> +		els->els_pend = false;
> +		els->els_active = false;
> +
> +		/* add els structure to ELS IO list */
> +		INIT_LIST_HEAD(&els->list_entry);
> +		list_add_tail(&els->list_entry,
> +			      &node->els_io_pend_list);
> +		els->els_pend = true;
> +	}
> +
> +	spin_unlock_irqrestore(&node->active_ios_lock, flags);
> +	return els;
> +}
> +
> +void
> +efct_els_io_free(struct efct_io *els)
> +{
> +	kref_put(&els->ref, els->release);
> +}
> +
> +void
> +_efct_els_io_free(struct kref *arg)
> +{
> +	struct efct_io *els = container_of(arg, struct efct_io, ref);
> +	struct efct *efct;
> +	struct efc_node *node;
> +	int send_empty_event = false;
> +	unsigned long flags = 0;
> +
> +	node = els->node;
> +	efct = node->efc->base;
> +
> +	spin_lock_irqsave(&node->active_ios_lock, flags);
> +		if (els->els_active) {
> +			/* if active, remove from active list and check empty */
> +			list_del(&els->list_entry);
> +			/* Send list empty event if the IO allocator
> +			 * is disabled, and the list is empty
> +			 * If node->io_alloc_enabled was not checked,
> +			 * the event would be posted continually
> +			 */
> +			send_empty_event = (!node->io_alloc_enabled) &&
> +				list_empty(&node->els_io_active_list);
> +			els->els_active = false;
> +		} else if (els->els_pend) {
> +			/* if pending, remove from pending list;
> +			 * node shutdown isn't gated off the
> +			 * pending list (only the active list),
> +			 * so no need to check if pending list is empty
> +			 */
> +			list_del(&els->list_entry);
> +			els->els_pend = 0;
> +		} else {
> +			efc_log_err(efct,
> +				"Error: els not in pending or active set\n");
> +			spin_unlock_irqrestore(&node->active_ios_lock, flags);
> +			return;
> +		}
> +
> +	spin_unlock_irqrestore(&node->active_ios_lock, flags);
> +
> +	/* free ELS request and response buffers */
> +	dma_free_coherent(&efct->pcidev->dev, els->els_rsp.size,
> +			  els->els_rsp.virt, els->els_rsp.phys);
> +	dma_free_coherent(&efct->pcidev->dev, els->els_req.size,
> +			  els->els_req.virt, els->els_req.phys);
> +
> +	memset(&els->els_rsp, 0, sizeof(struct efc_dma));
> +	memset(&els->els_req, 0, sizeof(struct efc_dma));
> +	efct_io_pool_io_free(efct->xport->io_pool, els);
> +
> +	if (send_empty_event)
> +		efc_scsi_io_list_empty(node->efc, node);
> +
> +	efct_scsi_check_pending(efct);
> +}
> +
> +static void
> +efct_els_make_active(struct efct_io *els)
> +{
> +	struct efc_node *node = els->node;
> +	unsigned long flags = 0;
> +
> +	/* move ELS from pending list to active list */
> +	spin_lock_irqsave(&node->active_ios_lock, flags);
> +		if (els->els_pend) {
> +			if (els->els_active) {
> +				efc_log_err(node->efc,
> +					"Error: els in both pend and active\n");
> +				spin_unlock_irqrestore(&node->active_ios_lock,
> +						       flags);
> +				return;
> +			}
> +			/* remove from pending list */
> +			list_del(&els->list_entry);
> +			els->els_pend = false;
> +
> +			/* add els structure to ELS IO list */
> +			INIT_LIST_HEAD(&els->list_entry);
> +			list_add_tail(&els->list_entry,
> +				      &node->els_io_active_list);
> +			els->els_active = true;
> +		} else {
> +			/* must be retrying; make sure it's already active */
> +			if (!els->els_active) {
> +				efc_log_err(node->efc,
> +					"Error: els not in pending or active set\n");
> +			}
> +		}
> +	spin_unlock_irqrestore(&node->active_ios_lock, flags);
> +}
> +
> +static int efct_els_send(struct efct_io *els, u32 reqlen,
> +			 u32 timeout_sec, efct_hw_srrs_cb_t cb)
> +{
> +	struct efc_node *node = els->node;
> +
> +	/* update ELS request counter */
> +	node->els_req_cnt++;
> +
> +	/* move ELS from pending list to active list */
> +	efct_els_make_active(els);
> +
> +	els->wire_len = reqlen;
> +	return efct_scsi_io_dispatch(els, cb);
> +}
> +
> +static void
> +efct_els_retry(struct efct_io *els);
> +
> +static void
> +efct_els_delay_timer_cb(struct timer_list *t)
> +{
> +	struct efct_io *els = from_timer(els, t, delay_timer);
> +	struct efc_node *node = els->node;
> +
> +	/* Retry delay timer expired, retry the ELS request,
> +	 * Free the HW IO so that a new oxid is used.
> +	 */
> +	if (els->state == EFCT_ELS_REQUEST_DELAY_ABORT) {
> +		node->els_req_cnt++;
> +		efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL,
> +					    NULL);
> +	} else {
> +		efct_els_retry(els);
> +	}
> +}
> +
> +static void
> +efct_els_abort_cleanup(struct efct_io *els)
> +{
> +	/* handle event for ABORT_WQE
> +	 * whatever state ELS happened to be in, propagate aborted even
> +	 * up to node state machine in lieu of EFC_HW_SRRS_ELS_* event
> +	 */
> +	struct efc_node_cb cbdata;
> +
> +	cbdata.status = 0;
> +	cbdata.ext_status = 0;
> +	cbdata.els_rsp = els->els_rsp;
> +	els_io_printf(els, "Request aborted\n");
> +	efct_els_io_cleanup(els, EFC_HW_ELS_REQ_ABORTED, &cbdata);
> +}
> +
> +static int
> +efct_els_req_cb(struct efct_hw_io *hio, struct efc_remote_node *rnode,
> +		u32 length, int status, u32 ext_status, void *arg)
> +{
> +	struct efct_io *els;
> +	struct efc_node *node;
> +	struct efct *efct;
> +	struct efc_node_cb cbdata;
> +	u32 reason_code;
> +
> +	els = arg;
> +	node = els->node;
> +	efct = node->efc->base;
> +
> +	if (status != 0)
> +		els_io_printf(els, "status x%x ext x%x\n", status, ext_status);
> +
> +	/* set the response len element of els->rsp */
> +	els->els_rsp.len = length;
> +
> +	cbdata.status = status;
> +	cbdata.ext_status = ext_status;
> +	cbdata.header = NULL;
> +	cbdata.els_rsp = els->els_rsp;
> +
> +	/* FW returns the number of bytes received on the link in
> +	 * the WCQE, not the amount placed in the buffer; use this info to
> +	 * check if there was an overrun.
> +	 */
> +	if (length > els->els_rsp.size) {
> +		efc_log_warn(efct,
> +			      "ELS response returned len=%d > buflen=%zu\n",
> +			     length, els->els_rsp.size);
> +		efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL, &cbdata);
> +		return EFC_SUCCESS;
> +	}
> +
> +	/* Post event to ELS IO object */
> +	switch (status) {
> +	case SLI4_FC_WCQE_STATUS_SUCCESS:
> +		efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_OK, &cbdata);
> +		break;
> +
> +	case SLI4_FC_WCQE_STATUS_LS_RJT:
> +		reason_code = (ext_status >> 16) & 0xff;
> +
> +		/* delay and retry if reason code is Logical Busy */
> +		switch (reason_code) {
> +		case ELS_RJT_BUSY:
> +			els->node->els_req_cnt--;
> +			els_io_printf(els,
> +				      "LS_RJT Logical Busy response,delay and retry\n");
> +			timer_setup(&els->delay_timer,
> +				    efct_els_delay_timer_cb, 0);
> +			mod_timer(&els->delay_timer,
> +				  jiffies + msecs_to_jiffies(5000));
> +			els->state = EFCT_ELS_REQUEST_DELAYED;
> +			break;
> +		default:
> +			efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_RJT,
> +					    &cbdata);
> +			break;
> +		}
> +		break;
> +
> +	case SLI4_FC_WCQE_STATUS_LOCAL_REJECT:
> +		switch (ext_status) {
> +		case SLI4_FC_LOCAL_REJECT_SEQUENCE_TIMEOUT:
> +			efct_els_retry(els);
> +			break;
> +
> +		case SLI4_FC_LOCAL_REJECT_ABORT_REQUESTED:
> +			if (els->state == EFCT_ELS_ABORT_IO_COMPL) {
> +				/* completion for ELS that was aborted */
> +				efct_els_abort_cleanup(els);
> +			} else {
> +				/* completion for ELS received first,
> +				 * transition to wait for abort cmpl
> +				 */
> +				els->state = EFCT_ELS_REQ_ABORTED;
> +			}
> +
> +			break;
> +		default:
> +			efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL,
> +					    &cbdata);
> +			break;
> +		}
> +		break;
> +	default:	/* Other error */
> +		efc_log_warn(efct,
> +			      "els req failed status x%x, ext_status, x%x\n",
> +					status, ext_status);
> +		efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL, &cbdata);
> +		break;
> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +static void efct_els_send_req(struct efc_node *node, struct efct_io *els)
> +{
> +	int rc = 0;
> +	struct efct *efct;
> +
> +	efct = node->efc->base;
> +	rc = efct_els_send(els, els->els_req.size,
> +			   els->els_timeout_sec, efct_els_req_cb);
> +
> +	if (rc) {
> +		struct efc_node_cb cbdata;
> +
> +		cbdata.status = INT_MAX;
> +		cbdata.ext_status = INT_MAX;
> +		cbdata.els_rsp = els->els_rsp;
> +		efc_log_err(efct, "efct_els_send failed: %d\n", rc);
> +		efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL,
> +				    &cbdata);
> +	}
> +}
> +
> +static void
> +efct_els_retry(struct efct_io *els)
> +{
> +	struct efct *efct;
> +	struct efc_node_cb cbdata;
> +
> +	efct = els->node->efc->base;
> +	cbdata.status = INT_MAX;
> +	cbdata.ext_status = INT_MAX;
> +	cbdata.els_rsp = els->els_rsp;
> +
> +	if (!els->els_retries_remaining) {
> +		efc_log_err(efct, "ELS retries exhausted\n");
> +		efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL,
> +				    &cbdata);
> +		return;
> +	}
> +
> +	els->els_retries_remaining--;
> +	 /* Free the HW IO so that a new oxid is used.*/
> +	if (els->hio) {
> +		efct_hw_io_free(&efct->hw, els->hio);
> +		els->hio = NULL;
> +	}
> +
> +	efct_els_send_req(els->node, els);
> +}
> +
> +static int
> +efct_els_acc_cb(struct efct_hw_io *hio, struct efc_remote_node *rnode,
> +		u32 length, int status, u32 ext_status, void *arg)
> +{
> +	struct efct_io *els;
> +	struct efc_node *node;
> +	struct efct *efct;
> +	struct efc_node_cb cbdata;
> +
> +	els = arg;
> +	node = els->node;
> +	efct = node->efc->base;
> +
> +	cbdata.status = status;
> +	cbdata.ext_status = ext_status;
> +	cbdata.header = NULL;
> +	cbdata.els_rsp = els->els_rsp;
> +
> +	/* Post node event */
> +	switch (status) {
> +	case SLI4_FC_WCQE_STATUS_SUCCESS:
> +		efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_CMPL_OK, &cbdata);
> +		break;
> +
> +	default:	/* Other error */
> +		efc_log_warn(efct,
> +			      "[%s] %-8s failed status x%x, ext_status x%x\n",
> +			    node->display_name, els->display_name,
> +			    status, ext_status);
> +		efc_log_warn(efct,
> +			      "els acc complete: failed status x%x, ext_status, x%x\n",
> +		     status, ext_status);
> +		efct_els_io_cleanup(els, EFC_HW_SRRS_ELS_CMPL_FAIL, &cbdata);
> +		break;
> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +static int
> +efct_els_send_rsp(struct efct_io *els, u32 rsplen)
> +{
> +	struct efc_node *node = els->node;
> +
> +	/* increment ELS completion counter */
> +	node->els_cmpl_cnt++;
> +
> +	/* move ELS from pending list to active list */
> +	efct_els_make_active(els);
> +
> +	els->wire_len = rsplen;
> +	return efct_scsi_io_dispatch(els, efct_els_acc_cb);
> +}
> +
> +struct efct_io *
> +efct_send_plogi(struct efc_node *node, u32 timeout_sec,
> +		u32 retries,
> +	      void (*cb)(struct efc_node *node,
> +			 struct efc_node_cb *cbdata, void *arg), void *cbarg)
> +{
> +	struct efct_io *els;
> +	struct efct *efct = node->efc->base;
> +	struct fc_els_flogi  *plogi;
> +
> +	node_els_trace();
> +
> +	els = efct_els_io_alloc(node, sizeof(*plogi), EFCT_ELS_ROLE_ORIGINATOR);
> +	if (!els) {
> +		efc_log_err(efct, "IO alloc failed\n");
> +		return els;
> +	}
> +	els->els_timeout_sec = timeout_sec;
> +	els->els_retries_remaining = retries;
> +	els->els_callback = cb;
> +	els->els_callback_arg = cbarg;
> +	els->display_name = "plogi";
> +
> +	/* Build PLOGI request */
> +	plogi = els->els_req.virt;
> +
> +	memcpy(plogi, node->sport->service_params, sizeof(*plogi));
> +
> +	plogi->fl_cmd = ELS_PLOGI;
> +	memset(plogi->_fl_resvd, 0, sizeof(plogi->_fl_resvd));
> +
> +	els->hio_type = EFCT_HW_ELS_REQ;
> +	els->iparam.els.timeout = timeout_sec;
> +
> +	efct_els_send_req(node, els);
> +
> +	return els;
> +}
> +
> +struct efct_io *
> +efct_send_flogi(struct efc_node *node, u32 timeout_sec,
> +		u32 retries, els_cb_t cb, void *cbarg)
> +{
> +	struct efct_io *els;
> +	struct efct *efct;
> +	struct fc_els_flogi  *flogi;
> +
> +	efct = node->efc->base;
> +
> +	node_els_trace();
> +
> +	els = efct_els_io_alloc(node, sizeof(*flogi), EFCT_ELS_ROLE_ORIGINATOR);
> +	if (!els) {
> +		efc_log_err(efct, "IO alloc failed\n");
> +		return els;
> +	}
> +	els->els_timeout_sec = timeout_sec;
> +	els->els_retries_remaining = retries;
> +	els->els_callback = cb;
> +	els->els_callback_arg = cbarg;
> +	els->display_name = "flogi";
> +
> +	/* Build FLOGI request */
> +	flogi = els->els_req.virt;
> +
> +	memcpy(flogi, node->sport->service_params, sizeof(*flogi));
> +	flogi->fl_cmd = ELS_FLOGI;
> +	memset(flogi->_fl_resvd, 0, sizeof(flogi->_fl_resvd));
> +
> +	els->hio_type = EFCT_HW_ELS_REQ;
> +	els->iparam.els.timeout = timeout_sec;
> +
> +	efct_els_send_req(node, els);
> +
> +	return els;
> +}
> +
> +struct efct_io *
> +efct_send_fdisc(struct efc_node *node, u32 timeout_sec,
> +		u32 retries, els_cb_t cb, void *cbarg)
> +{
> +	struct efct_io *els;
> +	struct efct *efct;
> +	struct fc_els_flogi *fdisc;
> +
> +	efct = node->efc->base;
> +
> +	node_els_trace();
> +
> +	els = efct_els_io_alloc(node, sizeof(*fdisc), EFCT_ELS_ROLE_ORIGINATOR);
> +	if (!els) {
> +		efc_log_err(efct, "IO alloc failed\n");
> +		return els;
> +	}
> +	els->els_timeout_sec = timeout_sec;
> +	els->els_retries_remaining = retries;
> +	els->els_callback = cb;
> +	els->els_callback_arg = cbarg;
> +	els->display_name = "fdisc";
> +
> +	/* Build FDISC request */
> +	fdisc = els->els_req.virt;
> +
> +	memcpy(fdisc, node->sport->service_params, sizeof(*fdisc));
> +	fdisc->fl_cmd = ELS_FDISC;
> +	memset(fdisc->_fl_resvd, 0, sizeof(fdisc->_fl_resvd));
> +
> +	els->hio_type = EFCT_HW_ELS_REQ;
> +	els->iparam.els.timeout = timeout_sec;
> +
> +	efct_els_send_req(node, els);
> +
> +	return els;
> +}
> +
> +struct efct_io *
> +efct_send_prli(struct efc_node *node, u32 timeout_sec, u32 retries,
> +	       els_cb_t cb, void *cbarg)
> +{
> +	struct efct *efct = node->efc->base;
> +	struct efct_io *els;
> +	struct {
> +		struct fc_els_prli prli;
> +		struct fc_els_spp spp;
> +	} *pp;
> +
> +	node_els_trace();
> +
> +	els = efct_els_io_alloc(node, sizeof(*pp), EFCT_ELS_ROLE_ORIGINATOR);
> +	if (!els) {
> +		efc_log_err(efct, "IO alloc failed\n");
> +		return els;
> +	}
> +	els->els_timeout_sec = timeout_sec;
> +	els->els_retries_remaining = retries;
> +	els->els_callback = cb;
> +	els->els_callback_arg = cbarg;
> +	els->display_name = "prli";
> +
> +	/* Build PRLI request */
> +	pp = els->els_req.virt;
> +
> +	memset(pp, 0, sizeof(*pp));
> +
> +	pp->prli.prli_cmd = ELS_PRLI;
> +	pp->prli.prli_spp_len = 16;
> +	pp->prli.prli_len = cpu_to_be16(sizeof(*pp));
> +	pp->spp.spp_type = FC_TYPE_FCP;
> +	pp->spp.spp_type_ext = 0;
> +	pp->spp.spp_flags = FC_SPP_EST_IMG_PAIR;
> +	pp->spp.spp_params = cpu_to_be32(FCP_SPPF_RD_XRDY_DIS |
> +			       (node->sport->enable_ini ?
> +			       FCP_SPPF_INIT_FCN : 0) |
> +			       (node->sport->enable_tgt ?
> +			       FCP_SPPF_TARG_FCN : 0));
> +
> +	els->hio_type = EFCT_HW_ELS_REQ;
> +	els->iparam.els.timeout = timeout_sec;
> +
> +	efct_els_send_req(node, els);
> +
> +	return els;
> +}
> +
> +struct efct_io *
> +efct_send_prlo(struct efc_node *node, u32 timeout_sec, u32 retries,
> +	       els_cb_t cb, void *cbarg)
> +{
> +	struct efct *efct = node->efc->base;
> +	struct efct_io *els;
> +	struct {
> +		struct fc_els_prlo prlo;
> +		struct fc_els_spp spp;
> +	} *pp;
> +
> +	node_els_trace();
> +
> +	els = efct_els_io_alloc(node, sizeof(*pp), EFCT_ELS_ROLE_ORIGINATOR);
> +	if (!els) {
> +		efc_log_err(efct, "IO alloc failed\n");
> +		return els;
> +	}
> +	els->els_timeout_sec = timeout_sec;
> +	els->els_retries_remaining = retries;
> +	els->els_callback = cb;
> +	els->els_callback_arg = cbarg;
> +	els->display_name = "prlo";
> +
> +	/* Build PRLO request */
> +	pp = els->els_req.virt;
> +
> +	memset(pp, 0, sizeof(*pp));
> +	pp->prlo.prlo_cmd = ELS_PRLO;
> +	pp->prlo.prlo_obs = 0x10;
> +	pp->prlo.prlo_len = cpu_to_be16(sizeof(*pp));
> +
> +	pp->spp.spp_type = FC_TYPE_FCP;
> +	pp->spp.spp_type_ext = 0;
> +
> +	els->hio_type = EFCT_HW_ELS_REQ;
> +	els->iparam.els.timeout = timeout_sec;
> +
> +	efct_els_send_req(node, els);
> +
> +	return els;
> +}
> +
> +struct efct_io *
> +efct_send_logo(struct efc_node *node, u32 timeout_sec, u32 retries,
> +	       els_cb_t cb, void *cbarg)
> +{
> +	struct efct_io *els;
> +	struct efct *efct;
> +	struct fc_els_logo *logo;
> +	struct fc_els_flogi  *sparams;
> +
> +	efct = node->efc->base;
> +
> +	node_els_trace();
> +
> +	sparams = (struct fc_els_flogi *)node->sport->service_params;
> +
> +	els = efct_els_io_alloc(node, sizeof(*logo), EFCT_ELS_ROLE_ORIGINATOR);
> +	if (!els) {
> +		efc_log_err(efct, "IO alloc failed\n");
> +		return els;
> +	}
> +	els->els_timeout_sec = timeout_sec;
> +	els->els_retries_remaining = retries;
> +	els->els_callback = cb;
> +	els->els_callback_arg = cbarg;
> +	els->display_name = "logo";
> +
> +	/* Build LOGO request */
> +
> +	logo = els->els_req.virt;
> +
> +	memset(logo, 0, sizeof(*logo));
> +	logo->fl_cmd = ELS_LOGO;
> +	hton24(logo->fl_n_port_id, node->rnode.sport->fc_id);
> +	logo->fl_n_port_wwn = sparams->fl_wwpn;
> +
> +	els->hio_type = EFCT_HW_ELS_REQ;
> +	els->iparam.els.timeout = timeout_sec;
> +
> +	efct_els_send_req(node, els);
> +
> +	return els;
> +}
> +
> +struct efct_io *
> +efct_send_adisc(struct efc_node *node, u32 timeout_sec,
> +		u32 retries, els_cb_t cb, void *cbarg)
> +{
> +	struct efct_io *els;
> +	struct efct *efct;
> +	struct fc_els_adisc *adisc;
> +	struct fc_els_flogi  *sparams;
> +	struct efc_sli_port *sport = node->sport;
> +
> +	efct = node->efc->base;
> +
> +	node_els_trace();
> +
> +	sparams = (struct fc_els_flogi *)node->sport->service_params;
> +
> +	els = efct_els_io_alloc(node, sizeof(*adisc), EFCT_ELS_ROLE_ORIGINATOR);
> +	if (!els) {
> +		efc_log_err(efct, "IO alloc failed\n");
> +		return els;
> +	}
> +	els->els_timeout_sec = timeout_sec;
> +	els->els_retries_remaining = retries;
> +	els->els_callback = cb;
> +	els->els_callback_arg = cbarg;
> +	els->display_name = "adisc";
> +
> +	/* Build ADISC request */
> +
> +	adisc = els->els_req.virt;
> +
> +	memset(adisc, 0, sizeof(*adisc));
> +	adisc->adisc_cmd = ELS_ADISC;
> +	hton24(adisc->adisc_hard_addr, sport->fc_id);
> +	adisc->adisc_wwpn = sparams->fl_wwpn;
> +	adisc->adisc_wwnn = sparams->fl_wwnn;
> +	hton24(adisc->adisc_port_id, node->rnode.sport->fc_id);
> +
> +	els->hio_type = EFCT_HW_ELS_REQ;
> +	els->iparam.els.timeout = timeout_sec;
> +
> +	efct_els_send_req(node, els);
> +
> +	return els;
> +}
> +
> +struct efct_io *
> +efct_send_pdisc(struct efc_node *node, u32 timeout_sec,
> +		u32 retries, els_cb_t cb, void *cbarg)
> +{
> +	struct efct_io *els;
> +	struct efct *efct = node->efc->base;
> +	struct fc_els_flogi  *pdisc;
> +
> +	node_els_trace();
> +
> +	els = efct_els_io_alloc(node, sizeof(*pdisc), EFCT_ELS_ROLE_ORIGINATOR);
> +	if (!els) {
> +		efc_log_err(efct, "IO alloc failed\n");
> +		return els;
> +	}
> +	els->els_timeout_sec = timeout_sec;
> +	els->els_retries_remaining = retries;
> +	els->els_callback = cb;
> +	els->els_callback_arg = cbarg;
> +	els->display_name = "pdisc";
> +
> +	pdisc = els->els_req.virt;
> +
> +	memcpy(pdisc, node->sport->service_params, sizeof(*pdisc));
> +
> +	pdisc->fl_cmd = ELS_PDISC;
> +	memset(pdisc->_fl_resvd, 0, sizeof(pdisc->_fl_resvd));
> +
> +	els->hio_type = EFCT_HW_ELS_REQ;
> +	els->iparam.els.timeout = timeout_sec;
> +
> +	efct_els_send_req(node, els);
> +
> +	return els;
> +}
> +
> +struct efct_io *
> +efct_send_scr(struct efc_node *node, u32 timeout_sec, u32 retries,
> +	      els_cb_t cb, void *cbarg)
> +{
> +	struct efct_io *els;
> +	struct efct *efct = node->efc->base;
> +	struct fc_els_scr *req;
> +
> +	node_els_trace();
> +
> +	els = efct_els_io_alloc(node, sizeof(*req), EFCT_ELS_ROLE_ORIGINATOR);
> +	if (!els) {
> +		efc_log_err(efct, "IO alloc failed\n");
> +		return els;
> +	}
> +
> +	els->els_timeout_sec = timeout_sec;
> +	els->els_retries_remaining = retries;
> +	els->els_callback = cb;
> +	els->els_callback_arg = cbarg;
> +	els->display_name = "scr";
> +
> +	req = els->els_req.virt;
> +
> +	memset(req, 0, sizeof(*req));
> +	req->scr_cmd = ELS_SCR;
> +	req->scr_reg_func = ELS_SCRF_FULL;
> +
> +	els->hio_type = EFCT_HW_ELS_REQ;
> +	els->iparam.els.timeout = timeout_sec;
> +
> +	efct_els_send_req(node, els);
> +
> +	return els;
> +}
> +
> +struct efct_io *
> +efct_send_rscn(struct efc_node *node, u32 timeout_sec, u32 retries,
> +	       void *port_ids, u32 port_ids_count, els_cb_t cb, void *cbarg)
> +{
> +	struct efct_io *els;
> +	struct efct *efct = node->efc->base;
> +	struct fc_els_rscn *req;
> +	struct fc_els_rscn_page *rscn_page;
> +	u32 length = sizeof(*rscn_page) * port_ids_count;
> +
> +	length += sizeof(*req);
> +
> +	node_els_trace();
> +
> +	els = efct_els_io_alloc(node, length, EFCT_ELS_ROLE_ORIGINATOR);
> +	if (!els) {
> +		efc_log_err(efct, "IO alloc failed\n");
> +		return els;
> +	}
> +	els->els_timeout_sec = timeout_sec;
> +	els->els_retries_remaining = retries;
> +	els->els_callback = cb;
> +	els->els_callback_arg = cbarg;
> +	els->display_name = "rscn";
> +
> +	req = els->els_req.virt;
> +
> +	req->rscn_cmd = ELS_RSCN;
> +	req->rscn_page_len = sizeof(struct fc_els_rscn_page);
> +	req->rscn_plen = cpu_to_be16(length);
> +
> +	els->hio_type = EFCT_HW_ELS_REQ;
> +	els->iparam.els.timeout = timeout_sec;
> +
> +	/* copy in the payload */
> +	rscn_page = els->els_req.virt + sizeof(*req);
> +	memcpy(rscn_page, port_ids,
> +	       port_ids_count * sizeof(*rscn_page));
> +
> +	efct_els_send_req(node, els);
> + > +	return els;
> +}
> +
> +void *
> +efct_send_ls_rjt(struct efc *efc, struct efc_node *node,
> +		 u32 ox_id, u32 reason_code,
> +		u32 reason_code_expl, u32 vendor_unique)
> +{
> +	struct efct_io *io = NULL;
> +	int rc;
> +	struct efct *efct = node->efc->base;
> +	struct fc_els_ls_rjt *rjt;
> +
> +	io = efct_els_io_alloc(node, sizeof(*rjt), EFCT_ELS_ROLE_RESPONDER);
> +	if (!io) {
> +		efc_log_err(efct, "els IO alloc failed\n");
> +		return io;
> +	}
> +
> +	node_els_trace();
> +
> +	io->els_callback = NULL;
> +	io->els_callback_arg = NULL;
> +	io->display_name = "ls_rjt";
> +	io->init_task_tag = ox_id;
> +
> +	memset(&io->iparam, 0, sizeof(io->iparam));
> +	io->iparam.els.ox_id = ox_id;
> +
> +	rjt = io->els_req.virt;
> +	memset(rjt, 0, sizeof(*rjt));
> +
> +	rjt->er_cmd = ELS_LS_RJT;
> +	rjt->er_reason = reason_code;
> +	rjt->er_explan = reason_code_expl;
> +
> +	io->hio_type = EFCT_HW_ELS_RSP;
> +	rc = efct_els_send_rsp(io, sizeof(*rjt));
> +	if (rc) {
> +		efct_els_io_free(io);
> +		io = NULL;
> +	}
> +
> +	return io;
> +}
> +
That is a bit strange.
Sending a response can fail, but (apparently) sending a request cannot; 
at the very least you don't have (or check) the return value from the 
send request.

Some intricate scheme I've missed?


Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

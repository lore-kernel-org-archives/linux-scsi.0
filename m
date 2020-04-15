Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC707C2BA19
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 19:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 842BB20771
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 19:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441070AbgDOTIa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 15:08:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:39686 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1416886AbgDOS4K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 14:56:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D46A3AC79;
        Wed, 15 Apr 2020 18:56:03 +0000 (UTC)
Date:   Wed, 15 Apr 2020 20:56:03 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v3 14/31] elx: libefc: FC node ELS and state handling
Message-ID: <20200415185603.hoaap564jde4v6bt@carbon>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-15-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200412033303.29574-15-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Apr 11, 2020 at 08:32:46PM -0700, James Smart wrote:
> This patch continues the libefc library population.
> 
> This patch adds library interface definitions for:
> - FC node PRLI handling and state management
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>   Replace efc_assert with WARN_ON
>   Bug Fix: Send LS_RJT for non FCP PRLIs
> ---
>  drivers/scsi/elx/libefc/efc_device.c | 1672 ++++++++++++++++++++++++++++++++++
>  drivers/scsi/elx/libefc/efc_device.h |   72 ++
>  2 files changed, 1744 insertions(+)
>  create mode 100644 drivers/scsi/elx/libefc/efc_device.c
>  create mode 100644 drivers/scsi/elx/libefc/efc_device.h
> 
> diff --git a/drivers/scsi/elx/libefc/efc_device.c b/drivers/scsi/elx/libefc/efc_device.c
> new file mode 100644
> index 000000000000..e279a6dd19fa
> --- /dev/null
> +++ b/drivers/scsi/elx/libefc/efc_device.c
> @@ -0,0 +1,1672 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +/*
> + * device_sm Node State Machine: Remote Device States
> + */
> +
> +#include "efc.h"
> +#include "efc_device.h"
> +#include "efc_fabric.h"
> +
> +void
> +efc_d_send_prli_rsp(struct efc_node *node, uint16_t ox_id)
> +{
> +	struct efc *efc = node->efc;
> +	/* If the back-end doesn't want to talk to this initiator,
> +	 * we send an LS_RJT
> +	 */
> +	if (node->sport->enable_tgt &&
> +	    (efc->tt.scsi_validate_node(efc, node) == 0)) {
> +		node_printf(node, "PRLI rejected by target-server\n");
> +
> +		efc->tt.send_ls_rjt(efc, node, ox_id,
> +				    ELS_RJT_UNAB, ELS_EXPL_NONE, 0);
> +		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
> +		efc_node_transition(node, __efc_d_initiate_shutdown, NULL);
> +	} else {
> +		/*
> +		 * sm: / process PRLI payload, send PRLI acc
> +		 */
> +		efc->tt.els_send_resp(efc, node, ELS_PRLI, ox_id);
> +
> +		/* Immediately go to ready state to avoid window where we're
> +		 * waiting for the PRLI LS_ACC to complete while holding
> +		 * FCP_CMNDs
> +		 */
> +		efc_node_transition(node, __efc_d_device_ready, NULL);
> +	}
> +}
> +
> +static void *
> +__efc_d_common(const char *funcname, struct efc_sm_ctx *ctx,
> +	       enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_node *node = NULL;
> +	struct efc *efc = NULL;
> +
> +	node = ctx->app;
> +	efc = node->efc;
> +
> +	switch (evt) {
> +	/* Handle shutdown events */
> +	case EFC_EVT_SHUTDOWN:
> +		efc_log_debug(efc, "[%s] %-20s %-20s\n", node->display_name,
> +			      funcname, efc_sm_event_name(evt));
> +		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
> +		efc_node_transition(node, __efc_d_initiate_shutdown, NULL);
> +		break;
> +	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
> +		efc_log_debug(efc, "[%s] %-20s %-20s\n",
> +			      node->display_name, funcname,
> +				efc_sm_event_name(evt));
> +		node->shutdown_reason = EFC_NODE_SHUTDOWN_EXPLICIT_LOGO;
> +		efc_node_transition(node, __efc_d_initiate_shutdown, NULL);
> +		break;
> +	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
> +		efc_log_debug(efc, "[%s] %-20s %-20s\n", node->display_name,
> +			      funcname, efc_sm_event_name(evt));
> +		node->shutdown_reason = EFC_NODE_SHUTDOWN_IMPLICIT_LOGO;
> +		efc_node_transition(node, __efc_d_initiate_shutdown, NULL);
> +		break;
> +
> +	default:
> +		/* call default event handler common to all nodes */
> +		__efc_node_common(funcname, ctx, evt, arg);
> +		break;
> +	}
> +	return NULL;
> +}
> +
> +/**
> + * State is entered when a node sends a delete initiator/target call to the
> + * target-server/initiator-client and needs to wait for that work to complete.
> + */
> +static void *
> +__efc_d_wait_del_node(struct efc_sm_ctx *ctx,
> +		      enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_node *node = ctx->app;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER:
> +		efc_node_hold_frames(node);
> +		/* Fall through */

		fallthrough;

> +
> +	case EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY:
> +	case EFC_EVT_ALL_CHILD_NODES_FREE:
> +		/* These are expected events. */
> +		break;
> +
> +	case EFC_EVT_NODE_DEL_INI_COMPLETE:
> +	case EFC_EVT_NODE_DEL_TGT_COMPLETE:
> +		/*
> +		 * node has either been detached or is in the process
> +		 * of being detached,
> +		 * call common node's initiate cleanup function
> +		 */
> +		efc_node_initiate_cleanup(node);
> +		break;
> +
> +	case EFC_EVT_EXIT:
> +		efc_node_accept_frames(node);
> +		break;
> +
> +	case EFC_EVT_SRRS_ELS_REQ_FAIL:
> +		/* Can happen as ELS IO IO's complete */
> +		WARN_ON(!node->els_req_cnt);
> +		node->els_req_cnt--;
> +		break;
> +
> +	/* ignore shutdown events as we're already in shutdown path */
> +	case EFC_EVT_SHUTDOWN:
> +		/* have default shutdown event take precedence */
> +		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
> +		/* fall through */

		fallthrough;

> +	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
> +	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
> +		node_printf(node, "%s received\n", efc_sm_event_name(evt));
> +		break;
> +	case EFC_EVT_DOMAIN_ATTACH_OK:
> +		/* don't care about domain_attach_ok */
> +		break;
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +
> +	return NULL;
> +}
> +
> +static void *
> +__efc_d_wait_del_ini_tgt(struct efc_sm_ctx *ctx,
> +			 enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_node *node = ctx->app;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER:
> +		efc_node_hold_frames(node);
> +		/* Fall through */
> +
> +	case EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY:
> +	case EFC_EVT_ALL_CHILD_NODES_FREE:
> +		/* These are expected events. */
> +		break;
> +
> +	case EFC_EVT_NODE_DEL_INI_COMPLETE:
> +	case EFC_EVT_NODE_DEL_TGT_COMPLETE:
> +		efc_node_transition(node, __efc_d_wait_del_node, NULL);
> +		break;
> +
> +	case EFC_EVT_EXIT:
> +		efc_node_accept_frames(node);
> +		break;
> +
> +	case EFC_EVT_SRRS_ELS_REQ_FAIL:
> +		/* Can happen as ELS IO IO's complete */
> +		WARN_ON(!node->els_req_cnt);
> +		node->els_req_cnt--;
> +		break;
> +
> +	/* ignore shutdown events as we're already in shutdown path */
> +	case EFC_EVT_SHUTDOWN:
> +		/* have default shutdown event take precedence */
> +		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
> +		/* fall through */
> +	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
> +	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
> +		node_printf(node, "%s received\n", efc_sm_event_name(evt));
> +		break;
> +	case EFC_EVT_DOMAIN_ATTACH_OK:
> +		/* don't care about domain_attach_ok */
> +		break;
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +
> +	return NULL;
> +}
> +
> +void *
> +__efc_d_initiate_shutdown(struct efc_sm_ctx *ctx,
> +			  enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_node *node = ctx->app;
> +	struct efc *efc = node->efc;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER: {
> +		/* assume no wait needed */
> +		int rc = EFC_SCSI_CALL_COMPLETE;
> +
> +		efc->tt.scsi_io_alloc_disable(efc, node);
> +
> +		/* make necessary delete upcall(s) */
> +		if (node->init && !node->targ) {
> +			efc_log_info(node->efc,
> +				     "[%s] delete (initiator) WWPN %s WWNN %s\n",
> +				node->display_name,
> +				node->wwpn, node->wwnn);
> +			efc_node_transition(node,
> +					    __efc_d_wait_del_node,
> +					     NULL);
> +			if (node->sport->enable_tgt)
> +				rc = efc->tt.scsi_del_node(efc, node,
> +					EFC_SCSI_INITIATOR_DELETED);
> +
> +			if (rc == EFC_SCSI_CALL_COMPLETE)
> +				efc_node_post_event(node,
> +					EFC_EVT_NODE_DEL_INI_COMPLETE, NULL);
> +
> +		} else if (node->targ && !node->init) {
> +			efc_log_info(node->efc,
> +				     "[%s] delete (target) WWPN %s WWNN %s\n",
> +				node->display_name,
> +				node->wwpn, node->wwnn);
> +			efc_node_transition(node,
> +					    __efc_d_wait_del_node,
> +					     NULL);
> +			if (node->sport->enable_ini)
> +				rc = efc->tt.scsi_del_node(efc, node,
> +					EFC_SCSI_TARGET_DELETED);
> +
> +			if (rc == EFC_SCSI_CALL_COMPLETE)
> +				efc_node_post_event(node,
> +					EFC_EVT_NODE_DEL_TGT_COMPLETE, NULL);
> +
> +		} else if (node->init && node->targ) {
> +			efc_log_info(node->efc,
> +				     "[%s] delete (I+T) WWPN %s WWNN %s\n",
> +				node->display_name, node->wwpn, node->wwnn);
> +			efc_node_transition(node, __efc_d_wait_del_ini_tgt,
> +					    NULL);
> +			if (node->sport->enable_tgt)
> +				rc = efc->tt.scsi_del_node(efc, node,
> +						EFC_SCSI_INITIATOR_DELETED);
> +
> +			if (rc == EFC_SCSI_CALL_COMPLETE)
> +				efc_node_post_event(node,
> +					EFC_EVT_NODE_DEL_INI_COMPLETE, NULL);
> +			/* assume no wait needed */
> +			rc = EFC_SCSI_CALL_COMPLETE;
> +			if (node->sport->enable_ini)
> +				rc = efc->tt.scsi_del_node(efc, node,
> +						EFC_SCSI_TARGET_DELETED);
> +
> +			if (rc == EFC_SCSI_CALL_COMPLETE)
> +				efc_node_post_event(node,
> +					EFC_EVT_NODE_DEL_TGT_COMPLETE, NULL);
> +		}
> +
> +		/* we've initiated the upcalls as needed, now kick off the node
> +		 * detach to precipitate the aborting of outstanding exchanges
> +		 * associated with said node
> +		 *
> +		 * Beware: if we've made upcall(s), we've already transitioned
> +		 * to a new state by the time we execute this.
> +		 * consider doing this before the upcalls?
> +		 */
> +		if (node->attached) {
> +			/* issue hw node free; don't care if succeeds right
> +			 * away or sometime later, will check node->attached
> +			 * later in shutdown process
> +			 */
> +			rc = efc->tt.hw_node_detach(efc, &node->rnode);
> +			if (rc != EFC_HW_RTN_SUCCESS &&
> +			    rc != EFC_HW_RTN_SUCCESS_SYNC)
> +				node_printf(node,
> +					    "Failed freeing HW node, rc=%d\n",
> +					rc);
> +		}
> +
> +		/* if neither initiator nor target, proceed to cleanup */
> +		if (!node->init && !node->targ) {
> +			/*
> +			 * node has either been detached or is in
> +			 * the process of being detached,
> +			 * call common node's initiate cleanup function
> +			 */
> +			efc_node_initiate_cleanup(node);
> +		}
> +		break;
> +	}
> +	case EFC_EVT_ALL_CHILD_NODES_FREE:
> +		/* Ignore, this can happen if an ELS is
> +		 * aborted while in a delay/retry state
> +		 */
> +		break;
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +	return NULL;
> +}
> +
> +void *
> +__efc_d_wait_loop(struct efc_sm_ctx *ctx,
> +		  enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_node *node = ctx->app;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER:
> +		efc_node_hold_frames(node);
> +		break;
> +
> +	case EFC_EVT_EXIT:
> +		efc_node_accept_frames(node);
> +		break;
> +
> +	case EFC_EVT_DOMAIN_ATTACH_OK: {
> +		/* send PLOGI automatically if initiator */
> +		efc_node_init_device(node, true);
> +		break;
> +	}
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +
> +	return NULL;
> +}
> +
> +/* Save the OX_ID for sending LS_ACC sometime later */
> +void
> +efc_send_ls_acc_after_attach(struct efc_node *node,
> +			     struct fc_frame_header *hdr,
> +			     enum efc_node_send_ls_acc ls)
> +{
> +	u16 ox_id = be16_to_cpu(hdr->fh_ox_id);
> +
> +	WARN_ON(node->send_ls_acc != EFC_NODE_SEND_LS_ACC_NONE);
> +
> +	node->ls_acc_oxid = ox_id;
> +	node->send_ls_acc = ls;
> +	node->ls_acc_did = ntoh24(hdr->fh_d_id);
> +}
> +
> +void
> +efc_process_prli_payload(struct efc_node *node, void *prli)
> +{
> +	struct fc_els_spp *sp = prli + sizeof(struct fc_els_prli);
> +
> +	node->init = (sp->spp_flags & FCP_SPPF_INIT_FCN) != 0;
> +	node->targ = (sp->spp_flags & FCP_SPPF_TARG_FCN) != 0;
> +}
> +
> +void *
> +__efc_d_wait_plogi_acc_cmpl(struct efc_sm_ctx *ctx,
> +			    enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_node *node = ctx->app;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER:
> +		efc_node_hold_frames(node);
> +		break;
> +
> +	case EFC_EVT_EXIT:
> +		efc_node_accept_frames(node);
> +		break;
> +
> +	case EFC_EVT_SRRS_ELS_CMPL_FAIL:
> +		WARN_ON(!node->els_cmpl_cnt);
> +		node->els_cmpl_cnt--;
> +		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
> +		efc_node_transition(node, __efc_d_initiate_shutdown, NULL);
> +		break;
> +
> +	case EFC_EVT_SRRS_ELS_CMPL_OK:	/* PLOGI ACC completions */
> +		WARN_ON(!node->els_cmpl_cnt);
> +		node->els_cmpl_cnt--;
> +		efc_node_transition(node, __efc_d_port_logged_in, NULL);
> +		break;
> +
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +
> +	return NULL;
> +}
> +
> +void *
> +__efc_d_wait_logo_rsp(struct efc_sm_ctx *ctx,
> +		      enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_node *node = ctx->app;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER:
> +		efc_node_hold_frames(node);
> +		break;
> +
> +	case EFC_EVT_EXIT:
> +		efc_node_accept_frames(node);
> +		break;
> +
> +	case EFC_EVT_SRRS_ELS_REQ_OK:
> +	case EFC_EVT_SRRS_ELS_REQ_RJT:
> +	case EFC_EVT_SRRS_ELS_REQ_FAIL:
> +		/* LOGO response received, sent shutdown */
> +		if (efc_node_check_els_req(ctx, evt, arg, ELS_LOGO,
> +					   __efc_d_common, __func__))
> +			return NULL;
> +
> +		WARN_ON(!node->els_req_cnt);
> +		node->els_req_cnt--;
> +		node_printf(node,
> +			    "LOGO sent (evt=%s), shutdown node\n",
> +			efc_sm_event_name(evt));
> +		/* sm: / post explicit logout */
> +		efc_node_post_event(node, EFC_EVT_SHUTDOWN_EXPLICIT_LOGO,
> +				    NULL);
> +		break;
> +
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +	return NULL;
> +}
> +
> +void
> +efc_node_init_device(struct efc_node *node, bool send_plogi)
> +{
> +	node->send_plogi = send_plogi;
> +	if ((node->efc->nodedb_mask & EFC_NODEDB_PAUSE_NEW_NODES) &&
> +	    (node->rnode.fc_id != FC_FID_DOM_MGR)) {
> +		node->nodedb_state = __efc_d_init;
> +		efc_node_transition(node, __efc_node_paused, NULL);
> +	} else {
> +		efc_node_transition(node, __efc_d_init, NULL);
> +	}
> +}
> +
> +/**
> + * Device node state machine: Initial node state for an initiator or
> + * a target.
> + *
> + * This state is entered when a node is instantiated, either having been
> + * discovered from a name services query, or having received a PLOGI/FLOGI.
> + */
> +void *
> +__efc_d_init(struct efc_sm_ctx *ctx, enum efc_sm_event evt, void *arg)
> +{
> +	int rc;
> +	struct efc_node_cb *cbdata = arg;
> +	struct efc_node *node = ctx->app;
> +	struct efc *efc = node->efc;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER:
> +		if (!node->send_plogi)
> +			break;
> +		/* only send if we have initiator capability,
> +		 * and domain is attached
> +		 */
> +		if (node->sport->enable_ini &&
> +		    node->sport->domain->attached) {
> +			efc->tt.els_send(efc, node, ELS_PLOGI,
> +				EFC_FC_FLOGI_TIMEOUT_SEC,
> +				EFC_FC_ELS_DEFAULT_RETRIES);
> +
> +			efc_node_transition(node, __efc_d_wait_plogi_rsp, NULL);
> +		} else {
> +			node_printf(node, "not sending plogi sport.ini=%d,",
> +				    node->sport->enable_ini);
> +			node_printf(node, "domain attached=%d\n",
> +				    node->sport->domain->attached);
> +		}
> +		break;
> +	case EFC_EVT_PLOGI_RCVD: {
> +		/* T, or I+T */
> +		struct fc_frame_header *hdr = cbdata->header->dma.virt;
> +		u32 d_id = ntoh24(hdr->fh_d_id);
> +
> +		efc_node_save_sparms(node, cbdata->payload->dma.virt);
> +		efc_send_ls_acc_after_attach(node,
> +					     cbdata->header->dma.virt,
> +					     EFC_NODE_SEND_LS_ACC_PLOGI);
> +
> +		/* domain already attached */
> +		if (node->sport->domain->attached) {
> +			rc = efc_node_attach(node);
> +			efc_node_transition(node,
> +					    __efc_d_wait_node_attach, NULL);
> +			if (rc == EFC_HW_RTN_SUCCESS_SYNC) {
> +				efc_node_post_event(node,
> +						    EFC_EVT_NODE_ATTACH_OK,
> +						    NULL);
> +			}
> +			break;
> +		}
> +
> +		/* domain not attached; several possibilities: */
> +		switch (node->sport->topology) {

This substate machine should go into a new function.

> +		case EFC_SPORT_TOPOLOGY_P2P:
> +			/* we're not attached and sport is p2p,
> +			 * need to attach
> +			 */
> +			efc_domain_attach(node->sport->domain, d_id);
> +			efc_node_transition(node,
> +					    __efc_d_wait_domain_attach,
> +					    NULL);
> +			break;
> +		case EFC_SPORT_TOPOLOGY_FABRIC:
> +			/* we're not attached and sport is fabric, domain
> +			 * attach should have already been requested as part
> +			 * of the fabric state machine, wait for it
> +			 */
> +			efc_node_transition(node, __efc_d_wait_domain_attach,
> +					    NULL);
> +			break;
> +		case EFC_SPORT_TOPOLOGY_UNKNOWN:
> +			/* Two possibilities:
> +			 * 1. received a PLOGI before our FLOGI has completed
> +			 *    (possible since completion comes in on another
> +			 *    CQ), thus we don't know what we're connected to
> +			 *    yet; transition to a state to wait for the
> +			 *    fabric node to tell us;
> +			 * 2. PLOGI received before link went down and we
> +			 * haven't performed domain attach yet.
> +			 * Note: we cannot distinguish between 1. and 2.
> +			 * so have to assume PLOGI
> +			 * was received after link back up.
> +			 */
> +			node_printf(node,
> +				    "received PLOGI, unknown topology did=0x%x\n",
> +				d_id);
> +			efc_node_transition(node,
> +					    __efc_d_wait_topology_notify,
> +					    NULL);
> +			break;
> +		default:
> +			node_printf(node,
> +				    "received PLOGI, with unexpected topology %d\n",
> +				node->sport->topology);
> +			break;
> +		}
> +		break;
> +	}
> +
> +	case EFC_EVT_FDISC_RCVD: {
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		break;
> +	}
> +
> +	case EFC_EVT_FLOGI_RCVD: {
> +		struct fc_frame_header *hdr = cbdata->header->dma.virt;
> +		u32 d_id = ntoh24(hdr->fh_d_id);
> +
> +		/* sm: / save sparams, send FLOGI acc */
> +		memcpy(node->sport->domain->flogi_service_params,
> +		       cbdata->payload->dma.virt,
> +		       sizeof(struct fc_els_flogi));
> +
> +		/* send FC LS_ACC response, override s_id */
> +		efc_fabric_set_topology(node, EFC_SPORT_TOPOLOGY_P2P);
> +		efc->tt.send_flogi_p2p_acc(efc, node,
> +				be16_to_cpu(hdr->fh_ox_id), d_id);
> +		if (efc_p2p_setup(node->sport)) {
> +			node_printf(node,
> +				    "p2p setup failed, shutting down node\n");
> +			efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
> +		} else {
> +			efc_node_transition(node,
> +					    __efc_p2p_wait_flogi_acc_cmpl,
> +					    NULL);
> +		}
> +
> +		break;
> +	}
> +
> +	case EFC_EVT_LOGO_RCVD: {
> +		struct fc_frame_header *hdr = cbdata->header->dma.virt;
> +
> +		if (!node->sport->domain->attached) {
> +			/* most likely a frame left over from before a link
> +			 * down; drop and
> +			 * shut node down w/ "explicit logout" so pending
> +			 * frames are processed
> +			 */
> +			node_printf(node, "%s domain not attached, dropping\n",
> +				    efc_sm_event_name(evt));
> +			efc_node_post_event(node,
> +					    EFC_EVT_SHUTDOWN_EXPLICIT_LOGO,
> +					    NULL);
> +			break;
> +		}
> +		efc->tt.els_send_resp(efc, node, ELS_LOGO,
> +					be16_to_cpu(hdr->fh_ox_id));
> +		efc_node_transition(node, __efc_d_wait_logo_acc_cmpl, NULL);
> +		break;
> +	}
> +
> +	case EFC_EVT_PRLI_RCVD:
> +	case EFC_EVT_PRLO_RCVD:
> +	case EFC_EVT_PDISC_RCVD:
> +	case EFC_EVT_ADISC_RCVD:
> +	case EFC_EVT_RSCN_RCVD: {
> +		struct fc_frame_header *hdr = cbdata->header->dma.virt;
> +
> +		if (!node->sport->domain->attached) {
> +			/* most likely a frame left over from before a link
> +			 * down; drop and shut node down w/ "explicit logout"
> +			 * so pending frames are processed
> +			 */
> +			node_printf(node, "%s domain not attached, dropping\n",
> +				    efc_sm_event_name(evt));
> +
> +			efc_node_post_event(node,
> +					    EFC_EVT_SHUTDOWN_EXPLICIT_LOGO,
> +					    NULL);
> +			break;
> +		}
> +		node_printf(node, "%s received, sending reject\n",
> +			    efc_sm_event_name(evt));
> +		efc->tt.send_ls_rjt(efc, node, be16_to_cpu(hdr->fh_ox_id),
> +				    ELS_RJT_UNAB, ELS_EXPL_PLOGI_REQD, 0);
> +
> +		break;
> +	}
> +
> +	case EFC_EVT_FCP_CMD_RCVD: {
> +		/* note: problem, we're now expecting an ELS REQ completion
> +		 * from both the LOGO and PLOGI
> +		 */
> +		if (!node->sport->domain->attached) {
> +			/* most likely a frame left over from before a
> +			 * link down; drop and
> +			 * shut node down w/ "explicit logout" so pending
> +			 * frames are processed
> +			 */
> +			node_printf(node, "%s domain not attached, dropping\n",
> +				    efc_sm_event_name(evt));
> +			efc_node_post_event(node,
> +					    EFC_EVT_SHUTDOWN_EXPLICIT_LOGO,
> +					    NULL);
> +			break;
> +		}
> +
> +		/* Send LOGO */
> +		node_printf(node, "FCP_CMND received, send LOGO\n");
> +		if (efc->tt.els_send(efc, node, ELS_LOGO,
> +				     EFC_FC_FLOGI_TIMEOUT_SEC,
> +			EFC_FC_ELS_DEFAULT_RETRIES) == NULL) {
> +			/*
> +			 * failed to send LOGO, go ahead and cleanup node
> +			 * anyways
> +			 */
> +			node_printf(node, "Failed to send LOGO\n");
> +			efc_node_post_event(node,
> +					    EFC_EVT_SHUTDOWN_EXPLICIT_LOGO,
> +					    NULL);
> +		} else {
> +			/* sent LOGO, wait for response */
> +			efc_node_transition(node,
> +					    __efc_d_wait_logo_rsp, NULL);
> +		}
> +		break;
> +	}
> +	case EFC_EVT_DOMAIN_ATTACH_OK:
> +		/* don't care about domain_attach_ok */
> +		break;
> +
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +
> +	return NULL;
> +}
> +
> +void *
> +__efc_d_wait_plogi_rsp(struct efc_sm_ctx *ctx,
> +		       enum efc_sm_event evt, void *arg)
> +{
> +	int rc;
> +	struct efc_node_cb *cbdata = arg;
> +	struct efc_node *node = ctx->app;
> +	struct efc *efc = node->efc;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_PLOGI_RCVD: {
> +		/* T, or I+T */
> +		/* received PLOGI with svc parms, go ahead and attach node
> +		 * when PLOGI that was sent ultimately completes, it'll be a
> +		 * no-op
> +		 *
> +		 * If there is an outstanding PLOGI sent, can we set a flag
> +		 * to indicate that we don't want to retry it if it times out?
> +		 */
> +		efc_node_save_sparms(node, cbdata->payload->dma.virt);
> +		efc_send_ls_acc_after_attach(node,
> +					     cbdata->header->dma.virt,
> +				EFC_NODE_SEND_LS_ACC_PLOGI);
> +		/* sm: domain->attached / efc_node_attach */
> +		rc = efc_node_attach(node);
> +		efc_node_transition(node, __efc_d_wait_node_attach, NULL);
> +		if (rc == EFC_HW_RTN_SUCCESS_SYNC)
> +			efc_node_post_event(node,
> +					    EFC_EVT_NODE_ATTACH_OK, NULL);
> +
> +		break;
> +	}
> +
> +	case EFC_EVT_PRLI_RCVD:
> +		/* I, or I+T */
> +		/* sent PLOGI and before completion was seen, received the
> +		 * PRLI from the remote node (WCQEs and RCQEs come in on
> +		 * different queues and order of processing cannot be assumed)
> +		 * Save OXID so PRLI can be sent after the attach and continue
> +		 * to wait for PLOGI response
> +		 */
> +		efc_process_prli_payload(node, cbdata->payload->dma.virt);
> +		efc_send_ls_acc_after_attach(node,
> +					     cbdata->header->dma.virt,
> +				EFC_NODE_SEND_LS_ACC_PRLI);
> +		efc_node_transition(node, __efc_d_wait_plogi_rsp_recvd_prli,
> +				    NULL);
> +		break;
> +
> +	case EFC_EVT_LOGO_RCVD: /* why don't we do a shutdown here?? */
> +	case EFC_EVT_PRLO_RCVD:
> +	case EFC_EVT_PDISC_RCVD:
> +	case EFC_EVT_FDISC_RCVD:
> +	case EFC_EVT_ADISC_RCVD:
> +	case EFC_EVT_RSCN_RCVD:
> +	case EFC_EVT_SCR_RCVD: {
> +		struct fc_frame_header *hdr = cbdata->header->dma.virt;
> +
> +		node_printf(node, "%s received, sending reject\n",
> +			    efc_sm_event_name(evt));
> +
> +		efc->tt.send_ls_rjt(efc, node, be16_to_cpu(hdr->fh_ox_id),
> +				    ELS_RJT_UNAB, ELS_EXPL_PLOGI_REQD, 0);
> +
> +		break;
> +	}
> +
> +	case EFC_EVT_SRRS_ELS_REQ_OK:	/* PLOGI response received */
> +		/* Completion from PLOGI sent */
> +		if (efc_node_check_els_req(ctx, evt, arg, ELS_PLOGI,
> +					   __efc_d_common, __func__))
> +			return NULL;
> +
> +		WARN_ON(!node->els_req_cnt);
> +		node->els_req_cnt--;
> +		/* sm: / save sparams, efc_node_attach */
> +		efc_node_save_sparms(node, cbdata->els_rsp.virt);
> +		rc = efc_node_attach(node);
> +		efc_node_transition(node, __efc_d_wait_node_attach, NULL);
> +		if (rc == EFC_HW_RTN_SUCCESS_SYNC)
> +			efc_node_post_event(node,
> +					    EFC_EVT_NODE_ATTACH_OK, NULL);
> +
> +		break;
> +
> +	case EFC_EVT_SRRS_ELS_REQ_FAIL:	/* PLOGI response received */
> +		/* PLOGI failed, shutdown the node */
> +		if (efc_node_check_els_req(ctx, evt, arg, ELS_PLOGI,
> +					   __efc_d_common, __func__))
> +			return NULL;
> +
> +		WARN_ON(!node->els_req_cnt);
> +		node->els_req_cnt--;
> +		efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
> +		break;
> +
> +	case EFC_EVT_SRRS_ELS_REQ_RJT:
> +		/* Our PLOGI was rejected, this is ok in some cases */
> +		if (efc_node_check_els_req(ctx, evt, arg, ELS_PLOGI,
> +					   __efc_d_common, __func__))
> +			return NULL;
> +
> +		WARN_ON(!node->els_req_cnt);
> +		node->els_req_cnt--;
> +		break;
> +
> +	case EFC_EVT_FCP_CMD_RCVD: {
> +		/* not logged in yet and outstanding PLOGI so don't send LOGO,
> +		 * just drop
> +		 */
> +		node_printf(node, "FCP_CMND received, drop\n");
> +		break;
> +	}
> +
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +
> +	return NULL;
> +}
> +
> +void *
> +__efc_d_wait_plogi_rsp_recvd_prli(struct efc_sm_ctx *ctx,
> +				  enum efc_sm_event evt, void *arg)
> +{
> +	int rc;
> +	struct efc_node_cb *cbdata = arg;
> +	struct efc_node *node = ctx->app;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER:
> +		/*
> +		 * Since we've received a PRLI, we have a port login and will
> +		 * just need to wait for the PLOGI response to do the node
> +		 * attach and then we can send the LS_ACC for the PRLI. If,
> +		 * during this time, we receive FCP_CMNDs (which is possible
> +		 * since we've already sent a PRLI and our peer may have
> +		 * accepted). At this time, we are not waiting on any other
> +		 * unsolicited frames to continue with the login process. Thus,
> +		 * it will not hurt to hold frames here.
> +		 */
> +		efc_node_hold_frames(node);
> +		break;
> +
> +	case EFC_EVT_EXIT:
> +		efc_node_accept_frames(node);
> +		break;
> +
> +	case EFC_EVT_SRRS_ELS_REQ_OK:	/* PLOGI response received */
> +		/* Completion from PLOGI sent */
> +		if (efc_node_check_els_req(ctx, evt, arg, ELS_PLOGI,
> +					   __efc_d_common, __func__))
> +			return NULL;
> +
> +		WARN_ON(!node->els_req_cnt);
> +		node->els_req_cnt--;
> +		/* sm: / save sparams, efc_node_attach */
> +		efc_node_save_sparms(node, cbdata->els_rsp.virt);
> +		rc = efc_node_attach(node);
> +		efc_node_transition(node, __efc_d_wait_node_attach, NULL);
> +		if (rc == EFC_HW_RTN_SUCCESS_SYNC)
> +			efc_node_post_event(node, EFC_EVT_NODE_ATTACH_OK,
> +					    NULL);
> +
> +		break;
> +
> +	case EFC_EVT_SRRS_ELS_REQ_FAIL:	/* PLOGI response received */
> +	case EFC_EVT_SRRS_ELS_REQ_RJT:
> +		/* PLOGI failed, shutdown the node */
> +		if (efc_node_check_els_req(ctx, evt, arg, ELS_PLOGI,
> +					   __efc_d_common, __func__))
> +			return NULL;
> +
> +		WARN_ON(!node->els_req_cnt);
> +		node->els_req_cnt--;
> +		efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
> +		break;
> +
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +
> +	return NULL;
> +}
> +
> +void *
> +__efc_d_wait_domain_attach(struct efc_sm_ctx *ctx,
> +			   enum efc_sm_event evt, void *arg)
> +{
> +	int rc;
> +	struct efc_node *node = ctx->app;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER:
> +		efc_node_hold_frames(node);
> +		break;
> +
> +	case EFC_EVT_EXIT:
> +		efc_node_accept_frames(node);
> +		break;
> +
> +	case EFC_EVT_DOMAIN_ATTACH_OK:
> +		WARN_ON(!node->sport->domain->attached);
> +		/* sm: / efc_node_attach */
> +		rc = efc_node_attach(node);
> +		efc_node_transition(node, __efc_d_wait_node_attach, NULL);
> +		if (rc == EFC_HW_RTN_SUCCESS_SYNC)
> +			efc_node_post_event(node, EFC_EVT_NODE_ATTACH_OK,
> +					    NULL);
> +
> +		break;
> +
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +	return NULL;
> +}
> +
> +void *
> +__efc_d_wait_topology_notify(struct efc_sm_ctx *ctx,
> +			     enum efc_sm_event evt, void *arg)
> +{
> +	int rc;
> +	struct efc_node *node = ctx->app;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER:
> +		efc_node_hold_frames(node);
> +		break;
> +
> +	case EFC_EVT_EXIT:
> +		efc_node_accept_frames(node);
> +		break;
> +
> +	case EFC_EVT_SPORT_TOPOLOGY_NOTIFY: {
> +		enum efc_sport_topology topology =
> +					(enum efc_sport_topology)arg;
> +
> +		WARN_ON(node->sport->domain->attached);
> +
> +		WARN_ON(node->send_ls_acc != EFC_NODE_SEND_LS_ACC_PLOGI);
> +
> +		node_printf(node, "topology notification, topology=%d\n",
> +			    topology);
> +
> +		/* At the time the PLOGI was received, the topology was unknown,
> +		 * so we didn't know which node would perform the domain attach:
> +		 * 1. The node from which the PLOGI was sent (p2p) or
> +		 * 2. The node to which the FLOGI was sent (fabric).
> +		 */
> +		if (topology == EFC_SPORT_TOPOLOGY_P2P) {
> +			/* if this is p2p, need to attach to the domain using
> +			 * the d_id from the PLOGI received
> +			 */
> +			efc_domain_attach(node->sport->domain,
> +					  node->ls_acc_did);
> +		}
> +		/* else, if this is fabric, the domain attach
> +		 * should be performed by the fabric node (node sending FLOGI);
> +		 * just wait for attach to complete
> +		 */
> +
> +		efc_node_transition(node, __efc_d_wait_domain_attach, NULL);
> +		break;
> +	}
> +	case EFC_EVT_DOMAIN_ATTACH_OK:
> +		WARN_ON(!node->sport->domain->attached);
> +		node_printf(node, "domain attach ok\n");
> +		/* sm: / efc_node_attach */
> +		rc = efc_node_attach(node);
> +		efc_node_transition(node, __efc_d_wait_node_attach, NULL);
> +		if (rc == EFC_HW_RTN_SUCCESS_SYNC)
> +			efc_node_post_event(node,
> +					    EFC_EVT_NODE_ATTACH_OK, NULL);
> +
> +		break;
> +
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +	return NULL;
> +}
> +
> +void *
> +__efc_d_wait_node_attach(struct efc_sm_ctx *ctx,
> +			 enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_node *node = ctx->app;
> +	struct efc *efc = node->efc;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER:
> +		efc_node_hold_frames(node);
> +		break;
> +
> +	case EFC_EVT_EXIT:
> +		efc_node_accept_frames(node);
> +		break;
> +
> +	case EFC_EVT_NODE_ATTACH_OK:
> +		node->attached = true;
> +		switch (node->send_ls_acc) {
> +		case EFC_NODE_SEND_LS_ACC_PLOGI: {
> +			/* sm: send_plogi_acc is set / send PLOGI acc */
> +			/* Normal case for T, or I+T */
> +			efc->tt.els_send_resp(efc, node, ELS_PLOGI,
> +							node->ls_acc_oxid);
> +			efc_node_transition(node,
> +					    __efc_d_wait_plogi_acc_cmpl,
> +					     NULL);
> +			node->send_ls_acc = EFC_NODE_SEND_LS_ACC_NONE;
> +			node->ls_acc_io = NULL;
> +			break;
> +		}
> +		case EFC_NODE_SEND_LS_ACC_PRLI: {
> +			efc_d_send_prli_rsp(node,
> +					    node->ls_acc_oxid);
> +			node->send_ls_acc = EFC_NODE_SEND_LS_ACC_NONE;
> +			node->ls_acc_io = NULL;
> +			break;
> +		}
> +		case EFC_NODE_SEND_LS_ACC_NONE:
> +		default:
> +			/* Normal case for I */
> +			/* sm: send_plogi_acc is not set / send PLOGI acc */
> +			efc_node_transition(node,
> +					    __efc_d_port_logged_in, NULL);
> +			break;
> +		}
> +		break;
> +
> +	case EFC_EVT_NODE_ATTACH_FAIL:
> +		/* node attach failed, shutdown the node */
> +		node->attached = false;
> +		node_printf(node, "node attach failed\n");
> +		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
> +		efc_node_transition(node, __efc_d_initiate_shutdown, NULL);
> +		break;
> +
> +	/* Handle shutdown events */
> +	case EFC_EVT_SHUTDOWN:
> +		node_printf(node, "%s received\n", efc_sm_event_name(evt));
> +		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
> +		efc_node_transition(node, __efc_d_wait_attach_evt_shutdown,
> +				    NULL);
> +		break;
> +	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
> +		node_printf(node, "%s received\n", efc_sm_event_name(evt));
> +		node->shutdown_reason = EFC_NODE_SHUTDOWN_EXPLICIT_LOGO;
> +		efc_node_transition(node, __efc_d_wait_attach_evt_shutdown,
> +				    NULL);
> +		break;
> +	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
> +		node_printf(node, "%s received\n", efc_sm_event_name(evt));
> +		node->shutdown_reason = EFC_NODE_SHUTDOWN_IMPLICIT_LOGO;
> +		efc_node_transition(node,
> +				    __efc_d_wait_attach_evt_shutdown, NULL);
> +		break;
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +
> +	return NULL;
> +}
> +
> +void *
> +__efc_d_wait_attach_evt_shutdown(struct efc_sm_ctx *ctx,
> +				 enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_node *node = ctx->app;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER:
> +		efc_node_hold_frames(node);
> +		break;
> +
> +	case EFC_EVT_EXIT:
> +		efc_node_accept_frames(node);
> +		break;
> +
> +	/* wait for any of these attach events and then shutdown */
> +	case EFC_EVT_NODE_ATTACH_OK:
> +		node->attached = true;
> +		node_printf(node, "Attach evt=%s, proceed to shutdown\n",
> +			    efc_sm_event_name(evt));
> +		efc_node_transition(node, __efc_d_initiate_shutdown, NULL);
> +		break;
> +
> +	case EFC_EVT_NODE_ATTACH_FAIL:
> +		/* node attach failed, shutdown the node */
> +		node->attached = false;
> +		node_printf(node, "Attach evt=%s, proceed to shutdown\n",
> +			    efc_sm_event_name(evt));
> +		efc_node_transition(node, __efc_d_initiate_shutdown, NULL);
> +		break;
> +
> +	/* ignore shutdown events as we're already in shutdown path */
> +	case EFC_EVT_SHUTDOWN:
> +		/* have default shutdown event take precedence */
> +		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
> +		/* fall through */
> +	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
> +	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
> +		node_printf(node, "%s received\n", efc_sm_event_name(evt));
> +		break;
> +
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +
> +	return NULL;
> +}
> +
> +void *
> +__efc_d_port_logged_in(struct efc_sm_ctx *ctx,
> +		       enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_node_cb *cbdata = arg;
> +	struct efc_node *node = ctx->app;
> +	struct efc *efc = node->efc;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER:
> +		/* Normal case for I or I+T */
> +		if (node->sport->enable_ini &&
> +		    !(node->rnode.fc_id != FC_FID_DOM_MGR)) {
> +			/* sm: if enable_ini / send PRLI */
> +			efc->tt.els_send(efc, node, ELS_PRLI,
> +				EFC_FC_ELS_SEND_DEFAULT_TIMEOUT,
> +				EFC_FC_ELS_DEFAULT_RETRIES);
> +			/* can now expect ELS_REQ_OK/FAIL/RJT */
> +		}
> +		break;
> +
> +	case EFC_EVT_FCP_CMD_RCVD: {
> +		break;
> +	}
> +
> +	case EFC_EVT_PRLI_RCVD: {
> +		/* Normal case for T or I+T */
> +		struct fc_frame_header *hdr = cbdata->header->dma.virt;
> +		struct fc_els_spp *sp = cbdata->payload->dma.virt
> +					+ sizeof(struct fc_els_prli);
> +
> +		if (sp->spp_type != FC_TYPE_FCP) {
> +			/*Only FCP is supported*/
> +			efc->tt.send_ls_rjt(efc, node,
> +					be16_to_cpu(hdr->fh_ox_id),
> +					ELS_RJT_UNAB, ELS_EXPL_UNSUPR, 0);
> +			break;
> +		}
> +
> +		efc_process_prli_payload(node, cbdata->payload->dma.virt);
> +		efc_d_send_prli_rsp(node, be16_to_cpu(hdr->fh_ox_id));
> +		break;
> +	}
> +
> +	case EFC_EVT_SRRS_ELS_REQ_OK: {	/* PRLI response */
> +		/* Normal case for I or I+T */
> +		if (efc_node_check_els_req(ctx, evt, arg, ELS_PRLI,
> +					   __efc_d_common, __func__))
> +			return NULL;
> +
> +		WARN_ON(!node->els_req_cnt);
> +		node->els_req_cnt--;
> +		/* sm: / process PRLI payload */
> +		efc_process_prli_payload(node, cbdata->els_rsp.virt);
> +		efc_node_transition(node, __efc_d_device_ready, NULL);
> +		break;
> +	}
> +
> +	case EFC_EVT_SRRS_ELS_REQ_FAIL: {	/* PRLI response failed */
> +		/* I, I+T, assume some link failure, shutdown node */
> +		if (efc_node_check_els_req(ctx, evt, arg, ELS_PRLI,
> +					   __efc_d_common, __func__))
> +			return NULL;
> +
> +		WARN_ON(!node->els_req_cnt);
> +		node->els_req_cnt--;
> +		efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
> +		break;
> +	}
> +
> +	case EFC_EVT_SRRS_ELS_REQ_RJT: {
> +		/* PRLI rejected by remote
> +		 * Normal for I, I+T (connected to an I)
> +		 * Node doesn't want to be a target, stay here and wait for a
> +		 * PRLI from the remote node
> +		 * if it really wants to connect to us as target
> +		 */
> +		if (efc_node_check_els_req(ctx, evt, arg, ELS_PRLI,
> +					   __efc_d_common, __func__))
> +			return NULL;
> +
> +		WARN_ON(!node->els_req_cnt);
> +		node->els_req_cnt--;
> +		break;
> +	}
> +
> +	case EFC_EVT_SRRS_ELS_CMPL_OK: {
> +		/* Normal T, I+T, target-server rejected the process login */
> +		/* This would be received only in the case where we sent
> +		 * LS_RJT for the PRLI, so
> +		 * do nothing.   (note: as T only we could shutdown the node)
> +		 */
> +		WARN_ON(!node->els_cmpl_cnt);
> +		node->els_cmpl_cnt--;
> +		break;
> +	}
> +
> +	case EFC_EVT_PLOGI_RCVD: {
> +		/*sm: / save sparams, set send_plogi_acc,
> +		 *post implicit logout
> +		 * Save plogi parameters
> +		 */
> +		efc_node_save_sparms(node, cbdata->payload->dma.virt);
> +		efc_send_ls_acc_after_attach(node,
> +					     cbdata->header->dma.virt,
> +				EFC_NODE_SEND_LS_ACC_PLOGI);
> +
> +		/* Restart node attach with new service parameters,
> +		 * and send ACC
> +		 */
> +		efc_node_post_event(node, EFC_EVT_SHUTDOWN_IMPLICIT_LOGO,
> +				    NULL);
> +		break;
> +	}
> +
> +	case EFC_EVT_LOGO_RCVD: {
> +		/* I, T, I+T */
> +		struct fc_frame_header *hdr = cbdata->header->dma.virt;
> +
> +		node_printf(node, "%s received attached=%d\n",
> +			    efc_sm_event_name(evt),
> +					node->attached);
> +		/* sm: / send LOGO acc */
> +		efc->tt.els_send_resp(efc, node, ELS_LOGO,
> +					be16_to_cpu(hdr->fh_ox_id));
> +		efc_node_transition(node, __efc_d_wait_logo_acc_cmpl, NULL);
> +		break;
> +	}
> +
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +
> +	return NULL;
> +}
> +
> +void *
> +__efc_d_wait_logo_acc_cmpl(struct efc_sm_ctx *ctx,
> +			   enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_node *node = ctx->app;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER:
> +		efc_node_hold_frames(node);
> +		break;
> +
> +	case EFC_EVT_EXIT:
> +		efc_node_accept_frames(node);
> +		break;
> +
> +	case EFC_EVT_SRRS_ELS_CMPL_OK:
> +	case EFC_EVT_SRRS_ELS_CMPL_FAIL:
> +		/* sm: / post explicit logout */
> +		WARN_ON(!node->els_cmpl_cnt);
> +		node->els_cmpl_cnt--;
> +		efc_node_post_event(node,
> +				    EFC_EVT_SHUTDOWN_EXPLICIT_LOGO, NULL);
> +		break;
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +
> +	return NULL;
> +}
> +
> +void *
> +__efc_d_device_ready(struct efc_sm_ctx *ctx,
> +		     enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_node_cb *cbdata = arg;
> +	struct efc_node *node = ctx->app;
> +	struct efc *efc = node->efc;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	if (evt != EFC_EVT_FCP_CMD_RCVD)
> +		node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER:
> +		node->fcp_enabled = true;
> +		if (node->init) {
> +			efc_log_info(efc,
> +				     "[%s] found (initiator) WWPN %s WWNN %s\n",
> +				node->display_name,
> +				node->wwpn, node->wwnn);
> +			if (node->sport->enable_tgt)
> +				efc->tt.scsi_new_node(efc, node);
> +		}
> +		if (node->targ) {
> +			efc_log_info(efc,
> +				     "[%s] found (target) WWPN %s WWNN %s\n",
> +				node->display_name,
> +				node->wwpn, node->wwnn);
> +			if (node->sport->enable_ini)
> +				efc->tt.scsi_new_node(efc, node);
> +		}
> +		break;
> +
> +	case EFC_EVT_EXIT:
> +		node->fcp_enabled = false;
> +		break;
> +
> +	case EFC_EVT_PLOGI_RCVD: {
> +		/* sm: / save sparams, set send_plogi_acc, post implicit
> +		 * logout
> +		 * Save plogi parameters
> +		 */
> +		efc_node_save_sparms(node, cbdata->payload->dma.virt);
> +		efc_send_ls_acc_after_attach(node,
> +					     cbdata->header->dma.virt,
> +				EFC_NODE_SEND_LS_ACC_PLOGI);
> +
> +		/*
> +		 * Restart node attach with new service parameters,
> +		 * and send ACC
> +		 */
> +		efc_node_post_event(node,
> +				    EFC_EVT_SHUTDOWN_IMPLICIT_LOGO, NULL);
> +		break;
> +	}
> +
> +	case EFC_EVT_PRLI_RCVD: {
> +		/* T, I+T: remote initiator is slow to get started */
> +		struct fc_frame_header *hdr = cbdata->header->dma.virt;
> +		struct fc_els_spp *sp = cbdata->payload->dma.virt
> +					+ sizeof(struct fc_els_prli);
> +
> +		if (sp->spp_type != FC_TYPE_FCP) {
> +			/*Only FCP is supported*/
> +			efc->tt.send_ls_rjt(efc, node,
> +					be16_to_cpu(hdr->fh_ox_id),
> +					ELS_RJT_UNAB, ELS_EXPL_UNSUPR, 0);
> +			break;
> +		}
> +
> +		efc_process_prli_payload(node, cbdata->payload->dma.virt);
> +
> +		efc->tt.els_send_resp(efc, node, ELS_PRLI,
> +					be16_to_cpu(hdr->fh_ox_id));
> +		break;
> +	}
> +
> +	case EFC_EVT_PRLO_RCVD: {
> +		struct fc_frame_header *hdr = cbdata->header->dma.virt;
> +		/* sm: / send PRLO acc */
> +		efc->tt.els_send_resp(efc, node, ELS_PRLO,
> +					be16_to_cpu(hdr->fh_ox_id));
> +		/* need implicit logout? */
> +		break;
> +	}
> +
> +	case EFC_EVT_LOGO_RCVD: {
> +		struct fc_frame_header *hdr = cbdata->header->dma.virt;
> +
> +		node_printf(node, "%s received attached=%d\n",
> +			    efc_sm_event_name(evt), node->attached);
> +		/* sm: / send LOGO acc */
> +		efc->tt.els_send_resp(efc, node, ELS_LOGO,
> +					be16_to_cpu(hdr->fh_ox_id));
> +		efc_node_transition(node, __efc_d_wait_logo_acc_cmpl, NULL);
> +		break;
> +	}
> +
> +	case EFC_EVT_ADISC_RCVD: {
> +		struct fc_frame_header *hdr = cbdata->header->dma.virt;
> +		/* sm: / send ADISC acc */
> +		efc->tt.els_send_resp(efc, node, ELS_ADISC,
> +					be16_to_cpu(hdr->fh_ox_id));
> +		break;
> +	}
> +
> +	case EFC_EVT_ABTS_RCVD:
> +		/* sm: / process ABTS */
> +		efc_log_err(efc, "Unexpected event:%s\n",
> +					efc_sm_event_name(evt));
> +		break;
> +
> +	case EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY:
> +		break;
> +
> +	case EFC_EVT_NODE_REFOUND:
> +		break;
> +
> +	case EFC_EVT_NODE_MISSING:
> +		if (node->sport->enable_rscn)
> +			efc_node_transition(node, __efc_d_device_gone, NULL);
> +
> +		break;
> +
> +	case EFC_EVT_SRRS_ELS_CMPL_OK:
> +		/* T, or I+T, PRLI accept completed ok */
> +		WARN_ON(!node->els_cmpl_cnt);
> +		node->els_cmpl_cnt--;
> +		break;
> +
> +	case EFC_EVT_SRRS_ELS_CMPL_FAIL:
> +		/* T, or I+T, PRLI accept failed to complete */
> +		WARN_ON(!node->els_cmpl_cnt);
> +		node->els_cmpl_cnt--;
> +		node_printf(node, "Failed to send PRLI LS_ACC\n");
> +		break;
> +
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +
> +	return NULL;
> +}
> +
> +void *
> +__efc_d_device_gone(struct efc_sm_ctx *ctx,
> +		    enum efc_sm_event evt, void *arg)
> +{
> +	int rc = EFC_SCSI_CALL_COMPLETE;
> +	int rc_2 = EFC_SCSI_CALL_COMPLETE;
> +	struct efc_node_cb *cbdata = arg;
> +	struct efc_node *node = ctx->app;
> +	struct efc *efc = node->efc;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_ENTER: {
> +		static char const *labels[] = {"none", "initiator", "target",
> +							"initiator+target"};
> +
> +		efc_log_info(efc, "[%s] missing (%s)    WWPN %s WWNN %s\n",
> +			     node->display_name,
> +				labels[(node->targ << 1) | (node->init)],
> +						node->wwpn, node->wwnn);
> +
> +		switch (efc_node_get_enable(node)) {
> +		case EFC_NODE_ENABLE_T_TO_T:
> +		case EFC_NODE_ENABLE_I_TO_T:
> +		case EFC_NODE_ENABLE_IT_TO_T:
> +			rc = efc->tt.scsi_del_node(efc, node,
> +				EFC_SCSI_TARGET_MISSING);
> +			break;
> +
> +		case EFC_NODE_ENABLE_T_TO_I:
> +		case EFC_NODE_ENABLE_I_TO_I:
> +		case EFC_NODE_ENABLE_IT_TO_I:
> +			rc = efc->tt.scsi_del_node(efc, node,
> +				EFC_SCSI_INITIATOR_MISSING);
> +			break;
> +
> +		case EFC_NODE_ENABLE_T_TO_IT:
> +			rc = efc->tt.scsi_del_node(efc, node,
> +				EFC_SCSI_INITIATOR_MISSING);
> +			break;
> +
> +		case EFC_NODE_ENABLE_I_TO_IT:
> +			rc = efc->tt.scsi_del_node(efc, node,
> +						  EFC_SCSI_TARGET_MISSING);
> +			break;
> +
> +		case EFC_NODE_ENABLE_IT_TO_IT:
> +			rc = efc->tt.scsi_del_node(efc, node,
> +				EFC_SCSI_INITIATOR_MISSING);
> +			rc_2 = efc->tt.scsi_del_node(efc, node,
> +				EFC_SCSI_TARGET_MISSING);
> +			break;
> +
> +		default:
> +			rc = EFC_SCSI_CALL_COMPLETE;
> +			break;
> +		}
> +
> +		if (rc == EFC_SCSI_CALL_COMPLETE &&
> +		    rc_2 == EFC_SCSI_CALL_COMPLETE)
> +			efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
> +
> +		break;
> +	}
> +	case EFC_EVT_NODE_REFOUND:
> +		/* two approaches, reauthenticate with PLOGI/PRLI, or ADISC */
> +
> +		/* reauthenticate with PLOGI/PRLI */
> +		/* efc_node_transition(node, __efc_d_discovered, NULL); */
> +
> +		/* reauthenticate with ADISC */
> +		/* sm: / send ADISC */
> +		efc->tt.els_send(efc, node, ELS_ADISC,
> +				EFC_FC_FLOGI_TIMEOUT_SEC,
> +				EFC_FC_ELS_DEFAULT_RETRIES);
> +		efc_node_transition(node, __efc_d_wait_adisc_rsp, NULL);
> +		break;
> +
> +	case EFC_EVT_PLOGI_RCVD: {
> +		/* sm: / save sparams, set send_plogi_acc, post implicit
> +		 * logout
> +		 * Save plogi parameters
> +		 */
> +		efc_node_save_sparms(node, cbdata->payload->dma.virt);
> +		efc_send_ls_acc_after_attach(node,
> +					     cbdata->header->dma.virt,
> +				EFC_NODE_SEND_LS_ACC_PLOGI);
> +
> +		/*
> +		 * Restart node attach with new service parameters, and send
> +		 * ACC
> +		 */
> +		efc_node_post_event(node, EFC_EVT_SHUTDOWN_IMPLICIT_LOGO,
> +				    NULL);
> +		break;
> +	}
> +
> +	case EFC_EVT_FCP_CMD_RCVD: {
> +		/* most likely a stale frame (received prior to link down),
> +		 * if attempt to send LOGO, will probably timeout and eat
> +		 * up 20s; thus, drop FCP_CMND
> +		 */
> +		node_printf(node, "FCP_CMND received, drop\n");
> +		break;
> +	}
> +	case EFC_EVT_LOGO_RCVD: {
> +		/* I, T, I+T */
> +		struct fc_frame_header *hdr = cbdata->header->dma.virt;
> +
> +		node_printf(node, "%s received attached=%d\n",
> +			    efc_sm_event_name(evt), node->attached);
> +		/* sm: / send LOGO acc */
> +		efc->tt.els_send_resp(efc, node, ELS_LOGO,
> +					be16_to_cpu(hdr->fh_ox_id));
> +		efc_node_transition(node, __efc_d_wait_logo_acc_cmpl, NULL);
> +		break;
> +	}
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +
> +	return NULL;
> +}
> +
> +void *
> +__efc_d_wait_adisc_rsp(struct efc_sm_ctx *ctx,
> +		       enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_node_cb *cbdata = arg;
> +	struct efc_node *node = ctx->app;
> +	struct efc *efc = node->efc;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_SRRS_ELS_REQ_OK:
> +		if (efc_node_check_els_req(ctx, evt, arg, ELS_ADISC,
> +					   __efc_d_common, __func__))
> +			return NULL;
> +
> +		WARN_ON(!node->els_req_cnt);
> +		node->els_req_cnt--;
> +		efc_node_transition(node, __efc_d_device_ready, NULL);
> +		break;
> +
> +	case EFC_EVT_SRRS_ELS_REQ_RJT:
> +		/* received an LS_RJT, in this case, send shutdown
> +		 * (explicit logo) event which will unregister the node,
> +		 * and start over with PLOGI
> +		 */
> +		if (efc_node_check_els_req(ctx, evt, arg, ELS_ADISC,
> +					   __efc_d_common, __func__))
> +			return NULL;
> +
> +		WARN_ON(!node->els_req_cnt);
> +		node->els_req_cnt--;
> +		/* sm: / post explicit logout */
> +		efc_node_post_event(node,
> +				    EFC_EVT_SHUTDOWN_EXPLICIT_LOGO,
> +				     NULL);
> +		break;
> +
> +	case EFC_EVT_LOGO_RCVD: {
> +		/* In this case, we have the equivalent of an LS_RJT for
> +		 * the ADISC, so we need to abort the ADISC, and re-login
> +		 * with PLOGI
> +		 */
> +		/* sm: / request abort, send LOGO acc */
> +		struct fc_frame_header *hdr = cbdata->header->dma.virt;
> +
> +		node_printf(node, "%s received attached=%d\n",
> +			    efc_sm_event_name(evt), node->attached);
> +
> +		efc->tt.els_send_resp(efc, node, ELS_LOGO,
> +					be16_to_cpu(hdr->fh_ox_id));
> +		efc_node_transition(node, __efc_d_wait_logo_acc_cmpl, NULL);
> +		break;
> +	}
> +	default:
> +		__efc_d_common(__func__, ctx, evt, arg);
> +		return NULL;
> +	}
> +
> +	return NULL;
> +}
> diff --git a/drivers/scsi/elx/libefc/efc_device.h b/drivers/scsi/elx/libefc/efc_device.h
> new file mode 100644
> index 000000000000..513096b8f875
> --- /dev/null
> +++ b/drivers/scsi/elx/libefc/efc_device.h
> @@ -0,0 +1,72 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +/*
> + * Node state machine functions for remote device node sm
> + */
> +
> +#ifndef __EFCT_DEVICE_H__
> +#define __EFCT_DEVICE_H__
> +extern void
> +efc_node_init_device(struct efc_node *node, bool send_plogi);
> +extern void
> +efc_process_prli_payload(struct efc_node *node,
> +			 void *prli);
> +extern void
> +efc_d_send_prli_rsp(struct efc_node *node, uint16_t ox_id);
> +extern void
> +efc_send_ls_acc_after_attach(struct efc_node *node,
> +			     struct fc_frame_header *hdr,
> +			     enum efc_node_send_ls_acc ls);
> +extern void *
> +__efc_d_wait_loop(struct efc_sm_ctx *ctx,
> +		  enum efc_sm_event evt, void *arg);
> +extern void *
> +__efc_d_wait_plogi_acc_cmpl(struct efc_sm_ctx *ctx,
> +			    enum efc_sm_event evt, void *arg);
> +extern void *
> +__efc_d_init(struct efc_sm_ctx *ctx, enum efc_sm_event evt, void *arg);
> +extern void *
> +__efc_d_wait_plogi_rsp(struct efc_sm_ctx *ctx,
> +		       enum efc_sm_event evt, void *arg);
> +extern void *
> +__efc_d_wait_plogi_rsp_recvd_prli(struct efc_sm_ctx *ctx,
> +				  enum efc_sm_event evt, void *arg);
> +extern void *
> +__efc_d_wait_domain_attach(struct efc_sm_ctx *ctx,
> +			   enum efc_sm_event evt, void *arg);
> +extern void *
> +__efc_d_wait_topology_notify(struct efc_sm_ctx *ctx,
> +			     enum efc_sm_event evt, void *arg);
> +extern void *
> +__efc_d_wait_node_attach(struct efc_sm_ctx *ctx,
> +			 enum efc_sm_event evt, void *arg);
> +extern void *
> +__efc_d_wait_attach_evt_shutdown(struct efc_sm_ctx *ctx,
> +				 enum efc_sm_event evt, void *arg);
> +extern void *
> +__efc_d_initiate_shutdown(struct efc_sm_ctx *ctx,
> +			  enum efc_sm_event evt, void *arg);
> +extern void *
> +__efc_d_port_logged_in(struct efc_sm_ctx *ctx,
> +		       enum efc_sm_event evt, void *arg);
> +extern void *
> +__efc_d_wait_logo_acc_cmpl(struct efc_sm_ctx *ctx,
> +			   enum efc_sm_event evt, void *arg);
> +extern void *
> +__efc_d_device_ready(struct efc_sm_ctx *ctx,
> +		     enum efc_sm_event evt, void *arg);
> +extern void *
> +__efc_d_device_gone(struct efc_sm_ctx *ctx,
> +		    enum efc_sm_event evt, void *arg);
> +extern void *
> +__efc_d_wait_adisc_rsp(struct efc_sm_ctx *ctx,
> +		       enum efc_sm_event evt, void *arg);
> +extern void *
> +__efc_d_wait_logo_rsp(struct efc_sm_ctx *ctx,
> +		      enum efc_sm_event evt, void *arg);
> +
> +#endif /* __EFCT_DEVICE_H__ */
> -- 
> 2.16.4
> 
> 

I run out of steam and thus stop here...

Thanks,
Daniel

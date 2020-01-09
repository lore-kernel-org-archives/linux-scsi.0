Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C8C9C32771
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 07:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E24B2072A
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 07:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgAIHF7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 02:05:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:57488 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgAIHF6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Jan 2020 02:05:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 282CBAC1C;
        Thu,  9 Jan 2020 07:05:56 +0000 (UTC)
Subject: Re: [PATCH v2 08/32] elx: libefc: Generic state machine framework
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
 <20191220223723.26563-9-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <238ab98f-eb1b-7f24-b4eb-7d8f002520da@suse.de>
Date:   Thu, 9 Jan 2020 08:05:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191220223723.26563-9-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/20/19 11:36 PM, James Smart wrote:
> This patch starts the population of the libefc library.
> The library will contain common tasks usable by a target or initiator
> driver. The library will also contain a FC discovery state machine
> interface.
> 
> This patch creates the library directory and adds definitions
> for the discovery state machine interface.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/elx/libefc/efc_sm.c | 213 +++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/elx/libefc/efc_sm.h | 140 +++++++++++++++++++++++++
>  2 files changed, 353 insertions(+)
>  create mode 100644 drivers/scsi/elx/libefc/efc_sm.c
>  create mode 100644 drivers/scsi/elx/libefc/efc_sm.h
> 
> diff --git a/drivers/scsi/elx/libefc/efc_sm.c b/drivers/scsi/elx/libefc/efc_sm.c
> new file mode 100644
> index 000000000000..90e60c0e6638
> --- /dev/null
> +++ b/drivers/scsi/elx/libefc/efc_sm.c
> @@ -0,0 +1,213 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +/*
> + * Generic state machine framework.
> + */
> +#include "efc.h"
> +#include "efc_sm.h"
> +
> +const char *efc_sm_id[] = {
> +	"common",
> +	"domain",
> +	"login"
> +};
> +
> +/**
> + * efc_sm_post_event() - Post an event to a context.
> + *
> + * @ctx: State machine context
> + * @evt: Event to post
> + * @data: Event-specific data (if any)
> + */
> +int
> +efc_sm_post_event(struct efc_sm_ctx *ctx,
> +		  enum efc_sm_event evt, void *data)
> +{
> +	if (ctx->current_state) {
> +		ctx->current_state(ctx, evt, data);
> +		return 0;
> +	} else {
> +		return -1;
> +	}
> +}
> +
> +void
> +efc_sm_transition(struct efc_sm_ctx *ctx,
> +		  void *(*state)(struct efc_sm_ctx *,
> +				 enum efc_sm_event, void *), void *data)
> +
> +{
> +	if (ctx->current_state == state) {
> +		efc_sm_post_event(ctx, EFC_EVT_REENTER, data);
> +	} else {
> +		efc_sm_post_event(ctx, EFC_EVT_EXIT, data);
> +		ctx->current_state = state;
> +		efc_sm_post_event(ctx, EFC_EVT_ENTER, data);
> +	}
> +}
> +
> +void
> +efc_sm_disable(struct efc_sm_ctx *ctx)
> +{
> +	ctx->current_state = NULL;
> +}
> +
> +const char *efc_sm_event_name(enum efc_sm_event evt)
> +{
> +	switch (evt) {
> +	case EFC_EVT_ENTER:
> +		return "EFC_EVT_ENTER";
> +	case EFC_EVT_REENTER:
> +		return "EFC_EVT_REENTER";
> +	case EFC_EVT_EXIT:
> +		return "EFC_EVT_EXIT";
> +	case EFC_EVT_SHUTDOWN:
> +		return "EFC_EVT_SHUTDOWN";
> +	case EFC_EVT_RESPONSE:
> +		return "EFC_EVT_RESPONSE";
> +	case EFC_EVT_RESUME:
> +		return "EFC_EVT_RESUME";
> +	case EFC_EVT_TIMER_EXPIRED:
> +		return "EFC_EVT_TIMER_EXPIRED";
> +	case EFC_EVT_ERROR:
> +		return "EFC_EVT_ERROR";
> +	case EFC_EVT_SRRS_ELS_REQ_OK:
> +		return "EFC_EVT_SRRS_ELS_REQ_OK";
> +	case EFC_EVT_SRRS_ELS_CMPL_OK:
> +		return "EFC_EVT_SRRS_ELS_CMPL_OK";
> +	case EFC_EVT_SRRS_ELS_REQ_FAIL:
> +		return "EFC_EVT_SRRS_ELS_REQ_FAIL";
> +	case EFC_EVT_SRRS_ELS_CMPL_FAIL:
> +		return "EFC_EVT_SRRS_ELS_CMPL_FAIL";
> +	case EFC_EVT_SRRS_ELS_REQ_RJT:
> +		return "EFC_EVT_SRRS_ELS_REQ_RJT";
> +	case EFC_EVT_NODE_ATTACH_OK:
> +		return "EFC_EVT_NODE_ATTACH_OK";
> +	case EFC_EVT_NODE_ATTACH_FAIL:
> +		return "EFC_EVT_NODE_ATTACH_FAIL";
> +	case EFC_EVT_NODE_FREE_OK:
> +		return "EFC_EVT_NODE_FREE_OK";
> +	case EFC_EVT_ELS_REQ_TIMEOUT:
> +		return "EFC_EVT_ELS_REQ_TIMEOUT";
> +	case EFC_EVT_ELS_REQ_ABORTED:
> +		return "EFC_EVT_ELS_REQ_ABORTED";
> +	case EFC_EVT_ABORT_ELS:
> +		return "EFC_EVT_ABORT_ELS";
> +	case EFC_EVT_ELS_ABORT_CMPL:
> +		return "EFC_EVT_ELS_ABORT_CMPL";
> +
> +	case EFC_EVT_DOMAIN_FOUND:
> +		return "EFC_EVT_DOMAIN_FOUND";
> +	case EFC_EVT_DOMAIN_ALLOC_OK:
> +		return "EFC_EVT_DOMAIN_ALLOC_OK";
> +	case EFC_EVT_DOMAIN_ALLOC_FAIL:
> +		return "EFC_EVT_DOMAIN_ALLOC_FAIL";
> +	case EFC_EVT_DOMAIN_REQ_ATTACH:
> +		return "EFC_EVT_DOMAIN_REQ_ATTACH";
> +	case EFC_EVT_DOMAIN_ATTACH_OK:
> +		return "EFC_EVT_DOMAIN_ATTACH_OK";
> +	case EFC_EVT_DOMAIN_ATTACH_FAIL:
> +		return "EFC_EVT_DOMAIN_ATTACH_FAIL";
> +	case EFC_EVT_DOMAIN_LOST:
> +		return "EFC_EVT_DOMAIN_LOST";
> +	case EFC_EVT_DOMAIN_FREE_OK:
> +		return "EFC_EVT_DOMAIN_FREE_OK";
> +	case EFC_EVT_DOMAIN_FREE_FAIL:
> +		return "EFC_EVT_DOMAIN_FREE_FAIL";
> +	case EFC_EVT_HW_DOMAIN_REQ_ATTACH:
> +		return "EFC_EVT_HW_DOMAIN_REQ_ATTACH";
> +	case EFC_EVT_HW_DOMAIN_REQ_FREE:
> +		return "EFC_EVT_HW_DOMAIN_REQ_FREE";
> +	case EFC_EVT_ALL_CHILD_NODES_FREE:
> +		return "EFC_EVT_ALL_CHILD_NODES_FREE";
> +
> +	case EFC_EVT_SPORT_ALLOC_OK:
> +		return "EFC_EVT_SPORT_ALLOC_OK";
> +	case EFC_EVT_SPORT_ALLOC_FAIL:
> +		return "EFC_EVT_SPORT_ALLOC_FAIL";
> +	case EFC_EVT_SPORT_ATTACH_OK:
> +		return "EFC_EVT_SPORT_ATTACH_OK";
> +	case EFC_EVT_SPORT_ATTACH_FAIL:
> +		return "EFC_EVT_SPORT_ATTACH_FAIL";
> +	case EFC_EVT_SPORT_FREE_OK:
> +		return "EFC_EVT_SPORT_FREE_OK";
> +	case EFC_EVT_SPORT_FREE_FAIL:
> +		return "EFC_EVT_SPORT_FREE_FAIL";
> +	case EFC_EVT_SPORT_TOPOLOGY_NOTIFY:
> +		return "EFC_EVT_SPORT_TOPOLOGY_NOTIFY";
> +	case EFC_EVT_HW_PORT_ALLOC_OK:
> +		return "EFC_EVT_HW_PORT_ALLOC_OK";
> +	case EFC_EVT_HW_PORT_ALLOC_FAIL:
> +		return "EFC_EVT_HW_PORT_ALLOC_FAIL";
> +	case EFC_EVT_HW_PORT_ATTACH_OK:
> +		return "EFC_EVT_HW_PORT_ATTACH_OK";
> +	case EFC_EVT_HW_PORT_REQ_ATTACH:
> +		return "EFC_EVT_HW_PORT_REQ_ATTACH";
> +	case EFC_EVT_HW_PORT_REQ_FREE:
> +		return "EFC_EVT_HW_PORT_REQ_FREE";
> +	case EFC_EVT_HW_PORT_FREE_OK:
> +		return "EFC_EVT_HW_PORT_FREE_OK";
> +
> +	case EFC_EVT_NODE_FREE_FAIL:
> +		return "EFC_EVT_NODE_FREE_FAIL";
> +
> +	case EFC_EVT_ABTS_RCVD:
> +		return "EFC_EVT_ABTS_RCVD";
> +
> +	case EFC_EVT_NODE_MISSING:
> +		return "EFC_EVT_NODE_MISSING";
> +	case EFC_EVT_NODE_REFOUND:
> +		return "EFC_EVT_NODE_REFOUND";
> +	case EFC_EVT_SHUTDOWN_IMPLICIT_LOGO:
> +		return "EFC_EVT_SHUTDOWN_IMPLICIT_LOGO";
> +	case EFC_EVT_SHUTDOWN_EXPLICIT_LOGO:
> +		return "EFC_EVT_SHUTDOWN_EXPLICIT_LOGO";
> +
> +	case EFC_EVT_ELS_FRAME:
> +		return "EFC_EVT_ELS_FRAME";
> +	case EFC_EVT_PLOGI_RCVD:
> +		return "EFC_EVT_PLOGI_RCVD";
> +	case EFC_EVT_FLOGI_RCVD:
> +		return "EFC_EVT_FLOGI_RCVD";
> +	case EFC_EVT_LOGO_RCVD:
> +		return "EFC_EVT_LOGO_RCVD";
> +	case EFC_EVT_PRLI_RCVD:
> +		return "EFC_EVT_PRLI_RCVD";
> +	case EFC_EVT_PRLO_RCVD:
> +		return "EFC_EVT_PRLO_RCVD";
> +	case EFC_EVT_PDISC_RCVD:
> +		return "EFC_EVT_PDISC_RCVD";
> +	case EFC_EVT_FDISC_RCVD:
> +		return "EFC_EVT_FDISC_RCVD";
> +	case EFC_EVT_ADISC_RCVD:
> +		return "EFC_EVT_ADISC_RCVD";
> +	case EFC_EVT_RSCN_RCVD:
> +		return "EFC_EVT_RSCN_RCVD";
> +	case EFC_EVT_SCR_RCVD:
> +		return "EFC_EVT_SCR_RCVD";
> +	case EFC_EVT_ELS_RCVD:
> +		return "EFC_EVT_ELS_RCVD";
> +	case EFC_EVT_LAST:
> +		return "EFC_EVT_LAST";
> +	case EFC_EVT_FCP_CMD_RCVD:
> +		return "EFC_EVT_FCP_CMD_RCVD";
> +
> +	case EFC_EVT_GIDPT_DELAY_EXPIRED:
> +		return "EFC_EVT_GIDPT_DELAY_EXPIRED";
> +
> +	case EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY:
> +		return "EFC_EVT_NODE_ACTIVE_IO_LIST_EMPTY";
> +	case EFC_EVT_NODE_DEL_INI_COMPLETE:
> +		return "EFC_EVT_NODE_DEL_INI_COMPLETE";
> +	case EFC_EVT_NODE_DEL_TGT_COMPLETE:
> +		return "EFC_EVT_NODE_DEL_TGT_COMPLETE";
> +
> +	default:
> +		break;
> +	}
> +	return "unknown";
> +}
Please convert into a lookup array.

> diff --git a/drivers/scsi/elx/libefc/efc_sm.h b/drivers/scsi/elx/libefc/efc_sm.h
> new file mode 100644
> index 000000000000..c76352d1d527
> --- /dev/null
> +++ b/drivers/scsi/elx/libefc/efc_sm.h
> @@ -0,0 +1,140 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + *
> + */
> +
> +/**
> + * Generic state machine framework declarations.
> + */
> +
> +#ifndef _EFC_SM_H
> +#define _EFC_SM_H
> +
> +/**
> + * State Machine (SM) IDs.
> + */
> +enum {
> +	EFC_SM_COMMON = 0,
> +	EFC_SM_DOMAIN,
> +	EFC_SM_PORT,
> +	EFC_SM_LOGIN,
> +	EFC_SM_LAST
> +};
> +
> +#define EFC_SM_EVENT_SHIFT		24
> +#define EFC_SM_EVENT_START(id)		((id) << EFC_SM_EVENT_SHIFT)
> +
> +extern const char *efc_sm_id[];
> +
Curious.
You define 4 state machine IDs, yet declare names for only 3 of them.
Omission?

And I would probably use a lookup function for the state machines; this
'const char *efc_sm_id[]' looks a bit lonely. Plus I'm always wary of
variable sized global const ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

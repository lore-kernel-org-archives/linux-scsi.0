Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 382E4C2D0EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 06:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2110420787
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 06:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408200AbgDPGiY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 02:38:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:55908 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408188AbgDPGiP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 02:38:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 41DCCACCA;
        Thu, 16 Apr 2020 06:37:14 +0000 (UTC)
Subject: Re: [PATCH v3 13/31] elx: libefc: Fabric node state machine
 interfaces
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-14-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <86cf1199-b29e-4955-1027-e3c2ba5056c4@suse.de>
Date:   Thu, 16 Apr 2020 08:37:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200412033303.29574-14-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/20 5:32 AM, James Smart wrote:
> This patch continues the libefc library population.
> 
> This patch adds library interface definitions for:
> - Fabric node initialization and logins.
> - Name/Directory Services node.
> - Fabric Controller node to process rscn events.
> 
> These are all interactions with remote ports that correspond
> to well-known fabric entities
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>    Replace efc_assert with WARN_ON
>    Return defined return values
> ---
>   drivers/scsi/elx/libefc/efc_fabric.c | 1759 ++++++++++++++++++++++++++++++++++
>   drivers/scsi/elx/libefc/efc_fabric.h |  116 +++
>   2 files changed, 1875 insertions(+)
>   create mode 100644 drivers/scsi/elx/libefc/efc_fabric.c
>   create mode 100644 drivers/scsi/elx/libefc/efc_fabric.h
> 
> diff --git a/drivers/scsi/elx/libefc/efc_fabric.c b/drivers/scsi/elx/libefc/efc_fabric.c
> new file mode 100644
> index 000000000000..251f8702dbc5
> --- /dev/null
> +++ b/drivers/scsi/elx/libefc/efc_fabric.c
> @@ -0,0 +1,1759 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +/*
> + * This file implements remote node state machines for:
> + * - Fabric logins.
> + * - Fabric controller events.
> + * - Name/directory services interaction.
> + * - Point-to-point logins.
> + */
> +
> +/*
> + * fabric_sm Node State Machine: Fabric States
> + * ns_sm Node State Machine: Name/Directory Services States
> + * p2p_sm Node State Machine: Point-to-Point Node States
> + */
> +
> +#include "efc.h"
> +
> +static void
> +efc_fabric_initiate_shutdown(struct efc_node *node)
> +{
> +	int rc;
> +	struct efc *efc = node->efc;
> +
> +	efc->tt.scsi_io_alloc_disable(efc, node);
> +
> +	if (node->attached) {
> +		/* issue hw node free; don't care if succeeds right away
> +		 * or sometime later, will check node->attached later in
> +		 * shutdown process
> +		 */
> +		rc = efc->tt.hw_node_detach(efc, &node->rnode);
> +		if (rc != EFC_HW_RTN_SUCCESS &&
> +		    rc != EFC_HW_RTN_SUCCESS_SYNC) {
> +			node_printf(node, "Failed freeing HW node, rc=%d\n",
> +				    rc);
> +		}
> +	}
> +	/*
> +	 * node has either been detached or is in the process of being detached,
> +	 * call common node's initiate cleanup function
> +	 */
> +	efc_node_initiate_cleanup(node);
> +}
> +
> +static void *
> +__efc_fabric_common(const char *funcname, struct efc_sm_ctx *ctx,
> +		    enum efc_sm_event evt, void *arg)
> +{
> +	struct efc_node *node = NULL;
> +
> +	node = ctx->app;
> +
> +	switch (evt) {
> +	case EFC_EVT_DOMAIN_ATTACH_OK:
> +		break;
> +	case EFC_EVT_SHUTDOWN:
> +		node->shutdown_reason = EFC_NODE_SHUTDOWN_DEFAULT;
> +		efc_fabric_initiate_shutdown(node);
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
> +void *
> +__efc_fabric_init(struct efc_sm_ctx *ctx, enum efc_sm_event evt,
> +		  void *arg)
> +{
> +	struct efc_node *node = ctx->app;
> +	struct efc *efc = node->efc;
> +
> +	efc_node_evt_set(ctx, evt, __func__);
> +
> +	node_sm_trace();
> +
> +	switch (evt) {
> +	case EFC_EVT_REENTER:	/* not sure why we're getting these ... */
> +		efc_log_debug(efc, ">>> reenter !!\n");
> +		/* fall through */
> +	case EFC_EVT_ENTER:
> +		/*  sm: / send FLOGI */
> +		efc->tt.els_send(efc, node, ELS_FLOGI,
> +				EFC_FC_FLOGI_TIMEOUT_SEC,
> +				EFC_FC_ELS_DEFAULT_RETRIES);
> +		efc_node_transition(node, __efc_fabric_flogi_wait_rsp, NULL);
> +		break;
> +
> +	default:
> +		__efc_fabric_common(__func__, ctx, evt, arg);
> +		break;
> +	}
> +
> +	return NULL;
> +}
> +
What is going on here?
Why do you declare all function as 'void *', but then continue to return 
only NULL pointer?

Is this some weird API logic or are these functions being fleshed out in 
later patches to return something else but NULL?

But as it stands I would recommend to move all of these functions to 
simple 'void' functions, and updating the function prototypes once they 
can return anything else than 'NULL'.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

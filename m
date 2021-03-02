Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C53C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 238B464F1B
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581613AbhCBS7r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:59:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:56350 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236524AbhCBSYr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Mar 2021 13:24:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ABE5AAF3D;
        Tue,  2 Mar 2021 16:33:57 +0000 (UTC)
Subject: Re: [PATCH v5 11/31] elx: libefc: SLI and FC PORT state machine
 interfaces
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
 <20210103171134.39878-12-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <534531b6-23a7-3620-dc94-0761b1bc2534@suse.de>
Date:   Tue, 2 Mar 2021 17:33:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210103171134.39878-12-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/3/21 6:11 PM, James Smart wrote:
> This patch continues the libefc library population.
> 
> This patch adds library interface definitions for:
> - SLI and FC port (aka n_port_id) registration, allocation and
>    deallocation.
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>   drivers/scsi/elx/libefc/efc_nport.c | 794 ++++++++++++++++++++++++++++
>   drivers/scsi/elx/libefc/efc_nport.h |  50 ++
>   2 files changed, 844 insertions(+)
>   create mode 100644 drivers/scsi/elx/libefc/efc_nport.c
>   create mode 100644 drivers/scsi/elx/libefc/efc_nport.h
> 
> diff --git a/drivers/scsi/elx/libefc/efc_nport.c b/drivers/scsi/elx/libefc/efc_nport.c
> new file mode 100644
> index 000000000000..fad42cd8a108
> --- /dev/null
> +++ b/drivers/scsi/elx/libefc/efc_nport.c
> @@ -0,0 +1,794 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +/*
> + * NPORT
> + *
> + * Port object for physical port and NPIV ports.
> + */
> +
> +/*
> + * NPORT REFERENCE COUNTING
> + *
> + * A nport reference should be taken when:
> + * - an nport is allocated
> + * - a vport populates associated nport
> + * - a remote node is allocated
> + * - a unsolicited frame is processed
> + * The reference should be dropped when:
> + * - the unsolicited frame processesing is done
> + * - the remote node is removed
> + * - the vport is removed
> + * - the nport is removed
> + */
> +
> +#include "efc.h"
> +
> +int
> +efc_nport_cb(void *arg, int event, void *data)
> +{
> +	struct efc *efc = arg;
> +	struct efc_nport *nport = data;
> +	unsigned long flags = 0;
> +
> +	efc_log_debug(efc, "nport event: %s\n", efc_sm_event_name(event));
> +
> +	spin_lock_irqsave(&efc->lock, flags);
> +	efc_sm_post_event(&nport->sm, event, NULL);
> +	spin_unlock_irqrestore(&efc->lock, flags);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +static struct efc_nport *
> +efc_nport_find_wwn(struct efc_domain *domain, uint64_t wwnn, uint64_t wwpn)
> +{
> +	struct efc_nport *nport = NULL;
> +
> +	/* Find a nport, given the WWNN and WWPN */
> +	list_for_each_entry(nport, &domain->nport_list, list_entry) {
> +		if (nport->wwnn == wwnn && nport->wwpn == wwpn)
> +			return nport;
> +	}
> +	return NULL;
> +}
> +
> +static void
> +_efc_nport_free(struct kref *arg)
> +{
> +	struct efc_nport *nport = container_of(arg, struct efc_nport, ref);
> +
> +	kfree(nport);
> +}
> +
> +struct efc_nport *
> +efc_nport_alloc(struct efc_domain *domain, uint64_t wwpn, uint64_t wwnn,
> +		u32 fc_id, bool enable_ini, bool enable_tgt)
> +{
> +	struct efc_nport *nport;
> +
> +	if (domain->efc->enable_ini)
> +		enable_ini = 0;
> +
> +	/* Return a failure if this nport has already been allocated */
> +	if ((wwpn != 0) || (wwnn != 0)) {
> +		nport = efc_nport_find_wwn(domain, wwnn, wwpn);
> +		if (nport) {
> +			efc_log_err(domain->efc,
> +				"Err: NPORT %016llX %016llX already allocated\n",
> +				wwnn, wwpn);
> +			return NULL;
> +		}
> +	}
> +
> +	nport = kzalloc(sizeof(*nport), GFP_ATOMIC);
> +	if (!nport)
> +		return nport;
> +
> +	/* initialize refcount */
> +	kref_init(&nport->ref);
> +	nport->release = _efc_nport_free;
> +
> +	nport->efc = domain->efc;
> +	snprintf(nport->display_name, sizeof(nport->display_name), "------");
> +	nport->domain = domain;
> +	xa_init(&nport->lookup);
> +	nport->instance_index = domain->nport_count++;
> +	nport->sm.app = nport;
> +	nport->enable_ini = enable_ini;
> +	nport->enable_tgt = enable_tgt;
> +	nport->enable_rscn = (nport->enable_ini ||
> +			(nport->enable_tgt && enable_target_rscn(nport->efc)));
> +
> +	/* Copy service parameters from domain */
> +	memcpy(nport->service_params, domain->service_params,
> +		sizeof(struct fc_els_flogi));
> +
> +	/* Update requested fc_id */
> +	nport->fc_id = fc_id;
> +
> +	/* Update the nport's service parameters for the new wwn's */
> +	nport->wwpn = wwpn;
> +	nport->wwnn = wwnn;
> +	snprintf(nport->wwnn_str, sizeof(nport->wwnn_str), "%016llX",
> +			(unsigned long long)wwnn);
> +
> +	/*
> +	 * if this is the "first" nport of the domain,
> +	 * then make it the "phys" nport
> +	 */
> +	if (list_empty(&domain->nport_list))
> +		domain->nport = nport;
> +
> +	INIT_LIST_HEAD(&nport->list_entry);
> +	list_add_tail(&nport->list_entry, &domain->nport_list);
> +
> +	kref_get(&domain->ref);
> +
> +	efc_log_debug(domain->efc, "New Nport [%s]\n", nport->display_name);
> +
> +	return nport;
> +}
> +
> +void
> +efc_nport_free(struct efc_nport *nport)
> +{
> +	struct efc_domain *domain;
> +
> +	if (!nport)
> +		return;
> +
> +	domain = nport->domain;
> +	efc_log_debug(domain->efc, "[%s] free nport\n", nport->display_name);
> +	list_del(&nport->list_entry);
> +	/*
> +	 * if this is the physical nport,
> +	 * then clear it out of the domain
> +	 */
> +	if (nport == domain->nport)
> +		domain->nport = NULL;
> +
> +	xa_destroy(&nport->lookup);
> +	xa_erase(&domain->lookup, nport->fc_id);
> +
> +	if (list_empty(&domain->nport_list))
> +		efc_domain_post_event(domain, EFC_EVT_ALL_CHILD_NODES_FREE,
> +				      NULL);
> +
> +	kref_put(&domain->ref, domain->release);
> +	kref_put(&nport->ref, nport->release);
> +
> +}
> +
> +struct efc_nport *
> +efc_nport_find(struct efc_domain *domain, u32 d_id)
> +{
> +	struct efc_nport *nport;
> +
> +	/* Find a nport object, given an FC_ID */
> +	nport = xa_load(&domain->lookup, d_id);
> +	if (!nport || !kref_get_unless_zero(&nport->ref))
> +		return NULL;
> +
> +	return nport;
> +}
> +
> +int
> +efc_nport_attach(struct efc_nport *nport, u32 fc_id)
> +{
> +	int rc;
> +	struct efc_node *node;
> +	struct efc *efc = nport->efc;
> +	unsigned long index;
> +
> +	/* Set our lookup */
> +	rc = xa_err(xa_store(&nport->domain->lookup, fc_id, nport, GFP_ATOMIC));
> +	if (rc) {
> +		efc_log_err(efc, "Sport lookup store failed: %d\n", rc);
> +		return rc;
> +	}
> +
> +	/* Update our display_name */
> +	efc_node_fcid_display(fc_id, nport->display_name,
> +			      sizeof(nport->display_name));
> +
> +	xa_for_each(&nport->lookup, index, node) {
> +		efc_node_update_display_name(node);
> +	}
> +
> +	efc_log_debug(nport->efc, "[%s] attach nport: fc_id x%06x\n",
> +		      nport->display_name, fc_id);
> +
> +	/* Register a nport, given an FC_ID */
> +	rc = efc_cmd_nport_attach(efc, nport, fc_id);
> +	if (rc != EFC_HW_RTN_SUCCESS) {
> +		efc_log_err(nport->efc,
> +			    "efc_hw_port_attach failed: %d\n", rc);
> +		return EFC_FAIL;
> +	}
> +	return EFC_SUCCESS;
> +}
> +
> +static void
> +efc_nport_shutdown(struct efc_nport *nport)
> +{
> +	struct efc *efc = nport->efc;
> +	struct efc_node *node;
> +	unsigned long index;
> +
> +	xa_for_each(&nport->lookup, index, node) {
> +		if (!(node->rnode.fc_id == FC_FID_FLOGI && nport->is_vport)) {
> +			efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
> +			continue;
> +		}
> +
> +		/*
> +		 * If this is a vport, logout of the fabric
> +		 * controller so that it deletes the vport
> +		 * on the switch.
> +		 */
> +		/* if link is down, don't send logo */
> +		if (efc->link_status == EFC_LINK_STATUS_DOWN) {
> +			efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
> +			continue;
> +		}
> +
> +		efc_log_debug(efc, "[%s] nport shutdown vport, send logo\n",
> +					node->display_name);
> +
> +		if (!efc_send_logo(node)) {
> +			/* sent LOGO, wait for response */
> +			efc_node_transition(node, __efc_d_wait_logo_rsp, NULL);
> +			continue;
> +		}
> +
> +		/*
> +		 * failed to send LOGO,
> +		 * go ahead and cleanup node anyways
> +		 */
> +		node_printf(node, "Failed to send LOGO\n");
> +		efc_node_post_event(node, EFC_EVT_SHUTDOWN_EXPLICIT_LOGO, NULL);
> +	}
> +}
> +
> +static void
> +efc_vport_link_down(struct efc_nport *nport)
> +{
> +	struct efc *efc = nport->efc;
> +	struct efc_vport_spec *vport;
> +
> +	/* Clear the nport reference in the vport specification */
> +	list_for_each_entry(vport, &efc->vport_list, list_entry) {
> +		if (vport->nport == nport) {
> +			kref_put(&nport->ref, nport->release);
> +			vport->nport = NULL;
> +			break;
> +		}
> +	}
> +}
> +
Hmm. I'm a bit confused with the 'vport_spec' thing.
Why is this not simply named 'vport'?
Especially as it's being held in a 'vport_list'?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AB9C2D0E2
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 00:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0991D20757
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 00:01:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Uq/WbUvc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgIWABf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 20:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbgIWABd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 20:01:33 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7298C061755
        for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2020 17:01:32 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z19so13909844pfn.8
        for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2020 17:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=mTygZ9kN4WHDhv85TH9eddenLeZoOK/ucVcHg+3UwZ8=;
        b=Uq/WbUvccA1i9sGwuJMmiMC0k++VbV89bjSZcs8MZWkvbfwPXpri1qVKPy2wnTKf+e
         ebIQ3ygLgig2KcCVJ0j9wBXy7t1t+q6zaaeV8NvpBXFfagz7hechVmVbgmjoriJDZ4ZM
         H7NOj2zb3l+N4e+JEwvSuGoC7ZWtPzw0GFXdw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=mTygZ9kN4WHDhv85TH9eddenLeZoOK/ucVcHg+3UwZ8=;
        b=rDKuh+hRv5yapXNJy1esKWZFn27w90N+224S0xnRKt+pTW1885jKrJEnfwfdbw/Dc8
         dmL5v6LcoLeLV7ZfzcylMUmT7AQiQRtJB+s9ibA8Y4/nAEV9/4SvEOGie6AOa1OxDiAN
         ZzKCsjEB2kjDxEaY1u/PYEblrtbO6nXApvL0r0Lqiw0zIgIRkhi1yswmQdIxqvxsWkIK
         s7ROdFnz8iQTaL7+z+vpDjXpHQ5Jsc+sGviMj31tlE+fT/YEgl16bgxh9wi0S8XaWqnJ
         3ryw6YMMAMfX5W7JNRZaDdHqHdU+5Y27kPMTpsbJWJxDJTdgWtEMx4AJ4iztx/cKW4kb
         d1Vg==
X-Gm-Message-State: AOAM532Q9S6gVvoHOtOcXPhnxzfMRdSZxvCCXWQE2+ALgK4HruePdt1T
        p074CBJ8IBFiqGobsHRB0+bMri1kFKpGuyGS
X-Google-Smtp-Source: ABdhPJzQpZyMvNY/VCiV9mKVC6vOtQssF/SzNn/UV0zmBnzKinBv6i58VKo9CY5mKv9vGwd0UW+KlQ==
X-Received: by 2002:aa7:9583:0:b029:142:2501:35cd with SMTP id z3-20020aa795830000b0290142250135cdmr1044606pfj.45.1600819291413;
        Tue, 22 Sep 2020 17:01:31 -0700 (PDT)
Received: from [10.69.69.102] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b4sm3265728pjz.22.2020.09.22.17.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 17:01:30 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 1/2] scsi: fc: Update statistics for host and rport on
 FPIN reception.
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        James Smart <james.smart@broadcom.com>
References: <20200730061116.20111-1-njavali@marvell.com>
 <20200730061116.20111-2-njavali@marvell.com>
Message-ID: <31d735ac-90d6-a601-0d8e-c15739684d23@broadcom.com>
Date:   Tue, 22 Sep 2020 17:01:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200730061116.20111-2-njavali@marvell.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000047fe2a05afefc913"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000047fe2a05afefc913
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US



On 7/29/2020 11:11 PM, Nilesh Javali wrote:
> From: Shyam Sundar<ssundar@marvell.com>
>
>   Add Fabric Performance Impact Notification (FPIN) stats structure to
>   fc_host_attr and the fc_rport structures to maintain FPIN statistics
>   for the respective entities when the LLD notifies the transport of an
>   FPIN ELS.
>
>   Add sysfs nodes to display FPIN statistics
>
>   Specifically, this patch:
>
> - Adds the formal definition of FPIN descriptors
> 	* Delivery Notification Descriptor
> 	* Peer Congestion Notification Descriptor
> 	* Congestion Notification Descriptor
>
> - Adds the formal definition of the event types associated with them
>
> - Adds a structure for holding fpin stats for host & rport
>
> - Adds functions to parse the FPIN ELS and update the stats
>
> - Adds sysfs nodes to maintain FPIN stats:
> 	/sys/class/fc_host/hostXX/statistics/
> 	/sys/class/fc_remote_ports/rport-XX\:Y-Z/statistics/
>
> - Add stats for Congestion Signals, that are delivered to the host as
>   interrupt signals, under fc_host_statistics.

This much separate functionality hints that this should be broken into 
several patches.
Recommendation:
- patch on fc_els.h additions for FPINs
- patch for framework - adding statistics to fc_host and fc_rport objects
- patch for the fpin parsing and statistics setting
- patch for cn_sign additions


> Signed-off-by: Shyam Sundar<ssundar@marvell.com>
> Signed-off-by: Nilesh Javali<njavali@marvell.com>
> ---
>   drivers/scsi/lpfc/lpfc_attr.c    |   2 +
>   drivers/scsi/qla2xxx/qla_attr.c  |   2 +
>   drivers/scsi/scsi_transport_fc.c | 410 ++++++++++++++++++++++++++++++-
>   include/scsi/scsi_transport_fc.h |  34 ++-
>   include/uapi/scsi/fc/fc_els.h    | 114 +++++++++
>   5 files changed, 559 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index a62c60ca6477..9fd35b90cb53 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -7158,6 +7158,8 @@ struct fc_function_template lpfc_transport_functions = {
>   	.set_rport_dev_loss_tmo = lpfc_set_rport_loss_tmo,
>   	.show_rport_dev_loss_tmo = 1,
>   
> +	.show_rport_statistics = 1,
> +
>   	.get_starget_port_id  = lpfc_get_starget_port_id,
>   	.show_starget_port_id = 1,
>   
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 5d93ccc73153..e34623b7cb6f 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -3143,6 +3143,8 @@ struct fc_function_template qla2xxx_transport_functions = {
>   	.set_rport_dev_loss_tmo = qla2x00_set_rport_loss_tmo,
>   	.show_rport_dev_loss_tmo = 1,
>   
> +	.show_rport_statistics = 1,
> +
>   	.issue_fc_host_lip = qla2x00_issue_lip,
>   	.dev_loss_tmo_callbk = qla2x00_dev_loss_tmo_callbk,
>   	.terminate_rport_io = qla2x00_terminate_rport_io,

Given this really doesn't interact with the driver (transport can export 
statistics and as transport routines do all the stats update), I think 
we should code it such that there does not need to be a 
show_xport_statistics flags.  They'll just be 0 if the lldd doesn't call 
the fpin_rcv routine.


> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 2732fa65119c..587b610e13a2 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -22,6 +22,7 @@
>   #include <net/netlink.h>
>   #include <scsi/scsi_netlink_fc.h>
>   #include <scsi/scsi_bsg_fc.h>
> +#include <uapi/scsi/fc/fc_els.h>
>   #include "scsi_priv.h"
>   
>   static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
> @@ -33,6 +34,10 @@ static int fc_bsg_hostadd(struct Scsi_Host *, struct fc_host_attrs *);
>   static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
>   static void fc_bsg_remove(struct request_queue *);
>   static void fc_bsg_goose_queue(struct fc_rport *);
> +static void fc_li_stats_update(struct fc_fn_li_desc *li_desc,
> +			       struct fpin_stats *stats);
> +static void fc_deli_stats_update(u32 reason_code, struct fpin_stats *stats);
> +static void fc_cn_stats_update(u16 event_type, struct fpin_stats *stats);
>   
>   /*
>    * Module Parameters
> @@ -418,6 +423,7 @@ static int fc_host_setup(struct transport_container *tc, struct device *dev,
>   	fc_host->fabric_name = -1;
>   	memset(fc_host->symbolic_name, 0, sizeof(fc_host->symbolic_name));
>   	memset(fc_host->system_hostname, 0, sizeof(fc_host->system_hostname));
> +	memset(&fc_host->stats, 0, sizeof(struct fpin_stats));

I'd prefer the fc_host field were named fpin_stats or something 
similar.  "stats" alone implies it may contain other kinds of statistics 
and "stats" with a "struct fpin_stats" isn't clean.

>   
>   	fc_host->tgtid_bind_type = FC_TGTID_BIND_BY_WWPN;
>   
> @@ -627,6 +633,266 @@ fc_host_post_vendor_event(struct Scsi_Host *shost, u32 event_number,
>   }
>   EXPORT_SYMBOL(fc_host_post_vendor_event);
>   
> +/**
> + * fc_find_rport_by_wwpn - find the fc_rport pointer for a given wwpn
> + * @shost:		host the fc_rport is associated with
> + * @wwpn:		wwpn of the fc_rport device
> + *
> + * Notes:
> + *	This routine assumes no locks are held on entry.
> + */
> +struct fc_rport *
> +fc_find_rport_by_wwpn(struct Scsi_Host *shost, u64 wwpn)
> +{
> +	struct fc_rport *rport, *found = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +
> +	list_for_each_entry(rport, &fc_host_rports(shost), peers) {
> +		if (rport->scsi_target_id == -1)
> +			continue;
> +
> +		if (rport->port_state != FC_PORTSTATE_ONLINE)
> +			continue;
> +
> +		if (rport->port_name == wwpn)
> +			found = rport;
tighten it up and exit when found:
           if (rport->scsi_target_id == -1 || rport->port_state != 
FC_PORTSTATE_ONLINE)
               continue;
           if (rport->port_name == wwpn) {
                found = rport;
                break;
           }


Given how generic this routine is - it's a little odd that it's 
validating the scsi target id - meaning it will bypass well known fabric 
rports (ok) but also nvme devices.  I think it needs to be matching nvme 
rports as well.  I recommend not validating scsi_target_id (so this is 
very generic and matches anything with the wwpn), and in the caller 
apply the validations to either the address or the role.

> +	}
> +
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +	return found;
> +}
> +EXPORT_SYMBOL(fc_find_rport_by_wwpn);
> +
> +static void
> +fc_li_stats_update(struct fc_fn_li_desc *li_desc,
> +		   struct fpin_stats *stats)
> +{
> +	switch (be16_to_cpu(li_desc->event_type)) {
> +	case FPIN_LI_UNKNOWN:
> +		stats->li_failure_unknown +=
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_LINK_FAILURE:
> +		stats->li_link_failure_count +=
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_LOSS_OF_SYNC:
> +		stats->li_loss_of_sync_count +=
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_LOSS_OF_SIG:
> +		stats->li_loss_of_signals_count +=
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_PRIM_SEQ_ERR:
> +		stats->li_prim_seq_err_count +=
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_INVALID_TX_WD:
> +		stats->li_invalid_tx_word_count +=
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_INVALID_CRC:
> +		stats->li_invalid_crc_count +=
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_DEVICE_SPEC:
> +		stats->li_device_specific +=
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	}
> +}
> +
> +static void
> +fc_deli_stats_update(u32 deli_reason_code, struct fpin_stats *stats)

nit: at least name the routine "fc_delivery_status_update" - deli is 
cute but not clear.

> +{
> +	switch (deli_reason_code) {
> +	case FPIN_DELI_UNKNOWN:
> +		stats->dn_unknown++;
> +		break;
> +	case FPIN_DELI_TIMEOUT:
> +		stats->dn_timeout++;
> +		break;
> +	case FPIN_DELI_UNABLE_TO_ROUTE:
> +		stats->dn_unable_to_route++;
> +		break;
> +	case FPIN_DELI_DEVICE_SPEC:
> +		stats->dn_device_specific++;
> +		break;
> +	}
> +}
> +
> +static void
> +fc_cn_stats_update(u16 event_type, struct fpin_stats *stats)
> +{
> +	switch (event_type) {
> +	case FPIN_CONGN_CLEAR:
> +		stats->cn_clear++;
> +		break;
> +	case FPIN_CONGN_LOST_CREDIT:
> +		stats->cn_lost_credit++;
> +		break;
> +	case FPIN_CONGN_CREDIT_STALL:
> +		stats->cn_credit_stall++;
> +		break;
> +	case FPIN_CONGN_OVERSUBSCRIPTION:
> +		stats->cn_oversubscription++;
> +		break;
> +	case FPIN_CONGN_DEVICE_SPEC:
> +		stats->cn_device_specific++;
> +	}
> +}
> +
> +/*
> + * fc_fpin_li_stats_update - routine to update Link Integrity
> + * event statistics.
> + * @shost:		host the FPIN was received on
> + * @tlv:		pointer to link integrity descriptor
> + *
> + */
> +static void
> +fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_tlv_desc *tlv)
> +{
> +	u8 i;
> +	struct fc_rport *rport = NULL;
> +	struct fc_rport *det_rport = NULL, *attach_rport = NULL;
> +	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
> +	struct fc_fn_li_desc *li_desc = (struct fc_fn_li_desc *)tlv;
> +	u64 wwpn;
> +
> +	rport = fc_find_rport_by_wwpn(shost,
> +				      be64_to_cpu(li_desc->detecting_wwpn));
> +	if (rport) {
> +		det_rport = rport;
> +		fc_li_stats_update(li_desc, &det_rport->stats);

this looks odd - why are the stats counting against both the detecting 
and attached ports - I would think it only counts against the "attached" 
port.

As it's the same counters - you loose the distinction of what it 
detected vs what it is generating.  My guess is most of the detecting 
ports would have been a switch port and it wouldn't have been found by 
the rport_by_wwpn, so this block wasn't getting executed.

> +	}
> +
> +	rport = fc_find_rport_by_wwpn(shost,
> +				      be64_to_cpu(li_desc->attached_wwpn));
> +	if (rport) {
> +		attach_rport = rport;
> +		fc_li_stats_update(li_desc, &attach_rport->stats);
> +	}
> +
> +	if (be32_to_cpu(li_desc->pname_count) > 0) {
> +		for (i = 0;
> +		    i < be32_to_cpu(li_desc->pname_count);
> +		    i++) {
> +			wwpn = be64_to_cpu(li_desc->pname_list[i]);
> +			rport = fc_find_rport_by_wwpn(shost, wwpn);
> +			if (rport && rport != det_rport &&
> +			    rport != attach_rport) {
> +				fc_li_stats_update(li_desc, &rport->stats);

I guess this is ok - but it makes it hard for administrators.  I believe 
this is the list of the other nports (aka npiv) on the "attached port" 
that is generating the error.  In that respect, it is correct to 
increment their counters - but I hope that an administrator knows that 
may resolve to a single physical port with only 1/N the error count.  
 From our use case in linux, as an initiator, to match an rport it must 
be a target port using npiv and from our point of view we don't know 
that they are all sharing the same physical port.


> +			}
> +		}
> +	}
> +
> +	if (fc_host->port_name == be64_to_cpu(li_desc->attached_wwpn))
> +		fc_li_stats_update(li_desc, &fc_host->stats);

looks good

> +}
> +
> +/*
> + * fc_fpin_deli_stats_update - routine to update Delivery Notification
> + * event statistics.
> + * @shost:		host the FPIN was received on
> + * @tlv:		pointer to delivery descriptor
> + *
> + */
> +static void
> +fc_fpin_deli_stats_update(struct Scsi_Host *shost,
> +			  struct fc_tlv_desc *tlv)

same nit comment

> +{
> +	struct fc_rport *rport = NULL;
> +	struct fc_rport *det_rport = NULL, *attach_rport = NULL;
> +	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
> +	struct fc_fn_deli_desc *deli_desc = (struct fc_fn_deli_desc *)tlv;
> +	u32 reason_code = be32_to_cpu(deli_desc->deli_reason_code);
> +
> +	rport = fc_find_rport_by_wwpn(shost,
> +				      be64_to_cpu(deli_desc->detecting_wwpn));
> +	if (rport) {
> +		det_rport = rport;
> +		fc_deli_stats_update(reason_code, &det_rport->stats);
> +	}

repeat of li comment - detecting port shouldn't be having stats counted 
against it.

> +
> +	rport = fc_find_rport_by_wwpn(shost,
> +				      be64_to_cpu(deli_desc->attached_wwpn));
> +	if (rport) {
> +		attach_rport = rport;
> +		fc_deli_stats_update(reason_code, &attach_rport->stats);
> +	}
> +
> +	if (fc_host->port_name == be64_to_cpu(deli_desc->attached_wwpn))
> +		fc_deli_stats_update(reason_code, &fc_host->stats);
> +}
> +
> +/*
> + * fc_fpin_peer_congn_stats_update - routine to update Peer Congestion
> + * event statistics.
> + * @shost:		host the FPIN was received on
> + * @tlv:		pointer to peer congestion descriptor
> + *
> + */
> +static void
> +fc_fpin_peer_congn_stats_update(struct Scsi_Host *shost,
> +				struct fc_tlv_desc *tlv)
> +{
> +	u8 i;
> +	struct fc_rport *rport = NULL;
> +	struct fc_rport *det_rport = NULL, *attach_rport = NULL;
> +	struct fc_fn_peer_congn_desc *pc_desc =
> +	    (struct fc_fn_peer_congn_desc *)tlv;
> +	u16 event_type = be16_to_cpu(pc_desc->event_type);
> +	u64 wwpn;
> +
> +	rport = fc_find_rport_by_wwpn(shost,
> +				      be64_to_cpu(pc_desc->detecting_wwpn));
> +	if (rport) {
> +		det_rport = rport;
> +		fc_cn_stats_update(event_type, &det_rport->stats);
> +	}

same comment - don't add stats to detecting port name.

> +
> +	rport = fc_find_rport_by_wwpn(shost,
> +				      be64_to_cpu(pc_desc->attached_wwpn));
> +	if (rport) {
> +		attach_rport = rport;
> +		fc_cn_stats_update(event_type, &attach_rport->stats);
> +	}
> +
> +	if (be32_to_cpu(pc_desc->pname_count) > 0) {
> +		for (i = 0;
> +		    i < be32_to_cpu(pc_desc->pname_count);
> +		    i++) {
> +			wwpn = be64_to_cpu(pc_desc->pname_list[i]);
> +			rport = fc_find_rport_by_wwpn(shost, wwpn);
> +			if (rport && rport != det_rport &&
> +			    rport != attach_rport) {
> +				fc_cn_stats_update(event_type,
> +						   &rport->stats);

same comment as li - good that we're adding to all rports, but admin 
must understand the multiplier if all on same port.

> +			}
> +		}
> +	}
> +}
> +
> +/*
> + * fc_fpin_congn_stats_update - routine to update Congestion
> + * event statistics.
> + * @shost:		host the FPIN was received on
> + * @tlv:		pointer to congestion descriptor
> + *
> + */
> +static void
> +fc_fpin_congn_stats_update(struct Scsi_Host *shost,
> +			   struct fc_tlv_desc *tlv)
> +{
> +	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
> +	struct fc_fn_congn_desc *congn = (struct fc_fn_congn_desc *)tlv;
> +
> +	fc_cn_stats_update(be16_to_cpu(congn->event_type), &fc_host->stats);
> +}
> +
>   /**
>    * fc_host_rcv_fpin - routine to process a received FPIN.
>    * @shost:		host the FPIN was received on
> @@ -639,8 +905,41 @@ EXPORT_SYMBOL(fc_host_post_vendor_event);
>   void
>   fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf)
>   {
> +	struct fc_els_fpin *fpin = (struct fc_els_fpin *)fpin_buf;
> +	struct fc_tlv_desc *tlv;
> +	u32 desc_cnt = 0, bytes_remain;
> +	u32 dtag;
> +
> +	/* Update Statistics */
> +	tlv = (struct fc_tlv_desc *)&fpin->fpin_desc[0];
> +	bytes_remain = fpin_len - offsetof(struct fc_els_fpin, fpin_desc);
> +	bytes_remain = min_t(u32, bytes_remain, be32_to_cpu(fpin->desc_len));
> +
> +	while (bytes_remain >= FC_TLV_DESC_HDR_SZ &&
> +	       bytes_remain >= FC_TLV_DESC_SZ_FROM_LENGTH(tlv)) {
> +		dtag = be32_to_cpu(tlv->desc_tag);
> +		switch (dtag) {
> +		case ELS_DTAG_LNK_INTEGRITY:
> +			fc_fpin_li_stats_update(shost, tlv);
> +			break;
> +		case ELS_DTAG_DELIVERY:
> +			fc_fpin_deli_stats_update(shost, tlv);
> +			break;
> +		case ELS_DTAG_PEER_CONGEST:
> +			fc_fpin_peer_congn_stats_update(shost, tlv);
> +			break;
> +		case ELS_DTAG_CONGESTION:
> +			fc_fpin_congn_stats_update(shost, tlv);
> +		}
> +
> +		desc_cnt++;
> +		bytes_remain -= FC_TLV_DESC_SZ_FROM_LENGTH(tlv);
> +		tlv = fc_tlv_next_desc(tlv);
> +	}
> +
>   	fc_host_post_fc_event(shost, fc_get_event_number(),
> -				FCH_EVT_LINK_FPIN, fpin_len, fpin_buf, 0);
> +			      FCH_EVT_LINK_FPIN, fpin_len, fpin_buf, 0);
> +
>   }
>   EXPORT_SYMBOL(fc_host_fpin_rcv);

Question: I know we've been asked to log the fpins to the kernel log.  
Holding on to the counts and so is good, but it still loses some of the 
relationship of the detected port (what detected what attached port).  
What's your thinking on it. Should it be something in these common 
routines and enabled/disabled by a sysfs toggle ?

>   
> @@ -990,6 +1289,61 @@ store_fc_rport_fast_io_fail_tmo(struct device *dev,
>   static FC_DEVICE_ATTR(rport, fast_io_fail_tmo, S_IRUGO | S_IWUSR,
>   	show_fc_rport_fast_io_fail_tmo, store_fc_rport_fast_io_fail_tmo);
>   
> +#define fc_rport_fpin_statistic(name)					\
> +static ssize_t fc_rport_fpinstat_##name(struct device *cd,		\
> +				  struct device_attribute *attr,	\
> +				  char *buf)				\
> +{									\
> +	struct fc_rport *rport = transport_class_to_rport(cd);		\
> +									\
> +	return snprintf(buf, 20, "0x%llx\n", rport->stats.name);	\
> +}									\
> +static FC_DEVICE_ATTR(rport, fpin_##name, 0444, fc_rport_fpinstat_##name, NULL)
> +
> +fc_rport_fpin_statistic(dn_unknown);
> +fc_rport_fpin_statistic(dn_timeout);
> +fc_rport_fpin_statistic(dn_unable_to_route);
> +fc_rport_fpin_statistic(dn_device_specific);
> +fc_rport_fpin_statistic(cn_clear);
> +fc_rport_fpin_statistic(cn_lost_credit);
> +fc_rport_fpin_statistic(cn_credit_stall);
> +fc_rport_fpin_statistic(cn_oversubscription);
> +fc_rport_fpin_statistic(cn_device_specific);
> +fc_rport_fpin_statistic(li_failure_unknown);
> +fc_rport_fpin_statistic(li_link_failure_count);
> +fc_rport_fpin_statistic(li_loss_of_sync_count);
> +fc_rport_fpin_statistic(li_loss_of_signals_count);
> +fc_rport_fpin_statistic(li_prim_seq_err_count);
> +fc_rport_fpin_statistic(li_invalid_tx_word_count);
> +fc_rport_fpin_statistic(li_invalid_crc_count);
> +fc_rport_fpin_statistic(li_device_specific);
> +
> +static struct attribute *fc_rport_statistics_attrs[] = {
> +	&device_attr_rport_fpin_dn_unknown.attr,
> +	&device_attr_rport_fpin_dn_timeout.attr,
> +	&device_attr_rport_fpin_dn_unable_to_route.attr,
> +	&device_attr_rport_fpin_dn_device_specific.attr,
> +	&device_attr_rport_fpin_li_failure_unknown.attr,
> +	&device_attr_rport_fpin_li_link_failure_count.attr,
> +	&device_attr_rport_fpin_li_loss_of_sync_count.attr,
> +	&device_attr_rport_fpin_li_loss_of_signals_count.attr,
> +	&device_attr_rport_fpin_li_prim_seq_err_count.attr,
> +	&device_attr_rport_fpin_li_invalid_tx_word_count.attr,
> +	&device_attr_rport_fpin_li_invalid_crc_count.attr,
> +	&device_attr_rport_fpin_li_device_specific.attr,
> +	&device_attr_rport_fpin_cn_clear.attr,
> +	&device_attr_rport_fpin_cn_lost_credit.attr,
> +	&device_attr_rport_fpin_cn_credit_stall.attr,
> +	&device_attr_rport_fpin_cn_oversubscription.attr,
> +	&device_attr_rport_fpin_cn_device_specific.attr,
> +	NULL
> +};
> +
> +static struct attribute_group fc_rport_statistics_group = {
> +	.name = "statistics",
> +	.attrs = fc_rport_statistics_attrs,
> +};
> +
>   
>   /*
>    * FC SCSI Target Attribute Management
> @@ -1743,6 +2097,38 @@ fc_host_statistic(fc_xid_not_found);
>   fc_host_statistic(fc_xid_busy);
>   fc_host_statistic(fc_seq_not_found);
>   fc_host_statistic(fc_non_bls_resp);
> +fc_host_statistic(cn_sig_warn);
> +fc_host_statistic(cn_sig_alarm);

Please add statistics for the # of each type of fpin descriptor received 
on the shost.  Increment by 1 in each of the descriptor-based update 
routines.


Rest looks good.

Thanks

-- james



--00000000000047fe2a05afefc913
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgUijrVbJnjkhnNbKf
SUvty2kqVXZXsUmVN3/Qoi+hEegwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAwOTIzMDAwMTMyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAKZPFlKCiEKzK+EzPteyA4oGnAJ2xqeiFA/w
TTyP9ItTA926qSvWDvukK7IRbamtYVAzTUVSyXpxNYcuJQ/6xvUQNE3G9J2GeQzZQu1vxA7k6+Vn
xA8igo2k2CJgry6oOJrkytEW+GGZiCNRqMDeZBieo2gopdVGkgQfgm8ddXqQJeE7yhbvPnc3hh/7
h+NmQcEryVswKCVbkacjaJ2KhrvAzTNop7M4PCvIJX8nLP92dJq5xelgb3CPby8KHB7YZCWAmn4N
LhmDqjsDwq5CZ4FST57Sk1b7KDEFczez1u9MMK8+uCO8JqzGkPTCAgYado5zp7m10BAOLGc6v8j0
rzA=
--00000000000047fe2a05afefc913--

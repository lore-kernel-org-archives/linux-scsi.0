Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02377C47080
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 12:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6435613B1
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 12:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbhFAMhX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 08:37:23 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:48234 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbhFAMhX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 08:37:23 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 265741FD2D;
        Tue,  1 Jun 2021 12:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622550941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vZK7OMExMGOG+MnztyVWrqvX9Jsjg8Wf4MZ82JgUybw=;
        b=SOUO29hq/tZQHOil8f40Ad+kVNLJzD1MpS9K6ias5bY1HqrXNZRtUOHgC5PDkjgGyUAoQS
        dTZ0oJRHExWR2iAiD+qlPYfL4R1Wko/mqrJdhIABYWoloMsU/YPUORgYXLUDsBZQUevezU
        OvY5gwlKOd7a41JWkmDBv1m1NiMWFyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622550941;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vZK7OMExMGOG+MnztyVWrqvX9Jsjg8Wf4MZ82JgUybw=;
        b=sMZ1KujmLOZPAiFyWpZAe7ZT4s+c8DaAodWcGdVBpmG/e1hhJIjdmhE10CUm1hF7Q6GKN+
        W1qcBDqr8H4HcUBw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id E4606118DD;
        Tue,  1 Jun 2021 12:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622550941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vZK7OMExMGOG+MnztyVWrqvX9Jsjg8Wf4MZ82JgUybw=;
        b=SOUO29hq/tZQHOil8f40Ad+kVNLJzD1MpS9K6ias5bY1HqrXNZRtUOHgC5PDkjgGyUAoQS
        dTZ0oJRHExWR2iAiD+qlPYfL4R1Wko/mqrJdhIABYWoloMsU/YPUORgYXLUDsBZQUevezU
        OvY5gwlKOd7a41JWkmDBv1m1NiMWFyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622550941;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vZK7OMExMGOG+MnztyVWrqvX9Jsjg8Wf4MZ82JgUybw=;
        b=sMZ1KujmLOZPAiFyWpZAe7ZT4s+c8DaAodWcGdVBpmG/e1hhJIjdmhE10CUm1hF7Q6GKN+
        W1qcBDqr8H4HcUBw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id pKsVNpwptmB/XgAALh3uQQ
        (envelope-from <hare@suse.de>); Tue, 01 Jun 2021 12:35:40 +0000
Subject: Re: [PATCH v2 02/10] qla2xxx: Add getfcinfo and statistic bsg's
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-3-njavali@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <120562a3-40e4-026a-d3f8-4c2580dc5a52@suse.de>
Date:   Tue, 1 Jun 2021 14:35:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210531070545.32072-3-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/31/21 9:05 AM, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Latest FC adapter from Marvell has the ability to encrypt
> data in flight (EDIF) feature. This feature require an
> application (ex: ipsec, etc) to act as an authenticator.
> 
> This patch add 2 new BSG calls:
> QL_VND_SC_GET_FCINFO: Application from time to time can request
> for a list of all FC ports or a single device that support
> secure connection. If driver sees a new or old device has
> came onto the switch, this call is used to check for the WWPN.
> 
> QL_VND_SC_GET_STATS: Application request for various statistic
> count of each FC port.
> 
> Signed-off-by: Larry Wisneski <Larry.Wisneski@marvell.com>
> Signed-off-by: Duane Grigsby <duane.grigsby@marvell.com>
> Signed-off-by: Rick Hicksted Jr <rhicksted@marvell.com>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_def.h  |   2 +
>  drivers/scsi/qla2xxx/qla_edif.c | 182 ++++++++++++++++++++++++++++++++
>  2 files changed, 184 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index ac3b9b39d741..9c921381d020 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2574,6 +2574,8 @@ typedef struct fc_port {
>  		uint16_t	app_started:1;
>  		uint16_t	secured_login:1;
>  		uint16_t	app_sess_online:1;
> +		uint16_t	rekey_cnt;	// num of times rekeyed
> +		uint8_t		auth_state;	/* cureent auth state */
>  		uint32_t	tx_rekey_cnt;
>  		uint32_t	rx_rekey_cnt;
>  		// delayed rx delete data structure list

Please check structure alignment.

> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> index 38d79ef2e700..fd39232fa68d 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -258,6 +258,182 @@ qla_edif_app_stop(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
>  	return rval;
>  }
>  
> +/*
> + * event that the app needs fc port info (either all or individual d_id)
> + */
> +static int
> +qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
> +{
> +	int32_t			rval = 0;
> +	int32_t			num_cnt = 1;
> +	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
> +	struct app_pinfo_req	app_req;
> +	struct app_pinfo_reply	*app_reply;
> +	port_id_t		tdid;
> +
> +	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app get fcinfo\n", __func__);
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +	    bsg_job->request_payload.sg_cnt, &app_req,
> +	    sizeof(struct app_pinfo_req));
> +
> +	num_cnt =  app_req.num_ports;	/* num of ports alloc'd by app */
> +
> +	app_reply = kzalloc((sizeof(struct app_pinfo_reply) +
> +	    sizeof(struct app_pinfo) * num_cnt), GFP_KERNEL);
> +	if (!app_reply) {
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		rval = -1;
> +	} else {
> +		struct fc_port	*fcport = NULL, *tf;
> +		uint32_t	pcnt = 0;
> +
> +		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
> +			if (!(fcport->flags & FCF_FCSP_DEVICE))
> +				continue;
> +
> +			tdid = app_req.remote_pid;
> +
> +			ql_dbg(ql_dbg_edif, vha, 0x2058,
> +			    "APP request entry - portid=%02x%02x%02x.\n",
> +			    tdid.b.domain, tdid.b.area, tdid.b.al_pa);
> +
> +			/* Ran out of space */
> +			if (pcnt > app_req.num_ports)
> +				break;
> +
> +			if (tdid.b24 != 0 && tdid.b24 != fcport->d_id.b24)
> +				continue;
> +
> +			app_reply->ports[pcnt].remote_type =
> +				VND_CMD_RTYPE_UNKNOWN;
> +			if (fcport->port_type & (FCT_NVME_TARGET | FCT_TARGET))
> +				app_reply->ports[pcnt].remote_type |=
> +					VND_CMD_RTYPE_TARGET;
> +			if (fcport->port_type & (FCT_NVME_INITIATOR | FCT_INITIATOR))
> +				app_reply->ports[pcnt].remote_type |=
> +					VND_CMD_RTYPE_INITIATOR;
> +
> +			app_reply->ports[pcnt].remote_pid = fcport->d_id;
> +
> +			ql_dbg(ql_dbg_edif, vha, 0x2058,
> +	"Found FC_SP fcport - nn %8phN pn %8phN pcnt %d portid=%02x%02x%02x.\n",

Indentation.

> +			    fcport->node_name, fcport->port_name, pcnt,
> +			    fcport->d_id.b.domain, fcport->d_id.b.area,
> +			    fcport->d_id.b.al_pa);
> +
> +			switch (fcport->edif.auth_state) {
> +			case VND_CMD_AUTH_STATE_ELS_RCVD:
> +				if (fcport->disc_state == DSC_LOGIN_AUTH_PEND) {
> +					fcport->edif.auth_state = VND_CMD_AUTH_STATE_NEEDED;
> +					app_reply->ports[pcnt].auth_state =
> +						VND_CMD_AUTH_STATE_NEEDED;
> +				} else {
> +					app_reply->ports[pcnt].auth_state =
> +						VND_CMD_AUTH_STATE_ELS_RCVD;
> +				}
> +				break;
> +			default:
> +				app_reply->ports[pcnt].auth_state = fcport->edif.auth_state;
> +				break;
> +			}
> +
> +			memcpy(app_reply->ports[pcnt].remote_wwpn,
> +			    fcport->port_name, 8);
> +
> +			app_reply->ports[pcnt].remote_state =
> +				(atomic_read(&fcport->state) ==
> +				    FCS_ONLINE ? 1 : 0);
> +
> +			pcnt++;
> +
> +			if (tdid.b24 != 0)
> +				break;  /* found the one req'd */
> +		}
> +		app_reply->port_count = pcnt;
> +		SET_DID_STATUS(bsg_reply->result, DID_OK);
> +	}
> +
> +	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +	    bsg_job->reply_payload.sg_cnt, app_reply,
> +	    sizeof(struct app_pinfo_reply) + sizeof(struct app_pinfo) * num_cnt);
> +
> +	kfree(app_reply);
> +
> +	return rval;
> +}
> +
> +/*
> + * return edif stats (TBD) to app
> + */
> +static int32_t
> +qla_edif_app_getstats(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
> +{
> +	int32_t			rval = 0;
> +	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
> +	uint32_t ret_size, size;
> +
> +	struct app_sinfo_req	app_req;
> +	struct app_stats_reply	*app_reply;
> +
> +	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
> +	    bsg_job->request_payload.sg_cnt, &app_req,
> +	    sizeof(struct app_sinfo_req));
> +	if (app_req.num_ports == 0) {
> +		ql_dbg(ql_dbg_async, vha, 0x911d,
> +		   "%s app did not indicate number of ports to return\n",
> +		    __func__);
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		rval = -1;
> +	}
> +
> +	size = sizeof(struct app_stats_reply) +
> +	    (sizeof(struct app_sinfo) * app_req.num_ports);
> +
> +	if (size > bsg_job->reply_payload.payload_len)
> +		ret_size = bsg_job->reply_payload.payload_len;
> +	else
> +		ret_size = size;
> +
> +	app_reply = kzalloc(size, GFP_KERNEL);
> +	if (!app_reply) {
> +		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
> +		rval = -1;
> +	} else {
> +		struct fc_port	*fcport = NULL, *tf;
> +		uint32_t	pcnt = 0;
> +
> +		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
> +			if (fcport->edif.enable) {
> +				if (pcnt > app_req.num_ports)
> +					break;
> +
> +				app_reply->elem[pcnt].rekey_count =
> +				    fcport->edif.rekey_cnt;
> +				app_reply->elem[pcnt].tx_bytes =
> +				    fcport->edif.tx_bytes;
> +				app_reply->elem[pcnt].rx_bytes =
> +				    fcport->edif.rx_bytes;
> +
> +				memcpy(app_reply->elem[pcnt].remote_wwpn,
> +				    fcport->port_name, 8);
> +
> +				pcnt++;
> +			}
> +		}
> +		app_reply->elem_count = pcnt;
> +		SET_DID_STATUS(bsg_reply->result, DID_OK);
> +	}
> +
> +	bsg_reply->reply_payload_rcv_len =
> +	    sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
> +	       bsg_job->reply_payload.sg_cnt, app_reply, ret_size);
> +
> +	kfree(app_reply);
> +
> +	return rval;
> +}
> +
>  int32_t
>  qla_edif_app_mgmt(struct bsg_job *bsg_job)
>  {
> @@ -304,6 +480,12 @@ qla_edif_app_mgmt(struct bsg_job *bsg_job)
>  	case QL_VND_SC_APP_STOP:
>  		rval = qla_edif_app_stop(vha, bsg_job);
>  		break;
> +	case QL_VND_SC_GET_FCINFO:
> +		rval = qla_edif_app_getfcinfo(vha, bsg_job);
> +		break;
> +	case QL_VND_SC_GET_STATS:
> +		rval = qla_edif_app_getstats(vha, bsg_job);
> +		break;
>  	default:
>  		ql_dbg(ql_dbg_edif, vha, 0x911d, "%s unknown cmd=%x\n",
>  		    __func__,
> 
Other than that:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)

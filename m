Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07853C55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4F0D20731
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgKPIUC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 03:20:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:45800 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgKPIUB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 03:20:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1B8A6AFB0;
        Mon, 16 Nov 2020 08:19:59 +0000 (UTC)
Subject: Re: [PATCH v7 3/5] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
 <1605070685-20945-4-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <4e638c14-faf4-0a63-a715-86e9baabedda@suse.de>
Date:   Mon, 16 Nov 2020 09:19:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1605070685-20945-4-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/20 5:58 AM, Muneendra wrote:
> Added a new rport state FC_PORTSTATE_MARGINAL.
> 
> Added a new interface fc_eh_should_retry_cmd which Checks if the cmd
> should be retried or not by checking the rport state.
> If the rport state is marginal it returns
> false to make sure there won't be any retries on the cmd.
> 
> Also made changes in fc_remote_port_delete,fc_user_scan_tgt,
> fc_timeout_deleted_rport functions  to handle the new rport state
> FC_PORTSTATE_MARGINAL.
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v7:
> Removed the changes related to SCMD_NORETRIES_ABORT bit.
> 
> Added a new function fc_eh_should_retry_cmd to check whether the cmd
> should be retried based on the rport state.
> 
> v6:
> No change
> 
> v5:
> Made changes to clear the SCMD_NORETRIES_ABORT bit if the port_state
> has changed from marginal to online due to port_delete and port_add
> as we need the normal cmd retry behaviour
> 
> Made changes in fc_scsi_scan_rport as we are checking FC_PORTSTATE_ONLINE
> instead of FC_PORTSTATE_ONLINE and FC_PORTSTATE_MARGINAL
> 
> v4:
> Made changes in fc_eh_timed_out to call fc_rport_chkmarginal_set_noretries
> so that SCMD_NORETRIES_ABORT bit in cmd->state is set if rport state
> is marginal.
> 
> Removed the newly added scsi_cmd argument to fc_remote_port_chkready
> as the current patch handles only SCSI EH timeout/abort case.
> 
> v3:
> Rearranged the patch so that all the changes with respect to new
> rport state is part of this patch.
> Added a new argument to scsi_cmd  to fc_remote_port_chkready
> 
> v2:
> New patch
> ---
>   drivers/scsi/scsi_transport_fc.c | 62 +++++++++++++++++++++++---------
>   include/scsi/scsi_transport_fc.h |  4 ++-
>   2 files changed, 49 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index a926e8f9e56e..ffd25195ae62 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -148,20 +148,23 @@ fc_enum_name_search(host_event_code, fc_host_event_code,
>   static struct {
>   	enum fc_port_state	value;
>   	char			*name;
> +	int			matchlen;
>   } fc_port_state_names[] = {
> -	{ FC_PORTSTATE_UNKNOWN,		"Unknown" },
> -	{ FC_PORTSTATE_NOTPRESENT,	"Not Present" },
> -	{ FC_PORTSTATE_ONLINE,		"Online" },
> -	{ FC_PORTSTATE_OFFLINE,		"Offline" },
> -	{ FC_PORTSTATE_BLOCKED,		"Blocked" },
> -	{ FC_PORTSTATE_BYPASSED,	"Bypassed" },
> -	{ FC_PORTSTATE_DIAGNOSTICS,	"Diagnostics" },
> -	{ FC_PORTSTATE_LINKDOWN,	"Linkdown" },
> -	{ FC_PORTSTATE_ERROR,		"Error" },
> -	{ FC_PORTSTATE_LOOPBACK,	"Loopback" },
> -	{ FC_PORTSTATE_DELETED,		"Deleted" },
> +	{ FC_PORTSTATE_UNKNOWN,		"Unknown", 7},
> +	{ FC_PORTSTATE_NOTPRESENT,	"Not Present", 11 },
> +	{ FC_PORTSTATE_ONLINE,		"Online", 6 },
> +	{ FC_PORTSTATE_OFFLINE,		"Offline", 7 },
> +	{ FC_PORTSTATE_BLOCKED,		"Blocked", 7 },
> +	{ FC_PORTSTATE_BYPASSED,	"Bypassed", 8 },
> +	{ FC_PORTSTATE_DIAGNOSTICS,	"Diagnostics", 11 },
> +	{ FC_PORTSTATE_LINKDOWN,	"Linkdown", 8 },
> +	{ FC_PORTSTATE_ERROR,		"Error", 5 },
> +	{ FC_PORTSTATE_LOOPBACK,	"Loopback", 8 },
> +	{ FC_PORTSTATE_DELETED,		"Deleted", 7 },
> +	{ FC_PORTSTATE_MARGINAL,	"Marginal", 8 },

Why did you append the length of the string here?
This doesn't have anything to do with this patch, but rather is an 
improvement/modification of the original code, and should be delegated 
to a separate patch.

>   };
>   fc_enum_name_search(port_state, fc_port_state, fc_port_state_names)
> +fc_enum_name_match(port_state, fc_port_state, fc_port_state_names)
>   #define FC_PORTSTATE_MAX_NAMELEN	20
>   
>   
> @@ -2509,7 +2512,8 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint channel, uint id, u64 lun)
>   		if (rport->scsi_target_id == -1)
>   			continue;
>   
> -		if (rport->port_state != FC_PORTSTATE_ONLINE)
> +		if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> +			(rport->port_state != FC_PORTSTATE_MARGINAL))
>   			continue;
>   
>   		if ((channel == rport->channel) &&
> @@ -3373,7 +3377,8 @@ fc_remote_port_delete(struct fc_rport  *rport)
>   
>   	spin_lock_irqsave(shost->host_lock, flags);
>   
> -	if (rport->port_state != FC_PORTSTATE_ONLINE) {
> +	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> +		(rport->port_state != FC_PORTSTATE_MARGINAL)) {
>   		spin_unlock_irqrestore(shost->host_lock, flags);
>   		return;
>   	}
> @@ -3515,7 +3520,8 @@ fc_timeout_deleted_rport(struct work_struct *work)
>   	 * target, validate it still is. If not, tear down the
>   	 * scsi_target on it.
>   	 */
> -	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
> +	if (((rport->port_state == FC_PORTSTATE_ONLINE) ||
> +		(rport->port_state == FC_PORTSTATE_MARGINAL)) &&
>   	    (rport->scsi_target_id != -1) &&
>   	    !(rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
>   		dev_printk(KERN_ERR, &rport->dev,
> @@ -3658,7 +3664,8 @@ fc_scsi_scan_rport(struct work_struct *work)
>   	struct fc_internal *i = to_fc_internal(shost->transportt);
>   	unsigned long flags;
>   
> -	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
> +	if (((rport->port_state == FC_PORTSTATE_ONLINE) ||
> +		(rport->port_state == FC_PORTSTATE_MARGINAL)) &&
>   	    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
>   	    !(i->f->disable_target_scan)) {
>   		scsi_scan_target(&rport->dev, rport->channel,
> @@ -3731,6 +3738,28 @@ int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
>   }
>   EXPORT_SYMBOL(fc_block_scsi_eh);
>   
> +/*
> + * fc_eh_should_retry_cmd - Checks if the cmd should be retried or not
> + * @scmd:        The SCSI command to be checked
> + *
> + * This checks the rport state to decide if a cmd is
> + * retryable.
> + *
> + * Returns: true if the rport state is not in marginal state.
> + */
> +bool fc_eh_should_retry_cmd(struct scsi_cmnd *scmd)
> +{
> +	struct fc_rport *rport = starget_to_rport(scsi_target(scmd->device));
> +
> +	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> +		(scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT)) {
> +		set_host_byte(scmd, DID_TRANSPORT_MARGINAL);
> +		return false;
> +	}
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(fc_eh_should_retry_cmd);
> +
>   /**
>    * fc_vport_setup - allocates and creates a FC virtual port.
>    * @shost:	scsi host the virtual port is connected to.
> @@ -4162,7 +4191,8 @@ static blk_status_t fc_bsg_rport_prep(struct fc_rport *rport)
>   	    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
>   		return BLK_STS_RESOURCE;
>   
> -	if (rport->port_state != FC_PORTSTATE_ONLINE)
> +	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> +		(rport->port_state != FC_PORTSTATE_MARGINAL))
>   		return BLK_STS_IOERR;
>   
>   	return BLK_STS_OK;
> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
> index c759b29e46c7..14214ee121ad 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -67,6 +67,7 @@ enum fc_port_state {
>   	FC_PORTSTATE_ERROR,
>   	FC_PORTSTATE_LOOPBACK,
>   	FC_PORTSTATE_DELETED,
> +	FC_PORTSTATE_MARGINAL,
>   };
>   
>   
> @@ -742,7 +743,6 @@ struct fc_function_template {
>   	unsigned long	disable_target_scan:1;
>   };
>   
> -
>   /**
>    * fc_remote_port_chkready - called to validate the remote port state
>    *   prior to initiating io to the port.
> @@ -758,6 +758,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
>   
>   	switch (rport->port_state) {
>   	case FC_PORTSTATE_ONLINE:
> +	case FC_PORTSTATE_MARGINAL:
>   		if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
>   			result = 0;
>   		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
> @@ -839,6 +840,7 @@ int fc_vport_terminate(struct fc_vport *vport);
>   int fc_block_rport(struct fc_rport *rport);
>   int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
>   enum blk_eh_timer_return fc_eh_timed_out(struct scsi_cmnd *scmd);
> +bool fc_eh_should_retry_cmd(struct scsi_cmnd *scmd);
>   
>   static inline struct Scsi_Host *fc_bsg_to_shost(struct bsg_job *job)
>   {
> 
Other than that:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

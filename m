Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADEC5C4363A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 11:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F4F522265
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 11:48:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MQCJ3ZO/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773972AbgJZLs2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 07:48:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40052 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1772606AbgJZLs2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Oct 2020 07:48:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603712905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BAg4NPiQeZ5ZueJAugDL6waABqllP1Np7akfk3Zu/Ps=;
        b=MQCJ3ZO/1/NrmUUS49SY3lvi7JqawVewJs9rqwJBzs3hbtmNxC1HkWh0WbO+LQGA9jrJMB
        m4d58W6s1o1O9lAfVawUqudiPlvW688+1NC0NSrsqHhH7zNfdKTdOnFKbn90iCtjtixRjh
        o/eLfGl/m0Cmg6+AFrJ8bAt3uiXSAaE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-0rUlNTtAO0yWWaeqlZ7Q5A-1; Mon, 26 Oct 2020 07:48:23 -0400
X-MC-Unique: 0rUlNTtAO0yWWaeqlZ7Q5A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85F96835B7E;
        Mon, 26 Oct 2020 11:48:22 +0000 (UTC)
Received: from ovpn-112-111.phx2.redhat.com (ovpn-112-111.phx2.redhat.com [10.3.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB6955B4B3;
        Mon, 26 Oct 2020 11:48:21 +0000 (UTC)
Message-ID: <e067dd48cbc1b0d09032c7b449a4f5d6802bac1b.camel@redhat.com>
Subject: Re: [patch v4 4/5] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        hare@suse.de
Cc:     jsmart2021@gmail.com, mkumar@redhat.com
Date:   Mon, 26 Oct 2020 07:48:21 -0400
In-Reply-To: <1603370091-9337-5-git-send-email-muneendra.kumar@broadcom.com>
References: <1603370091-9337-1-git-send-email-muneendra.kumar@broadcom.com>
         <1603370091-9337-5-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

See below.  I think you wanted to check for FC_PORTSTATE_MARGINAL
in the code you added to fc_scsi_scan_rport().  Instead the code
tests for FC_PORTSTATE_ONLINE twice.

-Ewan

On Thu, 2020-10-22 at 18:04 +0530, Muneendra wrote:
> Added a new rport state FC_PORTSTATE_MARGINAL.
> 
> Added a new inline function fc_rport_chkmarginal_set_noretries
> which will set the SCMD_NORETRIES_ABORT bit in cmd->state if rport
> state
> is marginal.
> 
> Made changes in fc_eh_timed_out to call
> fc_rport_chkmarginal_set_noretries
> Also made changes in fc_remote_port_delete,fc_user_scan_tgt,
> fc_timeout_deleted_rport functions  to handle the new rport state
> FC_PORTSTATE_MARGINAL.
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v4:
> Made changes in fc_eh_timed_out to call
> fc_rport_chkmarginal_set_noretries
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
>  drivers/scsi/scsi_transport_fc.c | 41 +++++++++++++++++++-----------
> --
>  include/scsi/scsi_transport_fc.h | 19 +++++++++++++++
>  2 files changed, 44 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c
> b/drivers/scsi/scsi_transport_fc.c
> index 2ff7f06203da..fcb38068e2a4 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -142,20 +142,23 @@ fc_enum_name_search(host_event_code,
> fc_host_event_code,
>  static struct {
>  	enum fc_port_state	value;
>  	char			*name;
> +	int			matchlen;
>  } fc_port_state_names[] = {
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
>  };
>  fc_enum_name_search(port_state, fc_port_state, fc_port_state_names)
> +fc_enum_name_match(port_state, fc_port_state, fc_port_state_names)
>  #define FC_PORTSTATE_MAX_NAMELEN	20
>  
>  
> @@ -2071,6 +2074,7 @@ fc_eh_timed_out(struct scsi_cmnd *scmd)
>  {
>  	struct fc_rport *rport = starget_to_rport(scsi_target(scmd-
> >device));
>  
> +	fc_rport_chkmarginal_set_noretries(rport, scmd);
>  	if (rport->port_state == FC_PORTSTATE_BLOCKED)
>  		return BLK_EH_RESET_TIMER;
>  
> @@ -2095,7 +2099,8 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint
> channel, uint id, u64 lun)
>  		if (rport->scsi_target_id == -1)
>  			continue;
>  
> -		if (rport->port_state != FC_PORTSTATE_ONLINE)
> +		if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> +			(rport->port_state != FC_PORTSTATE_MARGINAL))
>  			continue;
>  
>  		if ((channel == rport->channel) &&
> @@ -2958,7 +2963,8 @@ fc_remote_port_delete(struct fc_rport  *rport)
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
>  
> -	if (rport->port_state != FC_PORTSTATE_ONLINE) {
> +	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> +		(rport->port_state != FC_PORTSTATE_MARGINAL)) {
>  		spin_unlock_irqrestore(shost->host_lock, flags);
>  		return;
>  	}
> @@ -3100,7 +3106,8 @@ fc_timeout_deleted_rport(struct work_struct
> *work)
>  	 * target, validate it still is. If not, tear down the
>  	 * scsi_target on it.
>  	 */
> -	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
> +	if (((rport->port_state == FC_PORTSTATE_ONLINE) ||
> +		(rport->port_state == FC_PORTSTATE_MARGINAL)) &&
>  	    (rport->scsi_target_id != -1) &&
>  	    !(rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
>  		dev_printk(KERN_ERR, &rport->dev,
> @@ -3243,7 +3250,8 @@ fc_scsi_scan_rport(struct work_struct *work)
>  	struct fc_internal *i = to_fc_internal(shost->transportt);
>  	unsigned long flags;
>  
> -	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
> +	if (((rport->port_state == FC_PORTSTATE_ONLINE) ||
> +		(rport->port_state == FC_PORTSTATE_ONLINE)) &&

I think the second line should have been FC_PORTSTATE_MARGINAL.


>  	    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
>  	    !(i->f->disable_target_scan)) {
>  		scsi_scan_target(&rport->dev, rport->channel,
> @@ -3747,7 +3755,8 @@ static blk_status_t fc_bsg_rport_prep(struct
> fc_rport *rport)
>  	    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
>  		return BLK_STS_RESOURCE;
>  
> -	if (rport->port_state != FC_PORTSTATE_ONLINE)
> +	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> +		(rport->port_state != FC_PORTSTATE_MARGINAL))
>  		return BLK_STS_IOERR;
>  
>  	return BLK_STS_OK;
> diff --git a/include/scsi/scsi_transport_fc.h
> b/include/scsi/scsi_transport_fc.h
> index 1c7dd35cb7a0..829bade13b89 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -14,6 +14,7 @@
>  #include <linux/bsg-lib.h>
>  #include <asm/unaligned.h>
>  #include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_netlink.h>
>  #include <scsi/scsi_host.h>
>  
> @@ -67,6 +68,7 @@ enum fc_port_state {
>  	FC_PORTSTATE_ERROR,
>  	FC_PORTSTATE_LOOPBACK,
>  	FC_PORTSTATE_DELETED,
> +	FC_PORTSTATE_MARGINAL,
>  };
>  
>  
> @@ -707,6 +709,22 @@ struct fc_function_template {
>  	unsigned long	disable_target_scan:1;
>  };
>  
> +/**
> + * fc_rport_chkmarginal_set_noretries - Set the SCMD_NORETRIES_ABORT
> bit
> + * in cmd->state if port state is marginal
> + * @rport:	remote port to be checked
> + * @scmd:	scsi_cmd to set/clear the SCMD_NORETRIES_ABORT bit on
> Marginal state
> + **/
> +static inline void
> +fc_rport_chkmarginal_set_noretries(struct fc_rport *rport, struct
> scsi_cmnd *cmd)
> +{
> +	if ((rport->port_state == FC_PORTSTATE_MARGINAL) &&
> +		 (cmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT))
> +		set_bit(SCMD_NORETRIES_ABORT, &cmd->state);
> +	else
> +		clear_bit(SCMD_NORETRIES_ABORT, &cmd->state);
> +
> +}
>  
>  /**
>   * fc_remote_port_chkready - called to validate the remote port
> state
> @@ -723,6 +741,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
>  
>  	switch (rport->port_state) {
>  	case FC_PORTSTATE_ONLINE:
> +	case FC_PORTSTATE_MARGINAL:
>  		if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
>  			result = 0;
>  		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)


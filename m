Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73E4C63697
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 20:01:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DC5720727
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 20:01:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XaXADL3J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbgKWUBR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 15:01:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726921AbgKWUBQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Nov 2020 15:01:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606161674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+lgqr36+3e7H0r74YLfVGuX33Z2h+0ii6biuw0dVjBQ=;
        b=XaXADL3JaHffQR5+Wf3ngBizBH0gWsUrVwZCr0RManalxtqA7cQ6qX5UKPNV5i31ASIR5D
        8oyeeIWTbjX5D/psbJR3T96yuimRjpy7aKBex5c9tcEVrtFJVcXod2HmT8xhBFO1DEfs1s
        7VZjhNvmRDw+t3O2baEIZQTsoHezCHw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-qGWaoFEBMymaV7BO5_DcxA-1; Mon, 23 Nov 2020 15:01:09 -0500
X-MC-Unique: qGWaoFEBMymaV7BO5_DcxA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A7D48030C4;
        Mon, 23 Nov 2020 20:01:08 +0000 (UTC)
Received: from ovpn-112-111.phx2.redhat.com (ovpn-112-111.phx2.redhat.com [10.3.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6B9C5D9CC;
        Mon, 23 Nov 2020 20:01:07 +0000 (UTC)
Message-ID: <859756ebd8e98a3b2e8b1b3d233485aec59b1872.camel@redhat.com>
Subject: Re: [PATCH v7 3/5] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Hannes Reinecke <hare@suse.de>,
        Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com
Cc:     jsmart2021@gmail.com, mkumar@redhat.com
Date:   Mon, 23 Nov 2020 15:01:07 -0500
In-Reply-To: <4e638c14-faf4-0a63-a715-86e9baabedda@suse.de>
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
         <1605070685-20945-4-git-send-email-muneendra.kumar@broadcom.com>
         <4e638c14-faf4-0a63-a715-86e9baabedda@suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-11-16 at 09:19 +0100, Hannes Reinecke wrote:
> On 11/11/20 5:58 AM, Muneendra wrote:
> > Added a new rport state FC_PORTSTATE_MARGINAL.
> > 
> > Added a new interface fc_eh_should_retry_cmd which Checks if the
> > cmd
> > should be retried or not by checking the rport state.
> > If the rport state is marginal it returns
> > false to make sure there won't be any retries on the cmd.
> > 
> > Also made changes in fc_remote_port_delete,fc_user_scan_tgt,
> > fc_timeout_deleted_rport functions  to handle the new rport state
> > FC_PORTSTATE_MARGINAL.
> > 
> > Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> > 
> > ---
> > v7:
> > Removed the changes related to SCMD_NORETRIES_ABORT bit.
> > 
> > Added a new function fc_eh_should_retry_cmd to check whether the
> > cmd
> > should be retried based on the rport state.
> > 
> > v6:
> > No change
> > 
> > v5:
> > Made changes to clear the SCMD_NORETRIES_ABORT bit if the
> > port_state
> > has changed from marginal to online due to port_delete and port_add
> > as we need the normal cmd retry behaviour
> > 
> > Made changes in fc_scsi_scan_rport as we are checking
> > FC_PORTSTATE_ONLINE
> > instead of FC_PORTSTATE_ONLINE and FC_PORTSTATE_MARGINAL
> > 
> > v4:
> > Made changes in fc_eh_timed_out to call
> > fc_rport_chkmarginal_set_noretries
> > so that SCMD_NORETRIES_ABORT bit in cmd->state is set if rport
> > state
> > is marginal.
> > 
> > Removed the newly added scsi_cmd argument to
> > fc_remote_port_chkready
> > as the current patch handles only SCSI EH timeout/abort case.
> > 
> > v3:
> > Rearranged the patch so that all the changes with respect to new
> > rport state is part of this patch.
> > Added a new argument to scsi_cmd  to fc_remote_port_chkready
> > 
> > v2:
> > New patch
> > ---
> >   drivers/scsi/scsi_transport_fc.c | 62 +++++++++++++++++++++++--
> > -------
> >   include/scsi/scsi_transport_fc.h |  4 ++-
> >   2 files changed, 49 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_transport_fc.c
> > b/drivers/scsi/scsi_transport_fc.c
> > index a926e8f9e56e..ffd25195ae62 100644
> > --- a/drivers/scsi/scsi_transport_fc.c
> > +++ b/drivers/scsi/scsi_transport_fc.c
> > @@ -148,20 +148,23 @@ fc_enum_name_search(host_event_code,
> > fc_host_event_code,
> >   static struct {
> >   	enum fc_port_state	value;
> >   	char			*name;
> > +	int			matchlen;
> >   } fc_port_state_names[] = {
> > -	{ FC_PORTSTATE_UNKNOWN,		"Unknown" },
> > -	{ FC_PORTSTATE_NOTPRESENT,	"Not Present" },
> > -	{ FC_PORTSTATE_ONLINE,		"Online" },
> > -	{ FC_PORTSTATE_OFFLINE,		"Offline" },
> > -	{ FC_PORTSTATE_BLOCKED,		"Blocked" },
> > -	{ FC_PORTSTATE_BYPASSED,	"Bypassed" },
> > -	{ FC_PORTSTATE_DIAGNOSTICS,	"Diagnostics" },
> > -	{ FC_PORTSTATE_LINKDOWN,	"Linkdown" },
> > -	{ FC_PORTSTATE_ERROR,		"Error" },
> > -	{ FC_PORTSTATE_LOOPBACK,	"Loopback" },
> > -	{ FC_PORTSTATE_DELETED,		"Deleted" },
> > +	{ FC_PORTSTATE_UNKNOWN,		"Unknown", 7},
> > +	{ FC_PORTSTATE_NOTPRESENT,	"Not Present", 11 },
> > +	{ FC_PORTSTATE_ONLINE,		"Online", 6 },
> > +	{ FC_PORTSTATE_OFFLINE,		"Offline", 7 },
> > +	{ FC_PORTSTATE_BLOCKED,		"Blocked", 7 },
> > +	{ FC_PORTSTATE_BYPASSED,	"Bypassed", 8 },
> > +	{ FC_PORTSTATE_DIAGNOSTICS,	"Diagnostics", 11 },
> > +	{ FC_PORTSTATE_LINKDOWN,	"Linkdown", 8 },
> > +	{ FC_PORTSTATE_ERROR,		"Error", 5 },
> > +	{ FC_PORTSTATE_LOOPBACK,	"Loopback", 8 },
> > +	{ FC_PORTSTATE_DELETED,		"Deleted", 7 },
> > +	{ FC_PORTSTATE_MARGINAL,	"Marginal", 8 },
> 
> Why did you append the length of the string here?
> This doesn't have anything to do with this patch, but rather is an 
> improvement/modification of the original code, and should be
> delegated 
> to a separate patch.

It's because the attribute is now writeable, the use of the
fc_enum_name_match() macro on port_state needs the length.

The tgtid_bind_type attribute uses the same mechanism already.

-Ewan

> 
> >   };
> >   fc_enum_name_search(port_state, fc_port_state,
> > fc_port_state_names)
> > +fc_enum_name_match(port_state, fc_port_state, fc_port_state_names)
> >   #define FC_PORTSTATE_MAX_NAMELEN	20
> >   
> >   
> > @@ -2509,7 +2512,8 @@ fc_user_scan_tgt(struct Scsi_Host *shost,
> > uint channel, uint id, u64 lun)
> >   		if (rport->scsi_target_id == -1)
> >   			continue;
> >   
> > -		if (rport->port_state != FC_PORTSTATE_ONLINE)
> > +		if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> > +			(rport->port_state != FC_PORTSTATE_MARGINAL))
> >   			continue;
> >   
> >   		if ((channel == rport->channel) &&
> > @@ -3373,7 +3377,8 @@ fc_remote_port_delete(struct
> > fc_rport  *rport)
> >   
> >   	spin_lock_irqsave(shost->host_lock, flags);
> >   
> > -	if (rport->port_state != FC_PORTSTATE_ONLINE) {
> > +	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> > +		(rport->port_state != FC_PORTSTATE_MARGINAL)) {
> >   		spin_unlock_irqrestore(shost->host_lock, flags);
> >   		return;
> >   	}
> > @@ -3515,7 +3520,8 @@ fc_timeout_deleted_rport(struct work_struct
> > *work)
> >   	 * target, validate it still is. If not, tear down the
> >   	 * scsi_target on it.
> >   	 */
> > -	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
> > +	if (((rport->port_state == FC_PORTSTATE_ONLINE) ||
> > +		(rport->port_state == FC_PORTSTATE_MARGINAL)) &&
> >   	    (rport->scsi_target_id != -1) &&
> >   	    !(rport->roles & FC_PORT_ROLE_FCP_TARGET)) {
> >   		dev_printk(KERN_ERR, &rport->dev,
> > @@ -3658,7 +3664,8 @@ fc_scsi_scan_rport(struct work_struct *work)
> >   	struct fc_internal *i = to_fc_internal(shost->transportt);
> >   	unsigned long flags;
> >   
> > -	if ((rport->port_state == FC_PORTSTATE_ONLINE) &&
> > +	if (((rport->port_state == FC_PORTSTATE_ONLINE) ||
> > +		(rport->port_state == FC_PORTSTATE_MARGINAL)) &&
> >   	    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
> >   	    !(i->f->disable_target_scan)) {
> >   		scsi_scan_target(&rport->dev, rport->channel,
> > @@ -3731,6 +3738,28 @@ int fc_block_scsi_eh(struct scsi_cmnd *cmnd)
> >   }
> >   EXPORT_SYMBOL(fc_block_scsi_eh);
> >   
> > +/*
> > + * fc_eh_should_retry_cmd - Checks if the cmd should be retried or
> > not
> > + * @scmd:        The SCSI command to be checked
> > + *
> > + * This checks the rport state to decide if a cmd is
> > + * retryable.
> > + *
> > + * Returns: true if the rport state is not in marginal state.
> > + */
> > +bool fc_eh_should_retry_cmd(struct scsi_cmnd *scmd)
> > +{
> > +	struct fc_rport *rport = starget_to_rport(scsi_target(scmd-
> > >device));
> > +
> > +	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> > +		(scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT)) {
> > +		set_host_byte(scmd, DID_TRANSPORT_MARGINAL);
> > +		return false;
> > +	}
> > +	return true;
> > +}
> > +EXPORT_SYMBOL_GPL(fc_eh_should_retry_cmd);
> > +
> >   /**
> >    * fc_vport_setup - allocates and creates a FC virtual port.
> >    * @shost:	scsi host the virtual port is connected to.
> > @@ -4162,7 +4191,8 @@ static blk_status_t fc_bsg_rport_prep(struct
> > fc_rport *rport)
> >   	    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
> >   		return BLK_STS_RESOURCE;
> >   
> > -	if (rport->port_state != FC_PORTSTATE_ONLINE)
> > +	if ((rport->port_state != FC_PORTSTATE_ONLINE) &&
> > +		(rport->port_state != FC_PORTSTATE_MARGINAL))
> >   		return BLK_STS_IOERR;
> >   
> >   	return BLK_STS_OK;
> > diff --git a/include/scsi/scsi_transport_fc.h
> > b/include/scsi/scsi_transport_fc.h
> > index c759b29e46c7..14214ee121ad 100644
> > --- a/include/scsi/scsi_transport_fc.h
> > +++ b/include/scsi/scsi_transport_fc.h
> > @@ -67,6 +67,7 @@ enum fc_port_state {
> >   	FC_PORTSTATE_ERROR,
> >   	FC_PORTSTATE_LOOPBACK,
> >   	FC_PORTSTATE_DELETED,
> > +	FC_PORTSTATE_MARGINAL,
> >   };
> >   
> >   
> > @@ -742,7 +743,6 @@ struct fc_function_template {
> >   	unsigned long	disable_target_scan:1;
> >   };
> >   
> > -
> >   /**
> >    * fc_remote_port_chkready - called to validate the remote port
> > state
> >    *   prior to initiating io to the port.
> > @@ -758,6 +758,7 @@ fc_remote_port_chkready(struct fc_rport *rport)
> >   
> >   	switch (rport->port_state) {
> >   	case FC_PORTSTATE_ONLINE:
> > +	case FC_PORTSTATE_MARGINAL:
> >   		if (rport->roles & FC_PORT_ROLE_FCP_TARGET)
> >   			result = 0;
> >   		else if (rport->flags & FC_RPORT_DEVLOSS_PENDING)
> > @@ -839,6 +840,7 @@ int fc_vport_terminate(struct fc_vport *vport);
> >   int fc_block_rport(struct fc_rport *rport);
> >   int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
> >   enum blk_eh_timer_return fc_eh_timed_out(struct scsi_cmnd *scmd);
> > +bool fc_eh_should_retry_cmd(struct scsi_cmnd *scmd);
> >   
> >   static inline struct Scsi_Host *fc_bsg_to_shost(struct bsg_job
> > *job)
> >   {
> > 
> 
> Other than that:
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> 
> Cheers,
> 
> Hannes


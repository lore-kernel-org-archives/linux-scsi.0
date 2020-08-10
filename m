Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BEAC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 14:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EE772076B
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 14:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgHJONp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 10:13:45 -0400
Received: from netrider.rowland.org ([192.131.102.5]:52499 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726897AbgHJONp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 10:13:45 -0400
Received: (qmail 300172 invoked by uid 1000); 10 Aug 2020 10:13:43 -0400
Date:   Mon, 10 Aug 2020 10:13:43 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200810141343.GA299045@rowland.harvard.edu>
References: <d3fe36a9-b785-a5c4-c90d-b8fa10f4272f@puri.sm>
 <20200730151030.GB6332@rowland.harvard.edu>
 <9b80ca7c-39f8-e52d-2535-8b0baf93c7d1@puri.sm>
 <425990b3-4b0b-4dcf-24dc-4e7e60d5869d@puri.sm>
 <20200807143002.GE226516@rowland.harvard.edu>
 <b0abab28-880e-4b88-eb3c-9ffd927d1ed9@puri.sm>
 <20200808150542.GB256751@rowland.harvard.edu>
 <d3b6f7b8-5345-1ae1-4f79-5dde226e74f1@puri.sm>
 <20200809152643.GA277165@rowland.harvard.edu>
 <60150284-be13-d373-5448-651b72a7c4c9@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60150284-be13-d373-5448-651b72a7c4c9@puri.sm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 10, 2020 at 02:03:17PM +0200, Martin Kepplinger wrote:
> On 09.08.20 17:26, Alan Stern wrote:
> > This is a somewhat fragile approach.  You don't know for certain that 
> > scsi_noretry_cmd will be called.  Also, scsi_noretry_cmd can be called 
> > from other places.
> > 
> > It would be better to clear the expecting_media_change flag just before 
> > returning from scsi_decide_disposition.  That way its use is localized 
> > to one routine, not spread out between two.
> > 
> > Alan Stern
> > 
> 
> Hi Alan,
> 
> maybe you're right. I initially just thought that I'd allow for specific
> error codes in scsi_noretry_cmd() to return non-NULL (BUS_BUSY, PARITY,
> ERROR) despite having the flag set.
> 
> The below version works equally fine for me but I'm not sure if it's
> actually more safe.
> 
> James, when exposing a new writable sysfs option like
> "suspend_no_media_change"(?) that drivers can check before setting the
> new "expecting_media_change" flag (during resume), would this addition
> make sense to you?
> 
> thanks,
> 
>                       martin
> 
> 
> 
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -565,6 +565,18 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
>  				return NEEDS_RETRY;
>  			}
>  		}
> +		if (scmd->device->expecting_media_change) {
> +			if (sshdr.asc == 0x28 && sshdr.ascq == 0x00) {
> +				/*
> +				 * clear the expecting_media_change in
> +				 * scsi_decide_disposition() because we
> +				 * need to catch possible "fail fast" overrides
> +				 * that block readahead can cause.
> +				 */
> +				return NEEDS_RETRY;
> +			}
> +		}
> +
>  		/*
>  		 * we might also expect a cc/ua if another LUN on the target
>  		 * reported a UA with an ASC/ASCQ of 3F 0E -
> @@ -1944,9 +1956,19 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
>  	 * the request was not marked fast fail.  Note that above,
>  	 * even if the request is marked fast fail, we still requeue
>  	 * for queue congestion conditions (QUEUE_FULL or BUSY) */
> -	if ((++scmd->retries) <= scmd->allowed
> -	    && !scsi_noretry_cmd(scmd)) {
> -		return NEEDS_RETRY;
> +	if ((++scmd->retries) <= scmd->allowed) {
> +		/*
> +		 * but scsi_noretry_cmd() cannot override the
> +		 * expecting_media_change flag.
> +		 */
> +		if (!scsi_noretry_cmd(scmd) ||
> +		    scmd->device->expecting_media_change) {
> +			scmd->device->expecting_media_change = 0;
> +			return NEEDS_RETRY;
> +		} else {
> +			/* marked fast fail and not expected. */
> +			return SUCCESS;
> +		}
>  	} else {

This may not matter...  but it's worth pointing out that 
expecting_media_change doesn't get cleared if ++scmd->retries > 
scmd->allowed.

It also doesn't get cleared in cases where the device _doesn't_ 
report a Unit Attention.

Alan Stern

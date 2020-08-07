Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BE7C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 14:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7530E2224D
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 14:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgHGOaF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 10:30:05 -0400
Received: from netrider.rowland.org ([192.131.102.5]:40833 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1725815AbgHGOaE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 10:30:04 -0400
Received: (qmail 228459 invoked by uid 1000); 7 Aug 2020 10:30:02 -0400
Date:   Fri, 7 Aug 2020 10:30:02 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200807143002.GE226516@rowland.harvard.edu>
References: <1596034432.4356.19.camel@HansenPartnership.com>
 <d9bb92e9-23fa-306f-c7f2-71a81ab28811@puri.sm>
 <1596037482.4356.37.camel@HansenPartnership.com>
 <A1653792-B7E5-46A9-835B-7FA85FCD0378@puri.sm>
 <20200729182515.GB1580638@rowland.harvard.edu>
 <1596047349.4356.84.camel@HansenPartnership.com>
 <d3fe36a9-b785-a5c4-c90d-b8fa10f4272f@puri.sm>
 <20200730151030.GB6332@rowland.harvard.edu>
 <9b80ca7c-39f8-e52d-2535-8b0baf93c7d1@puri.sm>
 <425990b3-4b0b-4dcf-24dc-4e7e60d5869d@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <425990b3-4b0b-4dcf-24dc-4e7e60d5869d@puri.sm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 07, 2020 at 11:51:21AM +0200, Martin Kepplinger wrote:
> it's really strange: below is the change I'm trying. Of course that's
> only for testing the functionality, nothing how a patch could look like.
> 
> While I remember it had worked, now (weirdly since I tried that mounting
> via fstab) it doesn't anymore!
> 
> What I understand (not much): I handle the error with "retry" via the
> new flag, but scsi_decide_disposition() returns SUCCESS because of "no
> more retries"; but it's the first and only time it's called.

Are you saying that scmd->allowed is set to 0?  Or is scsi_notry_cmd() 
returning a nonzero value?  Whichever is true, why does it happen that 
way?

What is the failing command?  Is it a READ(10)?

> How can this be? What am I missing?

It's kind of hard to tell without seeing the error messages or system 
log or any debugging information.

Alan Stern

> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -565,6 +565,13 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
>  				return NEEDS_RETRY;
>  			}
>  		}
> +		if (scmd->device->expecting_media_change) {
> +			if (sshdr.asc == 0x28 && sshdr.ascq == 0x00) {
> +				scmd->device->expecting_media_change = 0;
> +				return NEEDS_RETRY;
> +			}
> +		}
> +
>  		/*
>  		 * we might also expect a cc/ua if another LUN on the target
>  		 * reported a UA with an ASC/ASCQ of 3F 0E -
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d90fefffe31b..bb583e403b81 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3642,6 +3642,8 @@ static int sd_resume(struct device *dev)
>  	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
>  		return 0;
> 
> +	sdkp->device->expecting_media_change = 1;
> +
>  	if (!sdkp->device->manage_start_stop)
>  		return 0;
> 
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index bc5909033d13..f5fc1af68e00 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -169,6 +169,7 @@ struct scsi_device {
>  				 * this device */
>  	unsigned expecting_cc_ua:1; /* Expecting a CHECK_CONDITION/UNIT_ATTN
>  				     * because we did a bus reset. */
> +	unsigned expecting_media_change:1;
>  	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
>  	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
>  	unsigned set_dbd_for_ms:1; /* Set "DBD" field in mode sense */

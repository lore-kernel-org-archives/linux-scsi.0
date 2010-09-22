From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi_dh_alua: add missing transitioning state support
Date: Wed, 22 Sep 2010 08:29:01 -0400
Message-ID: <20100922122901.GA10218@redhat.com>
References: <1282071956-391-1-git-send-email-snitzer@redhat.com>
 <1282073039.30453.37.camel@haakon2.linux-iscsi.org>
 <4C7B7B9E.3020002@suse.de>
 <20100831151129.GA18855@redhat.com>
 <20100920153539.GA28284@redhat.com>
 <4C98180F.1020707@cs.wisc.edu>
 <20100921193320.GA5110@redhat.com>
 <4C992026.5080402@cs.wisc.edu>
 <4C99D6B3.3090003@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab0IVM3I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2010 08:29:08 -0400
Content-Disposition: inline
In-Reply-To: <4C99D6B3.3090003@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org



On Wed, Sep 22 2010 at  6:13am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> Mike Christie wrote:
> > On 09/21/2010 02:33 PM, Mike Snitzer wrote:
> >> 2) the patch also modified alua_rtpg() so implicit ALUA would retry
> >>     (just like explicit ALUA currently does) if TPGS_STATE_TRANSITIONING
> >>     - so why should we avoid retry for implicit but do it for explicit?
> > 
> > Leaving that for Hannes. I cannot think of a reason. Probably just did
> > not do it.
> 
> Finally I got around to answering this.
> 
> I've attached a patch which I made the other day which seems to work
> reasonably well.
> Looks better from my side, so if you agree I'll be sending it
> upstream properly.

Looks good for covering this "2)" change above.

But "1)" change you had concern with (in my previous patch) was that
alua_prep_fn would return BLKPREP_DEFER if TPGS_STATE_TRANSITIONING.
This was bad in that FS requests (like the directio path checker) would
always call ->prep_fn and that if TPGS_STATE_TRANSITIONING the RTPG
state would never be reevaluated.. leaving us stuck in BLKPREP_DEFER.

Seems I'm missing a new flow that proves this is no longer a concern.

Please advise, thanks.
Mike

> From d3f02c90db3e3177309b78726d082e17dd772ee2 Mon Sep 17 00:00:00 2001
> From: Hannes Reinecke <hare@suse.de>
> Date: Wed, 22 Sep 2010 12:09:07 +0200
> Subject: [PATCH] scsi_dh_alua: Handle all states correctly
> 
> For ALUA we should be handling all states, independent of whether
> is explicit or implicit. For 'Transitioning' we should be retry
> for a certain amount of time; after that an error should be
> returned.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 1a970a7..c6f57e3 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
...
> @@ -698,8 +704,11 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
>  	struct alua_dh_data *h = get_alua_data(sdev);
>  	int ret = BLKPREP_OK;
>  
> -	if (h->state != TPGS_STATE_OPTIMIZED &&
> -	    h->state != TPGS_STATE_NONOPTIMIZED) {
> +	if (h->state == TPGS_STATE_TRANSITIONING)
> +		ret = BLKPREP_DEFER;
> +	else if (h->state != TPGS_STATE_OPTIMIZED &&
> +		 h->state != TPGS_STATE_NONOPTIMIZED &&
> +		 h->state != TPGS_STATE_LBA_DEPENDENT) {
>  		ret = BLKPREP_KILL;
>  		req->cmd_flags |= REQ_QUIET;
>  	}


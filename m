From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 1/1] fc class: fail fast bsg requests
Date: Thu, 5 Nov 2009 13:39:54 -0500
Message-ID: <4AF31BFA.1030305@emulex.com>
References: <1257441489-9055-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:34011 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705AbZKESkA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2009 13:40:00 -0500
In-Reply-To: <1257441489-9055-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Does this really do what you want ?  Don't you want something that dequeues 
the request, and errors it out ?

The break from the look doesn't remove the request from the request queue. It 
just stops servicing it.  Thus, we have the "goose" function that kicks in if 
the rport comes back, and if it doesn't, the queue gets removed (hmmm... now 
that I think about it - I'm not sure what happens if the request queue has 
items on it and the device gets torn down. Are we doing the right thing by 
references, etc?).

So - to have what you want, I would think we need to add:
- something that gooses the queue when fastfail io timeout expires
- allows the requests to enter between fastfail io timeout and nodev
   timeout and fails them.

It also says we aren't discriminating based on request type - e.g. any bsg 
request fails back immediately after fastfail io timer. Nothing ever waits 
until nodev tmo unless fastfail isn't configured.

Right ?

-- james s


michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> If the port state is blocked and the fast io fail tmo has
> fired then this patch will fail bsg requests immediately.
> This is needed if userspace is sending IOs to test the transport
> like with fcping, so it will not have to wait for the dev loss tmo.
> With this patch he bsg req fast io fail code behaves like the normal
> and sg io/passthrough fast io fail.
> 
> Patch was made over scsi-rc-fixes. It is only compiled tested.
> I found this while looking over the iscsi bsg patch.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> Cc: james.smart@emulex.com <james.smart@emulex.com>
> ---
>  drivers/scsi/scsi_transport_fc.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index c6f70da..1004684 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -3769,8 +3769,9 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
>  		return;
>  
>  	while (!blk_queue_plugged(q)) {
> -		if (rport && (rport->port_state == FC_PORTSTATE_BLOCKED))
> -				break;
> +		if (rport && (rport->port_state == FC_PORTSTATE_BLOCKED) &&
> +		    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
> +			break;
>  
>  		req = blk_fetch_request(q);
>  		if (!req)

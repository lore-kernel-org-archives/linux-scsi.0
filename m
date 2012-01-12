From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 1/1] [SCSI] Clear Devloss Callback Done flag in fc_remote_port_rolechg
Date: Thu, 12 Jan 2012 16:44:31 -0500
Message-ID: <0236d7bd-4521-4f00-9ab1-f5e46dc81eb9@exht1.ad.emulex.com>
References: <1320333041.4568.3.camel@ogier>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:45874 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755624Ab2ALVo4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2012 16:44:56 -0500
In-Reply-To: <1320333041.4568.3.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Smart, James" <James.Smart@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Iannicelli, Alex" <Alex.Iannicelli@Emulex.Com>

James,

Ping...  anything holding up inclusion of this patch ?

-- james s


On 11/3/2011 11:10 AM, James Smart wrote:
> This patch fixes a bug where devloss is not called on fc_host teardown.
> The issue is seen if the LLDD uses rport_rolechg to add the target role
> to an rport.
>
> When an rport goes away, the LLDD will call fc_remote_port_delete, which
> will start the devloss timer.  If the timer expires, the transport will
> call the devloss callback and set the FC_RPORT_DEVLOSS_CALLBK_DONE flag.
> However, the rport structure is not deleted, it is retained to store the
> SCSI id mappings for the rport in case it comes back. In the scenario
> where it does come back, and the driver calls fc_remote_port_add, but does
> not indicate the "target" role for the rport - the create will clear the
> structure, but forgets to clear FC_RPORT_DEVLOSS_CALLBK_DONE flag (which
> is cleared if it's added with the target role). The secondary call, of
> fc_remote_port_rolechg to add the target role also does not clear the flag.
> Thus, the next time the rport goes away, the resulting devloss timer
> expiration will not call the driver callback as the flag is still set.
>
> This patch adds the FC_RPORT_DEVLOSS_CALLBK_DONE flags to the list of
> those that are cleared upon reuse of the rport structure.
>
>   Signed-off-by: Alex Iannicelli<alex.iannicelli@emulex.com>
>   Signed-off-by: James Smart<james.smart@emulex.com>
>
>   ---
>
>   scsi_transport_fc.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
>
> diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> --- a/drivers/scsi/scsi_transport_fc.c	2011-11-03 10:27:14.000000000 -0400
> +++ b/drivers/scsi/scsi_transport_fc.c	2011-11-03 10:28:59.000000000 -0400
> @@ -3048,7 +3048,8 @@ fc_remote_port_rolechg(struct fc_rport
>
>   		spin_lock_irqsave(shost->host_lock, flags);
>   		rport->flags&= ~(FC_RPORT_FAST_FAIL_TIMEDOUT |
> -				  FC_RPORT_DEVLOSS_PENDING);
> +				  FC_RPORT_DEVLOSS_PENDING |
> +				  FC_RPORT_DEVLOSS_CALLBK_DONE);
>   		spin_unlock_irqrestore(shost->host_lock, flags);
>
>   		/* ensure any stgt delete functions are done */
>
>

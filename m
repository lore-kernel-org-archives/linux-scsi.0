From: James Smart <James.Smart@Emulex.Com>
Subject: Re: FC transport: Calling fc_remote_port_add for online port
Date: Fri, 26 Jun 2009 12:41:00 -0400
Message-ID: <4A44FA1C.9080207@emulex.com>
References: <20090626152303.GA21058@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63079 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZFZQlH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2009 12:41:07 -0400
In-Reply-To: <20090626152303.GA21058@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The LLD should never be calling fc_remote_port_add() twice without an 
intervening fc_remote_port_delete(). Which is another way of saying - 
yes, it's what you say relative to the rport state values.

The idea is - the LLD is tracking an external port structure, using 
<portid, <wwnn,wwpn>> to track identity, and is keeping a "present" and 
"not-present" case. If a new port is deemed "present", it calls 
fc_remote_port_add() and when connectivity  is lost (aka goes to "not 
present") to that port, it calls fc_remote_port_delete(). It should be 
very straight forward.
 
The rport structure itself, to aid the midlayer,  to hide temporary 
connectivity losses due to link bounces, controller resets, etc - may 
stay around after the delete call, and midlayer calls may enter the 
driver for it, but the transport via helper functions, should pick them 
off and reject them. Eventually, when the rport exceeds its max 
connectivity loss hide value (devloss_tmo), the devloss_tmo_callbk() is 
made to tell the driver the rport is truly gone (if it cares), and all 
the midlayer structures and scsi objects below the rport are 
terminated.   After this point, for target id bindings, we keep the 
rport structure around - but only as a generic container to hold the 
binding values. For all intents and purposes, there's no relationship to 
the old rport or the old rport pointer value any more.  And if a port 
eventually comes back that matches the bindings, we flip the binding 
container back into a real rport structure as if we had just allocated it.

-- james s


Christof Schmitt wrote:
> When a LLD calls fc_remote_port_add for a port that is already in the
> state FC_PORTSTATE_ONLINE, the FC transport class will create a new
> fc_rport struct and sysfs will show two entries for the same port.
>
> How should this be handled? Does the LLD have to track the state and
> only call fc_remote_port add for new ports and ports in the state
> FC_PORTSTATE_BLOCKED or FC_PORTTYPE_NOTPRESENT?
>
> Or should the FC transport class allow that a LLD can call
> fc_remote_port_add at any time? The patch does this change in the FC
> transport class.
>
> Thoughts, comments?
>
> --
> Christof Schmitt
>
> ---
>  drivers/scsi/scsi_transport_fc.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> --- a/drivers/scsi/scsi_transport_fc.c	2009-06-23 14:41:20.000000000 +0200
> +++ b/drivers/scsi/scsi_transport_fc.c	2009-06-23 15:22:21.000000000 +0200
> @@ -2580,9 +2580,7 @@ fc_remote_port_add(struct Scsi_Host *sho
>  	spin_lock_irqsave(shost->host_lock, flags);
>  
>  	list_for_each_entry(rport, &fc_host->rports, peers) {
> -
> -		if ((rport->port_state == FC_PORTSTATE_BLOCKED) &&
> -			(rport->channel == channel)) {
> +		if (rport->channel == channel) {
>  
>  			switch (fc_host->tgtid_bind_type) {
>  			case FC_TGTID_BIND_BY_WWPN:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   

From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] FC_Transport: Check portstates before invoking target
 scan
Date: Thu, 14 Jun 2007 07:57:05 -0400
Message-ID: <46712D11.1010506@emulex.com>
References: <4670EDCA.5070302@suse.de>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:36362 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbXFNL5X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 07:57:23 -0400
In-Reply-To: <4670EDCA.5070302@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Sounds reasonable...  Only change I'd make is rather than comparing all the
different states, simply compare  (rport->port_state != FC_PORTSTATE_ONLINE)

-- james s

Hannes Reinecke wrote:
> Hi James (& James, too :-),
> 
> scsi_transport_fc.c:fc_user_scan() should check the portstates prior to
> calling scsi_scan_target(). Otherwise we might get a nice oops as the
> rport might already been disconnected from the host by the time we're
> calling scsi_scan_target(). Thus the traversal from the rport to the
> scsi_host in scsi_scan_target() will fail, resulting in a nice Oops.
> Plus it's quite pointless to scan a target if the portstates already
> told us that we can't communicate with it.
> 
> Please apply.
> 
> Cheers,
> 
> Hannes
> 
> 
> ------------------------------------------------------------------------
> 
> scsi_transport_fc: Check portstates before invoking target scan
> 
> When a target scan is initiated from sysfs, we should check the
> portstate prior to invoke scsi_scan_target().
> Otherwise scsi_scan_target() might oops as the rport might already
> been removed from the scsi host and the traversal from the rport to
> the scsi_host in scsi_scan_target() will fail.
> Also the portstate already told us that communication with the target
> has failed, so it's quite pointless to try.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 4953f0d..bd73615 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -1943,6 +1943,12 @@ static int fc_user_scan(struct Scsi_Host
>  		if (rport->scsi_target_id == -1)
>  			continue;
>  
> +		if ((rport->port_state == FC_PORTSTATE_NOTPRESENT) ||
> +		    (rport->port_state == FC_PORTSTATE_UNKNOWN) ||
> +		    (rport->port_state == FC_PORTSTATE_DELETED) ||
> +		    (rport->port_state == FC_PORTSTATE_BLOCKED))
> +			continue;
> +
>  		if ((channel == SCAN_WILD_CARD || channel == rport->channel) &&
>  		    (id == SCAN_WILD_CARD || id == rport->scsi_target_id)) {
>  			scsi_scan_target(&rport->dev, rport->channel,

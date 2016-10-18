From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 07/20] scsi_transport_fc: rename 'fc_rport_create' to
 'fc_remote_port_create'
Date: Tue, 18 Oct 2016 09:00:29 -0700
Message-ID: <488ec5c6-3c64-d9e4-d8d1-42676b666b32@broadcom.com>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
 <1476777714-3543-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34052 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964885AbcJRQAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2016 12:00:34 -0400
Received: by mail-pf0-f180.google.com with SMTP id r16so73031602pfg.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2016 09:00:33 -0700 (PDT)
In-Reply-To: <1476777714-3543-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


On 10/18/2016 1:01 AM, Hannes Reinecke wrote:
> Required for the next patch.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   drivers/scsi/scsi_transport_fc.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 0f3a386..4534085 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -2592,7 +2592,7 @@ static void fc_terminate_rport_io(struct fc_rport *rport)
>   
>   
>   /**
> - * fc_rport_create - allocates and creates a remote FC port.
> + * fc_remote_port_create - allocates and creates a remote FC port.
>    * @shost:	scsi host the remote port is connected to.
>    * @channel:	Channel on shost port connected to.
>    * @ids:	The world wide names, fc address, and FC4 port
> @@ -2605,8 +2605,8 @@ static void fc_terminate_rport_io(struct fc_rport *rport)
>    *	This routine assumes no locks are held on entry.
>    */
>   static struct fc_rport *
> -fc_rport_create(struct Scsi_Host *shost, int channel,
> -	struct fc_rport_identifiers  *ids)
> +fc_remote_port_create(struct Scsi_Host *shost, int channel,
> +		      struct fc_rport_identifiers  *ids)
>   {
>   	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
>   	struct fc_internal *fci = to_fc_internal(shost->transportt);
> @@ -2914,7 +2914,7 @@ struct fc_rport *
>   	spin_unlock_irqrestore(shost->host_lock, flags);
>   
>   	/* No consistent binding found - create new remote port entry */
> -	rport = fc_rport_create(shost, channel, ids);
> +	rport = fc_remote_port_create(shost, channel, ids);
>   
>   	return rport;
>   }

Hannes,

Why are you making an interface change that will now affect drivers that 
are not users of libfc ?   Can't this be localized within libfc ?

-- james

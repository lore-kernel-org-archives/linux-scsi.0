From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/4] scsi: never drop to untagged mode during queue ramp
 down
Date: Wed, 03 Dec 2014 14:32:49 +0100
Message-ID: <547F1101.5010604@suse.de>
References: <1416839781-26988-1-git-send-email-hch@lst.de> <1416839781-26988-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaLCNcv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 08:32:51 -0500
In-Reply-To: <1416839781-26988-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>

On 11/24/2014 03:36 PM, Christoph Hellwig wrote:
> Dropping to untagged mode when ramping down a queue due to QUEUE FULL
> events has two problems:
>=20
>  - nothing in the midlayer or drivers ever moves back to tagged mode
>    during queue ramp up.
>  - cmd_per_lun isn't the untagged queue depth for many modern drivers
>    that can handle multiple untagged commands, and this is the only
>    place in the midlayer assuming that.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi.c | 6 ------
>  1 file changed, 6 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 72282ae..6b0d524 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -820,12 +820,6 @@ int scsi_track_queue_full(struct scsi_device *sd=
ev, int depth)
> =20
>  	if (sdev->last_queue_full_count <=3D 10)
>  		return 0;
> -	if (sdev->last_queue_full_depth < 8) {
> -		/* Drop back to untagged */
> -		scsi_set_tag_type(sdev, 0);
> -		scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun);
> -		return -1;
> -	}
> =20
>  	return scsi_change_queue_depth(sdev, depth);
>  }
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

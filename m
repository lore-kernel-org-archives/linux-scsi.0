From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] scsi: remove scsi_set_tag_type
Date: Wed, 03 Dec 2014 14:34:23 +0100
Message-ID: <547F115F.4080601@suse.de>
References: <1416839781-26988-1-git-send-email-hch@lst.de> <1416839781-26988-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaLCNeY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 08:34:24 -0500
In-Reply-To: <1416839781-26988-5-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>

On 11/24/2014 03:36 PM, Christoph Hellwig wrote:
> There is no benefit over just setting sdev->simple_tags directly.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/53c700.c   |  2 +-
>  drivers/scsi/tmscsim.c  |  2 +-
>  include/scsi/scsi_tcq.h | 15 ---------------
>  3 files changed, 2 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
> index 2c87a7a..82abfce 100644
> --- a/drivers/scsi/53c700.c
> +++ b/drivers/scsi/53c700.c
> @@ -902,8 +902,8 @@ process_message(struct Scsi_Host *host,	struct NC=
R_700_Host_Parameters *hostdata
>  			hostdata->tag_negotiated &=3D ~(1<<scmd_id(SCp));
> =20
>  			SCp->device->tagged_supported =3D 0;
> +			SCp->device->simple_tags =3D 0;
>  			scsi_change_queue_depth(SCp->device, host->cmd_per_lun);
> -			scsi_set_tag_type(SCp->device, 0);
>  		} else {
>  			shost_printk(KERN_WARNING, host,
>  				"(%d:%d) Unexpected REJECT Message %s\n",
> diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> index 6c3c2ce..14ccc9a 100644
> --- a/drivers/scsi/tmscsim.c
> +++ b/drivers/scsi/tmscsim.c
> @@ -2190,7 +2190,7 @@ static int dc390_slave_configure(struct scsi_de=
vice *sdev)
>  	 * XXX: Note that while this driver used to called scsi_activate_tc=
q,
>  	 * it never actually set a tag type, so emulate the old behavior.
>  	 */
> -	scsi_set_tag_type(sdev, 0);
> +	sdev->simple_tags =3D 0;
> =20
>  	if (sdev->tagged_supported && (dcb->DevMode & TAG_QUEUEING_)) {
>  		dcb->SyncMode |=3D EN_TAG_QUEUEING;
> diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
> index 681e010..e624aca 100644
> --- a/include/scsi/scsi_tcq.h
> +++ b/include/scsi/scsi_tcq.h
> @@ -15,21 +15,6 @@
> =20
> =20
>  #ifdef CONFIG_BLOCK
> -static inline void scsi_set_tag_type(struct scsi_device *sdev, int t=
ag)
> -{
> -	switch (tag) {
> -	case MSG_ORDERED_TAG:
> -	case MSG_SIMPLE_TAG:
> -		sdev->simple_tags =3D 1;
> -		break;
> -	case 0:
> -		/* fall through */
> -	default:
> -		sdev->simple_tags =3D 0;
> -		break;
> -	}
> -}
> -
>  static inline struct scsi_cmnd *scsi_mq_find_tag(struct Scsi_Host *s=
host,
>  						 int unique_tag)
>  {
>=20
Probably needs to be adjusted now that's tmscsim is gone, but
nevertheless:

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

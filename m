From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] sd: Optimal I/O size is in bytes, not sectors
Date: Wed, 20 Jan 2016 17:11:02 +0100
Message-ID: <20160120161102.GR2742@c203.arch.suse.de>
References: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933838AbcATQLF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 11:11:05 -0500
Content-Disposition: inline
In-Reply-To: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, borntraeger@de.ibm.com

On Wed, Jan 20, 2016 at 11:01:23AM -0500, Martin K. Petersen wrote:
> Commit ca369d51b3e1 ("block/sd: Fix device-imposed transfer length
> limits") accidentally switched optimal I/O size reporting from bytes =
to
> block layer sectors.
>=20
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  drivers/scsi/sd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 4e08d1cd704d..ec163d08f6c3 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2893,7 +2893,7 @@ static int sd_revalidate_disk(struct gendisk *d=
isk)
>  	    sdkp->opt_xfer_blocks <=3D SD_DEF_XFER_BLOCKS &&
>  	    sdkp->opt_xfer_blocks * sdp->sector_size >=3D PAGE_CACHE_SIZE)
>  		rw_max =3D q->limits.io_opt =3D
> -			logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
> +			sdkp->opt_xfer_blocks * sdp->sector_size;
>  	else
>  		rw_max =3D BLK_DEF_MAX_SECTORS;
> =20
> --=20
> 2.5.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

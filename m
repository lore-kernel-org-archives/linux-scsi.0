From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Use the correct size to set block max sectors
Date: Thu, 26 May 2016 18:35:55 -0700
Message-ID: <1464312955.16344.55.camel@perches.com>
References: <1464307708-4315-1-git-send-email-longli@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464307708-4315-1-git-send-email-longli@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@microsoft.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: KY Srinivasan <kys@microsoft.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

dOn Thu, 2016-05-26 at 17:08 -0700, Long Li wrote:
> The block sector size should be in unit of 512 bytes, not in bytes.

Thanks.  The patch subject should use something like:

[PATCH] sd: Use the correct size to set block max sectors

to show what subsystem is being modified.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
[]
> @@ -2862,9 +2862,11 @@ static int sd_revalidate_disk(struct gendisk *=
disk)
> =A0	if (sdkp->opt_xfer_blocks &&
> =A0	=A0=A0=A0=A0sdkp->opt_xfer_blocks <=3D dev_max &&
> =A0	=A0=A0=A0=A0sdkp->opt_xfer_blocks <=3D SD_DEF_XFER_BLOCKS &&
> -	=A0=A0=A0=A0sdkp->opt_xfer_blocks * sdp->sector_size >=3D PAGE_SIZE=
)
> -		rw_max =3D q->limits.io_opt =3D
> +	=A0=A0=A0=A0sdkp->opt_xfer_blocks * sdp->sector_size >=3D PAGE_SIZE=
) {
> +		q->limits.io_opt =3D
> =A0			sdkp->opt_xfer_blocks * sdp->sector_size;
> +		rw_max =3D (q->limits.io_opt >> 9);
> +	}
> =A0	else
> =A0		rw_max =3D BLK_DEF_MAX_SECTORS;

And style trivia: =A0it'd be more kernel style consistent as:

	if (...
	  =A0=A0sdkp->opt_xfer_blocks * sdp->sector_size >=3D PAGE_SIZE) {
		q->limits.io_opt =3D sdkp->opt_xfer_blocks * sdp->sector_size;
		rw_max =3D q->limits.io_opt >> 9;
	} else {
		rw_max =3D BLK_DEF_MAX_SECTORS;
	}

ie: no parentheses necessary around the shifted value and
=A0   braces around both arms.

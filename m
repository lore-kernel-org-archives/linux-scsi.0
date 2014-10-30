From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 14/36] ncr5380: Remove pointless compiler command line
 override macros
Date: Thu, 30 Oct 2014 08:34:49 +0100
Message-ID: <5451EA19.9040502@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052610.515575414@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141027052610.515575414@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> Compile-time override of scsi host defaults is pointless for drivers =
that
> provide module parameters and __setup options for that. Too many macr=
os make
> the code hard to read so remove them.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/atari_scsi.c |    2 +-
>  drivers/scsi/atari_scsi.h |    3 ---
>  drivers/scsi/mac_scsi.c   |   19 +++++++++----------
>  drivers/scsi/mac_scsi.h   |   16 ----------------
>  drivers/scsi/sun3_scsi.c  |   20 ++++++++++----------
>  drivers/scsi/sun3_scsi.h  |   18 ------------------
>  6 files changed, 20 insertions(+), 58 deletions(-)
>=20
> Index: linux/drivers/scsi/mac_scsi.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/mac_scsi.c	2014-10-27 16:25:26.000000000 =
+1100
> +++ linux/drivers/scsi/mac_scsi.c	2014-10-27 16:25:32.000000000 +1100
> @@ -177,13 +177,12 @@ int __init macscsi_detect(struct scsi_ho
>      if (macintosh_config->scsi_type !=3D MAC_SCSI_OLD)
>  	return( 0 );
> =20
> -    /* setup variables */
> -    tpnt->can_queue =3D
> -	(setup_can_queue > 0) ? setup_can_queue : CAN_QUEUE;
> -    tpnt->cmd_per_lun =3D
> -	(setup_cmd_per_lun > 0) ? setup_cmd_per_lun : CMD_PER_LUN;
> -    tpnt->sg_tablesize =3D=20
> -	(setup_sg_tablesize >=3D 0) ? setup_sg_tablesize : SG_TABLESIZE;
> +	if (setup_can_queue > 0)
> +		tpnt->can_queue =3D setup_can_queue;
> +	if (setup_cmd_per_lun > 0)
> +		tpnt->cmd_per_lun =3D setup_cmd_per_lun;
> +	if (setup_sg_tablesize >=3D 0)
> +		tpnt->sg_tablesize =3D setup_sg_tablesize;
> =20
>      if (setup_hostid >=3D 0)
>  	tpnt->this_id =3D setup_hostid;

Sigh. Blasted indentation.
Can I convince you to cleanup mac_scsi.c to conform to current
coding style after the cleanup is done?

The remainder is okay.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

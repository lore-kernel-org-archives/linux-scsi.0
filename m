From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/22] ncr5380: Add MAX_LUN limit
Date: Mon, 14 Mar 2016 08:43:15 +0100
Message-ID: <56E66B93.1030506@suse.de>
References: <20160314042700.596192247@telegraphics.com.au>
 <20160314042704.285983735@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160314042704.285983735@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

On 03/14/2016 05:27 AM, Finn Thain wrote:
> The driver has a limit of eight LUs because of the byte-sized bitfiel=
d
> that is used for busy flags. Reject commands with LUN > 7.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c |    6 ++++++
>  drivers/scsi/NCR5380.h |    2 ++
>  2 files changed, 8 insertions(+)
>=20
> Index: linux/drivers/scsi/NCR5380.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/NCR5380.c	2016-03-14 15:26:45.000000000 +=
1100
> +++ linux/drivers/scsi/NCR5380.c	2016-03-14 15:26:48.000000000 +1100
> @@ -661,6 +661,12 @@ static int NCR5380_queue_command(struct
>  	}
>  #endif /* (NDEBUG & NDEBUG_NO_WRITE) */
> =20
> +	if (cmd->device->lun > MAX_LUN) {
> +		cmd->result =3D DID_NO_CONNECT << 16;
> +		cmd->scsi_done(cmd);
> +		return 0;
> +	}
> +
>  	cmd->result =3D 0;
> =20
>  	if (!NCR5380_acquire_dma_irq(instance))
> Index: linux/drivers/scsi/NCR5380.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/NCR5380.h	2016-03-14 15:26:45.000000000 +=
1100
> +++ linux/drivers/scsi/NCR5380.h	2016-03-14 15:26:48.000000000 +1100
> @@ -244,6 +244,8 @@ struct NCR5380_hostdata {
> =20
>  #ifdef __KERNEL__
> =20
> +#define MAX_LUN	7
> +
>  struct NCR5380_cmd {
>  	struct list_head list;
>  };
>=20
>=20
Why not simply use shost->max_lun ?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

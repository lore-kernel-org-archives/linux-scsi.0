From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 23/23] ncr5380: Call complete_cmd() for disconnected
 commands on bus reset
Date: Wed, 23 Mar 2016 08:29:32 +0100
Message-ID: <56F245DC.90801@suse.de>
References: <20160321023149.604138431@telegraphics.com.au>
 <20160321023155.603958101@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35227 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbcCWH3e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2016 03:29:34 -0400
In-Reply-To: <20160321023155.603958101@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>

On 03/21/2016 03:32 AM, Finn Thain wrote:
> I'm told that some targets are liable to disconnect a REQUEST SENSE
> command. Theoretically this would cause a command undergoing autosens=
e to
> be moved onto the disconnected list. The bus reset handler must call
> complete_cmd() for these commands, otherwise the hostdata->sensing po=
inter
> will not get cleared. That would cause autosense processing to stall =
and
> a timeout or an incorrect scsi_eh_restore_cmnd() would eventually fol=
low.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>  drivers/scsi/NCR5380.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Index: linux/drivers/scsi/NCR5380.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/NCR5380.c	2016-03-21 13:31:40.000000000 +=
1100
> +++ linux/drivers/scsi/NCR5380.c	2016-03-21 13:31:47.000000000 +1100
> @@ -2437,7 +2437,7 @@ static int NCR5380_bus_reset(struct scsi
>  		struct scsi_cmnd *cmd =3D NCR5380_to_scmd(ncmd);
> =20
>  		set_host_byte(cmd, DID_RESET);
> -		cmd->scsi_done(cmd);
> +		complete_cmd(instance, cmd);
>  	}
>  	INIT_LIST_HEAD(&hostdata->disconnected);
> =20
>=20
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

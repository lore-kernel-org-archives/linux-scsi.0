From: Hannes Reinecke <hare@suse.de>
Subject: Re: [ V3 PATCH 2/2] scsi: TUR path is down after adapter gets reset
 with multipath
Date: Fri, 07 Nov 2014 09:53:07 +0100
Message-ID: <545C8873.4010200@suse.de>
References: <20141106211121.526781033@linux.vnet.ibm.com> <20141106211336.369139152@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbaKGIxI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2014 03:53:08 -0500
In-Reply-To: <20141106211336.369139152@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

On 11/06/2014 10:11 PM, wenxiong@linux.vnet.ibm.com wrote:
> This patch fixes an issue with multipath ipr SAS devices which requir=
e a
> start unit command to be issued following an adapter reset. Without t=
his
> patch, paths get marked failed following an adapter reset and since t=
he
> error handler never gets invoked to issue the start unit, the paths a=
re
> never recovered. Returning FAILED for this case ensures the error
> handler wakes up to issue the start unit.
>=20
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> Teste-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> Index: b/drivers/scsi/device_handler/scsi_dh_alua.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c	2014-11-06 14:01:37.=
682079047 -0600
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c	2014-11-06 14:04:08.=
772079175 -0600
> @@ -474,6 +474,13 @@ static int alua_check_sense(struct scsi_
>  			 * LUN Not Ready -- Offline
>  			 */
>  			return SUCCESS;
> +		if (sdev->allow_restart &&
> +		    sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D 0x02)
> +			/*
> +			 * if the device is not started, we need to wake
> +			 * the error handler to start the motor
> +			 */
> +			return FAILED;
>  		break;
>  	case UNIT_ATTENTION:
>  		if (sense_hdr->asc =3D=3D 0x29 && sense_hdr->ascq =3D=3D 0x00)
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

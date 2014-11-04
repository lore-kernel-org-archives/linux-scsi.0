From: Hannes Reinecke <hare@suse.de>
Subject: Re: [V2 PATCH 2/2] scsi: TUR path is down after adapter gets reset
 with multipath
Date: Tue, 04 Nov 2014 08:21:13 +0100
Message-ID: <54587E69.50108@suse.de>
References: <20141103211806.572351346@linux.vnet.ibm.com> <20141103211815.000777763@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbaKDHVP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 02:21:15 -0500
In-Reply-To: <20141103211815.000777763@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

On 11/03/2014 10:18 PM, wenxiong@linux.vnet.ibm.com wrote:
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
>  drivers/scsi/device_handler/scsi_dh_alua.c |   20 ++++++++++++++++++=
+-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>=20
> Index: b/drivers/scsi/device_handler/scsi_dh_alua.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c	2014-10-29 20:50:29.=
000000000 -0500
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c	2014-11-03 14:24:39.=
482078993 -0600
> @@ -84,6 +84,7 @@ struct alua_dh_data {
> =20
>  static char print_alua_state(int);
>  static int alua_check_sense(struct scsi_device *, struct scsi_sense_=
hdr *);
> +static int alua_check_sense_handler(struct scsi_device *, struct scs=
i_sense_hdr *);
> =20
>  static inline struct alua_dh_data *get_alua_data(struct scsi_device =
*sdev)
>  {
> @@ -519,6 +520,23 @@ static int alua_check_sense(struct scsi_
>  	return SCSI_RETURN_NOT_HANDLED;
>  }
> =20
> +static int alua_check_sense_handler(struct scsi_device *sdev,
> +			    struct scsi_sense_hdr *sense_hdr)
> +{
> +	switch (sense_hdr->sense_key) {
> +	case NOT_READY:
> +		if (sdev->allow_restart &&
> +		    sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D 0x02)
> +			/*
> +			 * if the device is not started, we need to wake
> +			 * the error handler to start the motor
> +			 */
> +			return FAILED;
> +		break;
> +	}
> +	alua_check_sense(sdev, sense_hdr);
> +}
> +
>  /*
>   * alua_rtpg - Evaluate REPORT TARGET GROUP STATES
>   * @sdev: the device to be evaluated.
> @@ -827,7 +845,7 @@ static struct scsi_device_handler alua_d
>  	.attach =3D alua_bus_attach,
>  	.detach =3D alua_bus_detach,
>  	.prep_fn =3D alua_prep_fn,
> -	.check_sense =3D alua_check_sense,
> +	.check_sense =3D alua_check_sense_handler,
>  	.activate =3D alua_activate,
>  	.set_params =3D alua_set_params,
>  	.match =3D alua_match,
>=20
Why did you use a wrapper for an already existing function?
Please fold the logic into alua_check_sense().

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: export function scsi_scan.c:sanitize_inquiry_string
Date: Thu, 21 Jan 2016 07:35:02 +0100
Message-ID: <20160121063502.GS2742@c203.arch.suse.de>
References: <20160120194028.23159.25263.stgit@brunhilda>
 <20160120194141.23159.5168.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758585AbcAUGfI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jan 2016 01:35:08 -0500
Content-Disposition: inline
In-Reply-To: <20160120194141.23159.5168.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

On Wed, Jan 20, 2016 at 01:41:41PM -0600, Don Brace wrote:
> The hpsa driver uses this function to cleanup inquiry
> data. Our new pqi driver will also use this
> function. This function was copied into both drivers.
>=20
> This patch exports sanitize_inquiry_string so the hpsa
> and the pqi drivers can use this function directly.
>=20
> Hannes recommended the change in review:
> https://www.marc.info/?l=3Dlinux-scsi&m=3D144619249003064&w=3D2
> that using the existing function in scsi_scan would be
> preferrable.
>=20
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/scsi_scan.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 6a82066..1f02e84 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -518,7 +518,8 @@ void scsi_target_reap(struct scsi_target *starget=
)
>  }
> =20
>  /**
> - * sanitize_inquiry_string - remove non-graphical chars from an INQU=
IRY result string
> + * scsi_sanitize_inquiry_string - remove non-graphical chars from an
> + *                                INQUIRY result string
>   * @s: INQUIRY result string to sanitize
>   * @len: length of the string
>   *
> @@ -531,7 +532,7 @@ void scsi_target_reap(struct scsi_target *starget=
)
>   *	string terminator, so all the following characters are set to
>   *	spaces.
>   **/
> -static void sanitize_inquiry_string(unsigned char *s, int len)
> +void scsi_sanitize_inquiry_string(unsigned char *s, int len)
>  {
>  	int terminated =3D 0;
> =20
> @@ -542,6 +543,7 @@ static void sanitize_inquiry_string(unsigned char=
 *s, int len)
>  			*s =3D ' ';
>  	}
>  }
> +EXPORT_SYMBOL(scsi_sanitize_inquiry_string);
> =20
>  /**
>   * scsi_probe_lun - probe a single LUN using a SCSI INQUIRY
> @@ -627,9 +629,9 @@ static int scsi_probe_lun(struct scsi_device *sde=
v, unsigned char *inq_result,
>  	}
> =20
>  	if (result =3D=3D 0) {
> -		sanitize_inquiry_string(&inq_result[8], 8);
> -		sanitize_inquiry_string(&inq_result[16], 16);
> -		sanitize_inquiry_string(&inq_result[32], 4);
> +		scsi_sanitize_inquiry_string(&inq_result[8], 8);
> +		scsi_sanitize_inquiry_string(&inq_result[16], 16);
> +		scsi_sanitize_inquiry_string(&inq_result[32], 4);
> =20
>  		response_len =3D inq_result[4] + 5;
>  		if (response_len > 255)
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

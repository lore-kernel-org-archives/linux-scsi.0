From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1 06/25] hpsa: abandon rescans on memory alloaction
 failures.
Date: Fri, 30 Oct 2015 08:53:40 +0100
Message-ID: <56332204.1010509@suse.de>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220506.5323.34488.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758294AbbJ3Hxn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 03:53:43 -0400
In-Reply-To: <20151028220506.5323.34488.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/28/2015 11:05 PM, Don Brace wrote:
> Abandon and reschedule rescan process only if device inquiries
> fail due to mem alloc failures, which are likely to occur for
> all devices.
>=20
> Otherwise, skip device if inquiry fails for other reasons,
> and continue rescanning process for other devices.
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |   24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index a3f671c..ecc6ada 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -3375,10 +3375,13 @@ static int hpsa_update_device_info(struct ctl=
r_info *h,
> =20
>  	unsigned char *inq_buff;
>  	unsigned char *obdr_sig;
> +	int rc =3D 0;
> =20
>  	inq_buff =3D kzalloc(OBDR_TAPE_INQ_SIZE, GFP_KERNEL);
> -	if (!inq_buff)
> +	if (!inq_buff) {
> +		rc =3D -ENOMEM;
>  		goto bail_out;
> +	}
> =20
>  	/* Do an inquiry to the device to see what it is. */
>  	if (hpsa_scsi_do_inquiry(h, scsi3addr, 0, inq_buff,
> @@ -3386,6 +3389,7 @@ static int hpsa_update_device_info(struct ctlr_=
info *h,
>  		/* Inquiry failed (msg printed already) */
>  		dev_err(&h->pdev->dev,
>  			"hpsa_update_device_info: inquiry failed\n");
> +		rc =3D 1;
>  		goto bail_out;
>  	}
> =20
Why '1' and not a normal error code, seeing that you're using -ENOMEM a=
bove?

> @@ -3435,7 +3439,7 @@ static int hpsa_update_device_info(struct ctlr_=
info *h,
> =20
>  bail_out:
>  	kfree(inq_buff);
> -	return 1;
> +	return rc;
>  }
> =20
>  static void hpsa_update_device_supports_aborts(struct ctlr_info *h,
> @@ -3803,6 +3807,7 @@ static void hpsa_update_scsi_devices(struct ctl=
r_info *h, int hostno)
>  	n_ext_target_devs =3D 0;
>  	for (i =3D 0; i < nphysicals + nlogicals + 1; i++) {
>  		u8 *lunaddrbytes, is_OBDR =3D 0;
> +		int rc =3D 0;
> =20
>  		/* Figure out where the LUN ID info is coming from */
>  		lunaddrbytes =3D figure_lunaddrbytes(h, raid_ctlr_position,
> @@ -3815,11 +3820,20 @@ static void hpsa_update_scsi_devices(struct c=
tlr_info *h, int hostno)
>  				continue;
> =20
>  		/* Get device type, vendor, model, device id */
> -		if (hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
> -							&is_OBDR)) {
> +		rc =3D hpsa_update_device_info(h, lunaddrbytes, tmpdevice,
> +							&is_OBDR);
> +		if (rc =3D=3D -ENOMEM) {
> +			dev_warn(&h->pdev->dev,
> +				"Out of memory, rescan deferred.\n");
>  			h->drv_req_rescan =3D 1;
> -			continue; /* skip it if we can't talk to it. */
> +			goto out;
>  		}
> +		if (rc) {
> +			dev_warn(&h->pdev->dev,
> +				"Inquiry failed, skipping device.\n");
> +			continue;
> +		}
> +
>  		figure_bus_target_lun(h, lunaddrbytes, tmpdevice);
>  		hpsa_update_device_supports_aborts(h, tmpdevice, lunaddrbytes);
>  		this_device =3D currentsd[ncurrent];
>=20
Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

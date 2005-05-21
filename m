From: =?iso-8859-1?Q?Gr=E9goire?= Favre <gregoire.favre@gmail.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Sun, 22 May 2005 01:22:20 +0200
Message-ID: <20050521232220.GD28654@gmail.com>
References: <20050516085832.GA9558@gmail.com> <20050517071307.GA4794@in.ibm.com> <20050517002908.005a9ba7.akpm@osdl.org> <1116340465.4989.2.camel@mulgrave> <20050517170824.GA3931@in.ibm.com> <1116354894.4989.42.camel@mulgrave> <20050517192636.GB9121@gmail.com> <1116359432.4989.48.camel@mulgrave> <20050517195650.GC9121@gmail.com> <1116363971.4989.51.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.192]:35264 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261670AbVEUXWW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 May 2005 19:22:22 -0400
Received: by rproxy.gmail.com with SMTP id a41so681385rng
        for <linux-scsi@vger.kernel.org>; Sat, 21 May 2005 16:22:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1116363971.4989.51.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dino@in.ibm.com, Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, May 17, 2005 at 04:06:11PM -0500, James Bottomley wrote:

> Well, the attached is what I'd like you to try, capturing the
> information from the initial inquiry on ... it will be quite a bit.
>=20
> Hopefully it will give me a clearer idea of what's going on.

I have found a way to fetch the console :-)

Against which kernel revision is your patch made for ?

Thank you very much :-)

> Thanks,
>=20
> James
>=20
> --- a/drivers/scsi/scsi_transport_spi.c
> +++ b/drivers/scsi/scsi_transport_spi.c
> @@ -669,14 +669,23 @@ spi_dv_retrain(struct scsi_request *sreq
>  {
>  	struct spi_internal *i =3D to_spi_internal(sreq->sr_host->transport=
t);
>  	struct scsi_device *sdev =3D sreq->sr_device;
> +	struct scsi_target *starget =3D sdev->sdev_target;
>  	int period =3D 0, prevperiod =3D 0;=20
>  	enum spi_compare_returns retval;
> =20
> =20
>  	for (;;) {
>  		int newperiod;
> +
>  		retval =3D compare_fn(sreq, buffer, ptr, DV_LOOPS);
> =20
> +		if(i->f->get_period)
> +			i->f->get_period(starget);
> +		if (i->f->get_offset)
> +			i->f->get_offset(starget);
> +
> +		spi_display_xfer_agreement(starget);
> +
>  		if (retval =3D=3D SPI_COMPARE_SUCCESS
>  		    || retval =3D=3D SPI_COMPARE_SKIP_TEST)
>  			break;
> @@ -765,6 +774,8 @@ spi_dv_device_internal(struct scsi_reque
>  	/* first set us up for narrow async */
>  	DV_SET(offset, 0);
>  	DV_SET(width, 0);
> +
> +	printk("BEGINNING ASYNC, inq len =3D %d\n", sdev->inquiry_len);
>  =09
>  	if (spi_dv_device_compare_inquiry(sreq, buffer, buffer, DV_LOOPS)
>  	    !=3D SPI_COMPARE_SUCCESS) {
> @@ -773,11 +784,13 @@ spi_dv_device_internal(struct scsi_reque
>  		return;
>  	}
> =20
> +	printk("ASYNC INQUIRY SUCCEEDED\n");
> +
>  	/* test width */
>  	if (i->f->set_width && spi_max_width(starget) && sdev->wdtr) {
>  		i->f->set_width(sdev->sdev_target, 1);
> =20
> -		printk("WIDTH IS %d\n", spi_max_width(starget));
> +		printk("TRYING WIDE ASYNC INQUIRY\n");
> =20
>  		if (spi_dv_device_compare_inquiry(sreq, buffer,
>  						   buffer + len,
> @@ -802,12 +815,17 @@ spi_dv_device_internal(struct scsi_reque
>  	if (sdev->ppr)
>  		len =3D spi_dv_device_get_echo_buffer(sreq, buffer);
> =20
> +	printk("ECHO BUFFER HAS LEN %d\n", len);
> +
>   retry:
> =20
>  	/* now set up to the maximum */
>  	DV_SET(offset, spi_max_offset(starget));
>  	DV_SET(period, spi_min_period(starget));
> =20
> +	printk("DV SETTING TO period %d, offset %d\n", spi_min_period(starg=
et),
> +	       spi_max_offset(starget));
> +
>  	if (len =3D=3D 0) {
>  		SPI_PRINTK(sdev->sdev_target, KERN_INFO, "Domain Validation skippi=
ng write tests\n");
>  		spi_dv_retrain(sreq, buffer, buffer + len,
>=20

--=20
	Gr=E9goire Favre
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

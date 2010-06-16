From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 5/5]scsi:hosts.c Fix warning: variable 'rval' set but not used
Date: Wed, 16 Jun 2010 19:25:43 +0200
Message-ID: <201006161925.43956.eike-kernel@sf-tec.de>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com> <1276702443.2847.153.camel@mulgrave.site> <4C18F524.4000902@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4375284.Rhr4l8mgtq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:51568 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482Ab0FPR0W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2010 13:26:22 -0400
In-Reply-To: <4C18F524.4000902@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org

--nextPart4375284.Rhr4l8mgtq
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Justin P. Mattock wrote:
> On 06/16/2010 08:34 AM, James Bottomley wrote:

> > However, I don't think we should be ignoring the fact that the eh thread
> > failed to spawn, so I think some type of printed warning (giving the
> > error code) would be a much more appropriate replacement.

> o.k. I'll give a try at that.. as a  test I did this(below) seemed to
> compile clean, but not sure if this is what you're asking for though:

> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 6660fa9..8d98a46 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -325,7 +325,6 @@ struct Scsi_Host *scsi_host_alloc(struct
> scsi_host_template *sht, int privsize)
>   {
>   	struct Scsi_Host *shost;
>   	gfp_t gfp_mask =3D GFP_KERNEL;
> -	int rval;
>=20
>   	if (sht->unchecked_isa_dma && privsize)
>   		gfp_mask |=3D __GFP_DMA;
> @@ -420,7 +419,7 @@ struct Scsi_Host *scsi_host_alloc(struct
> scsi_host_template *sht, int privsize)
>   	shost->ehandler =3D kthread_run(scsi_error_handler, shost,
>   			"scsi_eh_%d", shost->host_no);
>   	if (IS_ERR(shost->ehandler)) {
> -		rval =3D PTR_ERR(shost->ehandler);
> +		printk(KERN_WARNING "test.....\n");
>   		goto fail_kfree;
>   	}

If you want to print anything here I think the error code would be a good=20
thing to include as that could give a hint _what_ actually went wrong. In t=
hat=20
case you would need rval, but IMHO it should be declared inside that if=20
clause.

Eike

--nextPart4375284.Rhr4l8mgtq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwZCRcACgkQXKSJPmm5/E7CFQCfacAXhWr0yWSrv2m/nT+o8Bqi
RY8AnjDJroak2bG5ozIQTz1oDhpPYB+D
=eSwC
-----END PGP SIGNATURE-----

--nextPart4375284.Rhr4l8mgtq--

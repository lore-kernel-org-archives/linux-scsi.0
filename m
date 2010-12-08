From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 5/8] scsi: fix TUR error handling in sr_media_change()
Date: Wed, 8 Dec 2010 21:14:40 +0100
Message-ID: <201012082114.41509.eike-kernel@sf-tec.de>
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <1291838262-21274-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3076944.NXSmOvlDyz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:33898 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab0LHUOv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Dec 2010 15:14:51 -0500
In-Reply-To: <1291838262-21274-6-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@hansenpartnership.com

--nextPart3076944.NXSmOvlDyz
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Tejun Heo wrote:

> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -214,13 +214,17 @@ static int sr_media_change(struct cdrom_device_info
> *cdi, int slot)
>=20
>  	sshdr =3D  kzalloc(sizeof(*sshdr), GFP_KERNEL);
>  	retval =3D sr_test_unit_ready(cd->device, sshdr);
> -	if (retval || (scsi_sense_valid(sshdr) &&
> -		       /* 0x3a is medium not present */
> -		       sshdr->asc =3D=3D 0x3a)) {
> -		/* Media not present or unable to test, unit probably not
> -		 * ready. This usually means there is no disc in the drive.
> -		 * Mark as changed, and we will figure it out later once
> -		 * the drive is available again.
> +	/*
> +	 * Media is considered to be present if TUR succeeds or fails with
> +	 * sense data indicating something other than media-not-present
> +	 * (ASC 0x3a).
> +	 */
> +	if (!scsi_status_is_good(retval) &&
> +	    (!scsi_sense_valid(sshdr) || sshdr->asc =3D=3D 0x3a)) {
> +		/*
> +		 * Probably not media in the device.  Mark as changed, and
> +		 * we will figure it out later once the drive is available
> +		 * again.

"Probably no media ..."?

Eike

--nextPart3076944.NXSmOvlDyz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkz/5zEACgkQXKSJPmm5/E4RIwCgmLecVbJQphEZPlyM+labK9/2
ybIAnAxCKEHzpksGxmq+XOHz9DSlTTi8
=/66e
-----END PGP SIGNATURE-----

--nextPart3076944.NXSmOvlDyz--

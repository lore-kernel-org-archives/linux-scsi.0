From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 19/30] scsi: Remove explicit casts of [kv]alloc return values in osst driver
Date: Fri, 24 Aug 2007 09:04:58 +0200
Message-ID: <200708240905.04994.eike-kernel@sf-tec.de>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com> <aaed77aa8511322bc32b406a952c7c960091ff3b.1187912217.git.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1560431.S3jFJPvFbj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:50420 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760217AbXHXHFI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Aug 2007 03:05:08 -0400
Received: from pd907f0e2.dip0.t-ipconnect.de ([::ffff:217.7.240.226] HELO [10.1.1.229]) (auth=eike-kernel@sf-tec.de)
	by mail.sf-mail.de (Qsmtpd 0.9) with (DHE-RSA-AES256-SHA encrypted) ESMTPSA
	for <linux-scsi@vger.kernel.org>; Fri, 24 Aug 2007 09:05:06 +0200
In-Reply-To: <aaed77aa8511322bc32b406a952c7c960091ff3b.1187912217.git.jesper.juhl@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Willem Riede <osst@riede.org>, osst-users@lists.sourceforge.net

--nextPart1560431.S3jFJPvFbj
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Jesper Juhl wrote:
> [kv]alloc() return void *. No need to cast the return value.

> @@ -5756,7 +5756,7 @@ static int osst_probe(struct device *dev)
>  	write_lock(&os_scsi_tapes_lock);
>  	if (os_scsi_tapes == NULL) {
>  		os_scsi_tapes =
> -			(struct osst_tape **)kmalloc(osst_max_dev * sizeof(struct osst_tape *),
> +			kmalloc(osst_max_dev * sizeof(struct osst_tape *),
>  				   GFP_ATOMIC);
>  		if (os_scsi_tapes == NULL) {
>  			write_unlock(&os_scsi_tapes_lock);

Three lines later:

		for (i=0; i < osst_max_dev; ++i) os_scsi_tapes[i] = NULL;

This wants to be

os_scsi_tapes = kcalloc(osst_max_dev, sizeof(struct osst_tape *), GFP_ATOMIC);

Eike

--nextPart1560431.S3jFJPvFbj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGzoMgXKSJPmm5/E4RAr/CAJwKMeoBd9YsFnCF1hZQqQEOl6HwzQCeOY4w
q/aoFsU+p8qt4Ax4dk4CZHM=
=f5Xx
-----END PGP SIGNATURE-----

--nextPart1560431.S3jFJPvFbj--

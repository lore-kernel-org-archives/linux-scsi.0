From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/5] block: Implement support for WRITE SAME
Date: Tue, 14 Feb 2012 09:05:54 +0100
Message-ID: <1850970.Jr6mms0Kgx@donald.sf-tec.de>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com> <20120207214005.GG6346@redhat.com> <yq1hayugyv4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1542498.KggAQYrvjp"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:52588 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360Ab2BNIGg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2012 03:06:36 -0500
In-Reply-To: <yq1hayugyv4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, snitzer@redhat.com, jaxboe@fusionio.com


--nextPart1542498.KggAQYrvjp
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Martin K. Petersen wrote:

> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 129a9c0..b0d25ea 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -358,9 +358,15 @@ static inline char *__bio_kmap_irq(struct bio *bio,
> unsigned short idx, /*
>   * Check whether this bio carries any data or not. A NULL bio is allowed.
>   */
> -static inline int bio_has_data(struct bio *bio)
> +static inline unsigned int bio_has_data(struct bio *bio)
>  {
> -	return bio && bio->bi_io_vec != NULL;
> +	if (!bio)
> +		return 0;
> +
> +	if (bio->bi_rw & REQ_DISCARD)
> +		return 0;
> +
> +	return bio->bi_io_vec != NULL;
>  }

Shouldn't this be just "bool"?

Eike
--nextPart1542498.KggAQYrvjp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk86FeoACgkQXKSJPmm5/E4wZQCfSzy7qT6h7crJB3L+wAaVPVn+
z8gAoIgvwNx/iQ5HBhyOzXNBWlPRsu0R
=s8RA
-----END PGP SIGNATURE-----

--nextPart1542498.KggAQYrvjp--


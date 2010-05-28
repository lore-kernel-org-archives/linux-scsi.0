From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 08/24] hpsa: fix leak of ioremapped memory
Date: Fri, 28 May 2010 21:12:17 +0200
Message-ID: <201005282112.24802.eike-kernel@sf-tec.de>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com> <20100527201322.3116.86053.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2914297.itjYZsoPnK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:44539 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab0E1TMc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 15:12:32 -0400
In-Reply-To: <20100527201322.3116.86053.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

--nextPart2914297.itjYZsoPnK
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>=20
> hpsa: fix leak of ioremapped memory
> in hpsa_pci_init error path.

If you had used devres to track your resources you got this for free.

> @@ -3474,6 +3477,12 @@ static int __devinit hpsa_pci_init(struct ctlr_info
> *h) return 0;
>=20
>  err_out_free_res:
> +	if (h->transtable)
> +		iounmap(h->transtable);
> +	if (h->cfgtable)
> +		iounmap(h->cfgtable);
> +	if (h->vaddr)
> +		iounmap(h->vaddr);

I wonder if that shouldn't use pci_iomap() instead. Also the page aligning=
=20
tricks in remap_pci_mem() look a bit dubious to me. If your pci BAR is >=3D=
=20
PAGE_SIZE this isn't needed at all anyway since those mappings are aligned =
to=20
at least their size in physical address space anyway and the logical addres=
s=20
shouldn't matter for the driver.

Eike

--nextPart2914297.itjYZsoPnK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwAFZgACgkQXKSJPmm5/E5WrQCfcoktmSJxUWggVEhnwdiCpxbW
iksAn3OMS0FYRN3OW31Nk1dLciIUbWZI
=N9BY
-----END PGP SIGNATURE-----

--nextPart2914297.itjYZsoPnK--

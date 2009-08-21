From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 2/14] bfa: Brocade BFA FC SCSI driver (bfa part1)
Date: Fri, 21 Aug 2009 19:35:44 +0200
Message-ID: <200908211935.46316.eike-kernel@sf-tec.de>
References: <200908200659.n7K6xqMZ006536@swe57.brocade.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1781262.CMuzRPZbpK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:47714 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149AbZHURg4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Aug 2009 13:36:56 -0400
In-Reply-To: <200908200659.n7K6xqMZ006536@swe57.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

--nextPart1781262.CMuzRPZbpK
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Jing Huang wrote:
> From: Jing Huang <huangj@brocade.com>
>
> This patch contains code to access Brocade Fibre channel HBA
> firmware/hardware, part-1
>
> +/*
> + * Copyright (c)  2005-2008 Brocade Communications Systems, Inc.
> + * All rights reserved
> + * www.brocade.com

Shouldn't that be 2009?

> +char *
> +wwn2str(char *buf, int bufsize, u64 wwn)
> +{
> +	char *ptr;
> +	union {
> +	wwn_t           wwn;
> +	u8         byte[sizeof(wwn_t)];
> +	} w;
> +	int i =3D sizeof(wwn_t);
> +
> +	ptr =3D buf + bufsize;
> +	*--ptr =3D '\0';
> +	bufsize--;
> +
> +	w.wwn =3D wwn;
> +	while (i > 0) {
> +		i--;
> +		*--ptr =3D n2b(w.byte[i] & 0x0f);
> +		*--ptr =3D n2b((w.byte[i] >> 4) & 0x0f);
> +		if (i > 0)
> +			*--ptr =3D ':';
> +	}
> +
> +	return ptr;
> +}

I searched for 20 minutes and found nothing. Is there really no standard=20
function to printf a WWN? I mean, every FC driver needs this, no?

fnic:
=2D"%llx", wwn

ipr:
=2D"%08X%08X", be32_to_cpu(wwid[0]), be32_to_cpu(wwid[1])=20

lpfc:
=2D"%02x%02x%02x%02x%02x%02x%02x%02x", wwn[0], wwn[1], ...
=2D"%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x", wwn[0], wwn[1], ...
=2D"0x%llx", cfg_soft_wwnn

qla2xxx:
=2Dlike lpfc, version 1. Harder to find as there it is called port_name and=
=20
node_name instead of wwpn or wwnn or wwn

Is there really nothing like this? Should be an easy job to write one and=20
convert all existing drivers over to use this, no? Would also add the benef=
it=20
as that all drivers would print that in the same way.=20

Ei-printk("%WWN", wwn)-ke

--nextPart1781262.CMuzRPZbpK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkqO2vIACgkQXKSJPmm5/E748gCghCJlF+cFo1UzujUNs4iIIQfE
EJwAmwWKgw9JrcL7DG8c/GSt7GMwdghg
=baeK
-----END PGP SIGNATURE-----

--nextPart1781262.CMuzRPZbpK--

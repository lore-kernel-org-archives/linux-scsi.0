Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DC63B19F
	for <linux-scsi@vger.kernel.org>; Sun, 30 Nov 2025 01:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764467703; cv=none; b=ep316HJxM4J1cb0a7E2Q44gatyyU5vkWjPo38hTZjdU+eUoBW1peOR4RX+ZoSIheZ8KYdE6AGAiroCuf0Wn/Busu8mNITUzLvz4bvqY/wiKBcs52x+jWOgzMXVGPDwAEGhCZkPJ/niZ4Hv/Y2tpAc7yht6QbHmWFNR9jP15LHGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764467703; c=relaxed/simple;
	bh=EJsie/oDWmsHzwg9Cgw28LSjOg36CreOoDF9rcGSUdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DERg8YOT7ah+ShfofFHAFKXuFEmIzCaARb00pN1V6vJOR/VFvwnFCbujeF2amuQbnQNbFdLl0EzL+J9ym6ue1UQTHK3JVZgFhVEG1OEqHfdXiJVXtzFx26w2fJdpRY0lT3jwzLJY4qgfHg/mJWFJxvaFwbTJPV6ViN8Mh4FJnVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TGfF67mr; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TGfF67mr"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2955623e6faso33244145ad.1
        for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2025 17:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764467701; x=1765072501; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EJsie/oDWmsHzwg9Cgw28LSjOg36CreOoDF9rcGSUdA=;
        b=TGfF67mrdR1kDeHzakHJuS5yb9QF/r29xdgf3PVQawaLL4JZMBWsxvYnIzp8VV6eZ0
         R6yU4NEDTV8XJrPz0wNFXjolGojN3aKjd/EIJLpeYKz/xR1DDjeKDP4KniL/n1MdKG+t
         KdpYFIQScaWs56V0/4KgtrpV116UbH59VlRQ2Py67ETNI5SjqISKJzJXhWAj2iVDqW0U
         sdcPOIVvVP+IfEcnapPna0iZagZBbZe4247tO7BhkiEblxfVDH6n7QSYzbXqTwwVFbrS
         5GjkQhn8L5iHeApIjwezBxCtniPPyK/AYG58JlpdfL1OmaYcbRzJl/Fc0Dhgk4u9BURV
         HiyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764467701; x=1765072501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EJsie/oDWmsHzwg9Cgw28LSjOg36CreOoDF9rcGSUdA=;
        b=v1XqD0PMueCjHpGkJIHtUQMLVxkErBNRWnR4JtORospbqxqvgx2za+L52oKCsSiwxd
         pLVlZE8zIhECCv950bUuwREtYN7hHyXxzmpNwUunccEHcXfCIPxo6D/qUyl4vGdwJevu
         11zLtNN8LRwd2DE5SM622EO4MQiNyTJS66YBf2J4T1TNXszjLD5qx9KyW0YdKk++bOpX
         L+3TE4XWqM/Z9Un49II69FsYbXugC6wwYirOqCwvB5qdDnT8eGb1mB4fYlWxsTrXtik4
         Ab+SPriKVr77mDdMMRxLiK5HmNX0WRn8cuxrqdvu+F6c9cUEjvobwYNt1GkQkeLGXYy+
         wgFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXorQotxiNgB+kdSKSy2UzrlVpGloEBtz1oCjYf1dDE0gpzIh8qGCRKMHJAwsvo1N6tIaE9fJDSkvxT@vger.kernel.org
X-Gm-Message-State: AOJu0YyHjbHiLR8YVnY/fDomJA3w3s0ZdCPRZ9a+C4UJUXS5vgvl12tl
	sRnM2QhzTklWGnExO9M0zdbAUNaio3XxcWGPyfB1wKtbI191cBfahaac
X-Gm-Gg: ASbGncsELnVuiFNEYj4r3OVCCA/UWZwabMx3MvJ22HCa7ZegWvYQPHJ9N2Ag3jOK1nL
	vMOM8LKkxnvW+x45XvsE/S2vH1ILBqFfLsBLZeVLlfa1m7mhOikWBgZyQhzJLaUAH/UBjADOpGa
	VsFzVs7+NsMCy7m1xk/xEn7HvOfX3lkojnNezo/e2xslIsPwEfjTiTSn4dXUS+Ot8OFbrkxytCP
	qjwYCrLzlHfW/0qq5U/xVrTArCJVVvK3k7xI74TR4LO5NPEjTotsBIefrlDjS8Y0PMH5PcvL9BM
	W5CGoFKOkjYy3Tfdp5mxxkdGm9F3Ktd2RUwgps3C7S+2IoMvUcUTb8aLHjE8GVXDqbplNOSJNvh
	GZPhkkEc3My1I4G1ez/uXjeLycoRlRXFOwoIjBrCbprAMwhni7agAeqdIxpgsrL2CxSmjawEN+9
	D79KxjpBRJSbk=
X-Google-Smtp-Source: AGHT+IF/l7NB+y1jtAMRLjj8iCOnE7KKZZWOFytSeyN/8Cx2c8SbmngUPLwiA2q9K90lCrCmvmph2g==
X-Received: by 2002:a17:903:19c3:b0:295:b46f:a6c2 with SMTP id d9443c01a7336-29bab1685bdmr230368035ad.37.1764467701296;
        Sat, 29 Nov 2025 17:55:01 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3475e9b46f4sm6358089a91.3.2025.11.29.17.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 17:55:00 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 38D464218345; Sun, 30 Nov 2025 08:54:52 +0700 (WIB)
Date: Sun, 30 Nov 2025 08:54:51 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Max Nikulin <manikulin@gmail.com>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] docs: admin: devices: /dev/sr<N> for SCSI CD-ROM
Message-ID: <aSuj66nCF4r_5ksh@archie.me>
References: <a221275c-53af-459d-97ed-05a0766adb04@gmail.com>
 <aSqPHMSgtHN7ty8-@archie.me>
 <c5bb2474-b66d-47e5-b392-b12c4db979df@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3cV3mE+eGYkJw/de"
Content-Disposition: inline
In-Reply-To: <c5bb2474-b66d-47e5-b392-b12c4db979df@gmail.com>


--3cV3mE+eGYkJw/de
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 29, 2025 at 10:01:41PM +0700, Max Nikulin wrote:
> On 29/11/2025 13:13, Bagas Sanjaya wrote:
> > On Sat, Nov 29, 2025 at 12:12:32AM +0700, Max Nikulin wrote:
> > > +Usage of ``/dev/scd?`` as alternate SCSI CD-ROM names for ``sr?`` de=
vices
> > > +ended around year 2011.
> >=20
> > What about "Support for /dev/scd? as alternative names for /dev/sr? has=
 been
> > removed in 2011"?
>=20
> If others support your suggestion then I do not mind. Feel free to commit
> preferred variant ignoring my patch.
>=20
> I would be more verbose however by adding that it was removed namely from
> udev:
>=20
> Creation of ``/dev/scd?`` alternative names for ``sr?`` CD-ROM and other
> optical drives (using SCSI commands) was removed in ``udev-174`` (released
> in 2011).

This one looks better.

>=20
> Perhaps I am biased by my confusion. Noticed that wodim tries to access
> currently absent /dev/scd0 for kernels >=3D X.6, I tried git blame game in
> kernel repository to find kernel version when scd<N> were renamed to sr<N=
>.
> It took some time for me to realize that it is impossible to determine scd
> vs. sr from kernel version. That is why I would consider adding explicit
> mention of udev. Otherwise for me it sounds like that scd? names were
> removed from kernel. I am not a native English speaker, so I do not insist
> on my variant.
>=20
> How long I should wait for comments before submitting another revision of
> the patch? I hope, pending changes are not an obstacle for those who are
> tempting to review the whole devices.rst file.

Since we're in rc7 (and 6.18 release is tomorrow), you need to wait until at
least two weeks later (when 6.19 merge window closes) and repost. Don't for=
get
to Cc me anyway.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--3cV3mE+eGYkJw/de
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaSuj5wAKCRD2uYlJVVFO
owTQAP9w+uWu3xIqLC+ZYTFzZOgEVmU14JCotEG/IeEI7KRE2QD/bVAaD/dBSb15
KaSXUaWSu+OIvuxec51RzTuuGFPu7AQ=
=kmxx
-----END PGP SIGNATURE-----

--3cV3mE+eGYkJw/de--

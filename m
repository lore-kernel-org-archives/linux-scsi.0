Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3131D352F95
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 20:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781125010; cv=none; b=No2sZQRIMvztb1iDoGpz1A85DmXO32x6N7+1d2dgqoeLW81np18Im3N0ztZhXyfdYrkRRgN65ow7ptgRBjr8Iuy3KZvW546R0bJh6LfcYitOYg5PSOdVXzxhOA04mAzpFLQcogu0WHZZkbM0IZ6PR4GmgWpyHKTjyvB2lVELTtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781125010; c=relaxed/simple;
	bh=Uw+bVKuSNHDEmPzBZJHOJj8rAChZRPa0vhBaxuhG/U0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZwaGAC3lGU/T3XEay5+9EBn0HUe+CVJkZRF2O9tRt6G1fghQrsEdhfHMdLBUI2q0J38fN/ATyxSyWNG/GRgErQRknuP1RFrIxYfKv7BCJNzvMnM7KuODc9nzdk9PSWZxPFRsvJzCfbEk8Z01zWUDCsax9ztWJc5oX5ZLsMr9IAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=gBiCDNYK; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="gBiCDNYK"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490c1915793so52029175e9.2
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2026 13:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1781125006; x=1781729806; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wHnIpgO42NH6+Ad+ppwobMNc15nwTLi776JaQeCvZQE=;
        b=gBiCDNYKPwSzykz2mRQoSmwLpZ6TgevfS1jLtng8wrg+GDrm6zsCQJn8Ln8nb/fsl9
         KR6IhlbmthsfB4fbWiVShAIZKw5MAbwiMrDBth9bMytUTpAo/hOQGv66lQEyNY++BBfr
         5uQxaeKKHeD97kRvnv93Ae37XLnOHOsS9IzvQa/5h1J106472nkFenTp/0CJ/CSyqxlt
         Y/m/JmttxS12DfjSYYT7tkHg+Jk92jMLZ+jEttfamyqQ2pA5DTroJHfvkr9Iv6x1Ui+l
         n3Fpl+0J1Nb6HAUT9QBFvmrnP0JTEDKtdLs/v4tExvuvuTLEZdkrd1PPQWqH1rzqGo6V
         TbsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781125006; x=1781729806;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wHnIpgO42NH6+Ad+ppwobMNc15nwTLi776JaQeCvZQE=;
        b=rVgRmS/6RdnwARROCwq89Yi0sMqKMm3ghCA7a6mYnqHe7LB67YKKxo3AheFy3iQbrz
         xCzFvzZaJOOl6CufeKam1mtQPSOk4l8fbfeKQ1bdoOjmnhAD7h/kmREMnjljVwcUH2JR
         Cv9aSeVeU9NDOV5ic10IqagTkKdgADAxXcmAcpD1P+c2jfvy004Os5goRl4v9IOgZEqk
         IUZ29SqQOfzjYAUUyhgdMjP/4etFOJm7Mk/FS8EmRcsQ3jWRVc29x/DQ1zrWU9MipY57
         hMkinls+UfxDumUqs+gm/FE4C/Lyb9mV9S9Reiu5uimpkPKa6/H7jKbVJsTgBs5EXQxC
         +klg==
X-Forwarded-Encrypted: i=1; AFNElJ+iSzZqY96kIWrrVKm0DiJJyBifupt4yI/m16/meqiokD1GhloC6b8kj6l+RoQalfUy1g8D3/vbsxzQ@vger.kernel.org
X-Gm-Message-State: AOJu0YzBNcKDZHBjSLBUKX3v7WQn15bUERTcqxwBrcs7WJEVpDB+0oG0
	1onja1TA1POHw3mkQQstWPenhtWtvJVnEzXbhrsgxcD7yZrhfLBbgRpSmoEa1/x7Ah0=
X-Gm-Gg: Acq92OGZCDfDvDBhGQinZPh6OYcdTQgKj5YS1aquQnCMOvONubVYYOOCulGdzYOpWfj
	BMWQQsLmTbyJiuBnwW97DsPbQQNY9QskbCktd1ntThsU2D2mEYnHCmgxNdjAANYfZnQMLluhTxt
	rlRdYn0mOxSgkXmoS1rxONfA7pH6caEylNdlO+KBI+WGJKUyts8rGvEbKV6epWXKt1w/b8rjyd2
	kUJjcCzKT0Him3lD3Hh/hM+lDG2kg0G5X0DwKPfoOJQ4W4jHSn/8QcBHsapTTHHrTrolxzyiLei
	YaArs/KE4hCXlMOI0o+LOy2yXzFyWo1KGTaMFHiaWKrWvBmlRIWdmfdSPzEXVvrWwa4azZ0MJ+1
	KviuCvfXjdQXLlYSnZ2NmEUGg/IhQeTojCXqWuebpTw4Y9mwG25GB/GN87mgzZ+qPaKgmu+u9vl
	M/Ekf45qPxwTzc70FUDQRXN0k3V2qbM088EN7dHwI=
X-Received: by 2002:a05:600c:4746:b0:490:bb44:3f8b with SMTP id 5b1f17b1804b1-490e2e4517cmr6406585e9.17.1781125006559;
        Wed, 10 Jun 2026 13:56:46 -0700 (PDT)
Received: from localhost ([2a02:8071:56d1:2de0:559d:eec2:887f:c200])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f35eae5sm75644130f8f.33.2026.06.10.13.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 13:56:45 -0700 (PDT)
Date: Wed, 10 Jun 2026 22:56:29 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
To: John Garry <john.g.garry@oracle.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Finn Thain <fthain@linux-m68k.org>, 
	Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] scsi: Improve style of pnp_device_id array terminator
Message-ID: <ainNaTWWNlqRPmh7@monoceros>
References: <096aaa981c0bf1aaa8be75e675f17b1c9ca0086c.1781102092.git.u.kleine-koenig@baylibre.com>
 <f5624497-a6e3-45f3-8837-bdf8cf848dfc@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6dqirmxzpmjjskyb"
Content-Disposition: inline
In-Reply-To: <f5624497-a6e3-45f3-8837-bdf8cf848dfc@oracle.com>


--6dqirmxzpmjjskyb
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v1] scsi: Improve style of pnp_device_id array terminator
MIME-Version: 1.0

On Wed, Jun 10, 2026 at 04:46:24PM +0100, John Garry wrote:
> On 10/06/2026 15:36, Uwe Kleine-K=F6nig (The Capable Hub) wrote:
> > To match how device-id array terminators look like for other device
> > types drop `.id =3D ""` from it and let the compiler care for zeroing t=
he
> > entry.
> >=20
> > There are no changes in the compiled drivers, only the source looks
> > nicer.
> >=20
> > Signed-off-by: Uwe Kleine-K=F6nig (The Capable Hub) <u.kleine-koenig@ba=
ylibre.com>
> > ---
> > Hello,
> >=20
> > I'm currently working on changing various *_device_id definitions.
> > This patch is irrelevant for this quest and a pure style update for
> > consistency reasons without further dependencies on it. I just stumbled
> > over this while working on that quest.
> >=20
> > So if you don't like this patch, I won't insist.
> >=20
> > Best regards
> > Uwe
> >=20
> >   drivers/scsi/aha1542.c   | 2 +-
> >   drivers/scsi/g_NCR5380.c | 2 +-
> >   2 files changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
> > index fd766282d4a4..93dab19c1cb9 100644
> > --- a/drivers/scsi/aha1542.c
> > +++ b/drivers/scsi/aha1542.c
> > @@ -1083,7 +1083,7 @@ static int isa_registered;
> >   #ifdef CONFIG_PNP
> >   static const struct pnp_device_id aha1542_pnp_ids[] =3D {
> >   	{ .id =3D "ADP1542" },
> > -	{ .id =3D "" }
>=20
> It seems to be standard practice to use { .id =3D "" } as pnp dev table
> sentinel - so why change? Are they all going to be changed?

I sent several patches reworking pnp_device_id arrays. Both styles exist
(and also { "", 0 }) and I adapted all arrays I touched to the { } style
matching what is usual for all other *_device_id arrays I saw so far.

And I sent this patch only to create consistency. I think I catched most
instances already, and before declaring the quest done I will make sure
to tackle also those that I now might have missed for now.

Best regards
Uwe

--6dqirmxzpmjjskyb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmopz3gACgkQj4D7WH0S
/k4qSAgAq2KBTnzdHTPfLlDqyKf0nlJq9IoOTjV7wXhGGiR7TlglXAF6f1FL0Zxx
KKqQtZjgTYN+w6wGxW51G8OF/bqkLriu6RXZ4bXIcJtE1WWsSKlAFD8zcHIJv6dG
3+BV8lwIqZbZDVzbND84MxsNQ8Dmro0HHyFvam75o50YsoDlo1HMqV9tKsIYhiCv
mN4k26SiwFSJw9sE1Oc9rPKZWzGxctufXEoRw9Wr4n7t8nD+m88EvrFAokQC6gXR
pTIMUA5JYNsxLctmMizX5ay+M/71ZiDmyV2okftn5wsw8bwuc8fEXRtOtvpJaD+j
KFjntFfHqP2tepoGAxPFHBC9bDPXFQ==
=xzIf
-----END PGP SIGNATURE-----

--6dqirmxzpmjjskyb--

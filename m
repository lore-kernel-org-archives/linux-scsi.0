Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4408230B538
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 21:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765315382; cv=none; b=EHirzMmB4mJJGo2VEvVv14yezzvyO1+cXg+ld8LSwbOKDdReRRX9WDcKcYI6kqjOtMpAx6Sn1QeJe6JcvivLABkZ38unK91b1C1UcOfnl/BH1e+u4KexMxVtC8SVhFohV+0KPD4T2hyZ1Xis1zYieoCCTWYcQKqjOdFuQjvWFmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765315382; c=relaxed/simple;
	bh=mVfqQFDJgXgbBCIxP2tFBjFqVcsWSwsZudzmeNbgb50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s4UeGHZbR8RgYHAZWuC/IfCfuf3boWJPoAdp1LaT0KGB2qklASomIYYhsbgeJMPdsAB8+I7vVtHODxTBHrTUmSOP6yh96r6id2Vq2P1Mo/7uDx7yN6NyckCHracs1VAt4zpgIiPk7g/AntgvGTowHV9PuDjQ600j9EBSD2X/lz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=XnDS00Wd; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="XnDS00Wd"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b735e278fa1so1075898366b.0
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 13:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765315376; x=1765920176; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MP/MKVcz6+Wi8CfuV/t1F42/Is8PBbTDcKLmlIkrnrs=;
        b=XnDS00Wdan+lkoGQa5zXoUEjvCLj2/54qMGXUJwlecDFog60X/LQVvkik5+9Bdb5/k
         6PI/vtG90EMOju8q1cBn6pwDu8/sMsugCWRxuyVLfQxuSQZRTTbwd0SWqtpt1PixlTg2
         dHlS2rXCxxReDZaf8mzmajHS56Q/qzqhQNHAQndwT+lPoR3Vf15eUtjngmpoc/oYyz1o
         f+Z9NoysuCDjrDFD545pQ449RZy7QpULXzpUArPL8w3Uir8j5z/H+8Ac2A52IQnfnBMP
         TI3Q2NVfeE07zy7okzmCHK7vQhvOzbXGkZu22QENZPO6wP3A8ebEVKfNlYab3wIszfhP
         ouZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765315376; x=1765920176;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MP/MKVcz6+Wi8CfuV/t1F42/Is8PBbTDcKLmlIkrnrs=;
        b=jE5XU/jzv1DKv79+fg3SgotuJtwec4iYfTKz2e5hQl0pfUHUgymtRTAW1fgz/PQmz+
         MgrCvjril+tuoOBHB7qJLqMEN0mvKWOyS1UEEW7N88OcrYQ8RYtSGw+HN8oh+Ar74Ju0
         V1ECtVdsoRWq39/X0JBARMq+EZjFF9JXV9qM1USi8Dz/0DLfw1fJIIPwxAv1xvOwTbWG
         kC31KWhvk0/yoXubKZ31b+sprFUPOjDQzfo7qIe+U7GPaA/3XFk7w6dDtW5/oHDi6CK7
         5xF973EIDtiL+a4cmr+rFFO/kxoCzAakx4tpd4l6tH0kWIta9m+VMCQbwM9TcysKvLx8
         JLAA==
X-Forwarded-Encrypted: i=1; AJvYcCVu1ZpT2xEOd8slenv7H/l0yw5bqDvNY2xxp4SDGaL6niZLJuUXCQCEJ0IF53aS2+esB4fbO7sRs7Ht@vger.kernel.org
X-Gm-Message-State: AOJu0YyS2jjyJI2P9UIiDd9ivBm7rPKhvszf7K22lyjVIEg1nVmdP+0G
	nuvKEIIF9VL/v5qqA+ztxi7AkrrIaMFujzvkWc4/qE2Cg9w1I+oKOlH3oszAev9TNL8=
X-Gm-Gg: ASbGncvqPFzNU+ZUXR/bT73CFmo+v+JI8LOoyT4/ch+DM1rpddzAuLlM6wJBRuEwRl0
	LMfY/TkG41eb45mSml/kiJVXAwNYyVgqyjKaiREjA2NH77OoFlt+9YipGeZPhYzgwZTdUW/kIAu
	/gEtTUfZUHPutY5BHnlayug0QMHX9Mp5bsxTiC8GIOExnsI3NtaI8lSeOHaMIDG8OswnoY7yxsJ
	6bGeS+T9Gp/6AQqLbiUXyW9QldLYjj/MftPd4DsaZfUvkZmhn/+kksiui4FfpBcy2cN2szgN2+6
	oaIkMRnpEKw41XDbu79utnQkVm/auUgJdhHedhUfq6l2aoWAumSWGTNBAKl1KVM6f5Y7bikw1gK
	rgITtgC7vD4IaM4FHwPGQs0w1KyKv7u15AhM/If18WQYxpt4RLBKRmRDIN9ZhQNtBC5CVnbPzk/
	No8RDyIHWNKt4peB1+
X-Google-Smtp-Source: AGHT+IHePqBRD5VmD7+kI8U08Rj+P50pfm1oZGwJK90Uu83i4Yy0loCUmRj/oPg0m7eO0BwHKOAu2A==
X-Received: by 2002:a17:907:3da8:b0:b3f:f207:b748 with SMTP id a640c23a62f3a-b7ce823a0ecmr10049766b.10.1765315375875;
        Tue, 09 Dec 2025 13:22:55 -0800 (PST)
Received: from localhost ([2a02:8071:b783:6940:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b7a705003e7sm231356366b.25.2025.12.09.13.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 13:22:55 -0800 (PST)
Date: Tue, 9 Dec 2025 22:22:54 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/8] scsi: Make use of bus callbacks
Message-ID: <akknplwphiv2qllb6s3k5cpyqz76coyvbutmwln4bjtsi5rxqo@twezemfbfiow>
References: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
 <59b408f6d89d402457a23564302afcbb334bc9dd.1765312062.git.u.kleine-koenig@baylibre.com>
 <e4924c88-909c-4ba4-8281-184f783539ff@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4faqs2zjn6stbdzm"
Content-Disposition: inline
In-Reply-To: <e4924c88-909c-4ba4-8281-184f783539ff@acm.org>


--4faqs2zjn6stbdzm
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 2/8] scsi: Make use of bus callbacks
MIME-Version: 1.0

On Tue, Dec 09, 2025 at 12:59:08PM -0800, Bart Van Assche wrote:
> On 12/9/25 12:45 PM, Uwe Kleine-K=F6nig wrote:
> > +static int scsi_legacy_probe(struct scsi_device *sdp)
> > +{
> > +	struct device *dev =3D &sdp->sdev_gendev;
> > +	struct device_driver *driver =3D dev->driver;
> > +
> > +	return driver->probe(dev);
> > +}
> > +
> > +static void scsi_legacy_remove(struct scsi_device *sdp)
> > +{
> > +	struct device *dev =3D &sdp->sdev_gendev;
> > +	struct device_driver *driver =3D dev->driver;
> > +
> > +	driver->remove(dev);
> > +}
> > +
> > +static void scsi_legacy_shutdown(struct scsi_device *sdp)
> > +{
> > +	struct device *dev =3D &sdp->sdev_gendev;
> > +	struct device_driver *driver =3D dev->driver;
> > +
> > +	driver->shutdown(dev);
> > +}
> Does this patch series convert all SCSI drivers that trigger calls to
> the above functions? If so, shouldn't there be a patch at the end of
> this series that removes the above functions again?

I decided not to do that as part of this patch set. In case I missed a
driver and for oot drivers I think it's nice and fair to not break them
immediately and give its users/developers a chance to see the warning
and act on it.

Before the callbacks can be removed from struct device_driver these
obviously have to be dropped.

Best regards
Uwe

--4faqs2zjn6stbdzm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmk4kygACgkQj4D7WH0S
/k5XuAgAshUsMGhwd4sO0X4qTJINO/wbB7Y3P+fG5UfxWEL6syfl39z7mh8Qjhw2
EVof1A5Q6nwZR6ewfjlcYa7M+GU/flz3jf4mMo24cK+44TpHYOC607CMlLI44kau
U7oKFaR50O+i0bNcvQDmXNsx9LPqWNQQLFdfPHn4zQLcVM57e5/nagmo8BAseFUU
9mn/F8GN9tXA4XyABjsrXNdeI4Z4FPG3bx26O/lTzbhZuPwS/kke09aJXswUXONH
T5El/L3jhIbUsaXAalJQRryCpK5Hlm2NEmIrYZEXaE5PXl2CSWgNs1mbnoOW2Dh9
5b8PwAHwWsn9WOX6gnZtsyZ4ZWj6dw==
=zdnE
-----END PGP SIGNATURE-----

--4faqs2zjn6stbdzm--

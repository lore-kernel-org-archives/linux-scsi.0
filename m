Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2CF1D271D
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 08:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730883029; cv=none; b=WJ+i/cC/ntHck0UHTKh8g+dGiQl/Hw8b0kGP0bQ/+CTsVbgTr6cQGPsD4SSha046ogtA7YLoulMWHUnO9epEPadvrAsjDhv7n+Kfxi84TJ7xkQh6Cpi7+yO7eli5BJ7DREAfvewpRHq2Oj3HYL7bCn710igF9itrwRVFTJcnYBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730883029; c=relaxed/simple;
	bh=Qw/O+ise3frqlKTZUnBXTla7mdjrxDVQvyMdAvWwzxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dzU7sMcAgM9vpWhqmiCQ+hRRWXxDMMvDh82rM9X+L+2e/QgkLxC/9ZT0x46GxzRcu6mHWjc6VYCrulXJz0aVyR7XgC0psX+jJpfhfJdfX8IcaU0ROwM4Wocx3PG9NGI9U+vXfD28S8N9Us8fxdLpwNx1aLm2tSUlFlMLGpWT2Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=sRKC7qle; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="sRKC7qle"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4314b316495so55210735e9.2
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2024 00:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1730883025; x=1731487825; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2y5HxipShLescLFWcD8ARWRAPkNr3UxFiV+SpqkG9SE=;
        b=sRKC7qle/sgz+AaqfA2ejKQSLcU7F4tmlDwwEq7b/Vm+PTNw1rFtLzGQg8p/JHgYxX
         BU93jiXoUIryvgpsyJVNokfOYYCyPWao+cQoVUNuLziag/dKJ9Izdf7HX77gBayNsmXi
         IPMgKcXGU+eaDc4D/WyW8k/Vg9KHlWpL9ax6tGO5yLEHWL5qvXwmmyEk4U6SaJHSyVJ2
         J6opQU+bYPEgkLKTkew8eIYV+FDJ7pCnm3OwDLhX6JKQbxEJfZ5HKcdQVjarvHYgPGLj
         YX6+BHwYiGcgSta9/A7y78CQJH41Pz4d19mMLqeDhMYIkQQwxfbFv7DPB+DyPDy4ApQM
         EiPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730883025; x=1731487825;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2y5HxipShLescLFWcD8ARWRAPkNr3UxFiV+SpqkG9SE=;
        b=TCCbgEXhcPJSGWHc5sXyLA9QAWEQO6pZdMNuYz0edyQNNFpJhLjUmoRMSbJOt4vDUk
         BtYgnuPd1FV3KSvUSb+5M1KNg4BFV1FT521mj+g42mn0GDl+frCOHD8cNviN2UWgv2z5
         4wyxjJ6aegHXLzMd7SDc1F0inGPb4YdkFcDdLeKkDPXMOh53TlL5N8V4mZu5/BeItFW6
         Ktsndr/tU+l7TyQybjQBCN03k863Vp9Ay60/xfyKy1ZI2HzRdc0qPF25OEx7Ok0LF6Ev
         a0ZaCUPZWmdp7L+WvwOJu1qKs8Fel4HcQSf6Ck+PuPNrhPrdWb0Vz4WYAvIZOe1jR0wP
         thrg==
X-Forwarded-Encrypted: i=1; AJvYcCXf6CyiMmPP0uGHlC5mY1+jH8arQJ1OBLezEKf4H+mRW4tZGbV2zLQ1j8/Hr6CAbSq7QAxA0QIddkv8@vger.kernel.org
X-Gm-Message-State: AOJu0YyF/+Qj599WNhs2tHhVhSdD/zcY5aG+0PLJhAfIS7zqKdvRVvPU
	SKkm/8OYG5az4PlOgbk7ydjxl67zSQ4cAQXXvH1w22pzHUhLU0P5d4smehzwtdI=
X-Google-Smtp-Source: AGHT+IHqUrdPcg/Yqkh+cAwPSW88HT6c3UnrMwecsenner/5sbGIznYrPuCUBPy436J+5v+BMebExA==
X-Received: by 2002:a05:600c:1ca7:b0:42c:bb96:340e with SMTP id 5b1f17b1804b1-4327b8011aamr220555575e9.31.1730883025080;
        Wed, 06 Nov 2024 00:50:25 -0800 (PST)
Received: from localhost (p509159f1.dip0.t-ipconnect.de. [80.145.89.241])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c113dd8asm18618953f8f.73.2024.11.06.00.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 00:50:24 -0800 (PST)
Date: Wed, 6 Nov 2024 09:50:22 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@linux-m68k.org>, 
	Michael Schmitz <schmitzmic@gmail.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] scsi: sun3: Mark driver struct with __refdata to prevent
 section mismatch
Message-ID: <h7x2iksfw7vguvqvjg5axl67mpejodbimwhxluew6cfobotb4t@fewz7knes7au>
References: <b2c56fa3556505befe9b4cb9a830d9e2a962e72c.1730831769.git.geert@linux-m68k.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ixj22fbotanodxri"
Content-Disposition: inline
In-Reply-To: <b2c56fa3556505befe9b4cb9a830d9e2a962e72c.1730831769.git.geert@linux-m68k.org>


--ixj22fbotanodxri
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] scsi: sun3: Mark driver struct with __refdata to prevent
 section mismatch
MIME-Version: 1.0

On Tue, Nov 05, 2024 at 07:36:31PM +0100, Geert Uytterhoeven wrote:
> As described in the added code comment, a reference to .exit.text is ok
> for drivers registered via module_platform_driver_probe().  Make this
> explicit to prevent the following section mismatch warnings
>=20
>     WARNING: modpost: drivers/scsi/sun3_scsi: section mismatch in referen=
ce: sun3_scsi_driver+0x4 (section: .data) -> sun3_scsi_remove (section: .ex=
it.text)
>     WARNING: modpost: drivers/scsi/sun3_scsi_vme: section mismatch in ref=
erence: sun3_scsi_driver+0x4 (section: .data) -> sun3_scsi_remove (section:=
 .exit.text)
>=20
> that trigger on a Sun 3 allmodconfig build.
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Reviewed-by: Uwe Kleine-K=F6nig <u.kleine-koenig@baylibre.com>

Seems I missed that one before posting 7308bf8a2c3d ("modpost: Enable
section warning from *driver to .exit.text"). My excuse is that this
driver isn't enabled for an ARCH=3Dm68k allmodconfig build.

Thanks
Uwe

--ixj22fbotanodxri
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmcrLcwACgkQj4D7WH0S
/k7W4Af+ON8yyjSHOMZpG4vkGoh7a4mj83XDANNPRTDeLQFWUpDoB6wvjKQBUe22
Mi3uHdZPUTdBfwNu6fLEJ+4BMOAlM0G+kPB+TKijQ81ngwQfAIi1scZz7UzCC2Ft
HE+G4K+oK+Z/se3JmenLo5blTeMXH3JC0WtVQpaxkeXm5Gpb/59yLhRXha+R5O7g
tGWKhCcjiZz3dkMLCp2pI9nVJi9ZZjtEACOYWsVeYGdsfd5N+DGiIag9GTWyyWuB
wmhM+0t1W6GJfnUt7cUtiR6jbLc/xBWFHYJSQZVghudLf+kswWeavAk3sW37JdGe
7+yRpUn5NrH1mmVn1mKbcDeMusFRGg==
=MbOg
-----END PGP SIGNATURE-----

--ixj22fbotanodxri--

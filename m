Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A11278C6D
	for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 07:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730187169; cv=none; b=bEStx9QBDyxT+oSLViXdYceDoadiq89oUZhh6RXWrS2sPvkeqQH/g/yHLbIjjxTkdiIEFgIddAjQB3oT21u0cndEBxhbsOvYfGOkV/vpwRLKGPYPUP9DUSHbnYwUY3TwqcjOOcUylQyYAKyrU+vNTbMyMaD12Kya6jqDyiufP5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730187169; c=relaxed/simple;
	bh=8gFlYmg8aJbjsI5TPhu8ofR/6Ycm6FhkjEru9IJq8Vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V33AE4udBg2A4mT7XhqL2aX4c+Q+kNnyV6MMzgdou9yCj3HbIrC57wyQn2hGUxnqS+fLk+LINKEqTi91YYteJierIuCXzclZGdzODAfKe/T6r878fNOJLo7ZsVwhW4JzM2XXy6DXxCZb0lnw6SGhbsjvWgIHJKK/zqoK8N/wiaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=y6/f6CRC; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="y6/f6CRC"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4314f38d274so67828505e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2024 00:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1730187163; x=1730791963; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Vr2OoCNpwv4fo9q6sakU7X6ulwsoIZxioYPDru737U=;
        b=y6/f6CRColYkrc1s4S7C7m7Hu6RbDlcNLlttyC/F6EByUk0LfAKDaK8jOL64Oobivl
         dfeuFOIkBM5SoIuow5e36TXP19FXvTvYFXC4/1tT0tzTbPW6e/CgEXx44Iy3PN7NFO3y
         wwBhuPCCuLs0XL3aVA2W+F0zEgOqCQSXjVj7jALpdEf3O0zoKj5KdvLkdZdqxpnobBU6
         2txHK8um/kokvuwzmhg+vTAEjyh1bO5wLlmrnNw/mmkOzyvXEmIAPQFsvOk9vRElFSRE
         Vze1X0b+6tWsUcikdLyqzckI7AxBZre4uFXl1HGQ8ax0qMj8JGjuNLqYzo+YBh2oaZRp
         NTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730187163; x=1730791963;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Vr2OoCNpwv4fo9q6sakU7X6ulwsoIZxioYPDru737U=;
        b=cYFR+csTigx4wyXGJEX3RxzZ8fSyfxfOnuYaHE5B3ixGSQYhQiKDv0MPMNfdX2Ibwf
         g8q+GB5t3kWHyZYsNOyMQZZcHJQxZHlOr4AQls++rTp9eN0pmyyL9OWke+La0tXPJ57K
         Gg2cpn5NAuEBZ1Q/FCFgltJ3WRiu/RYB/mC20kIJlb70yOFt/zGSCIPW8bQtmPDR28GD
         F1Tri8b7ToCHiDskStPReY3/iRdRBxJzEalUXPcg0+mszOLGa2fB78X/km3LrhxYnJAk
         Pd9IlgYP7AoS7233n9nbYwU1f+lw7NTuEYHYY2Hcl5/2PFdR/D7l1R8wn3we+rw1cRrk
         h4nA==
X-Gm-Message-State: AOJu0YzUMhbOKBRRw4kpG0j504s8CrDdiQv/cPwyFbCQa+wRv6Cb2lsX
	IrVf5Mnw3N0YY5r2hC/2u8T3dy4gVRTUPaE0HQ3gR4m4ap4e2u9xg2qm2lu0pkA=
X-Google-Smtp-Source: AGHT+IEDwgh0ZQgkdux4I6hbX2te0nM/FTIAXGz8NCaNaZSweAMf00VscBOP2XSKllCmH+GtbfgSDg==
X-Received: by 2002:a05:600c:a085:b0:431:54f3:11ab with SMTP id 5b1f17b1804b1-4319ad2a791mr101496495e9.33.1730187162931;
        Tue, 29 Oct 2024 00:32:42 -0700 (PDT)
Received: from localhost (p50915d2d.dip0.t-ipconnect.de. [80.145.93.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4318b567838sm167754795e9.23.2024.10.29.00.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 00:32:42 -0700 (PDT)
Date: Tue, 29 Oct 2024 08:32:40 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Switch back to struct platform_driver::remove()
Message-ID: <cfhae7lnnna7difhdurabtysh3ddivl5veb7aof7u4cippurlh@gyojgwbx4iut>
References: <20241028080754.429191-2-u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7kbjgzofywrlliaa"
Content-Disposition: inline
In-Reply-To: <20241028080754.429191-2-u.kleine-koenig@baylibre.com>


--7kbjgzofywrlliaa
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] scsi: Switch back to struct platform_driver::remove()
MIME-Version: 1.0

Hello,

On Mon, Oct 28, 2024 at 09:07:55AM +0100, Uwe Kleine-K=F6nig wrote:
> After commit 0edb555a65d1 ("platform: Make platform_driver::remove()
> return void") .remove() is (again) the right callback to implement for
> platform drivers.
>=20
> Convert all platform drivers below drivers/scsito use .remove(), with
                                                ^^
I missed to restore the space here -------------'' while adapting my
template to this patch. Can you please fixup during application? Or
should I resend?

Best regards
Uwe

--7kbjgzofywrlliaa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmcgj5YACgkQj4D7WH0S
/k4JfAgAk0ilD2VEwpxPZ6t8Xw0vaeBX3ngCt2/gxhe3BPzzNZrjjZWzY7VrTXxg
57G/WT6BEaohKt/VJFIv7H8TS7vOefoOsBNGxXzBLMw8xhwPZxxn1NSNRAzqP0ub
ExIJVQA2eNsbmVeLeB6BcoW816LGMnKE6Y4SNssWiL+TOFEJhajkOD4fLsq05DNV
aQd3pTmsSE2rIK635sUeIPVjxUda7D0kqQcGfRzP4Q///QE03KqHim1qTXUMzACf
Rg1ars/UWnE6yWQvB943QWi0zmsalwwk++RgO+hFL8ihbt+mKWgSZApxDKqy0EOT
dA2K5zE3EqheQRv1e30aLP1MRitIUw==
=nFP8
-----END PGP SIGNATURE-----

--7kbjgzofywrlliaa--

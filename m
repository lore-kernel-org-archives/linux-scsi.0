Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFDC1F4264
	for <linux-scsi@vger.kernel.org>; Tue,  4 Mar 2025 05:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741065163; cv=none; b=fKh7U9RqnaQXfz2kG5zF1KSdp15Df1sZ+X9j8fvlBkkUXwe5I0mkaO3tvePXienXd+Cjwhdkv9I9i3/1+s4rFA7MP5XGIeYa0Fgu9mOYyNupDpMtg9RSus8NKQlHqQm65GtslSP1yJnqmlFidR4Aq6fhllu7HEOOv9m+qXh4wHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741065163; c=relaxed/simple;
	bh=UqUkulJfTVPYICuXTQxco+AaAjH3mu1LKhMq3BX2eug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qp336PQS9s+sg8+n4MFThgawhRJw+xGqi++c3DMFQ836s8qfqpDU2imRRZ8JHkB+Ohw+e+hJvae8FVfOksw2gcsHbL9Fnqzmqpvh7L5U08s3KUVc40F0Tz753S0YO5VVGKFR6lo7DhsnoF/rXBI43TxvLJt0oqn1nS4vkgLYJkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=UxX88En5; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="UxX88En5"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-390e702d481so2261011f8f.1
        for <linux-scsi@vger.kernel.org>; Mon, 03 Mar 2025 21:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1741065159; x=1741669959; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VGDcVLShV6h0jC9uhBpDDw55f7EzHOwouXG7Rkj3oio=;
        b=UxX88En5/JVC86Bfv+hP+AzyCvDLAMmLuWZVx5830AmfOoC/Pvb08otHAfaqzRxdj0
         XULFwsV4smVtwixD3vdSL7if3ZgzkHEWHsJJCBrREivybn7S0d8rlxFEZBlcmrnT8w4+
         u/KhdFqZqs2Np0EbwyqD2N3Hi2zRjtuGrDxu6w/UbzAPojSjnSJ/zEVWjVRpS0ZVH7IK
         Wo3NnUyJbdz+9a4NNh+KiKvHIGyis0l9FVl9K7nhPugYFxf5VslojmJmxS4dDYvhjlKG
         +6dzeLrrd2A2UCMpj54hCi9mxrGtRo0nUJAvPGFclpl9qBNVehmQdaOsgT07vrdul5Fu
         zXAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741065159; x=1741669959;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VGDcVLShV6h0jC9uhBpDDw55f7EzHOwouXG7Rkj3oio=;
        b=ev3LztyUyKsJNYSxv1Ob6VD9kvJq119qn+pijPANWt/5yWyf1G+D7Z+oa2x6iX52KA
         EK6zKJffJYj9OvyrGLz4WqR7osCTPv4b18l8YVsA2vJLBEwFIjNjb5y1SpFRreMhjZVN
         xdNNj1fd5RiFhpeE/tM52QrJHHPv6+Ijn8tetxvUukJke0DSJSF28BDAxgGuY6kLQtgn
         67kVkVGzQ/PmyytXXJZDUR8xzwsAJ3Tw2H1Y/+p7oFz8ydgC7Hwjs4lIbqoj9DhKXwIG
         ylyaZ1+i2HuSAvxEt6LBEujNabaZO1rAimTAvHemaXPEA31/eUYxxUk098JkILTi5j79
         qfdg==
X-Forwarded-Encrypted: i=1; AJvYcCXNI3b0I+kaQHvR3xnXUhKfzEdzD4EuRXWHQlrbEClfkDrNo/hdEbnLAFLOCw2CGW8sP/52qhluLdzm@vger.kernel.org
X-Gm-Message-State: AOJu0YywGJRtfaiJF1a48vjuozy0Sr5ZBem7QMy1VIlmlLZUGf3Kytqc
	mvnk0a3LjagLpQ5qnA/qolbJSSUz9n/v+cgxP2/kzutKHRFdAP32TVVHvAd3P+Q=
X-Gm-Gg: ASbGnct1OfOMQwl3CIwi8RLmd3H3D1iit06iZGLt9p5IiKwhei4/XrCVN0AQhrzzi+i
	rMlo4SJMYnuOD4H2KBcDjYXHk59JnbcgkJ2KkHlxFMrJiqCeojbDFcALqmY1iYfdP2Ao9LYdOgW
	5ZDprZ8w1VQjeiBqKDV6kbKC7pcwa0c6PC8+rMp6RiMPsE0bdD6UBnEKYU7tJL1slZUfHOA7o1P
	MhL1PFAQeI3bKWXcWt5byLaRkB2qTfA9g8VyIZN6iSWuhHs+Jx4ylBFwcedBaGDGgFPtYv0U17b
	9DzMAzDOJFsK00T05A1qfeMBuuWUNML3sHU2tcFwA/P90vxIsf+OKm2baVIbuPXFEImQ/lzonh6
	k530yZFFnXn8PiWI=
X-Google-Smtp-Source: AGHT+IHrd9PqX/DjlI9fj4DBpZmmZUNi2fJ1f/erG72uoIjwSjUT4MZjUG1DX4gjTr54ZGluOrADMQ==
X-Received: by 2002:a05:6000:2112:b0:38f:6149:9235 with SMTP id ffacd0b85a97d-390ec7cba70mr13509775f8f.16.1741065158423;
        Mon, 03 Mar 2025 21:12:38 -0800 (PST)
Received: from localhost (lfbn-nic-1-357-249.w90-116.abo.wanadoo.fr. [90.116.189.249])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e47b7dcfsm16679767f8f.55.2025.03.03.21.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 21:12:37 -0800 (PST)
Date: Tue, 4 Mar 2025 06:12:34 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Yihang Li <liyihang9@huawei.com>
Cc: Arnd Bergmann <arnd@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Arnd Bergmann <arnd@arndb.de>, Damien Le Moal <dlemoal@kernel.org>, 
	John Garry <john.g.garry@oracle.com>, Bart Van Assche <bvanassche@acm.org>, 
	Jason Yan <yanaijie@huawei.com>, Igor Pylypiv <ipylypiv@google.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: hisi: remove incorrect ACPI_PTR annotations
Message-ID: <h7oh3uhuvmulmqkxi5x73bnkmgkodjxemabiqwkrqu3jmbxu2e@p2pmhpxh6nxl>
References: <20250225163637.4169300-1-arnd@kernel.org>
 <49419ea6-5535-3612-c1c4-5ac58f2bc012@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3hem4h7lf6bcgapu"
Content-Disposition: inline
In-Reply-To: <49419ea6-5535-3612-c1c4-5ac58f2bc012@huawei.com>


--3hem4h7lf6bcgapu
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] scsi: hisi: remove incorrect ACPI_PTR annotations
MIME-Version: 1.0

Hello,

On Wed, Feb 26, 2025 at 11:23:18AM +0800, Yihang Li wrote:
> On 2025/2/26 0:36, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >=20
> > Building with W=3D1 shows a warning about sas_v2_acpi_match being unuse=
d when
> > CONFIG_OF is disabled:
> >=20
> >     drivers/scsi/hisi_sas/hisi_sas_v2_hw.c:3635:36: error: unused varia=
ble 'sas_v2_acpi_match' [-Werror,-Wunused-const-variable]
> >=20
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>=20
> Looks good. So Reviewed-by: Yihang Li <liyihang9@huawei.com>

If you put your Reviewed-by tag in a separate line, the tooling that
most maintainers use pick it up automatically. Martin applied your patch
(currently as commit 7a9c0476d4073e742f474e71feeef4f54add4bc9 in
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git 6.15/scsi-stag=
ing
) indeed without your tag.

Best regards
Uwe

--3hem4h7lf6bcgapu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmfGi8AACgkQj4D7WH0S
/k6uTwf/bL2OxbnKrLPCyCJoJ83Z//yLDsboI8SAvxeHxQEkwAj81Xuyp2fdSEnk
M9idgLnnXAh4RE3Xt0OUGm7wpC6s6+tfLQQzgS1GcSm8Zo2JSXtjR12T4FRx2tLK
IxVnJ+ALuaEtgPV5aitknIwsEds9QNKZz4BIrxQ7YRD+Li4U7gJ4iavzRk35WK5t
rA6b2v3g3qJAO9Oe4IPGh0TIjyc28J6ALo4U0IA0C5DwNB+JcyGeLGc1ZkApJxot
xLlQTlI0jZtNCxn006Q39TcWIwjb28zp73JCuWSg7nSQddF80oN54kRrRRq4SmSh
Hx1QG/MpSok55aMOI+2+Nv90RuCn8w==
=5tCd
-----END PGP SIGNATURE-----

--3hem4h7lf6bcgapu--

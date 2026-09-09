Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E81957D21A
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 14:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963638; cv=none; b=Upxbz+jxDVoveFVO5mUz7i46kU4z7XmdshuTWTPEERwySvBxKHPRl266sza80Qv5mm2XFsoMGOhIZ/kr8efRa7e9UUQn2a1loW/PxIDykw53NhXW19cyVcPUKwjbU5apFAzk1t5JiVv8UquxDvaB2dT0oXQkC5YQe5Kdb5WbQ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963638; c=relaxed/simple;
	bh=f9Y6CM5pe3HK3EjR5tDWDt1T5CXFfS0AlY2DyqM0SwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bk0LCnMeIpoiYzDhO6C4exVoOgX9NQUgVcPFxQ0gLNh87pfxvw6cH4jdnZxoAYUz85kbGgB0zCeaaBwzjMKtfR8BDXqwcoZhONrmXwlufcsFnAcClyLK+vJrTxFCLakKZ9Eygat2FUzTAkxEZs/uXGDR1AVU/Ir19Mx0Z9n4gj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=d7wRufA4; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="d7wRufA4"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49b96837ca3so46513285e9.3
        for <linux-scsi@vger.kernel.org>; Wed, 09 Sep 2026 07:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1788963634; x=1789568434; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WwLHQQMSnh/KCTvcN5PJ4rnq4frOJyb3C+XPlurt7uw=;
        b=d7wRufA4TdjMqrq4UJD19dzGMMgG0Vt66cJEVwnA/I5KMXr75RyL1Xxoz0w9CIGaRH
         MuExlzuhWWuG+3XovFiKw23Hl6ZweHzMbQGOo/JM2JGlkFaumrCG8iYrQJnXc4c2R2wU
         GvV233mv+TtMP8ipwo/H60MsEVOMaKN1+pR0BY01GI3moRPYoTUzyJPsENN7tH9H96wU
         Alr1GpH9vvGZACRFW0k9L/I0w1679ZXKx6yxPECvRDvuH3xStudW9zScucIuyKaZHcCz
         zQAbj2ZY2Lr3dRxvTQXiPm69kBsZu449uYPfX/9q7ygI1RVjVSvYdA3Dv3Ko1gAmhRzI
         Y9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788963634; x=1789568434;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WwLHQQMSnh/KCTvcN5PJ4rnq4frOJyb3C+XPlurt7uw=;
        b=erK3xNij23xre46bDPY4je/gSrblem0iORivb0oNBJSMZua1frSwz9sHC41//hUqX4
         03dzwS+NMFc4Qzh6uJkPBOjU9POwdpUL3fObwOVtfaHgIY32QOvj+zjdi2+EIfa+ttb3
         aJ5Xo5Iwn0CiEffDmrs+MfnxOSkMoFSuslH4lcorVN7eUPqI39/a9tMi8mUpXktzmYFc
         Cs5IRqJ2OWARIF/wXKjzCSKwlQzOQQJWCqbC/Y+Pzp3sU5x2dieHAHZeN4cNuWiaXXAS
         FBlqpuHkdaQfFf9JY73FJwgCVCpNwp2/xGbrmRTcpXhx4b4WKPVB5anDYxI+1lV+Cl+4
         355A==
X-Forwarded-Encrypted: i=1; AKwUvBxx/VZH8TGRYvI29JNmqyMEnMzSUchwCADckcV3Tw7xjsD2sStgyik4IbCDyjHj9hmHX4SU9OPas7zK@vger.kernel.org
X-Gm-Message-State: AFuF++nIqg+SsiajwSM3i/1c4PWBdjf808Tt2GwXttA0zqV6b3wRjV6N
	QDS5BrH5UdfguLR2oYksILECflSjROB7dH4EkltVaul2XmsTS/9MbiqiTlXeEbmXkmI=
X-Gm-Gg: AYBFou0Iu/57YHL8o9pN2nK/ykIb313ZoH6fy47mkilX4oRayCc/LNUHab23khVlE87
	irV7rn3+clKHmM5HRNIZ1rSXp82z0ZL9o8H98+fl7jcHuOAPIAz7dmOfLGItLrailpoT0WfSgjh
	Fub9esJ62JmDY/MfwjGvHA5Sczgh+BUiPObIU3FQJ7RV3LjjqBXXOuJ43c/5wW4WSO0sye464ON
	qvS1FcqrVzgMk3J/GowBIcIo0eHBw/BvLeifwYuuCscMr8LeG8N0EvV35x4QFhqxjHeQcvJg+nf
	SNSywJlwFdyQVTSJD+bz6ulh3lfttKbsF/TEYhMH01N4AsScaGqyEpMQ+GT3KTNRgHMz0/HAV/B
	3axiO7WBs53FbwHyPoHlMyr7yjGUu/1wKOVDPpTQgEIxUV+DYeyVpC8Hz/QbzPmjnkwVmc14AVa
	WUkPegxBDg9HRFnHBgT4Y9Y37lvjX91JUD+hQSkeWr22GKqcIlfGHkKiF4FAMb1XJdh+qDW4Qli
	Gmc+J6Q5sD9693J55EO+Giv5NkJxroF3R3uW+4CzIj9G/j9GY6lIKuCKnxDjw9NBsZ/p4Lu
X-Received: by 2002:a05:600c:190d:b0:49d:72d:9ba3 with SMTP id 5b1f17b1804b1-49d072d9bccmr267545975e9.14.1788963634483;
        Wed, 09 Sep 2026 07:20:34 -0700 (PDT)
Received: from localhost (p200300f65f19a9042846e5e8b4b91e99.dip0.t-ipconnect.de. [2003:f6:5f19:a904:2846:e5e8:b4b9:1e99])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-485885bfe14sm44695307f8f.35.2026.09.09.07.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 07:20:31 -0700 (PDT)
Date: Wed, 9 Sep 2026 16:20:28 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Kartik Rajput <kkartik@nvidia.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Thierry Reding <thierry.reding@kernel.org>, 
	Jonathan Hunter <jonathanh@nvidia.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Thierry Reding <treding@nvidia.com>, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] scsi: ufs: tegra: Add Tegra264 UFS host controller
 driver
Message-ID: <aqFqhNA50674GtPo@monoceros>
References: <20260909-tegra264-ufs-v1-0-e4a9831702a0@nvidia.com>
 <20260909-tegra264-ufs-v1-4-e4a9831702a0@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bo2cqm6hlrzg5q2v"
Content-Disposition: inline
In-Reply-To: <20260909-tegra264-ufs-v1-4-e4a9831702a0@nvidia.com>


--bo2cqm6hlrzg5q2v
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH 4/4] scsi: ufs: tegra: Add Tegra264 UFS host controller
 driver
MIME-Version: 1.0

Hello,

On Wed, Sep 09, 2026 at 04:11:22PM +0530, Kartik Rajput wrote:
> +#include <linux/bitfield.h>
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/mod_devicetable.h>

Please don't add new instances of includes for
<linux/mod_devicetable.h>.  Either rely on <linux/platform_device.h> to
provide of_device_id (my preferred way), or use <linux/device-id/of.h>
if you want full iwyu.

> +#include <linux/of.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/reset.h>
> [...]
> +static const struct of_device_id ufs_tegra_of_match[] = {
> +	{ .compatible = "nvidia,tegra264-ufs", },

No trailing comma before a } please

> +	{}

{ } please (i.e. a space between the braces)

> +};
> +MODULE_DEVICE_TABLE(of, ufs_tegra_of_match);

Best regards
Uwe

--bo2cqm6hlrzg5q2v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmqhayAACgkQj4D7WH0S
/k687wgArsy0qdFLf679KsDOewkgrobh46ihhNA7b7Crylg9MkryYaiwdB4Qlmjr
3zrv48WR9cTtOUTrHhr9UT/ALUmx3nvAey+m38JCRTyRc1oTnHq8/etl4TcZmW0e
pWh+Rh6NQr6+Eg8k/uKuVMWdJMBIbxVMYfUj9O0zp0++xEmWhskcXKtB1r0QzqYd
rruRMXw68tfK++ui6+jWZwZZLO8GkGC3fiHgrkOpxXJ4+aPDsfQB69M4LBb5T5I1
65NFieoF25WsAUm9WXBbAYZdEP5lC3Hyz4EpdOeYA/f3OARpaYqgTJYYznV+0bC6
oc0+HyZKufdUxpfaO5vmE+USw5UEPw==
=gTRf
-----END PGP SIGNATURE-----

--bo2cqm6hlrzg5q2v--

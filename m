Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20F386329
	for <linux-scsi@vger.kernel.org>; Sun,  6 Sep 2026 06:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788676156; cv=none; b=Pq6gBOCH7Li6X/RnN9QjrblEIZ33pmatVlvX5dDvI9g1XqGnnLAotBPMZEJKGtRkGNwQ94dTr0XAhj6KtvgQWJLDfH7ahB1zBmhk05jFe0nzmza1POg3UWoZsE2z3ftdQeN2QbS/3zQD4kD6fxB6ZvAk+euy8pktUMbnYAaeECg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788676156; c=relaxed/simple;
	bh=yLGNHsjzdS8jPFsNcYioR6RUcmjiiworjndzAs+9P1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mc+eXcU8qmkb5f/bfC9wC+um18TqCrjGghzUt3LTvNsVn/CVbAVYTxw3voa3lXHKb7z7c/JvnLqpHgYL4kZJDMARE2r+B7rSmO0aHPlaCx2dfA87PICWYl5xXTGS53jmmMdWRX+nRxNiLIBGEVVbJfNRFaCm5xBjgTvuzMb9yFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=l9E2pgbA; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="l9E2pgbA"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4843efcbdb2so1167841f8f.2
        for <linux-scsi@vger.kernel.org>; Sat, 05 Sep 2026 23:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1788676152; x=1789280952; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JRrwyh1GV38tMLqmo1DwCJhHJystogA1fhGBbH9cNao=;
        b=l9E2pgbAiRFoWuV+WIgzOkTyYO1fxrYcsyULu2pLfk3Z/hl9njsE3DjedqmGq/b7tT
         dEL0aO5hr1cvka6VNkzxicbb9L/bmagEyjb6F84hW8z0ly28lYF4GhMPTFiQvoQiAORY
         n6ACJWr/+H25FtaiwbpVdn3OT8iqsfW0gN6gvwiKP568RSeAbvIP+4lgJTzcrt9Qfh2P
         S1ruWVrghDZMMcMM2zXsG51ilaJ6pAW3TzoeuG59PF0XM3er+7E5/auOwNaqnoRK5uyL
         eC7g2j2wDV+i5mxj6Vhamkr4C9VSN3QvJQ4Jnf1TzwfxS7juh3gczz1kxDYnNi+8qNGp
         vmwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788676152; x=1789280952;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JRrwyh1GV38tMLqmo1DwCJhHJystogA1fhGBbH9cNao=;
        b=h15GcqmjVjJjFpTbu1lbcnxvGCvde2cqGJBgilk2sunxj712P4r1z8jtodcmt3ZKhj
         oWtg99snZq4q9M97O0pVMaDrZkMI4jgqTDplNL/8o1saU4kzTJ8Yi8zIbyl9NaTE4swA
         Oqf+cDWIXizFlgbW6BWBzd2ucYc+NtxrhaYJgoi7rW1AA6VewxiPqFGB/2stWL1PBDBf
         f6+M/d7+78Xw9YQtby3rbM67o3SF0MAvI22mTZ2jNm66Imo1WsZZbB31c9m2vXzJs209
         +i1YbPWR4UfmWvJ7ElTldAuNV00gzrmTXPmsm3n3VaYwgaMrIADDjSAl4Mt1atXSSEOx
         DHGg==
X-Forwarded-Encrypted: i=1; AKwUvBy+o7Z1nUho2mZ9JUoDvi6gwOBSBCzlnz+TRGG542KTWDtQOQGRC191e9oiJZX03ShpSoCX1iNIsaMA@vger.kernel.org
X-Gm-Message-State: AFuF++kCpusMZHaiRf9JP+us/1Txvw4lCBHDLzaYb+VPFgRBQNSnA6lY
	RWIAYaiP50CvD7aXKTCPaIFTcfvVjYZ7qL9V3snpvhpOhD1SS2xIKR8WJWYKHa6EDGI=
X-Gm-Gg: AYBFou1LZprvE48ngJdodrsPVjf9WEyoRcw1ITFWu6P//7CdwiaNCCvUXAJGmI0EV7l
	3o7s6k0hySJ0UTZ1uIB23jT2LB0CAK7ZkSwuanI9BiZFnzyZ+8svFFCpuoD1aUDJ356ln78fRkE
	/f4UaU65tkVFfsS7fB55wEKVl+WJNUrNb06WJ36O8nYcD2AGOixtNluzQmUhekCrEGR5Q7HKHjJ
	Kg1uVdxYcU7aHcW2GSZr6puKDcN1afTNKvUPIkYGcwuFD5Wiu0xIMXVzev9Ej1tr8R0EtsQqwXi
	lBeZnoYZsx9Qb//SDjdLM/XhEausjPQMMxpIT/qK4rKO5ATJhBnxqAhpt7epshFv2Pc4nY9zjxM
	A3sYKRNDVyXh2SBoz3yu/5P9M+DV7XHltZlXVZ9t2iXLN315zN9VU/k8twh/6MY9Ae5WjtYvUCY
	4hqVMdZHnvdaQ4lhT2I8lNaalxkMWw1+VGHUZuR0i0lrP1LzdDyqOWQg822KcUNWt0F9PzwSK1c
	XcO
X-Received: by 2002:a5d:5e90:0:b0:485:8a47:5b90 with SMTP id ffacd0b85a97d-4858a475da2mr14160635f8f.45.1788676151912;
        Sat, 05 Sep 2026 23:29:11 -0700 (PDT)
Received: from localhost ([2a02:8071:56d1:2de0:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4858bc74298sm16329876f8f.6.2026.09.05.23.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 23:29:11 -0700 (PDT)
Date: Sun, 6 Sep 2026 08:29:09 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>
Subject: Re: [PATCH] zorro: use module_driver() to avoid repeated boilerplate
 code
Message-ID: <ap0Hpa5BNKgMg9rO@monoceros>
References: <20260906034037.81379-1-enelsonmoore@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="j5xthm2rjqmnrlry"
Content-Disposition: inline
In-Reply-To: <20260906034037.81379-1-enelsonmoore@gmail.com>


--j5xthm2rjqmnrlry
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] zorro: use module_driver() to avoid repeated boilerplate
 code
MIME-Version: 1.0

On Sat, Sep 05, 2026 at 08:40:19PM -0700, Ethan Nelson-Moore wrote:
> Many Zorro drivers have module_init and module_exit functions that only
> call zorro_register_driver() and zorro_unregister_driver(). The
> module_driver() macro automatically generates these functions given the
> register and unregister functions. Switch to it to simplify the code.
>=20
> Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
> ---
>  drivers/net/ethernet/8390/hydra.c     | 13 +------------
>  drivers/net/ethernet/8390/zorro8390.c | 13 +------------
>  drivers/net/ethernet/amd/a2065.c      | 13 +------------
>  drivers/net/ethernet/amd/ariadne.c    | 13 +------------
>  drivers/scsi/a2091.c                  | 12 +-----------
>  drivers/scsi/gvp11.c                  | 12 +-----------
>  drivers/scsi/zorro7xx.c               | 13 +------------
>  drivers/scsi/zorro_esp.c              | 13 +------------
>  8 files changed, 8 insertions(+), 94 deletions(-)


>=20
> diff --git a/drivers/net/ethernet/8390/hydra.c b/drivers/net/ethernet/839=
0/hydra.c
> index 9a59915436d2..2edf97e500df 100644
> --- a/drivers/net/ethernet/8390/hydra.c
> +++ b/drivers/net/ethernet/8390/hydra.c
> @@ -257,18 +257,7 @@ static void hydra_remove_one(struct zorro_dev *z)
>      free_netdev(dev);
>  }
> =20
> -static int __init hydra_init_module(void)
> -{
> -    return zorro_register_driver(&hydra_driver);
> -}
> -
> -static void __exit hydra_cleanup_module(void)
> -{
> -    zorro_unregister_driver(&hydra_driver);
> -}
> -
> -module_init(hydra_init_module);
> -module_exit(hydra_cleanup_module);
> +module_driver(hydra_driver, zorro_register_driver, zorro_unregister_driv=
er);

If there was

#define module_zorro_driver(__platform_driver) \
        module_driver(__platform_driver, zorro_register_driver, zorro_unreg=
ister_driver)

this could be reduced to just

+module_zorro_driver(hydra_driver);

=2E

With or without that addition I like the patch.

Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@baylibre.com>

Best regards
Uwe

--j5xthm2rjqmnrlry
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmqdCDIACgkQj4D7WH0S
/k5Q+wgAqaAciwF0YQfLcSh7llXTFmwTcZrnjuYaboZmPy6Bde2NcpAvROn5uu/V
AhrAf39Mz9RPYp5G+tY7+lWRdGAt6yuufobAtfhCkTA6hYraHFIpQa1dAbX92wL7
jdwdxzpV3TEGPtCbMgcraK0U3PC5H2mVVNSo18Eco+d7KaG8FQerkp0SBR0ro1G/
mHXkCiL0bBcO8GAJcao4XKTEpQLnfYzdgbRCYvFvo6umMcgTgykBpOTpO9XreNNj
NhQQzaQakXTDexeTzkFKhIOiMsrWHEeKW5Dkf+RW7wyy2By3Swu8haih6zzcrlSY
M/zV59jEuiJGxiuJ2HXuATz7myHCGg==
=AWHm
-----END PGP SIGNATURE-----

--j5xthm2rjqmnrlry--

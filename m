Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794307997;
	b=4JN9ZUvKAJYYsYZPH7yY+rEE2b4aj0ko8Ly+wJkjB0AzatZmqBJzZ2aelLmlQXM6ZQkn
	 +jTY79/KLAM1wRYy5GNwT+p3Kp/kHvLjPyfZ8hdrzeTG7TKBDIuAJv/X6oiCZP0/P2RV1
	 uQ5rsbSdiHzFxQ8amOosMV3D4w+bl/zWZjduqcvCmkMImywZebzwuHdim0rQrLXItcSei
	 /t227uGXgHvYZHkKQT7H24qnPWzwjH5flpf88FlV12l+49DsD6PgFV83JvPRSPUGy5FOV
	 dNCUZomS9tgPpoiOwxYR5LQADiVvbTh0K9SViVZm50OS0C17DsptPeTQjWOuDX29oVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794307997;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=XvZzxhH1tJfaFa9xLjcAjvvdEgxtHDpQlkyGqk3MqEo=;
	b=iT+F8zSGAhJ4h5R0twvUepSjjEbRAWBuHcMUB+PnTWHvGgrOu5yh/PLSvrqHsj0nq6Wk
	 3i9pxRPmSoIS+mi5xWNhib5CdmVTrWMHUOSMwvCvfZ94yc6jB2Mem8ekV+n+mzmOwAse/
	 tfWmB0KNAnHtxnhI95gHY5O0TsPAWmkUq7p/ib6GYgOqDactKkQhnF5vHotHOXBc0lNzM
	 pHSSXjTW5/8XiWBuMWBPWEMHbTWYQRjMutYG16xjQ+H3GvbOX5G/iua3c4whinC/Xc37q
	 toaIIYvSmM+5uFDktxXTrqjiYqjUOV8Ezelpt9KjspGNsUdvGIRv9vek7s2YqY3v7Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a7rpRKie;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE87B606A31C;
	Tue, 10 Nov 2026 10:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a7rpRKie
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1391F0089F;
	Tue, 10 Nov 2026 10:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794307996;
	bh=XvZzxhH1tJfaFa9xLjcAjvvdEgxtHDpQlkyGqk3MqEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a7rpRKieOLdLRCHlux/v2v3q1OPL379DSZCfBOKVMnMkNjBc7lUcTyI4IylD7zYmn
	 OXz9/qvSrCgKw/VX+neh3X8jFxLI9eGwlPc8cabK7Qu7QkbD3iMBsiNV5J8xNO8a1F
	 niHxvoFUalD8kHu7/XVXvJPPIdBD1A/K1rquiv9KEpA6M/LkSJvVnnF27IrHQYEzfH
	 gaeH+pHC6jtOt1Os9NchErQn8BIc5GhcWT5YSsorwQOdUdV1wmkVIH1QGDKpZFeA7D
	 RblFM7R/IUu4zj5K7TPeBIPY5Xfnfyr7RE3k1OCG1aTMAhVDgEO9w4rX+lZdeTGeL4
	 8tT+cbF61316A==
Date: Tue, 10 Nov 2026 11:53:10 +0100
From: Alejandro Colomar <alx+linux-hardening@kernel.org>
To: Mariia Nikitash <nikitash.mariiaw@gmail.com>
Cc: mkp@kernel.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, morbo@google.com, 
	justinstitt@google.com, kees@kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: Replace strlcat() with snprintf()
Message-ID: <avL2aQq9oSun177S@devuan>
References: <20261110093137.37744-1-nikitash.mariiaw@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="c5b4bwq2tilhrcqr"
Content-Disposition: inline
In-Reply-To: <20261110093137.37744-1-nikitash.mariiaw@gmail.com>


--c5b4bwq2tilhrcqr
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx+linux-hardening@kernel.org>
To: Mariia Nikitash <nikitash.mariiaw@gmail.com>
Cc: mkp@kernel.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, morbo@google.com, 
	justinstitt@google.com, kees@kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: Replace strlcat() with snprintf()
Message-ID: <avL2aQq9oSun177S@devuan>
References: <20261110093137.37744-1-nikitash.mariiaw@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20261110093137.37744-1-nikitash.mariiaw@gmail.com>

Hi Mariia,

> Date: 2026-11-10 01:31:37-0800
> From: Mariia Nikitash <nikitash.mariiaw@gmail.com>
>
> In preparation for removing the deprecated strlcat() API[1], replace
> the strlcat() call with snprintf() to construct the AuthMethod value
> directly from param->value.
>=20
> Since buf1 contains unmodified copy of param->value, formatting
> original value and suffix together preserves the NUL-terminated
> output, including partial or omitted ",None" suffixes when the
> 256-byte buffer is too small.
>=20
> Link: https://github.com/KSPP/linux/issues/370 [1]
> Signed-off-by: Mariia Nikitash <nikitash.mariiaw@gmail.com>
> ---
>  drivers/target/iscsi/iscsi_target_tpg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/isc=
si/iscsi_target_tpg.c
> index 99772364c88e..aad82a37538f 100644
> --- a/drivers/target/iscsi/iscsi_target_tpg.c
> +++ b/drivers/target/iscsi/iscsi_target_tpg.c
> @@ -624,7 +624,7 @@ int iscsit_ta_authentication(struct iscsi_portal_grou=
p *tpg, u32 authentication)
>  		none =3D strstr(buf1, NONE);
>  		if (none)
>  			goto out;
> -		strlcat(buf1, "," NONE, sizeof(buf1));
> +		snprintf(buf1, sizeof(buf1), "%s," NONE, param->value);

This rewrites the string written a few lines above.  It seems rather
confusing.  I very much prefer strlcat(3) here.  Of course, an
strscpy_at() would be better, but snprintf(3) seems wrong.

For other readers, here's the same diff with some more context:

	@@ -622,11 +622,11 @@ int iscsit_ta_authentication(struct iscsi_portal_gro=
up *tpg, u32 authentication)
		} else {
			snprintf(buf1, sizeof(buf1), "%s", param->value);
			none =3D strstr(buf1, NONE);
			if (none)
				goto out;
	-               strlcat(buf1, "," NONE, sizeof(buf1));
	+               snprintf(buf1, sizeof(buf1), "%s," NONE, param->value);
			if (iscsi_update_param_value(param, buf1) < 0)
				return -EINVAL;
		}
	=20
	 out:

So far, NAK by me.


Have a lovely day!
Alex

>  		if (iscsi_update_param_value(param, buf1) < 0)
>  			return -EINVAL;
>  	}
> --=20
> 2.43.0
>=20
>=20

--=20
<https://www.alejandro-colomar.es>

--c5b4bwq2tilhrcqr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmry95AACgkQ64mZXMKQ
wqnUbA/+Ia9sO6kZ0dpmQ4E0viH2C2QAzQRKSibUxXeS1zti2iFaedYh/Vw3Utht
a6fXGGjGweK3rKojZBnHOxrUt4w3GE6PWyM2dIocDFMEJ2cZhDF3JCHWR3rrhQT/
wrDBL0yyD1o6DvVr/aDhbRsqsO1r2DZVnplhlQVn88IK+T/iZEBWLwIfVsHqJK0S
zLEvcoxI2POaQgmLZy6N+KBQhNVP3/4z/NKwB6DYbh85HfwS6vYQHnyG05d5rQNg
n82yfjdWGGvr0mmm2Mxqw7rzkfHfS2xosuQlmuTpq+738HRQvYAHqJMBByjFI6Dz
yBgLfHLOnMSDrmmKJRZJiGg7GT3KS9ei++hs5g9rvmtpKVMO9UPv1pRIwMMXlGBd
FGl98AGVIR2qU1/fSiQ0hKzFXXHLtPBxr0nAre19m5A4nSmbtJn8s7/l+a1N9cZD
mFXX12060/dsfShGnvrpK/VghnJ4SJ4SOi2xhTghon8e5VVy7lWWygR5oWbMd36g
5Ow91ClNM3X5MijgCtGXTHhQpJGH6J0be7qD9uLGNZ5G9wZyeCvQ82f1wMnVwkUV
0Xt7JYD7px1uV3Y/xROSBBA4jKUZE02jDVXjKpiTOPGlJvmYTJZYX/rFYF8HBiBU
/9OvzwMJS6qrAZ27UkPIORHOyryskiXJ147e5Wa2m1R16eEcHr8=
=lpk1
-----END PGP SIGNATURE-----

--c5b4bwq2tilhrcqr--

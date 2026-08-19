Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741663C0603
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 03:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787110430; cv=none; b=sll65oXRACW6klVa/5aYLq2cCcLCr18ADLcQJslgnrJ3zIPwFwb/huXTaSGHbHGUCO9gEqit2c7tUgnHfsqtoK6E67FJFjuKNHkmcqeqcsdpwMfnOwEyN0hEJlSKSj3q3jbIe9k2GPPYVCYr9hJuTyj7Z5dtwzfREUqFC8POuSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787110430; c=relaxed/simple;
	bh=lj2R2UN6wBrNfPvh2YPgcFNiCfb4wBZtD/g0SgUBAYg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VOgDmiZeojBNWzKBLFKJmWb9Uspgs6eJ01SeISSepy9x0T/Qb87D2k8jJFfQBEdLD+HpKZ0CdqnnfnKSVgBaSHOodd6bEe36glHX4URwjNnlWqizjPjJ/c1i2y9Y7D1phy+mni1hhpIz7nS5vl9EBLWjvjh7GxvyR6Q+hsN4kh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nL3P/ZPw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nL3P/ZPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A311F000E9;
	Wed, 19 Aug 2026 03:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787110429;
	bh=gNk5bdqpdVNn5gUK2PHOuRwFaJSAHx8V0pA75yZZsuw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nL3P/ZPw+zFnBUjd0GBUv++H21o+HfNWgD07ZF75EBPZrFhpH43o/rJ5Mvc6i0oHL
	 29Fl60CEzUQRcq4yw21OMGDBJx5cK30JYsSJl0AsPP4AKn8LHuSYD4f/eazjrXCRq4
	 lnwxgt95BKt27iDoN6kedzUQUPMBZk5Bmom60gGEoD2fQgcFOxyjgKAI35QcWgPSGY
	 ghQTsACasqAtS1OOrzdL143MRtQwm6PSF7Z22CI7be4/EtdZtMNf9dN9bA+19aU4ry
	 hXm8B6GZDz8Zwc8S5AjjGCUiGea/tJUFivbj7OEH2/yP1LyOjm4inziOSymhvqbUTc
	 PKD/72i2N/orw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/3] scsi: libsas: Handle errors in
 sas_ex_add_parent_port()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eshaan Deshmukh" <eshaan2031@icloud.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260819032321.493746-2-eshaan2031@icloud.com>
References: <20260819032321.493746-1-eshaan2031@icloud.com>
 <20260819032321.493746-2-eshaan2031@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 19 Aug 2026 03:33:48 +0000
Message-Id: <20260819033348.E4A311F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Pre-existing lack of error handling causes a kernel panic on port =
allocation or addition failure during edge/fanout expander discovery.
--

--- Patch [1]: [PATCH v4 1/3] scsi: libsas: Handle errors in sas_ex_add_par=
ent_port() ---
commit bc14b1e6a1d6e30259a7082de185251e075a15fc
Author: Eshaan Deshmukh <eshaan2031@icloud.com>

    scsi: libsas: Handle errors in sas_ex_add_parent_port()

This commit changes sas_ex_add_parent_port() to properly handle failures fr=
om
sas_port_alloc() and sas_port_add() by returning error codes rather than us=
ing
BUG_ON(). It also updates sas_ex_discover_dev() to check and return these n=
ew
error codes.

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index f471ab464a78b..f1a1417b09819 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -33,19 +33,29 @@ static void sas_port_add_ex_phy(struct sas_port *port=
, struct ex_phy *ex_phy)
>  	ex_phy->phy_state =3D PHY_DEVICE_DISCOVERED;
>  }
> =20
> -static void sas_ex_add_parent_port(struct domain_device *dev, int phy_id)
> +static int sas_ex_add_parent_port(struct domain_device *dev, int phy_id)
>  {
>  	struct expander_device *ex =3D &dev->ex_dev;
>  	struct ex_phy *ex_phy =3D &ex->ex_phy[phy_id];
> +	int error;
> =20
>  	if (!ex->parent_port) {
>  		ex->parent_port =3D sas_port_alloc(&dev->rphy->dev, phy_id);
> -		/* FIXME: error handling */
> -		BUG_ON(!ex->parent_port);
> -		BUG_ON(sas_port_add(ex->parent_port));
> +		if (!ex->parent_port)
> +			return -ENOMEM;
> +
> +		error =3D sas_port_add(ex->parent_port);
> +		if (error) {
> +			sas_port_free(ex->parent_port);
> +			ex->parent_port =3D NULL;
> +			return error;
> +		}
> +
>  		sas_port_mark_backlink(ex->parent_port);
>  	}
>  	sas_port_add_ex_phy(ex->parent_port, ex_phy);
> +
> +	return 0;
>  }

[Severity: High]
This isn't a bug introduced by this patch, but since this patch updates the
error handling for sas_port_alloc() and sas_port_add(), could the identical
pattern remaining in sas_ex_discover_expander() be addressed as well?

drivers/scsi/libsas/sas_expander.c:sas_ex_discover_expander() {
    ...
	child =3D sas_alloc_device();
	if (!child)
		return NULL;

	phy->port =3D sas_port_alloc(&parent->rphy->dev, phy_id);
	/* FIXME: better error handling */
	BUG_ON(sas_port_add(phy->port) !=3D 0);
    ...
}

If sas_port_alloc() fails under memory pressure during edge or fanout expan=
der
discovery, it returns a NULL pointer. This NULL pointer is directly passed =
to
sas_port_add(), leading to a NULL pointer dereference and a kernel panic.
Additionally, if sas_port_add() fails, the BUG_ON() triggers a kernel panic=
.=20

Would it make sense to implement graceful error handling here as well inste=
ad
of crashing the system?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260819032321.4937=
46-1-eshaan2031@icloud.com?part=3D1

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84E01F4631
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 20:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786564832; cv=none; b=efkl8FSQv+w0FOLiAONATU1jD4Upkn3JXFzhR27NNxqF0TPTl2EPJWhYAT6v61CjNaU0NLnflxWvwu40ar5acU8Y0QqgapIWvoKjDJSkvCpkhs+40Gu0PBG5f2JmV8OC2Wy69sl23nqHYCNd9ETgJFs0gjAKwFy1vQ0VUds7g8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786564832; c=relaxed/simple;
	bh=mCjzKv22Jz2tslhJ3a8LIZ2TdWvhBKlasoCteWaO3YQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uV5JVUP2/tcs0fpobw2DKTR2Ke1ri6o+tnCDIBSef4y3xa7/T8bhN7pDPX8B7ykTU07eMR7eMeXMiwU0q6kdLeEtlE6U/gF7Zaki+CU93q6XkhM8B9By6MF821RZXWFr+pDX+4I4CN+piv6bczy4PfmIw9Avs/aaPWZE5UVwSl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jSLagJyB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jSLagJyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388171F000E9;
	Wed, 12 Aug 2026 20:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786564831;
	bh=kMGYvTWnlyGi5voHRq0yVi/vk6Wr4ieGx2C9+SBpu0g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jSLagJyBJbivzCTe+cmgObxTRgg4MJF7iYJhaN+BWrw/+t86WnS4vvCZCkBRjtMou
	 CJsyCZR5NsDXwzpld2z5EYSwYD+rAqJaxLggetSMik20e/bi71D9dgxvuEJlBfUN4N
	 D1+lbyDTyi8PmqTKU+818C9RPZEFQYz2xunVaYb94qKhO0080F7YQvbPIDnK+UTYFg
	 dI6NMSJtQ0d2GkuE/c/TNDv5zufBJDOAsf0d+V5fIFyFY/eFNHkjw3iYCeEzg8m+Bq
	 XNXBjdifA64acbEW3zX5vD+Rhs3NIfJStV8mcC9nE/E7bwwfdDu34g4sy1X8wk2tP7
	 vw6Ecq0aJ4sJg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/3] scsi: libsas: Handle errors in
 sas_ex_add_parent_port()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eshaan Deshmukh" <eshaan2031@icloud.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812194808.576586-2-eshaan2031@icloud.com>
References: <20260812194808.576586-1-eshaan2031@icloud.com>
 <20260812194808.576586-2-eshaan2031@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 20:00:30 +0000
Message-Id: <20260812200031.388171F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unchecked return value of `sas_port_alloc()` in `sas_ex_discover_e=
xpander()` leads to a NULL pointer dereference and kernel panic.
--

--- Patch [1]: [PATCH v3 1/3] scsi: libsas: Handle errors in sas_ex_add_par=
ent_port() ---
commit b53b16ccede6280045a463721b18531d23ff3fb8
Author: Eshaan Deshmukh <eshaan2031@icloud.com>

scsi: libsas: Handle errors in sas_ex_add_parent_port()

This patch changes sas_ex_add_parent_port() to return error codes instead
of using BUG_ON() when sas_port_alloc() or sas_port_add() fail. It also
updates sas_ex_discover_dev() to handle these returned errors.

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

[Severity: High]
This is a pre-existing issue, but since this patch fixes the missing error
handling here, does a similar problem exist in sas_ex_discover_expander()
in drivers/scsi/libsas/sas_expander.c?

It looks like sas_port_alloc() is called and its result is passed directly =
to
sas_port_add() without a NULL check:

    phy->port =3D sas_port_alloc(&parent->rphy->dev, phy_id);
    /* FIXME: better error handling */
    BUG_ON(sas_port_add(phy->port) !=3D 0);

If sas_port_alloc() fails due to memory exhaustion and returns NULL, would
passing this NULL pointer to sas_port_add() immediately dereference it while
checking list_empty(&port->phy_list), resulting in a kernel panic?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812194808.5765=
86-1-eshaan2031@icloud.com?part=3D1

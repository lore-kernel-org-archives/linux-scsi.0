Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB0A39A805;
	Tue, 24 Feb 2026 12:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771937320; cv=none; b=nS7yK77TNU+30ZMUNfmlBRY9cro38h4Yfqnhnwu1SiQp+QpepIx3TmENGYDw3tvUsh4po3KJj3alhEtKE4aA47llq3qQxa6OzdAeVDDKkYKwQsbBFkJLZL1DLVfA5sQUHAXGMJbfyAGdwQBMY49S4jhTuLi/a8o9Dlmw+7CMGd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771937320; c=relaxed/simple;
	bh=NE+kk/QuY4v7944+aH1+qD4q77+1CSzALEv0f+0og4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kw1T/fSGy32i0oTvVYxsdhGvQBQUrTrpNrnBFqeulODGoKlR7wvE3FYdntz7ifcgXNCjhBiad8+bupSWHfN5ESf2+hAEdhRDFUofpkpIYduFBla1lJm6A8UV1+tQ5otwKxMKn98IrDd0YrhbD4XU+GuGvWOCajoTz1tPunXZ3bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mBESL7E+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mBESL7E+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53FFC116D0;
	Tue, 24 Feb 2026 12:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771937320;
	bh=NE+kk/QuY4v7944+aH1+qD4q77+1CSzALEv0f+0og4c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mBESL7E+Zs0Gxiat7NA52IJwqwX9UTl+sUtdsM93istQcGmDyU42b8wWUFoOXqSR3
	 uMTU6CQicOUGvblXr4EzyzzwDyfk0fFoHGwfT4KcAOojC0eHWDP3UYzbUpeOrxPIUK
	 iklwBVEOK2H0O5Tlp5Y0mI9FEFoppVK2vyolG+Eh5ghHp3mwWifTIUw+Icl+Y5pzML
	 bUWot/QqZP0L7k2Ku5bFG4cvRcXZOe/heIcchyAsZI43bM6uay22DDvETaOT0A65qN
	 i63RvyRAj5yNcz5zVL6D7OMFjaDMbHQplNzWY9GwvXpRs/8s9qlRV4EFzcp8Cj7kFL
	 xGyfkteOzy/Yg==
Date: Tue, 24 Feb 2026 12:48:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Wang =?utf-8?B?KOeOi+S/oeWPiyk=?= <peter.wang@mediatek.com>
Cc: "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	"robh@kernel.org" <robh@kernel.org>,
	Chunfeng Yun =?utf-8?B?KOS6keaYpeWzsCk=?= <Chunfeng.Yun@mediatek.com>,
	"kishon@kernel.org" <kishon@kernel.org>,
	"James.Bottomley@HansenPartnership.com" <James.Bottomley@hansenpartnership.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>,
	Chaotian Jing =?utf-8?B?KOS6leacneWkqSk=?= <Chaotian.Jing@mediatek.com>,
	"lgirdwood@gmail.com" <lgirdwood@gmail.com>,
	"nicolas.frattaroli@collabora.com" <nicolas.frattaroli@collabora.com>,
	"vkoul@kernel.org" <vkoul@kernel.org>,
	"krzk+dt@kernel.org" <krzk+dt@kernel.org>,
	"p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	"kernel@collabora.com" <kernel@collabora.com>
Subject: Re: [PATCH v7 10/23] scsi: ufs: mediatek: Handle misc host voltage
 regulators
Message-ID: <3f4920b2-4697-4897-bdca-65c9f02909d8@sirena.org.uk>
References: <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
 <20260216-mt8196-ufs-v7-10-b5f2907c6da7@collabora.com>
 <2c7c84a2df19624ba9f207fd3fee47a8bdd9d8dc.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1sApqFsS7KHCWKJU"
Content-Disposition: inline
In-Reply-To: <2c7c84a2df19624ba9f207fd3fee47a8bdd9d8dc.camel@mediatek.com>
X-Cookie: Obey all traffic laws.


--1sApqFsS7KHCWKJU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 24, 2026 at 12:38:50PM +0000, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=
=8F=8B) wrote:
> On Mon, 2026-02-16 at 14:37 +0100, Nicolas Frattaroli wrote:

> > +	if (data->num_reg_names) {
> > +		ret =3D devm_regulator_bulk_get_enable(dev, data-
> > >num_reg_names,
> > +						=C2=A0=C2=A0=C2=A0=C2=A0 data-
> > >reg_names);

> If these regulators are only acquired and enabled once,
> why not just set regulator-always-on in the device tree?

Drivers should request and enable any regulators they require, they
should not rely on boards happening to enable a supply for them.
Similarly the board should only impose constraints that come from the
system design, it should not assume that drivers will continue to behave
as they do.

--1sApqFsS7KHCWKJU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmdnh8ACgkQJNaLcl1U
h9DiTgf/fv4WLvjpgOLLYMYODnOOXRHQd1h3dBm6KtelA8k6J759K498iOyzjgnx
A7YslxQK3ou66JhdMdWlrqY+7QykL6rXbwLBoot6l+R+wFGAEb/lqn8wF9GwrqHv
Di47ihAw78UzoJNYds6DZnYWbxmXg/AJTGBLMpT2SEDHkQP9RZTzM+/vrFooaWFd
D9icpI4Px4qj8dLhd2RbgPU/LuJNihS003UOXoPlxMCKwFZAedjtkvyIcDO4QEt/
l6h8S7R9wVG/PZNQZ8mSYL3rrkFfMU7SVdCsj/rql55fKHzbdixEN89Yyvwp1Cqw
tUY0UZW3V/fFE0ZigwUzfVZrpHJJEQ==
=9vEz
-----END PGP SIGNATURE-----

--1sApqFsS7KHCWKJU--

Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0767A3264F7;
	Sat, 12 Sep 2026 13:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221336; cv=none; b=tZep7ZY7hb5PqU+VEzY83JtQprkYr2KtVYQKJG0wrP5iIfc+xHxh86gzFJgjzTj0lWOL/2QZDCshWVOsD5tkSlFNlzLoe8H3GtgTW568xKIGBAiTBIzCCP0GA1665GwgOpXXNCrf2CBAtDFOcTBfo7B5iKhJ8tICQf60sJJkYm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221336; c=relaxed/simple;
	bh=BDwzFJtt3fMOehG8JuyE+cZTipqyF3HRyqpeNEPG9vY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OiEP43xylOq1TW0cMU/rh2H5AX1kmPJOkhUb8uiOEf/LVgZFfoVjllXkmC3djecn1CUFpVeyaayEN7BluMc2LHy8ZR8rpXTULZu5DjQitB1fcjNIIASjZxGHK7U3L4727uUGQipSIjATLgwzxx+rT0D5hfmrxM9WMs+xNpyM2PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=wt2j8DVZ; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="wt2j8DVZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1789221321;
	bh=BDwzFJtt3fMOehG8JuyE+cZTipqyF3HRyqpeNEPG9vY=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=wt2j8DVZNWPqyjgZ4OvpD/sRRtGWhx5M16G01XpBWM7nZHZIvxyAshpab9t9OwE8u
	 n9m/WnAa03VCvq/33qvNDKpIl9aXsj7hIo+LUY7OTgyQEaaCIcHl2rUFKlODEAKUoW
	 nikhE/4MxGG8CaofViqTQYTNMNQmxNVJlOrk0klg=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 0E91E1C04D4;
	Sat, 12 Sep 2026 09:55:21 -0400 (EDT)
Message-ID: <77e00073a9254d5ea1ade771590da81a859b75a6.camel@HansenPartnership.com>
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andreas Hindborg <a.hindborg@kernel.org>, Greg KH
	 <gregkh@linuxfoundation.org>, jaemyung.lee@samsung.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo
	 <gary@garyguo.net>, =?ISO-8859-1?Q?Bj=F6rn?= Roy Baron	
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Alice Ryhl	
 <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich	
 <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, Tamir
 Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>,
 Onur =?ISO-8859-1?Q?=D6zkan?=	 <work@onurozkan.dev>,
 linux-kernel@vger.kernel.org, 	rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, 	linux-scsi@vger.kernel.org,
 linux-arm-msm@vger.kernel.org
Date: Sat, 12 Sep 2026 09:55:20 -0400
In-Reply-To: <87eceyvdnv.fsf@kernel.org>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
	 <YKq4TcQM0v2dXF4wTHEvZKwASII6PDd_R7_UiHWe3NRnR4JsrC_ZS-x6jA_Kl7P6ONehU0REHYk7WaLz8Xv5gA==@protonmail.internalid>
	 <2026091124-treason-trickily-bc52@gregkh> <87mrtmvioe.fsf@kernel.org>
	 <6JMwZ4EuSfQ8V4TGaPwatQ31m30TceLJblORsuILQmy4VV8Fx2lHbihL8ARsRUuJmaSUqek8L54y4Nk6DuZMXQ==@protonmail.internalid>
	 <bdcff6a168e6d4b8e9c9524bd598281817a7df2c.camel@HansenPartnership.com>
	 <87eceyvdnv.fsf@kernel.org>
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNE
 lecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn
 1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHU
 RfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8
 X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvd
 HRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGw
 MGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBI
 FCS3GUMIACgkQgUrkfCFIVNZKjQf/deRzlXZClKxTC/Ee2yEPqqS7mm/INUA49KdQQ5oIhSxkUBy0
 9J4qjMIo5F8ZFkFTqikBqeL35LKu7O7rn8WETfX8Bxvos3HUsl3jHo34DES4MUFIpoQPgtiLRGwLb
 K0cVCAArR2u2qj4ABmTRrs1I1kvdjEw6gatOuXtEe/j5O2fvfzTq9GBr0Q3n2IAsFXi4hLlx6VPE8
 tyWUZ8BWJKtih3JAeUiXFvASL3McV0rV9RnU0VbjEQEhSE7PMYhWpnDC9AyBb0lXJllQRvC3NSkUB
 8KVQgNNxRPss0WE/nBoZ4dFA42jTyzTz8lNylxZoAWV7WJb3QxVg4oCodRVrxxrQhSmFtZXMgQm90
 dG9tbGV5IDxqZWpiQGtlcm5lbC5vcmc+iQFVBBMBCAA/AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeA
 QIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJgS5mYBQkbNYS9AAoJEIFK5HwhSFTWBpwIAL5Bk3
 5FB34U6iHmDzzgdCbxLTs43T/YQyJpcGIvopBvnI/fDY8oSG6Df64/O6B+1R+A8TDp6ZG5ysUWnCC
 6GuIaEHemBYkitMPglR6+sGCMQY7O0mlsPvdssvKK1KI9Bno4VU6ogaF2qVzefSqg1Djmf/DcsxWP
 rI/jdJ8FB5AYR2rjIdDFc+zRdAJuavo1/anyY2wgpFh/3R8IOYAEfWV9nGgYkf9+tA4EIn1sxE0I3
 L5oW2N3mbyRrkzuBwO8ztMCwqEPk7moWzhokcZqMXiAIahaZdkashJC+s2X2RZSGCy+g+pvY5NN4B
 BVG5XwLgVBqbHMTcxE0fbmPqz+q6O0LEphbWVzIEJvdHRvbWxleSA8amVqYkBoYW5zZW5wYXJ0bmV
 yc2hpcC5jb20+iQFXBBMBCABBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmODZ5ACGwMFCRs1hL0F
 CwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQgUrkfCFIVNZu0Af/TzvL2/NdgAcw9uN3x60H8
 jc4QUq14VpxcFEFEMpcj1morkX/G93V+56HBBaXZj+yK8PhxIA/SIz+sU7C/0YvKuvzakP8ZX/7WJ
 e32SOUtjfr/VTaqjIBzNj6OxLvZpmNbBw7s6DwhhNpHOWqJ/1ml+PtDRDV71IB58yVqQjp1xlNKVl
 ZppcJ5908EJzsFnRIVjiQiDSKoppqB2BCibBbrWcln7CiWMyOC/cco6SIn6twH+f7+aivJ3xGcOE2
 a9gBKF5rNi9TBoX9oyPmshv/TDmnohsVrH7AYXlGYfZTk15SWEiROh1QX8/uD9wl/gcIv5EDUpT/F
 L2jzOsA5663bw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-09-12 at 14:48 +0200, Andreas Hindborg wrote:
> "James Bottomley" <James.Bottomley@HansenPartnership.com> writes:
>=20
> > On Sat, 2026-09-12 at 13:00 +0200, Andreas Hindborg wrote:
> > > "Greg KH" <gregkh@linuxfoundation.org> writes:
> > >=20
> > > > On Sat, Sep 12, 2026 at 12:52:55AM +0900, Jaemyung Lee via B4
> > > > Relay
> > > > wrote:
> > > > > Comments on the decision to bypass the SCSI midlayer, the
> > > > > blk-mq model used in its place, and the proposed prerequisite
> > > > > API boundaries would be especially welcome.
> > > >=20
> > > > Many many years ago, the USB subsystem tried to bypass the SCSI
> > > > midlayer for its storage driver, and while it was a "quick
> > > > solution" at the time, in the end, it didn't work out and we
> > > > dropped the driver as it just made no sense to keep duplicating
> > > > all of the logic all the time.
> > > >=20
> > > > So I wouldn't recommend it, as long as UFS builds on top of the
> > > > SCSI commands and the like, you should not attempt to duplicate
> > > > it in a separate driver, no matter how much "simpler" it
> > > > initially seems to be.
> > >=20
> > > The scsi related code in this driver is less than 300 lines and
> > > is mostly struct packing/unpacking. I guess we could lift the
> > > struct definitions from the scsi layer via bindgen. But at 280
> > > lines I am not sure it is worth it, and it hardly counts as
> > > duplication.
> >=20
> > You didn't actually read the above did you?
>=20
> Yes.
>=20
> > The problem isn't necessarily the duplication of code per-se it's
> > the duplication of function without understanding the subtlety.=C2=A0=
=C2=A0
> > Every fool thinks they can duplicate the core features of SCSI in a
> > few hundred lines (andthey can: the core SCSI model looks
> > beguilingly simple).
>=20
> Yes, it's really just encoding/decoding. Not much semantics or logic.
>=20
> > They then usually spend years adding back the necessary corner
> > cases and quirks before finally concluding that actually they
> > shouldn't have tried in the first place.
>=20
> Please educate this fool then. I am curious what SCSI logic we would
> spend years re-implementing in a detached ufshci driver.

The "duplication" is incomplete (it's actually only sense code handling
in scsi.rs, but the rest of the duplication is sprayed all over the
driver).  The incompleteness is fine if you never test for it, but your
users will run into it in the field (almost certainly in error
handling), which is when you begin the reinvention.  As Greg said, this
is the exact path USB storage tried ... and they did it because their
devices barely behave like SCSI ones so they seemed different enough
that there was little overlap with core SCSI (i.e. exactly like the
JEDEC comment in the cover letter).

What I don't quite get is this isn't a criticism of the language or the
rust project, it's a criticism of the implementation methodology of
this particular driver; and it isn't a theoretical criticism: it's
practical; this path has been tried before and failed.  The definition
of insanity is doing the same thing over and expecting different
results.

Regards,

James

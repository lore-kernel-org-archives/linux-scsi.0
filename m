Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7A53749FD
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 15:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784733887; cv=none; b=L+F8yLKn7uysj/7Z5TAaqzBh4He/lIIPn+Ohlsuq11b8PA3OQcLBWH4CP1bNCC1a0i4laz6WqpghM1WK7UirpuIY3SW388S0uvvAJJmeoZAAUN6Z8ln6IT9Pmb0AtsMozePcMh2y1kmH8IiO9g8Y9PbJijialyPIVHh1fVT3mDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784733887; c=relaxed/simple;
	bh=uSkD0aMO/EM2F+9kpLTJGIt9x50Emb40hDSXo53AmVo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sZRz+SNre1H2wF6SAuQSnBlBQ0d3ba5YhXgnpKt8PlYJRQw+kSQA3V0FKKiib7NpghisDqCjmHfNazQaLB887n+o75ipmLM5AE6fg6CWpxPse6tAIszJdc7zoMNAWCTLgMrZSZzBXkD4dTlCxbCnh6yK9ClC5TkhpfNkQLltjOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=tuysoPm1; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="tuysoPm1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1784733879;
	bh=uSkD0aMO/EM2F+9kpLTJGIt9x50Emb40hDSXo53AmVo=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=tuysoPm1oVvhvoZIE5LGoDVkYkH6f4WqeQsCnOwGlwm08eF0y56Nltq9qMMv3puNy
	 qRk/jqNSmA48I3UD8nj+SgF0S4zMKwNiy//RpkqgRtn3DIbEZlN+GXoeKsjNKU6HWg
	 +F23Wphxj7SXR56nd/4rqB939Be+ddgWXBpu96EM=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8c71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 9B8131C01E8;
	Wed, 22 Jul 2026 11:24:39 -0400 (EDT)
Message-ID: <a05e2ddea75895afdff63425d2fd47f90bdf65c8.camel@HansenPartnership.com>
Subject: Re: How to fix problems with the sashiko review model
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, Greg KH
	 <gregkh@linuxfoundation.org>, sashiko-reviews@lists.linux.dev, Chris Mason
	 <clm@fb.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-scsi@vger.kernel.org, ksummit@lists.linux.dev
Date: Wed, 22 Jul 2026 11:24:38 -0400
In-Reply-To: <20260722170901.30bdae6a@localhost>
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
		<20260722042744.5C1B01F000E9@smtp.kernel.org>
		<dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
		<2026072224-moisture-gonad-409f@gregkh>
		<e8f7c3614c15a86b335576074fec1768d95f3df4.camel@HansenPartnership.com>
		<e30c8cebe5d0a6cfada18c633be0125774ef0c7f.camel@sipsolutions.net>
		<5a2ce0b0eab27354d62450018f9843be83c72697.camel@HansenPartnership.com>
	 <20260722170901.30bdae6a@localhost>
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

On Wed, 2026-07-22 at 17:09 +0200, Mauro Carvalho Chehab wrote:
> On Wed, 22 Jul 2026 10:17:40 -0400
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>=20
> > On Wed, 2026-07-22 at 16:00 +0200, Johannes Berg wrote:
> > > On Wed, 2026-07-22 at 09:42 -0400, James Bottomley wrote:=C2=A0=20
> > > >=20
> > > > Well, I noted that in my reply above.=C2=A0 The way I was thinking
> > > > of implementing it was to add a general instruction file for
> > > > drivers which would make hardware trusted for pretty much
> > > > everything and then instruct the AI to consult driver specific
> > > > files for overrides to this so we could add the additional
> > > > threat checks to usb.md and virt.md=C2=A0=20
> > >=20
> > > I guess it's a question which way around it should be - but I'll
> > > note that generally for wifi customers tend to not trust the
> > > "hardware" because it's mostly firmware, is generally buggy and
> > > can be attacked over the air too...
> > >=20
> > > Personally (with that background) I'd tend to lean towards saying
> > > the high-performance stuff that does want/need to trust the
> > > device should opt out, it's harder to get that wrong. If we
> > > generally opt out as you describe and then forgot to include
> > > something, we might have issues.=C2=A0=20
> >=20
> > So this is just an efficiency thing.=C2=A0 There are 144 driver
> > subsystems, so if most of the want to trust the hardware it makes
> > more sense to have this as default but overriden by subsystems.=C2=A0
> > However, if most of the 144 don't trust their hardware then
> > absolutely, I agree, it should be per-subsystem opt in.=C2=A0 Part of
> > the reason for the post was to gauge this ... and so far I count
> > three opt outs.
>=20
> I don't trust hardware/firmware. They can be buggy.=20

Wait, buggy is different; we have potentially buggy in SCSI as well
(rather a lot of it, in fact).  However, we don't fix theoretical
hardware bugs, we require users to specify a device (which they could
add to the code as comments to keep sashiko quiet).

The general tenor of my driver/ prompt would be that hardware may never
be assumed to be malicious but could be buggy.  In the event that the
fix is for buggy hardware, the submitter must state which hardware is
buggy and confirm they've tested the fix on the actual hardware.

Regards,

James

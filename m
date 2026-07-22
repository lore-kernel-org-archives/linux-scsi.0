Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB8C3F3262
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 15:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784735741; cv=none; b=uQacDOiaipd7kEaD3zataM7scpnwFnuCMJJ4WXeBTQEHhNM+YyTyQIqVcXWXys0+HJL3XQOgQxTUntnNZM7qZyqpLOXmjp9iReKq/sotccfQPXW7YI9uyiG9ekjc5/bp39rapT7RvDshC3dcq0bHoQkNiP9xx9pEE/CBmIrYNS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784735741; c=relaxed/simple;
	bh=EVCg044fuMUg4WIP9fdJ4dfN4B82bSBsb+RO1nNcLoE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hqeZzvEAhzOGdQrKdK21uB0CkZUjCgHOAXFR34ERA71dEtFhM3Qrno+ud8/qsJabpq8je504p3uVPdj8l3Pj58fYRPfK3WEVBjULKGb52JIizgwgUVNKj/ZZlqdb/6vEsQOxyliCD/O92n+S5YiUfukZ2RmD8qgdNmTWXmYKMkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=D5lkklAT; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="D5lkklAT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1784735737;
	bh=EVCg044fuMUg4WIP9fdJ4dfN4B82bSBsb+RO1nNcLoE=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=D5lkklATMZ1chbSl+59c4SXqL+8sO6Im5oapMx8MwZA9FuV35aMq3/KZsgMSurzqh
	 mYRWWgyJx+GXHaNa9N/cBOLEZ/9/dpd4o6CeXMVupZfQ7ey+d9DksBoop72rgHB0VU
	 P//EPkDCIUkttEbwvrQIwRwXit4lswjDBwUtxJuw=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8c71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id E2DDA1C0166;
	Wed, 22 Jul 2026 11:55:36 -0400 (EDT)
Message-ID: <9a107be6c6041e3ce892217096c8fba7c9489849.camel@HansenPartnership.com>
Subject: Re: How to fix problems with the sashiko review model
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Steven Rostedt <rostedt@goodmis.org>, Johannes Berg
	 <johannes@sipsolutions.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, sashiko-reviews@lists.linux.dev, 
 Chris Mason
	 <clm@fb.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-scsi@vger.kernel.org, ksummit@lists.linux.dev
Date: Wed, 22 Jul 2026 11:55:36 -0400
In-Reply-To: <20260722113904.38fa087b@gandalf.local.home>
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
		<20260722042744.5C1B01F000E9@smtp.kernel.org>
		<dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
		<2026072224-moisture-gonad-409f@gregkh>
		<e8f7c3614c15a86b335576074fec1768d95f3df4.camel@HansenPartnership.com>
		<e30c8cebe5d0a6cfada18c633be0125774ef0c7f.camel@sipsolutions.net>
		<5a2ce0b0eab27354d62450018f9843be83c72697.camel@HansenPartnership.com>
		<96e5845db5e8e4f2d2253c2014b00d0db093ff21.camel@sipsolutions.net>
	 <20260722113904.38fa087b@gandalf.local.home>
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

On Wed, 2026-07-22 at 11:39 -0400, Steven Rostedt wrote:
> On Wed, 22 Jul 2026 16:25:03 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
>=20
> > There's also a risk thing - if you erroneously get a report for
> > SCSI (as you did, IIUC) then you can opt out at that point and not
> > worry about it again.
> >=20
> > If we erroneously _don't_ get a report for something that didn't
> > speak up because they're not on the list, didn't dare say anything,
> > didn't pay attention, etc. then nobody ever knows until someone
> > starts exploiting it?
>=20
> I agree with Johannes here. It's one thing to get an annoying report
> that says "You can be compromised by your hardware" when the hardware
> is trusted. I have the same issue with boot parameters. But I rather
> opt-in than have the case that I'm the odd one out where my hardware
> is not trustworthy, but I don't know I have to take action to have it
> checked.

The thing is it's not just sashiko.  Various AI driven patchers seem to
be using the prompts, which has lead to a slew of malicious hardware
fixes being sent to linux-scsi and I'm getting a bit worn out replying
to them saying that's not in our threat model.

So I figured why not fix the problem at source.

Regards,

James

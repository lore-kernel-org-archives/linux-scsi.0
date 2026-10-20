Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.37.111.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792507918;
	b=4omEl5ug2BaYRqN/4SN1E2pGjacmhvND7wOR8k1shFBjPO+3XUWKixcINOs63741MUZe
	 5KtUHqCK0xpw0iLL5J/MXf/ZinIPaPed8+mzhakTWLJq5seW4eri41/A/Cf50ODlA21N1
	 qPIW9yBUIHQ2TctN4GDaP/dn+1DRWkkIAzJ123SHbKOs3WmKvOidgQ7XL7jZn91mvucn3
	 /oZF3bs/CQPR2U8N90uGlMMVwh+MDeX08Zxt36u7jupS/Ztl7y+9k/CiCaKKalnRr9662
	 rLie1k/Y6RXRtqwAlVvqtnF6aV9lbx6bdbcJggSwwdnxtjsX35+zysovfAlGQFAkCtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792507918;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=DYXjhYohUan98NM/lys58QeMC8RgS+JMQUdLn51Hsac=;
	b=CyVGFrJ+9MviCX1/o13JygxqntDKTj0AQETs4BF2ZPjSSSkugM5uNfqWyrHvLzpka8Hd
	 0k89s6dloFuyWxS1SXkJkngROwHa8wO2qnox6WEvdPrsZwJhLi0SkwwQ8gFJ7GWoutdcP
	 kkLFZkzW9zQXrrsyaBYRq/djtok9dMTPlvMnNgP29aCqH55SmD9uoPjVNWVr6xtFegKbF
	 elEzvMHVeRh1Bb2FauwP14+Q3xon/vxEvznhHa/7Xd3rBfbxB2YQKIojVLMUdAPuNkmEm
	 fslawpsHw0qXf6714zSLyhq/3UIw3tojoH/IrB1VGVmjD63RhsaVvhA6NY+kt5pLv1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=HansenPartnership.com;
	spf=pass smtp.mailfrom=HansenPartnership.com;
	dkim=pass header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=XndoBtHg;
	arc=none smtp.remote-ip=198.37.111.173
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A37606A31C;
	Tue, 20 Oct 2026 14:51:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47A37606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=XndoBtHg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1792507916;
	bh=LexaumSGgf9IRQDtHz3O/M7QNPz/CJw5yVRJLAPIf1Y=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=XndoBtHgWNE/a8hOLdA0w5+/StIecBB6GltWENQBqDRm4zmYFGF/furLk15GS6l3E
	 KA3J3PyktqeynwAxOxyBPYUWVUPvUtTg/Gts5KYu+sq2+uueJkfVk/oEXa0ePFILTN
	 TQO/mE8oxWm5476cubXdVSZr3wZ8ZlcpPwjvl1EI=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 0E4BB1C025A;
	Tue, 20 Oct 2026 10:51:56 -0400 (EDT)
Message-ID: <1f9e1b5852aeb4827c31efcf537ff7201ac32cfb.camel@HansenPartnership.com>
Subject: Re: [PATCH v3 2/5] scsi: aic94xx: validate the EDB index in
 asd_get_response_tasklet()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, "Martin K . Petersen"
	 <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Date: Tue, 20 Oct 2026 10:51:55 -0400
In-Reply-To: <20261016001453.232046-1-yhlee@isslab.korea.ac.kr>
References: <20261015091747.4184349-1-yhlee@isslab.korea.ac.kr>
		 <20261015091747.4184349-3-yhlee@isslab.korea.ac.kr>
		 <06bbaf40d9188e478c4b58eaaffb58139839d217.camel@HansenPartnership.com>
		 <20261016001453.232046-1-yhlee@isslab.korea.ac.kr>
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
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Fri, 2026-10-16 at 09:14 +0900, Yehyeong Lee wrote:
> > have you actually tested this on real hardware?
>=20
> No -- the hardware is twenty years old and I couldn't get a board. I
> exercised the path by fault injection: built the function into a
> KUnit harness, fed it a status block with those three bits zero, and
> KASAN reported the read one entry before seq->edb_arr[] without the
> guard and nothing with it. That isn't evidence the sequencer does
> this, and I'm not presenting it as such.
>=20
> > is there any evidence of the sequencer ever setting these three
> > bits to a zero value?
>=20
> I can't show that it does. I looked for something authoritative -- an
> AIC-9410 done-list/status-block layout -- and there's no public
> Adaptec spec; the sequencer is an opaque request_firmware() blob, and
> the only in-tree description of this field is the commented-out size
> line just above the decode. What the tree does settle is the decode:
> the index is one-based, and the same seq->edb_arr[edb_id + edb_index]
> access is also reached from the empty-buffer path
> (escb_tasklet_complete -> asd_bytes_dmaed_tasklet), where edb < 0 is
> rejected before the access
> --
> aic94xx_scb.c:410, the 0xc0 "no buffer" case. The response path
> reaches the identical access with no such check. So it really turns
> on whether the sequencer can set those bits to zero on a response: if
> you know it can't, this is dead code like the second comparison and
> I'll drop it; if the field is as unbounded as it looks, this is the
> guard the driver already applies to the same array on its other
> producer.

There is a long tail of old server class hardware that has this chip as
its on-board controller, so we try not to touch the driver to avoid
causing bugs for them which will only show up months to years later
when they install stable backports.  The problem you outline here is
purely theoretical: if the sequencer put a zero in this field; however,
there's never been any actual observation of any sequencer doing that,
so there's no evidence a bug actually exists here.  Added to which the
fact that the change is untested on real hardware seems to create a set
of risks in applying it without much offset in the way of benefit.

Regards,

James

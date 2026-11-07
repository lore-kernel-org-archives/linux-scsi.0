Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.37.111.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794068205;
	b=1GVN8igKG7oSkluRHlUDwzniV99F87UYMN+yPo0cbONYgdJGkB+sbErQAPdY2TXYxwe9
	 RMqbQ0l4LzQMj33eGDrZPaku6qIvuNVa4xy2RHazo2b1SOiR8kMaw2XBeAbSVf7eV513L
	 u/RUOTT/cvZNGXHvL7Od0mxo8EQNSG94hI7g4cpYYnHHaks7YxlwUI/muA6Fw8KVVz5r9
	 hs2XXXwBqDEtO20iDjlX+oj0HwM+AenQ/KXNrXXp1NoY1nkOUT41x5Ep44Tb4mNvqUDG2
	 yDH7Y2xPYdwxXGk79ocJQLNvBi0qKtRB21zyNucGh29TeNPMiaya1Rng8UbKJwUR7Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794068205;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=6Y7Yo6Oqe/ga/aZg1xfbYcTINik1UzbgbEYeh9sbfEM=;
	b=J4bxnKF90usPwK25JFvx7c/Y/VEJ32J8YtT6UTVaRFTFxDlJU3ZrOphsGIKmYdFeeqKY
	 btDuLcVrRhCypTaFrFZN3P0uxFZ5vZDbeobnGcPUYKiDMaQ3LorsV4ToFIgYgXHPXmDXa
	 Qm5b2Aqv2UnPXqLimWozMtm0jI8EcsVsz6bYMvR/mPDpgUA7NaPrVY8yj3IohmeV23KoF
	 SWh7zUqFVZOyS+l0/sH0g4pyKlv9AKbCObsqvkqWe5XdzBFduoXQI1AXwlGNui3NCG3oK
	 tXDV2ym/B2BAR0bFvAIQ15RepgaQEsz/9CEvw7Bpo2Vp9dZ/uqEUTFVWhiQyJfzu3Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=HansenPartnership.com;
	spf=pass smtp.mailfrom=HansenPartnership.com;
	dkim=pass header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=dppFUTCR;
	arc=none smtp.remote-ip=198.37.111.173
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD6C606AC36;
	Sat,  7 Nov 2026 16:16:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AD6C606AC36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.a=rsa-sha256 header.s=20151216 header.b=dppFUTCR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1794068203;
	bh=6Y7Yo6Oqe/ga/aZg1xfbYcTINik1UzbgbEYeh9sbfEM=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=dppFUTCRuiebk817IGUGOfEX+qqm9ka2EfsTqm5Lp9V6Hniv7iQc0tyR/FmJs2581
	 UImzaZahBuPmsou+Vmv+tQ8if/G/LSdOMJS1IIvfD1eeEMB8FuP8z1Vd7sbGH+Nr1+
	 YvKl4uCgUj29AkD1TWUFV4gXMLq9yFmdBr16bDaQ=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 0866D1C022F;
	Sat, 07 Nov 2026 11:16:43 -0500 (EST)
Message-ID: <22c5ee29302b8deac001fec78942eae91ead557b.camel@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: libsas: Fix use-after-free in
 sas_eh_handle_resets()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Wentao Liang <vulab@iscas.ac.cn>, John Garry <john.garry@linux.dev>
Cc: "Martin K.Petersen" <martin.petersen@oracle.com>, Jason Yan	
 <yanaijie@huawei.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, 	stable@vger.kernel.org
Date: Sat, 07 Nov 2026 11:16:42 -0500
In-Reply-To: <20261107145323.314159-1-vulab@iscas.ac.cn>
References: <20260917143946.2157366-1-vulab@iscas.ac.cn>
	 <085fcc2e-112f-4d4c-a07d-9d0962936e44@linux.dev>
	 <20261107145323.314159-1-vulab@iscas.ac.cn>
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

On Sat, 2026-11-07 at 14:53 +0000, Wentao Liang wrote:
> sas_eh_handle_resets() drops the reference it took on the domain
> device with sas_put_device() and then accesses dev->state again while
> holding ha->lock. The put may release the last reference, so the
> clear_bit() can touch freed memory.
>=20
> Clear the pending flag before dropping the reference.
>=20
> The candidate was found with static analysis tools; DeepSeek and GPT-
> 6.1 Sol were used to audit it and to help prepare this fix.
>=20
> Fixes: 5db45bdc87ce ("[SCSI] libsas: enforce eh strategy handlers
> only in eh context")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

You just adopted the patch John sent wholesale, so the signoff above is
now wrong and you either need his signoff or at least a Co-developed-
by.

I get that this change is likely too small to have copyright
implications, but you want to make sure your process works in cases
where it does matter.

Regards,

James

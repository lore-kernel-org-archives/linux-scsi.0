Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D0D3EFFA6;
	Thu, 15 Oct 2026 13:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792069534; cv=none; b=ZZ9H9bqB5wBtfFabNky/E2l/GGIsM3OLNEHThA2ias0uWlqHzXLEy9tAJLZ40sJU4zU40qe2VoknOKlXeVpoJ4SYL5k8aSefkqvrc8f2HP4DQDUjUGNTbE8MNYVH16AOAnRyMlxF2h6/BcJ7RBl0qPL74UQdgAAYIo9uRizx7Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792069534; c=relaxed/simple;
	bh=2fvPEbrksXUYBX4/5rBDlqNIqOnAiK7F/60abEAhyJ4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R+Gx2xu2jZsdA0CoCbpz1dqlaknY2qsXCeM0dIuosK2v7ulB7ltjIf2svlBigA1Vh+GFTJS5tv2Sgv1gwKTPRB0xewSv79HbPxM/sglO1fgKrFaetCOXcybRXY9moCbbVvPhJQOJHqqj7P9i3AgPGxRbf3I7+i0L1dLlo0Z721E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=rJFNl0Z0; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="rJFNl0Z0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1792069531;
	bh=2fvPEbrksXUYBX4/5rBDlqNIqOnAiK7F/60abEAhyJ4=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=rJFNl0Z0lYR/zOH3BlCoKDQD4dzZt7OdD5lj3OddME8xbByRTNIEgcFX5y6Qxc8lK
	 TbF6MgtePv3SO/G5fXkUhOQPPXaSQAwrlBPhHd7qZf0yVPlCU1/TZ3XmFH9ji5BqS/
	 aQyeST2vFYWiyKCIu2jydxF5p+n3P5c8ihOaQWNg=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 3AEFC1C046A;
	Thu, 15 Oct 2026 09:05:31 -0400 (EDT)
Message-ID: <06bbaf40d9188e478c4b58eaaffb58139839d217.camel@HansenPartnership.com>
Subject: Re: [PATCH v3 2/5] scsi: aic94xx: validate the EDB index in
 asd_get_response_tasklet()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, "Martin K . Petersen"
	 <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Date: Thu, 15 Oct 2026 09:05:30 -0400
In-Reply-To: <20261015091747.4184349-3-yhlee@isslab.korea.ac.kr>
References: <20261015091747.4184349-1-yhlee@isslab.korea.ac.kr>
	 <20261015091747.4184349-3-yhlee@isslab.korea.ac.kr>
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

First a meta question: the aic94xx is about 20 years old today ... have
you actually tested this on real hardware?

On Thu, 2026-10-15 at 18:17 +0900, Yehyeong Lee wrote:
> asd_get_response_tasklet() takes the empty data buffer index out of
> the done list status block the sequencer wrote, with the same
> arithmetic
> escb_tasklet_complete() uses on its own copy:
>=20
> 	int=C2=A0 edb_id =3D ((resp_sb->flags & 0x70) >> 4)-1;
>=20
> The extracted field is three bits, so the subtraction yields -1
> through 6, and the function indexes seq->edb_arr[] with it without
> looking:

These are the sequencer response flags ... is there any evidence of the
sequencer ever setting these three bits to a zero value?

[...]
> +	if (edb_id < 0 || edb_id >=3D ASD_EDBS_PER_SCB) {

Why the second comparison?  As you say the value could only be -1..6
and ASD_EDBS_PER_SCB is defined to 7.

Regards,

James

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998139;
	b=btBN5x3c/GXxEu4BPdHDl2CQdiEpnq7QAsarIdQea/QVxrVkni0Mgr9hEOtc8vrzegbA
	 AvrznVL1O+X1u3wEwmLzq/wUN9WAN1a6bR1/wtUXYKTV49Nt5tgCK+cAArBNBW4VU6deP
	 /Di8Po9cl1oUZ075YSkgTqqWKzEQ5OLFvUWQd3KUq7lmbx1E1hCCwxDOWF712f0NI3N2A
	 t6lLJjeW/M5MIUwfZNtGs5eOIOEosTBJYDLbO6hAo7m3sUZqTOOMnFWgMZD5b5CN3UI79
	 tPo7vgvsvri0YB61cBIwCDXHTrA2LBhOzmV3r70BLAcBH0Ug+ebICSimrLeu0f5c5cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998139;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7lNlKijfjzYnAIJLacJZdOtSM6WD8qOKJm2H2h/IbrI=;
	b=g+OaZ7GWtc+JtzoXxSWp+4N81r0vw3YhFKX0vB2/EHP1jwWYQvEUxpuifG96kjZbxS0L
	 OF6fIniGPf+tTw7M8NGRcvAeRe+QD5kUVYQxx8TF3oTqOFK5R4KQeb9tfS3k53hbLstr2
	 /pSUUGlPKeRqbfISSB/S6KaKKrlDhOGj8kKdURzlZZB7Wd/SkfSxd/X6gpB6ZkD0uDRms
	 ky5sZmsfuUzchdgV/d4nBFhdwit/B982OiFw+Y9PDwf3tsjrHGOu6PgodF0Fs54m5+a7w
	 FvfPQOzrdWcVkrDt/56MEr6iSFHEAYMnHqRsHslBfw+qobjnprYjkArUzo0fEB/+/lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PRIVAZKJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4799C606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PRIVAZKJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3181F000C4;
	Wed, 18 Nov 2026 10:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794998138;
	bh=7lNlKijfjzYnAIJLacJZdOtSM6WD8qOKJm2H2h/IbrI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=PRIVAZKJ225bG5LST4Y6hesmT9haT/XwTZYi/trRxZQOdRF+hNe08DXjbpfKR4eLa
	 Qasmjyop+Cl29s1i51aOyhv31rnTE72VuVmKfRaKM5ldYnehs7lx+Gz+Ro1xS79NSs
	 rGCGttVab6iDCwzIM5Oyj6RvhYJa5Ax0qrAE0w6fV0wIzCb8HCqp2F0QMTe4wUVZky
	 fGkzyBjq1palrCoaNJqtwCP1WRwpnEXR5S/Ft9OYF1DfAYthh9mp3VoY8wo7u1Ivtd
	 3SwvS1UnijeQ/zqwbqZXuu7jdnJ/RaFP46471kRPPHlbasJLQTZ9hHFg7xN9yp73OP
	 Ox5uJh5sJK27g==
Message-ID: <sashiko-outbox-220708@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 21/37] scsi: mpt3sas: Clamp sense_length before
 copying into transfer_packet->sense
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-22-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-22-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:35:38 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] scsi: mpt3sas: missing Fixes: trailer for _scsi_send_scsi_io()
  overflow fix
--

commit 4d7bd86fa6f45295740631c1c707cf0f676eab3c
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Clamp sense_length before copying into transfer_packet->se=
nse
>
> Clamp the firmware-reported SenseCount to sizeof(sense) before the
> copy.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
This fixes a potential buffer overflow in _scsi_send_scsi_io().  Should
this include:

  Fixes: aee682fad6cd ("scsi: mpt3sas: Improve device discovery and readine=
ss handling for slow devices")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D21

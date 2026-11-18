Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997586;
	b=Xp4mg42WAe+IOFnmvJSvVX3fj7OAQ/jlvd/LwAt/05ixinuX75yWBTmV6aCqlXdcWbq2
	 MdlmnqrpX6fBGcPK7UF8W56EsdKsShzhHuTu9IKc9JAxpOKGEF9I7R4RKChBhvBQnUGR/
	 KigAlhDAK7Er8SOqDlTno9WmaQ9xhLR9QYlJGu8rENT5HFo3b7pGf2l0hPyluTW8QjGwm
	 NA0/DxRmyqrOi5hZOfG4D4V9bN2lMo1alAupBzb1wsv76u2eK98pPICL4yp0EQnj5W8bE
	 PsXi2TPJoJRiQBDjyOcsEK1MD4hKn/iTtywKdP2gSH56XWKysyzDxAdcRWinK493d0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997586;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1BB5MqILCIonwu1g/xhQkHxA9MQiZH2vKjXf5MqzkMc=;
	b=jCrBlje4dF8JwuBDQLZl3meGAYkKvdFgugUgjcYAOagE0/kvnW+iJYpK+3ZsCbGyprRY
	 k4qTRpD/u/IiqasD0XX9BGy62K9fRtS3EsmY9tVWClIchwWFkpgNmXGMaR+SKoElZmr+R
	 udCN9yFGp9fLc4Zdhvfh9OjCNJlG175bWyPojgNXRcJJ+9HhNeGTlvII32XfheHXabNcI
	 nStoAdN+k+mosXZoyd/vtZRr0DYULf8E0YFK0SytzfwbU9TGFuGxALKvsAlXk12tRQ7PK
	 VxrNUykO6WYg91krE2CI28gA4fG/jv0cdmMt/JhHdgfHHxTmFatnXI1fNmMsA2m2N2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="auRtMY1/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC1E606A320
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=auRtMY1/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7911F000C4;
	Wed, 18 Nov 2026 10:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997586;
	bh=1BB5MqILCIonwu1g/xhQkHxA9MQiZH2vKjXf5MqzkMc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=auRtMY1/oW6STAaHO3EQ9JMFoRLl2KPPpwndy9SZ/wLHUPXHXAmtqvjSU+JkXxYh0
	 D03HcPDgKXRzBRWBT23EcQx1HAk2HRQgP4ypTMf7iKoFhuz1mT/NJwpoIP3Gx+YEwB
	 8FKSTYadyJVxSgyYZY8lmqONFlYLvETduB990OqS0dsGy2DhA0PJfnuDLEOgWwcStG
	 JyEkt0Ibe5YWW7s3xXBPOmUxbB8sDUEBz+zkNLm/lhWwuC32no9BLn5zgIGKMW7jax
	 7fG71FfQM7I3IbwfrNKJK7mXAAU+NtStSUiIc8X79IWYUro+W8DHoIBaBtass4RzM9
	 +uzmap8vgs6hA==
Message-ID: <sashiko-outbox-220688@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 15/37] scsi: mpt3sas: Fix Scsi_Host leak on
 invalid/tampered device probe
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-16-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-16-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:26:26 +0000
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
- [Low] scsi: mpt3sas: missing Fixes trailer for Scsi_Host leak in
  _scsih_probe()
--

commit a9a92c92deebc92ce6b586ab0b53ab5f9760eb6d
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Fix Scsi_Host leak on invalid/tampered device probe
>
> Release the Scsi_Host before returning on the invalid/tampered
> device-ID paths in _scsih_probe().
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
Those early-return paths after scsi_host_alloc() in _scsih_probe() were
added by commit f38c43a0e900 ("scsi: mpt3sas: Detect tampered Aero and Sea
adapters").  Should this include:

  Fixes: f38c43a0e900 ("scsi: mpt3sas: Detect tampered Aero and Sea adapter=
s")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D15

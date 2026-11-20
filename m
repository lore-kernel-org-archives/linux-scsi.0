Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795142431;
	b=hJml8o9Z6+PHUrHxhdQAH8uzau0gaw9GNFeBC4VXe5+gdpnG/vSVREt8C3ekMitU1q6l
	 VgilJ7FwsramlV0foGdx0y6U0O0wH/pA/pccVEAJ/bXFXiFW6S2J00x8XTbWvBrlBaO/D
	 sjsENbYW9+wrROVpGpn41l4k1SoBGUI82+kHU3IJ2jx41uZFctfnsPm//lTeq4/DcEcfU
	 3fHQ2M9m6270DphDAwObjseqhfMq9XneRl2M1kiKgzRTubiO3dxpQ115Vrs8YkDPJX7dx
	 5mvl+dJe7QWZtihX6urYzY0vqeDp0TZ0ahMaMD2TGl8yd4QbsFcgHDJ7anEFZYtvFIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795142431;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=qBcMam9a+G72eCE1iEQm72P3r8R+iwjDqvOhmq1l5fk=;
	b=jAqLU0L1PIwKpPQ6j3CIQVbPKxg9mQ2qRfPVK1QuNRFdr5F/coPS1Fs8XVtIgsTD1Z2u
	 Vd2Qk1+HoqbHZ56gmsN7wEcU0+tkVCbPaGGyF4wPWO1Bm1DQfBAvLDr5Hrzr1O7cMx+xB
	 0RQfkxFlamVvsmS06nOUAJF+GrznSEfPmwkwuIDCRKZ7NnqqFTrz9Pv49QFGtBiE/lZHq
	 +fpB+xZUGSxI74pgcT4Er6wSNBRUVs13o2I3D8A/0GM66DeMUYCCpsTO4iuxLkgangyoG
	 9MPcVDyWrn3OGOIjJA6UtAfR+Qr7DuYvG2xbEFKuuw3RE1KrlzVNR9bllsn/JOu//eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="fLPEty/H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C794D606A320;
	Fri, 20 Nov 2026 02:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fLPEty/H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576F01F000C4;
	Fri, 20 Nov 2026 02:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795142431;
	bh=qBcMam9a+G72eCE1iEQm72P3r8R+iwjDqvOhmq1l5fk=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=fLPEty/HV4MNwDK/4gyh+ICQDovXhH2Pqbenl7hfRMBLY4SBXvIsmn0yOJNz4Urly
	 H1CbeQ0fmi5Bs4R4GhgiDEtmpOxwRqNXg5UIioezhYdJ6xrBLpfwnjwLW9ufFJN66y
	 edxP9AGEQOZROAj29+QhAzAU/iugDPuJYtDdX4RxuSLJsm0JoPPrHeqh59Y/SBJQTQ
	 gwIe4mNrsuJbEvJSH2HlyF1UBwIgaVvFAP7OXmZ4Sru1s6BSFzAIpmN4zwl8yo0TOs
	 9eoCVuhBSv4zCB8QAzEH9gFGftKFHD4RLOx+jVI+aChzKfGrLDrWEBGZfyKDGG6X+Y
	 sE24MgmvOPO1Q==
To: Tim Douglas <me@timdoug.com>
Cc: mkp@kernel.org,  James.Bottomley@HansenPartnership.com,
  linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: esp_scsi: report the residual byte count
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261118003746.61659-1-me@timdoug.com>
Message-ID: <yq18q2oql81.fsf@mail.kernel.org>
References: <20261118003746.61659-1-me@timdoug.com>
Date: Thu, 19 Nov 2026 21:40:30 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Tim,

> The ESP core tracks the number of bytes left to transfer in tot_residue
> but does not report that count to the SCSI midlayer. As a result, SG_IO
> returns a residual of zero even when a target transfers fewer bytes than
> requested, as can happen with INQUIRY and MODE SENSE.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen

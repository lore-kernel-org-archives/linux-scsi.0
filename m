Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793849178;
	b=JN8y74Ukm0+u3M32XRSB94K30kYPB2meVZAjfadfzz4vm18jAtrVKWwh6voiFZpmpay5
	 nnnEznu7uzn3meq+igvyKpE/8RT3CHyIFVtQNmIpxvv4nDXlAeg189TH6RDhfPaj3/gfH
	 Qs4HdG+VPgXJ/sLeZMo7w+9q2yJSNRp13SBKiIvvQRwBZ1euSJviFjo7rm2agK3MeiERW
	 g9L0ppFhT4N3oCmDbtlckzc0e8hhmxcaVjeWBz6+5hF7+FEWRbBAHLrevqR48gBSi2LP2
	 cIv1u9izjHD6A0ndh+Is8H9y74K+RIeoCnaOeGLBNCLWZWcWO9mmBm+kcre+d37EuKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793849178;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=Fpu2k0HmKxZttwGHEPl9JAza7xUeO4Q39YGMtAjSdGI=;
	b=m+KoDxJG96zJKwZkwLQ52tUtOTIGXf1pYLl0OmbLZ6sF0iRr0RDZDlpGeMvA+tjxt8qp
	 yJZkjewiyPZgZGsBJhKuaSYVEuxIVSwker5X9t8ra57gqkxza8u90pa3FQpf2157Eb9jH
	 HybDo0WlLgLWDXH0DpXUXHTigX8Tz04m5e1XwhGeunNEpGpb/KWcRhj8mPOckAITjYEpo
	 nr+ptBLVB/k53vpfxj1OVYqWRuvIJUJ/Kq8YkrIWr6/4BE4RkDZb6L0ZLw9ebxxSlY5AC
	 C8OWwH7FaX9FDdkgSIm9q0gBYhrs24K8y54Mr4KzmA605pzw732FPfQ5tYUNXW/h/UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g83VSZWY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CBF606A31B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 03:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g83VSZWY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB5C1F000C1;
	Thu,  5 Nov 2026 03:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793849177;
	bh=Fpu2k0HmKxZttwGHEPl9JAza7xUeO4Q39YGMtAjSdGI=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=g83VSZWYitfSyIrZ0IaeFKQplFLGUG1iqo/2nYF2zo7uoVm/TYBAGEZrDXzKSgNgY
	 F2Myt5/ZQSUVn3IK2wxGXLuFI0YuI+AaPQv1vpWwdGyhtdcclxmVpnfEX/X+6TKoDd
	 b18Gn/231Re3xMYdlxp013NIMw0bAAGa1oNpdmxFOaOkEd7EK6A1yJTKckjxUBS/10
	 1/anNwQrkdXt6msGFLeYH1CF3Vnl4Yp5mY+e+DNH2hRFzLeV1jClWtI63Br6T+YdKm
	 J3lhgkZwZC5Iv9W5LHIhSAILKIE428iNPv6wzpaZewqmL4087g6Gjz5YTXqijrVUIl
	 AWFvdsWO25lgw==
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
  "Martin K . Petersen" <mkp@kernel.org>,  Heiko Stuebner
 <heiko@sntech.de>,  linux-rockchip@lists.infradead.org,
  linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: rockchip: Improve RX noise immunity
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261029151030.1.I61cd43e660b146e49d4380a754e936270e5fb6a1@changeid>
Message-ID: <yq1jymsyn6a.fsf@mail.kernel.org>
References: <20261029151030.1.I61cd43e660b146e49d4380a754e936270e5fb6a1@changeid>
Date: Wed, 04 Nov 2026 22:26:16 -0500
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


Shawn,

> Program VND_RX_SAVE_DET_CTRL for each RX lane to raise the receiver's
> tolerance against short transients on the incoming signal, as recommended
> by the Rockchip PHY team.

Applied to 7.4/scsi-fixes, thanks!

-- 
Martin K. Petersen

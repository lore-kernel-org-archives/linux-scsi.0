Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793781703;
	b=NN8Tq2DJEhoW9BOk+qjQC4Oem977Yf+LvaS6OXojFEwaVQyfCCCCdIg3ghVr+JOrsKEJ
	 2ZrH4TdjznMGvh9wW0ODcDX9fn1Tq4fAEPgzWbH6KHFfxQk+6k+i5bWYkKgpjacn6leJ9
	 cmQjDiySfWpZ0WOmomnfUGXqfxAFPGbWY5mCugl4Z7oFH3loLjomqejGdA9+uv/2M7v22
	 9IQRIlSkEnA2Dmrwm3KGrK/7ZDaUz74Wo6Kjq3fWmoEjIexUstUaukh3HccqOKPvnVrKH
	 fIciP8QVJYmArZm1grIQ98azwPOQX9y/+VZa7ZDm3+4O8Dulp1glYP5wWvN81ZUb9xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793781703;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=HxBxe+zVox6fEP5byfjPEJNTREH8M4lYzABxTwwXNEE=;
	b=4XePP8EIMnRJBW0rP/OBZgaPIxuMTTCos+3H4tL0eXYD1HWcCIkQjTc/Zxs3HWc0fQlk
	 rot46nj80LMa1PTTg+ErAeZeL0N1yXUJm+1uh44NfG6GEH85n7f9eXJWyAQMc90cdMFBp
	 Y2RUACPE52E6hRdoVgEe+pz7lvialynHU0NQotGeecqzaLqv3FNr3CbfH2v+XDbZBpg83
	 /KwY+lW0gWdLQAJ08b0r3wEElIKTDL0TM1w8PuDBduYm92zKsAtOHlelPU28BZjhqRkvD
	 mdzrDLvWtvj1dyWqwPtfkSi5pQO9kKUZ0MZ1/aEMEYG9LFn86ud95RWtvXfW7zK8QdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lEQqQEO+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBEA606A326
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 08:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lEQqQEO+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE31D1F00919;
	Wed,  4 Nov 2026 08:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793781702;
	bh=HxBxe+zVox6fEP5byfjPEJNTREH8M4lYzABxTwwXNEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lEQqQEO+ECac2o6ggGJ3t5Ii715n3JasZks60xns3KvN3Vcwei2f3tYR9abFbt4o3
	 CeXEdguKwwRuqqeFcKNEknCsPJMqSRChFWqEoF7wfiN9hiClBrvWP8Yz2aaEruKfPV
	 kuitu6Kh2W5h8b4a5TM7lDG4H/bNLOigoBDIHELVoY1UGWEShCn5HCbKQ6TErqroLZ
	 AOMw07qPv82m/eS32Fy0D/I2Y6n17bFmBn0j5L27Fyoac1gAkKbPGw6rR5HE/P9VOI
	 iYDGS76v1+DIz0QFxdLAKc1+BjcaQJVWssVfu4Ag5JpN1RzU4bIc5J8/C0p8XFXE6B
	 0jZsDttpIwz+g==
Date: Wed, 4 Nov 2026 09:41:39 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Cc: Wentao Liang <vulab@iscas.ac.cn>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: pm8001: unwind the probe on ccb tag allocation
 failure
Message-ID: <20261104-fragrant-fascinating-civet-9c5cd8@quoll>
References: <20261104021411.1467970-1-vulab@iscas.ac.cn>
 <CAMGffEkj=rzCiiek=p+9Qc2AjJ1Nkk00H8wFReQ9-0ptWHKobw@mail.gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAMGffEkj=rzCiiek=p+9Qc2AjJ1Nkk00H8wFReQ9-0ptWHKobw@mail.gmail.com>

On Wed, Nov 04, 2026 at 09:33:55AM +0100, Jinpu Wang wrote:
> On Wed, Nov 4, 2026 at 3:14=E2=80=AFAM Wentao Liang <vulab@iscas.ac.cn> w=
rote:
> >
> > pm8001_init_ccb_tag() is called after the Scsi_Host, the sas_ha and the
> > driver's private data have been allocated, and after the PCI regions
> > have been requested.  When it fails, pm8001_pci_probe() jumps to
> > err_out_enable, which only returns the error: the Scsi_Host, sas_ha and
> > private data are leaked, the PCI regions stay requested and the device
> > stays enabled.
> >
> > Jump to err_out_ha_free instead, which releases all of those resources.
> >
> > Fixes: 5a141315ed7c ("scsi: pm80xx: Increase the number of outstanding =
I/O supported to 1024")
> > Cc: stable@vger.kernel.org
> > Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> > Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>

Are you sure? Sashiko reports introduced UAF (and/or other bugs).

Mind that vulab@iscas.ac.cn is a bot with spams with tons of patches
which looks exactly like previous hypocrite commit approach - some
security vulnerability intentionally added in between of thousands of
valid patches.

Best regards,
Krzysztof


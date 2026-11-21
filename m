Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795229214;
	b=C0u0BMiE5ySBnEcT6dJvmHqPuvPOdNNFFiqb/AgPe85FAXR6Juv6/AOEs5csiSotN0+R
	 DbgMtb5ijsPkjmikzwfodOW0OYfz5HMYt85W5MVNjD6mLsrzROfY8kJw5iYX+O2OC7wFf
	 D8URPDFKQvgR/ioxpdaBzYAjoHmN6Nry7CBvfVCs7Ppb0zPM2c87wK3ItprJLUK76VowJ
	 7GhGnFXz2HvMh9cUQlSzDTJGp85b3T07w5A+LiMLk7JVRZrLrTaDVqwSml9X6KrcHGb2D
	 p0zz4ZAVJUW/nxJ0PKywM5H1X50uCGSpYgD7QNDVOtKR6glTMyjo0du/EvUQ7qSDhBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795229214;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=tdjB1sJVMcUby28Dv9dh3WA+B6Qh7Hq6MD6ZlCMvcEk=;
	b=O/kGZieBJ0z/78SHU1ZJfr0qwSIRDvt4e0ezOOXHatmwKTpzFgjbBTuZ/gT3EZikXsKr
	 ESyk0Fj4jPhbWPC8ufuw38Yp/MOFx7+utbbMLt2LiOUFRljaNGCkuRmty2KpqvrBBNMgx
	 jT+g3Y3H4sloF3hJ4EiBCaWM7zO2YNnTApx0H5oyotQDqQ6DRZoM21653HBC92Ja9O7Jm
	 hVYVIjE55cBcYMIqaIVEZfbGwe6tCoaOoHPp+h6aqkc1tQmy2z2IDq8kyiZN4Rp3GJbi/
	 heAhSQR0UUO8RbwO1ZnogYNi36x52/m7Es9q8YqmMo7TYkJa0fv/kCQc52tBJYfpjHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ao99I1+D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA0B606A68A;
	Sat, 21 Nov 2026 02:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ao99I1+D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091151F000C4;
	Sat, 21 Nov 2026 02:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795229214;
	bh=tdjB1sJVMcUby28Dv9dh3WA+B6Qh7Hq6MD6ZlCMvcEk=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=ao99I1+DpQRNpCvv/3h/yrJy2Qu4uiORbWK8Gjqp97pr64r7Z9FjUpAGzrkxLW6Nq
	 3TVciHwJe9fB17GUeWHyjhSv187axlgq+nVU+1aaQxoDef6Q1mTd0sdPXkwjnT+9wH
	 On26/XBaINilAueWT3hS530sGmHe3JMW73PGj9+i7d3gfx5AUk5qgsm3J2O4tE94JQ
	 8R/kJjbb8J3kreZE7zetf/7Lqyg9joe1DEYvyhfjkZjAv7moS0zEU9DqfF2MDMZ6iE
	 P2u+p4iZDOyz8kK3Vj8nxbBdlZyWsMOdwTK+N1lONO520T661Af868QEE0v3i3Hrvm
	 l89Am7Tz5lhUw==
To: Tal Zussman <tz2294@columbia.edu>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin
 K. Petersen" <mkp@kernel.org>,  Damien Le Moal <dlemoal@kernel.org>,
  Douglas Gilbert <dgilbert@interlog.com>,  Shin'ichiro Kawasaki
 <shinichiro.kawasaki@wdc.com>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] scsi: scsi_debug: fix zone reset with virtual_gb
 and DIX
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261116-scsi-debug-zone-reset-v2-0-83c8a9841f4c@columbia.edu>
Message-ID: <yq1ik1qoq99.fsf@mail.kernel.org>
References: <20261116-scsi-debug-zone-reset-v2-0-83c8a9841f4c@columbia.edu>
Date: Fri, 20 Nov 2026 21:46:52 -0500
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


Tal,

> Resetting a written zone on scsi_debug zeroes the zone's blocks in the
> store, but does so with a raw offset that doesn't wrap around the
> store like writes do, and without resetting the blocks' protection
> information. With virtual_gb set, resetting a zone that starts past
> the end of the store oopses. With DIX enabled, a reset zone can't be
> read back. The first patch makes the reset wrap around the end of the
> store like writes do. The second resets the protection information of
> the zeroed blocks.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen

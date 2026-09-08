Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61AF296BD2;
	Tue,  8 Sep 2026 20:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900313; cv=none; b=p88M9mR+0WWPuIJKXxQlU+eUX6yAd94F8yvTxxgYlJKRDjKJINVgp/onChXWzxH7Mlmokl/+59Sey3J9cpT5u8Jf0LoPF4+JpaRC4+rZlVK3StZ6oBgn2yVMCQZkg4kfpikdGFB7yuxDU/ODSe+j7FZU4Dhcm/tw+u2IRW+E/0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900313; c=relaxed/simple;
	bh=lfX1XLXDKjaQ1hZ7XBgaLjSBi6sT1IIdcg4WNB0jRhI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BygbXpeZPf9LSfvsRQ1kzgFnICbwCgmP50DF1lQnpa7M4okUjMtkfD7WxQ5TFQPSEOyv9XHtp4uR2G10DIZ+pums21/ZM+AvsbA8d/xdqfxOe8QLF9g/S1ggBtyuQSpaTjSvdiyNJtb2ReOL8jFYMkJSvaNaRNOjpMTEMIBGqFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQN30dWJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQN30dWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831161F00A3D;
	Tue,  8 Sep 2026 20:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900311;
	bh=lfX1XLXDKjaQ1hZ7XBgaLjSBi6sT1IIdcg4WNB0jRhI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UQN30dWJwpo4V26dZC3AaUHsG2hOS/xHT3lNBlbcetD/oJNqKXV4MoEcunr7NwsWK
	 renQVIHz5ptMXhKDVsYTwLLVuO5HvVauR2+LJz4YvqrcUJgJzFPkbq+sTWU5Dx5Njc
	 3CAW+UVWWmi1GFMyQm45EB8Jtkf6hvacLvI/l/Xoo/u/HCOeN6lvJS5IyABEVJ6vSR
	 kQpBNg5GO8Vy5ywxwIPiwjoI6QuiA9SHiMCcSEjiO0AEJQ3fxMaOf/a2FBjluod/Qy
	 Jb+GwVWvtPtT6rnk10lA3DS6hu0he65vbiCM4qqqSzYT48HwO6Ywg9IYMSRFEVwfkh
	 CQNAq5+G5+y5g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 34/39] mm: eliminate VMA_SPECIAL_FLAGS check in
 lru_gen_look_around()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-s390@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, selinux@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-34-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-34-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:45:10 +0000
Message-Id: <20260908204510.831161F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> A kernel-owned or fixed mapping is one which sets VMA_PFNMAP_BIT,
> VMA_MIXEDMAP_BIT or VMA_DONTEXPAND_BIT, which is precisely what
> VMA_SPECIAL_FLAGS tests for other than VMA_IO_BIT, which is safe to drop =
as
> only kernel-owned mappings may set it.
>=20
> Using these predicates rather than VMA_SPECIAL_FLAGS makes the check
> self-documenting and helps eliminate the confusion around 'special' flags.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D34


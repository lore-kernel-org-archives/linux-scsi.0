Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2DA49AA44;
	Tue,  8 Sep 2026 20:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899902; cv=none; b=Guxb+NZiwQSL972s1pzV5IZ89pvEGvMAG9Qj7Olf5QE9iu5aIxw0RNVTrtLN0MZOwxU1+FhOPvOCYHxzsGCPSPmevX6SmVr4xFQ+wdwHC5KPMzMoKxomk0NK0kcU8gWpKHxNWIObjGZjmS0FRcdSsewo2oAqCasN9P5K/UGtBVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899902; c=relaxed/simple;
	bh=3FmB7rMB7W+zd8I+08aizQ0FJkQHIiLBhCXPX9ap9Y8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iABzrfpz253sy9+84jPpqIGOLNnpNulnnLt81cORv6wdrG+U0ww/hasoV/f6oCIctO/FfWU9OG9wYk9kZypMzPwnShOVpfapyWWxE0yG9c9qbg85bcIzxSr4z7XulaF87+iHO2G1xCNr7zaRCCP4B/uXg4z8Uz9LpmGzbZws2X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f7diApag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f7diApag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26131F00A3A;
	Tue,  8 Sep 2026 20:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899901;
	bh=3FmB7rMB7W+zd8I+08aizQ0FJkQHIiLBhCXPX9ap9Y8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f7diApagFqZbGgd6pH4K5iirRLD9yF5/ODra3BSWwjisqk+0LaNnrOhY96eJBIOmf
	 kmFrgdpkYzPOEqor4yWsue5/SSjw1lw18m2DKJtptnVnYdGsbk7Wu6vMrUlynT8UgD
	 bvVWW8AHIyHrnqHmoFkaBxH0t5soTPx2W+eSwYhKvE4PwFp/PMm7rfnAIAyb6atvy9
	 5ot18378dDl58bAVyv4y7sQepP1swB7lm+k83bE+YNvFu+v1TyiNs3BkH7wOESfGyR
	 wEhjKXOaLkwRNyyCm/q4AUszA6ek0xbr4I68hIGm2X9Wu9BJy/nDECGvcLEQmuwwdO
	 knBMvSPprIGMw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 22/39] mm/mlock: clear VMA_LOCKED_MASK over mmap
 callback
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-perf-users@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, selinux@vger.kernel.org, kvmarm@lists.linux.dev, dri-devel@lists.freedesktop.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, bpf@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, linux-trace-kernel@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-22-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-22-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:38:20 +0000
Message-Id: <20260908203820.E26131F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Currently there's a confusing mess around VMA_LOCKED_BIT and
> VMA_LOCKONFAULT_BIT.
>=20
> It is permitted for drivers to set any flags they like, with the VMA
> already possessing lock flags.
>=20
> This results in the absurd situation of a VMA possessing both
> VMA_SPECIAL_FLAGS and VMA_LOCKED_MASK flags, which is not permitted.
>=20
> This has resulted in mlock_vma_folio() having a very silly check for this
> scenario to work around it.
>=20
> There is no need for this - just clear the flags before invoking the hook
> and reinstate them afterwards if they are required.
>=20
> Nothing relies upon this being set during the mmap operation.
>=20
> mmap_prepare is unaffected by this so requires no fix.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D22


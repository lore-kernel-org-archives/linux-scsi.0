Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFD53ABD88;
	Sat,  3 Oct 2026 17:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050211; cv=none; b=fkE7Ql5GKoMKduy6cS6p5GbKGjZc1DqVUl34GEMHckZRpbfTky9pfvUs8Y/JfcYek5n6GfBJBDyhYOfcK2yQ1JT9yc9NNOoQU9Smanpag91O+SBGhM1B6WluRrQaBMOQp9yRN3gsOaqYReQS+hmUpEPXenOf5dlnEZM2T/mCF6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050211; c=relaxed/simple;
	bh=O+VsZj4N/VkqVBY2g9BGjgn5Fpgy386y+4eQWu/+de8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=n7kE1656thmA92S2pMF5Sbutz5a1DiXQ2hGFsb81u8uNZsp0sl/bZgL2QolwBhAKtOCdFvO8owbC+SZ5KVShcn0tOU0UEglckwTxm44L2bZGv5im/Ex1a2n7IB8YR9oodLYfhcxlIjGuzAnWiBYeDKlMFR3ci2HViSb7Xnt59lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kifP9gYb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kifP9gYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98261F0089B;
	Sat,  3 Oct 2026 17:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050203;
	bh=O+VsZj4N/VkqVBY2g9BGjgn5Fpgy386y+4eQWu/+de8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kifP9gYbNt4dMtF7Zh/2DJ6SZJFwfAASX9y/jK/3eyKGhQIA/cBhxnrh63y7JrQx3
	 e3t/lMB+basqTEI3j7ux90JpLCL6mYPa3z7Jw++8/k/Idtu1n9ETb/TZWKX7uPgBKw
	 M2SemTVJ5kUxSdWmedMpEOno5+vAUjg90byy3mSa4rW/AVDQRPnDBmBOCy2UMZgmil
	 7J0x+gaU3UXv99P5DJj7LFwmpaq78ZEZkCzgSRxGrzF2HPeS5J69QvajJ4YOtJm26r
	 g27DzpxZyF/kx+3aM0gdT1IEse+Piiju4ez2wP4MdPj/woXwbAxmRqB3Xs6UlT4YSi
	 UsfI6nesygOwg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 18/38] fbdev: defio: assert FBINFO_VIRTFB, drop
 VM_IO, add VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, kvmarm@lists.linux.dev, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, bpf@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Vasily
 Gorbik" <gor@linux.ibm.com>, selinux@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-perf-users@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-18-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-18-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:42 +0000
Message-Id: <20261003175642.A98261F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Currently all drivers which use defio allocate system memory. All of them
> also set FBINFO_VIRTFB, other than ssd1307fb, however this driver allocat=
es
> system RAM, so simply failed to set this flag when it ought to.
>=20
> This patch sets FBINFO_VIRTFB on ssd1307fb probe, then drops setting VM_IO
> in fb_deferred_io_mmap() and instead requires FBINFO_VIRTFB to be set,
> erroring out with a kernel warning if not.
>=20
> The logic requires a page from the driver and since commit 1ecbc7dd2902
> ("fbdev/deferred-io: Always call get_page() for framebuffer pages") has
> always required it to be refcounted, so this was implicitly already the
> case.
>=20
> Finally this patch sets VM_MIXEDMAP, as the logic is mapping
> kernel-allocated memory so this is appropriate.
>=20
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D18


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2714E7808;
	Thu, 17 Sep 2026 17:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666809; cv=none; b=BCMc9fGuaoqkKLUGBUMoc+2s2rAZK2J4J0V22902OwcGC6L8q/xtae54Pd2Ww8pH83kgknIvVs3xdTOoJclTzg8wR3845T7jVxsfEpXuvz/dSH0PAKA8W+oUin2dPYTeb0oX2EMZmTCN2feUnK2VbuecguYNqJREtkNFxciVqsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666809; c=relaxed/simple;
	bh=kw8qtrhOn/PcO+7goj5HzYjavAR573Wgkq9tnhBLii0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=H1fak+83d5qs+Nb8ztZcrgPoEqjGIiDS88tnCigkqaj0B3q6S+FTBX/dpBJbfG8HvX3sPiHu/pW4EekffVXaQZ3/pp89HAm/RwV7I6hE2MBQaINl+0bze1PYBHnLcwBk1P4u+Q+bV1Ge1PtfD3GSyzcK4V+dxA3aRdlmbwMJ1IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CovEv7D1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CovEv7D1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D652B1F00893;
	Thu, 17 Sep 2026 17:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666807;
	bh=kw8qtrhOn/PcO+7goj5HzYjavAR573Wgkq9tnhBLii0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CovEv7D1higUoN+hUXawPFnAiP20k2YSsz2egl2hD+2mn94zeJ1oANjeE7jaKohUf
	 nETfnbchA4o+E1Wr0FeqkktKhXskNWHgjZRThDynRnyuXzaFM2cTvpBJCDE8f1YoEm
	 4vkP2R6IsFfhWjhOD6YE57Z3cJaFJuVl9V99XLgXDGd2m5jepK+U+TcYnsF6ubJ8os
	 e4R6LYrgaFrRKcgWpomZhSupF354DrlvAL/P/Zs4U7BQKiei1gQi9obiXdbn7A7oPD
	 B2AlrxAHPtzg0y/nvSqnfvzcL+g6p7RzZO8Fuzar+yZwjsktJnasYYljC5R8dMUWE3
	 yDA/ICqnTP2PQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 36/40] mm: avoid use of VMA_SPECIAL_FLAGS in
 migrate_vma_setup()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-perf-users@vger.kernel.org, selinux@vger.kernel.org, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, kvm@vger.kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-36-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-36-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:40:06 +0000
Message-Id: <20260917174006.D652B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Now we have the expressive vma_is_kernel_owned() and vma_is_fixed_mapping=
()
> predicates, use them to determine whether to proceed with migration. This
> drops the VMA_IO_BIT test, which is safe as only kernel-owned mappings may
> set it.
>=20
> hugetlb mappings remain excluded, as they are fixed mappings.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D36


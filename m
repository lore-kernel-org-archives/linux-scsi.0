Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECCC3B47E5;
	Tue,  8 Sep 2026 20:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899655; cv=none; b=aHx9YVJKcBF1jjsfKhnjLKYH3GiBJBWIiUwSyYrSOl/bqsfux5eKVnxiTekoALuOwSamanUEirTTa8xDXAwU6Si4SuntEhVQX1x/T6kcnDi6KKS4zUii04Y0CfTgW/CuOzQa8fU2GwSlcyqG9qT0ROym7md2P98mQpE1rGLEc4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899655; c=relaxed/simple;
	bh=vB+bEPol9wUUVJBfbK6MzyNE6mz3Befcd7ErB1ajxhE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ajwyf24Uz03RJigZjANDXfIwBKp6wLw2fPoiuuzMsq2E2Igfu/AquFJ4JOt8V2hnVbvvBZHfIbAfppZh/1VLH4nyP3En4c66dnLYeCT5syaP65RdQoGwzM7APtwqoz1IMIuvAYJvbVfh+3OEZA5xs934qhtKwZWiRvkk/H++CGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GuoTKeTJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GuoTKeTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1876A1F00A3A;
	Tue,  8 Sep 2026 20:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899653;
	bh=vB+bEPol9wUUVJBfbK6MzyNE6mz3Befcd7ErB1ajxhE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GuoTKeTJuepHEC1KRZlCLpDY/Wfs1aOd7bO5p4JlitjvSNJY2seFdousOt7ptjRCA
	 LFJEiDD+2iiht6Q5o3bAhJojTA4h2nDph82IDqjLmBXumZ7KJ3pgT4xnREtO5ywiRJ
	 btFrRQlKE1NlyGSoMCY7qMU71BrE1L83ByvJ0d6ibozDS2jl1/x0/mtixa4eKePue8
	 sLE65OByhF4muXMbh4wUnZB0P4aeJU4pxPCOySXzDAGZkrFzcSm5iEl3x0jusvqCIX
	 aA3JQlxnMGMrMmVWbnDCf5wCYaV7rwPqAUufMC/uP8tXOVqnUw4QqTuNTrmPrZ2npA
	 5go43qg7LXECw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 26/39] mm: remove hugetlb_inline.h
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, selinux@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-perf-users@vger.kernel.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-26-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-26-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:34:12 +0000
Message-Id: <20260908203413.1876A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> This header really makes little sense - every place it is included mm.h is
> also included, and the header itself includes mm.h, so it does nothing to
> reduce header size.
>=20
> It also oddly does an #ifdef around checking VMA_HUGETLB_BIT, however
> VMA_HUGETLB_BIT is unconditionally available, and will never be set if
> hugetlb is not enabled.
>=20
> Simply remove the header, eliminate the odd ifdeffery and place the
> predicates in mm.h.
>=20
> The naming of these predicates is odd, but to keep changes separate, we
> will address this in a separate patch.
>=20
> The file was never put into MAINTAINERS so there's no change required
> there.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D26


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D385E3B71AC;
	Thu, 17 Sep 2026 17:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666606; cv=none; b=Vl+ouKVcbbGsKie+oaVuJqxlOgg0wjj7QIvZCN1bho4zB/j/bJC6jbZhg3s4wkCPzJNSrpPnSy/m+oFj7P5gViqpLs7ZKC6373PMvgkQw3po48jxIV4DgJSimyV9gXtd+jxW3bgOAFp5VLv5vwZXlEzYVAfmy9bUEbTeMuXYajk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666606; c=relaxed/simple;
	bh=XJ0qh6at42huWEJyKoCj2nGu0zhfQ+f/MtIbMInQeww=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GR8KMiegVL5RU4yZ0fwLPWy6i9IwomZ6BQ4hKACXufB7PyBvGLoBbr8IYFv9AURbQzGLKdjpNH9FVDlwDn3pZa41suSizeltlHUzceY8EnmsMjTjPWf9SNiSxtezk6BUzBm9hs3p9nNJwNjiT8w0amDQVvpDVNebBAY9OuEB37w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CU5w8uNx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CU5w8uNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C2B1F00893;
	Thu, 17 Sep 2026 17:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666605;
	bh=XJ0qh6at42huWEJyKoCj2nGu0zhfQ+f/MtIbMInQeww=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CU5w8uNxxLZFLsGZ4LmrcTlWiHWiP+HGDxPK1XMovccbBuf94GKQ1wBxMj4zLuuo3
	 HzOY2E74gGXUaiuQgNnxNkGCNr2HIzQgGYrdmZiUVNBKKkIcHLoz6zMw6wjZXvs72w
	 WdBfjnTnm7YRH5XIN5co5v3l92cZxN+FaQuR197e0wsSes8Eg3ZJ1B3wVyAwZhYgqn
	 YU43/aXCMKMd0jrEqllYbG9ikYMO2KMs7+rPbEm0WA7CljJIvjiR+huPTD+T31uC43
	 QKsg6ByY9FHAE62U4X727mj2arbAqHgrBwRanzRbShKy/rIi5H4GqY8WRqjf3sAQPv
	 dWdO1BFwlNPSg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 11/40] infiniband: update hfi1 to use
 remap_vmalloc_range()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, "Alexander Gordeev" <agordeev@linux.ibm.com>, dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, bpf@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-11-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-11-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:36:44 +0000
Message-Id: <20260917173644.E3C2B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> In cases which map chip memory from vmalloc()'d ranges, the hfi1 infiniba=
nd
> drivers currently installs a fault handler, and then smuggles the kernel
> virtual address of this range in vma->vm_pgoff.
>=20
> This is exposing KASLR-sensitive internal kernel state in the VMA, and is
> entirely unnecessary.
>=20
> Instead, use remap_vmalloc_range() to remap the VMA to the span, and
> eliminate the fault handler altogether.
>=20
> remap_vmalloc_range() checks that the VMA does not extend beyond the
> vmalloc area, and the driver already requires the VMA to exactly match the
> span of the memory being mapped, so this has no impact.
>=20
> The memory is all preallocated so not having a fault handler has no impact
> [ ... ]
> There is a change in behaviour in that pages mapped using
> remap_vmalloc_range() will now have normal GUP-able pages, however this
> should have no impact as there is no reason not to allow this.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D11


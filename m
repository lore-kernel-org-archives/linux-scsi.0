Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AC941A547;
	Mon, 14 Sep 2026 21:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789422277; cv=none; b=tv+aVyzTNYPgV+db7tObRuA8+ExZtzqdmdR9JIHkimpVtAzaOFANY0HMS4cdEjUGZLckSrIj7qxb24L08DhOb40ZeAs2bFcjuxTXa44UEMw4rtSkGWT1oN+ZZoHdFUz1YXXkAbRgQE4ydJLRQKGopQDS0n3I5JDncmwHQ9uo0GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789422277; c=relaxed/simple;
	bh=VeZJkxS52Dj4SWyIayGwjQWKW6AW34H/B7QQpUI0MxM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=toeTdlQ+8JaMK7V/esCh0CtydF/Q+gDinvsHFCgrwnI6RNPXxm1/8vQywUrQfkoYdg5yq3/AJfw7Jzv5PjCMnocUcJWtdOB4HtsCvXtl8A/2XI+Oa9p0QncoPElCkSp6TsXl3/YoMiNYdDrWhzEX6f6SAI2uBWW46Re1o4XWudM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SLO5ch0N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SLO5ch0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AC31F000FF;
	Mon, 14 Sep 2026 21:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789422275;
	bh=lJQdkE1hGp3WpIdWGndQZAcOkc4mf6EeWvmOa0CrHV0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SLO5ch0ND1pxjlZaU6j8c06PyIPpVI1f0qkkDSUKmcx2BT6FIPKux1TX+gNREBdM7
	 2X4O1Z4eGZSw/gkvjOXg1xTzmwSpUYdW9Wu7+9rV7rgizcCACKtt2squwJKYa4jC/C
	 R0/8SeaH3x31sbV2a9sBkve/wiA3XGayT7bqzcB+dOmKxfeVpA/Up6mJQPHsc9NUyC
	 GR2Pd3pHT290kJ12c1iOLZSWV5ZqRU616YZSxqvBhf27j2TrtpqhAnnjRQHXFNQKoT
	 UILJQBfp/x1Bni2LlEy6cpUcpEx9k0gwsMYfWYe8Yxk1a+AnuXnvUpYjm0kQyBgNyi
	 eXdCNGl4TkMzw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 24/40] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, kvmarm@lists.linux.dev, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-24-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-24-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 21:44:34 +0000
Message-Id: <20260914214435.14AC31F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Casting `bool` to `void *` causes a compiler warning/error (-Wint-t=
o-pointer-cast).
--

commit 5ca9abe89befb83b06ebb688a6a1ab1fe25a4e0e
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm/mlock: eliminate weird VMA_IO_BIT abuse and simplify

This commit eliminates the use of VMA_IO_BIT during mlock/munlock operations
which was previously used to prevent double-counting during migration. Inst=
ead,
it threads a boolean through the page table walk and temporarily sets
VMA_LOCKONFAULT_BIT without VMA_LOCKED_BIT to indicate a locking walk in
progress. It also simplifies checking for VMA_LOCKED_BIT across various fol=
io
locking paths.

> diff --git a/mm/mlock.c b/mm/mlock.c
> index 39215a3eab1fb..4235a1518fc9e 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
[ ... ]
> @@ -428,31 +417,29 @@ static void mlock_vma_pages_range(struct vm_area_st=
ruct *vma,
[ ... ]
>  	lru_add_drain();
> -	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
> +	walk_page_range_vma(vma, start, end, &mlock_walk_ops, (void *)lock);

[Severity: Low]
Does this direct cast from a boolean to a void pointer cause a compiler
warning?

Since a boolean is typically 1 byte and a void pointer is 8 bytes on 64-bit
systems, casting directly might trigger a -Wint-to-pointer-cast warning.
When building with -Werror enabled, this can result in a build failure.

Would it be safer to cast it through unsigned long first, like
(void *)(unsigned long)lock?

>  	lru_add_drain();
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D24

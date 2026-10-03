Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62E33A4F59;
	Sat,  3 Oct 2026 17:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050195; cv=none; b=F0bvbYK1DLGfojKI9R2TKkk/M8RcB1GTh2KtiJCH4P4GEbJIR/PATPhM8FKLSsdrI3Hytj3p/UIrttkDqNV4vkum6O0YphP10MbQQn73qaFFWXAGdfS7Kt4Sv8Vxq6gM8aps+v5f/YftmZuBlFYY4IrnlJf31yFc4tjBNlfYVes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050195; c=relaxed/simple;
	bh=NIhBk/SRDFS0I7lVjccxNBqbONvSO5gx+1RJrKtAPc0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=K7OVTHXMC8mnu+EZ8xREgbLyqYNrvRjnXxhK4BIlIoiRORz3aR7ckh0CZeEejEwgH1VWsZSgb1Ttpfy0Fq0RCzvWXu+JdmedWDMhjf7LRfDRPdi1rY8TRj4E/bxXWBEQ6dRkmCWYPOAxk4tDGGaT5HmkKyv9gMxJ1pyPqXoNpBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j2vsTkrT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j2vsTkrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06591F0089C;
	Sat,  3 Oct 2026 17:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050193;
	bh=NIhBk/SRDFS0I7lVjccxNBqbONvSO5gx+1RJrKtAPc0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j2vsTkrT+q7iwpsTHIbznytwjucZ5dNclWGA/WSmmJGNKFc6WqmqUyZbYHG2AK+SO
	 Kq76PE/BADT6pLr8pFpzlw383x/yF89J6aOj/ocEXhrQXAFpa0snbJ638UYV5EycZH
	 vQ+Y1JcsLleu5tNKmxOCMyM+WM7yWtvss4VUhbtUjZwzgZO524+OoIIxkcHyAqXWsi
	 NM5M74uUZGWjjd/qxBRZSQcOYxA4fCVCB+/TUlfaklBjXnzjfz3uW7wKwqH+BpMy6A
	 K9CXO3FClHR+tAgxQlsM89c1JURjFuHkbaMiw5ftAYTQ/a50cxn4bdvfKQ7kXzCx9/
	 yURgXC9MZZh9w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 06/38] mm/vma: tidy up map kernel pages enum values
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-s390@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, kvmarm@lists.linux.dev, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, selinux@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-6-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-6-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:32 +0000
Message-Id: <20261003175632.B06591F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied by
> MMAP.
>=20
> Also while we're here delete useless comments for mmap actions whose names
> clearly indicate what they are for.
>=20
> Also update the userland VMA tests to reflect this change.
>=20
> No functional change intended.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D6


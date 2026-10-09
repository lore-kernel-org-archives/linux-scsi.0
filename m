Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5174FE2F3;
	Fri,  9 Oct 2026 18:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791570274; cv=none; b=oevrRCA8Ds5OkXftr72Rr9FdzdXPiWomClUtkeu2aFYRqqQ2ogmAQM9yDwvjkXloa+ipkk2Mc1xIFqhne887yPsmDUTD/Bv2+PoanVHeLXTOsfEmM8tcRnIxT7ZEXmsQaChUB7r9lI8NaXIntjTf8DHRjOrCe+MnYnWvTlyhHLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791570274; c=relaxed/simple;
	bh=Gw8OAT1acDkqFZ/hXt4p5IlqMtMgDvYZLqnlzn2uBx8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=RxJbeDNM+jedd/DW5VvGVnhRHre59qhBuT2EYDCaZEeZ/QxbDHiAr/dbPYO9yQmjSbq/F/0uCsGhBstEl2yyvZL6K8AuXuNt1ann9swlDtE/N29G6Y5clUaosftEell6yXzWazmlrUXp7Q2g3RkUPvfD47N5plDdiE2bzMWavlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XYclpwE9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XYclpwE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650061F000FF;
	Fri,  9 Oct 2026 18:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791570272;
	bh=Gw8OAT1acDkqFZ/hXt4p5IlqMtMgDvYZLqnlzn2uBx8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XYclpwE9jKqMwXXOuIOrb1ZsOG/gmJ/C/VzxUZAU0iXHyon8QNrmYPuh0HfDASpOk
	 Dzt7gg7AoN6r1ACk4blftokMOco6E2GzB8mvFl+v/HR8WVOgkUKiI3npbrI815eB2T
	 qtd6sfewr4XfniKoUWbelFFQDZNfKn4BG+haaPZYVfscJaBHxSSnf1yQyRQHNd6Thq
	 mKJbpG1CQQbMWZYPl9r59REFUEeqjq9bww6zsqqXE8zN+2/iTREAdeQ62TGpYCyNsg
	 oCuDMqgQU3KC2ixMwt3cvwyYmGr1MjYi/w85+qvmnAsqjF73sJycrkCcIqWI0IUHi2
	 MmU4i8QlL9Dtw==
Message-ID: <sashiko-outbox-165939@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 01/38] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-perf-users@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-s390@vger.kernel.org, bpf@vger.kernel.org, linux-usb@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-1-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-1-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:24:31 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The map->file_doesnt_need_get flag is confusing and the existing
> implementation has holes.
>=20
> Drivers are permitted to change the owning file of a mapping. If they do
> so, they are required to take a reference on that file.
>=20
> The mmap() operation which ultimately invokes __mmap_region() is guarante=
ed
> to drop the refcount for the original file the mapping was made under, but
> this is not true for the replaced file.
>=20
> This has been addressed so far by tracking map->file_doesnt_need_get, whi=
ch
> is rather poorly named and unfortunately fails to correctly track whether
> or not an additional put were needed in a number of cases.
>=20
> Make life easier by removing this flag, and instead drop the reference for
> [ ... ]
> currently (no driver that does this is mergeable for one), so this does n=
ot
> need to be a fix.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D1


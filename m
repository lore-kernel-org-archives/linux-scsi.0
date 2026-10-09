Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36BB4F96AD;
	Fri,  9 Oct 2026 18:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791571806; cv=none; b=BQuJfgWT1JhWZzoIC5eeI0EiPtyTBazkUNooxpe+3EkuPGULwZfXFCYlejNMU5gB3Ky4zxLZMiieQXf+YOQc6atAzldwV24YAvjYIxyjocg4g/PUkuU1BfVTmFMqrdpO5YefLE3OzJUIOgx1lvkLQhdV+KWFV/9z6dwq6v9YULQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791571806; c=relaxed/simple;
	bh=Enmdzzj0sP8U+nehEBpABhud7J5njQLUQed3l3DuJ2w=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=mvtJZcv8D6zskIhgGrir+6LPPSKQ6jqAWo16BwDHo1L//I4Xjb9cJup5o7QEGFkM9Sz6/bhA54lD0M3gCWzlU0C/gzxXRTCrfbX4nwEu28AhYY7hspP/F67Uj2CYbbbIbdXvQU+xGBf2wzulcApg5DnQotrrqYMmUnBefJGXuZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g6Ohof9q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6Ohof9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6434E1F000FF;
	Fri,  9 Oct 2026 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791571804;
	bh=Enmdzzj0sP8U+nehEBpABhud7J5njQLUQed3l3DuJ2w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g6Ohof9qHl8tFsb7i5dHYSMyT9/Dj/MD6eMWnehlErSA2yf5Bn93DKoTT502HVOsc
	 1gJEHcbFYg4+JpO4MOzXLOBapnopIBQUXeiUcQh37J33r+YQoFh9VPBYw7r5KPDFfK
	 K9Q2H6ulqq1EQHnXj3vaG+jJuikPRaSYtFpQjLk9/ZEJp+DgvdjZvm/bcVTfOtKJbW
	 BgcZwoIgTu/4HnZKXglDyUB2RzWGTHr36mKLVqH28XNcZw5/B/C2mGNlqUgem6FNNZ
	 nZjs56FOSB525VRVUCeL2De5HoxIb+Bge4x4hfctEjNWmMxMjKt5MtFvbvywPWQq2P
	 dMV2p6aMTcBhQ==
Message-ID: <sashiko-outbox-165982@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 35/38] mm: avoid use of VMA_SPECIAL_FLAGS in
 migrate_vma_setup()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-usb@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, selinux@vger.kernel.org, linux-s390@vger.kernel.org, kvmarm@lists.linux.dev, bpf@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-35-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-35-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:50:02 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Now we have the expressive vma_is_mm_managed() and vma_is_fixed_mapping()
> predicates, use them to determine whether to proceed with migration. This
> drops the VMA_IO_BIT test, which is safe as mm-managed mappings may not s=
et
> it.
>=20
> hugetlb mappings remain excluded, as they are fixed mappings.
>=20
> No functional change intended.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D35


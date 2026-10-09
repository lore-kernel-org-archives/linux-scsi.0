Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B51503BF2;
	Fri,  9 Oct 2026 18:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791571143; cv=none; b=mVfEDLmLWrH9W64ARzVXTZHlFVlQdoruRc3rQ71FFQ2iDUWx1KtlAC+Kem8oTpbmBqSehzbYVwyY04aMROak02aZLGP57yEBNlrzIMr/pl4YgPcUDhsVPk1dgRNm4q/7FA48c0fbXfpqkbZ/RZYkPls5yWcSjl0BiIBkdYl7a6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791571143; c=relaxed/simple;
	bh=XvSkH/vkDzBCc6Yy8pr97AcLVmOtcCshhf7Oxisq2Qg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=LD2xJ+xs9Q/5OqLgMszolfJBxcGGj5DGYMk7pEOX1JcY3BEh9tvOKyn3vdcaBGHNVyss3eIHZ3TIOU8DXMsz3iQtvJ0AgnJOtQkT4p4C+Q1a91RBIaetY5Lzd2BiDy2QnJ9eNOLil5Uc1aoFdhecUNvFmwGZvngWrGYHZQfpnWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CNiqfU0+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CNiqfU0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F531F000FF;
	Fri,  9 Oct 2026 18:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791571140;
	bh=XvSkH/vkDzBCc6Yy8pr97AcLVmOtcCshhf7Oxisq2Qg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CNiqfU0+XQz1FN52FxePWCSUPhMXxOlq+mzLafif7EQRjvexDQ2BO2lwDBBBqpkFp
	 LdvOBmzuXtknKNZpNfsKYHu/MfJ8ehCM2uQ1XxHWT2vpHHJIV6IPLoNFaUc7FvH3nw
	 WpuYKKm91z+54yCqanQm3bF01ROuuDAzJk8/lfkUHLHCsPtZP4eSIxuWAxGlqdiyuM
	 WNb9nJjYZGNI8Z9J8iNeqo6WInTKtlRgzIgHNncGtRSOe45AJr/Y6LJPuN4HP7wd8y
	 3qtse4BIAR9YyOPYQbbYvye4G9LsnxnyzaDdLqiFCoiDyz1DBYYFS/tmuHppts+xk8
	 ncqXHBNVNhYuQ==
Message-ID: <sashiko-outbox-165958@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 26/38] mm: remove hugetlb_inline.h
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, linux-rdma@vger.kernel.org, linux-usb@vger.kernel.org, bpf@vger.kernel.org, selinux@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-26-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-26-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:38:58 +0000
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
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D26


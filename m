Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34111518155;
	Thu, 17 Sep 2026 17:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666227; cv=none; b=MCTumCd5/TLcmwP3aoGMzTDbPJh+eNtEohpHY6wOQSr9QszEdohhXB5LRMZDYa72/dDZafyQ2HaUiLWecVfmFAQCetQlTEPIM3SHB8GU+pDvELIfwe5/BG1/OQ1yTyV3r/i55Z0Ngtbp7+mWf51o/To+cqy/L+2Hp9jGQETuRdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666227; c=relaxed/simple;
	bh=M9HWNLmcokbHcx5tP6s2WGauskJmJ0ymgWt3noQKw6s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CrTFlhDwM1S4yBdzB7iWv2FcS7bF8PZaDNHzyu1kKbpB8t1AIvfbSgt2xkagZa+0jYdBWSiXtwSxzPtK70iLtASgAHItImnZcFm/qH7WypbVKWIf6owSXC1Aw2KY+pSvRlHSmfbI/61LqvyKIcPmYLhqJMN1+Kvd4EEnBTGX5U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kcSXwmdA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kcSXwmdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332341F00893;
	Thu, 17 Sep 2026 17:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666226;
	bh=M9HWNLmcokbHcx5tP6s2WGauskJmJ0ymgWt3noQKw6s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kcSXwmdATUiFkE0iOlC86lEL3ZjFlVsTFYqmlaFHsQUb4mQ7ZcBOSDs7VVySqGftF
	 suM/NqVkyb1F6Uz0tMJUjaeun7gwyEqYM+5tQTU+6V9b5fj9cTVRSmEHLBAPNJwsSF
	 6zGqIrMv5KIqSQcsT+I5iqGsBNoiPQJMLUUX5IQrN2U7M7srBjYunmH09ENIl/WX2P
	 Eo/iv9OAUt2UIJEcKtXlQJLuGd6mUgu4RHn2J0khpLM7PSCzLwcb8WaGt5Qb9pHLlD
	 r273VHiN9OFWs/lcFsAyERfjkCky15S2fWYybblF0Vpspv8TVtrYbLhUoyo34waga3
	 hzoPhidInbpGg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 28/40] mm: rename is_vm_hugetlb_page() to
 vma_is_hugetlb()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, kvm@vger.kernel.org, selinux@vger.kernel.org, linux-trace-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, linux-scsi@vger.kernel.org, kvmarm@lists.linux.dev, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-rdma@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-28-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-28-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:30:24 +0000
Message-Id: <20260917173025.332341F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The is_vm_hugetlb_page() predicate is badly named - the mapping can span
> more than a page and it is inconsistent with other VMA predicates that
> typically are prefixed by vma_.
>=20
> Rename to vma_is_hugetlb() for consistency, and while we're here update
> some VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA() as to avoid unnecessary
> oopses.
>=20
> No functional change intended.
>=20
> Acked-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D28


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F7C4A4F1C;
	Sat,  3 Oct 2026 17:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050241; cv=none; b=aShF9FsX0HyNhkmUDPWvWFK8W1EAikzfadLlpHbKTla519GY3qy2+wYR1DZCoSGvN4AOu/42RfQs+OprJlkEEIQsh/UIbyrBsqPsUG/ppLdimi4afliuUgCqZIi+R4m43GaQ7bwBPsDE06k7LyBdHZndf5K1OSkdmCMEgMpdnAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050241; c=relaxed/simple;
	bh=DBaEZLeORgCi7ZNKkb2bttUus6/jcwyebZupu2FrDxE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kMo9v7sBbYcuITq+NCQCKV12OWaKN6M+xkIN0k9XpZGAZ4HXzdrIDGmZzilKC0quRLWcPYqYgG9uZhHPwtU80cA3p2sohQjhzvLqpgQ/tJ0BGxpG07O4hNE/Sqij5Nozy0izVi/b9QDZm4SCI8sVcJRKTfsFzpx8gnNavPqG4js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G7R5W+5o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7R5W+5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804691F008A3;
	Sat,  3 Oct 2026 17:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050239;
	bh=DBaEZLeORgCi7ZNKkb2bttUus6/jcwyebZupu2FrDxE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G7R5W+5oTk5xv0YsoKXnGPkj0s7JOOQJhOd9Ux7YUXcVkp7Qxtts9bngS/2sEJBG7
	 dAXAfk4hLIZB+PiddKg6PDehXM1BENa2k1BItqZ2/3TDQYbKisf3BMRPMKYccwi8YH
	 C2+yw5oP8+yR8EQ6/iOR8LmsoTTyoAepyWcP/XmnlQkdA9vcg5MDpAsR7GcpiK7UGF
	 jDmrBmJJFa7yrmU4EoKCuBsOhNkfRZfgwkM3A2mE9DGTBLf0IPDcyzveEEgMEfNFgK
	 QKpa/oLV9ScRR2skG2vX7PHhCOkFUyA36uVkj+BlKMKEs9zR+h1fbpRYDNNzY3RRXO
	 LlD6ppcZ9h42g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 35/38] mm: avoid use of VMA_SPECIAL_FLAGS in
 migrate_vma_setup()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, linux-rdma@vger.kernel.org, kvmarm@lists.linux.dev, selinux@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, bpf@vger.kernel.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-perf-users@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, linux-s390@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-35-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-35-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:18 +0000
Message-Id: <20261003175718.804691F008A3@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D35


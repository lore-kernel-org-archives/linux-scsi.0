Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7933AF675;
	Sat,  3 Oct 2026 17:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050216; cv=none; b=sJcTnp6fxp/URriIBnS3pTMFfrK5+dhtrXIkY1uZV/JdXl8oDG2RUoC4cFzdvSjj//U1LVBMKeMXg2KWlPCaWzK9eizL/H9rLTPvf0F1YjkONaqlD96wosgqd4ZFMXltXpQI/6ihBZLdIhGXEy3sA6/zfM/GYj7nA0HAh7E6HbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050216; c=relaxed/simple;
	bh=FYSeoaYKVtU0vhuuj0pQEHfWbUwBZqIQzddec+ndTR0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FejLQOjZpR3MnbshiaUqjeazxahIKWDFMjDaYPEITKFVmPFydhtubicjU0RcaXoJ2Nt/p69X8RWzYKdFsdYPgyRFXAVdjRDo9cJ7WiIlpKU2jXVbSohkFoiN90zNTCuJS5hd5oi8Ads6QLObHSM2VBxf/7oNt5vJVRdnExzJsTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQRQuIMP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQRQuIMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B931F0089C;
	Sat,  3 Oct 2026 17:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050214;
	bh=FYSeoaYKVtU0vhuuj0pQEHfWbUwBZqIQzddec+ndTR0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PQRQuIMPJX1lqsvSVopu7aRxwaUpt3azpHRSHWtW78CHPAIYk6FgD+fvt1iiMvmDY
	 Z3g9zFQLLP+3uW7LWcLs0kfn3eKr1V+2JtdJONweVFUTxVrpEzP9pJAHCLNzxKEXyP
	 ZwFYFgf1YyhoA+G66tGoxSvkdMyz6fsKZicbD2V4KU+MBN6ZZmPV52iSwsB+EUzgfD
	 k3Ds9dV8+CLDZB9vj0Y0GufX46udfzsSBdsT7fCRvvnhyLNCfPJk/urONV0fDq0Uqo
	 wRf1xa15Wbxrt+zKs0L+vhF1eEnPzRNIWSvK0JT1tcjZG1bKw3rZY6ElVAYivPsW5i
	 aDRriPKtr9K+A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 20/38] mm/gup: error out early on !VMA_MAYREAD_BIT
 VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, selinux@vger.kernel.org, dri-devel@lists.freedesktop.org, kvmarm@lists.linux.dev, "Heiko
 Carstens" <hca@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, linux-trace-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-20-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-20-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:53 +0000
Message-Id: <20261003175653.F3B931F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> When populating a VMA range via the aptly named populate_vma_page_range()
> an unreadable VMA will always eventually fail with -EFAULT.
>=20
> That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is no=
t.
>=20
> All user mappings always have VMA_MAYREAD_BIT set, so this check only
> impacts kernel mappings.
>=20
> It is implemented specifically to disallow population of uprobes XOL
> mappings which are exec-only.
>=20
> A nasty interaction with these mappings may occur if they are mlocked, so
> actively disallow this early.
>=20
> This allows a subsequent commit to remove the VM_IO check in
> __mm_populate() which otherwise requires non-MMIO mappings to be wrongly
> flagged simply as a workaround.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D20


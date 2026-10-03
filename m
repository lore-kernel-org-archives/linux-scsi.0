Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310CF439354;
	Sat,  3 Oct 2026 17:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050213; cv=none; b=boV2JuzZvgphFgQRTqn/L3EnliDMlWFnSrkSWsXCrkK6kyeFFpZoacB9jPTCZPfPzIRseuCOSyzNGeHSn9EHLLieOscqjPR2q8Pj5I5ASl4rtCHJqL3CNGrNDxRkAvO9gDj4yBIz9qM9aFwPqJyCeNEWTg2XRaht5v9p/RYMa30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050213; c=relaxed/simple;
	bh=ClYTsswbCIYbM/fmgQqIBazGgbYk16TfuG2VPiaWPh4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aI8P+TMCAAN0LB95PrCXO8q3oM4QrVRO/PgxciyyvmsrB0FZxg9wNwB+Xdms2scZZamszXHxmOe7egDpLbfFk4OsOCHzWB+9YisnJaWWTWiUO7DuMEx1gr97tcUyidPlW6m2brFMIqFtBgA4s0q1/xM5J17aADv0puTVViWA9dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AtPoWp0k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AtPoWp0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87A31F008A3;
	Sat,  3 Oct 2026 17:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050212;
	bh=ClYTsswbCIYbM/fmgQqIBazGgbYk16TfuG2VPiaWPh4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AtPoWp0k81qHL5dl4dSTYDDE0BL6Ds+3ki5psRrwl1I+RXjU3o8BMBrjCZ3t+m+II
	 KgmB4/xIVMRT1g5icXqYU5BkHyZ86OvSjVclntoNjx6ItRdosXIM/DF6qkhz4QJBJ2
	 r1PsDohA8J8BmCSvan4Z4jeA+8JLxNLvxRuZDoJHorpKwKzdGvBZR0PwDdyeKqtOQI
	 g7ykibcSm2/dFEvo8kfiGW91+qy78EyfWnYSWh/IUjoNt3x7R/76lxNMdjCenm8WRl
	 0vO4sas9HnC2FRFMGasiBDTQlP5DNTtdK8iKEFs9nFVx+pQ1wRHNWrpQ3/NVPsAlAV
	 YBbh8qcLVtQYw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 27/38] mm: rename is_vm_hugetlb_page() to
 vma_is_hugetlb()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvmarm@lists.linux.dev, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, bpf@vger.kernel.org, selinux@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Vasily Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-27-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-27-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:50 +0000
Message-Id: <20261003175650.D87A31F008A3@smtp.kernel.org>
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
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D27


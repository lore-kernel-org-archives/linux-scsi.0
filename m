Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E841F2DF134;
	Mon, 14 Sep 2026 22:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789424584; cv=none; b=T4vwY2Mo9Z3b91/Q/st4LxGjhmXWkyGI7l82B30ANyBYUz+cwOUZa52avVcUEh1OL00E0Qw+b8Se4tBJETbFxoUCvO+8Cft5NBoBJ5xfTepJ+2XL/qWV+Q1k4kGpIyqM9G5ztgGcj+a0KicpJ4fIbO0LweA6+eRUV+oS7PVK05M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789424584; c=relaxed/simple;
	bh=c4XH58/I7392Xbk505A1UsC6J0SJtiYPHplEBssQvpI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lEPxROIUZ1+QUvN1oTKfCt3gUcrBuiJm5e5r3QRpSV6W/L/SVTl6Sgw/AZTBQXZE+rZU1cxc5OC459y9XSWOSzYhhIedE4zTHtHMRmbqCqTW+yXxHCzUHYQxSNq2yrHS0nvb6V5Geg0p1tw6lSWJnmkEmjvLanYObBGRlSxuc1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OfArqOFi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OfArqOFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AAE1F000FF;
	Mon, 14 Sep 2026 22:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789424582;
	bh=c4XH58/I7392Xbk505A1UsC6J0SJtiYPHplEBssQvpI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OfArqOFiZJRAZCBve6VPTmk2T0X8YczKKSzCSjfUxEB1i70GQjj2FTxFIiqCz3dvh
	 szRaPChmWgbuj1efViCjHQuQ4R1jcMH8QycYUAYLVc9y/1QmB9RwbImB5KlenS7Nus
	 TtdR4+UhVdvO4BNWuQele3uMIAmVpCGqV4C6Hw9MT6I3Q/1h3ntdQwTgtzg+8tujr8
	 EhV/j18klnflUc/2/txROQAUsoq2cgTK5ZwxQPYwXfpeembS6HNJ4pgfsj8anWt1jX
	 TymusSkPJXTJwvipaYlqrIQjCyRpMb/1iDUAt6PCY7gxFnHfufJZT54tIixj3TLAjo
	 xzozslx3mIoBw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 36/40] mm: avoid use of VMA_SPECIAL_FLAGS in
 migrate_vma_setup()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, bpf@vger.kernel.org, kvm@vger.kernel.org, selinux@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org, linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, kvmarm@lists.linux.dev
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-36-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-36-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 22:23:01 +0000
Message-Id: <20260914222301.D3AAE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Now we have the expressive vma_is_kernel_owned() and vma_is_fixed_mapping=
()
> predicates, use them to determine whether to proceed with migration. This
> drops the VMA_IO_BIT test, which is safe as only kernel-owned mappings may
> set it.
>=20
> hugetlb mappings remain excluded, as they are fixed mappings.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D36


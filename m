Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6A24FC8E2;
	Fri,  9 Oct 2026 18:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791571932; cv=none; b=ax/ILKhToW7JgZmRJbCHG/sy+WXI/phMxfV0upgDBbIoRAmYTUgXwCfm9wPk67mB5w82zpvShDg+ZpJJZUjRtHn9uDbO67MAl75UbplRHYW1JO1BHyb68HHJy0WvO28EU0dsqX4rzutImhKkRF8hlALXw+6zPWPdOrlss4UGDQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791571932; c=relaxed/simple;
	bh=iS6gRDNVxVdWwjfR0EFYGfvTS5rkURkUxECDqrFlPrs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ZzgdBiYroPSQetqFrOjeZO+GJIrczOL+J9N5D6moaj6CIfmzxXzmGeahMtjo+5a9Lx/Pal11el3MdKsyjBvzozYvVKNOFaRsqJnFqOLtvJK1s2IsLJ4tWdBRd4pPNN3FznHFVgew/VCho7ys4BduNJxoJcWmj/VejPHt//LYum0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j2NCh4jg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j2NCh4jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBD01F000FF;
	Fri,  9 Oct 2026 18:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791571931;
	bh=iS6gRDNVxVdWwjfR0EFYGfvTS5rkURkUxECDqrFlPrs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j2NCh4jgs2Y4S8aWErXY5aLYgPFNf/euPSNPQbIC/vHAKPppC4cDfTN8BceM8Zoqc
	 eQNVyKcjXdjBjsIuz8ewFbTsgAfzaUa+7GLROxrnEMKEdEmYPxwlzKPWgjuXIqBS9J
	 heEhaR5G/+qfLK4nX7AZWDGVBpkjfOMwlt0jJqyfQZMznhdgbZhZlzXaDsQ9Mob7fR
	 COXx8eU+iKRvxVKtdab3GgGkyo7cpiPgnjbXb9r4D/V73EigZx5vQYoS/BGdu1i+/B
	 eMn+gXDMUGd93t6/pH+LDLz6sI28FMn6O+UOkAfhUHSmN0R2lSKE1xCrrIvN5uB0As
	 jbDBAVTpqlnTg==
Message-ID: <sashiko-outbox-165985@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 38/38] mm/huge_memory: remove vma_is_special_huge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-rdma@vger.kernel.org, kvmarm@lists.linux.dev, linux-usb@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-scsi@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, selinux@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-38-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-38-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:52:09 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
> VMA_MIXEDMAP_BIT is set (i.e. whether the VMA is not mm-managed),
> but with a DAX carve-out.
>=20
> DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no long=
er
> required.
>=20
> Therefore test for !vma_is_mm_managed() instead and also drop the
> VMA_IO_BIT check, as it is now redundant since it is enforced that
> mm-managed mappings may not set VMA_IO_BIT.
>=20
> This also eliminates another overloaded use of 'special' within mm.
>=20
> No functional change intended.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D38


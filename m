Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B24A4D17B4;
	Thu, 17 Sep 2026 17:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667084; cv=none; b=dwoN9xXD+Dto5egh2Q7a2FgAb0P43jbcEAKWmS+cdWljBzzhC5SjVPkpa770BUf6/QPyJUxuMESWXJ745I8At+/hBRcX9shAjmJ5I/nmXeKRMokxmHnhyiITB5in01IKuSuvuxZpNkScsbinvUjFrMpPF2fNDXLLpuFaKYUFJXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667084; c=relaxed/simple;
	bh=bOLX5ZIt85Wehm+S/ctj8x4KFEci3aDFtZl9D7sbGF4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bBqtYo5jRTMtuhRhb8UOFfpAtSANOCVu8+hcLZQYrsn5HS5BN12oxdycUQxc1/i0UaC8ZB04obvY4ag9pSGUHSb52Jc9iIjzByGj6Mg8h/r8PftHIykXmol7T2jqqpGAIWjP/xa0yQkamly1n9/HJc2FwOFLggCB16PS4GQ8+nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYJD4w0B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYJD4w0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E671F000FF;
	Thu, 17 Sep 2026 17:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789667083;
	bh=bOLX5ZIt85Wehm+S/ctj8x4KFEci3aDFtZl9D7sbGF4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LYJD4w0BXe8i3saYW8Yd7W0JnFONEfC0+5OoOwuCKELG/BV3vFWzaLwBKoVewFfYi
	 sQpJ4HMiWXqZkykwzKj2MSVlbzj1iRlzRTo0GX7CnzESn2uqzpd7m4+oivlk/PLvDM
	 7LC0WUg1nZx04a1shcupTt9K9uh0y7m1DlCLvi1oJ5OtyCiajKKKpwT01AWYnln57b
	 7aY2sbcvheXsLNVanbNzIx1XYo3p9iXhpam+PMGeDPKeO69zYx/NO57JuLwAyNnKQY
	 deiSRJDStCLB0GuJ3T4BTUqlFp9gLgEaTZN+0OXy/8pgfmF4tu9oXgxm5IPX8NgNxu
	 PVfwwTSrEFtLQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 37/40] mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, selinux@vger.kernel.org, bpf@vger.kernel.org, linux-rdma@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Vasily Gorbik" <gor@linux.ibm.com>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, linux-trace-kernel@vger.kernel.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-37-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-37-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:44:42 +0000
Message-Id: <20260917174442.B8E671F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Every user of the VM_SPECIAL or VMA_SPECIAL_FLAGS has now been converted =
to
> predicates which explicitly express what is actually being checked for
> rather than the nebulous concept of possessing 'special' VMA flags.
>=20
> In any case 'special' is not so special a term of art in mm - it includes
> VDSO/VVAR mappings, special in the sense of vm_normal_folio() and probably
> other cases too.
>=20
> Therefore make things less special by eliminating these now unused flags.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D37


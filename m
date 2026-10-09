Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550FF43CEDD;
	Fri,  9 Oct 2026 18:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791571613; cv=none; b=rKpskITvnLIZ2Jieu7T0seLKreRby2oFgh85fTkf/NaVFBIJEHS/NNBF6FVoXgRedWjja5Ytqta0+KHXAcB9Is08yfFzMYQE5BXrWUEjaGegPICSlo74acU9S+xdy2j/2/nF4q5pnXITeUSV9Re66uKB/G04vJdMKhYmgaCDHRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791571613; c=relaxed/simple;
	bh=HFKBoDKgPdTwbnYnYqRFjYpZs2q39uFT5lOGj3Ocqlo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=H9jp78fiH69QahLZCoSew1JKXDx8d65jhpY3sxIFh+7to7BA50NRTgrLORB0cIBTeEE8SDUa2IwWb6UlShY53OjW6vYpG22+20IH11GJNRoyEk+hEk9G4iLEWz93h2329095yC5cyX0oWM/xd+k+ojkiK1/YzxdovRrXBUu9QiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EbvOFCwl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EbvOFCwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6071F000FF;
	Fri,  9 Oct 2026 18:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791571612;
	bh=HFKBoDKgPdTwbnYnYqRFjYpZs2q39uFT5lOGj3Ocqlo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EbvOFCwl7vCmqFIt3haK4QWAALj/vPIXRM+4bVy4Fp9K5f6O7aab0Q5qMaLvGj1LD
	 ZbPbiowO2iup3HXEvEFvKKu84X48KwpxGQLTTrFLvLYdcCloY3B8TbI0kwn4Jnx15W
	 nPAn/aGDGtMgVuWOCntjbUI4rL7Wc245lCbS+NRWfnYy2dedAIoIIg9QByRPTxQ6em
	 MNU+rTEP9SoKPAFsJIX8QwjlziA7pA83ESORBONiCSf4jICiIuQk5ClHkAd4rpCZP3
	 aJfzH3arqwRQM+rmogzbCXJdcKfC2VOhZA1Opwpa/mzrMIMJbLVSHMVFkfz/SppwCj
	 3B2dqW0icl31w==
Message-ID: <sashiko-outbox-165970@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 31/38] mm/uffd: use predicates for userfaultfd checks
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-scsi@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, kvm@vger.kernel.org, linux-usb@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, selinux@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-31-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-31-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:46:50 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Rather than directly checking VMA flags, use the newly introduced
> vma_is_mm_managed() and vma_is_mm_backed() helpers in userfaultfd
> when assessing VMA suitability for userfaultfd and UFFDIO_MOVE.
>=20
> Update vma_move_compatible() so it's expressed in terms of VMA
> characteristics rather than arbitrary flags.
>=20
> Additionally, update the use of the deprecated VMA flag API when checking
> VMA_SHADOW_STACK_BIT.
>=20
> A VMA_IO_BIT check is no longer required but that is fine as a hard
> invariant has been established that mm-managed mappings may not set
> VMA_IO_BIT so the check is now redundant.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D31


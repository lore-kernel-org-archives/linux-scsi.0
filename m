Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802383BF679;
	Tue,  8 Sep 2026 20:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899787; cv=none; b=jTB62xeu3FFbvVc0Jm/Q6gp3hhEJcX3FYp8cY7oUIzfZcdeAh4sWaX4oaPqWbvRCmfBGDwMD67qidJLZ2kCqMFL11ecZgsdyi6x8aZPuBiTs4vHyiewZR153vccIYOkTf72urr6UpTrjVuAh5HloB38sa29BeeJPnj7fk+WsjcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899787; c=relaxed/simple;
	bh=wAJ7ikObQ7BdyD8JmXGdd6lEUfR3W8m2ceywh5stGKo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=U1JfBoqGj8PZk8PAOB1cpNcBPaYMhvb/6vKxQSWjZ7WOGmyW2v1Goe2ENcdBaGk1C4meT0UymaM+tO0p3+kBMJdqjI4xDbJE7CKFxU7E53dPxzAD023jobti1jl2LQT1eP7GwRGqjWfVO1f6+XgwktIIl8lAg3r7GW7AGnaVdTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vw+3Z/GT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vw+3Z/GT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7401F00A3D;
	Tue,  8 Sep 2026 20:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899785;
	bh=wAJ7ikObQ7BdyD8JmXGdd6lEUfR3W8m2ceywh5stGKo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Vw+3Z/GTh+Dohhq4+9hT2hyhF257D90BGoxNyy/dMiyI/kx8l6o6yVGHmfV6TsCbu
	 QJrR/OaDvqjzK6rjaBrKBmWKgVL/Q7kn9hHdw9Yli24KxnWoBB/40l/JJQKCI9AM3c
	 jDuNOhAciZQLyDR5AIG4nLKerI+QUAy1b9L1JOqJM7pbEh1f/xZ2yfRPm+OSXyJFtC
	 3rpdr03OoNwCl+Y0FoCgxz7P5cjya9oXD2mhS23ex3fN17k/sqm1E6HiawWTZoDkkZ
	 RAvKOnbiNyGtmQfyRwUQA0S4cRYW+mG98TCfG40v4QN0a11r/k8Sgu3XfmUZVckyR4
	 Irs0EZPvowRcg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 20/39] mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, bpf@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, kvmarm@lists.linux.dev, linux-scsi@vger.kernel.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-20-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-20-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:36:24 +0000
Message-Id: <20260908203625.2E7401F00A3D@smtp.kernel.org>
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
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D20


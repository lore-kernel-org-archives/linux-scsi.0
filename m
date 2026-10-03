Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC84F49B5AE;
	Sat,  3 Oct 2026 17:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050222; cv=none; b=Q54CtTofa0ISJlPInSFyGTAQnJT+XDsLyZ4TpsAnX+zso/tWRU83kYhfVLMh2XxIZUGJulLtc7W1zEGlVYfvqsaxFwcjFbNO28sRBbGxwq3kBFIkhVXGaSgn2l170zJdO5jvcHVRFdSopS9thSs+6+xUB1/R9hvVz0cjNr6UA2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050222; c=relaxed/simple;
	bh=/NgCQciV8YSe9Yp6Z5A+AvBAEOtXELuAL7XD5DazBS4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pC4uRyAURmSTLMr3hNGxhOaoIu6w+Lpq09+zklenBOAH0DzK+XAuMQsLTJ0Lxo7RgJx6NhCl2+gcju7ZsubAdC3ZqC2eXlfXvJR/AfpX58FxisgnaZOEihaLsUL5aTEAjNterqiqD7/n5MwTeQh2cVXJjPRMD21xDIQkkPU79ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJxk8tJz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJxk8tJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE8A1F0089B;
	Sat,  3 Oct 2026 17:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050221;
	bh=/NgCQciV8YSe9Yp6Z5A+AvBAEOtXELuAL7XD5DazBS4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FJxk8tJzUmtLXb8IjjraO2tW/UFcyH+5lhTYKGCdN9Gyc2EupoqJsx4KCxb7jU4WG
	 vPrUoaLKyZ5K1C7CJrk5oVpRYneJT7O06gIYdp84XqRE2nb11e0hqPktvbR5TQURoq
	 xxu254tvtTZcciunr955eOXNnxD0icpq+FLAV3JQHjTtST7nd1clKIP6TZw/qmtQWu
	 nI7qQQSK8DHNhoaQMBsmW76QSFxELtoa8EU5wgM7rDpFRhswU8F426rOBmEI8Jk9Rm
	 p1YXV9AV560m06PPqpZLCNbmMNpUGbDPeavEW0/dGXhTau7v6OVZcz6lLEBCcfamuQ
	 DZPLoDqyjxppg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 10/38] infiniband: update hfi1 to use
 remap_vmalloc_range()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-rdma@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, selinux@vger.kernel.org, linux-s390@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-perf-users@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-10-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-10-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:00 +0000
Message-Id: <20261003175700.BCE8A1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> In cases which map chip memory from vmalloc()'d ranges, the hfi1 infiniba=
nd
> drivers currently installs a fault handler, and then smuggles the kernel
> virtual address of this range in vma->vm_pgoff.
>=20
> This is exposing KASLR-sensitive internal kernel state in the VMA, and is
> entirely unnecessary.
>=20
> Instead, use remap_vmalloc_range() to remap the VMA to the span, and
> eliminate the fault handler altogether.
>=20
> remap_vmalloc_range() checks that the VMA does not extend beyond the
> vmalloc area, and the driver already requires the VMA to exactly match the
> span of the memory being mapped, so this has no impact.
>=20
> The memory is all preallocated so not having a fault handler has no impact
> [ ... ]
> There is a change in behaviour in that pages mapped using
> remap_vmalloc_range() will now have normal GUP-able pages, however this
> should have no impact as there is no reason not to allow this.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D10


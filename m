Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF360502D5A;
	Fri,  9 Oct 2026 18:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791570986; cv=none; b=iwC70MG6dwug6FCCCvoAQYR9d1HWjq2HW893GFZtJAhXc+9yKi2Wcz+10LngAqLwDdH8H5eCBuYshVGpLsKmvK2iCvyIdtngOViuLUs5SR8nd9lG4/aNQPmtUAD6LzdqxZaBP6xfhDY8NcFwtavWsoPin3/5cEeAQmLJLnGO3rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791570986; c=relaxed/simple;
	bh=JCqh1EtcYjZW0RH7Et7NA4otY8ggCzC3ELzMG8X53C8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ZAA3/EDYbahVAzUw/ORH/77nLPVONIUIx6KNt6/Kq3ZY+pS+Au4AZDKWJ9V8iDLTV4J+36+TqYfTFU/tzR6QCB99YM/0saOugXMZSmCNrWbMx2BP2OLDR5fSd8EjgbZSOeCyoSvIdLmLnmJyEqAeQFli9A/aX6xJKGv71tkBJA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ek16SYIg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ek16SYIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441BD1F000FF;
	Fri,  9 Oct 2026 18:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791570984;
	bh=JCqh1EtcYjZW0RH7Et7NA4otY8ggCzC3ELzMG8X53C8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ek16SYIgc2VoBs6MnvrygaV6SlEwjqQGZ29u7RkoN/ZqSa10RBRzJt14Gi6G4P8vh
	 fYLZORJRzDuFYqCFy9zAjyaiD9s2mBbMZzvaxRTy0ws6ZeczP+EdX1s/ejX/oIaYP/
	 hrVFZZCwPpXjcf1jFntdbu+XwI241rZ0EVXFJsmdj9vqY1ObJsWu+qlsog85di1FR7
	 tuTQze5AWb/KvI6WAWDosdx9lM0skGuKjM6T2TgmAMhTAQAhTQyOOEyPG51mYJlZ3u
	 pVXrp0ua+j+c3S5OR3UPQPWyC0AoG+2fKlroN8iCzGdh92daqMoLiV50jCnlD41XtK
	 gN050VH2QmrjA==
Message-ID: <sashiko-outbox-165954@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 24/38] mm/vma: enforce that mm-managed mappings may
 not set VMA_IO_BIT
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-perf-users@vger.kernel.org, linux-rdma@vger.kernel.org, linux-usb@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, kvm@vger.kernel.org, bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, selinux@vger.kernel.org, linux-scsi@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, kvmarm@lists.linux.dev, "Heiko Carstens" <hca@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-24-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-24-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:36:22 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> It makes no sense for a mapping whose contents the kernel does not own to
> specify that the range is MMIO.
>=20
> Prior to this patch, all in-tree drivers which did so have been updated
> such that they are marked as not being mm-managed. The check WARNs and
> fails the mmap for any out-of-tree driver that still sets VMA_IO_BIT
> without a kernel mapping.
>=20
> No functional change intended for in-tree code.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D24


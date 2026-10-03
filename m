Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10DF3A963B;
	Sat,  3 Oct 2026 17:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050212; cv=none; b=ekAzhZROieUhpY2vhnA7znMMsXIRcqNUeZYX0c0k/G7oQ6DTYC5R9Wa1lFmnbYtIi9/qEyVrbLK1c1Z8HJ+CHLbHvAwSZdWuXsGaxzRpdzD7E8BUccx1mIz21eAnCC+kq//0EljXvzHwB9Xo3h5seer7939j2XXI7LAYOrh3++I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050212; c=relaxed/simple;
	bh=720ol9Ripw3z9h6ZLAWU78O/wEjZ1Vm63lG7Tj19ZDk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=f7CbuGcigaLCUjZqiUh9Vt9i/4NSnEUAigQJuh1FifFPpRv/gBYCArRzWLa474FWXx2jMzTiSoJ9l1awAv1AX8MVHn5UlJMnHIEHF0msGeIHZCmRmE2cj1b/Du7eDZ8iB1LsWQkinoXJHN6D8TlYVOIaXMojB7NIdWUnE377UQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sh811yfx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sh811yfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418161F008A1;
	Sat,  3 Oct 2026 17:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050209;
	bh=720ol9Ripw3z9h6ZLAWU78O/wEjZ1Vm63lG7Tj19ZDk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sh811yfxkCSxUArEHiAohTOPT5gW17iTdzaITYb8L95qpLj2hPo5q790xJqlfzrBw
	 /WSMEDfymQL1fQlpChxT+5x2UlFhhQ41WZv3oE8a36xx1+NMG0r9QNcxEgGlziy0K6
	 cufUQTG262puyF5vtazy+LGHo5HV6cDnsvttOkrpR9n6canLNVscTC8URyLyYz8GZx
	 OiQvoUNDXtxfBFvBnRVNGV2KytRzJFMr+XBadeaahZx1qPF4GTSowQD90g4d36V4bC
	 K+8ufJ7g+TPRBg53c8MgoINvlQdk209+jRM+iBx97bPKDDp/l7Hz71KIkhBkbseiR9
	 ssqwQ+nK8Desw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 07/38] mm: add mmap action for discontiguous kernel
 page mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: bpf@vger.kernel.org, dri-devel@lists.freedesktop.org, selinux@vger.kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, kvmarm@lists.linux.dev, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-7-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-7-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:47 +0000
Message-Id: <20261003175648.418161F008A1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The existing kernel page mapping mmap actions allow for partial and full
> mapping of an array of struct page pointers.
>=20
> However some drivers require the mapping of discontiguous ranges. Permit
> this by providing discontig_kernel_page_ops which allows a driver to
> specify how the operation should begin and how batches of pages should be
> retrieved.
>=20
> It uses the minimum exposed interface to do so, providing address, page
> offset and both vm_private_data state and a local private state object.
>=20
> ops->init can establish state for the operation, and ops->get outputs the
> pages to map and their count. Should an error arise the core unmaps the
> VMA, invoking vm_ops->close, which is therefore where any state establish=
ed
> by ops->init is released.
> [ ... ]
>=20
> The userland VMA tests are updated accordingly.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D7


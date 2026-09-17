Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA2C54706E;
	Thu, 17 Sep 2026 17:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666445; cv=none; b=apQzBSOvvixGVUC/FGPmjk2Ggbg+XUCQyi7eVxKMFanUeSdvaQNOITO0pfWclRhaGgx+3WQLPh1tqLgiA47LNJcWfYBXS0VG5KY4y1zLBQz/0v09YYZKlG3ROmPBJra0ULybn66DaGSPxW2Yj7vVRFgUf42rBwjg8HqkYhWZk7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666445; c=relaxed/simple;
	bh=KGbqyAT/TiyJlIwP5C3BkJDelZU3+k7lsVP6/O1KyOE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dgoCzdkuXrEf+s/aJEzXITShoJizscHS+9wjxOlrU4DyvwBxXUh7XlYa3a6uWQL5w8bbuNEzeQE+ZVQTeBTunEANxTFCbEuioDWeFyONyirW7xUyIMHWchEg7GBkRKYLAESgfQ6gdfocM+0j3tsfArg/S/tVCiqo71fjGyl4sSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqA1D2eh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqA1D2eh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF271F000FF;
	Thu, 17 Sep 2026 17:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666444;
	bh=KGbqyAT/TiyJlIwP5C3BkJDelZU3+k7lsVP6/O1KyOE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PqA1D2eh0vHM1w8JZn/OuKCp74Gg4monMIroiEMvP9+fzXFO12JDc+uNqws1yXzgS
	 KMHjR/pOJ2FQ3mWm2zbbsSKGqL1ZwPyBw2fQCXWtAw3Bx/C1qddRj6exthcfjxaBgM
	 89J1ScbIeF8qj3/msWk4R2yvf7geoyXs5lSYTom3lULrLHWlg7Ev5CxsJgp+nNIUT8
	 JoTktDGaX7MjFcW1t8uYvCyX3SHgHB0mY97JSGS6QL44Cy+t0N0LQFwweaCK7x/oH9
	 0ZsiTFBZdhTHF25R+YMdupe0+LcV6XVuY9Qdv4vxjb/9+zCFF+3L7BQSB2GRPUnSEf
	 0Eu1MRX9fKshA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 18/40] scsi: sg: convert mmap hook to mmap_prepare
 and rework
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, kvm@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, selinux@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-18-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-18-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:34:02 +0000
Message-Id: <20260917173403.6EF271F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Move from the deprecated mmap hook to the new mmap_prepare hook.
>=20
> We are mapping kernel pages here, so use the discontiguous kernel mapping
> mmap action to do so.
>=20
> Unwind the rather confusing loop and instead map as many pages as we can =
at
> one time.
>=20
> Note that we do not need to pay attention to rsv_schp->k_use_sg here, as
> the pages are populated for the length of the buffer at
> rsv_schp->page_order granularity as compound pages.
>=20
> The discontiguous kernel page mapping logic handles the compound pages for
> us.
>=20
> sfp->mmap_called keeps the buffer stable for us. As before it is never
> cleared, so a failed mmap also leaves it set.
>=20
> We also remove some useless vma, vma->vm_file NULL checks - these will
> always be non-NULL if you reached the mmap hook logic.
>=20
> We retain log output for consistency, but change what's output on page
> mapping to indicate that sg_discontig_get() does the work now.
>=20
> Note that we drop the VMA_IO_BIT flag for the VMA here. It was never
> necessary as we invoke alloc_pages() which gives us refcounted folios that
> are fine for GUP to access (VMA_IO_BIT would prevent that).
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D18


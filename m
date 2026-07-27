Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A8041D204
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164747; cv=none; b=tx40gmtFRXqHkwP3T0YToAE8RxcFeWtul3nYysyA9/jLmnyveMPSuMuyN/kazZaRGVD3fsMRHJdtFKFo8/0ec9lUDN9FwAKqPe2Zd0ipqzNHN4Wdsd/RIKz6I9F/KtI7fci/no6FoJceugsJ6qteMzLgQ5KIFY5QE23GMv8gWk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164747; c=relaxed/simple;
	bh=PEp+Db860LNOCluIBNTIPnP7La5Ohbq0rOVr2rqHhKY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZLwj3j1BGB69DGMVY5wmhTUBbZFx1mJB+O4nWB1dWY60UKSB6kT6Yx6rRBmiTVN0ExketMx6AFel02PCVVy68uIejYXpWw1O8xc4IZxKz2JCnlq/sM6fnjXu2c0PoMHpi8VsNWuQks6wjkIre4VY+v0OXD1Xwlu/YDNLSYRARM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K25nvr1O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K25nvr1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A990C1F000E9;
	Mon, 27 Jul 2026 15:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785164745;
	bh=SLm6+6n7ykYU2PajoGISDMmQLeIdLz2e3dy776BWEb8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K25nvr1OjJoEl7Ni2si3JJMop8KsChddsn6blhwwjNYd1Tz8EY1fsLXuK2x2DsJKS
	 Cp+qekY5BiXhLqEvfrv8/Ng0sN3Od9jkRBkwaRPc+YrXPMhI6CM0NGBfgPx8TBwR0J
	 dMaTCUgIQ3zxG4p+4FU+OYiS4ikKO0ZiqXz1gYPl/skeWBYQ9hSmJmH0a3lbli+yHr
	 bYEn72G8/hLXrFBgOoY4NKVsJ8hr77f88Misx05yP8UhxRblRR2fTdXWI3wNGSScMI
	 /DKx0PPekwjB6h5le1+ZJzM/hS7ZZUHjmUCjP6btpOFTWsvFmTTgvTtqabGbsXBSf5
	 SnKGnJZx7djHw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 01/27] libmultipath: Add initial framework
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-2-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:05:45 +0000
Message-Id: <20260727150545.A990C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] The static workqueue `mpath_wq` is allocated but never used to queu=
e work.
- [Low] Missing `#include <linux/wait_bit.h>` in `lib/multipath.c` causes a=
 build issue.
--

--- Patch [1]: [PATCH v5 01/27] libmultipath: Add initial framework ---
commit 10e613ef081274ac617a43c354384f9ddc32f1f5
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add initial framework

Add initial framework for libmultipath to support path management, path
selection, and failover handling.

> diff --git a/lib/multipath.c b/lib/multipath.c
> new file mode 100644
> index 0000000000000..9cc398d266adf
> --- /dev/null
> +++ b/lib/multipath.c
[ ... ]
> +void mpath_put_head(struct mpath_head *mpath_head)
> +{
> +	refcount_t *refcount =3D &mpath_head->refcount;
> +
> +	if (refcount_dec_and_test(&mpath_head->refcount))
> +		wake_up_var(refcount);

[Severity: Low]
Does this code build without including <linux/wait_bit.h>?

It appears that the wake_up_var() macro used here, and the wait_var_event()
macro used in mpath_head_uninit(), are defined in <linux/wait_bit.h>.
This header does not seem to be included directly or implicitly through
<linux/multipath.h> or <linux/module.h>.

> +}
> +EXPORT_SYMBOL_GPL(mpath_put_head);
[ ... ]
> +static int __init mpath_init(void)
> +{
> +	mpath_wq =3D alloc_workqueue("mpath-wq",
> +			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS, 0);

[Severity: Low]
Is it necessary to allocate this workqueue here?

It looks like the static variable mpath_wq is allocated and initialized, but
no work is ever actually queued to it. Could this allocation be removed
until it is needed?

> +	if (!mpath_wq)
> +		return -ENOMEM;
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D1

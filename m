Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560910;
	b=0UsvO7TbqMWRdn3XugLAxiWxdwhFN3TYDPuXL2NkqkFCwXVDJBC9SxVG/FMG6RvEIh5t
	 ikrm09GhArG695HIjmLIknNa8hkpUOcqK6NOYeVrTttLiAsGiUWfoWsYnBpkzTlAYIkmo
	 Pneg2eyB690GNQ+urBCRTBuCtB2nM2lGIgZkg9czUX1V99KtM/4yIFO+nxUs4TQYTtCra
	 uthtbPzSfkekIFfHQxu8whGIfrfB7D/X3Tlg26O0PypppcitWzCJGECba4JHJDyu35DlF
	 /mVQcJ00JJBVZVE+6rrO7xVmi+9aQe52QuqYxWz/soBrbaxZQdSyk1Bwx0+zzV7V9MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560910;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=njwJCys7WGPxrmfKQJRaBVFTjukpboxirKPMxaXAuVQ=;
	b=B7YKFab+V4a4GfT9p2ZiosskAeSfY+wUw74+/qE2AY+SKejv0yAJZ5S/D3EpczdGD3eC
	 guGlhC+i/r34dQ3KJgv6tfZjj0KgjsqYAPjHdkDBSXvW5ADdz5TDiv7/PSgw7nEni3dWL
	 Jts9vRKBZX8zYSRlAe3ubWncYZgPn4pO2NHgCTMDxnIWxCLgX2QXwVFO1lO7JWJlqXFdT
	 gxL4kR3ga/gbQeJw1t+nhFw2SldFRhhfeneYgT9nW0wXVA6xkhzJAtlJg1oMk9ybpqsX2
	 vcvkViJs6u/zk+piiOVYycV8He6GDWys/H5jeShOYUeydmVUi6E+/a6VttYV8Dq5RpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HdEKEMk0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEE1606A319
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 05:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HdEKEMk0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED60D1F000C9;
	Wed, 21 Oct 2026 05:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792560910;
	bh=njwJCys7WGPxrmfKQJRaBVFTjukpboxirKPMxaXAuVQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HdEKEMk0TgX6831RqNRe+Zdnwr9aTrRAUwdcvrOPazRLffKRaUPNc9xT9AUy04KoV
	 E3uyW+UGXhrv2/jxBzCkqv8L3GeW7f9yIe5n8e6zP2SFOU5ENQiljRh8/N7J7zLv1l
	 7kR2QZhvDcL2GmTSMCPiGsxOGs08pT+BMqUNowGAkLcXAyJmPhQ7RWpdHv/d3Z8Ych
	 LWzpgEMDdS8NIAT6WmJmeWl93zgEaes8Y00qBtAGpYi+X5KTi9x/+XORN8qVaftVCF
	 V02vqQ86IawIoXPf90n+Z6jbZ/KHMWAnBtPqxEVwTHKnGiP29om7sJ8BchrZMK6H/8
	 0LNvbI06cPhYw==
Message-ID: <sashiko-outbox-179807@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ufs: Fix wild pointer dereference in
 ufshcd_clkscale_enable_store()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Ximo" <lixicaicai@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261021052042.3441449-1-lixicaicai@gmail.com>
References: <20261021052042.3441449-1-lixicaicai@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 05:35:09 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] scsi: ufs: ufshcd_clkscale_enable_store() mutates state before l=
ist_empty()
- [Medium] scsi: ufs: inconsistent empty clk_list_head handling in ufshcd_c=
lkscale_enable_store()
--

commit 61a6e6195466b512ac30d8e2c7bbb0da09b2167e
Author: Wang Haoran <haoranwangsec@gmail.com>

scsi: ufs: Fix wild pointer dereference in ufshcd_clkscale_enable_store()

This commit adds a list_empty() check on hba->clk_list_head in
ufshcd_clkscale_enable_store() before calling list_first_entry(), returning
-EINVAL via the out_rel path when the clock list is empty.

>     scsi: ufs: Fix wild pointer dereference in ufshcd_clkscale_enable_sto=
re()
>    =20
>     ufshcd_clkscale_enable_store() calls
>     list_first_entry(&hba->clk_list_head, ...) and immediately dereferenc=
es
>     the result with clki->max_freq, without checking whether the clock li=
st
>     is empty. list_first_entry() does not return NULL on an empty list: it
>     returns container_of() applied to the list head, i.e. a non-NULL wild
>     pointer pointing at &hba->clk_list_head itself, so the ->max_freq read
>     lands on adjacent fields of struct ufs_hba and yields a garbage value=
 /
>     out-of-bounds access. The clock list can legitimately be empty on this
>     path: it starts out empty (INIT_LIST_HEAD() in ufshcd_alloc_host()) a=
nd
>     ufshcd_parse_clock_info() returns success leaving it empty when the
>     device tree has no clock-names property, while UFSHCD_CAP_CLK_SCALING=
 is
>     a software capability bit set independently by vendor/platform code, =
so
>     a "cap set but no clocks" configuration is possible. In that state
>     ufshcd_devfreq_init() explicitly returns success for an empty list and
>     ufshcd_async_scan() still creates the clkscale_enable sysfs attribute
>     with is_enabled =3D true, so a simple "echo 0 > .../clkscale_enable"
>     reaches the unguarded list_first_entry() and dereferences the wild
>     pointer. Notably, all five sibling functions in this file that access
>     clk_list_head (ufshcd_print_clk_freqs(), ufshcd_setup_clocks(),
>     ufshcd_init_clocks(), ufshcd_devfreq_init(), ufshcd_devfreq_scale())
>     guard with list_empty() first - only this one was missed, which sugge=
sts
>     an oversight rather than a deliberate design. This potential issue was
>     found during a code audit.
>    =20
>     Fix this by adding a list_empty() guard before the list_first_entry()
>     call, returning -EINVAL via the existing out_rel error path when the
>     clock list is empty, exactly matching how the sibling functions handle
>     the same condition. Behaviour with a non-empty clock list is unchange=
d.
>    =20
>     Reported-by: Wang Haoran <haoranwangsec@gmail.com>
>     Reported-by: Li Ximo <lixicaicai@gmail.com>
>     Signed-off-by: Wang Haoran <haoranwangsec@gmail.com>

[Severity: Medium]
The commit message states that all five sibling functions in
drivers/ufs/core/ufshcd.c that access clk_list_head (including
ufshcd_devfreq_scale()) guard with list_empty() first, and that returning
-EINVAL matches how the sibling functions handle an empty clock list. Is th=
is
description accurate?

Looking at drivers/ufs/core/ufshcd.c, ufshcd_devfreq_scale() does not access
clk_list_head directly, while functions that do check list_empty() treat an
empty list as a no-op rather than returning -EINVAL. For example, in
ufshcd_devfreq_init():

	/* Skip devfreq if we don't have any clocks in the list */
	if (list_empty(clk_list))
		return 0;

Similarly, ufshcd_setup_clocks(), ufshcd_init_clocks(), ufshcd_set_clk_freq=
(),
and ufshcd_devfreq_target() return 0 when clk_list_head is empty, and
ufshcd_is_devfreq_scaling_required() returns false:

	if (list_empty(head))
		return false;

In ufshcd_clkscale_enable_store(), when ufshcd_is_devfreq_scaling_required()
returns false after ufshcd_suspend_clkscaling(hba), the function jumps to
out_rel with err =3D 0 rather than -EINVAL.

Could the commit message and empty-list handling in
ufshcd_clkscale_enable_store() be aligned with how these sibling functions
treat an empty clock list?

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index cc75384c65021..a55226695ad13 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1874,6 +1874,11 @@ static ssize_t ufshcd_clkscale_enable_store(struct=
 device *dev,
>  		goto out_rel;
>  	}
> =20
> +	if (list_empty(&hba->clk_list_head)) {
> +		err =3D -EINVAL;
> +		goto out_rel;
> +	}
> +
>  	clki =3D list_first_entry(&hba->clk_list_head, struct ufs_clk_info, lis=
t);
>  	freq =3D clki->max_freq;
> =20

[Severity: Medium]
Does returning -EINVAL here leave hba->clk_scaling.is_enabled in a mutated
state when disabling clock scaling with an empty hba->clk_list_head?

In drivers/ufs/core/ufshcd.c, ufshcd_clkscale_enable_store() updates
hba->clk_scaling.is_enabled and handles the enable path before checking
list_empty(&hba->clk_list_head):

	value =3D !!value;
	if (value =3D=3D hba->clk_scaling.is_enabled)
		goto out;

	ufshcd_rpm_get_sync(hba);
	ufshcd_hold(hba);

	hba->clk_scaling.is_enabled =3D value;

	if (value) {
		ufshcd_resume_clkscaling(hba);
		goto out_rel;
	}

	if (list_empty(&hba->clk_list_head)) {
		err =3D -EINVAL;
		goto out_rel;
	}

When hba->clk_list_head is empty and a user writes 0 to clkscale_enable:

1. hba->clk_scaling.is_enabled is set to 0 before the list_empty() check
   returns -EINVAL, so subsequent reads via ufshcd_clkscale_enable_show()
   report 0 even though the write failed.

2. A second write of 0 matches (value =3D=3D hba->clk_scaling.is_enabled) a=
nd
   returns count (success) instead of -EINVAL.

3. A subsequent write of 1 sets hba->clk_scaling.is_enabled =3D 1, calls
   ufshcd_resume_clkscaling(hba), and jumps to out_rel before reaching the
   list_empty() check.

4. Because ufshcd_clkscale_enable_store() jumps to out_rel before calling
   ufshcd_suspend_clkscaling(hba) while leaving hba->clk_scaling.is_enabled
   as false, subsequent suspend transitions in ufshcd_clk_scaling_suspend()
   will also skip ufshcd_suspend_clkscaling(hba):

	if (suspend) {
		if (hba->clk_scaling.is_enabled)
			ufshcd_suspend_clkscaling(hba);
		ufshcd_clk_scaling_allow(hba, false);

Should the empty clock list case either be checked before mutating
hba->clk_scaling.is_enabled, or skip only the list_first_entry() and clock
scaling steps after ufshcd_suspend_clkscaling(hba) so that state transitions
remain consistent?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021052042.3441=
449-1-lixicaicai@gmail.com?part=3D1

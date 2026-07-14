Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDF7417BEF
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 17:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784051052; cv=none; b=kI19c/8CP5QyjF70W3HRmJmkPkluScg4CFyuZEQjGaoIekwmdeSlIm3XddgGQf9XrPsWTEFBkwFC6FuxpMcH6e0D8wkTkxI+BE76Rh72otOEIquLCuSe18pq8SzlFhSC9Rqe8PHEnuSr6tb/x3V/0EhsjxkAKgOLymUJtkzvRHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784051052; c=relaxed/simple;
	bh=uv6oe7SNHwDsnz3NkHiCAFq4vIJq8wt/vYMT7/FeqXQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=R9RNMO9D3WwUAtejAk9M9tBgsPbTdFiJLWcaHAFNYj8Ng8brbxafDzbIUMnWzPQIcySUsv0LYdSNsvexQ+gVlyai3GUHeIKRLkFAklKa/b0Mk9h8ur6Yy8NC3L9c09KVoAhkNpwyvekQOGYeJy9FxkvUBCOq6Fzvuz+YOH5cd6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hPccmZm4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hPccmZm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD471F00A3A;
	Tue, 14 Jul 2026 17:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784051046;
	bh=KPabRj40nYYQPsZ51J4xIjEBwORUg3UfKjkYvXCRP68=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hPccmZm4o6R10k4QMrPYWFXE4N4eT2tFBzrx4/VCe18Gy5hFoeI/loPQpysGK9kiv
	 08Hvl/VdRiIKfufbpqTEg8qcGUQO8Jv5tyrOcx8nyi2Wv/uVMWMrKDxNMVDaXvO50h
	 9Uaz8KfjmEYVMXC4/vWLieLd+1PkiE8EsC6dsjWJTvGFG9Dbza25DJIPp0481IN1O0
	 kqoCUbQUinWpDbsHqe+HwnqD6ef5/FQ9jdwPfJzLGzX/FwyT4GSQhFEqwsWS4xMrYY
	 8F3eF06lMaxAqeGWbuMUpkMMt7HgfKA9UuTOPYh6RxT7enw2NJ9r8rRJ82pVAH3MPn
	 g57K0yP1sh2lg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: ufs: core: cancel RTC work in active-active
 suspend
Reply-To: sashiko-reviews@lists.linux.dev
To: "Guangshuo Li" <lgs201920130244@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714172726.1736967-1-lgs201920130244@gmail.com>
References: <20260714172726.1736967-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 17:44:05 +0000
Message-Id: <20260714174406.6FD471F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `ufs_rtc_update_work` is permanently lost if `__ufshcd_wl_su=
spend()` fails after cancelling it in the active-active suspend path, stopp=
ing periodic UFS RTC updates until the next successful suspend/resume cycle.
--

--- Patch [1]: [PATCH v2] scsi: ufs: core: cancel RTC work in active-active=
 suspend ---
commit 9a4850975ce80edc6032f13153aa50eb19b4cc19
Author: Guangshuo Li <lgs201920130244@gmail.com>

scsi: ufs: core: cancel RTC work in active-active suspend
   =20
This commit cancels the UFS RTC update work in the active-active suspend
path before calling the vendor suspend callback to prevent an SError.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index d3044a3089b53..c3b105b2678e4 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10269,6 +10269,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hb=
a, enum ufs_pm_op pm_op)
>  			req_link_state =3D=3D UIC_LINK_ACTIVE_STATE) {
>  		ufshcd_disable_auto_bkops(hba);
>  		flush_work(&hba->eeh_work);
> +		cancel_delayed_work_sync(&hba->ufs_rtc_update_work);

[Severity: Medium]
If the active-active suspend path fails after this point, is the
ufs_rtc_update_work permanently lost?

When this jumps to the vops_suspend label, if ufshcd_vops_suspend() returns
an error, the function branches to the error handling path:

__ufshcd_wl_suspend() {
    ...
vops_suspend:
	ret =3D ufshcd_vops_suspend(hba, pm_op, POST_CHANGE);
	if (ret)
		goto set_link_active;
    ...
out:
	...
	if (ret) {
		ufshcd_update_evt_hist(hba, UFS_EVT_WL_SUSP_ERR, (u32)ret);
		hba->clk_gating.is_suspended =3D false;
		ufshcd_release(hba);
	}
	hba->pm_op_in_progress =3D false;
	return ret;
}

The error path doesn't appear to re-arm the canceled RTC update work before
returning the error code. Does this mean periodic UFS RTC updates will stay
stopped until the next successful suspend and resume cycle?

>  		goto vops_suspend;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714172726.1736=
967-1-lgs201920130244@gmail.com?part=3D1

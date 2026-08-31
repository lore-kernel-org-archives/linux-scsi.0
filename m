Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7952A45C6FD
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 18:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788200054; cv=none; b=Bew754LAvW7cg8oCPEJ9q0VsxxXMYRKjf98WS949RXXpJaDf0TlSPhgqgENRvX5wYSP7JjHqqKqGCWlOjdKkMWCmEhikf8V5kfYtPpesAFe676uEm2Fn6xlEK1P1Umf8uYL4F12cwzpvWEuqYuilW7S3HlUhrdrjZLl4iKAA3HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788200054; c=relaxed/simple;
	bh=4xBz36/PWzI8P2WA/e8hNiesmDEQimqv9Nc36jICNVw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Wk8YuP2PSiIiaJGG65sRIAbQpvBe5/DwQLdbcbvP0rJaZrk1xe82BA8HhdDk+fRFVU5m1dU4R8GckVLNVYhSfrwHwq3y1kqSX9Hirw1eD9mtlfbmi4wOq4sa2LBFXDcxVK8qzpnYJ+jrh1MX8DDWBiwxGmVUUghtNBsmvzmS64w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kcW36Wqw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kcW36Wqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4E51F000E9;
	Mon, 31 Aug 2026 18:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788200053;
	bh=DBRk14FOWh/96dPTefeJWrV+tCVo4VqkBalqyEUTKIM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kcW36WqwU4qSDDBJKiryLlsqjkmT2oObVbDLxYeroLDtQVX/qzYHgQKAgdfgHzh4c
	 mLwjU7y0ZOmpIxgjsipvxeYaLjkh6C32E4zeiAj/7io8WeYH12bgkdzLQ+cBp1YMBM
	 xBfVNvbobZ9Be49QdGS6HjyipDtoyetJ29GIk/rByxbeavgB8eQSVGMFd/34d3w+k5
	 ndXAMC68JOVB5+zj/SMiPxEXGq2wzmn6L7/qBY05UntXO1JyV6B4KhjaErLeY8sooV
	 4YAvQIHDrKgjORWZ5ZT1ZnDEemW+chVGSOSaooD4KLbfDK+5FjeaFQYBjS7ldgrS52
	 185dfljDFzmkQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: fix use-after-free on self-preempt in
 PROUT PREEMPT
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tianchu Chen" <tianchu.chen@linux.dev>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <ddf3c216cf486a1939784731bd1fb50e58092256@linux.dev>
References: <cfc81cd805c38b2600a219329c351580aa535326@linux.dev>
 <ddf3c216cf486a1939784731bd1fb50e58092256@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 18:14:12 +0000
Message-Id: <20260831181413.4B4E51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] When processing PREEMPT_AND_ABORT, preempted registrations are add=
ed to `preempt_and_abort_list` but are leaked if a specific condition is no=
t met, skipping required task aborts.
- [High] Unsafe `list_for_each_entry_safe` iteration across a spinlock drop=
 in PR clearing and preemption paths leads to a potential Use-After-Free.
- [High] Missing reference decrement in `core_scsi3_emulate_pro_clear` caus=
es a soft lockup if the caller's registration is concurrently unlinked.
--

commit 3df8f536b0380acddfcc85e22e361b03863b2a7d
Author: Tianchu Chen <flynnnchen@tencent.com>

scsi: target: fix use-after-free on self-preempt in PROUT PREEMPT

This commit fixes a use-after-free bug in core_scsi3_pro_preempt() that
occurs when a remote initiator preempts its own registration. It tracks if
the free path consumed the locate reference and conditionally skips the
final put.

> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core=
_pr.c
> index e7933115087ab..e4160ed3c1191 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -2926,6 +2927,13 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int typ=
e, int scope, u64 res_key,
>  				sa_res_key_unmatched =3D false;
> =20
>  				calling_it_nexus =3D (pr_reg_n =3D=3D pr_reg) ? 1 : 0;
> +				/*
> +				 * dec_holders=3D1 makes the free path drop the
> +				 * reference core_scsi3_locate_pr_reg() took on
> +				 * pr_reg_n, so the tail must not put it again.
> +				 */
> +				if (calling_it_nexus)
> +					reg_n_released =3D true;
>  				pr_reg_nacl =3D pr_reg->pr_reg_nacl;
>  				pr_res_mapped_lun =3D pr_reg->pr_res_mapped_lun;
>  				__core_scsi3_free_registration(dev, pr_reg,

[Severity: High]
This is a pre-existing issue, but since we are modifying the preemption
logic here, could this list iteration be unsafe?

The loop enclosing this section uses list_for_each_entry_safe, which caches
the next element assuming the list remains safely locked. However, inside
__core_scsi3_free_registration():

__core_scsi3_free_registration() {
        ...
        spin_unlock(&pr_tmpl->registration_lock);
        while (atomic_read(&pr_reg->pr_res_holders) !=3D 0) {
                cpu_relax();
        }
        ...
}

Since the list lock is dropped inside the loop body, couldn't a concurrent
thread acquire the lock and unlink or free the cached next element, causing
a use-after-free when iteration resumes?

[ ... ]

> @@ -2997,7 +3005,8 @@ core_scsi3_pro_preempt(struct se_cmd *cmd, int type=
, int scope, u64 res_key,
>  		if (pr_tmpl->pr_aptpl_active)
>  			core_scsi3_update_and_write_aptpl(cmd->se_dev, true);
> =20
> -		core_scsi3_put_pr_reg(pr_reg_n);
> +		if (!reg_n_released)
> +			core_scsi3_put_pr_reg(pr_reg_n);
>  		core_scsi3_pr_generation(cmd->se_dev);
>  		return 0;

[Severity: High]
This is a pre-existing issue, but I noticed something unusual about how
preempt_and_abort_list is handled before we return here.

When processing PREEMPT_AND_ABORT, preempted registrations are added to the
local preempt_and_abort_list. However, earlier in this function,
core_scsi3_release_preempt_and_abort() is only called if a very specific
condition is met:

if (pr_res_holder && all_reg && !(sa_res_key)) {
        __core_scsi3_complete_pro_preempt(...)
        if (preempt_type =3D=3D PREEMPT_AND_ABORT)
                core_scsi3_release_preempt_and_abort(...)
}

If that condition evaluates to false, we eventually reach this return 0
statement without cleaning up the list.

Does this permanently leak the local preempt_and_abort_list and skip the
required task aborts if a remote initiator sends a PREEMPT_AND_ABORT command
with all_reg=3D0 or a non-zero sa_res_key?

[Severity: High]
This is another pre-existing issue, but looking at a similar pattern in
core_scsi3_emulate_pro_clear():

core_scsi3_emulate_pro_clear() {
        pr_reg_n =3D core_scsi3_locate_pr_reg(...);

        list_for_each_entry_safe(...) {
                calling_it_nexus =3D (pr_reg_n =3D=3D pr_reg) ? 1 : 0;
                __core_scsi3_free_registration(..., calling_it_nexus);
        }
        ...
        return 0;
}

The function relies exclusively on finding pr_reg_n during its list loop to
drop the reference via __core_scsi3_free_registration. If another thread
concurrently unlinks pr_reg_n before the list lock is acquired, the loop
never encounters it.

Since the function eventually returns 0 without a fallback
core_scsi3_put_pr_reg() call, could this leaked reference force the
unlinking thread to spin infinitely in its atomic_read cpu_relax loop,
leading to a soft lockup?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/ddf3c216cf486a19397=
84731bd1fb50e58092256@linux.dev?part=3D1

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CF6477E51
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 13:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183437; cv=none; b=HcB6I8GZKyib4rV6nLZ8fBL/4QHh7p+rL0kS464TvYuWscenCDHbKQuVMHrfJqf33OS+cp2OQLy7Z3oHqB9bJjjJO4JEmqeIphWMeADWwZagY7EuQMxzxYP2/2Hvwuqh2xtVCicPdn/36TnbwWV9j7VkjHms0cYO9GDR3Oi/JJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183437; c=relaxed/simple;
	bh=caqs4cfTO0AOTayLQd3q+N+GJRJyo5IacsC532zAaxY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aKz+PvvXjSffJDkMEj7DVXg5UJ1DlFskpwMKH7goKraRnIpcSnzFpllm8sLXyjFbHE6GxDgZs72MIR0DHobZOzrEm0HeLE8fqXFXmMA4Z9Zt9Z4nFM6hUYM+0OwTKM/XPoNxSQ+UDaRKIYL8j8R63L5FKh8KynMswJiEndB//vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oZiF5ADk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oZiF5ADk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4CB1F000E9;
	Mon, 31 Aug 2026 13:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183435;
	bh=F8tuiB/wrex6GxIQDzyVviFruFt64dgF72nlsND9kCk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oZiF5ADkzOzw1OwJTWa7/8ZyIRm52lJsCR4rqFHGZ3XDRcFt1H2CJ1csnYjmP9Zl4
	 ivKH8B4BIqrVc0+B2P6Hazz83jvtl2bPpNcqM1H9g408FeoTD4X/MqKJmk8efv2Rda
	 rKC3W9XmDqqmmUbabQIoXDkiTaY/fFkJv2g18IiWF5a2dIYfLy1GJ7WbS8nu2MjuAo
	 e/FHa3p9SatfimSA11HEDDilWfeFSjtCYSKQXlsAtXBsaKjoYYLihfxhbUl9jxDYp/
	 9/B1cps4InfvNQUaIBs6XRvbrX82x3CM/8AzzIYLSgWImlhUSvSUWgrAAzBK8JpYDo
	 rpof4oqTl5YjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: fix PRIN READ_FULL_STATUS buffer bounds
 check
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tianchu Chen" <tianchu.chen@linux.dev>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <cfc81cd805c38b2600a219329c351580aa535326@linux.dev>
References: <cfc81cd805c38b2600a219329c351580aa535326@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 13:37:14 +0000
Message-Id: <20260831133715.6D4CB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Preexisting out-of-bounds heap write in `iscsi_get_pr_transpor=
t_id` caused by double-incrementing buffer offset and length, bypassing the=
 bounds check.
- [High] Use-After-Free in `core_scsi3_pri_read_full_status` due to droppin=
g the lock while iterating with `list_for_each_entry_safe`.
--

commit 5d1c2d868ed5fae3f80b9cbcf44f8a5d0a03c061
Author: Tianchu Chen <flynnnchen@tencent.com>
scsi: target: fix PRIN READ_FULL_STATUS buffer bounds check

This commit fixes a heap out-of-bounds write in the PR IN READ FULL STATUS
command processing. It corrects the buffer overflow check to account for the
8-byte PRIN header and the 24-byte descriptor header, which were previously
omitted.

> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core=
_pr.c
> index e7933115087ab..53ffb89f196b9 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -3988,7 +3988,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
>  		exp_desc_len =3D target_get_pr_transport_id_len(se_nacl, pr_reg,
>  					&format_code);

[Severity: High]
This is a pre-existing issue, but I have a question about the list iteration
happening just above this bounds check:

drivers/target/target_core_pr.c:core_scsi3_pri_read_full_status() {
    ...
    list_for_each_entry_safe(pr_reg, pr_reg_tmp,
			&pr_tmpl->registration_list, pr_reg_list) {
        ...
        atomic_inc_mb(&pr_reg->pr_res_holders);
        spin_unlock(&pr_tmpl->registration_lock);
    ...
}

While the lock is dropped to process the descriptor, isn't the cached next
pointer (pr_reg_tmp) completely unprotected?

If another initiator concurrently issues a PR OUT command that unregisters
and frees the next registration in the list, could this lead to a
use-after-free when the lock is reacquired and the loop evaluates the next
condition?

>  		if (exp_desc_len < 0 ||
> -		    exp_desc_len + add_len > cmd->data_length) {
> +		    off + 24 + exp_desc_len > cmd->data_length) {

[Severity: Critical]
This is also a pre-existing issue, but does this bounds check still leave us
vulnerable to an out-of-bounds write if the transport ID generation overruns
the expected length?

Looking at the iSCSI specific implementation:

drivers/target/target_core_fabric_lib.c:iscsi_get_pr_transport_id() {
    ...
    buf[off+len] =3D 0x2c; off++; /* ASCII Character: "," */
    buf[off+len] =3D 0x69; off++; /* ASCII Character: "i" */
    buf[off+len] =3D 0x2c; off++; /* ASCII Character: "," */
    buf[off+len] =3D 0x30; off++; /* ASCII Character: "0" */
    buf[off+len] =3D 0x78; off++; /* ASCII Character: "x" */
    len +=3D 5;
    buf[off+len] =3D pr_reg->pr_reg_isid[0]; off++;
    ...
}

When writing the separator, both off is incremented per byte and len +=3D 5=
 is
executed at the end. Since the array index used is off+len, won't this cause
the index to jump by 10 instead of 5?

If an initiator logs in over iSCSI providing a custom ISID, could this write
the 7-byte ISID up to 5 bytes past the correctly calculated descriptor leng=
th?

Since this bounds check trusts the expected length returned by
target_get_pr_transport_id_len(), wouldn't this bypass the check and
corrupt memory past the allocated cmd->data_length buffer?

>  			pr_warn("SPC-3 PRIN READ_FULL_STATUS ran"
>  				" out of buffer: %d\n", cmd->data_length);
>  			spin_lock(&pr_tmpl->registration_lock);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cfc81cd805c38b2600a=
219329c351580aa535326@linux.dev?part=3D1

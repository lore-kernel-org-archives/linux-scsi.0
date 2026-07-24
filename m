Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74533A9628
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 08:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784880756; cv=none; b=GfrHymH/58loeSOZrfyPwMzzMrgFBKrLnF1OozxYXu1KmyFP6WO7eR6TE202Bs0jgHxvzpjK6I9XuCVakx4CnVhN8f98mqPO5mLFJNS8cTnYFNIqRPTXg3AoASr1y5yJB0PqB1r/fytEu5e8EYR4AnUltJdLYiMmuHtOCaP7PoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784880756; c=relaxed/simple;
	bh=+V5MVhlTM5Qy4JZ54wwn/hmku44V0YspNdM1ki0elnw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XOet8GxrlahRxI+PkBMwlx3jnIySpJNXfwSLOKHJ0FFgcfJrfKdMOdbt6iDB2tAOa5+1/UbK9VFetSu2cHUd2V+5i2YXWHOdwe+2/7I7WHYCE+GrtyyRPyAu57w7Q/O/S6IvTs1TcVisdTjwvNQ75mqPcIDHImtv1rfPXJWDmAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oCWHVwFS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oCWHVwFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D3D1F000E9;
	Fri, 24 Jul 2026 08:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784880755;
	bh=K4bowNsrbvkcjrcZUJcgDLNBW2oykMs5vca5h9/ghhs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oCWHVwFS0+kK5H0PwiNcZvFddbYN0kHsIFz4RbFpGig6tiSgUr4UR81XsF1tYU9k2
	 5Y6NV5oQyH2iOrGLpphR4K3R2iXWP5Fakk0RKGJkIjdbnHV1uLEDfQenkJ3XkHvv0q
	 kO0/sQWBcdgAbK4jJOjXdhtgYUlRmEK12RYuiAorCQKqhsxkc3mMmcHj5c8R/ysAO2
	 fU27CeLneA1oX1IrH5ptWJlAqKYWlPJkZg/d9FcgJPiU1xMlDiuBX7iJzeIkVML20D
	 MG23v9GcvrYQIxnCstgrtUV5Vadsx2+pkZk7W7CzP+hueViIxjGsOLFbFxDNz5FJII
	 nGxBu5G0eM0gA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: iblock: Fix wrong PR ops NULL check for
 PREEMPT/RELEASE
Reply-To: sashiko-reviews@lists.linux.dev
To: kensanya@163.com
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724075850.280699-1-kensanya@163.com>
References: <20260724075850.280699-1-kensanya@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 08:12:34 +0000
Message-Id: <20260724081235.26D3D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Un-ratelimited error logging can be abused by an initiator to floo=
d the kernel log.
--

--- Patch [1]: [PATCH] scsi: target: iblock: Fix wrong PR ops NULL check fo=
r PREEMPT/RELEASE ---
commit 562d965ef4dd6b2eb1b1b38dac4b060b92e2df13
Author: TanZheng <tanzheng@kylinos.cn>

scsi: target: iblock: Fix wrong PR ops NULL check for PREEMPT/RELEASE
   =20
This commit corrects a bug in the iblock_execute_pr_out function where the
pr_clear callback was being checked instead of the corresponding pr_preempt
and pr_release callbacks. This fixes a potential NULL pointer dereference
if those specific PR ops are unimplemented.

> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -906,7 +906,7 @@ static sense_reason_t iblock_execute_pr_out(struct se=
_cmd *cmd, u8 sa, u64 key,
>  		break;
>  	case PRO_PREEMPT:
>  	case PRO_PREEMPT_AND_ABORT:
> -		if (!ops->pr_clear) {
> +		if (!ops->pr_preempt) {
>  			pr_err("block_device does not support pr_preempt.\n");

[Severity: High]
This is a pre-existing issue, but could this un-ratelimited error logging be
abused by a remote initiator to flood the kernel log?

If a malicious or misbehaving SCSI initiator repeatedly sends PR OUT comman=
ds
with unsupported operations, it will hit this pr_err() at a high frequency.
This could flood the dmesg buffer, hide other critical messages, and
potentially cause resource exhaustion.

This same pattern exists throughout iblock_execute_pr_out, including the
default switch case for unknown Service Actions:

    default:
        pr_err("Unknown PERSISTENT_RESERVE_OUT SA: 0x%02x\n", sa);
        return TCM_UNSUPPORTED_SCSI_OPCODE;

Would it be safer to use pr_err_ratelimited() for these initiator-triggerab=
le
errors?

>  			return TCM_UNSUPPORTED_SCSI_OPCODE;
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724075850.2806=
99-1-kensanya@163.com?part=3D1

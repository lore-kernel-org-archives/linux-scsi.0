Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10050408013
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 13:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782739369; cv=none; b=gbjjduf2XUV+La+BB3vfdMChOlWrsb2eqAufeu7MhcBjJGjDK138tfV5H1QshVGVJmNT3EiG5YP2l07HQ8Fxm+T1XqSW+mnTgHMdxqi1Wm67ywAiZk4ocNwHh9MM4wO1s52SQbNi+/dmoTQhXhyJfIczTPEYXxzrmMhxvJs7vTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782739369; c=relaxed/simple;
	bh=rkf8W4krVOvpttLjr95icMhWWrXDCLa92+pqLo21Iv0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZV3FXl/2T4XaAUUmu8+o7GaBeWluJVEVaACtXjP5KzLJTEcrLLfC4jpX4nspYgAs6iZdxKCjhjomsVlnMwUXCaYU95ZiSxR6K9NUm0xIjG4p2K1HKDhU0p05ofr7V2K5spOU6jnbTQpTXl4y0ZQS03Kx0Gya4YeA8GV5NSa0ZLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bK40M8u/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bK40M8u/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2D01F000E9;
	Mon, 29 Jun 2026 13:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782739367;
	bh=TZL7zu0RXcZyP+jAL1BL6oqmsEQSKzXRygCDtpFGrRE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bK40M8u/krrwoYnXdvZm6lkBuv7Q1O/LukMBx/i7igSsI6H32itC2MFJn8uIQKRSp
	 sYqmA0jME3CX/qyfBpNfE8iYtfAHTESoxqgRz3Pvjz4VSPizBZSkPPI6HCbpRF5AtB
	 1pbZu3qDsC1gi4bpVLdAHlkiTrE8WTL87vwcr/Xbk5oSIE4/FgLV+DOmhJ27jRWe9U
	 n2PxXb6baqut2+u3RmNFO63AyWLb1FzGse+ei3/rqBCU/63phl7BmyC5OWzsITAqvq
	 RdKDEU8oP9YtlO+OoMr6i0y9QTd/1qWn3aayI3Ix9IBKi2hkmH2WGSHqPT2zaLnqnZ
	 iUo+FBa7OBVdw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] target: Fix an overwriting of the error status code
Reply-To: sashiko-reviews@lists.linux.dev
To: "Markov Gleb" <markov.gi@npc-ksb.ru>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260629130932.684-1-markov.gi@npc-ksb.ru>
References: <20260629130932.684-1-markov.gi@npc-ksb.ru>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 13:22:46 +0000
Message-Id: <20260629132247.8C2D01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Invalid format specifier (`%lld`) and parsing function (`match_int=
`) used for 64-bit LUN values, causing silent truncation and parsing failur=
es.
- [High] Out-of-bounds heap read when parsing `initiator_sid` from APTPL me=
tadata if the provided string is shorter than 8 bytes.
- [High] Missing lock acquisition when adding to `aptpl_reg_list`, leading =
to linked list corruption on concurrent writes.
- [Medium] A pre-existing memory leak occurs when duplicate string keys are=
 provided in the APTPL metadata.
--

commit 351651d7e3ca454861c7698ee9547223c7b37c39
Author: Gleb Markov <markov.gi@npc-ksb.ru>

target: Fix an overwriting of the error status code

If the maximum field length is exceeded, the error status code written to
ret will be overwritten without verification, and data with an incorrect
field length will be passed to core_scsi3_alloc_aptpl_registration(). This
commit fixes the error handling by jumping to the "out" label instead of
breaking the switch statement.

> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targe=
t_core_configfs.c
> index 860e840461778..4436111900318 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -1636,7 +1636,7 @@ static ssize_t target_core_dev_pr_store_attr_res_ap=
tpl_metadata(
>  					" exceeds PR_APTPL_MAX_IPORT_LEN: %d\n",
>  					PR_APTPL_MAX_IPORT_LEN);
>  				ret =3D -EINVAL;
> -				break;
> +				goto out;

[Severity: Medium]
This is a pre-existing issue, but does match_strdup() leak memory if multip=
le
instances of the same key are supplied?

Just above these lines in target_core_dev_pr_store_attr_res_aptpl_metadata(=
),
when Opt_initiator_node is matched:

		case Opt_initiator_node:
			i_port =3D match_strdup(args);

If a user provides a string with duplicate keys, match_strdup() allocates n=
ew
memory and overwrites i_port without freeing the previous allocation. Could
this cause a memory leak?

>  			}
>  			break;
>  		case Opt_initiator_sid:

[ ... ]

[Severity: High]
This is a pre-existing issue, but is the 64-bit LUN value being silently
truncated and ignored?

Looking at the token definitions in drivers/target/target_core_configfs.c:

	{Opt_mapped_lun, "mapped_lun=3D%lld"},
	{Opt_target_lun, "target_lun=3D%lld"},

The match_one() function in lib/parser.c does not support the %lld format
specifier, which causes match_token() to fail and silently ignore these
options.

Furthermore, even if it did match, the parsed value is truncated because
match_int() only handles 32-bit integers:

		case Opt_mapped_lun:
			ret =3D match_int(args, &arg);
			if (ret)
				goto out;
			mapped_lun =3D (u64)arg;

Does this completely break PR APTPL state restoration for non-zero LUNs?

[Severity: High]
This is a pre-existing issue, but can we read out-of-bounds from the isid
pointer when parsing initiator_sid?

The isid string is dynamically allocated based on its length in
target_core_dev_pr_store_attr_res_aptpl_metadata().

When it is passed to core_scsi3_alloc_aptpl_registration() in
drivers/target/target_core_pr.c, it is read using get_unaligned_be64():

	if (isid !=3D NULL) {
		pr_reg->pr_reg_bin_isid =3D get_unaligned_be64(isid);
		snprintf(pr_reg->pr_reg_isid, PR_REG_ISID_LEN, "%s", isid);

If the initiator_sid provided by the user is shorter than 8 bytes,
get_unaligned_be64() will read past the end of the allocated string. Can th=
is
leak uninitialized memory or cause a crash?

[Severity: High]
This is a pre-existing issue, but is there a missing lock when adding to
aptpl_reg_list?

In core_scsi3_alloc_aptpl_registration() in drivers/target/target_core_pr.c,
the new registration is added to the list:

	pr_reg->pr_res_holder =3D res_holder;

	list_add_tail(&pr_reg->pr_reg_aptpl_list, &pr_tmpl->aptpl_reg_list);

Since configfs store attributes don't provide mutual exclusion, concurrent
writes to the res_aptpl_metadata attribute could invoke
core_scsi3_alloc_aptpl_registration() simultaneously.

Does pr_tmpl->aptpl_reg_list need to be protected by aptpl_reg_lock to
prevent linked list corruption during concurrent writes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629130932.684-=
1-markov.gi@npc-ksb.ru?part=3D1

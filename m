Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009963FB07A
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 08:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791362389; cv=none; b=LQgD+OGt6DUQ9CG7pW+Pmdd/oXMa86APLwxsDVVM42LvSteQ33YySj3i/SfKR0ThXW3PNEt5/OX09C9F4zdfoJxF0k+kO8cM/JS0XBUlekmpa0I56T5UTm+HYRIen9frjVXLMzwdKVXS150r22ejf3yHdgMyT/0RK6uybejNTsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791362389; c=relaxed/simple;
	bh=QtLKwcosSEOV7xHUJ6sD6Qp1Cy8Br1UsCJvXvy+52KY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=KHqvZqAwjtXsHkIkrPJkPYrsbcdZFxYJcJ9rUcnm6G0lUiwCIwzKJuyXWV9Z8DdsPkJyV5LlsOkJ2f3RkBhszTyjFfVZORWUqjGVvRR6qYl5dkUevvXqJhHMJ7N/GTFJRDuL1+JVepKSKkpYt30AJCfy3Ud5pyddh+ysZl8Tl4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AtjPBJ5s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AtjPBJ5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC441F0089B;
	Wed,  7 Oct 2026 08:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791362386;
	bh=15RkDs2hdXobIgTeqwaxgEP+vXigp6XSGK4VZ0YJIBk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AtjPBJ5sPXzJa3SUs/Im8P34swo8YRXmoAGKi2RDSePrYFfQgCVAvm47RQHFydo9c
	 bmSv/5PAzDkje3nrAVMmnmHqZDN53qkbc6s0cbCPPsZqK6s3ELoCeIFiyq9TyUfHGb
	 V9hCxjVzgzQ5c7IG0hb06PQdSLb9s/YXZYzPSlR5DzIOG/IDYl+F3FoXWPG8WF10yx
	 Ad0xrF6DP7akcWUJagQzlf8gzOLRYwRUTgcz1LxCKeDM/OESWjHMrZ4laymtkSdHXQ
	 ImyAchZh/3qoZ1bnm/m2U1RXyw8dA/LemYA/ZGaiVTrjb4zgBLyyOJhkmKoCZ6N+Xx
	 onssekJFXOhAA==
Message-ID: <sashiko-outbox-162753@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 5/7] zloop: add degrade_element control command
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007082344.1049179-6-dlemoal@kernel.org>
References: <20261007082344.1049179-1-dlemoal@kernel.org>
 <20261007082344.1049179-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 08:39:45 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] block: double-free and UAF in zloop_ctl_add error path
- [Low] block: missing presence check and error message for element_id in z=
loop_ctl_degrade_element
--

commit 85f6af597dc5c733cb0ab607eae7cb9cac0357b4
Author: Damien Le Moal <dlemoal@kernel.org>

zloop: add degrade_element control command

Allow users to mark storage elements of a zloop device as degraded using
the new "degrade_element" control command. The element to degrade is
indicated using the element_id option.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index e113ecd63c0b2..311588de853fc 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c

[ ... ]

> @@ -1384,6 +1890,8 @@ static int zloop_ctl_add(struct zloop_options *opts)
>  	kfree(zlo->base_dir);
>  out_destroy_workqueue:
>  	destroy_workqueue(zlo->workqueue);
> +out_destroy_storage_elements:
> +	kfree(zlo->elements);

[Severity: High]
Does this code introduce a double-free and use-after-free on zlo->elements?

When a failure in zloop_ctl_add() causes execution to jump to the
out_cleanup_disk label (which is located just above this block),
put_disk(zlo->disk) is called. This synchronously triggers the
zloop_free_disk() fops callback. This callback completely frees zlo and
its members, including zlo->elements.

The error path then falls through and accesses the already freed zlo pointer
to sequentially double-free the same resources, including the newly added
zlo->elements shown here.

Can this be triggered from user-space by writing invalid parameters or
encountering resource exhaustion during the device add command on
/dev/zloop-control?

[ ... ]

> @@ -1946,6 +1991,42 @@ static int zloop_ctl_remove(struct zloop_options *=
opts)
>  	return 0;
>  }
> =20
> +static int zloop_ctl_degrade_element(struct zloop_options *opts)
> +{
> +	struct zloop_device *zlo;
> +	int ret =3D 0;
> +
> +	if (!(opts->mask & ZLOOP_OPT_ID)) {
> +		pr_err("No ID specified for degrade_element\n");
> +		return -EINVAL;
> +	}
> +
> +	if (opts->mask & ~(ZLOOP_OPT_ID | ZLOOP_OPT_ELEMENT_ID)) {
> +		pr_err("Invalid option specified for degrade_element\n");
> +		return -EINVAL;
> +	}

[Severity: Low]
Does this code fail to verify the presence of the ZLOOP_OPT_ELEMENT_ID opti=
on?

This bitwise check in zloop_ctl_degrade_element() only validates that no
extra options are present, but it does not enforce that ZLOOP_OPT_ELEMENT_ID
is actually provided. If element_id is omitted, it defaults to 0 and
zloop_degrade_element(zlo, 0) will safely catch this and return -EINVAL.
However, the user receives a silent failure rather than an informative error
message about the missing required argument.

Can we add a check similar to ZLOOP_OPT_ID to ensure ZLOOP_OPT_ELEMENT_ID
is explicitly provided?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007082344.1049=
179-1-dlemoal@kernel.org?part=3D5

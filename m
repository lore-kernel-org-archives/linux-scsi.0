Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485564322F1
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801116; cv=none; b=swWYr3nvhj8L7xPij8MNnjP0ohPzqVu6SW2drMOMFUhJKShgPRHghXbcuPc36SpixNrZxZ/E7qGrDeMIEgyB9yten9dhzpoDQ0kUkN36/Ak9iOIUNVUrPCN6//7dHGHbrFDMdTFve/tYjeuy6IadB0rI9pGe+BvQl90N9Ks6JGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801116; c=relaxed/simple;
	bh=WLjZEU+9/hkWS5UQUb0qABvyOoNip57R3KCu/sOL+3g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Kg/9vIXaNIp8HANMuZsNPmNZtUeFWRiWteRn/jtJlp+/7RPTSgSxrFibhFJXlyNvejmePXfjxdFDYkd1CcSrgCgj8xTa8zKt6zHvonD4W5wwB8TuHphwESMbU2VCTwaJZ7Ref03GY5fK/BOf27W4uh8H4+TSQE0cCWf/8ZbyvkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KK28ZIsB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KK28ZIsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08011F000E9;
	Thu, 23 Jul 2026 10:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784801115;
	bh=hSHlHY+3FxXIv1mtc51j1V49vNf1EM8xyIUhHRhL4ws=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KK28ZIsB+OX0iBI9w515DnwYOj4ociP9pHdTgTAdIjy0YdL5A1ixBFXwKtfYhVRFo
	 GF6Dc+eZm/u/XezYax82TvZA0X1AReAhRgnGAWfyH8tmT8PfN2q8MMwUstFgns9rPS
	 zHr7q3WKiFLGFalTG1JAhIelNw+qAad1+3AxioBz1W9vHDaVZ+5inc0Pg5pJmqRMtr
	 f3KyoT/0KV5tcKzYqwR7Pd5fuMj7smIgFz5NdQZx5u+DpjDZyy6PKliQg82Fv/tg6s
	 uyjzWr8XqaPw6iybPEbZee9eQ3oqqLzj2EKCnAGLDg+qasK2pcVBxQdsqOG0r/N3pj
	 3sr3QkxuhCFVA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 07/28] libmultipath: Add sysfs helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-8-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-8-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:05:14 +0000
Message-Id: <20260723100514.C08011F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Calling `kstrtouint()` with an `int *` argument causes a compiler =
warning and leads to sign-extension overflow when parsed.
--

--- Patch [7]: [PATCH v4 07/28] libmultipath: Add sysfs helpers ---
commit ebebf59df39aef065973319479be0a19b5308cb0
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add sysfs helpers
   =20
This adds helpers for driver sysfs code to get/set iopolicy, show device pa=
ths
per NUMA node, and manage multipath attribute groups.

> diff --git a/lib/multipath.c b/lib/multipath.c
> new file mode 100644
> index 0000000000000..3ff4f42a096c2
> --- /dev/null
> +++ b/lib/multipath.c

[ ... ]

> +ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
> +			const char *buf, size_t count)
> +{
> +	ssize_t ret;
> +	int sec;
> +
> +	ret =3D kstrtouint(buf, 0, &sec);

[Severity: High]
Does kstrtouint() properly handle being passed a pointer to a signed int?
If a user writes a value >=3D 2147483648 to this sysfs attribute, could the
parsed value be interpreted as negative?

> +	if (ret < 0)
> +		return ret;
> +
> +	mutex_lock(&mpath_head->lock);
> +	mpath_head->delayed_removal_secs =3D sec;

[Severity: High]
If sec is evaluated as a negative number here, does this assignment
sign-extend the value into the unsigned long delayed_removal_secs field?

This could result in an extremely large 64-bit value, which might cause a
permanent resource leak of the multipath disk structures when
mod_delayed_work() delays the removal indefinitely.

> +	if (sec)
> +		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
> +	else
> +		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
> +	mutex_unlock(&mpath_head->lock);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D7

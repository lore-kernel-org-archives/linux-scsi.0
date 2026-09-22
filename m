Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25585372F8
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 23:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790120512; cv=none; b=KLxcsJZC+FfaSvC58V7q370W1DaIIRZpG1BoVdkenvllbVbGeaJQKzpr4wyur3dlRyy0azwzNOWCPUoqNR2g0nGTMmctormJBHe28Jiwpw4gFMVQH7IcT09Jxd3R6d6OLzAJfzoTEw1oT1toZbd6ct+bGQ3maUhVmTt1xPmernc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790120512; c=relaxed/simple;
	bh=jAfR7FadooclStbPW/C1qB9daqOhE6/Oyx7pcKOWeOI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LLsxQefY0GiT0lobZBgeEi4c3pWdiGTYdi2HCyY9K2U/Gx/M3dOqiS8IcdwSTLSJZRmFBOcLtdhtX0TlASBhlWGvFciq7jrONc7lK+nfwKjPicC3mKG7hkHJOPSf6l6+OC0Ec/DtCDI3l7G2lYR2/jMYILPvpcSCIlsSuCBkT6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zlh57xcO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zlh57xcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFBE1F000FF;
	Tue, 22 Sep 2026 23:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790120499;
	bh=OHlS5kDGWEsrYn7HgClBoIAcX3HX8OvEHeymYihPqq0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zlh57xcOxjsrfhURVDc7qKmgndEMT1AxT8ejEsNdj3GzWpFgIXfN+407OHoFfc0BC
	 vl6ZIWjJ/XIpBrfzFeN5/BAI53S05eWF7eT7yYAI98BhPb03B5VLWD42FZTc7jyT1/
	 Itpt7PBkgiY0wfJdEFkQEWBaJT7bkw2f+eNsmOAzLfF9y9OrPu0nLWnBOatyCb5FUM
	 smh9cmXndMwmENmetoliHujZzjkPEhn7SVmZpV8zklCx8xP8Qkx5ZuJNgNvNpSdfz0
	 sqDurP4yh2TkD6rjSLAcWJwYnBcNKKRzij45+L/Su+BVsYJjf0Ra4cSd1WpHaWF/8D
	 RfMVI/4RNDXqQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/7] scsi: scsi_debug: Improve lock context annotations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <06a3167ff74552c2d6877908039cc5023adeb49f.1790119506.git.bvanassche@acm.org>
References: <cover.1790119506.git.bvanassche@acm.org>
 <06a3167ff74552c2d6877908039cc5023adeb49f.1790119506.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 23:41:39 +0000
Message-Id: <20260922234139.ACFBE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] scsi: error code clobbered in __resp_write_same()
- [Medium] scsi: code and commit message mismatch for context_unsafe()
- [Low] scsi: inconsistent __context_unsafe annotation on sdeb_data_read_lo=
ck()
--

commit 48cf9cad9b28e1e200552389935c265b76bfca78
Author: Bart Van Assche <bvanassche@acm.org>

scsi: scsi_debug: Improve lock context annotations

Prepare the scsi_debug driver for enabling compiler-based lock context
analysis by defining context lock structures, annotating lock/unlock helper=
s,
and wrapping conditional metadata locks.

>     - Wrap the conditional metadata locking sections in resp_read_dt0() a=
nd
>       resp_write_dt0() with context_unsafe().

[Severity: Medium]
Are resp_read_dt0() and resp_write_dt0() still supposed to be wrapped
with context_unsafe()?

This isn't a bug, but the commit message explicitly states these conditional
metadata locking sections are wrapped, whereas the patch does not add any
context_unsafe() wrappers to these functions. Could this cause static analy=
sis
tools to incorrectly flag the conditional locking?

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index ed30b3950c4e2..ccaaf13cc2430 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c

[ ... ]

> @@ -4042,42 +4049,44 @@ static inline struct sdeb_store_info *devip2sip(s=
truct sdebug_dev_info *devip,

[ ... ]

>  static inline void
>  sdeb_data_read_lock(struct sdeb_store_info *sip)
> +	__acquires_shared(&sip->macc_data_lck)
> +	__context_unsafe(/*conditional locking*/)
>  {
>  	BUG_ON(!sip);

[Severity: Low]
Does sdeb_data_read_lock() actually perform any conditional locking itself?

It unconditionally calls sdeb_read_lock(), so the __context_unsafe annotati=
on
appears to be inconsistent with its counterpart sdeb_data_read_unlock() and
other wrappers like sdeb_data_write_lock() which correctly omit this tag.

[Severity: High]
Does the error handling path in __resp_write_same() inadvertently clobber
its error code?

This appears to have been introduced in an earlier patch in this series
("scsi: scsi_debug: Fix a locking bug in resp_write_same()") and remains
unfixed in the final state of the series:

drivers/scsi/scsi_debug.c:__resp_write_same() {
    ...
	} else
		ret =3D fetch_to_dev_buffer(scp, fs1p, lb_size);

	if (-1 =3D=3D ret) {
		ret =3D DID_ERROR << 16;
		goto unlock;
	} else if (sdebug_verbose && !ndob && (ret < lb_size))
    ...
unlock:
	sdeb_data_write_unlock(sip);
	ret =3D 0;
	return ret;
}

When fetch_to_dev_buffer() fails, ret is set to DID_ERROR << 16 and the code
jumps to the unlock label, where ret is unconditionally overwritten with 0.

Could this mask the error from the SCSI subsystem, leading it to believe
the write same command succeeded when it actually failed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790119506.gi=
t.bvanassche@acm.org?part=3D6

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A742475CB
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 19:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788809625; cv=none; b=czKVEHeQNSfMb+OQf8aITfLovX/CdhV7h+nX9+DAaMp8k0Ggk77g+kRUON33M1jmK9NspXSbJIKw/8iu2ttMVUlS6u1QasI7CQcIrmxzxT62qt/1KEKU5rukG5y4/eosefDsqejeS8EwEPomX7dKjZ09HKBWobO4/9/1VJaQHlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788809625; c=relaxed/simple;
	bh=uSl9guDydTZ6Tvl0WkRykipvAD0Xt3Aq+3Nu/8w69GU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GNdsq0lJpf6QK5KR7C+8ztdUA3X4oBgLrR1bxZl4CIXwYEoEyabCX+zUl/a2vGDaodNupmTjWIyr2P43oci82Ybpxpjhct0UppVD9cA+MM1SGr9N9t8Y4sjQGQiasn7F85E6azzQ/I/M0Lmvt1OUA2rO3OnxAjd7mty4mqGolt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VwQIYiG9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VwQIYiG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841D91F00A3A;
	Mon,  7 Sep 2026 19:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788809622;
	bh=ymLFwz9iAlhrQ7/NjQNHftL5fE42oHWXAClX9UW3bho=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VwQIYiG9lmGfwIAxnSkaRW9yvcDSCeCNIOxBYcBZ0TMQf4rhPL6Ei0eqL3SYsRm7X
	 xPZi8DNHApTNALSPiZY5UrNyNJMJnzQeB1HX0xBWuciU9F5NwtdStCR82T8ZpShfrd
	 3bMWlj5McKdJNxI9irurai9W66ZEEt2Q6ZXeYP4Vz9Uq7am73oLP4z5FR1NnM0yzD6
	 a8Mr21fwbJIq2DXDJITowG8j9viRa7nfo4r6qLqyAggIltNlIAyvZCe0vF2YHErQwr
	 OEmr1ZDb1qQyeKqG96WeKA1mdOm1VUEU+5Wid/JQENo0bhf/HqFJTgMx7q7u4R2kjC
	 1H96cHedf/GZg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/4] PM / devfreq: Fall back to previous_freq when
 get_cur_freq() fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bean Huo" <beanhuo@iokpp.de>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260907192140.2701755-2-beanhuo@iokpp.de>
References: <20260907192140.2701755-1-beanhuo@iokpp.de>
 <20260907192140.2701755-2-beanhuo@iokpp.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 19:33:42 +0000
Message-Id: <20260907193342.841D91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Medium] devfreq->resume_freq is incorrectly overwritten with devfreq->su=
spend_freq during system suspend, causing devices to resume to their suspen=
d frequency rather than their active frequency.
--

commit 252cf4045ad4d642d45961b4d6845aa317e8ee57
Author: Bean Huo <beanhuo@micron.com>

PM / devfreq: Fall back to previous_freq when get_cur_freq() fails

This commit updates devfreq_set_target() to fall back to the previous
frequency when get_cur_freq() returns an error. This prevents uninitialized
stack values from being passed to notifiers during frequency changes.

> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index f08fc6966eaee..f20d9a6607791 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -348,9 +348,8 @@ static int devfreq_set_target(struct devfreq *devfreq=
, unsigned long new_freq,
>  	unsigned long cur_freq;
>  	int err =3D 0;
> =20
> -	if (devfreq->profile->get_cur_freq)
> -		devfreq->profile->get_cur_freq(devfreq->dev.parent, &cur_freq);
> -	else
> +	if (!devfreq->profile->get_cur_freq ||
> +	    devfreq->profile->get_cur_freq(devfreq->dev.parent, &cur_freq))
>  		cur_freq =3D devfreq->previous_freq;
> =20
>  	freqs.old =3D cur_freq;

[Severity: Medium]
This is a pre-existing issue, but since we are modifying devfreq_set_target=
(),
I noticed a potential issue with how resume frequencies are stored.

Further down in devfreq_set_target(), there is this unconditional assignmen=
t:

drivers/devfreq/devfreq.c:devfreq_set_target() {
    ...
    if (devfreq->suspend_freq)
        devfreq->resume_freq =3D new_freq;

    return err;
}

When a device defines a suspend_freq, system suspend invokes
devfreq_suspend_device(), which places the device in the low-power state
by calling:

drivers/devfreq/devfreq.c:devfreq_suspend_device() {
    ...
    ret =3D devfreq_set_target(devfreq, devfreq->suspend_freq, 0);
    ...
}

Does this cause devfreq_set_target() to unintentionally overwrite the saved
active frequency with the suspend frequency?

It appears that during every system suspend cycle, resume_freq gets updated=
 to
the suspend_freq target. Will this cause devices to resume to their lowest
suspend frequency instead of their pre-suspend active frequency, degrading
performance until the governor recalculates a new target?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907192140.2701=
755-1-beanhuo@iokpp.de?part=3D1

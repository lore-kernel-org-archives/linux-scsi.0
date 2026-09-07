Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9874476CC0
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 11:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788780213; cv=none; b=FnuP6L/BcUSwygln1ErT5wMJsN9DE6g3bL4aI6CHRDDSl33eYYRDlcGImgaaqmowq/PdkW1shX+45vhuHuClFS6gljj1ADE6lzMUfdjsqwvkzY0naUBU2Oe7eHAP6Xg4HDPP88Mi4IuQZQSMZsP6r+TvCmj2qweEjXUcWBHkSsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788780213; c=relaxed/simple;
	bh=aPYB/+beuzYjKK0shFpts2vdUYzOHjKyOy0E6GZMGTU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ds0ajuNA3Q6ZxF0YRmdzOmqDeUdsvkwt8OaGRgscNr6IWnSysMyyPyI2IXfTm67y64PAQT1YwKnA52JeSDTP+stHvT1i2PAXoBWfCZ3CBP37qhZvw6sZYQAOB+lYfwOG5qUZ/fvrHh7YTIk/UhtyHDaB1m0NC0qBSNAuQQEu1Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NaMKhoQz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NaMKhoQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7635E1F00A3A;
	Mon,  7 Sep 2026 11:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788780207;
	bh=akqoYp7gl8veyGYL52AudSLEFA5Rd7shHOrLlo1xp7w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NaMKhoQzIVqeXcsTw587Ve0bHElyoAi6mZhqfoFIWeARkAlFMuJaa5qRCYb2yt1jH
	 /FjBa2ZKkPPLDS0/976spn5t7T02MBy4ffvxJHZZeM5XQ784XQ0Zp+j6BmDK8VlAtB
	 bNiRPp2vA5MATBvCXyqJhTZUcA5pWvdTKV2vQ4+JsZJLve9DGG+setCcee2YCAIQHX
	 lBYFc03tBOqMrDtcT+1Rm2pz4gQUW8b4XI3nY6FPph2EDowI/wW1YoJ/r6RfV7Mxxt
	 Xu3U2X6UdX4xR8+5RHGT9KXtVz+pPQkpvT3GOn4kN9Pie5tOoa2YiyvRmEuPlxMmSl
	 uVWC2SbSlNOAQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 06/27] libmultipath: Add delayed removal support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260907105021.1763236-7-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-7-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 11:23:26 +0000
Message-Id: <20260907112327.7635E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Disabling delayed removal via sysfs leaves pending IOs stranded in=
 the requeue list and fails to cancel the teardown timer.
--

commit 13530eba33df6a0206410ca4e486f37c5aabe865
Author: John Garry <john.garry@linux.dev>

libmultipath: Add delayed removal support

This commit adds support for delayed removal of multipath devices, similar
to NVMe. It introduces a sysfs attribute to configure a timeout window
during which I/O is requeued instead of failed when no paths are available.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index f24086a6e3012..9fcf0b743f0e1 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c

[ ... ]

> +ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
> +			const char *buf, size_t count)
> +{
> +	unsigned int sec;
> +	ssize_t ret;
> +
> +	ret =3D kstrtouint(buf, 0, &sec);
> +	if (ret < 0)
> +		return ret;
> +
> +	mutex_lock(&mpath_head->lock);
> +	mpath_head->delayed_removal_secs =3D sec;
> +	if (sec)
> +		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
> +	else
> +		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
> +	mutex_unlock(&mpath_head->lock);
> +
> +	/*
> +	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
> +	 * by its reader.
> +	 */
> +	mpath_synchronize(mpath_head);
> +
> +	return count;

[Severity: High]
Does disabling delayed removal here leave pending I/Os stranded in the requ=
eue
list and fail to cancel the teardown timer?

If all paths go offline while delayed_removal_secs is non-zero, new I/Os
are queued in requeue_list. If an administrator subsequently writes 0 to
this sysfs attribute to disable delayed removal,
mpath_delayed_removal_secs_store() in lib/multipath.c clears the
MPATH_HEAD_QUEUE_IF_NO_PATH flag but does not call
mpath_schedule_requeue_work() to flush existing stranded I/Os.

Additionally, it doesn't appear to cancel the pending remove_work timer,
which might cause the device teardown to be arbitrarily delayed by the old
timeout value rather than executing immediately upon user reconfiguration.
Could these unhandled I/Os hang indefinitely?

> +}
> +EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_store);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907105021.1763=
236-1-john.g.garry@oracle.com?part=3D6

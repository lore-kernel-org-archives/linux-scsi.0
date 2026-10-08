Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE6242124D
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 12:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791461052; cv=none; b=uXJQFdaotqLjZ21mRpIsW7+Sq+Ror/nRbFK4+FCllrUVhh297N6FsA2xmVwKnc16PBg1MK/WYDOs2n2nbGciNLSGdIco34YAme2AnZs4cUk+D87n2i1pIxynvry0mEwdpyUG0b9caJXn8oebjl5/fe4K1dVgbQMjl7b/GjBWHiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791461052; c=relaxed/simple;
	bh=i5n/nFAAZhYKfvUxaKmomdE3vdizfU5Wkoqu6Ne/Q2w=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=aM8/a59k8A4zoZBAeuHYTrL8kq9n56Lz+bIkVtIqVFrlFEdT5rMmY+C5Z5Cl+xpB+WNg6Egrq2r8GcTJ4QwJ+HoZieTEYMfCY+YMOdGD/KVQMrazmjdcKv414E5ALm+5kFeH/DelUAgCPeML9Fq8u95tK8/Svq9LVFqisXSk/eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oShrIZvG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oShrIZvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB401F000FF;
	Thu,  8 Oct 2026 12:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791461050;
	bh=0SBzFFPxjP/iFUPj2hlztfDi1HCd+jVXE57FxqQ3JJc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oShrIZvGL9ddwt0R7Z42z1e834EXb3cvBb6u+zG6qx8tqy6vJaL/e7zokP8IDp2Wv
	 Oa0ANd/jgJwfWXRJST9FpZVAyk5ejMpnKq3FSbu9/hYg7cbKs1MKc7sNfLIEFnlFhd
	 6+sUiXx6JxpPVr/gkzD6cm9TwsYGtRPOMH9EouJDbC/C7+r+FxZQUErje9uT0iHXcX
	 C3fRL8p9VAgAtSpQ9mPwT7uMSuBb65u8oVrZGNY8tJCXRj9QbrwYymikZsLSTYZpS1
	 2AtDdAeCElfvZJEAA6gZlewnLV+Bpc+tE9LjJAwihf+8IEiK6HfVggI4/61zZ6/YHO
	 BwJiMjqLmZ+0Q==
Message-ID: <sashiko-outbox-164131@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] scsi: sd: mark disk dead on surprise host removal to
 avoid I/O hang
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?77+977+977+977+977+977+9?= <hulianqin@vivo.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <TYUPR06MB6217570B9AFA4B5980FCCED0D2932@TYUPR06MB6217.apcprd06.prod.outlook.com>
References: <TYUPR06MB6217570B9AFA4B5980FCCED0D2932@TYUPR06MB6217.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 12:04:10 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: Data loss on orderly host teardown due to misidentified surp=
rise removal
--

commit 9a3b48997b6a95bc55f9d45d1fe71786ff63438c
Author:  <hulianqin@vivo.com>

scsi: sd: mark disk dead on surprise host removal to avoid I/O hang

This commit adds a scsi_host_in_cancel() check in sd_remove() to mark the
disk dead before del_gendisk(). This is intended to skip sync_filesystem()
during surprise removals where the device can no longer handle I/O.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index b0d2542fd3172..00cf408513ce4 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4270,6 +4270,16 @@ static void sd_remove(struct scsi_device *sdp)
> =20
>  	scsi_autopm_get_device(sdkp->device);
> =20
> +	/*
> +	 * If the host is being torn down (e.g. USB surprise removal),
> +	 * the device cannot handle I/O anymore.
> +	 * Mark the disk dead before del_gendisk() so that new I/O is
> +	 * rejected immediately and sync_filesystem() in del_gendisk()
> +	 * is skipped, avoiding a hang waiting for I/O that can never
> +	 * complete.
> +	 */
> +	if (scsi_host_in_cancel(sdkp->device->host))
> +		blk_mark_disk_dead(sdkp->disk);

[Severity: High]
Will this logic conflate all host removals with surprise removals?

The patch aims to skip sync_filesystem() only during surprise removals by
checking if the host is in SHOST_CANCEL. However, scsi_remove_host() in
drivers/scsi/hosts.c unconditionally transitions the host state to
SHOST_CANCEL for all host teardowns:

drivers/scsi/hosts.c:scsi_remove_host() {
    ...
    if (scsi_host_set_state(shost, SHOST_CANCEL))
    ...
}

Because SHOST_CANCEL is the standard teardown state for all removals,
including orderly ones like rmmod usb-storage or sysfs driver unbinding,
blk_mark_disk_dead() will set GD_DEAD for every host removal.

When del_gendisk() executes, it will bypass its own
blk_report_disk_dead(disk, false) because GD_DEAD is already set.

Could this skip sync_filesystem() entirely, causing all pending dirty page
cache data to be discarded instead of written back during an orderly unbind
or unload, resulting in data loss?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/TYUPR06MB6217570B9A=
FA4B5980FCCED0D2932@TYUPR06MB6217.apcprd06.prod.outlook.com?part=3D1

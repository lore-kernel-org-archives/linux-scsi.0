Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892B93D567F;
	Fri,  9 Oct 2026 08:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791534597; cv=none; b=KDbhnk1qefUJxVzeODDea3momLVUMAd2wbEqQ56aDw9wKfIezZIyp1q2Rms7N6MvcSMlHD+iGyPjE3u93vDA6FUxO+tfb3OFJY3OXiem9Sf2kiCC3F1lv+VNjhc910u4UuyxRf4PXNerSVXW5qrIMaFtpWf3OeWQxmn9Lcs3fn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791534597; c=relaxed/simple;
	bh=vnUHtpQk5yUM7X3ebgfXeNTNuOSXt7+dmcJH7/YyOGs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=kKvqJVE04Q3odR6J5/rU+0h2+XrIh5yZxbH1EbVQPHhw/7UqweSuNZlp/nje0cPTr98Kba3MlETblxVO/u8/o2WoaO3b8wzYKFsjEpBn0oELm+1Znt48oWOvpP4MfQG53t1IkzEoXBzWXECTuW7tDJd6dbPij6gygQYGbXTKkKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lcfmMht9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lcfmMht9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32A91F00893;
	Fri,  9 Oct 2026 08:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791534595;
	bh=tI0jJfrrjm8WzTe4f9Y2xQh89gGIW2xEi2bJEKO8HnM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lcfmMht9oLziLWXHYyP6nXW9oPKdWhqJiWd2++VWMw6HvDb4wC9I8bemM/ejTYBxX
	 L6EWIAWj0LxrKRcgaG7iNFiblFIJIcMLW7gEUYn7FyS6T4k8fI+6XCeRzHYEvR42qP
	 hh83zOfLijGqIqisxJxh1MK77OORmYFtdQ7G3BIREDcJUuQrf66q4IJTRR/5Y9ZPaT
	 iy2T/GsobVs7N9wj5SPk43HW/3qcoCTM/EnQ7uIC1LTtLrjsxXXeirtN8J7zV82nE+
	 blQkBsRDyba3/5aZpzhMlhABxH5a7zxEKR/X5PdamUK9E7vfuRDdiyBHQbocNxnBOS
	 iaL+kAedZsirA==
Message-ID: <sashiko-outbox-165090@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] usb: uas: implement .change_queue_depth to allow
 per-device queue depth override
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luca Cecchi" <luca.cecchi.info@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20261009081225.304319-1-luca.cecchi.info@gmail.com>
References: <20261009080341.295646-1-luca.cecchi.info@gmail.com>
 <20261009081225.304319-1-luca.cecchi.info@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 08:29:55 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] usb: uas: unsigned underflow in block queue depth via negative qde=
pth
- [High] usb: uas: negative qdepth corrupts block layer queue depth via sys=
fs
- [Medium] locking: data race on devinfo->qdepth between sysfs uas_change_q=
ueue_depth and uas_configure_endpoints
--

commit 4c7e73054e14e754e6e1a2516899bccc20bf7379
Author: Luca Cecchi <luca.cecchi.info@gmail.com>

    usb: uas: implement .change_queue_depth to allow per-device queue depth=
 override

This commit implements the .change_queue_depth callback for the UAS driver.
This allows users to dynamically lower the per-device queue depth via sysfs
to work around bridge firmware lockups without having to disable UAS
entirely.

> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 8655edbd66b16..0a9ae15be2bd6 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c

[ ... ]

> @@ -910,6 +910,20 @@ static int uas_sdev_configure(struct scsi_device *sd=
ev,
>  	return 0;
>  }
> =20
> +/*
> + * Implementing .change_queue_depth allows users to lower the per-device
> + * queue depth via sysfs.
> + */
> +static int uas_change_queue_depth(struct scsi_device *sdev, int depth)
> +{
> +	struct uas_dev_info *devinfo =3D sdev->hostdata;
> +	int max_depth =3D devinfo->qdepth - 2;

[Severity: Medium]
Could this read of devinfo->qdepth race with a concurrent USB bus reset?

If a user writes to the queue_depth sysfs attribute while a reset
(like uas_post_reset() or uas_reset_resume()) is occurring,
uas_configure_endpoints() can write to devinfo->qdepth before any locks
are acquired by the reset caller:

drivers/usb/storage/uas.c:uas_configure_endpoints() {
    ...
    devinfo->qdepth =3D usb_alloc_streams(devinfo->intf, eps + 1,
                                        3, MAX_CMNDS, GFP_NOIO);
    ...
}

Because uas_change_queue_depth() reads devinfo->qdepth without holding
shost->host_lock or devinfo->lock, can this lack of mutual exclusion lead
to an inconsistent observation of the queue depth?

[Severity: High]
Does this code expose the block layer to queue depth underflows?

If uas_configure_endpoints() fails during a USB reset, it can return a
negative error code (such as -ENOMEM or -22) which is assigned directly to
devinfo->qdepth.

If this happens, sdev->host->can_queue still retains its positive probe-time
value, so sysfs writes to queue_depth still pass validation in
sdev_store_queue_depth().

When this happens, max_depth is calculated as a negative value (e.g. -24).

> +
> +	if (depth > max_depth)
> +		depth =3D max_depth;
> +	return scsi_change_queue_depth(sdev, depth);

The requested depth is then capped to this negative max_depth and passed to
scsi_change_queue_depth() in drivers/scsi/scsi.c.

scsi_change_queue_depth() forwards this negative value to
blk_set_queue_depth(..., unsigned int depth) in block/blk-settings.c, where
it will implicitly cast to a massive unsigned integer.

Can this heavily corrupt the block layer's queue limits and lead to tag
exhaustion or memory corruption? Even if the underlying negative qdepth is
a separate issue, does wiring up change_queue_depth expose this previously
unreachable vulnerability to sysfs?

> +}
> +

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009081225.3043=
19-1-luca.cecchi.info@gmail.com?part=3D1

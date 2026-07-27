Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB2036C588
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785165681; cv=none; b=W9AMoGMX5P4GNI3kYZXLaW89XymUflvhnSewxy5UlZi3lTEDi1wvyvDQBzEbN84di2P9oe7uRJtL/ogMzTh4AEHS+3DoEdR3968dWKEFmzwFGqJnmbOxZUE5ICZHRgnOY+hi1UCSH3IcQhKKfr7Mr6A8FUe8Kw8KnJxbiIdkxUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785165681; c=relaxed/simple;
	bh=s1AxxIDZlyGxM2UZFa3i6gLjGgIwOCfwVnn1FIT43L4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=geMxyI45JdlN3Rba43O4NYQ+7u/fMJSrEpG+J0LCyd1Wjyr2gqePeld0adSqmZzsKGj9I/oT9/xuTRL2BTe9QkR/l9zAgPTQXjBHHdmsvS0Jjw2G3d8GxuICqHq9oShG80n/0jLzUX1QWG8xgvR+VyoRDw+boEPjBxnIMLn6b7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XLomMc7W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XLomMc7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DEB1F000E9;
	Mon, 27 Jul 2026 15:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785165679;
	bh=SXW2mBCcvkGBACevaYfwmGsFpr4XZrkXwY4fyCAj1MQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XLomMc7WQRHb/0g2nSLl4LcVWANEfZC5q4q477RywGzFrf1pRfZV1R5t5a8dYnHIi
	 HDYL3eCbtRCslgmXBNZ6iZhBPsysRoTiUAwq9rVmZmubQb3r2nGy8q2ujDzefUE70M
	 6wPFkG13OEKbVCP5fvoDVuhTKHq+2eFzRFKcX90Fmj7kFl69biCoyYC8R/siNF/hfO
	 fx18Tgh4FjgMUwg27kUA5RHqIq81Id0UvIrruGg/u9UOnJQKo+tniFmacgNrt+a+oD
	 k4nigWyIDtBRXDjI1TiItOC0LCXhNvLbZuSYdwGbXKFBuJvfE9wYe4ydaYPQBLlMOW
	 UfjTe6MAW0cwQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 15/27] scsi-multipath: clone each bio
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-16-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-16-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:21:19 +0000
Message-Id: <20260727152119.96DEB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `smpdt` template in `scsi_multipath.c` fails to implement lo=
gically required callbacks from `struct mpath_head_template`, which will ca=
use a NULL pointer dereference when the framework attempts to evaluate path=
 states.
--

--- Patch [15]: [PATCH v5 15/27] scsi-multipath: clone each bio ---
commit d3a7e352069146b0f42f27f5c63fadf38b17548f
Author: John Garry <john.garry@linux.dev>

scsi-multipath: clone each bio

For failover handling, this patch resubmits the original bio by cloning and
submitting each bio. This ensures each bio can be safely resubmitted for
SCSI, which unlike NVMe, has no guarantee that any bio submitted is either
all or none completed.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 1b955e19a6814..5999c59bf7297 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c

[ ... ]

> @@ -230,7 +231,34 @@ static int scsi_multipath_sdev_init(struct scsi_devi=
ce *sdev)
>  	return 0;
>  }
> =20
> +static void scsi_mpath_clone_end_io(struct bio *clone)
> +{
> +	struct bio *master_bio =3D clone->bi_private;
> +
> +	master_bio->bi_status =3D clone->bi_status;
> +	bio_put(clone);
> +	bio_endio(master_bio);
> +}
> +
> +static struct bio *scsi_mpath_clone_bio(struct bio *bio)
> +{
[ ... ]
> +}
> +
>  static struct mpath_head_template smpdt =3D {
> +	.clone_bio =3D scsi_mpath_clone_bio,

[Severity: Medium]
Is it safe to leave callbacks like is_disabled, is_optimized, and
remove_head uninitialized in this template?

Looking at the libmultipath framework, it appears to unconditionally invoke
these callbacks. For example, mpath_path_is_disabled() does this:

lib/multipath.c:mpath_path_is_disabled() {
    ...
    return mpath_head->mpdt->is_disabled(mpath_device);
}

Could this lead to a null pointer dereference when the framework attempts
to evaluate the path state or remove the multipath head, once the device
is fully hooked up?

>  };
> =20
>  static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D15

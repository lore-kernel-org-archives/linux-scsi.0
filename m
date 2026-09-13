Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59233016F5
	for <linux-scsi@vger.kernel.org>; Sun, 13 Sep 2026 03:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789271247; cv=none; b=fPSA5/X15XJxwI0lttaAMhWHUNc+kBbeUKDb1UM609qh0umwp50CAv+kibfxL9UHndONYrHuLlpJ3R8LZc9yU0TjebifoAb/lL1r32ZRYomH00E2xEsY/m0KZMHFhX7hVZTavVzouW7UWzBFXfXEwxiX0sgAxWZYYKeMdieAiW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789271247; c=relaxed/simple;
	bh=4kM+E2o1+RpJGbxfn99foJPV3PNmJVjf3GrZZ1jI+6c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BpMtUEj/pbnwyS8c5NWFBTFsXVFgZgB7ZY5q5RIngvYnwuAWJHsOkJ10AWwHPp4CCcg5ESfYo+vXtz+24gwU0OsrZlPOQqkB4USQOUZkLf0O4Hbmkg5QsL1tZNH1hjxUqWD2l6pY/vEmSoStGtwSKGvDmNLUlpy0Iv/aqsrCQJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ByGXrdje; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ByGXrdje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F751F000FF;
	Sun, 13 Sep 2026 03:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789271246;
	bh=Zh/wkn6TIhwyrnnQwyShuza44M0nLNU80F5+AX/w6jQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ByGXrdjeInSF9Q/CMIi/rjo3pACZx6AivBOHRnPw2XQaxhZpjo51Jm/XxxXtfjvUH
	 Gy2SvgzYbNZGOoIdwuL1505vN+n4lCEyKE8xz8d6ZSl3QQz4g5ez8LfdM30nMg/MtU
	 gq/7TLobnlKhx+JPr5r18ASuDaOCQteBhhaM4cZF4okIfKpU/4WkrQdKPM2Fbw9GQV
	 p6Lf25bT7GHMoxU0YnmPQ9JgsK3UgNAP4bK8eszTC+KQgRKl7FUuowK2k5+kmie9jz
	 gg0JZbGLrgLDhdVI6TNO+iq7BJp7AQ7ToeozchLCJkRKI4+Du3fzWd8ythui/WaJHU
	 IpISDzNOWyHrQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/3] scsi: ufs: rpmb: Decouple device lifecycle from
 devres to avoid UAF
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanley Jhu" <stanleyjhu@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260913033633.3159296-3-stanleyjhu@google.com>
References: <20260913033633.3159296-1-stanleyjhu@google.com>
 <20260913033633.3159296-3-stanleyjhu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 13 Sep 2026 03:47:25 +0000
Message-Id: <20260913034726.28F751F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Module Reference Leak / Unload Deadlock
--

commit c2fd812022915196c82ed205c8c33614922be2b5
Author: Stanley Jhu <stanleyjhu@google.com>

scsi: ufs: rpmb: Decouple device lifecycle from devres to avoid UAF

This commit addresses a use-after-free issue by tying the ufs_rpmb_dev
memory to its reference count instead of devres. It pins the SCSI WLUN
during probe, cleans up properly during release to break the lifecycle
cycle, and rejects requests once the WLUN is offline.

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index 783ecfc7581d7..373b60aba9166 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
[ ... ]
> @@ -177,25 +186,28 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
[ ... ]
>  		ufs_rpmb =3D kzalloc_obj(*ufs_rpmb);
>  		if (!ufs_rpmb) {
>  			ret =3D -ENOMEM;
>  			goto err_out;
>  		}
> =20
> -		ufs_rpmb->hba =3D hba;
> -		ufs_rpmb->dev.parent =3D &hba->ufs_rpmb_wlun->sdev_gendev;
> +		INIT_LIST_HEAD(&ufs_rpmb->node);
> +
> +		ret =3D scsi_device_get(sdev);

[Severity: Medium]
Does this code introduce a module reference leak that prevents driver unloa=
ding?

When ufs_rpmb_probe() calls scsi_device_get(), the following call chain occ=
urs:

ufs_rpmb_probe()
  scsi_device_get(sdev)
    try_module_get(sdev->host->hostt->module)

Since this is called during the driver's probe sequence, and the SCSI host
template module is likely this exact same module (ufshcd-core), it ends up
taking a reference on itself.=20

Because the reference won't be dropped until the device is released, and the
device won't be released while the module is held active, doesn't this crea=
te
a lifecycle deadlock where rmmod will permanently fail with -EBUSY?

> +		if (ret) {
> +			kfree(ufs_rpmb);
> +			goto err_out;
> +		}
> +
> +		ufs_rpmb->sdev =3D sdev;
> +		ufs_rpmb->region_id =3D region;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260913033633.3159=
296-1-stanleyjhu@google.com?part=3D2

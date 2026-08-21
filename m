Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFF54248A0
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 15:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787325844; cv=none; b=JC+G/p5cTFWDMpdcQEBPxc8HX/yoMQh1S1Fz1F1vEpHhy+bcAgyJ2hcWBefw1gHOPSdg3C3YwQezURILkhhmP67+8WZ8bIT555rAQdwB8Fqs4/wgvbcrdER0GD65MhPVfqO1/1wF1rtKFV4LNj/jE3vhHUmoURTxT07ZJj2qecA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787325844; c=relaxed/simple;
	bh=M37lGv/+jVQgn+CfWMumHu2Nk+hksZF2Af+CyH1H5X4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UDO2UmoNF+4Z3O1K7PJu0Q5ZbXqeD21N2mI4RUMuQXDaDoQP9/vyymopQr0fx/MB+QWTp8xtzclNyc9wuWwpDP4Cjz0UeX5ynStXUtVQcnhl6Mm0zSHU4MUW/wHaUIi2iNimpYU3Ua/StQ8OOdt2AWl44CuSKMRi5GHz40cp5ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XLNbODKW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XLNbODKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332881F000E9;
	Fri, 21 Aug 2026 15:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787325842;
	bh=jr5TLzMufQpL/4kk3btbnSuWnDafm4EBAxEoDiwtJgU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XLNbODKW1rRMhxAd76IASUURRbILr9t+fz1F+ASF5MBgtJ9i781sTsiII3t+X4ORO
	 +3TBlsQfgwlvKbyWBLKrcTcqL1buPkBKys9tB7Uoia9BPLQrFdY91fpb+aVAktc1yt
	 rrkI6bothilwFx4TBvH7NNp4x/dp5OEBs79WPj8DRiUXotkvyChG90fKemAldmjXKs
	 63Wks6LOkzyVraps5z3ASC/m+kSVw+i87qsfxnZCWOpEaYITtJmFEdJoRa7dfJZC2v
	 +Vzc47opuY6pNJJO5yjnCB3B57m/1mEX7WLtBHPL3g34S02EjrF7PAGA6SGzYA0Z4l
	 HlOTZ+a+jlNXQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jorge Ramirez-Ortiz" <jorge.ramirez@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260821150612.3944782-3-jorge.ramirez@oss.qualcomm.com>
References: <20260821150612.3944782-1-jorge.ramirez@oss.qualcomm.com>
 <20260821150612.3944782-3-jorge.ramirez@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 15:24:01 +0000
Message-Id: <20260821152402.332881F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-after-free due to improper devm_kzalloc allocation of a struct=
ure containing an embedded struct device.
- [High] Permanent resource leak of parent and child devices due to a circu=
lar reference dependency in the teardown path.
--

--- Patch [2]: [PATCH v3 2/2] ufs: rpmb: use a fixed-length RPMB dev_id ---
commit 9b16b5ee089ea3c3bc7689863d98de4a3af82dfa
Author: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

ufs: rpmb: use a fixed-length RPMB dev_id

The RPMB authentication key is derived from the dev_id handed to the RPMB
subsystem. OP-TEE expects a fixed 16-byte eMMC CID. This patch hashes the
variable-length UFS id into a fixed 16-byte dev_id using blake2b.

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index 5f98472369d00..90dd7fd64ff1f 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c

[ ... ]

> @@ -157,6 +159,7 @@ static void ufs_rpmb_device_release(struct device *de=
v)
>  int ufs_rpmb_probe(struct ufs_hba *hba)
>  {
>  	struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;

[Severity: High]
This is a pre-existing issue, but does using devm_kzalloc for a structure
that embeds a struct device lead to a use-after-free?

If a process holds an active reference to the embedded device by keeping a
sysfs attribute open during unbind, devres will automatically free the
memory when the remove function returns. When the process later closes the
file, the device's release callback will operate on the already freed memor=
y:

ufs_rpmb_probe() {
        ...
        ufs_rpmb =3D devm_kzalloc(hba->dev, sizeof(*ufs_rpmb), GFP_KERNEL);
        ...
        ufs_rpmb->dev.release =3D ufs_rpmb_device_release;
        ...
}

Should this structure be allocated with a standard kzalloc and explicitly
freed inside ufs_rpmb_device_release() to tie its lifetime to the device's
reference count?

>  	u8 dev_id[UFS_RPMB_ID_LEN];
>  	struct rpmb_dev *rdev;
>  	char *cid =3D NULL;

[ ... ]

> @@ -215,8 +218,10 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
>  			goto err_out;
>  		}
> =20
> -		descr.dev_id =3D cid;
> -		descr.dev_id_len =3D strlen(cid);
> +		blake2b(NULL, 0, cid, strlen(cid), dev_id, UFS_RPMB_ID_LEN);
> +
> +		descr.dev_id =3D dev_id;
> +		descr.dev_id_len =3D UFS_RPMB_ID_LEN;
>  		descr.capacity =3D cap;
> =20
>  		/* Register RPMB device */

[Severity: High]
This isn't a bug introduced by this patch, but is there a permanent resource
leak here due to a circular reference?

In ufs_rpmb_probe(), the child device is registered under the parent:

ufs_rpmb_probe() {
        ...
        rdev =3D rpmb_dev_register(&ufs_rpmb->dev, &descr);
        ...
}

Registering the child takes a reference on the parent. During teardown, if
only the parent is unregistered, the child still holds a reference, meaning
the parent's refcount never reaches zero. As a result, the parent's release
callback is never invoked:

ufs_rpmb_device_release() {
        ...
        rpmb_dev_unregister(ufs_rpmb->rdev);
}

Since the child is only unregistered in the parent's release callback, both
devices will be leaked permanently. Should the child be unregistered
explicitly during the removal path before unregistering the parent?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821150612.3944=
782-1-jorge.ramirez@oss.qualcomm.com?part=3D2

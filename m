Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E5B3515FF
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 07:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787815068; cv=none; b=QBa8PYadb0Efh0Q7uhoHQrrAFWx57E3Vnwe6P+ReRqhrRE3IDLrepmIei+tjA4I6Wg4wVJfi+ukns0iepPVvW89meuVFRv9JrfXhdViTSzL367sB1h8THOBjJgrC2X97GlbApeRyep8seKBeC9C+6oF/QT490hlGmNdYoQ1Mw7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787815068; c=relaxed/simple;
	bh=IlF8lxpN65tSEps9YEp83Z26uKsCA1Na0uQK9reHjDU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lGWJBS3svcaOQTaA2Jfe/EuJmImL08CpvK1ZFVGeUwMv91A3ZryZ4lJeCTekq24AOPLAF0EZWC+kr+/QICcVfykyEIsILNpuC9GiG6CVIryxziIwFnda3RxoISG+O1JIcuHoEofZDAhmDtQLAqhvAazWB9TgA5m1fSymBq6IGkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X7ZqMdUO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X7ZqMdUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C0E1F000E9;
	Thu, 27 Aug 2026 07:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787815065;
	bh=5p5HNp1Y00vpynkW7HzJ0HYp2iB57W02heMFVsq1tNY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X7ZqMdUO8Zisow2u3r8aLPzivlBUdrM2yhLvwOFCTlHZfv2UtURdN/R2z34WKApRz
	 HTGSSU9lPxtvjmymzKvSuT6VMmFd8pOYfjA5A4Ma4lxspcd4nHaXQ5uT4j/POTIpGb
	 Bp92n9BdY1RLVweHp+GcV6P6Gc9hpEnxzQG6jIskwxJnBek4ACUveMYUsRc0cqrJOv
	 7ziDgk0WT0UPSfjj4AXVMWYZqi3HpK4xM8VwroiTK9OH3ax+0k9YkiUd4UCehNSfKo
	 w/JaE1O2DHgojZ4glEhCNxiixDO/lS+i7pOlBko9HjSzhQmVuzRReD9O7jHLpi9pqk
	 dFmU1GP1cRddQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jorge Ramirez-Ortiz" <jorge.ramirez@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260827070345.2853821-3-jorge.ramirez@oss.qualcomm.com>
References: <20260827070345.2853821-1-jorge.ramirez@oss.qualcomm.com>
 <20260827070345.2853821-3-jorge.ramirez@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 07:17:44 +0000
Message-Id: <20260827071744.E5C0E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The bus type `ufs_rpmb_bus_type` is never registered, causing devi=
ce_register() to unconditionally fail.
- [High] Using devm_kzalloc for a structure embedding a struct device viola=
tes driver model lifetime rules, leading to a Use-After-Free on unbind and =
memory leaks on error paths.
- [High] Parent-child reference counting deadlock in device removal paths p=
revents unregistration and causes a permanent memory and device leak.
--

commit ecc19262c86a06d5ad583f54476cad317a179650
Author: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

ufs: rpmb: use a fixed-length RPMB dev_id

The RPMB authentication key is derived from the dev_id handed to the RPMB
subsystem. A fixed 16-byte dev_id is needed so the derived key stays stable
and unique per region while matching the eMMC CID layout.

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index 00ba4f3b842bf..783ecfc7581d7 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c

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
This isn't a bug introduced by this patch, but looking at how the bus is
assigned slightly earlier in ufs_rpmb_probe():

	ufs_rpmb->dev.bus =3D &ufs_rpmb_bus_type;

Is ufs_rpmb_bus_type ever registered with bus_register()? If it is never
registered, won't device_register() unconditionally fail with -EINVAL becau=
se
it cannot find the subsystem for the unregistered bus, breaking the UFS RPMB
registration on every boot?

[Severity: High]
This is a pre-existing issue, but I noticed that ufs_rpmb_probe() allocates
the ufs_rpmb structure using devm_kzalloc() slightly earlier in the same
function:

	ufs_rpmb =3D devm_kzalloc(hba->dev, sizeof(*ufs_rpmb), GFP_KERNEL);

Since this structure embeds a struct device (ufs_rpmb->dev) which gets
registered with device_register(), could this lead to a use-after-free on
unbind?

If a user unbinds the hba->dev driver while holding a sysfs reference to
ufs_rpmb->dev, devres will immediately free the memory. When the user later
drops the final reference, wouldn't the kernel access the freed memory when
calling ufs_rpmb_device_release()?

[Severity: High]
This is a pre-existing issue, but is there an unresolvable cyclic dependency
during device removal? Looking at how the child device is unregistered insi=
de
the parent's release callback:

drivers/ufs/core/ufs-rpmb.c:ufs_rpmb_device_release() {
	struct ufs_rpmb_dev *ufs_rpmb =3D dev_get_drvdata(dev);

	rpmb_dev_unregister(ufs_rpmb->rdev);
}

When device_unregister(&ufs_rpmb->dev) is called during a probe error path =
or
removal, the child device (rdev) is not unregistered first. Since the child
still holds a reference to the parent, the parent's refcount never reaches =
0.
Wouldn't this prevent ufs_rpmb_device_release() from ever executing, causing
both devices to be permanently leaked?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827070345.2853=
821-1-jorge.ramirez@oss.qualcomm.com?part=3D2

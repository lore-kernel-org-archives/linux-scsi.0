Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EF935DA4A
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 18:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788202741; cv=none; b=jjoU0iq9qZ+lEx2hZi5PUlKaxOS4AeyMc5x4ijsfmAVBRr+OYK8fqbBqebG6/hXNGWlVpDDX0ZsXWoDO6m6x2c9UxVf1cCHBgb5fDdMdbUE9quJLXC4HAMArFE+maO9vG7KoFK/6Slim90i98KNbIRg2DXWXBkG8XdqVanuuwKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788202741; c=relaxed/simple;
	bh=97iLlLM7/Npn6chgs+ow+W9qugbFQdx9LW9RzgSb8Rw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EPmsVyZxhDx8PlHJtKeF0vqSZvsY/nAl+u7NMFCPYe3cpbVunud2YpYNHRQegoGl1wb9V+wl1zTnwXvOtQ48IQuVz2Bw3R/JVU9xi+ooMYObcvdA9Hhsj5q4q+jL1yjLKdXTXQilB/AXxBg/mnHK9o3KK4lYgJrE5AEQKVlMGLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GUrV6ZDV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GUrV6ZDV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607811F000E9;
	Mon, 31 Aug 2026 18:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788202739;
	bh=SzILj7kzwCRMJ/Gx9f1GXS1Xlim1Dl7D3vtUmk9IHLs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GUrV6ZDV2sBRVjg423fokOVMoQQWOIIRU/J4P76oUwstU6gIMUZnuQegfO+tiLIBh
	 DxVcpxnUIh1MpW+Cqh+kVydgNA9Wu3G+/ROrAie+DQtkNXXlJf53IrMU/5eE3ianFc
	 bsAV4gTU5m1YC3DeOthDCmxRm+VXwXdBxbpJ3i2D/4rkvPcbJ3uaqNzEb/UpE9/DLt
	 3Cd0d7gfWVXAN6FB9KlPtEi/c/CjWl8Wpg2VQrDadaN+1rd73ZnnC7l6/i/KxV1MJ3
	 Ccfkdu78O40azdX/hlDzS9ksmIohrAKmhh2xotG/CyrRN5UYIhXM+UR5JNCJE5z4B7
	 TwqrN3NE4FKeg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jorge Ramirez-Ortiz" <jorge.ramirez@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260831154804.719528-3-jorge.ramirez@oss.qualcomm.com>
References: <20260831154804.719528-1-jorge.ramirez@oss.qualcomm.com>
 <20260831154804.719528-3-jorge.ramirez@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 18:58:58 +0000
Message-Id: <20260831185859.607811F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Allocating a structure embedding a reference-counted `struct devic=
e` with `devm_kzalloc()` causes a Use-After-Free due to lifecycle mismatch.
- [High] Circular reference between `ufs_rpmb->dev` and `rdev` prevents dev=
ice cleanup, leading to permanent resource leaks of both device structures.
- [High] Initialization race: RPMB device is exposed to the subsystem and n=
otifiers before `region_id` is initialized.
- [High] The `ufs_rpmb_bus_type` is never registered with the driver core, =
causing `device_register()` to deterministically fail.
--

commit a3eaa4c56fa0d1803a39f46b9f298247acd5bdfd
Author: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

ufs: rpmb: use a fixed-length RPMB dev_id

The RPMB authentication key is derived from the dev_id handed to the
RPMB subsystem. OP-TEE implements the eMMC RPMB flow, where the dev_id
is the eMMC CID: a fixed 16-byte value the key derivation depends on.

[ ... ]

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index 00ba4f3b842bf..783ecfc7581d7 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -21,6 +22,7 @@
>  #include <linux/unaligned.h>
>  #include "ufshcd-priv.h"
> =20
> +#define UFS_RPMB_ID_LEN			16	/* Match eMMC CID Length */
>  #define UFS_RPMB_UA_RETRIES		3	/* Retries for the power-on UNIT ATTENTIO=
N */
>  #define UFS_RPMB_SEC_PROTOCOL		0xEC	/* JEDEC UFS application */
>  #define UFS_RPMB_SEC_PROTOCOL_ID	0x01	/* JEDEC UFS RPMB protocol ID, CDB=
 byte3 */

[Severity: High]
This is a pre-existing issue, but the ufs_rpmb_bus_type defined nearby is
completely missing a corresponding bus_register() call anywhere in the code=
base:

static const struct bus_type ufs_rpmb_bus_type =3D {
	.name =3D "ufs_rpmb",
};

When ufs_rpmb_probe() assigns this unregistered bus type to ufs_rpmb->dev.b=
us:

	ufs_rpmb->dev.bus =3D &ufs_rpmb_bus_type;

does this guarantee that device_register() will deterministically fail when=
 it
attempts to retrieve the bus subsystem?

[ ... ]

> @@ -157,6 +159,7 @@ static void ufs_rpmb_device_release(struct device *de=
v)
>  int ufs_rpmb_probe(struct ufs_hba *hba)
>  {
>  	struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
> +	u8 dev_id[UFS_RPMB_ID_LEN];
>  	struct rpmb_dev *rdev;
>  	char *cid =3D NULL;
>  	int region;

[Severity: High]
This isn't a bug introduced by this patch, but ufs_rpmb_device_release() ju=
st
above here accesses memory that could have already been freed:

static void ufs_rpmb_device_release(struct device *dev)
{
	struct ufs_rpmb_dev *ufs_rpmb =3D dev_get_drvdata(dev);

	rpmb_dev_unregister(ufs_rpmb->rdev);
}

Since ufs_rpmb_probe() allocates ufs_rpmb with devm_kzalloc() and subsequen=
tly
calls device_register(&ufs_rpmb->dev), if the host driver unbinds, devres w=
ill
free ufs_rpmb unconditionally. If a local user holds an open file descripto=
r or
sysfs reference to the device, the kobject remains alive.

When the final reference is dropped, ufs_rpmb_device_release() is invoked,
which then dereferences the already-freed ufs_rpmb memory. Can this cause a
use-after-free?

[Severity: High]
This is also a pre-existing issue, but child unregistration is incorrectly
placed inside the parent's release function:

static void ufs_rpmb_device_release(struct device *dev)
{
	struct ufs_rpmb_dev *ufs_rpmb =3D dev_get_drvdata(dev);

	rpmb_dev_unregister(ufs_rpmb->rdev);
}

During driver removal, ufs_rpmb_remove() calls device_unregister(&ufs_rpmb-=
>dev)
on the parent before unregistering the child. Because the child still pins =
the
parent's refcount, the parent's refcount never reaches zero, preventing its
release function from executing.

Does this create an unbreakable circular reference that prevents device cle=
anup
and permanently leaks both device structures?

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
This isn't a bug introduced by this patch, but there is an initialization
race when registering the RPMB device just below this block:

		/* Register RPMB device */
		rdev =3D rpmb_dev_register(&ufs_rpmb->dev, &descr);
		...
		ufs_rpmb->rdev =3D rdev;
		ufs_rpmb->region_id =3D region;

rpmb_dev_register() exposes the device to the rpmb_class, which synchronous=
ly
triggers class notifiers. If a notifier like OP-TEE schedules a workqueue to
probe the RPMB device, the worker could issue SMC calls resulting in an RPC
back to ufs_rpmb_route_frames(), which relies on ufs_rpmb->region_id.

Since ufs_rpmb->region_id is initialized after rpmb_dev_register() returns,
could the asynchronous probe thread read an uninitialized region_id for
non-zero regions?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831154804.7195=
28-1-jorge.ramirez@oss.qualcomm.com?part=3D2

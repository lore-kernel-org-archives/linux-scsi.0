Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACB13BB10C
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 10:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783075486; cv=none; b=IsOh++1VFJc+7s9XkG16VzQGzaydRQ9B4YXW9wXWXWKBrVuqkV1lg4JmN2zGVnBAKbLbIjtGNKq/kz4hLlNoJoWZfWtPjHTLf1JRQJ5Y7kNlCq5k87GsUCVtVeba29RQWRlBqs7PNmcRNtiW7dUVv3eUnFHq/EWyF+CS1Ss4p/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783075486; c=relaxed/simple;
	bh=HEopqKzMioiIPS0t9+HQn4UQrbmGkJKHoUJfKWZ8pE8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Kz6A01/afu0GR1RiDQQnV9SYwJczKPA5H6yZHUxcYyuQ/8K+LsQ0voboqBnRJ5UXvycQe9aKfgXv9QP3GCVY8wnDvGOcm41t/Ou/qpOSujbFmLvj3hb0/IYw50+JlNLwiWTqOI02UbrekhsdxYSSlwDTWoZak+Lw9IrYKNqc6Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NL3ipNzh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NL3ipNzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AA41F000E9;
	Fri,  3 Jul 2026 10:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783075485;
	bh=J2q7mKwrewPFravz8xLdVGeSwb3VSdh2kYA0uG9F8no=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NL3ipNzh15S+iQfWZ4sRr9Jzm9YRc04ZwRtlOZv24c8OTlkgeQlD0vV2x0o8a9xC9
	 3N6zflyKmCh1tNceUnlMbN7mA6N5fj+M/g6l/9vpHk0tRIU0TwLSFL7AENolv/H4/Z
	 L2ysSYN2e6adg9EREpE+PL7ax63GyvZscK9Zj4GWjQqvv3+qMiWNN6cCPJhB88Kg9+
	 QZBOXiptwDjggladG1Xa25G2dfc7WCGOswuHE6UX4WX/z23jy+8MizwlGB98IEKsHT
	 w7mg8axsn/w5Sogb/yjzTdT6TVYRmeopENWyW67+/oZUe3V5nJ3LrwXJ4+UjDMpAp1
	 rwcGD3PcqRvzw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/10] nvme-multipath: add initial support for using
 libmultipath
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103204.3724406-2-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
 <20260703103204.3724406-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:44:44 +0000
Message-Id: <20260703104444.F0AA41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] The commit message claims to add an `mpath_disk` pointer to the =
head structure, but it is entirely missing from the implementation.
- [Low] The patch selects a non-existent Kconfig symbol `LIBMULTIPATH`.
- [Low] The patch references a non-existent header file `<linux/multipath.h=
>` and instantiates undefined, incomplete structure types.
--

commit 733f55d7e9c3919c9123eedece5d53fa4f13cc46
Author: John Garry <john.g.garry@oracle.com>

nvme-multipath: add initial support for using libmultipath

This patch introduces initial structural changes to support libmultipath in
the nvme subsystem. It modifies nvme Kconfig, nvme_ns, and nvme_ns_head
structures to include multipath components.

> Add initial support, as follows:
> - Add mpath_head_template
> - Add mpath_device in nvme_ns
> - Add mpath_disk pointer to head structure

[Severity: Medium]
The commit message states that an mpath_disk pointer is being added to the
head structure, but the actual implementation below adds a struct mpath_head
by value instead. Is the commit message stale, or was this pointer omitted
by mistake?

> diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
> index 31974c7dd20c9..1b3f76e781bad 100644
> --- a/drivers/nvme/host/Kconfig
> +++ b/drivers/nvme/host/Kconfig
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config NVME_CORE
>  	tristate
> +	select LIBMULTIPATH

[Severity: Low]
Does the LIBMULTIPATH Kconfig symbol exist in the tree? Selecting a
non-existent symbol here will result in Kconfig unmet dependency warnings.

> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index 9b9a657fa330f..14947736744a5 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c

[ ... ]

> @@ -1496,3 +1496,7 @@ void nvme_mpath_uninit(struct nvme_ctrl *ctrl)
>  	ctrl->ana_log_buf =3D NULL;
>  	ctrl->ana_log_size =3D 0;
>  }
> +
> +__maybe_unused
> +static const struct mpath_head_template mpdt =3D {
> +};

[Severity: Low]
Does this compile? The struct mpath_head_template type does not appear to be
defined anywhere.

> diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
> index 824651cc898db..3e023948015ac 100644
> --- a/drivers/nvme/host/nvme.h
> +++ b/drivers/nvme/host/nvme.h
> @@ -13,6 +13,7 @@
>  #include <linux/blk-mq.h>
>  #include <linux/sed-opal.h>
>  #include <linux/fault-inject.h>
> +#include <linux/multipath.h>

[Severity: Low]
Is linux/multipath.h present in the tree? Including a missing header will
cause build failures.

[ ... ]

> @@ -560,6 +561,8 @@ struct nvme_ns_head {
> =20
>  	u16			nr_plids;
>  	u16			*plids;
> +
> +	struct mpath_head	mpath_head;
>  #ifdef CONFIG_NVME_MULTIPATH
>  	struct bio_list		requeue_list;
>  	spinlock_t		requeue_lock;
> @@ -590,6 +593,7 @@ enum nvme_ns_features {
>  };
> =20
>  struct nvme_ns {
> +	struct mpath_device mpath_device;
>  	struct list_head list;

[Severity: Low]
Since linux/multipath.h does not seem to exist, these embed undefined
structures (struct mpath_head and struct mpath_device) directly by value,
which will result in incomplete type errors during compilation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103204.3724=
406-1-john.g.garry@oracle.com?part=3D1

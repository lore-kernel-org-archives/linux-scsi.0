Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9158737A855
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 10:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783076007; cv=none; b=fhee2BUocwzL3j2aJQjkBa1qNzn07bR+tVhBuP/wMmbIEOU6r2TbUH0pvi/dLdXzvODeay5yLTFuQrgPhFFMoCHqDPKZ8ObXIZ4mrTdIQIuLpXymHGBV5m25YKd06UrLOMWzMlOmqBGLXBERX5ZG2IocTcwwOTKHQWJeviB0RaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783076007; c=relaxed/simple;
	bh=KywFONElE+FAbRYxxOYZQo4CgnTQKxpKHMDN7dK7CBk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VXM2ZLiKLU8GvR0Z5TOoNL5vg0oYjhJD8zBUkjSCYGXt8qPaa6RHRf9ag/YBsb/FqY/b4hZBLqlAgN5Y3NoIbkwaXD5u0UlHbvtJKtjADgDkoUYzNXq5iXT7d9f9WXIUpbcc9wgxCjxdVD9SNYAw2wbDDRaXIZ8/PJmnaksJHww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhWDrpan; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhWDrpan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9721F000E9;
	Fri,  3 Jul 2026 10:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783076006;
	bh=y98xSyc01RgZ36+PfS1R92y2c7voua0rbsS/pahdFoA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JhWDrpan+dZT4QjUxW39njXbBbX9MN1fFMUR+rPYXGpZGdsESNq535s+BHjs8l4cU
	 kIYrd8wIqturb9dTuDWP2pGQAUansMQrRugKr6M4/gcPY7WVPn0E1aoDBGcmGmVjER
	 LeuLNf8q5JtMEYrFfcxQ1Tk5aDFgPJ2SDcBn/+4eWAsTtfKl5b4DgbQMu/QAnfRbOn
	 tcWsEwa2TljYfApZkr9yWd5I2r1NiPnyqO8o+KKv/rMrUWE476eoKABM85kWGEb5g0
	 LR7hjCODZkafzbwnIz12lwNF9SCLNdlaxYFnPIWiOeiJKze3tO92pjF8G3vFBUGpMX
	 7Jy9gNa+Jz6Ww==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/17] scsi-multipath: introduce basic SCSI device
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103402.3725011-2-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:53:25 +0000
Message-Id: <20260703105326.0D9721F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Medium] The module parameter parsing logic loosely matches string prefix=
es instead of exact values, mistakenly accepting unintended input.
- [Low] The Kconfig symbol SCSI_MULTIPATH selects a non-existent symbol LIB=
MULTIPATH.
- [Low] The patch includes a non-existent header <linux/multipath.h> and re=
ferences undefined structures, unconditionally breaking the build.
- [Low] The debug log message incorrectly states that 'IMPLICIT TPGS' is re=
quired, while the code accepts any ALUA TPGS support.
--

commit ad9f5e786299d2bbf9325dfe336051204d3f7369
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: introduce basic SCSI device support
   =20
For a scsi_device to support multipath, introduce structure
scsi_mpath_device to hold multipath-specific details.

> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index c3042393af234..d6c31df454825 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
[ ... ]
> @@ -76,6 +76,16 @@ config SCSI_LIB_KUNIT_TEST
> =20
>  	  If unsure say N.
> =20
> +config SCSI_MULTIPATH
> +	bool "SCSI multipath support (EXPERIMENTAL)"
> +	depends on SCSI_MOD
> +	select LIBMULTIPATH

[Severity: Low]
Does the config symbol LIBMULTIPATH exist in the tree? Selecting a
non-existent symbol causes unmet dependency warnings and breaks the
dependency inheritance chain.

> +	help
> +	  This option enables support for native SCSI multipath support for
> +	  SCSI host.
> +
> +	  If unsure say N.
> +
>  comment "SCSI support type (disk, tape, CD-ROM)"
>  	depends on SCSI

[ ... ]

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> new file mode 100644
> index 0000000000000..ff37cfdf2f9d1
> --- /dev/null
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -0,0 +1,146 @@
[ ... ]
> +static int scsi_multipath_param_set(const char *val, const struct kernel=
_param *kp)
> +{
> +	if (!val)
> +		return -EINVAL;
> +	if (!strncmp(val, "on", 2))
> +		scsi_multipath =3D SCSI_MULTIPATH_ON;
> +	else if (!strncmp(val, "always", 6))
> +		scsi_multipath =3D SCSI_MULTIPATH_ALWAYS;
> +	else if (!strncmp(val, "off", 3))
> +		scsi_multipath =3D SCSI_MULTIPATH_OFF;

[Severity: Medium]
Since scsi_multipath_param_set() uses strncmp() with exact lengths, won't it
silently accept strings like "once" or "office" instead of returning -EINVA=
L?
Should this use sysfs_streq() or strcmp() to ensure exact matches?

> +	else
> +		return -EINVAL;
> +
> +	return 0;
> +}

[ ... ]

> +int scsi_mpath_dev_alloc(struct scsi_device *sdev)
> +{
> +	int ret;
> +
> +	if (scsi_multipath =3D=3D SCSI_MULTIPATH_OFF)
> +		return 0;
> +
> +	if (!scsi_device_tpgs(sdev) && (scsi_multipath !=3D SCSI_MULTIPATH_ALWA=
YS)) {
> +		sdev_printk(KERN_DEBUG, sdev, "IMPLICIT TPGS are required for multipat=
h support\n");

[Severity: Low]
This isn't a bug, but the log message says IMPLICIT TPGS is required, while
the check for scsi_device_tpgs(sdev) accepts any TPGS support (implicit,
explicit, or both). Could the message be updated to match the check?

> +		return 0;
> +	}
> +
> +	ret =3D scsi_multipath_sdev_init(sdev);
> +	if (ret)
> +		return ret;

[ ... ]

> diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
> new file mode 100644
> index 0000000000000..d3d410dafd17a
> --- /dev/null
> +++ b/include/scsi/scsi_multipath.h
> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _SCSI_SCSI_MULTIPATH_H
> +#define _SCSI_SCSI_MULTIPATH_H
> +
> +#include <linux/list.h>
> +#include <linux/types.h>
> +#include <linux/rcupdate.h>
> +#include <linux/workqueue.h>
> +#include <linux/mutex.h>
> +#include <linux/blk-mq.h>
> +#include <linux/multipath.h>

[Severity: Low]
Does linux/multipath.h exist in the tree? Including a non-existent header
will unconditionally break the build for any file including this header.

> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_dbg.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_devinfo.h>
> +#include <scsi/scsi_driver.h>
> +
> +#ifdef CONFIG_SCSI_MULTIPATH
> +#define SCSI_MPATH_DEVICE_ID_LEN 256
> +
> +struct scsi_mpath_device {
> +	struct mpath_device	mpath_device;

[Severity: Low]
Because linux/multipath.h is missing, struct mpath_device is undefined,
which results in an incomplete type error when CONFIG_SCSI_MULTIPATH is
enabled. Is there a missing patch series this depends on?

> +	struct scsi_device 	*sdev;
> +
> +	char			device_id_str[SCSI_MPATH_DEVICE_ID_LEN];
> +};

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103402.3725=
011-1-john.g.garry@oracle.com?part=3D1

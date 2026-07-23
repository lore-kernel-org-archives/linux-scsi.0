Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC41421244
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 20:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784838454; cv=none; b=jPRon6SRC9GTyxRw6lTJvAkbonp3o4TCzJ3hKXicm10ChS2fURRkgWbPp8GUUu8wxOfLPLV3sIvjZyXIsG74r8YIIxdi0Ucfi5KUPDOwl4KNiDvRmUTekC1kDIL4zAdRuhO8WGezpeg6eSWnk6xuutMOLD/5ujRmFNbAua+Ut8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784838454; c=relaxed/simple;
	bh=Flyld6gLfZjzn8NMAZOGW2RFohdZiizg1edL53f1fKI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gSb/hjX9Vwt+ahX5V561YYWMCwYqZPZNba9ou8p2y+SlSFwSdgwC02nHt3yxsnIDkwCDFQNEVTcdx5yHqjejg5iQE7W83939I30HQhaIRwod/zc6qBz5jTd1adL+AKjOQc9LFu6LkiZIJ0SJCqO2BUXm7CZ4Jmk2etkcwi3nKU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CnsrKMek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CnsrKMek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E941F00A3A;
	Thu, 23 Jul 2026 20:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784838447;
	bh=06rryQX1uBIMcf2HSu0SSlQi6HT0poG8gTNY4rwKkNM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CnsrKMekRUBMmXF0eKNui1lGpaoi7DGkmDh8F9Df4jOuaKJk6KJGHGKPoFQz5gO/v
	 MBObmWa9dr59GghiwESa8nimANCTTF0rijIW9OVd5E4+cEZT4gAdd/3sxEWBSOtc7f
	 L/hdwEAVe1SMUkmYLQGZ1J7mQGggHs6sQkyWoXezcN9q7+7e96Ahgdhp6BTiowL7Wa
	 fhOyYGoGoUt0JFONBMuHQB15vwKm7jnXLFYb6m5fP8rbGI9RXRx5ugUc/iHZINTWmb
	 e1q5D6aFgR6artGMLYC9O++uACmklPek4VsJ/cbdWAn51w5iQJDbdx5Z6I8AWUy/DM
	 V4ta5z439mRkw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 56/56] scsi: qla2xxx: Update version to
 12.00.00.2607b1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-57-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-57-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 20:27:27 +0000
Message-Id: <20260723202727.98E941F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The new driver version string has an odd length, causing an infini=
te loop condition and out-of-bounds read in `qla82xx_set_driver_version`.
- [Medium] The new `QLA_DRIVER_BETA_VER` and `QLA2XXX_VERSION` values excee=
d the 8-bit limits assumed by the minidump and firmware dump metadata gener=
ators, leading to corrupted version reporting.
--

--- Patch [56]: [PATCH v6 56/56] scsi: qla2xxx: Update version to 12.00.00.=
2607b1 ---
commit 7e58cb94f7bd9df990cb9116b395dd17502493c0
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Update version to 12.00.00.2607b1

This commit updates the QLA2XXX driver version string and the corresponding
major, minor, patch, and beta version macros.

> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/ql=
a_version.h
> index 9564beafdab71..1c0b01d703509 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -6,9 +6,9 @@
>  /*
>   * Driver version
>   */
> -#define QLA2XXX_VERSION      "10.02.10.100-k"
> +#define QLA2XXX_VERSION      "12.00.00.2607b1"

[Severity: High]
Does changing this version string to an odd length (15 bytes) cause a loop
overrun and out-of-bounds read in qla82xx_set_driver_version()?

Looking at drivers/scsi/qla2xxx/qla_mbx.c:qla82xx_set_driver_version():

	for (i =3D 4; i < 16 && len; i++, str++, len -=3D 2) {
		mcp->mb[i] =3D le16_to_cpup(str);
		mcp->out_mb |=3D 1<<i;
	}

Since len is initialized to the string length, an odd length causes len to =
step
from 1 to -1. The loop condition && len will remain true when it goes negat=
ive,
causing the loop to continue and read past the end of the string literal.

> =20
> -#define QLA_DRIVER_MAJOR_VER	10
> -#define QLA_DRIVER_MINOR_VER	02
> -#define QLA_DRIVER_PATCH_VER	10
> -#define QLA_DRIVER_BETA_VER	100
> +#define QLA_DRIVER_MAJOR_VER	12
> +#define QLA_DRIVER_MINOR_VER	00
> +#define QLA_DRIVER_PATCH_VER	00
> +#define QLA_DRIVER_BETA_VER	2607

[Severity: Medium]
Does this new beta version value exceed 8-bit limits and corrupt the driver
version metadata in diagnostic dumps?

In drivers/scsi/qla2xxx/qla_nx.c:qla82xx_md_collect(), the version componen=
ts
are packed into a 32-bit integer:

	tmplt_hdr->driver_info[1] =3D (QLA_DRIVER_MAJOR_VER << 24) |
	    (QLA_DRIVER_MINOR_VER << 16) | (QLA_DRIVER_PATCH_VER << 8) |
	    QLA_DRIVER_BETA_VER;

Since 2607 (0x0A2F) is larger than 8 bits, the bitwise OR will overflow and
overwrite the patch version byte.

Additionally, in drivers/scsi/qla2xxx/qla_tmpl.c:qla27xx_driver_info(), the
%hhu format specifier is used to parse the string version:

	WARN_ON_ONCE(sscanf(qla2x00_version_str,
			    "%hhu.%hhu.%hhu.%hhu",
			    v + 0, v + 1, v + 2, v + 3) !=3D 4);

This will silently truncate the beta version 2607 to 47.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D56

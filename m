Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6754C412C02
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 18:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784053431; cv=none; b=ulbPsD5EK/O1HrXzkCqkb2jsHWfLAH3LFEkYF8U2pG5Q9Uaw09tI7r/xXjtUGxxyBWj/iXbA0XPInMSnA0X3n+JnworqDpxAmfNn7qgJXFgbJwzrabvWooaUuUu+9HKbOWRjVscQSO300tls6tQ4/Y6FUcp9jwv7wlQhIqgVhAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784053431; c=relaxed/simple;
	bh=eLyZ2k0W6MhDDwF06LFkfkMH8jyMvf6yORmgyFYnwpU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cfTxcVXvMvbatnkPPNcqci0jWQQ5yJr7LWY//6YVmjAkPbquktGPppKgLklEWz0C9NVALtZRFxdBHqJf11m643kGm59s85Rg3csCXUWlyTlZhdGUmWTCapwBaCRu41iXMJp3vGeuCHuZt/xAqcK+E/lyqQ55VkPD30xFF71VOus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8MFsDGX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8MFsDGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A351F000E9;
	Tue, 14 Jul 2026 18:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784053430;
	bh=fKA0QwYxy8K6yIN3oPC2Lh26YtNNzYtKFP45NFBRh6A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j8MFsDGXn1ZSoLkzaa1FQwECVggHFzjDXPRIvOun4mkmrWSrtsI2/qvYVVNPQXPhQ
	 Nx89HRkXau9LdZWp9bUNFqbIcNYGHrruCp5rVdnGF+bicyLAPxx7hLAH6hwwDmGv/X
	 Udugvtjw5DYP0PZQMK2q1GGoAqjLPtgp8XoQOhOPyipLqBf/d6hnXPQrC7s03wkbQa
	 lyHwdBH1GOJDq7k9Ulqq1pya+OE9y/v2LoRzGLOGt6czbd7+R4/lGbto3GBR0Mfqh7
	 3SOlvDQMCrBzrvZuRO4CynHD89Hv777nYfMvf2iqTXiOkvHYFNpXhXpd6pj0NkoISi
	 GSzMMR+L5LUVA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 56/56] scsi: qla2xxx: Update version to
 12.00.00.2607b1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-57-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-57-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 18:23:49 +0000
Message-Id: <20260714182349.C1A351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Medium] The new QLA_DRIVER_BETA_VER (2607) exceeds 8 bits, causing a bit=
wise overlap that corrupts the patch version byte in the firmware telemetry=
/minidump template header.
- [Medium] The sscanf format specifier %hhu truncates the new beta version =
(2607) during string parsing, leading to incorrect version logging.

Pre-existing issues:
- [High] Changing the length of `QLA2XXX_VERSION` to an odd number of bytes=
 triggers an off-by-one parity bug in `qla82xx_set_driver_version()`, resul=
ting in a global out-of-bounds read and info leak.
--

--- Patch [56]: [PATCH v4 56/56] scsi: qla2xxx: Update version to 12.00.00.=
2607b1 ---
commit 5dbc42f224e77d9a08367012fa8509d93dd148ac
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Update version to 12.00.00.2607b1

This commit updates the QLogic FC HBA driver version strings and macros to
12.00.00.2607b1 and increments the major and beta version numbers.

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
This is a pre-existing issue, but changing the version string length to an
odd number of bytes (15 bytes) triggers an out-of-bounds read during driver
initialization.

In drivers/scsi/qla2xxx/qla_mbx.c:qla82xx_set_driver_version(), the
parsing loop decrements the length by 2 on each iteration:

	for (i =3D 4; i < 16 && len; i++, str++, len -=3D 2) {

Because the new string length is odd, the len variable will drop from 1 to =
-1,
bypassing zero. Since -1 evaluates to true in C, will this cause the loop t=
o=20
read past the end of the string literal into adjacent memory until the loop
limit is hit?

> -#define QLA_DRIVER_MAJOR_VER	10
> -#define QLA_DRIVER_MINOR_VER	02
> -#define QLA_DRIVER_PATCH_VER	10
> -#define QLA_DRIVER_BETA_VER	100
> +#define QLA_DRIVER_MAJOR_VER	12
> +#define QLA_DRIVER_MINOR_VER	00
> +#define QLA_DRIVER_PATCH_VER	00
> +#define QLA_DRIVER_BETA_VER	2607

[Severity: Medium]
Will this new beta version (2607) corrupt the telemetry minidump header?

In drivers/scsi/qla2xxx/qla_nx.c:qla82xx_md_prep(), the version macros are
shifted and combined using bitwise OR:

	tmplt_hdr->driver_info[1] =3D (QLA_DRIVER_MAJOR_VER << 24) |
	    (QLA_DRIVER_MINOR_VER << 16) | (QLA_DRIVER_PATCH_VER << 8) |
	    QLA_DRIVER_BETA_VER;

Since 2607 (0xA2F) exceeds 8 bits, it appears it will bleed into the space
designated for the patch version, corrupting the reported driver info.

[Severity: Medium]
Does the firmware template logging also truncate this new beta value?

Looking at drivers/scsi/qla2xxx/qla_tmpl.c:qla27xx_driver_info(), the versi=
on
string is parsed using %hhu:

	WARN_ON_ONCE(sscanf(qla2x00_version_str,
			    "%hhu.%hhu.%hhu.%hhu",
			    v + 0, v + 1, v + 2, v + 3) !=3D 4);

Since %hhu expects an 8-bit unsigned integer, parsing 2607 will silently
truncate the beta version modulo 256 (resulting in 47). Could this cause
diagnostic tools to misreport the version?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D56

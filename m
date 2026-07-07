Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACFE3B95EC
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783409710; cv=none; b=FzCoeZtJkGGfmlkamDhRhX9Eu3gNNsHuUkVeqvp3CmyGWnAUt4Hu+qHYueY36PmQLZiGJNRqYi1FMNcXL/xuoj5XWsr/xMvRgQ4f34ZV+KNjn4A4MlbY47DZZ8b69o74iYyMmkPbFXYJHTseOgT/ICMwQmMwOuTQ0KELl5bPwLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783409710; c=relaxed/simple;
	bh=ahCQcKDywbRbL3Ue7bBUC+qD+iHwn5F60hV1VDIJcns=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bDou8aop0/gezVizAQMnn+9b3IS/icO0Wd7z/0rnSi5faJrcqS+qCE626o4FofvcpyV8cOElY+Ru4OyBNNS+YO+7el4kA1b176xRPzSmKXhtykDB5iOErvz7pNAiJKVmDUiIuP+JVypPub2Mc/i4AXbvp6T0/1wbk/lDcCFoYtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DSQ7dJ5e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DSQ7dJ5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AFD1F00A3A;
	Tue,  7 Jul 2026 07:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409709;
	bh=tmbEksB6eziSSfEAnVW4MsAIZ0J6q+osNzqaJq2n+Wo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DSQ7dJ5eZBT3YCyr5D63At2Tu5txzLLh3EE/R7G5RS+fcySQnhibnXkKjNDS/J8Tx
	 ufHFYSrkq0qKRkbrJ2alLxcTfh/Vvt+WTj2dLe6I4HyE2cUHSKUqHWTyLYi/w6qcGs
	 TP0cNt4jWo1xlvXqfEzbEAAn/iHLeBXBp5tnjfDk0WrOjBIiVJDbeKb5w6soMAIzY3
	 1LNxz4MJyTs8zaqXmWxM12katPlvNzIfffze+WDH4eQWbmurNF/FICuYN3O8AlDlUa
	 fROj3ORwx4ebYWKDHDahJ3nm3hTvj5LLDUsKBQtXJm4eKQL4lzuc5zTdYuLur8fQp6
	 3GPgntSW55Qtg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 88/88] scsi: qla2xxx: Update version to
 12.00.00.2607b1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-89-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-89-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:35:09 +0000
Message-Id: <20260707073509.78AFD1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The odd-length version string causes an infinite loop condition ev=
aluation, resulting in an out-of-bounds memory read into firmware mailbox r=
egisters.
- [Medium] The new QLA_DRIVER_BETA_VER (2607) exceeds 8 bits, causing data =
corruption and truncation in minidump headers.
--

--- Patch [88]: [PATCH v3 88/88] scsi: qla2xxx: Update version to 12.00.00.=
2607b1 ---
commit 7835c1af22d4a49f4cede46a4b0344d098aa7b95
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Update version to 12.00.00.2607b1

This commit updates the driver version, major, minor, patch, and beta
version macros to reflect the new 12.00.00.2607b1 release.

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
Does changing the version string length to an odd number (15 characters)
cause an out-of-bounds read?

In drivers/scsi/qla2xxx/qla_mbx.c:qla82xx_set_driver_version(), the loop
decrements the length by 2 on each iteration:

        for (i =3D 4; i < 16 && len; i++, str++, len -=3D 2) {
                mcp->mb[i] =3D le16_to_cpup(str);
                mcp->out_mb |=3D 1<<i;
        }

Since len starts as an odd number, len -=3D 2 will skip 0 and evaluate to
true for subsequent checks, causing the loop to continue reading past the
end of the string into adjacent memory until i reaches 16.

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
Will this new beta version exceed 8-bit packing constraints and corrupt the
version data?

The value 2607 requires 12 bits, but it is used in contexts expecting an
8-bit value. For example, in drivers/scsi/qla2xxx/qla_nx.c:qla82xx_md_colle=
ct(),
it spills into the patch version byte due to an unmasked bitwise OR:

        tmplt_hdr->driver_info[1] =3D (QLA_DRIVER_MAJOR_VER << 24) |
            (QLA_DRIVER_MINOR_VER << 16) | (QLA_DRIVER_PATCH_VER << 8) |
            QLA_DRIVER_BETA_VER;

Additionally, in drivers/scsi/qla2xxx/qla_tmpl.c:qla27xx_driver_info(), it
is parsed using the %hhu format string which silently truncates 2607 to 47:

        WARN_ON_ONCE(sscanf(qla2x00_version_str,
                            "%hhu.%hhu.%hhu.%hhu",
                            v + 0, v + 1, v + 2, v + 3) !=3D 4);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D88

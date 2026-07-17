Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381D333E348
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784307248; cv=none; b=PZ5+BIRIyUEx2YchrwH3Xk/PdftvlGD6U/eAvm4jmDATwQyYzKyYeNnxsGrGf0nDxKP2Fd0/YIKS/rsZobWDBJnL8eNLCdiXqLMaRezMWBboKcHhqbdpXBjPGlhMQCCdUaXanplprpbXCfAyA0yOfUYkUqHACVJu/IQY+PCHWJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784307248; c=relaxed/simple;
	bh=g3ARe/uFLFhRPozjbSKTg4/+vB5znkWLn0KLWYWiYh8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eHmMu5gJ5jKGhQsPfzKo8mgxGgBhaY6s8JXB+nElCFrKGcK/2QsS7dNl3gKIA0RitDwyEq+iMOzKkj9p7mSlTp3Vz8M25HS067BWgedTJSpBXwvvQyNpb2Ud1XPC9EgpV81ZshX0HQOQjjGGaJfMgKdPd5Io5AVGgCdh3Kl+a7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NRxodVKz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NRxodVKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE6D1F000E9;
	Fri, 17 Jul 2026 16:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784307246;
	bh=sxlfmIupxReeCJdyvPhYc4NEnemgqmp289LqX0+FVSY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NRxodVKzpRkJWaUY+l/wS3vnb0hqL6sDhFupC6sktzZVKp+yxJazv/JCQMH3+oBfi
	 qa9Mb1YmuNnuuwq/DdMq6R+uvS/D1bFLJm22EBQ6OsUyuoVJXeqYC4K7WmTo6/vFn3
	 iIKbQcXYwVURtlsoFVdHcqJM0+5UTcdnR/xFqDVd9dzvN4yCU41Neys35zn/lpqtAn
	 hvq0WsxE1evUPFD+HQDSeAx7PLbdIZvDrmrhDwx8ldr5u/R/ydg077ZTcJdXnnQngc
	 pzVnq+7Dkn5BtfyeF10xM4hN/iUocz/RpClwJMQZdYwpy7ugp59JqcDpNvrG+WJcHC
	 mekMrjFeCSGzA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 56/56] scsi: qla2xxx: Update version to
 12.00.00.2607b1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-57-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-57-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:54:05 +0000
Message-Id: <20260717165406.AAE6D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The new odd-length driver version string triggers an out-of-bounds=
 read vulnerability in qla82xx_set_driver_version().
--

--- Patch [56]: [PATCH v5 56/56] scsi: qla2xxx: Update version to 12.00.00.=
2607b1 ---
commit 06852b0036d05a19a62576cee2a7f97ae01c17ca
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Update version to 12.00.00.2607b1

This commit updates the QLA2XXX driver version from 10.02.10.100-k to
12.00.00.2607b1 and adjusts the corresponding major, minor, patch, and
beta version macros.

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
This isn't a bug introduced by this patch, but could changing the version
string to an odd length trigger an out-of-bounds read regression in
qla82xx_set_driver_version()?

Looking at drivers/scsi/qla2xxx/qla_mbx.c:qla82xx_set_driver_version():

	for (i =3D 4; i < 16 && len; i++, str++, len -=3D 2) {
		mcp->mb[i] =3D le16_to_cpup(str);
		mcp->out_mb |=3D 1<<i;
	}

Because `len` is a signed integer and is decremented by 2, an odd-length st=
ring
will bypass the zero check and become negative. The `&& len` condition will
remain true, causing the loop to read past the end of the version string
literal.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D56

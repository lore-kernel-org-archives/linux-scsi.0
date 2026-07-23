Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9AA363096
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 17:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784827753; cv=none; b=IfWEvvmvkf04IjN+NMYn6bPRTwCHE0o5WrEyrsM+6ub/hwNke8V43EQ8RjDwjlgWSfE6i+r6J2WFb+rgbIrtRL5Qaf6KII4ywIG7X4WQcRFt/hIjGABrKm2JAMKkZd1+WzSNfMc13BO/2nAiIlwlySSZDQrR5ffysoTozBNzG8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784827753; c=relaxed/simple;
	bh=e/jmroGDKiu2xLWj9i4MAM+sjIrEUOkFxRbb09vxQq8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Mf9r9TzyfysK7pvwcFySv+kSQIesLsqpTSfIMa82eMQgXvgkifM2f6VroZaJkMSzuCLgJSv28OH3+QtLuISsK5xyPWEof0nGun1ezoAnEDNWMbse1Y+bhG0zLsKo3oEMi7UwPKlm5kkrIjgigyeypeABHvrASo5tXXJTWQFFjR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jp4yKKem; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jp4yKKem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405DC1F000E9;
	Thu, 23 Jul 2026 17:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784827751;
	bh=SZmn0bmRVnxqz0HPXv3l+NX/swnX7fMvBcvN3rP/JF4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jp4yKKemqiiNoUXqZaMUjnVkDfcGvP5PLZWzLkgRv40jh+H7dLUDNYPEjRw7TMj7E
	 CZDBfoQti2pS+c8UnNijoQF8GJ1pzY+u3kmgFpSBIhN1H3o7nzpZHQ0yRSFFUDIOmM
	 BMk4jUYU5QSO1H5G52aNbTAqcq7qsU50VdrkhVylNLbBag8oM3V4lAMXrUSjjwIy7O
	 1jyNTfiew/w76rwbK4Y8j5mqjwfhpGFRvpONUSlvanunuvep+95A/ufP/YxKt3qgCu
	 dUX/9tKmPyVGASWnTu4JfHHrTYw0hiv9aV6k/OOMn6LhKfG+/uIhTJGrNjvDTGzRT8
	 2nF5o0XixT4TQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 41/56] scsi: qla2xxx: Replace __le16 bitfields with
 scalar and accessors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-42-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-42-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 17:29:10 +0000
Message-Id: <20260723172911.405DC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Incomplete fix for endianness bug in 29xx extended IOCBs

Pre-existing issues:
- [High] Target mode ABTS failures on big-endian due to bitfield packing
--

--- Patch [41]: [PATCH v6 41/56] scsi: qla2xxx: Replace __le16 bitfields wi=
th scalar and accessors ---
commit aa60e92d6d4c10c7735dd3bda849923fc8a00254
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Replace __le16 bitfields with scalar and accessors

C bitfield packing order is implementation-defined: GCC packs LSB-first
on little-endian targets and MSB-first on big-endian targets.  The
__le16 bitfield declarations for vp_index/sof_type in the 29xx extended
IOCB structures produce incorrect bit positions on big-endian hosts,
and Sparse cannot enforce endianness checks on bitfield members.

> Replace the three sets of __le16 bitfields (in els_entry_24xx_ext,
> els_sts_entry_24xx_ext, and abts_entry_24xx_ext) with a single __le16
> scalar field and provide inline accessor functions that use proper
> le16_to_cpu()/cpu_to_le16() with shift-and-mask operations.

[Severity: High]
Does this fix also need to be applied to vp_rpt_id_entry_24xx_ext in
drivers/scsi/qla2xxx/qla_fw29.h?

It appears vp_rpt_id_entry_24xx_ext still uses __le16 bitfields for
vp_idx and vp_status:

	__le16	vp_idx : 9;		/* VP Index 9bits */
	__le16	vp_status : 7;		/* VP Status 7bits */

When these fields are extracted in qla24xx_report_id_acquisition(), they wi=
ll
be read incorrectly on big-endian architectures, causing VP ID reporting and
initialization to fail for 29xx series adapters.

Could this have been missed from the earlier patch "scsi: qla2xxx: Add size
check for extended VP report ID entry" in this series?

> Fixes: 4e0e5b8c80e8 ("scsi: qla2xxx: Add 128-byte IOCB definitions for 29=
xx")
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Reviewed-by: Hannes Reinecke <hare@kernel.org>

> diff --git a/drivers/scsi/qla2xxx/qla_fw29.h b/drivers/scsi/qla2xxx/qla_f=
w29.h
> index 600a40d8bd5ff..63bf350ddffc0 100644
> --- a/drivers/scsi/qla2xxx/qla_fw29.h
> +++ b/drivers/scsi/qla2xxx/qla_fw29.h

[ ... ]

> @@ -563,9 +586,7 @@ struct abts_entry_24xx_ext {
>  	__le16	nport_handle;		/* type 0x54 only */
> =20
>  	__le16	control_flags;		/* type 0x55 only */
> -	__le16	vp_idx : 9;		/* VP index 9 bits */
> -	__le16	reserved_1_sof : 3;
> -	__le16	sof_type : 4;		/* sof_type is upper nibble */
> +	__le16	vp_idx_sof;		/* bits [8:0]=3DVP index, [15:12]=3DSOF type */

[Severity: High]
This isn't a bug introduced by this patch, but does the abts_recv_from_24xx
structure in drivers/scsi/qla2xxx/qla_target.h suffer from a similar
bitfield packing issue?

Looking at abts_recv_from_24xx:

	uint8_t  reserved_3:4;
	uint8_t  sof_type:4;

GCC packs the first bitfield in the most-significant bits on big-endian
systems, moving sof_type to the least-significant bits. Since the hardware
expects sof_type in the upper nibble, could this lead to malformed ABTS
responses and target-mode functional failures?

This appears to be a pre-existing issue dating back to commit 2d70c103fd2a0=
6.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D41

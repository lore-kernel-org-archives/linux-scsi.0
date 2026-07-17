Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45F536EA84
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784303357; cv=none; b=u0La/bvxXdr+RFVeM4BHwCc6XBYF39sezfmrDChJwcIjfZZgAUjG4Q1vaX2LrHaHKG80t7WN2qEke5OMitjSr0CQTlqd0W4t4A4vr+d/wAN2X9twHXqi2JWznErYRunar3pW0rk7vPHjZEAha5b5YG8KcSoh62OWR/zCyBtoD3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784303357; c=relaxed/simple;
	bh=C52/cfUOD7zJuKcZf6vOhANvEWIMaI2Fzy84pOZMfPg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cH8sGjCxhBmvpGZtSTDz//9qozkWjLdF4Vvpl4+YaAtfgXVPQlkDT+73ASn5DC49QwgIJpUMbHRWqsmzoKBbMHvPAaw0De4zuHPX660nSZQ6aik0r2tIoS3DoIkEoPFgPgj5UyMCFwUxsAeGNgIjceeH40Py4wuVTSchyr2EJWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BuXHqVZa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BuXHqVZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7A31F000E9;
	Fri, 17 Jul 2026 15:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784303355;
	bh=GvnnUy9ipKK8zTab75IUs/pXve4KsbaMADgiSqwCnOo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BuXHqVZact/1Rut9I1OMQOKi6zTEjdvThcHBQMHy6oVOSAQfeELzLgx2rmu8MR6Ja
	 KF2y2WYbVQ9NL+Wj1f9Dykjg0VIAQnzhDNnRczoPSB4jdBKbwzw0XRDndteK8qEXVN
	 VlIJzb8Jx4+8WSN5HTfn3YXLdKFIfaqecoZLDbDQjZLihRbLMutg1b/VF9LssEx5O4
	 o4nBIHM5CvBo0BEM6u3cV009aEIuSnrYKGRfI7+9ZlmWNJaP4CoVeMyMjeEScmCMru
	 VUmkItYKbWWtyOvQuia0HmSIts/gc8hXJY+kcfn5hFY5Tqeb2DCoAm40Cd1K6j3r52
	 o+G4KFzpqMINw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 09/56] scsi: qla2xxx: Add 128-byte IOCB definitions
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-10-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-10-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 15:49:14 +0000
Message-Id: <20260717154915.5A7A31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Hardware-mapped structures use C bitfields on `__le16` bitwise typ=
es, leading to memory layout bugs on big-endian architectures and violating=
 Sparse checks.
--

--- Patch [9]: [PATCH v5 09/56] scsi: qla2xxx: Add 128-byte IOCB definition=
s for 29xx ---
commit 16ec74f0c14d7afa47bfe50e3dd3cef172201ab7
Author: Anil Gurumurthy <agurumurthy@marvell.com>

scsi: qla2xxx: Add 128-byte IOCB definitions for 29xx

The 29xx series uses 128-byte IOCBs instead of the 64-byte IOCBs
used by earlier adapters.  Add a new header (qla_fw29.h) with the
extended IOCB structure definitions that match the 29xx firmware
interface.

> diff --git a/drivers/scsi/qla2xxx/qla_fw29.h b/drivers/scsi/qla2xxx/qla_f=
w29.h
> new file mode 100644
> index 0000000000000..efe1c60bee81d
> --- /dev/null
> +++ b/drivers/scsi/qla2xxx/qla_fw29.h
> @@ -0,0 +1,686 @@
[ ... ]
> +struct els_entry_24xx_ext {
[ ... ]
> +	__le16	tx_dsd_count;
> +
> +	__le16	vp_index : 9;		/* VP Index 9bits */
> +	__le16	reserved_1_sof : 3;
> +	__le16	sof_type : 4;
> +
> +	__le32	rx_xchg_address;	/* Receive exchange address. */

[Severity: High]
Does this bitfield usage on a restricted bitwise type (__le16) break memory
layout on big-endian hosts?

The C standard leaves bitfield memory layout up to the compiler. On big-end=
ian
architectures, bitfields are typically allocated from MSB to LSB rather than
LSB to MSB.=20

Could the firmware read or write corrupted VP indices and SOF types on
big-endian hosts because the bytes won't map to the hardware's expected
layout?

Sparse also explicitly rejects bitfields on restricted bitwise types,
producing "degrading to integer" errors.

Could this use a plain __le16 field and apply bitmasks manually via
le16_to_cpu() and bitwise operations instead, similar to how it is handled
in struct cmd_type_6_ext?

[ ... ]
> +struct els_sts_entry_24xx_ext {
[ ... ]
> +	__le16	reserved_1;
> +
> +	__le16	vp_index : 9;		/* VP Index 9bits */
> +	__le16	reserved_1_sof : 3;
> +	__le16	sof_type : 4;
> +
> +	__le32	rx_xchg_address;	/* Receive exchange address. */

[Severity: High]
Will this bitfield layout also cause endianness mapping issues with the
hardware on big-endian architectures?

[ ... ]
> +struct abts_entry_24xx_ext {
[ ... ]
> +	__le16	control_flags;		/* type 0x55 only */
> +	__le16	vp_idx : 9;		/* VP index 9 bits */
> +	__le16	reserved_1_sof : 3;
> +	__le16	sof_type : 4;		/* sof_type is upper nibble */
> +
> +	__le32	rx_xch_addr;

[Severity: High]
Could this bitfield definition on __le16 similarly break hardware mapping
on big-endian hosts?

[ ... ]
> +struct vp_rpt_id_entry_24xx_ext {
[ ... ]
> +	uint8_t vp_acquired;
> +	uint8_t vp_setup;
> +	__le16	vp_idx : 9;		/* VP Index 9bits */
> +	__le16	vp_status : 7;		/* VP Status 7bits */
> +
> +	uint8_t port_id[3];

[Severity: High]
Is this C bitfield definition on __le16 also resulting in incorrect memory
layout when accessed on big-endian architectures?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D9

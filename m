Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FF43769EF
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 11:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784027381; cv=none; b=DE8CPzA8EJ6VeedOBGIWXEHxOoyM+7z6YP/izDOZYi83q13wV7WBMPVzIu7MmCMhKrjRG4LlaXQ5Or4eYjSPrBBVTUi31loS/hJxHPfZBtUDr1Zk/cNXzdZKowdS4RBVA/1YhxaylmOWcczbI/I1SChlf9XZUDKJuiUxXZWVtDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784027381; c=relaxed/simple;
	bh=Bo4gz9LNL8PisRvTTIdFwD+lepfFK76RVySDFqzH9IA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iUOIoVcIA/P91qj0y71SYijeArGTtX73g3CW5YF2ogYQV6ve2E/DDvXlRE6R71PUEXxF2WpIWp8vvDXwcBq5ehI4C2Z28KmxA83JqqyDX0hSFNLDsR/WR8Br/mIBpCoACnsPySqudS38b8wCuKb1ju0b7a4DrF0Fwe0hnewwmJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J8f9dFgk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J8f9dFgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5921F000E9;
	Tue, 14 Jul 2026 11:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784027379;
	bh=99PL9PtlA8C5f2LepjZF6S6jUrO+nxmN7qzhLV4NU5g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J8f9dFgkuUH7tvO/y2anv0eVHDJyjiFNpeR93i3wKYlfFiqJ8ZVKo/1LjMpqkSLHP
	 mVnonidSL7XaVAGp48CKqMU+MMczc/3ULQ7efSFGJy/iRMkDQ608slYYRWXrPiaFA5
	 gMvGP5E4LBM2/gwGkcUF59bCxBCttfANdCRCJ44rFiPJxOAnQvJ6QFcO3Vw2YCa+nq
	 TM32dCSmV2zs9t9t4rg2+znpZwsnpxEXTx2rp+7dkX4UikyhgbdCGfyR6CG9RCAsHV
	 mVuBEgN0XEG8HFRu30eWBZ5v+IKKYHwiftWyUXCIMX64mKKenSRnT6yeCdIqi9AZQk
	 ZRbor5tNGP6Ig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 09/56] scsi: qla2xxx: Add 128-byte IOCB definitions
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-10-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-10-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 11:09:38 +0000
Message-Id: <20260714110939.6E5921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Usage of C bitfields with restricted `__le16` types in hardware-fa=
cing structures breaks memory layout on big-endian architectures and violat=
es Sparse rules.
- [High] The struct `vp_rpt_id_entry_24xx_ext` is missing padding to reach =
the 128-byte IOCB size, evaluating to only 64 bytes.
--

--- Patch [9]: [PATCH v4 09/56] scsi: qla2xxx: Add 128-byte IOCB definition=
s for 29xx ---
commit 109fd3a5dadf86d8a0a91f525e8bcde2ce34fc5b
Author: Anil Gurumurthy <agurumurthy@marvell.com>
scsi: qla2xxx: Add 128-byte IOCB definitions for 29xx

The patch adds a new header qla_fw29.h with 128-byte IOCB structure
definitions to support the 29xx series firmware interface.

> --- /dev/null
> +++ b/drivers/scsi/qla2xxx/qla_fw29.h

[ ... ]

> +struct els_entry_24xx_ext {
> +	uint8_t entry_type;		/* Entry type. */
> +	uint8_t entry_count;		/* Entry count. */
> +	uint8_t sys_define;		/* System Defined. */
> +	uint8_t entry_status;		/* Entry Status. */
> +
> +	uint32_t handle;		/* System handle. */
> +
> +	__le16	comp_status;		/* response only */
> +	__le16	nport_handle;
> +
> +	__le16	tx_dsd_count;
> +
> +	__le16	vp_index : 9;		/* VP Index 9bits */
> +	__le16	reserved_1_sof : 3;
> +	__le16	sof_type : 4;

[Severity: High]
Does this C bitfield definition on a restricted __le16 type break memory
layout on big-endian architectures and violate Sparse rules?

Since bitfields are packed differently depending on host endianness, wouldn=
't
applying them directly to a little-endian type cause the hardware to receive
garbled values for ELS and ABTS operations on big-endian systems like Power=
PC
or s390x?

[ ... ]

> +struct els_sts_entry_24xx_ext {
> +	uint8_t entry_type;		/* Entry type. */
> +	uint8_t entry_count;		/* Entry count. */
> +	uint8_t sys_define;		/* System Defined. */
> +	uint8_t entry_status;		/* Entry Status. */
> +
> +	__le32	handle;		/* System handle. */
> +
> +	__le16	comp_status;
> +
> +	__le16	nport_handle;		/* N_PORT handle. */
> +
> +	__le16	reserved_1;
> +
> +	__le16	vp_index : 9;		/* VP Index 9bits */
> +	__le16	reserved_1_sof : 3;
> +	__le16	sof_type : 4;

[Severity: High]
Could this bitfield on an __le16 type also result in endianness issues?

[ ... ]

> +struct abts_entry_24xx_ext {
> +	uint8_t entry_type;
> +	uint8_t entry_count;
> +	uint8_t handle_count;
> +	uint8_t entry_status;
> +
> +	__le32	handle;		/* type 0x55 only */
> +
> +	__le16	comp_status;		/* type 0x55 only */
> +	__le16	nport_handle;		/* type 0x54 only */
> +
> +	__le16	control_flags;		/* type 0x55 only */
> +	__le16	vp_idx : 9;		/* VP index 9 bits */
> +	__le16	reserved_1_sof : 3;
> +	__le16	sof_type : 4;		/* sof_type is upper nibble */

[Severity: High]
Can this also cause similar memory layout issues on big-endian systems as s=
een
above?

[ ... ]

> +struct vp_rpt_id_entry_24xx_ext {
> +	uint8_t entry_type;		/* Entry type. */
> +	uint8_t entry_count;		/* Entry count. */
> +	uint8_t sys_define;		/* System defined. */
> +	uint8_t entry_status;		/* Entry Status. */
> +	__le32 resv1;
> +	uint8_t vp_acquired;
> +	uint8_t vp_setup;
> +	__le16	vp_idx : 9;		/* VP Index 9bits */
> +	__le16	vp_status : 7;		/* VP Status 7bits */

[Severity: High]
Does this __le16 bitfield also suffer from endianness packing issues?

> +
> +	uint8_t port_id[3];
> +	uint8_t format;
> +	union {
> +		struct vp_rpt_id_ext_f1 {
> +			/* format 1 fabric */
> +			uint8_t vpstat1_subcode; /* vp_status=3D1 subcode */
> +			uint8_t flags;
> +
> +			uint16_t fip_flags;
> +			uint8_t rsv2[12];
> +
> +			uint8_t ls_rjt_vendor;
> +			uint8_t ls_rjt_explanation;
> +			uint8_t ls_rjt_reason;
> +			uint8_t rsv3;
> +			__le16	rsv8;
> +			__le16	flogi_acc_payload_size;	/* bits [8:0] meaningful */
> +			uint8_t port_name[8];
> +			uint8_t node_name[8];
> +			uint16_t bbcr;
> +			uint8_t reserved_5[6];
> +		} f1;
> +		struct vp_rpt_id_ext_f2 { /* format 2: N2N direct connect */
> +			uint8_t vpstat1_subcode;
> +			uint8_t flags;
> +			uint16_t fip_flags;
> +			uint8_t rsv2[12];
> +
> +			uint8_t ls_rjt_vendor;
> +			uint8_t ls_rjt_explanation;
> +			uint8_t ls_rjt_reason;
> +			uint8_t rsv3[5];
> +
> +			uint8_t port_name[8];
> +			uint8_t node_name[8];
> +			uint16_t bbcr;
> +			uint8_t reserved_5[2];
> +			uint8_t remote_nport_id[4];
> +		} f2;
> +	} u;
> +};
> +#endif

[Severity: High]
Is struct vp_rpt_id_entry_24xx_ext missing padding at the end to reach the
128-byte IOCB size?

The commit message mentions adding 128-byte IOCB definitions, and other str=
ucts
in this file appear padded to 128 bytes, but this struct evaluates to exact=
ly
64 bytes (16 bytes header + 48 bytes union).

If the driver logic uses sizeof(struct vp_rpt_id_entry_24xx_ext) for queue
processing or memcopying entries, could this result in misaligned hardware
command rings or queue corruption?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D9

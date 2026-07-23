Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8423E6397
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 07:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784792140; cv=none; b=G6vMGAozQk+sEi0AGfHMt1kRf5XuyCBTn5S4Dg79VGfYwUI7LzTkHRJ5j8jHvsnmPy5JZ7kxl2tUJzct4KuCpYij0Hsg4DAXn51o4KgAuR/sZHHtZ6lrDInU58MbuoqkmECymj3rTGv7e2PKqVpJrF/dPwel2xMYYzFDwHxSbdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784792140; c=relaxed/simple;
	bh=sQ16ZlYZCStm5kA+fwMutXdevkUo3M46j583YpONpaM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LQOvqNVQQ16876+S8CJ14JtGwQPfmw752qDcqyLRtVus0fzoat6yubkVV+mGUvBQnonqZRcda6sojCbwelHqcp6Ky8+VrmzTjrkj2ILR7UIarh5pmtlNa7QnNj+ai02YZbQzufJfyMU6Trc5svi0yocSQZXF35AMlbHmoiZ2QeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ag4i0EiT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ag4i0EiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4287E1F000E9;
	Thu, 23 Jul 2026 07:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784792138;
	bh=F3kpZWXpfL+v8rQen5e/l2vTCvmI5YlhXy5xgXAlg6c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ag4i0EiTCmCAtVn1DbBFqcG/Wo90K8MEPqFhbVCnHf1qF6a2eVYGkH+Gp9oEJbfAz
	 1ltktGXM2D07NdMlb0936Ua5aYBnXIr28Xhv1zj9fzqFjlfA9KqTXzE+2hy6iAZEB0
	 xh7BhYKQWjr1VmQPMqUjKY9g4+ejNssQu+NM15L+JdUf67dLTXoDkiZKfIf+WJSFQn
	 e/Sefvk9Cenl6cXI1tGSNuFDUxiCJuGgMXwF15XzyL9bUw6BNuzQwm1c9HKPCSfg+K
	 dIEn6VcQFLiry/3MUDhM/mFvB0zm9QHbW+MUK9jBZvRlq0h4vWwhky/1lADKRK5knp
	 uF/j82fwN6HJQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 09/56] scsi: qla2xxx: Add 128-byte IOCB definitions
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-10-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-10-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 07:35:37 +0000
Message-Id: <20260723073538.4287E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Endianness portability violation using bitfields on __le16 DMA str=
uctures.
- [Medium] Missing padding array leaves `struct vp_rpt_id_entry_24xx_ext` a=
t 64 bytes instead of the required 128 bytes.
- [Medium] Possible truncation of 9-bit VP indices in `vp_config_entry_24xx=
_ext` and `vp_ctrl_entry_24xx_ext`.
- [Low] Stale comment in `struct sts_entry_24xx_ext` provides incorrect arr=
ay offsets for DIF error handling.
--

--- Patch [9]: [PATCH v6 09/56] scsi: qla2xxx: Add 128-byte IOCB definition=
s for 29xx ---
commit f045d9bbc4916b8badfe0c3d725fe53a57f4cac2
Author: Anil Gurumurthy <agurumurthy@marvell.com>

scsi: qla2xxx: Add 128-byte IOCB definitions for 29xx

This commit introduces a new header file containing extended 128-byte IOCB
structure definitions for the QLogic 29xx series adapters. It maps the new
firmware interface to C structures for hardware DMA interactions.

> diff --git a/drivers/scsi/qla2xxx/qla_fw29.h b/drivers/scsi/qla2xxx/qla_f=
w29.h
> new file mode 100644
> index 0000000000000..efe1c60bee81d
> --- /dev/null
> +++ b/drivers/scsi/qla2xxx/qla_fw29.h
> @@ -0,0 +1,686 @@

[ ... ]

> +struct sts_entry_24xx_ext {
> +	uint8_t entry_type;		/* Entry type. */
> +	uint8_t entry_count;		/* Entry count. */

[ ... ]

> +	uint8_t	reserved_2[8];
> +	uint8_t act_dif[8];
> +	uint8_t exp_dif[8];
> +	union {

[ ... ]

> +	/*
> +	 * If DIF Error is set in comp_status, these additional fields are
> +	 * defined:
> +	 *
> +	 * !!! NOTE: Firmware sends expected/actual DIF data in big endian
> +	 * format; but all of the "data" field gets swab32-d in the beginning
> +	 * of qla2900_status_entry().
> +	 *
> +	 * &data[10] : uint8_t report_runt_bg[2];	- computed guard
> +	 * &data[12] : uint8_t actual_dif[8];		- DIF Data received
> +	 * &data[20] : uint8_t expected_dif[8];		- DIF Data computed
> +	 */
> +};

[Severity: Low]
Is this comment still accurate for the new 128-byte structure?

It appears this was copied from the legacy 64-byte struct. In this new layo=
ut,
the data array starts at offset 68, but the DIF error fields are explicitly
defined as act_dif[8] and exp_dif[8] at offsets 32 and 40.

Could this documentation mislead developers trying to access DIF error data?

[ ... ]

> +struct els_entry_24xx_ext {
> +	uint8_t entry_type;		/* Entry type. */

[ ... ]

> +	__le16	tx_dsd_count;
> +
> +	__le16	vp_index : 9;		/* VP Index 9bits */
> +	__le16	reserved_1_sof : 3;
> +	__le16	sof_type : 4;
> +
> +	__le32	rx_xchg_address;	/* Receive exchange address. */

[Severity: High]
Can this cause endianness issues on big-endian architectures?

Since these structures map directly to hardware DMA buffers, compiler-depen=
dent
C bitfield packing on __le16 variables could scramble the vp_index and sof_=
type
bits on big-endian hosts.

Would it be safer to use a plain __le16 field and define bitmask macros like
CMD_EXT_VP_INDEX_MASK, similar to what was done for cmd_type_crc_2_ext?

[ ... ]

> +struct els_sts_entry_24xx_ext {
> +	uint8_t entry_type;		/* Entry type. */

[ ... ]

> +	__le16	reserved_1;
> +
> +	__le16	vp_index : 9;		/* VP Index 9bits */
> +	__le16	reserved_1_sof : 3;
> +	__le16	sof_type : 4;
> +
> +	__le32	rx_xchg_address;	/* Receive exchange address. */

[Severity: High]
Are these __le16 bitfields also susceptible to endianness packing issues ac=
ross
different architectures?

[ ... ]

> +struct abts_entry_24xx_ext {
> +	uint8_t entry_type;
> +	uint8_t entry_count;

[ ... ]

> +	__le16	control_flags;		/* type 0x55 only */
> +	__le16	vp_idx : 9;		/* VP index 9 bits */
> +	__le16	reserved_1_sof : 3;
> +	__le16	sof_type : 4;		/* sof_type is upper nibble */
> +
> +	__le32	rx_xch_addr;

[Severity: High]
Do these bitfields have the same endianness concerns as the others?

[ ... ]

> +struct vp_ctrl_entry_24xx_ext {
> +	uint8_t entry_type;		/* Entry type. */

[ ... ]

> +	__le16	command;
> +
> +	__le16	vp_count;
> +
> +	uint8_t vp_idx_map[16];
> +	__le16	flags;
> +	__le16	id;

[Severity: Medium]
Are these 8-bit map entries sufficient for a 9-bit virtual port index?

The rest of the 29xx extended structures expand the virtual port index to
9 bits to support up to 512 virtual ports. Will mapping these indices to
uint8_t fields silently truncate values above 255?

[ ... ]

> +struct vp_config_entry_24xx_ext {
> +	uint8_t entry_type;		/* Entry type. */

[ ... ]

> +	uint8_t command;
> +
> +	uint8_t vp_count;
> +
> +	uint8_t vp_index1;
> +	uint8_t vp_index2;
> +
> +	uint8_t options_idx1;

[Severity: Medium]
Could this truncate the 9-bit virtual port indices?

If the 29xx hardware supports indices up to 511, storing them in these
uint8_t variables will drop the upper bit.

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
Do these bitfields have the same endianness concerns as the ones in
els_entry_24xx_ext?

[ ... ]

> +			uint8_t port_name[8];
> +			uint8_t node_name[8];
> +			uint16_t bbcr;
> +			uint8_t reserved_5[2];
> +			uint8_t remote_nport_id[4];
> +		} f2;
> +	} u;
> +};
> +#endif

[Severity: Medium]
Does this structure meet the 128-byte size requirement?

Unlike the other extended structures which include a reserved padding array
at the end to ensure the struct size is exactly 128 bytes, this one appears
to omit the padding and end at 64 bytes.

If any queue logic relies on the size of this struct, could it miscalculate
strides or corrupt memory queues?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D9

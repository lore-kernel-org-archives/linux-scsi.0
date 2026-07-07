Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59482F60CC
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783404888; cv=none; b=CvedHAF+jEy8QoBLJGej9hc8MmDjCFIrZVSZKxWUeMSg7qdZxOYWfELWxz3l8TAYABF/wlP0dsqvns5M122nAZJfnic11hThPN0v5BruFRlbElrrHhazxf4pxb51e+TDM4wThJ5z5mZ75zx+pb7mdVNGOmjhAdtJO3LiOxdWQ5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783404888; c=relaxed/simple;
	bh=np8H6S+Emj9i6L2hOLqQgFIMiHVC+yuat/mqRXvkXcE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MavBTR7sIAeB1cfSuPuqV83/ShMc/fHGYdoZSO74SZheU0Srznzn7EkVdHiOWb4zu0ayR+fZ9k0Z5E0G1PGd5aNOjrUaFQ2I/47cyr+eAdU6OIo/zBgMtbL2NW/gr++AUwfvY2DjM+OP4vI64A6cJZrmBM3U7Cley8qdYXNM9bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TfbS2C+v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TfbS2C+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B22E1F000E9;
	Tue,  7 Jul 2026 06:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783404886;
	bh=tpRweuObxC2Gb7SeoqStX10Sg2EiZuCL6EOR+EpKpmI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TfbS2C+vsBPwok5jzQ56qaUZlfe1Og04po1IR67VrJMr45XmliwIj4IWX6o294NdP
	 X6m0C+wkyDzJGrnaIw298rNUPzoyb8oaqWnqfPpclePMdQ78xrfJpQ6wSrvPBdAyUG
	 xCUWlJjs+Rs3V9WJRlVpK1gMdEZHvo/HZrtJOXMtriexgVecMiZKfQOaCM+HMJLNv8
	 JWeAghB4RH21+tR7pb2F1+KhpckaRi9sm1v9wyDw7sp0rTJqdnHzmrVq9WsXFqaCGl
	 c28GWN15EsPPKWRJ07B+PkVQ/o3wMGqEKLEkEl8v0Pi9IyEvyXml5XFxtzD6rmLQPA
	 m5zqSGMcTbxpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/88] scsi: qla2xxx: Add 128-byte IOCB definitions
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-10-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-10-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:14:46 +0000
Message-Id: <20260707061446.7B22E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Hardware IOCB structures incorrectly use C bitfields within `__le1=
6` restricted types, which will cause ABI corruption on big-endian architec=
tures.
- [High] The `vp_rpt_id_entry_24xx_ext` structure is missing trailing paddi=
ng, making it exactly 64 bytes instead of the required 128 bytes for 29xx e=
xtended IOCBs.
--

--- Patch [9]: [PATCH v3 09/88] scsi: qla2xxx: Add 128-byte IOCB definition=
s for 29xx ---
commit 17c73130a2f51368d3463b2a88fa780313b4e3a3
Author: Anil Gurumurthy <agurumurthy@marvell.com>

scsi: qla2xxx: Add 128-byte queue definitions for 29xx

This commit adds a new header file containing 128-byte extended queue
structure definitions for the 29xx series adapters.

diff --git a/drivers/scsi/qla2xxx/qla_fw29.h b/drivers/scsi/qla2xxx/qla_fw2=
9.h
new file mode 100644
index 0000000000000..efe1c60bee81d
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_fw29.h
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
Does defining bitfields inside a restricted __le16 type cause layout
issues on big-endian architectures?=20

The fields vp_index, reserved_1_sof, and sof_type will have their bits laid
out in reverse order on big-endian platforms compared to little-endian ones,
which may result in corruption of the firmware interface.

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
Could this also experience the same big-endian layout regressions as
els_entry_24xx_ext?

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
Is it possible the use of bitfields within __le16 here will lead to the same
endianness regressions?

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
Does this struct also share the big-endian layout issue due to bitfields
in __le16?

> +
> +	uint8_t port_id[3];
> +	uint8_t format;
> +	union {
> +		struct vp_rpt_id_ext_f1 {
[ ... ]
> +		} f1;
> +		struct vp_rpt_id_ext_f2 { /* format 2: N2N direct connect */
[ ... ]
> +		} f2;
> +	} u;
> +};

[Severity: High]
Is this structure missing the trailing padding needed to reach 128 bytes?

While the other extended structures intended for the 128-byte queue include
padding, this struct definition appears to sum to exactly 64 bytes
(16 bytes header plus 48 bytes union).=20

Could this lead to incorrect pointer arithmetic or leave half of the
128-byte slot uninitialized?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D9

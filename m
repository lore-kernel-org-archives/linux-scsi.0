Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B684373BE9
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784306991; cv=none; b=jtcwldAkE7Wy0f+NRaG+WV8xlX1GE6KKQCAVH+02ogBejWS0KmkhncIY3D9+aUiKIzjLnbdsC8mt1y/HB5nKRRdi5lMfioeEUdIZU/Vjk1en51rfClcCu0AzPojSRUlpm4xAbGVtHANNtU2e71QZby5xF3z6bdRLr3Myqzpap6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784306991; c=relaxed/simple;
	bh=I1mwCTYbpq5ChKWKu9xVxv1t7bSRH8vXkAW/mboTCjM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gHRDPWhI714A3CLV3uPN+4yF/pdHAthI8JRZyT1qhrDV6YhOgfPdd+BBE4w/fKu1suyuXl3dAAKk4368zdld17BwfIxUyp9wmgBhQYntcaM/4ifY1UUtF6L5Io1xh4Bd6jem7DyhH+1pDHfOT5zCAK5OpiwjXOfBBz3VprY+uUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Utf29ulD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Utf29ulD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741C31F000E9;
	Fri, 17 Jul 2026 16:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784306989;
	bh=gCWe06j2SUsk6HXgZubom3fsdfAM4Ik9TQA9ZFSMijI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Utf29ulD5ip10utALRy8pOamRY9aKmlDAeQrhZCCxWUt7lOaZB6IFxZ50KbHzdc3x
	 Bvlnn5x8opvUarmRK5LDWoWX/q0//PEfjiSbc5+srxZYXNw8H5GkGetCkjFHJx0LEa
	 ISVFw91fdqNnty80LfT9iJg/LckdlJYo1jXmZvAD01v7JNpiWIfwzrOXyQFXKNpBjS
	 C//7SqzNw4laPHustZ4RybeJ0Belr9Bf2n2tcy4CMD0sTuvBb/JEbYlxWUNf3aqonQ
	 vwOcL0GMDYfV82n8CpOeupbj6PXd8q8x0YObqVeTBvSCYsJW4bn5Zson7RusdWplCM
	 h/mtCNFFC13Lg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 34/56] scsi: qla2xxx: Enhance ABTS processing for
 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-35-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-35-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:49:49 +0000
Message-Id: <20260717164949.741C31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Usage of C bitfields in the hardware-defined DMA structure `struct=
 abts_entry_24xx_ext` breaks data layout on Big-Endian architectures.

Pre-existing issues:
- [Critical] The DMA buffer `rsp_pkt` can be freed while the hardware firmw=
are is still actively processing it if the mailbox command times out.
--

--- Patch [34]: [PATCH v5 34/56] scsi: qla2xxx: Enhance ABTS processing for=
 29xx series ---
commit 64217fa79af8b429a3a92eb33321f697d422a0cf
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enhance ABTS processing for 29xx series

This patch enhances ABTS processing for the 29xx series adapters by using
extended ABTS entry structures to handle the larger 128-byte IOCB format.
It introduces type-generic macros for logging and response construction
to avoid code duplication, branching on IS_QLA29XX() for type handling.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 6fbcbdd208c38..8367aa005d1b5 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -72,15 +72,89 @@ static inline void display_Laser_info(scsi_qla_host_t=
 *vha,
[ ... ]
> +#define QLA_LOG_ISSUE_ABTS_RSP(vha, rsp, dma, rval) do {		\
[ ... ]
> +	(rval) =3D qla2x00_issue_iocb((vha), (rsp), (dma), 0);		\
> +	if (rval) {							\
> +		ql_log(ql_log_warn, (vha), 0x028c,			\
> +		    "%s: iocb failed to execute -> %x\n",		\
> +		    __func__, (rval));					\
> +	} else if ((rsp)->comp_status) {				\
[ ... ]
> @@ -140,60 +212,27 @@ qla24xx_process_abts(struct scsi_qla_host *vha, str=
uct purex_item *pkt)
[ ... ]
> +	if (IS_QLA29XX(ha)) {
> +		struct abts_entry_24xx_ext *rsp_ext =3D rsp_pkt;
> +
> +		QLA_BUILD_ABTS_BA_ACC(rsp_ext, abts_ext,
> +		    abts_ext->sof_type, fctl);

[Severity: High]
Does reading and writing the sof_type bitfield directly cause data corrupti=
on
on big-endian systems?

Since struct abts_entry_24xx_ext defines sof_type as a C bitfield over an
__le16 integer:

    __le16 vp_idx : 9;
    __le16 reserved_1_sof : 3;
    __le16 sof_type : 4;

Compilers on big-endian architectures will reverse the packing order of the
bits. If the hardware expects fixed little-endian bit offsets for DMA
reads/writes, wouldn't passing abts_ext->sof_type directly result in a
mangled bit sequence?

> +		QLA_LOG_ISSUE_ABTS_RSP(vha, rsp_ext, dma, rval);
>  	} else {
> -		ql_dbg(ql_dbg_init, vha, 0x028ea,
> -		    "%s: done.\n", __func__);
> +		struct abts_entry_24xx *abts_rsp =3D rsp_pkt;
> +
> +		QLA_BUILD_ABTS_BA_ACC(abts_rsp, abts,
> +		    abts->sof_type & 0xf0, fctl);
> +		QLA_LOG_ISSUE_ABTS_RSP(vha, abts_rsp, dma, rval);
>  	}
> =20
>  	dma_free_coherent(&ha->pdev->dev, rsp_sz, rsp_pkt, dma);
>  }

[Severity: Critical]
This is a pre-existing issue, but can this lead to kernel memory corruption
if the mailbox command times out?

In qla24xx_process_abts(), qla2x00_issue_iocb() executes a synchronous IOCB
command (called via QLA_LOG_ISSUE_ABTS_RSP). If this command times out, it
returns an error but the hardware reset is only scheduled asynchronously,
meaning the hardware might still be actively processing.

The function then unconditionally calls dma_free_coherent() on rsp_pkt. If
the hardware is delayed and finishes processing the timed-out command later,
could it DMA-write its completion status to this now-freed memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D34

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB6F479897
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 15:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784821991; cv=none; b=agFQAILGLHMXZgE8f9xD3GoluN6F2Jqf7yX1A/9fU4kaYK5t/NGOesfcpHA0Wg7GEVpMcy9LzLUJ+qseRB1Hi0qsArjQs7Ip4zs8Sw7LlyaTfVDt8eY2DN57rsrLeUSTnLiWVqkiPBqqCXUvOCgkIG9eAH/VbUKDElJpwMQoTUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784821991; c=relaxed/simple;
	bh=ashJ5bFhs9JlXntExNTvsJhoXuIianbFQKRv9wUwVGE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S54pYmoP6kkXJyME7nK+F0PQizvqmIqEyh1Y2E4Zjn4MWq2l3fMM0Lyfo08uwE4VKmvhwIusCg5icE4XMb4L9KBbX8azpjtfVbqpLu2tJGrAaBSBRjGPpKcdJ3biL062vJurs4XMwfxFFLz2/NnoRP9lZl+S3X7oquDnoF9r3rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572AF1F000E9;
	Thu, 23 Jul 2026 15:53:09 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 34/56] scsi: qla2xxx: Enhance ABTS processing for
 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-35-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-35-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 15:53:08 +0000
Message-Id: <20260723155309.572AF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Usage of C bitfields for hardware-defined struct fields causes end=
ianness corruption on big-endian architectures.

Pre-existing issues:
- [High] DMA Use-After-Free and data race if `qla2x00_issue_iocb()` times o=
ut.
--

--- Patch [34]: [PATCH v6 34/56] scsi: qla2xxx: Enhance ABTS processing for=
 29xx series ---
commit 80e303232b31e50198f4e69882bfefaff470d483
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enhance ABTS processing for 29xx series

Use extended ABTS entry structures (abts_entry_24xx_ext) for 29xx
series adapters to properly handle the larger 128-byte IOCB format.

Introduce type-generic macros (QLA_LOG_ABTS_RCV, QLA_BUILD_ABTS_BA_ACC,
QLA_LOG_ISSUE_ABTS_RSP) that leverage the shared field names between
abts_entry_24xx and abts_entry_24xx_ext to avoid code duplication.
Branch on IS_QLA29XX() for receive logging, exchange termination, and
BA_ACC response construction, with each path passing the correctly
typed pointer to the shared macros. The sof_type handling difference
(direct for 29xx bitfield vs & 0xf0 mask for legacy) is parameterized
through the sof_val macro argument.

Add BUILD_BUG_ON size check for struct abts_entry_24xx_ext.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 6fbcbdd208c38..8367aa005d1b5 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -72,15 +72,89 @@ static inline void display_Laser_info(scsi_qla_host_t=
 *vha,
>  		       mb3);
>  }
> =20
> +/*
> + * Type-generic helpers for qla24xx_process_abts().
> + * Both abts_entry_24xx and abts_entry_24xx_ext share field names for all
> + * accessed fields, so these macros expand correctly for either type.
> + */

[ ... ]

> +#define QLA_BUILD_ABTS_BA_ACC(rsp, src, sof_val, fctl) do {		\
> +	memset((rsp), 0, sizeof(*(rsp)));				\
> +	(rsp)->entry_type =3D ABTS_RSP_TYPE;				\
> +	(rsp)->entry_count =3D 1;						\
> +	(rsp)->nport_handle =3D (src)->nport_handle;			\
> +	(rsp)->vp_idx =3D (src)->vp_idx;					\
> +	(rsp)->sof_type =3D (sof_val);					\

[Severity: High]
Will these bitfield assignments cause endianness corruption on big-endian
architectures?

Since vp_idx and sof_type in struct abts_entry_24xx_ext are defined as C
bitfields:

        __le16  vp_idx : 9;             /* VP index 9 bits */
        __le16  reserved_1_sof : 3;
        __le16  sof_type : 4;

Assigning directly to them allows the C compiler to pack them based on host
endianness. On big-endian systems, this places the bitfields in the most
significant bits, but the little-endian firmware expects them at the least
significant bits.=20

Could this result in the firmware receiving an incorrect VP index and SOF
type, breaking FC operations?

> +	(rsp)->rx_xch_addr =3D (src)->rx_xch_addr;			\
> +	(rsp)->d_id[0] =3D (src)->s_id[0];				\
> +	(rsp)->d_id[1] =3D (src)->s_id[1];				\

[ ... ]

> @@ -140,60 +212,27 @@ qla24xx_process_abts(struct scsi_qla_host *vha, str=
uct purex_item *pkt)
>  	}
> =20
>  	/* send ABTS response */
> +	if (IS_QLA29XX(ha)) {
> +		struct abts_entry_24xx_ext *rsp_ext =3D rsp_pkt;
> +
> +		QLA_BUILD_ABTS_BA_ACC(rsp_ext, abts_ext,
> +		    abts_ext->sof_type, fctl);
> +		QLA_LOG_ISSUE_ABTS_RSP(vha, rsp_ext, dma, rval);
>  	} else {
> +		struct abts_entry_24xx *abts_rsp =3D rsp_pkt;
> +
> +		QLA_BUILD_ABTS_BA_ACC(abts_rsp, abts,
> +		    abts->sof_type & 0xf0, fctl);
> +		QLA_LOG_ISSUE_ABTS_RSP(vha, abts_rsp, dma, rval);
>  	}
> =20
>  	dma_free_coherent(&ha->pdev->dev, rsp_sz, rsp_pkt, dma);

[Severity: High]
This is a pre-existing issue, but does this function have a DMA
use-after-free risk if qla2x00_issue_iocb times out?

Earlier in qla24xx_process_abts, qla2x00_issue_iocb is called to send an ELS
response using rsp_pkt. If that command times out, the firmware may still be
actively processing it.

Since the function merely logs a warning and proceeds, it ends up
overwriting the actively-used DMA memory here in QLA_BUILD_ABTS_BA_ACC and
re-issuing it. Finally, the function calls dma_free_coherent while the
firmware might still be writing its completion status to the buffer, leading
to a DMA use-after-free.

>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D34

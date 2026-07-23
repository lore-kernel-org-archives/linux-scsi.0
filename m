Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E502466AF7
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 14:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784817592; cv=none; b=XZsem+13ewo2+xuVJOG/XiZg5UKo+pX8zlf475d4an4LYlWlP1srKaCAI3aPGLc+h4lbE7X5mPskBGtBhG0oZAVKj91RuEDPB1fVjhTpwLfhFQzBAtanb6Wgq72ADDNZbpdw9mNR4cXN9XTum+S7GIMxcCGMokNOdkxogTkWrn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784817592; c=relaxed/simple;
	bh=5bQFWLTbXAPhjpFX480Nl6G2jcZPN9nAbEJ8YmHF+z8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GbzP2ls76at2S6aVy9w3QM24o+d+Il1YpLEDNRY+/VT/dsHvHHTE7yytFntPdJ0YDhX4EiksMfREaxmvxthJDGfoAMGFWpwPCnVXCIwmOL8PySJUTrJ60neiROiwF+kqVsYUysVdBeybOxAzIanISUGW0biIYrh5575v5iox0hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17C41F00AC4;
	Thu, 23 Jul 2026 14:39:45 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 30/56] scsi: qla2xxx: Add size check for ELS status
 entry layout on 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-31-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-31-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 14:39:42 +0000
Message-Id: <20260723143945.C17C41F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Hardware-defined structures `els_sts_entry_24xx_ext`, `els_entry_2=
4xx_ext`, `abts_entry_24xx_ext`, and `vp_rpt_id_entry_24xx_ext` use C bitfi=
elds, which breaks memory layout on big-endian architectures.

Pre-existing issues:
- [High] Missing dma_rmb() after checking the response queue entry signatur=
e, causing a data race against the hardware DMA.
--

--- Patch [30]: [PATCH v6 30/56] scsi: qla2xxx: Add size check for ELS stat=
us entry layout on 29xx ---
commit 1f1ccbc0c325b75366f8fa3f7fd4fcf61ec13421
Author: Nilesh Javali <njavali@marvell.com>
scsi: qla2xxx: Add size check for ELS status entry layout on 29xx

This commit adds a BUILD_BUG_ON check to validate that
struct els_sts_entry_24xx_ext is 128 bytes, matching the 29xx firmware
IOCB size. It also adds a docblock in qla24xx_els_ct_entry() detailing
the memory layout overlay and improves log messages.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 404dcb24b6887..14b774f25b97e 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2359,6 +2359,22 @@ static void
>  qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
>  		     void *pkt, int iocb_type)
>  {
> +	/*
> +	 * els_sts_entry_24xx_ext (29xx) overlays els_sts_entry_24xx for every
> +	 * field touched in this completion handler: comp_status (offset 8),
> +	 * total_byte_count (32), error_subcode_1 (36), error_subcode_2 (40),
> +	 * d_id[]/s_id[] (24..29), control_flags (30) all sit at byte-identical
> +	 * offsets in both layouts (only vp_index/sof_type at offset 14-15 are
> +	 * bit-packed differently, and that field is write-only on the issue

[Severity: High]
Does defining C bitfields in the hardware structure els_sts_entry_24xx_ext
break the memory layout on big-endian architectures?

In drivers/scsi/qla2xxx/qla_fw29.h:els_sts_entry_24xx_ext:
	__le16	vp_index : 9;		/* VP Index 9bits */
	__le16	reserved_1_sof : 3;
	__le16	sof_type : 4;

Using __le16 with bitfields doesn't fix the endianness of the bitfields
themselves. Because they are placed in an implementation-defined order
(LSB-to-MSB on little-endian vs MSB-to-LSB on big-endian), hardware receives
scrambled values on big-endian architectures.

A similar issue appears in els_entry_24xx_ext. Can this lead to
device failure when communicating with the 29xx firmware on big-endian
systems like s390x or PowerPC?

[ ... ]

[Severity: High]
This is a pre-existing issue, but is there a missing dma_rmb() after checki=
ng
the response queue entry signature in qla24xx_process_response_queue()?

In drivers/scsi/qla2xxx/qla_isr.c:qla24xx_process_response_queue():
	while (rsp->ring_index !=3D rsp_in &&
		       rsp->ring_ptr->signature !=3D RESPONSE_PROCESSED) {
		pkt =3D (void *)rsp->ring_ptr;
		cur_ring_index =3D rsp->ring_index;

		qla_rsp_ring_advance(rsp);

		if (((response_t *)pkt)->entry_status !=3D 0) {

The loop condition reads the descriptor signature to check for completion,
but accessing the payload (like entry_status) without executing dma_rmb()
first can cause a data race against the hardware DMA.

On weakly ordered architectures (e.g., ARM64, PowerPC), does this allow
speculative out-of-order reads, leading to parsing stale descriptor data?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D30

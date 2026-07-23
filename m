Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15024570EA
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 16:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784823168; cv=none; b=NAE2IL665G2DA+1Pz/gKM5b5yiqvvKdnaEhMkd+MAA9449Z2Zn+lvToVX5Asia4CMUA95gNquX4ux/QUSLiW091ktdNMET3x/EwEJXA9MPOWoJk5q2dkJzpSnJJJJoSPK5e2IVSSB8zPcIPrV7qI4Cx2WA4w/EYzSnw3SttZfzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784823168; c=relaxed/simple;
	bh=P/og2kxoTATERzTlZ2+VGOLNFTWxG3sFxncUwKcRV8s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=H4z1Rtpurj0ysTgRadCefqeUiENQGEUogzLqD9QrH97oMDZ95oingeakAxg4Uopag+RhYCZGvfO6qSOug2mD+ua2CoaDLGowEqLTrTCAXxatf1hmy2DTkVMxbZb2dG8JPqBZLrQuhgrgLyNYqUAGgrV1xcWWzbIgsuWEiCvkpAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BE91F000E9;
	Thu, 23 Jul 2026 16:12:45 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 35/56] scsi: qla2xxx: Update VP control IOCB handling
 for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-36-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-36-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 16:12:41 +0000
Message-Id: <20260723161245.13BE91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing bounds check on `vp_index` allows an out-of-bounds array w=
rite within the IOCB struct in `qla25xx_ctrlvp_iocb()`.
- [High] Missing `dma_rmb()` after reading the ownership signature from the=
 DMA response queue descriptor.
--

--- Patch [35]: [PATCH v6 35/56] scsi: qla2xxx: Update VP control IOCB hand=
ling for 29xx series ---
commit 3663b31ed4aaf500c1d3217a87f3276026fd224c
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Update VP control IOCB handling for 29xx series

This patch updates the VP control IOCB command and response handling to sup=
port
the 29xx series adapters. It modifies qla25xx_ctrlvp_iocb() and
qla_ctrlvp_completed() to accept generic void pointers, allowing them to
handle both 64-byte and 128-byte entry layouts seamlessly.

> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index b631fee8c430f..7e3a415d2c43e 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -4074,22 +4074,31 @@ qla_nvme_ls(srb_t *sp, struct pt_ls4_request *cmd=
_pkt)
>  }
> =20
>  static void
> -qla25xx_ctrlvp_iocb(srb_t *sp, struct vp_ctrl_entry_24xx *vce)
> +qla25xx_ctrlvp_iocb(srb_t *sp, void *pkt)
>  {
> +	/*
> +	 * vp_ctrl_entry_24xx_ext is layout-identical to vp_ctrl_entry_24xx
> +	 * for all fields touched here (entry_type, handle, entry_count,
> +	 * command, vp_count, vp_idx_map) -- they all sit at the same
> +	 * offsets and types in both structs, and the ext layout merely
> +	 * tacks on flags/id/hopct/reserved at offset 32+.  So no
> +	 * IS_QLA29XX(ha) dispatch is needed on the issue path.
> +	 */
> +	struct vp_ctrl_entry_24xx *vce =3D pkt;
>  	int map, pos;

[ ... ]

>  	/*
>  	 * index map in firmware starts with 1; decrement index
>  	 * this is ok as we never use index 0
>  	 */
>  	map =3D (sp->u.iocb_cmd.u.ctrlvp.vp_index - 1) / 8;
>  	pos =3D (sp->u.iocb_cmd.u.ctrlvp.vp_index - 1) & 7;
> +
> +	vce->entry_type =3D VP_CTRL_IOCB_TYPE;
> +	vce->handle =3D sp->handle;
> +	vce->entry_count =3D 1;
> +	vce->command =3D cpu_to_le16(sp->u.iocb_cmd.u.ctrlvp.cmd);
> +	vce->vp_count =3D cpu_to_le16(1);
>  	vce->vp_idx_map[map] |=3D 1 << pos;

[Severity: High]
This isn't a bug introduced by this patch, but does this write corrupt
adjacent fields in the DMA-mapped IOCB structure?

Since max_npiv_vports can be configured up to 255, vp_index can reach 254.=
=20
When vp_index is greater than 128, the map index becomes >=3D 16.

Because vp_idx_map is only a 16-byte array, writing to vce->vp_idx_map[map]
in this case writes past the end of the array, potentially corrupting fields
like flags, id, hopct, and reserved_5 before the descriptor is sent to the
firmware.

>  }

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 8367aa005d1b5..128138b4d16a9 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c

[ ... ]

> @@ -4228,8 +4234,7 @@ void qla24xx_process_response_queue(struct scsi_qla=
_host *vha,
>  			    (struct mbx_24xx_entry *)pkt);
>  			break;
>  		case VP_CTRL_IOCB_TYPE:
> -			qla_ctrlvp_completed(vha, rsp->req,
> -			    (struct vp_ctrl_entry_24xx *)pkt);
> +			qla_ctrlvp_completed(vha, rsp->req, pkt);

[Severity: High]
This is a pre-existing issue, but is it possible for the CPU to read stale
descriptor fields when processing this DMA response queue?

In qla24xx_process_response_queue(), the CPU reads the descriptor ownership
signature:

    while (rsp->ring_index !=3D rsp_in &&
           rsp->ring_ptr->signature !=3D RESPONSE_PROCESSED) {
        ...
        if (((response_t *)pkt)->entry_status !=3D 0) {

If the CPU observes a changed signature, it assumes device ownership transf=
er
is complete and proceeds to read payload fields (like entry_status and the
type fields handled in this switch statement).

Without a dma_rmb() immediately after reading the signature, weakly-ordered
CPUs may reorder the memory reads and fetch the payload fields before the D=
MA
write for them is visible in CPU cache. Would adding a dma_rmb() prevent
the driver from processing uninitialized or stale status payload data?

>  			break;
>  		case PUREX_IOCB_TYPE:
>  			if (IS_QLA29XX(ha)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D35

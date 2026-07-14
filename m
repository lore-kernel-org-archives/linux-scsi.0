Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F1049552D
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 15:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784042337; cv=none; b=b6BunsuCcTVpRG+dtmmumhXnfCY/TOQveMPhebtrY2aLSb6KAs8rhruQYvPkxdYabZAmtzLtRTSfLJauqjYf1NmIk6f/PPxs/CYKISjseTTynQpXYjWKUO/I3Ht5ZYbRcH0YI7tv5cDLR7VkBrrb9PscPjSsE3TM6FODzuY3YiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784042337; c=relaxed/simple;
	bh=bsjNnS0c6ecH1T40cB0KmNV9ac2/O+sOaTyqCQd+nLE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Op9wmppsBrpr2+TFBFllR/k4BB56wkYhehKxTmuMVfO9fBPSnkUzDR4huvl1McDX4qcaQlyF4CzuBFtbSC4g2/Oyp5HzTKW4AXGSosdPEDfQTHT4kyzFOYTxx3421ynwGptWtWTQzbgwxqv4B4u8WPcRtmgL/sIV62FuNbx6FMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pi8o5T2F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pi8o5T2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3343A1F000E9;
	Tue, 14 Jul 2026 15:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784042336;
	bh=hnskZ+L1sL1obpiDc1OUqzBhNWOmUCwUtQTL3DCwY54=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Pi8o5T2FQOEGzZ6ZPQU2mbtS5DAWOeLSSrxn79tCkxxvkOzQYQEwMMTY6a40s+jxz
	 Thnh/BWLaz92FnRfcTn4XyM8mjsG1jYqHISMWmw5x2LmEchIJKcG5yNX4R9vqtmA4Q
	 mlP27Q5I3z1e8ybVy980bqgs/gRuUGWthlCQsnHSYz0k8b/EjlnxwZqAoJHhi/WQCv
	 rQ50ooKGDObp1zGSCxcAyX1dVPsvK/7qgYZQ9hAcVfzJ7RWghXGaSrFd5CLyOUD7EH
	 br67hrFyGEwg7WNF3BqW3sfdSmiLkiyyB58ce36V2bFtyZYQx6g5P9NUF0nyBO9Ilo
	 7a1v9XTydIv6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 33/56] scsi: qla2xxx: Add abort command handling for
 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-34-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-34-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 15:18:55 +0000
Message-Id: <20260714151856.3343A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Deadlock risk in the abort path due to `GFP_KERNEL` allocation ins=
ide SCSI error handler / NVMe abort workqueue.
- [High] Time-Of-Check to Time-Of-Use (TOCTOU) race condition in the abort =
path allows the firmware to abort an unrelated, newly queued command.
--

--- Patch [33]: [PATCH v4 33/56] scsi: qla2xxx: Add abort command handling =
for 29xx series ---
commit 062493151f7c65c9841b286b24c4fdbc4ccf220d
Author: Nilesh Javali <njavali@marvell.com>
Subject: scsi: qla2xxx: Add abort command handling for 29xx series

This commit extends the abort-IOCB code path to support the 29xx extended
abort_entry_24xx_ext structure alongside the existing abort_entry_24xx.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 9bef87862077e..0d7aa6fce0072 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -3356,28 +3356,42 @@ qla24xx_abort_command(srb_t *sp)
>  		return QLA_ERR_NOT_FOUND;
>  	}
> =20
> -	abt =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &abt_dma);
> -	if (abt =3D=3D NULL) {
> +	abt_buf =3D dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &abt_dma);

[Severity: High]
This is a pre-existing issue, but does this allocation risk causing a
deadlock? When an IO times out, the error handling path (such as
qla2xxx_eh_abort or the NVMe qla_nvme_abort_work) calls
qla24xx_abort_command().

If the system is under memory pressure, using GFP_KERNEL allows the
allocator to sleep and enter memory reclaim. If the reclaim process
attempts to flush dirty pages to the block layer, and those IOs are
routed to this same HBA, it creates a circular dependency where the
block layer waits for the HBA to recover, but the HBA recovery thread is
blocked here waiting for memory reclaim.

Should this use GFP_ATOMIC or GFP_NOIO to avoid re-entering the storage
stack?

Also, this sleeping allocation seems to open a race window. Before this
allocation, qla24xx_abort_command() releases the hardware queue lock:

spin_lock_irqsave(qpair->qp_lock_ptr, flags);
for (handle =3D 1; handle < req->num_outstanding_cmds; handle++) {
    if (req->outstanding_cmds[handle] =3D=3D sp)
        break;
}
spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);

During the unlocked, sleeping window in dma_pool_zalloc(), can the
original command complete naturally, freeing up the handle? If a
concurrent thread issuing a new IO allocates this same freed handle for
an unrelated command, could the firmware end up aborting the wrong,
newly queued command once we resume?

> +	if (abt_buf =3D=3D NULL) {
>  		ql_log(ql_log_warn, vha, 0x108d,
>  		    "Failed to allocate abort IOCB.\n");
>  		return QLA_MEMORY_ALLOC_FAILED;
>  	}
> +	abt =3D abt_buf;
> =20
> +	/*
> +	 * abort_entry_24xx_ext overlays abort_entry_24xx through
> +	 * req_que_no (offsets 0-17), and entry_status (offset 3) and
> +	 * comp_status (offset 8) sit at identical offsets in both, so
> +	 * the common header writes and the completion-status reads are
> +	 * stride-agnostic and go through the 24xx view.  Only port_id
> +	 * (24xx-only) and vp_index width / offset diverge per stride.
> +	 */
>  	abt->entry_type =3D ABORT_IOCB_TYPE;
>  	abt->entry_count =3D 1;
>  	abt->handle =3D make_handle(req->id, abt->handle);
>  	abt->nport_handle =3D cpu_to_le16(fcport->loop_id);
>  	abt->handle_to_abort =3D make_handle(req->id, handle);

[Severity: High]
This isn't a bug introduced by this patch, but if the handle was reassigned
during the GFP_KERNEL allocation above, wouldn't we embed a stale handle
into the abort payload here?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D33

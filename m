Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FB63BB114
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781264158; cv=none; b=aFs3WfMuVlBoPA7Y81WQIF063eE/Tu2Bh4gVgqhVcm3x4hGgYeRO+ah7N5aIox/7ciAYMvgN8zra5PXPjf14yRFUDXJ4LGl6QgE2dszWy5hTc/h7io7+WESDeNBPgapdZYHeMTRYwh2iUp31jeDao3F0g2wvaRl7GuhL1UzO95M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781264158; c=relaxed/simple;
	bh=UYTEabtURqZJyuXa/NoKjMLLluW6wZlKEMx9tnnfZHU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZitxmFwJM5oxA7OlMpvKgB+DeIN77mh1saFVtOZSFd2FjarXQTvw8HyY4Avlb0w+SFEowtx5AvNfuMnibneE0qY3ohZGg1dcmBgIELKmHTkzJAKsb1NC+miQn13KjJ95sUD4SKGzRqlfbqJn42VwNHOoGrphwI6id/Me4H9bvyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mrOdNHrC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mrOdNHrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE051F000E9;
	Fri, 12 Jun 2026 11:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781264153;
	bh=WZmyAOUeOQZSFSu8+hv9/F37sErqXDOb66Gt3g3iHcQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mrOdNHrCoLh4Y6Oq20IGn7NkaVyT4XxC1k3QcjSUzHzxynIkwLAIGINjH60zljI7b
	 E/ijZQFwCPZgyfiUS7TmmHl41wr4ZgxN+uyyGFQmAdWMm1v/F9qyUxDTRslSIITr4H
	 DRkrVWb10lY2YPxOp/jhY7qhxFswJJ5AIbY6AQtHl5NaMG/V8SABCnKHeuMBZGoERU
	 5h37CUtKuyaZbT1EBnC/h1+o9NkP14hy1gZYTwuRBwullr40FCxQo9uU9TfbYyiYMF
	 70+FMmkoWiMijVUMIfSzv1BPrNqP1hllBlMg/8jpHZP1SPdnlNkBBCOeRUC6EsBTko
	 mGFE8OnTsDMww==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 53/60] scsi: qla2xxx: Bound VP index against VP_CTRL
 IOCB bitmap size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-54-njavali@marvell.com>
References: <20260612095333.1666592-54-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 11:35:53 +0000
Message-Id: <20260612113553.BAE051F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The patch prevents out-of-bounds memory accesses by rejecting `vp_=
index > 128` during VP disable, but fails to clamp the maximum number of ad=
vertised VPs to 128. This creates an asymmetry where VPs > 128 can still be=
 created and enabled, but their deletion will silently fail to disable the =
VP in firmware, leading to a permanent firmware resource leak.

Pre-existing issues:
- [High] A race condition between the async IOCB timeout handler and the IS=
R completion path can result in double completion executions and use-after-=
free of the SRB and on-stack completion variable.
--

commit efb150f1a60ba57983eb9491ce05b1ecf81e2b1b
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size

This commit fixes an out-of-bounds write in qla25xx_ctrlvp_iocb() by adding
bounds checking for vp_index against the fixed 128-bit vp_idx_map bitmap.
It also adds a check in qla24xx_control_vp() to reject requests with
vp_index > 128.

> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index 7072af5b42178..b7d9c1a53f3ce 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -987,6 +987,14 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
>  	if (vp_index =3D=3D 0 || vp_index >=3D ha->max_npiv_vports)
>  		return QLA_PARAMETER_ERROR;
> =20
> +	/*
> +	 * The VP_CTRL IOCB selects the target VP through a fixed 128-bit
> +	 * (16-byte) vp_idx_map bitmap, so vp_index must fit within it even
> +	 * if firmware advertises more NPIV vports.
> +	 */
> +	if (vp_index > sizeof_field(struct vp_ctrl_entry_24xx, vp_idx_map) * 8)
> +		return QLA_PARAMETER_ERROR;
> +

[Severity: High]
If firmware advertises up to 255 VPs (since ha->max_npiv_vports is parsed f=
rom
mcp->mb[11] in qla2x00_get_fw_version()), does this new bounds check introd=
uce
a firmware resource leak during VP deletion?

While this prevents the out-of-bounds write, VPs with vp_index > 128 can st=
ill
be successfully created because the maximum advertised limit is not clamped.
When deleting such a VP, qla24xx_vport_delete() calls qla24xx_disable_vp(),
which will now fail and return QLA_PARAMETER_ERROR due to this check.

Because the deletion process ignores this failure and continues fully freei=
ng
the kernel's local data structures, won't the firmware still consider the VP
active, resulting in a permanent leak? Is it possible to clamp
ha->max_npiv_vports to 128 during initialization to prevent creating these
VPs in the first place?

>  	/* ref: INIT */
>  	sp =3D qla2x00_get_sp(base_vha, NULL, GFP_KERNEL);
>  	if (!sp)

[Severity: High]
This is a pre-existing issue, but does the on-stack completion variable used
alongside this SRB introduce a use-after-free risk due to a race condition
in the async IOCB timeout handler?

If qla2x00_async_iocb_timeout() executes and the abort fails, it attempts to
remove the SRB from the outstanding_cmds array, but unconditionally calls
sp->done(sp, QLA_FUNCTION_TIMEOUT) without verifying if the SRB was actually
found and removed:

drivers/scsi/qla2xxx/qla_init.c:qla2x00_async_iocb_timeout() {
    ...
    spin_unlock_irqrestore(sp->qpair->qp_lock_ptr, flags);
    sp->done(sp, QLA_FUNCTION_TIMEOUT);
    ...
}

If the normal ISR completes the command concurrently, it will remove the SRB
and also call sp->done(). This causes qla_ctrlvp_sp_done() to execute twice.

The first execution wakes up the submitter thread here, causing it to free
sp and destroy the on-stack comp variable. Won't the second execution then
call complete() on a dangling comp pointer, leading to a stack use-after-fr=
ee?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D53

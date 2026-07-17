Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EE12949E0
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784307563; cv=none; b=eIU42Ac7jaG6aRm79YCIwpxZBQRSRjL7F0MOJK5RSThuvsjdeEcVNRLVwG9/JmJLM9l3jeLECsy6JRJjAIkNNnJWSPGLj0SNPoSb2+NmzMK3KOec/N8q7KEYuzEEpBzFTpgeqP2PdHCtFd43gxb6V9ia6Z1OIzHhFg8OMoVwk1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784307563; c=relaxed/simple;
	bh=vUIKKaF1KdZpqDItrEl84X2aKGBWj5H8/Fc4CYH8Np0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rr1hzmuk2icqyhOit6W7f/36JHgvGRnCub0DOlfErh+any/sbfXhAU4dPx7sigp+ivAFKxItFjyKifI8EGxyNG7+KZdBHlgy9Y2AsJsAUUTZHfp6hAF3mZpma7t8ymdchtCA3HF21vlwseaOQ8k+McxNAVXIZkV3VP1QHq+n5gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QITKFWU1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QITKFWU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DC51F000E9;
	Fri, 17 Jul 2026 16:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784307561;
	bh=bcOCKGpDZcUly9kNT3kpdcm5KyKvo8r6j5yiDuXh0Dw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QITKFWU13Sx28POMllPSzQihVTNJcebZ4Wwg5HVJ/RIWRtJ7gCA+PrBorY1TLXPld
	 uB6tdu03Uw/aHUHV5Yg/dUoELlxfBcvmXJelVcWBm73mWHFgYLDG6ev69i+Mw3D4Kf
	 5g+TgOzLRYdE8IcAIrtOwwV5Lian2xOD04mJq0fIC6FZLz7FKu2qm8fk3DnwuEebx0
	 6/D8s6Z0ga4dFyig5eIy4GURW/jdInrx+dgpYNNNGA/ecgh5RiC8FQdTr518ac9kV+
	 KDLD6ZYEZhoC4IYYp2FH8Ydl9nHgOTr8KiWXM1m71LIZ/dKzKXod9H3SrGZBm8hAyr
	 NrcX7XUrcrqIA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 49/56] scsi: qla2xxx: Check entry_status in
 qla24xx_modify_vp_config()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-50-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-50-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:59:20 +0000
Message-Id: <20260717165921.61DC51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but if the mailbox c=
ommand times out, the IOCB DMA memory is freed immediately while the hardwa=
re may still write to it, leading to potential DMA-to-freed-memory corrupti=
on.
--

--- Patch [49]: [PATCH v5 49/56] scsi: qla2xxx: Check entry_status in qla24=
xx_modify_vp_config() ---
commit 3dcfe3a8a4d45934e8e20a4f3d032dc1de73fa0f
Author: Nilesh Javali <njavali@marvell.com>
Subject: scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()

The commit fixes the completion status check in qla24xx_modify_vp_config() =
by
correctly examining entry_status instead of testing comp_status twice. This
prevents the driver from incorrectly initializing the virtual port when the
firmware has rejected the IOCB.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index b32ca8ed274d6..59023492c5a98 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4401,10 +4401,10 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
>  	if (rval !=3D QLA_SUCCESS) {
>  		ql_dbg(ql_dbg_mbx, vha, 0x10bd,
>  		    "Failed to issue VP config IOCB (%x).\n", rval);
> -	} else if (vpmod->comp_status !=3D 0) {
> +	} else if (vpmod->entry_status !=3D 0) {
>  		ql_dbg(ql_dbg_mbx, vha, 0x10be,
>  		    "Failed to complete IOCB -- error status (%x).\n",
> -		    vpmod->comp_status);
> +		    vpmod->entry_status);
>  		rval =3D QLA_FUNCTION_FAILED;
>  	} else if (vpmod->comp_status !=3D cpu_to_le16(CS_COMPLETE)) {
>  		ql_dbg(ql_dbg_mbx, vha, 0x10bf,
[ ... ]
>  		rval =3D QLA_FUNCTION_FAILED;
>  	} else {
>  		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10c0,
>  		    "Done %s.\n", __func__);
>  		fc_vport_set_state(vha->fc_vport, FC_VPORT_INITIALIZING);
>  	}
>  	dma_pool_free(ha->s_dma_pool, vpmod, vpmod_dma);

[Severity: High]
This isn't a bug introduced by this patch, but if the mailbox command times
out, could this lead to DMA-to-freed-memory corruption?

If qla2x00_issue_iocb() returns QLA_FUNCTION_TIMEOUT (which schedules an
asynchronous ISP abort), qla24xx_modify_vp_config() immediately frees the
vpmod DMA buffer back to s_dma_pool.

Since the hardware has not yet been reset, could it still complete the
delayed command and perform a DMA write of the completion status to the
vpmod_dma address?

If the DMA pool has reused this memory for another command, could the delay=
ed
write corrupt the new structure?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D49

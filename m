Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B35C349CC4
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 15:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781277172; cv=none; b=uJFWwrwhGmNzaPK3ONTxwteMy8eIq7HUMnp6Djt/59/CIinfF5Kl+GxgsRBa7Yv7jIIoD5BJF4BvEJYUw2Sa7IXAkTfu+9O0CO6sqR/PrH2P4eq9j7aFxuiizXlo1ivpx5URZf2WAi85XSYUdziD5CrBE7Ey5cHhFXrr9AXqeRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781277172; c=relaxed/simple;
	bh=+geGvRCVLZvqNriqMGbTwygp/mmAmrYaYNnIhxAjnbU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oZALEADxQUE7g8+iMK/K/0kjyxS05jNn7YJDEfgJKzxI3kFp8JEy4lLvp7LX96e1YYs11SOJkwNIpX8AtG+wBCI///+OnFN8+5OOiZX8mVBcTT1zzVCWqPgX9u5lhXziKT1sN8GwF8ApTUePBwCPHLGvn6UQ9UcHwBI3am2DB14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XbVNFxM9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XbVNFxM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88CC1F00A3A;
	Fri, 12 Jun 2026 15:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781277171;
	bh=9ng9/EcIzcgnUEXpVZwJ33I1cxrkdSCjxaG5UxRV9qA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XbVNFxM9UQmWpVrj5Aks5ujGkxuL7sdhfYa6oqduZtb8mWTJA48R0kmdFbiCZ+PBs
	 fqKBirIkcPhHo9lhze0ugh0GIp504T6inPCP5S2IhgI/Z/HgPnQ7GOhe3gY4iEh5S7
	 usc0FnolnETxj02hS1sy9YJtaUQQn32IAtTEnYRktsbHhBdWStPaauqa63/wiCZits
	 lIjzb0F+UXtNmguteihEba6H0IyEQEUBySqJWY0+Kkip+qkXqMQ0/HPqRz21psHA93
	 M0MqeiZcDpM0r2kcwaj2oblbIJGhXJtDaxbvwFjRIRGM5/FbyAOO6J/vAVIzMpk+CO
	 zH4F/7TZ1M/pQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 37/60] scsi: qla2xxx: Enhance ABTS processing for
 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-38-njavali@marvell.com>
References: <20260612095333.1666592-38-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 15:12:50 +0000
Message-Id: <20260612151250.C88CC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Releasing and reusing the `rsp_pkt` DMA buffer immediately after a=
 hardware timeout can lead to a use-after-free and memory corruption by the=
 device.
--

commit 95311a058967d0d565bd44ef588d75babbb03f6f
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enhance ABTS processing for 29xx series

This commit introduces extended ABTS entry structures to properly
handle the 128-byte IOCB format for the 29xx series adapters. It also
adds type-generic macros to reduce code duplication in the ABTS
processing path.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 5b5ccf2075353..284d874392fd5 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
[ ... ]
> @@ -140,60 +212,27 @@ qla24xx_process_abts(struct scsi_qla_host *vha, str=
uct purex_item *pkt)
>  	}
> =20
>  	/* send ABTS response */
> -	abts_rsp =3D rsp_pkt;
> -	memset(abts_rsp, 0, sizeof(*abts_rsp));
[ ... ]
> -	rval =3D qla2x00_issue_iocb(vha, abts_rsp, dma, 0);
> -	if (rval) {
[ ... ]
> +	if (IS_QLA29XX(ha)) {
> +		struct abts_entry_24xx_ext *rsp_ext =3D rsp_pkt;
> +
> +		QLA_BUILD_ABTS_BA_ACC(rsp_ext, abts_ext,
> +		    abts_ext->sof_type, fctl);
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

[Severity: High]
This is a pre-existing issue, but could this code lead to a use-after-free
and memory corruption?

Earlier in qla24xx_process_abts(), qla2x00_issue_iocb() is called to send an
ELS response using the same rsp_pkt buffer:

    rval =3D qla2x00_issue_iocb(vha, rsp_pkt, dma, 0);
    if (rval) {
        ql_log(ql_log_warn, vha, 0x0288,
            "%s: iocb failed to execute -> %x\n", __func__, rval);
    } else if ...

If the command times out, qla2x00_issue_iocb() returns a non-zero rval, but
execution continues. The code then reuses rsp_pkt to send an ABTS response
and unconditionally frees it via dma_free_coherent() right after.

If the firmware is still holding the physical DMA address and completes the
delayed command later, wouldn't it perform a DMA write to the freed physical
address?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D37

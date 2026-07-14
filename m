Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0E2466B65
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 13:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784035859; cv=none; b=enQ/UPHUDQ9AuPOxe9KAaqK3BXpoxUtUkkHKo4Cs/Iq3MEwlXDBWEuvKMIhwOqrGrsxZBfzak4ANtD09OyGNjV+ginz5V1As0Wq9yb2xEg2pVPDSYXjQcl5nYrH5hlTmq7mcK3ckAkvJIg7taS8tWGaMKrtui/8q3pIBkBLyrhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784035859; c=relaxed/simple;
	bh=A6ALRFehT/h6cixqrTbyVwMJJ0/XE5rMaQZXEt35n5I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=H1l48DG+Qb+hNacx/K4Mld41uc9ItYZW/IUEq93TYdobZQhuQSxeeU0GXifhFchZkIDyk/4JSmLmwLo2Tzt4wczkzamMHvHC/DDcCsKyv+yA9RmordmgGiRlCyjf5EInxec3c2RfksWhbRjaKQWUUOjZBI973lbihKkEjIjgo7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YuVXkOmE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YuVXkOmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AB91F000E9;
	Tue, 14 Jul 2026 13:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784035853;
	bh=trOJeW8x4TL3K5Eb7MgV0fUjsLQ2tgUAhog8rDqn3Rk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YuVXkOmEsmjaHYI2MxovA2MLVqbjYe+DxvnhkFLUDk/YWgQRl+TU0yq7A3huNWYrY
	 7LX+ouL0t+OOCbpxpXzUV39UcVufkdPcLTpW7SvIHc8vRouk/FsDHeDZtQV5Z2fVTD
	 hukSTAqYVZjq+ds85C2XtvuPSmykfhuwT6yVdjIngRuKRdkC5IQelm9ipn8ks+B+A2
	 69Z3tPvpmC4OOb9r6pFe3/OhsswEDg4UVh0CHsopqsAQzxupJR9XhRS4JXNHC++24v
	 lKZcU382X5TO36FHE5t41+QgQFZ14doOFSjU46t4eQOPcdNBWKbErmNPP/FgSMdukY
	 j2HmWmO2vMlEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 22/56] scsi: qla2xxx: Enable qla2x00_shutdown for
 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-23-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-23-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 13:30:52 +0000
Message-Id: <20260714133053.47AB91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Mismatched allocator and deallocator for crc_ctx in the command qu=
euing error paths.
- [High] Logic inversion and Use-After-Free in qla2x00_abort_srb when waiti=
ng for firmware abort completion.
--

--- Patch [22]: [PATCH v4 22/56] scsi: qla2xxx: Enable qla2x00_shutdown for=
 29xx ---
commit f4293733252c862c9a670e30cbe9ec9b3965ea0f
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enable qla2x00_shutdown for 29xx

Enable qla2x00_shutdown for 29xx adapter by adding IS_QLA29XX check
to the shutdown path that performs firmware abort cleanup.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 146701445485f..5450c40259bf9 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3840,7 +3840,7 @@ qla2x00_shutdown(struct pci_dev *pdev)
>  		qla2x00_disable_eft_trace(vha);
> =20
>  	if (IS_QLA25XX(ha) ||  IS_QLA2031(ha) || IS_QLA27XX(ha) ||
> -	    IS_QLA28XX(ha)) {
> +	    IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
>  		if (ha->flags.fw_started)
>  			qla2x00_abort_isp_cleanup(vha);
>  	} else {

[Severity: High]
This is a pre-existing issue, but is it safe to free a DMA pool allocation
using mempool_free()?

In the queuing_error paths of qla24xx_start_scsi() and
qla2xxx_dif_start_scsi_mq() when I/O submission fails, the dma_pool_zalloc'd
crc_ctx is freed using mempool_free():

drivers/scsi/qla2xxx/qla_iocb.c:qla24xx_start_scsi() {
    ...
	mempool_free(sp->u.scmd.crc_ctx, ha->ctx_mempool);
    ...
}

drivers/scsi/qla2xxx/qla_iocb.c:qla2xxx_dif_start_scsi_mq() {
    ...
	mempool_free(sp->u.scmd.crc_ctx, ha->ctx_mempool);
    ...
}

Could this lead to memory corruption or allocator crashes? Furthermore, if
ha->ctx_mempool is null (which happens when dif is enabled but security is
not), could this cause a null pointer dereference?

[Severity: High]
This isn't a bug introduced by this patch, but does this logic inversion
cause a use-after-free and potential stack corruption?

Looking at qla2x00_abort_srb() when waiting for firmware abort completion:

drivers/scsi/qla2xxx/qla_os.c:qla2x00_abort_srb() {
    ...
	if (wait_for_completion_timeout(&comp, ratov_j)) {
		ql_dbg(ql_dbg_taskm, vha, 0xffff,
		    "%s: Abort wait timer (4 * R_A_TOV[%d]) expired\n",
		    __func__, ha->r_a_tov/10);
		ret_cmd =3D true;
	}
    ...
}

Since wait_for_completion_timeout() returns > 0 on successful completion,
is a success treated as a timeout here due to a missing logical NOT (!)?

Because successful completion means the interrupt handler already freed the
srb (sp), will the function then dereference sp->type and call
sp->done(sp, res), resulting in a use-after-free?

Conversely, if a genuine timeout occurs and wait_for_completion_timeout()
returns 0, will it skip this block entirely? Would this leave sp->comp
pointing to the stack-allocated comp, causing stack corruption when the
firmware eventually responds?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D22

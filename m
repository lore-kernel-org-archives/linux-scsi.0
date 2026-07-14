Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C264643D4F5
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 17:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784051128; cv=none; b=UNgD9yp+yqP+0sYqNpfgeqyzubQ365/CoAglX0f5qetFvC4WQA0tqmq6scPayHqnLuusDttwP11g4L+iFEH6WEaRdIL/zrzSH1XSbIsDXm4zuiwn6NeB/3Rm+qWG8Y+2yZX9a98r+DQelDEiUjPVlMmXwzpGzUIe1PHXf5wLFGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784051128; c=relaxed/simple;
	bh=bVxvEWHHtPpmTt5hFB9FFaWnrHDwszX80Q/c0zMius8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IdDwn+RG6skIIhvw6I15PauMnjTm4KwJxo+GpU1eUJhDlUTZDMpNDvg7RMab1zibnor5PnX4XPOA/R00Xqgn/g8k0j3C9ZcDPyT9pTVb5dYlVFu0p2egnZD9R0ZVnT0LxlCZ+Ixtq9qhIQMC8Jtb325vXw37BWyxl3U5sme4O2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjdCMK83; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjdCMK83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12711F000E9;
	Tue, 14 Jul 2026 17:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784051115;
	bh=2wXZtfGDMvP26QUmAK0KJbXw9xZkaQHthz8ftHaz13E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fjdCMK83tQcm+PpFD6MMIhkqXe4HYi+j/ULUABCh1gIaqSeSc753MU7Ic/Zi7Kfeq
	 m20eBcVBRHL6mpNY4xcdxVmwizZriv2W/WClE7kweJRuYp0Z6MEETgTMDo36VbNpno
	 wfkVWpkd0tm9teiUnUQQndqcDEYWqZVsWqUuo1JCpZbYHmHTmEF/AJqDR+TgU0dXK8
	 p2aLTAEMvR9+a/lgG87utAX9sA4pvWUcAOJUE12NP84IA3BZTuIyC0ItKQjG/g38p7
	 j3jinw5yzcR/vipTdTs51fKQ6aQ2kNdc3ambM0d65OdSMcYxXBkP5PazjQFIK5MGPN
	 ZBEgGZUTuASKA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 35/56] scsi: qla2xxx: Update VP control IOCB handling
 for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-36-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-36-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 17:45:14 +0000
Message-Id: <20260714174514.E12711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The completion path for VP control commands drops error statuses f=
rom timeouts and hardware errors, falsely reporting success to the caller.
--

--- Patch [35]: [PATCH v4 35/56] scsi: qla2xxx: Update VP control IOCB hand=
ling for 29xx series ---
commit 77dc435924819ef08c343b24f1c7855d5ea36176
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Update VP control IOCB handling for 29xx series

Update VP control IOCB command and response handling to support the
29xx series adapters, which use the 128-byte vp_ctrl_entry_24xx_ext
layout.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 774ccf6b2adc8..7d2b6d135dc84 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3000,13 +3000,19 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host=
_t *vha, struct req_que *req,
>  }
> =20
>  static void qla_ctrlvp_completed(scsi_qla_host_t *vha, struct req_que *r=
eq,
> -    struct vp_ctrl_entry_24xx *vce)
> +				 void *pkt)
>  {
>  	const char func[] =3D "CTRLVP-IOCB";
> +	/*
> +	 * vp_ctrl_entry_24xx_ext overlays vp_ctrl_entry_24xx for all
> +	 * fields read here (entry_status, comp_status, vp_idx_failed),
> +	 * so the read goes through one struct vp_ctrl_entry_24xx * view.
> +	 */
> +	struct vp_ctrl_entry_24xx *vce =3D pkt;
>  	srb_t *sp;
>  	int rval =3D QLA_SUCCESS;
> =20
> -	sp =3D qla2x00_get_sp_from_handle(vha, func, req, vce);
> +	sp =3D qla2x00_get_sp_from_handle(vha, func, req, pkt);
>  	if (!sp)
>  		return;

[Severity: High]
This is a pre-existing issue, but is the error handling in this function
actually reachable?

In qla24xx_process_response_queue(), any IOCB response with a non-zero
entry_status is intercepted and routed to qla2x00_error_entry() instead of
falling through to the normal completion paths:

	if (((response_t *)pkt)->entry_status !=3D 0) {
		if (qla2x00_error_entry(vha, rsp, (sts_entry_t *)pkt))
			goto process_err;

		((response_t *)pkt)->signature =3D RESPONSE_PROCESSED;
		wmb();
		continue;
	}

Since qla2x00_error_entry() returns 0 for VP_CTRL_IOCB_TYPE, the processing
loop skips the process_err label and bypasses qla_ctrlvp_completed()
entirely. Does this mean the vce->entry_status !=3D 0 check further down in
this function is dead code?

Furthermore, when qla2x00_error_entry() or a timeout path invokes the
completion callback qla_ctrlvp_sp_done(), the callback ignores its res
parameter:

static void qla_ctrlvp_sp_done(srb_t *sp, int res)
{
	if (sp->comp)
		complete(sp->comp);
	/* don't free sp here. Let the caller do the free */
}

Because sp->rc is never updated and remains zero (success), wouldn't
qla24xx_control_vp() erroneously assume the hardware command succeeded even
if it failed?

Could this cause a state desync where the driver and firmware disagree on
whether a virtual port is enabled or disabled?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D35

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793193426;
	b=NHwM9tfjhv7uVHjAqld4hOaT6evMHT50JAHNChllCgD5z4RVnEt9mp8br4AplFvVgmku
	 FWEJPRMl8zFzMI0FU+DsdgCkMfo0P3jc59FRzDMlv3/5+xE07gUO4MkdpzwAh8ysIX5Qr
	 zBF0FgCC/MuEFjEBYK/uNV+tuchFxdl1jle18TORWCowXLEVbqeNu6EL8GIwimy+rKukM
	 /v0pV2sVfBsAMm4bgDnikZcz9ZApMvh6INNAVcewOK32EsAIeWZjGbCMqFIA+sWAKwtA9
	 FNRoTAu7hDbn0vX6AbBgmomiLNDGy8W8jQIMqJ9bqXf3GXDQ/b2XSksIYEhc7X3NXsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793193426;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Kurk9/qYWVL/2+VNRJVl3zQ0Iz3O2AzAzwwGEICR7Fw=;
	b=pcK8fxZtpctBznTyWdX9qGQX8NeuPgvf41Camxisd59B3GyR4W9XLUSE78U24KFs3C/U
	 lXt+UDI35l6WTOZTZ8XHQhgZpwsMMxgT8AgIHIj55AnlqTdLJivILlBkLeNaaDwpKAndV
	 TCfPj2qPyHe1VA778ojQ39jxikcZjo8jSgxrk0oVmPk3HHiTnEplQ2jB1BmcqC9NmZCaf
	 k1KKupE5gjxHe1aqYajPrF82OLrrb4+AY0u0Ug3VrIPues/wb1FkCjPEtW5rUEUpNzqsL
	 qhzLFnZMs/EaUwTvpq8khXmL/PiSXUPGKNpqwgBUAOjQzRkqZgGlLxG7cv+ayMbxxrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IDooV2dd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6388C606A31A
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 13:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IDooV2dd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95AE1F01825;
	Wed, 28 Oct 2026 13:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793193426;
	bh=Kurk9/qYWVL/2+VNRJVl3zQ0Iz3O2AzAzwwGEICR7Fw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IDooV2ddbYAPOo8mcqRsYiTa5LnyuV8THMcBWE0xZID+WBNf87r4NeWipB7v/WEWa
	 IPQgAmNxJQJpZ1Q4lQNuZt7xQKTQd+v5/u+n+lwf/afh372qj7koxKk/deeYO0zLn5
	 zptnfQcX7AyWGsMNqfPfZIE5O5+Q31mtZmQZ+NP+Pfm1QswdSZUt1lH/azq+wJnZ99
	 evdjHGRF0efTHR2abCes75OFrCTAStF/XNt2DOas0wbs2+HJNkWhNh6Q3QPCqrL72Q
	 1g9EuuMFj4H5BSnIvN8Q564JRl3Z3dOLHUTOm7ta9y40It27tXnuNJ4ZGKR6QLXTnb
	 F8+ZDPOajDSWA==
Message-ID: <sashiko-outbox-187901@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Clear power-on UNIT ATTENTION on BIWIN
 devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexey Charkov" <alchark@flipper.net>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261028-biwin-tua-quirk-v1-1-767a12c9b9cc@flipper.net>
References: <20261028-biwin-tua-quirk-v1-1-767a12c9b9cc@flipper.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 13:17:05 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] scsi: ufs: unhandled broken OCS quirk in ufshcd_clear_unit_atten=
tion()
- [Medium] scsi: ufs: core: ufshcd_issue_devman_upiu_cmd() hardcodes lun 0 =
in lrbp
--

commit 02e1f4aa450245801c780ec99fe1072a3f8e77c3
Author: Alexey Charkov <alchark@flipper.net>

scsi: ufs: core: Clear power-on UNIT ATTENTION on BIWIN devices

This patch adds a device quirk for BIWIN UFS devices (models starting with
BWU2A05) to clear pending power-on unit attention conditions across all
logical units after a host reset and restore by issuing a TEST_UNIT_READY
command via the device management slot.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ee643830a57a2..d52275a813fd3 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c

[ ... ]

> @@ -8265,6 +8268,55 @@ static void ufshcd_process_probe_result(struct ufs=
_hba *hba,
>  			  hba->curr_dev_pwr_mode, hba->uic_link_state);
>  }
> =20
> +/**
> + * ufshcd_clear_unit_attention - clear the power-on UNIT ATTENTION of ea=
ch LU
> + * @hba: per adapter instance
> + *
> + * Send a TEST UNIT READY to each logical unit to clear the power-on UNIT
> + * ATTENTION left by a device reset, for devices that keep reporting it =
to
> + * WRITE commands instead. Receiving the UNIT ATTENTION is what clears i=
t, so
> + * only transport failures matter.
> + *
> + * Use the device management slot rather than the logical units' request
> + * queues: those are blocked during error handling, and during a runtime
> + * resume of the device W-LU its runtime suspended consumers cannot take
> + * requests until it has resumed.
> + */
> +static void ufshcd_clear_unit_attention(struct ufs_hba *hba)
> +{
> +	struct utp_upiu_req req_upiu, rsp_upiu;
> +	struct scsi_device *sdev;
> +	int err;
> +
> +	shost_for_each_device(sdev, hba->host) {
> +		if (scsi_is_wlun(sdev->lun))
> +			continue;
> +
> +		req_upiu =3D (struct utp_upiu_req){
> +			.header =3D {
> +				.transaction_code =3D UPIU_TRANSACTION_COMMAND,
> +				.lun =3D ufshcd_scsi_to_upiu_lun(sdev->lun),
> +				.command_set_type =3D UPIU_COMMAND_SET_TYPE_SCSI,
> +			},
> +			.sc.cdb[0] =3D TEST_UNIT_READY,
> +		};
> +
> +		ufshcd_dev_man_lock(hba);
> +		err =3D ufshcd_issue_devman_upiu_cmd(hba, &req_upiu, &rsp_upiu,
> +						   NULL, NULL,
> +						   DEV_CMD_TYPE_SCSI,
> +						   UPIU_QUERY_OPCODE_NOP);

[Severity: Medium]
When ufshcd_clear_unit_attention() sends a DEV_CMD_TYPE_SCSI command to a
non-zero LUN, ufshcd_issue_devman_upiu_cmd() still passes a hardcoded LUN of
0 to ufshcd_setup_dev_cmd():

drivers/ufs/core/ufshcd.c:ufshcd_issue_devman_upiu_cmd() {
	...
	tag =3D scsi_cmd_to_rq(cmd)->tag;

	ufshcd_setup_dev_cmd(hba, cmd, cmd_type, 0, tag);
	...
}

This leaves lrbp->lun set to 0 even though req_upiu.header.lun targets a
non-zero LUN.

If the command times out during error recovery (for example via
ufshcd_err_handler() -> ufshcd_reset_and_restore() ->
ufshcd_host_reset_and_restore() -> ufshcd_clear_unit_attention() when
hba->pm_op_in_progress is false), scmd_eh_abort_handler() invokes
ufshcd_abort() -> ufshcd_mcq_abort() -> ufshcd_try_to_abort_task(), which
uses lrbp->lun to issue UFS_QUERY_TASK and UFS_ABORT_TASK:

drivers/ufs/core/ufshcd.c:ufshcd_try_to_abort_task() {
	...
	for (poll_cnt =3D 100; poll_cnt; poll_cnt--) {
		err =3D ufshcd_issue_tm_cmd(hba, lrbp->lun, tag, UFS_QUERY_TASK,
					  &resp);
	...
}

And ufshcd_clear_cmd() -> ufshcd_mcq_sq_cleanup() also uses lrbp->lun to
build the nexus written to REG_SQCTI:

drivers/ufs/core/ufs-mcq.c:ufshcd_mcq_sq_cleanup() {
	...
	/* SQCTI =3D EXT_IID, IID, LUN, Task Tag */
	nexus =3D lrbp->lun << 8 | task_tag;
	opr_sqd_base =3D mcq_opr_base(hba, OPR_SQD, id);
	writel(nexus, opr_sqd_base + REG_SQCTI);
	...
}

Should ufshcd_issue_devman_upiu_cmd() pass req_upiu->header.lun instead of 0
to ufshcd_setup_dev_cmd() so that task abort and MCQ queue cleanup target t=
he
right LUN?

> +		ufshcd_dev_man_unlock(hba);
> +		if (err) {
> +			dev_warn(hba->dev,
> +				 "TEST UNIT READY to LUN %llu failed: %d\n",
> +				 sdev->lun, err);
> +			scsi_device_put(sdev);
> +			break;
> +		}

[Severity: Medium]
What happens here on host controllers with UFSHCD_QUIRK_BROKEN_OCS_FATAL_ER=
ROR
(such as ufs-exynos)?

When a logical unit has a pending unit attention condition, the device
responds to TEST_UNIT_READY with a Response UPIU having header.response set
to TARGET_FAILURE and header.status set to SAM_STAT_CHECK_CONDITION. On
controllers with UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR, hardware reports
OCS_FATAL_ERROR in the UTRD/CQE whenever the Response UPIU has a non-zero
response or status field.

For normal SCSI commands, ufshcd_transfer_rsp_status() overrides ocs back to
OCS_SUCCESS:

drivers/ufs/core/ufshcd.c:ufshcd_transfer_rsp_status() {
	...
	if (hba->quirks & UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR) {
		if (lrbp->ucd_rsp_ptr->header.response ||
		    lrbp->ucd_rsp_ptr->header.status)
			ocs =3D OCS_SUCCESS;
	}
	...
}

However, ufshcd_issue_devman_upiu_cmd() uses a reserved device management
command (!ufshcd_is_scsi_cmd(cmd)). In ufshcd_compl_one_cqe(), the reserved
command path bypasses ufshcd_transfer_rsp_status() and leaves
lrbp->utr_descriptor_ptr->header.ocs as OCS_FATAL_ERROR, which
ufshcd_issue_dev_cmd() then returns directly:

drivers/ufs/core/ufshcd.c:ufshcd_issue_dev_cmd() {
	...
	rq->timeout =3D timeout;
	sts =3D blk_execute_rq(rq, true);
	if (sts !=3D BLK_STS_OK)
		return blk_status_to_errno(sts);
	return lrbp->utr_descriptor_ptr->header.ocs;
}

Wouldn't this cause ufshcd_clear_unit_attention() to see OCS_FATAL_ERROR on
the first LUN that reports unit attention, log a warning, and break out of
the loop before clearing the remaining LUNs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028-biwin-tua-=
quirk-v1-1-767a12c9b9cc@flipper.net?part=3D1

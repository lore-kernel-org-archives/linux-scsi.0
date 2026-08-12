Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8309A402444
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 21:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786571038; cv=none; b=u157uLggD1a2BtUwTKVqbeFTbG+x12hXfUB1WtUM4cnHhnp7cX+lDXMQGT+H5VHg07GqSZ3+0w6Fbp/9F2bRwiU9Zufn5M0CcnEHS4fnLLDoy8pbUHK/GpSgAKUW/fZIxdZeBuXQWT5dMNks5+3uinkhSChLYxJ01dAeIdYQ3nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786571038; c=relaxed/simple;
	bh=OI1fb0KHPpQwYPavCE9jeO1IVu0CoASpucEV4kUo+T0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fygyR+t00lSUxbCfMEFNT2hOXUIvDuPqeBlZC7/f4LxllHTR9/bfcmPb3/lGIocB58YiRsjcvi42MlHaYFaHqwaP8Akthk3ppkI74Zs2fnCfKn7Uq6IZwJBjJyptEmSvnLBroIv8IjloyHQ/ls66z0C3KLCRWzjeKac3WcfT/Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bdsQJgag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bdsQJgag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE60B1F000E9;
	Wed, 12 Aug 2026 21:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786571037;
	bh=7zAm96+KXvSviNAsWM/uNvqV919/g9vIVvOY0qalkLs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bdsQJgagj5sUpAcP1tJPzD4blZxUWnWAW/LVIsQrGPpGkQK/6/8AYkPYq7ZT6/9dx
	 RfAjKaoDzLXaZNUC4lGMwc6MwZlwbKTg9UsGKI1LcwMaikJIfkfKWEFY0PvcL7+Cw5
	 9LSY1prsFTuR5Wg3jDkJaowzVTIrd0V4NgmNHNz8VvquUyWBPIvbT9sih+2L4ihGow
	 TwA3tOb5P/yZzZis5P1PFs95UYR0ZX12soB+NuwI+6N5COk0Gasm8uays+awNxWwVm
	 TD1XU75AeLcbJUuRjCm7okTJJcfrUYMOD5ENK+uQEAQDS6Q+S/gRededCL6h/3d3sQ
	 pjuEkfuB4aF4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] ufs: core: Fix a race condition triggered by
 ufshcd_eh_timed_out()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <fd054bab859b55a9a8182e54a8e5c901c474c421.1786569828.git.bvanassche@acm.org>
References: <cover.1786569828.git.bvanassche@acm.org>
 <fd054bab859b55a9a8182e54a8e5c901c474c421.1786569828.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 21:43:56 +0000
Message-Id: <20260812214356.DE60B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Force-completing timed-out SCSI commands without aborting the =
hardware transaction causes fatal DMA double-unmaps and tag reuse corruptio=
n.
- [High] Unconditional invocation of `ufshcd_link_recovery()` for any posit=
ive return value erroneously triggers full hardware resets on non-fatal SCS=
I responses.
--

--- Patch [1]: [PATCH v2 1/2] ufs: core: Fix a race condition triggered by =
ufshcd_eh_timed_out() ---
commit dde417683cb3b7c051cd6097ff9874af45826071
Author: Bart Van Assche <bvanassche@acm.org>

ufs: core: Fix a race condition triggered by ufshcd_eh_timed_out()

If a START STOP UNIT command times out, the ufshcd_link_recovery() call
in ufshcd_eh_timed_out() may call scsi_done() for that command via the
force-completion mechanism. This may cause ufshcd_set_dev_pwr_mode() to
return before link recovery has finished. Fix this race condition by
moving the ufshcd_link_recovery() call into ufshcd_set_dev_pwr_mode().

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 69d92387e9d29..63ca6d489be02 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9550,18 +9550,6 @@ static enum scsi_timeout_action ufshcd_eh_timed_ou=
t(struct scsi_cmnd *scmd)
>  		return SCSI_EH_NOT_HANDLED;
>  	}
> =20
> -	/*
> -	 * Handle the timeout directly to prevent a deadlock between
> -	 * ufshcd_set_dev_pwr_mode() and ufshcd_err_handler().
> -	 */
> -	ufshcd_link_recovery(hba);
> -	dev_info(hba->dev, "%s() finished; outstanding_tasks =3D %#lx.\n",
> -		 __func__, hba->outstanding_tasks);
> -
> -	/*
> -	 * ufshcd_link_recovery() may already have completed @scmd, e.g. via
> -	 * the existing MCQ force-completion path.
> -	 */
>  	if (!test_bit(SCMD_STATE_COMPLETE, &scmd->state)) {
>  		if (!hba->mcq_enabled) {
>  			unsigned long flags;

[Severity: Critical]
By removing ufshcd_link_recovery() here, does this allow the software to
complete timed-out SCSI commands without aborting the hardware transaction?

In the subsequent code within ufshcd_eh_timed_out(), the driver unmaps DMA
buffers and calls scsi_done(scmd) to complete the command:

	if (ufshcd_is_scsi_cmd(scmd)) {
		set_host_byte(scmd, DID_REQUEUE);
		ufshcd_release_scsi_cmd(hba, scmd);
	} else {
		set_host_byte(scmd, DID_TIME_OUT);
	}

	scsi_done(scmd);

Since the hardware controller is no longer stopped, won't it continue
executing the command and potentially perform DMA writes to the now-freed
memory buffers?

If the controller completes the command before the caller executes
ufshcd_link_recovery(), this might process a completion for an already freed
tag, causing memory corruption or a use-after-free.

[ ... ]

> @@ -10098,6 +10086,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba=
 *hba,
>  		if (ret > 0) {
>  			if (scsi_sense_valid(&sshdr))
>  				scsi_print_sense_hdr(sdp, NULL, &sshdr);
> +			ufshcd_link_recovery(hba);
>  			ret =3D -EIO;
>  		}
>  	} else {

[Severity: High]
Does this unconditionally execute a full link recovery for any positive ret=
urn
value?

When scsi_execute_cmd() executes the start/stop unit command, it can return=
 a
positive status code if the device rejects the command with a standard SCSI
error (such as SAM_STAT_CHECK_CONDITION).

By executing ufshcd_link_recovery() here for all ret > 0, we seem to be
triggering a full hardware reset on non-fatal SCSI responses instead of
isolating actual timeout codes. Could this lead to unintended host resets
and system latency spikes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1786569828.gi=
t.bvanassche@acm.org?part=3D1

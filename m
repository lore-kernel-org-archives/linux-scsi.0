Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387613264D8
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786560179; cv=none; b=lAQGeRmAmGyi3GuGzktl9p7WO2TsmOGFXFL5exaL8PsQuwykVTTCvIcJa0Ct7AYSVPHLuuoXolIjFC/gKYNaYnciW3ufNff638lKkb6bzfVzQ0Znu8nXgv7ECfnCTM50WUx3YQTa7olyvG+qxwsM5a/EDBDU4df214r5JxI7rXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786560179; c=relaxed/simple;
	bh=hPIv0a3SHCXsNpPgg1ZBypvsT4NwJG6cqoMQCGtd0j0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SAM8dnBzvBVPwELMUS2+yjR9eQ5rh7cBgtG0zM7LeSAPBmDTT7sZHbFligKX8qg61SVTX59OWaBq1zUF483j+eQrRLRS5+iSf5uBe7frnjJCva2JsIQcYdYbXGkG4z9iY9iMkhT8rMzAOF6LFCcmvSQKbal0Dy2an2zhABjDNnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aCIRBCig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aCIRBCig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD92A1F000E9;
	Wed, 12 Aug 2026 18:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786560177;
	bh=doXjLgfp7xKt5bHhsyFf1CV+r7l4ZXxC/xNFlbaMqXo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aCIRBCigm3gSsG0LV3F7SWodNk+2yxxBpSj3Dv8iBVVFLZk7wE8wmiFV3ip6kBmjb
	 0CzHhQeRmJ5LjedzvrzCaHLB0v/BXSm/CPJrvkbWVJoADeGRnSkHoN3dWS65Bh6hJG
	 2umI+bTvIO0GrONXV86rm73RxorsR7fNxS/vr9ZquM5VNACJ5DIJjVB1s2sMSny9If
	 /kQuY7Vp30ZW2OqzwiNVufKCH+/jXKZCCuoinkC5aGLDuv/zsizQQWZJG6ye7l6Qc7
	 1RLCbfx5D4b79OOQGJVe/mjt0jN0uS9kK4BuVMvAQbDB3wioAeUE9rbN3a6y9jr/pn
	 2FFgmxDH1edhQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] ufs: core: Fix a race condition triggered by
 ufshcd_eh_timed_out()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <fc388a5ff11decf35246780f19ccfce2fda35f16.1786558726.git.bvanassche@acm.org>
References: <cover.1786558726.git.bvanassche@acm.org>
 <fc388a5ff11decf35246780f19ccfce2fda35f16.1786558726.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 18:42:57 +0000
Message-Id: <20260812184257.BD92A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Race condition with hardware completions leading to double-rel=
ease of DMA and PM resources.
- [High] Unconditional hardware link recovery for non-timeout START STOP UN=
IT failures.
--

--- Patch [2]: [PATCH 2/3] ufs: core: Fix a race condition triggered by ufs=
hcd_eh_timed_out() ---
commit 5124f897a6830560d1ea1c644750541f1ef1fc0b
Author: Bart Van Assche <bvanassche@acm.org>

ufs: core: Fix a race condition triggered by ufshcd_eh_timed_out()

This patch moves ufshcd_link_recovery() out of the timeout handler and into
ufshcd_set_dev_pwr_mode() to prevent deadlocks. It also removes the checking
of SCMD_STATE_COMPLETE before command cleanup in the timeout handler.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 6b94f0d91790c..cdfcd3d4c4c97 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9550,34 +9550,18 @@ static enum scsi_timeout_action ufshcd_eh_timed_o=
ut(struct scsi_cmnd *scmd)
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
> -	if (!test_bit(SCMD_STATE_COMPLETE, &scmd->state)) {
> -		if (!hba->mcq_enabled) {
> -			unsigned long flags;
> -			struct request *rq =3D scsi_cmd_to_rq(scmd);
> +	if (!hba->mcq_enabled) {
> +		struct request *rq =3D scsi_cmd_to_rq(scmd);
> =20
> -			spin_lock_irqsave(&hba->outstanding_lock, flags);
> +		scoped_guard(spinlock_irqsave, &hba->outstanding_lock)
>  			__clear_bit(rq->tag, &hba->outstanding_reqs);
> -			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
> -		}
> -
> -		set_host_byte(scmd, DID_TIME_OUT);
> -		if (ufshcd_is_scsi_cmd(scmd))
> -			ufshcd_release_scsi_cmd(hba, scmd);
> -		scsi_done(scmd);
>  	}
> =20
> +	set_host_byte(scmd, DID_TIME_OUT);
> +	if (ufshcd_is_scsi_cmd(scmd))
> +		ufshcd_release_scsi_cmd(hba, scmd);

[Severity: Critical]
Since the synchronous ufshcd_link_recovery() call has been removed from this
handler, the controller is still running and could complete this command
concurrently.

By removing the check for SCMD_STATE_COMPLETE, doesn't this create a race
where both the timeout handler and the hardware completion interrupt
(via ufshcd_compl_one_cqe()) might call ufshcd_release_scsi_cmd() on the
same command simultaneously?

This could lead to double-unmapping DMA regions and decrementing PM clock
gating refcounts twice.

> +	scsi_done(scmd);
> +
>  	return SCSI_EH_DONE;
>  }
> =20
> @@ -10091,9 +10075,13 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hb=
a *hba,
>  		sdev_printk(KERN_WARNING, sdp,
>  			    "START_STOP failed for power mode: %d, result %x\n",
>  			    pwr_mode, ret);
> +
> +		ufshcd_link_recovery(hba);

[Severity: High]
Does this unconditionally trigger a full hardware link recovery for any
non-zero return value from scsi_execute_cmd()?

The scsi_execute_cmd() call can fail for reasons other than timeouts,
such as memory pressure returning -ENOMEM or normal device check conditions.
Calling ufshcd_link_recovery() in these scenarios seems like it would cause
severe performance degradation and disruptive device resets for routine err=
ors.

Should this check the specific failure reason, like DID_TIME_OUT, before
initiating recovery?

> +
>  		if (ret > 0) {
>  			if (scsi_sense_valid(&sshdr))
>  				scsi_print_sense_hdr(sdp, NULL, &sshdr);
> +
>  			ret =3D -EIO;
>  		}
>  	} else {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1786558726.gi=
t.bvanassche@acm.org?part=3D2

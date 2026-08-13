Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CF83F1AB8
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2026 22:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660203; cv=none; b=chAXiBCgsiIJvWnLx8ldZs50/qHc3suA3P9j3tNk/qu/OUMlocCDGDhG7EkHIKYPAj+//U/H6sAbLTz7d2lMuzGb5GhoZawfDq+kRJ6BBMgruM91x0SSwhuTHVQZqFOZx7/4vfAvDDY+i8j3bKgysDp20ljmBQ07fIMKVtQ46IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660203; c=relaxed/simple;
	bh=xRnRyCuBTcc2nR056bYQmULTYSc/l8hw7SLcbzJt/Wk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QjKdFbuxT/pCG5uqc0SlL9lewZZK6gR7toaJy1qgRMeVZchuOmSCHGzpHHGrZ7VzsbcoeSN9FukujYpEkwplF8UR1DLs7BtpZ+irJnLgBfApHyfXre9YW8jCngyiR7OmRrN5b30UoiCLKJ587XcO1sD5Tq0QzqXaPpD7gVRRn6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hMAN6Ig9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMAN6Ig9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1581F00A3E;
	Thu, 13 Aug 2026 22:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786660194;
	bh=fVt9A4V2+ncc5e5YSSLVy1qklF5kQLpZmRIofA78btA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hMAN6Ig9xC+GccRYBLrUGBIKANU3a2J0t6V/oplHImUGe8wYSmkoOPNIxr6TeCSD/
	 yZG6otJgcFChf9SUzvGkrk3ZbTDtkoOJpAqJf54ml0aVvi8H7zVPlC9GUXrCFhqXW2
	 00Ru5KmBmSZqeuMpaJtyhd9gx/g01UBfLG1dSgAotlma19a8DoNlXglhuSL7HoGOz2
	 UtrryRpjrcBo/bRh5O2J73iAl3VTvX/UTTqvskkM2LfKz7WCiIzpBrHOLuWLoDXt6R
	 sLH7SG8mZzZy8FQGUofT39IDVM9QJ+u2l+2HgAzyn8QfG4e5/I8Ia21l2dfHRcdefE
	 lXSvcAL4Yf6Sg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 06/12] scsi: ufs: core: Add helpers to pause and
 resume command processing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Can Guo" <can.guo@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260321031021.1722459-7-can.guo@oss.qualcomm.com>
References: <20260321031021.1722459-7-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 22:29:49 +0000
Message-Id: <20260813222950.8C1581F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] AB-BA deadlock between block layer tagset quiesce and clk_scaling_=
lock during concurrent device management commands.
- [High] Missing ufshcd_hold() allows concurrent UIC commands and Hibern8 t=
ransitions from the clock gating worker.
- [High] Incomplete quiescence allows BSG and TMF commands to disrupt hardw=
are state during paused operations.
--

--- Patch [6]: [PATCH v4 06/12] scsi: ufs: core: Add helpers to pause and r=
esume command processing ---
commit fb401ec0f2366dbaa8f0c8881fcde7ff615bb4d2
Author: Can Guo <can.guo@oss.qualcomm.com>

scsi: ufs: core: Add helpers to pause and resume command processing

In preparation for supporting TX Equalization refreshing, introduce helper
functions to safely pause and resume command processing.
ufshcd_pause_command_processing() ensures the host is in a quiescent state,
and ufshcd_resume_command_processing() restores it.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index b2050281f3f89..71bda9dd60729 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
[ ... ]
> @@ -1364,6 +1364,48 @@ static int ufshcd_wait_for_pending_cmds(struct ufs=
_hba *hba,
>  	return ret;
>  }
> =20
> +/**
> + * ufshcd_pause_command_processing - Pause command processing
> + * @hba: per-adapter instance
> + * @timeout_us: timeout in microseconds to wait for pending commands to =
finish
> + *
> + * This function stops new command submissions and waits for existing co=
mmands
> + * to complete.
> + *
> + * Return: 0 on success, %-EBUSY if commands did not finish within @time=
out_us.
> + * On failure, all acquired locks are released and the tagset is unquies=
ced.
> + */
> +int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 timeout_us)
> +{
> +	int ret =3D 0;
> +
> +	mutex_lock(&hba->host->scan_mutex);
> +	blk_mq_quiesce_tagset(&hba->host->tag_set);

[Severity: High]
Does quiescing only the SCSI host tagset leave the independent Task Managem=
ent
(hba->tmf_queue) and BSG (hba->bsg_queue) queues active?

A userspace application could concurrently issue operations via the BSG dev=
ice
node, bypassing the scan_mutex and clk_scaling_lock, and write directly to
hardware doorbell registers (REG_UTP_TASK_REQ_DOOR_BELL and REG_UIC_COMMAND)
while the controller is undergoing maintenance.

> +	down_write(&hba->clk_scaling_lock);

[Severity: High]
Does quiescing the tagset before waiting on clk_scaling_lock create an AB-BA
deadlock with concurrent device management commands?

If a concurrent device management operation calls ufshcd_dev_man_lock() and
acquires down_read(&hba->clk_scaling_lock), it then submits a request to the
pseudo_sdev via blk_execute_rq().=20

Because the pseudo_sdev shares the SCSI host tagset which was just quiesced
above, the request is queued but never dispatched. Since it is never
dispatched, the block layer timeout timer never starts. The management
operation waits infinitely in wait_for_completion() holding the
clk_scaling_lock, while this pause function waits infinitely here for the
same lock.

> +
> +	if (ufshcd_wait_for_pending_cmds(hba, timeout_us)) {
> +		ret =3D -EBUSY;
> +		up_write(&hba->clk_scaling_lock);
> +		blk_mq_unquiesce_tagset(&hba->host->tag_set);
> +		mutex_unlock(&hba->host->scan_mutex);
> +	}
> +
> +	return ret;

[Severity: High]
If this function successfully returns without bumping the PM usage counter
(e.g., via ufshcd_hold()), couldn't the asynchronous ufshcd_gate_work fire?

Once pending SCSI commands complete, the queue becomes idle and active_reqs
drops to zero. This allows the clock gating worker to put the link into
Hibern8 mode and disable clocks, which could disrupt the caller of this pau=
se
function if it attempts low-level PHY operations assuming the link is fully
active.

> +}
> +
> +/**
> + * ufshcd_resume_command_processing - Resume command processing
> + * @hba: per-adapter instance
> + *
> + * This function resumes command submissions.
> + */
> +void ufshcd_resume_command_processing(struct ufs_hba *hba)
> +{
> +	up_write(&hba->clk_scaling_lock);
> +	blk_mq_unquiesce_tagset(&hba->host->tag_set);
> +	mutex_unlock(&hba->host->scan_mutex);

[Severity: High]
If ufshcd_hold() is added to ufshcd_pause_command_processing(), would a
matching ufshcd_release() be needed here to restore normal clock gating?

> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260321031021.1722=
459-1-can.guo@oss.qualcomm.com?part=3D6

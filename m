Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AE237107E
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 18:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917618; cv=none; b=fK/Iq0Uj0dI9JEJ3Znad3yiYEDYb815P3HKqzKzL+QHUeqWXVaj+0DTkCiDcByioE9k5wdx5jdCnA44qz2MJOnLzH3XJxYRqCeYI0Bgg0L0VHNiu7wxevhS7lcIhClwNch+kR3btt9yvbdw/0h1XqRQ/nP2K/NG/bSl6Kj0Nsqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917618; c=relaxed/simple;
	bh=Jrw9WlIn3gDDZlJwyOrRgDLOPbzbSqXNin/GUE4MCLk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FNYehPMfcQ//RiNjfOgIPvlFnBRZIBEvuMZJ1vKZWGPwYXWlTRis0ZYQi7TQqnG9hY/bRn9eVCDWOTG1ZLt54WqUKu1MhqkGK4dInl9DJ6mrILLsqlcFOgiRTS+PcMawO11vp8+13AA9WazSVEBPo0zoBd9FuzI220n0RYlj2Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Et7QK+uh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Et7QK+uh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111401F000E9;
	Fri, 24 Jul 2026 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784917614;
	bh=dwxIn1b+tD8acIbW04oJlMhOauFcVm04YDF8PfhEQHI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Et7QK+uhshHHNDd2NpqAngy/EUvxdz/g9C83eZX/+wbCFvCRW6qcMzAV6kogCpWR9
	 MK9jd9/sVjh6qIkfRMrOPcrO6goqxjfF7J0jvdvsRDT6LtI0q3UaGFLYC75Ynqz8Jf
	 BfokFKxI3R/yJs8gLgqTBKpMAQkNL6/gT8qz+j2zC4SQOhwYyLiLJJOc1ZDjqObRhN
	 Xz8HMbIcGEGII+y4Io7GIh2Suo5gmDHuxwbZenVCzyDv28Ic/xGs3pJqYSgwn4N6Yo
	 lSponIeaBqA33jNadCnyKJ4rDp83NCcXbP0Y1cLMldOMpKmLyoKOPpsgeFNSK1N4qi
	 gpUWDe7asUQ3A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 07/13] scsi: fnic: Route completions and resets by
 initiator role
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724174811.5118-8-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
 <20260724174811.5118-8-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 18:26:53 +0000
Message-Id: <20260724182654.111401F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [High] Missing cleanup for NVMe initiator resources in fnic_probe error p=
ath.
- [Medium] The active_fw_reqs atomic counter will underflow for NVMe I/O op=
erations.
- [Medium] The active_ios atomic counter will underflow when NVMe ITMF (abo=
rt) completions are received.
- [Low] nvfnic_cleanup_all_nvme_ios is redundantly called for every pending=
 descriptor during WQ cleanup.
- [Low] The variables lun_queue_depth and io_timeout_retry are fetched from=
 the firmware config but are never used.

Pre-existing issues:
- [High] fnic_cleanup_io() calls schedule_timeout() from a hardirq context.
--

--- Patch [7]: [PATCH v6 07/13] scsi: fnic: Route completions and resets by=
 initiator role ---
commit f5bb58906d74d7095d6b139507d49072e46f3946
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Route completions and resets by initiator role

This patch dispatches FCPIO command, response, and ITMF completions to the
FCP or NVMe handlers based on the configured role. It reads the NVMe queue
depth and timeout retry fields from the firmware config and performs NVMe
I/O cleanup on firmware reset.

> diff --git a/drivers/scsi/fnic/fnic_res.c b/drivers/scsi/fnic/fnic_res.c
> --- a/drivers/scsi/fnic/fnic_res.c
> +++ b/drivers/scsi/fnic/fnic_res.c
> @@ -57,6 +57,8 @@ int fnic_get_vnic_config(struct fnic *fnic)
>  	GET_CONFIG(port_down_io_retries);
>  	GET_CONFIG(luns_per_tgt);
>  	GET_CONFIG(intr_mode);
> +	GET_CONFIG(lun_queue_depth);
> +	GET_CONFIG(io_timeout_retry);

[Severity: Low]
Are these variables used anywhere in the driver?

They are fetched from the firmware config and stored, but do not appear to =
be
read or used anywhere else.

>  	GET_CONFIG(wq_copy_count);
> =20
>  	role =3D c->flags & FNIC_ROLE_CONFIG_MASK;

> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c

[ ... ]

> @@ -734,6 +735,8 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fn=
ic *fnic,
>  	/* Clean up all outstanding io requests */
>  	if (IS_FNIC_FCP_INITIATOR(fnic))
>  		fnic_cleanup_io(fnic, SCSI_NO_TAG);

[Severity: High]
This is a pre-existing issue, but does fnic_cleanup_io() sleep in a hardirq
context?

When a firmware reset completes, the hardware raises an interrupt on the co=
py
work queue, which is serviced by the hardirq handler fnic_isr_msix_wq_copy(=
).

The call chain executes fnic_wq_copy_cmpl_handler() -> vnic_cq_copy_service=
()
-> fnic_fcpio_cmpl_handler() -> fnic_fcpio_fw_reset_cmpl_handler().

For FCP initiators, this unconditionally calls fnic_cleanup_io(), which
enters a while loop and calls schedule_timeout(msecs_to_jiffies(100)).

Can calling a sleeping function from a hardirq context trigger a scheduling
while atomic panic?

> +	else if (IS_FNIC_NVME_INITIATOR(fnic))
> +		nvfnic_cleanup_all_nvme_ios(fnic);
> =20
>  	atomic64_set(&fnic->fnic_stats.fw_stats.active_fw_reqs, 0);
>  	atomic64_set(&fnic->fnic_stats.io_stats.active_ios, 0);

[ ... ]

> @@ -1443,6 +1446,7 @@ static int fnic_fcpio_cmpl_handler(struct vnic_dev =
*vdev,
>  	case FCPIO_FLOGI_REG_CMPL: /* fw completed flogi_reg */
>  	case FCPIO_FLOGI_FIP_REG_CMPL: /* fw completed flogi_fip_reg */
>  	case FCPIO_RESET_CMPL: /* fw completed reset */
> +	case FCPIO_NVME_ERSP_HW_CMPL: /* fw completed NVMe ERSP */
>  		atomic64_dec(&fnic->fnic_stats.fw_stats.active_fw_reqs);
>  		break;

[Severity: Medium]
Will the active_fw_reqs atomic counter underflow for NVMe I/O operations?

The FCPIO_NVME_ERSP_HW_CMPL and fast FCPIO_ICMND_CMPL NVMe completion paths
in fnic_fcpio_cmpl_handler() decrement the active_fw_reqs atomic counter.

However, looking at the NVMe submission path in nvfnic_queue_wq_nvme_copy_d=
esc(),
it does not appear to increment this counter (unlike the FCP submission pat=
h).

Does this imbalance cause the counter to underflow, corrupting the
driver statistics?

>  	default:

[ ... ]

> @@ -1457,11 +1461,22 @@ static int fnic_fcpio_cmpl_handler(struct vnic_de=
v *vdev,
>  		break;
> =20
>  	case FCPIO_ICMND_CMPL: /* fw completed a command */
> -		fnic_fcpio_icmnd_cmpl_handler(fnic, cq_index, desc);
> +		if (IS_FNIC_FCP_INITIATOR(fnic))
> +			fnic_fcpio_icmnd_cmpl_handler(fnic, cq_index, desc);
> +		else if (IS_FNIC_NVME_INITIATOR(fnic))
> +			nvfnic_fcpio_nvme_fast_cmpl_handler(fnic, desc);
> +		break;
> +
> +	case FCPIO_NVME_ERSP_HW_CMPL: /* fw completed NVMe ERSP */
> +		if (IS_FNIC_NVME_INITIATOR(fnic))
> +			nvfnic_fcpio_ersp_cmpl_handler(fnic, desc, 1);
>  		break;
> =20
>  	case FCPIO_ITMF_CMPL: /* fw completed itmf (abort cmd, lun reset)*/
> -		fnic_fcpio_itmf_cmpl_handler(fnic, cq_index, desc);
> +		if (IS_FNIC_FCP_INITIATOR(fnic))
> +			fnic_fcpio_itmf_cmpl_handler(fnic, cq_index, desc);
> +		else if (IS_FNIC_NVME_INITIATOR(fnic))
> +			nvfnic_fcpio_nvme_itmf_cmpl_handler(fnic, desc);

[Severity: Medium]
Does the active_ios atomic counter underflow when NVMe ITMF (abort)
completions are received?

This patch routes FCPIO_ITMF_CMPL completions to
nvfnic_fcpio_nvme_itmf_cmpl_handler() for NVMe initiators. This handler
decrements the active_ios atomic counter.

However, active_ios does not seem to be incremented during NVMe I/O submiss=
ion
in nvfnic_queuecommand().

Will this imbalance cause the active_ios counter to underflow when an ITMF
completion is received?

>  		break;
> =20
>  	case FCPIO_FLOGI_REG_CMPL: /* fw completed flogi_reg */

[ ... ]

> @@ -1650,6 +1665,15 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_c=
opy *wq,
>  	unsigned long start_time =3D 0;
>  	uint16_t hwq;
> =20
> +	/*
> +	 * Clean up outstanding NVMe requests if firmware reset did not
> +	 * complete them before WQ copy cleanup.
> +	 */
> +	if (IS_FNIC_NVME_INITIATOR(fnic)) {
> +		nvfnic_cleanup_all_nvme_ios(fnic);
> +		return;
> +	}

[Severity: Low]
Is nvfnic_cleanup_all_nvme_ios() redundantly called for every pending
descriptor during work queue cleanup?

vnic_wq_copy_clean() iterates over all pending descriptors in the work queue
and calls fnic_wq_copy_cleanup_handler() for each one sequentially.

If the role is an NVMe initiator, fnic_wq_copy_cleanup_handler() immediately
calls nvfnic_cleanup_all_nvme_ios(fnic). This function locks the driver and
iterates over the entire nvfnic_tag_map sbitmap to clean up all IOs.

Will a full global cleanup run redundantly N times (where N is the number of
pending descriptors), causing an inefficient operation?

>  	/* get the tag reference */
>  	fcpio_tag_id_dec(&desc->hdr.tag, &id);


Looking at the error handling for fnic_probe() in drivers/scsi/fnic/fnic_ma=
in.c:

> err_out_free_stats_debugfs:
> 	fnic_stats_debugfs_remove(fnic);
> 	fnic_free_ioreq_tables_mq(fnic);
> 	if (IS_FNIC_FCP_INITIATOR(fnic))
> 		scsi_remove_host(fnic->host);
> err_out_nvme_drv_init:
> err_out_scsi_drv_init:
> 	fnic_free_intr(fnic);

[Severity: High]
Does this error path miss cleanup for NVMe initiator resources?

If fnic_stats_debugfs_init() fails in fnic_probe(), the code jumps to
err_out_free_stats_debugfs. For an NVMe initiator, the error path skips FCP
cleanup and falls through to err_out_nvme_drv_init, which merely calls
fnic_free_intr(fnic).

It appears to entirely fail to unregister the NVMe local port (e.g., via
nvme_fc_unregister_localport), and leaks fnic->nvfnic_tag_map and
fnic->io_req_pool.

Because the NVMe-FC midlayer retains the nv_lport pointer, could subsequent
accesses to this unregistered local port cause a use-after-free or system
crash when the fnic structure is ultimately freed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724174811.5118=
-1-kartilak@cisco.com?part=3D7

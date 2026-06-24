Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C9D5478D
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 05:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782278140; cv=none; b=MYRN9sS5SUZ8omyk6/T0uD3OfJx2NR65QbL0mA2g7i7mO308nyv99iseJ7sCirJ/eUdHVkYHSNrn9ou3KcalL81Jl6VppwGZpPnYilEwBAekspBeVnmUA/mXWLgjPIfqw1D3bhPdr7jVQqCUXtPIJ2ZR9EF554WyfaNmMvXtl94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782278140; c=relaxed/simple;
	bh=8JjrUODs5GfRovP7jc5jIZ4WqJEh2kMHThInF2i2z9M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S7ZvqSeUzn6HYC3LaDbG75xoh/M2qwx2hiVg5aZZFGyOcEzmQQKINJMOfJJhb++mYRs1Nx6UH11PpTFVawHE/mC9XB9BBLJcZODjQ2JgjPgLmToRr5HHeHv3gq/DUXVljvCrTJcVs4dkeOFtVrPuzASHSrlSQhvXpzPO41PxSYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kxIRq3vY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kxIRq3vY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293A51F000E9;
	Wed, 24 Jun 2026 05:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782278139;
	bh=kSWlX+vgcuMzR3mTuGwMxBZDEmEaIeG2MdxlVwXGK24=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kxIRq3vYHelrMW7Y24Hun8QPIRzerztb5a6DfnJwwsRvpIcXXPFnNzP9JCnhFpdQc
	 cM7GDX7lqArl1EHQfO2mALivpQx1D3/cuzbooJ5RMnLsvkQ3Chu8ujqaxoFC6ftmD4
	 m2Y+19bbjXhpaVR+1+q56F0FhjQHwYnhYcRNPgLvlSNxca41pZzmQGhakjo5em27f7
	 c8oSAQHjteLkz3eZe41N4BNadab9Hvw80PR3586+zG1gxurhgdhqcoxGfdYWE2LNQ5
	 M71HdOtUV5ekfiWcPqzDY6+Bs9stQNjJQwFv6awGoVLpT13L0SK6vjDA2cF8/c6hp0
	 ji3sSdW8zDJVA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 11/13] scsi: fnic: Track NVMe transport statistics
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260624044334.3079-12-kartilak@cisco.com>
References: <20260624044334.3079-1-kartilak@cisco.com>
 <20260624044334.3079-12-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 05:15:38 +0000
Message-Id: <20260624051539.293A51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [Medium] Concurrent completions can underflow `io_cmpl_skip`, permanently=
 breaking `io_completions` counting
- [Medium] Unlocked read-modify-write race corrupting max statistics counte=
rs
- [Medium] The `active_fw_reqs` gauge is incremented but never decremented =
in NVMe completion paths
- [Low] Several newly added NVMe wait-queue statistics counters are dead co=
de and never updated

Pre-existing issues:
- [High] Use-After-Free accessing IO request memory after hardware submissi=
on
- [High] Use-After-Free due to non-sync timer_delete() on NVMe LS requests
--

commit 4e8ddd73c76a57b49825d3889a5531eb4520f10a
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Track NVMe transport statistics

Add counters for NVMe requests, responses, LS handling, aborts, and
wait-queue activity.

Link: https://lore.kernel.org/oe-kbuild-all/202605280619.pmobiDWp-lkp@intel=
.com/
Link: https://lore.kernel.org/oe-kbuild-all/202605280519.Jd4fmgAZ-lkp@intel=
.com/

> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
> index c4de6606c0b2f..e322dd4dcb787 100644
> --- a/drivers/scsi/fnic/fnic_nvme.c
> +++ b/drivers/scsi/fnic/fnic_nvme.c
> @@ -71,6 +71,61 @@ static void nvfnic_update_io_bytes(struct fnic *fnic,
>  		fnic->fcp_output_bytes +=3D io_req->fcp_req->transferred_length;
>  }
> =20
> +static void nvfnic_update_io_stats(struct fnic *fnic, u8 opcode)
> +{
[ ... ]
> +static void nvfnic_update_cmpl_stats(struct fnic *fnic,
> +				     struct fnic_io_req *io_req)
> +{
> +	struct io_path_stats *io_stats =3D &fnic->fnic_stats.io_stats;
> +	atomic64_t *duration_stat;
> +	unsigned long io_duration_time;
> +
> +	atomic64_dec(&io_stats->active_ios);
> +	if (atomic64_read(&fnic->io_cmpl_skip))
> +		atomic64_dec(&fnic->io_cmpl_skip);
> +	else
> +		atomic64_inc(&io_stats->io_completions);

[Severity: Medium]
Could concurrent completions underflow io_cmpl_skip?

If multiple threads process completions concurrently in
nvfnic_update_cmpl_stats(), they can both read a positive value and
decrement the counter, causing it to fall below zero.

Because atomic64_read() evaluates to true for negative values, all
subsequent completions would continue to decrement io_cmpl_skip indefinitel=
y.

Will io_completions ever be incremented again if this happens?

[ ... ]
> @@ -198,6 +255,11 @@ inline int nvfnic_queue_wq_nvme_copy_desc(struct fni=
c *fnic,
>  					tport->max_payload_size, tport->r_a_tov,
>  					tport->e_d_tov);
> =20
> +	atomic64_inc(&fnic->fnic_stats.fw_stats.active_fw_reqs);

[Severity: Medium]
Does active_fw_reqs ever get decremented?

This gauge is incremented here in nvfnic_queue_wq_nvme_copy_desc() and
also in nvfnic_queue_abort_io_req(), but there do not appear to be any
corresponding atomic64_dec() calls added to the NVMe completion handlers.

If it is never decremented when requests complete, will it act as a
monotonically increasing counter rather than a gauge of in-flight requests?

> +	if (atomic64_read(&fnic->fnic_stats.fw_stats.active_fw_reqs) >
> +	    atomic64_read(&fnic->fnic_stats.fw_stats.max_fw_reqs))
> +		atomic64_set(&fnic->fnic_stats.fw_stats.max_fw_reqs,
> +		     atomic64_read(&fnic->fnic_stats.fw_stats.active_fw_reqs));

[Severity: Medium]
Can this read-modify-write pattern corrupt the maximum statistic?

If active_fw_reqs drops between the first conditional check and the second
atomic64_read() inside atomic64_set(), max_fw_reqs could be set to a
lower value than the one that triggered the condition.

Could this cause the maximum statistic to shrink over time under high
concurrency?

> =20
>  	spin_unlock_irqrestore(&fnic->wq_copy_lock[idx], intr_flags);
>  	return 0;
[ ... ]
> @@ -296,6 +368,13 @@ int nvfnic_queuecommand(struct fnic_io_req *io_req)
>  			   (((u64)io_req->cmd_flags << 32) | io_req->cmd_state));
>  		return ret;
>  	}
> +
> +	atomic64_inc(&fnic_stats->io_stats.active_ios);
> +	atomic64_inc(&fnic_stats->io_stats.num_ios);
> +	if (atomic64_read(&fnic_stats->io_stats.active_ios) >
> +	    atomic64_read(&fnic_stats->io_stats.max_active_ios))
> +		atomic64_set(&fnic_stats->io_stats.max_active_ios,
> +		     atomic64_read(&fnic_stats->io_stats.active_ios));
>  	io_req->cmd_flags |=3D FNIC_IO_ISSUED;
>   out:
>  	lba =3D (char *)&cmdiu->sqe.rw.slba;

[Severity: High]
This isn't a bug introduced by this patch, but is there a use-after-free
risk here?

In nvfnic_queuecommand(), the IO request is submitted to the hardware via
nvfnic_queue_wq_nvme_copy_desc(). Once the doorbell is written, the hardware
can execute the NVMe command and post a completion immediately.

If the thread executing nvfnic_queuecommand() is preempted after submitting
the request, the completion handler could process the completion and free
the fcp_req memory. When the preempted thread resumes, it writes to
io_req->cmd_flags and reads from cmdiu->sqe.rw.slba:

    io_req->cmd_flags |=3D FNIC_IO_ISSUED;
 out:
    lba =3D (char *)&cmdiu->sqe.rw.slba;

Should all local state modifications and tracing be performed before the
hardware submission?

[ ... ]
> @@ -1231,6 +1365,7 @@ void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
>  	}
> =20
>  	nvfnic_ls_req->state =3D FNIC_LS_REQ_CMD_COMPLETE;
> +	atomic64_inc(&fnic_stats->nvme_stats.nvme_ls_responses);
> =20
>  	list_del_init(&nvfnic_ls_req->list);
>  	lsreq->private =3D NULL;

[Severity: High]
This is a pre-existing issue, but does the timer cancellation create a
use-after-free risk in nvfnic_ls_rsp_recv()?

When timer_delete() is called without sync on nvfnic_ls_req->ls_req_timer:

    timer_delete(&nvfnic_ls_req->ls_req_timer);
    if (status =3D=3D 0) {
        ...
    spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
    lsreq->done(lsreq, status);

The timer callback nvfnic_ls_req_timeout() might be executing concurrently
on another CPU. After the lock is dropped and lsreq->done() is called, the
NVMe FC transport frees the lsreq structure.=20

If the concurrent timer callback resumes, it will dereference=20
nvfnic_ls_req->fnic.

Is timer_delete_sync() required here?

[ ... ]
> @@ -1700,6 +1857,15 @@ void nvfnic_fcpio_abort(struct nvme_fc_local_port =
*lport,
>  		FNIC_NVME_DBG(KERN_INFO, fnic,
>  			      "cmd tag freed or not issued:0x%x sn:0x%08x\n",
>  			      io_req->tag, be32_to_cpu(cmd_iu->csn));
> +		num_ios_waitq =3D
> +		    atomic64_read(&fnic_stats->io_stats.nvme_num_ios_in_waitq);
> +		waitq_2sec =3D
> +		    atomic64_read(&fnic_stats->io_stats.nvme_ios_in_waitq_3000_msec);
> +		waitq_max_time =3D
> +		    atomic64_read(&fnic_stats->io_stats.nvme_ios_in_waitq_max_time);

[Severity: Low]
Are these wait-queue counters actually updated anywhere?

The counters like nvme_ios_in_waitq_3000_msec and
nvme_ios_in_waitq_max_time are read and logged here, but there does not
appear to be any logic in the patch to increment them or measure the wait
queue duration.

Will these counters perpetually read as zero?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624044334.3079=
-1-kartilak@cisco.com?part=3D11

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4812E738D
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 18:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917863; cv=none; b=OzHe3c88P7af8OK1eUkunfURqVV2fC7WRiGiQeOxf7AOyGejZU+jSB98EmQzbIvaJG0dDOSWP+Q8vJ4Je8PnHVxXLFnLkIC5OjBSxtmCe2HKs84yfxsLmWRZu2fWEDC1U4xLB772k4Yn7nil+Ib1AUcuyQnX/XKNUAJAbjL1rdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917863; c=relaxed/simple;
	bh=hfxWbPcKrVRRXOXkHBwTDRzW7f0+kUR+8hl4Daaur+E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S6yU12r+08ezQQbr6E+HuMgMjn4YklhIHXf+/QHZjhJ+7fw/BsyQPU3suTUliJcPtbVz1iljDx7rXYrYgLjypKL8e/MDWUK+uVXW+e6BVpqllPIQoOF71Nq0F4y7/0Ukds+qy1nusMVPyfUsG9icHdc5rgrC2HnCZL/4/ZDevxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aEp2mdCv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aEp2mdCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DF31F000E9;
	Fri, 24 Jul 2026 18:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784917862;
	bh=Ax0CFGpvphWugZ1GCCIRmLWAaXCzhyowzfuLCkdYjrw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aEp2mdCvuAqU/OA6+Hpw450ih0aTt8F9Bifi/DvKQg+BEba77lV3ai8iw/pQXtXS1
	 26qhfFQUYxJr52JqortRXdH+U1VzbXFMsUxTEHjsq4/f4keYQq79dxJEd/vgzZMgEP
	 kD0LJUjht3C5VHDXqOZatRQGGt8Sq4LLlAiCRA5IVCXAbLzeu8IS5U+jzFJJ0N4Gzk
	 95oF9pBh15JTpgYnag/mO/SZ1+fAAtW6sEeITndjzVdy+oEBbiezycbDhFnVPQfY/7
	 iQfDVyJRWDTEmogImTWkreEutyWfhK5qpsbsvAeDMZMFyVDY+hkBJ5yeQpSszznW4n
	 ch+qbRn9US/iQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 11/13] scsi: fnic: Track NVMe transport statistics
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724174811.5118-12-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
 <20260724174811.5118-12-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 18:31:02 +0000
Message-Id: <20260724183102.79DF31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Wait queue timeout and NVMe response metrics are declared and re=
ad, but never populated.
--

--- Patch [11]: [PATCH v6 11/13] scsi: fnic: Track NVMe transport statistic=
s ---
commit 9923585e497ab09ae056c5f083aec96413fc2a32
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Track NVMe transport statistics

This commit adds counters for NVMe requests, responses, LS handling, aborts,
and wait-queue activity. It also updates NVMe I/O, completion, LS response,
LS abort, and abort paths to maintain the new counters.

Closes: https://lore.kernel.org/oe-kbuild-all/202605280619.pmobiDWp-lkp@int=
el.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202605280519.Jd4fmgAZ-lkp@int=
el.com/

> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
> --- a/drivers/scsi/fnic/fnic_nvme.c
> +++ b/drivers/scsi/fnic/fnic_nvme.c

[ ... ]

> @@ -1755,6 +1912,15 @@ void nvfnic_fcpio_abort(struct nvme_fc_local_port =
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
> +		FNIC_NVME_DBG(KERN_INFO, fnic,
> +			      "waitq:%ld waitq_2sec:%ld max_wait:%ld\n",
> +			      num_ios_waitq, waitq_2sec, waitq_max_time);
>  		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>  		return;
>  	}

[ ... ]

> @@ -1855,6 +2038,7 @@ void nvfnic_nvme_iodone_work(struct work_struct *wo=
rk)
>  	llnode =3D llist_del_all(&fnic->nvme_io_event_llist);
>  	llist_for_each_entry_safe(io_req, tmp, llnode, nvfnic_io_cmpl) {
>  		atomic_dec(&fnic->nvme_io_event_queued);
> +		atomic64_dec(&fnic->fnic_stats.io_stats.nvme_num_ios_in_waitq);
>  		io_req->fcp_req->done(io_req->fcp_req);
>  	}
>  }

[Severity: Medium]
Are we missing the logic to calculate and populate the wait queue duration=
=20
metrics?

The nvme_ios_in_waitq_3000_msec and nvme_ios_in_waitq_max_time counters are=
=20
read and logged in nvfnic_fcpio_abort(), but it appears they are never=20
populated anywhere in the code. Should they be updated here in=20
nvfnic_nvme_iodone_work() using io_req->waitq_start_time when processing=20
the completion?

> diff --git a/drivers/scsi/fnic/fnic_stats.h b/drivers/scsi/fnic/fnic_stat=
s.h
> --- a/drivers/scsi/fnic/fnic_stats.h
> +++ b/drivers/scsi/fnic/fnic_stats.h

[ ... ]

> @@ -29,6 +29,15 @@ struct io_path_stats {
>  	atomic64_t io_greater_than_30000_msec;
>  	atomic64_t current_max_io_time;
>  	atomic64_t ios[FNIC_MQ_MAX_QUEUES];
> +
> +	atomic64_t nvme_io_reqs_rcvd;
> +	atomic64_t nvme_ios_queued_for_rsp;
> +	atomic64_t nvme_io_rsps_unqueued;
> +	atomic64_t nvme_io_rsps_sending;
> +	atomic64_t nvme_io_rsps_sent;
> +	atomic64_t nvme_num_ios_in_waitq;
> +	atomic64_t nvme_ios_in_waitq_3000_msec;
> +	atomic64_t nvme_ios_in_waitq_max_time;
>  };

[Severity: Medium]
In addition to the wait queue metrics mentioned above, does this code also=
=20
leave nvme_io_rsps_unqueued and nvme_io_rsps_sending completely unpopulated=
?=20
They appear to be declared here but are never updated or read in the modifi=
ed=20
code.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724174811.5118=
-1-kartilak@cisco.com?part=3D11

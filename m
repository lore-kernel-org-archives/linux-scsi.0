Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BAF330B01
	for <linux-scsi@vger.kernel.org>; Sun, 16 Aug 2026 12:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786882259; cv=none; b=VKr3bdThIlCXLzJAySWZIEIIn+B6rDR/P8S5eKu8tMtjIvOz/2K2FR3mvVwqcMB8N/foFk/ZDgjSJQ9DXuKLLkdhcE6U4cH/gD1NJWzHOwFqrhkCsQENC2aE/hCU1e+785qmRLCY0e0MKl0XYMyfp6cusgqndBJgyiFblmt7fpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786882259; c=relaxed/simple;
	bh=zgDF+eK3jpUfaQ2h3SX6dlVXP38UL2U753Z6ylVMWug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YfYPm7KgP23JEh23n9JbgA36hCc4f6JatIMkMtfaO1AJSrat3WuehXkfBLUUL5+z4B2Pa3R0zus/61+WEnRqmabfkJZhBWu1Q5sdqTw3U0vw0abnZSGEX4QNUhhaXq+Aj3E50305j3iFfS0TVSBl/bn7NEuA51EB34aZ41ooVg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kUWBlaXT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUWBlaXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DEC1F000E9;
	Sun, 16 Aug 2026 12:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786882258;
	bh=7DSkWoeE+HnOISzPhJ3AmFQnwbK5ppHefEPKoN6RKaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kUWBlaXTZpuIC90IuYC8qqw78OtqwJfXDqYNTXAbjCn/z0DwyjS2bHJ51lCjYaTzq
	 VYE2luOK3MrIhJ9IkTqXqpB0sUdrdstvDsIK9DzCKDPebsuQ3Rk4FT5RkBpybKowg/
	 IdAtQZLCyfc3BBhWd/rM3mz0lXgM5SbqSLIgIzQ9Qn/QKD2tR6teoUxz4vJeDB86gj
	 GP3ExXGzhf8YZtlecVOn8hwwRtxe8sCWdUL7dXag4dxkYSrQ2J+R7w5ZcBlswT3C42
	 DorQup6nz0I0Djd4LyqhNsBmlt4dowUsT2s+uWex8EjuvQInThH3y9TOCegNni2rE8
	 +hWF5dozw/KQA==
Date: Sun, 16 Aug 2026 15:10:50 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Hyeoncheol Jeong <hyenc.jeong@samsung.com>
Subject: Re: [PATCH] ufs: core: Disable queue depth tracking support
Message-ID: <20260816121050.GB66924@unreal>
References: <20260814214951.80673-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814214951.80673-1-bvanassche@acm.org>

On Fri, Aug 14, 2026 at 02:49:47PM -0700, Bart Van Assche wrote:
> Disable queue depth tracking support because:
>  - UFS devices shouldn't need queue tracking support. If the host sends
>    less than or equal to bQueueDepth commands to the UFS device, no TASK
>    SET FULL condition should be reported. If a TASK SET FULL condition
>    is reported anyway, the host->host_blocked variable will be set and
>    the SCSI command will be requeued. Submission of the SCSI command
>    will be retried after another SCSI command has completed.
>  - The queue depth tracking code is not thread-safe. With MCQ enabled,
>    scsi_track_queue_full() may be called from multiple CPU cores
>    concurrently. This is not safe because individual
>    scsi_track_queue_full() calls are not serialized.
>  - scsi_track_queue_full() is called from interrupt context but not all
>    code called by scsi_track_queue_full() is IRQ-safe. Here is an
>    example of a call chain that may cause interrupts to be enabled,
>    something that is not allowed from interrupt context:
> 
>    ufshcd_mcq_poll_cqe_lock()
>      ufshcd_compl_one_cqe()
>        scsi_done()
>          blk_mq_complete_request()
>            scsi_complete()
>              scsi_decide_disposition()
>                scsi_handle_queue_full()
>                  scsi_track_queue_full()
>                    scsi_change_queue_depth()
>                      blk_set_queue_depth()
>                        rq_qos_queue_depth_changed()
>                          ioc_rqos_queue_depth_changed()
>                            spin_lock_irq()
>                            spin_unlock_irq() <- enables interrupts
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c |  4 ++++
>  drivers/ufs/core/ufshcd.c           | 16 ----------------
>  2 files changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index acbd787de265..19a6400d1ec4 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1044,6 +1044,10 @@ static void srp_remove_target(struct srp_target_port *target)
>  	WARN_ON_ONCE(target->state != SRP_TARGET_REMOVED);
>  
>  	srp_del_scsi_host_attr(target->scsi_host);
> +	/*
> +	 * The srp_remove_host() call decrements the rport reference count.
> +	 * Keep the rport as long as its needed.
> +	 */

I believe we can drop this comment and keep the patch limited
to drivers/ufs/core/ufshcd.c only.

Thanks

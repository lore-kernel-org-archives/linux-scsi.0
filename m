Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08E435C69F
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 06:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790577935; cv=none; b=H1iPY4+NH450FACL4BYY0QRK1UvK4e7/h4FmOIY75JBv0BFt2bguh1jAUZTz3WlgyfmTCL1GZdNf2+naqOYFwXoVA3B8ZcOH7ZUafyToNyxDjQ+QGiLyojurGDYvCJGqvj3dVYhOMH8Vvb2KcHSTuP/m60weyxRZTz1JCEFC+Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790577935; c=relaxed/simple;
	bh=JP9zgsf8TUmucoFeWYVViI81RJ7v/Dl7ek9nrd7n+MU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jdAMcjIYNsvPnRb+JbKLvWSjEC3rLb/WRBESAVFEIFpAxi3Q9KcSfY/ltboF5Brsr6YN03mYeEa3V1sfmtaxONUdgNh6kAZ3kpquCYCwCaYiOQblJiZNygqn20RrM4GzPxoKDatVbYZ8r+RhNMht34e3NO4m5eGPVhxTwUwBlDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVqIIlZ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVqIIlZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999491F000FF;
	Mon, 28 Sep 2026 06:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790577933;
	bh=+i9EULIBLxRuOdGwnzYFFpx42mWl12CQHqIuvqjNLGU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EVqIIlZ9OA8VU7PEaj7l6W9ys0/E0UcpiuZk8u5QWTs/S/+fbYMx1g50v6D+NYgIu
	 hYz1TE5gXKN//0+5pnXPUAkUYXyV6AQBu0DFfM3zusjx40Om+eBMKx3IvgAp57GOnn
	 z5bKjuESeffEmdHIwNeU7lYZR0xdT5sP6TWMriiSRu28icAzBwnfgJyO92S90d/y3u
	 RseRLO/imZdf5Zsaia0yqKTOFWgcwUHIDLZEhHFFDQ88A/7JylHvCuVrp33v+60aKi
	 1+ZwYg1hotDJo25rPuwUhxm0HW6tlCSXJwWGRPrt8oGlxfw/krJIrZ8B04b5TCBE79
	 +h2TIApyZnjzQ==
Message-ID: <1dac66aa-a4e6-4c79-a914-d5d2699c392f@kernel.org>
Date: Mon, 28 Sep 2026 08:45:30 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/11] scsi: scsi_debug: Report the residual of a write
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260927052650.567035-13-cassel@kernel.org>
 <20260927052650.567035-18-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260927052650.567035-18-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/27 7:26, Niklas Cassel wrote:
> A write whose data buffer is larger than its transfer length leaves a
> residual that the initiator is entitled to be told about. resp_read_dt0()
> and resp_write_tape() report it, but the write paths for a disk do not,
> so such a write completes with GOOD status and a residual of zero while
> a READ of the same length into the same buffer reports it correctly.

I am not convinced this is correct. resid (residual count) is supposed to
indicate the amount of data that was *not* transferred. So if the buffer size is
larger that the command cdb transfer count, all data can be transferred and
resid should be 0. Which would mean that for this case, the write processing is
correct but the read side is not.

The SBC and SPC specs are very silent about this though, I do not think that the
resid is actually standardized. And I do not see a clear definition for it in
the documentation/code comments.

> 
> Report it in resp_write_dt0(), resp_write_scat() and resp_atomic_write().
> 
> resp_write_scat() differs twice over. Its data-out buffer also holds the
> parameter list header and the LBA range descriptors, so what the command
> consumed is sg_off rather than the bytes that the last range
> transferred; and sg_off counts what was asked for rather than what was
> transferred, so it can exceed the buffer and needs a guard. A command
> with no LBA range descriptors or a buffer transfer length of zero
> transfers nothing, so the whole buffer is residual. An error, real or
> injected, can end the command after some ranges have been written, so
> the residual is reported on every exit once the parameter list has been
> fetched.
> 
> Assisted-by: LLM
> Signed-off-by: Niklas Cassel <cassel@kernel.org>
> ---
> Tested with:
> 
>   modprobe scsi_debug zbc=managed sector_size=512 physblk_exp=3 \
>       zone_size_mb=8 dev_size_mb=128 zone_nr_conv=2
> 
> An eight logical block WRITE(16) with a 5000 byte buffer reports
> resid=904, having transferred 4096. A READ(16) of the same length into
> the same buffer reported that before this patch and the WRITE reported
> 0. A buffer of exactly 4096 bytes reports 0, as does a 512 byte buffer,
> which is consumed in its entirety. WRITE ATOMIC (16) behaves like the
> WRITE, on a device that is not zoned.
> 
> WRITE SCATTERED (16) with one LBA range descriptor of eight blocks and a
> 5632 byte buffer reports resid=1024, having consumed 512 bytes of
> parameter list and 4096 bytes of data. The same command with a 1024 byte
> buffer completes and reports resid=0: sg_off reaches 4608, past the end
> of the buffer, and without the guard the residual would have been
> reported as 4294963712.
> 
> Changes since v8: the residual is also reported when a later range
> fails. A WRITE SCATTERED (16) whose second range is out of range now
> reports resid=5120 of its 9728 byte buffer, where v8 reported 0.
> ---
>  drivers/scsi/scsi_debug.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index b64ae3ad300d..0c66a3118ee8 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5162,6 +5162,8 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>  			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
>  			    my_name, num * sdebug_sector_size, ret);
>  
> +	scsi_set_resid(scp, scsi_bufflen(scp) - ret);
> +
>  	if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
>  		     atomic_read(&sdeb_inject_pending))) {
>  		if (sdebug_opts & SDEBUG_OPT_RECOVERED_ERR) {
> @@ -5233,8 +5235,10 @@ static int resp_write_scat(struct scsi_cmnd *scp,
>  					    "Unprotected WR to DIF device\n");
>  		}
>  	}
> -	if ((num_lrd == 0) || (bt_len == 0))
> +	if (num_lrd == 0 || bt_len == 0) {
> +		scsi_set_resid(scp, scsi_bufflen(scp));
>  		return 0;       /* T10 says these do-nothings are not errors */
> +	}
>  	if (lbdof == 0) {
>  		if (sdebug_verbose)
>  			sdev_printk(KERN_INFO, scp->device,
> @@ -5327,6 +5331,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
>  
>  		if (unlikely((sdebug_opts & SDEBUG_OPT_RECOV_DIF_DIX) &&
>  			     atomic_read(&sdeb_inject_pending))) {
> +			/* This range has been written */
> +			sg_off += num_by;
>  			if (sdebug_opts & SDEBUG_OPT_RECOVERED_ERR) {
>  				mk_sense_buffer(scp, RECOVERED_ERROR,
>  					FAILURE_PREDICTION_THRESHOLD_EXCEEDED);
> @@ -5352,6 +5358,13 @@ static int resp_write_scat(struct scsi_cmnd *scp,
>  	}
>  	ret = 0;
>  err_out_unlock:
> +	/*
> +	 * sg_off counts what the command asked for, which can exceed the
> +	 * buffer: lbdof is not validated against it, and a range is counted
> +	 * in full even if do_device_access() copied less.
> +	 */
> +	if (scsi_bufflen(scp) > sg_off)
> +		scsi_set_resid(scp, scsi_bufflen(scp) - sg_off);
>  	sdeb_meta_write_unlock(sip);
>  err_out:
>  	kfree(lrdp);
> @@ -6206,6 +6219,8 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
>  		return DID_ERROR << 16;
>  	if (unlikely(ret != len * sdebug_sector_size))
>  		return DID_ERROR << 16;
> +
> +	scsi_set_resid(scp, scsi_bufflen(scp) - ret);
>  	return 0;
>  }
>  


-- 
Damien Le Moal
Western Digital Research

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0E52F84F
	for <linux-scsi@vger.kernel.org>; Sat, 16 Aug 2025 00:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755305635; cv=none; b=sGKyGSz/o2Hpn3vZYb3bLcO3nzLlkDla/I/avo0r0e8i49H5/oTNE9gfySXxbugNfcYKdOR+QW/HcVjkcYGvmjTrDofgBy4sLJvjeNMEYgMpPbXBYus/UzX7IWc4cv+xGgVFXXz9eZP+6LLIxWk1h+G8bZ7Tq8t5/V6LbWYYFiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755305635; c=relaxed/simple;
	bh=oBSsIeIld9S0Rh7zY+Dg9ygebe1A/v/2DIphl062pks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PkqTSn0rYuoqnfvu5cmrrgFdXItBx6Gc2hj8uOmlFyFBh0cMPs0yNyKsA4kTWYsDL0NbaW5F6rXz/ORhIoR8eqIvIU/8rg0ugKZ3n6pVjkEc4zRkVjHS8C4L3GMA3K5bbFWi3+4tSGI7/8oT5XzEjb2km0gsVG1IZA4856c6pWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X8jlu6s3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X8jlu6s3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD11C4CEF4;
	Sat, 16 Aug 2025 00:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755305635;
	bh=oBSsIeIld9S0Rh7zY+Dg9ygebe1A/v/2DIphl062pks=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X8jlu6s3Rukd6bu0e2lhJhnAQ5fIz8xsFN3tpXcyBwcZYlBpPcLGgMMobTFe0K1n3
	 0YzAav3k/B1eKXNvbq+YptHHvPD5yXM/yFDNYlDmlG9lPbiqAEO0TXs0AHQHm+nIMc
	 tRiMhr1E/VqZNtrHMpDzVplyffR0Kac6wNvCxFmzUHFLHx8cGwYVk3PtN1Xh+Or/6f
	 lgAY1gt5maEqRQdfpfBSvPZ+0eOEhvnEC4OUzjBFJNLUHESKQJkowv7wyuc0lyQPLM
	 yiT2QDLipOr4csoeUwbyTprtio2+S2MO1ojbNVzL+NNlPcbs8vps0GMcEWnC4kxmvX
	 +ihFN3Aj5xtRg==
Message-ID: <65053b7d-6d73-40c4-90f0-29530861f204@kernel.org>
Date: Sat, 16 Aug 2025 09:53:48 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/8] scsi: sd: Check for and retry in case of
 READ_CAPCITY(10)/(16) returning no data
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-7-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250815211525.1524254-7-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/16/25 06:15, Ewan D. Milne wrote:
> sd_read_capacity_10() and sd_read_capacity_16() do not check for underflow
> and can extract invalid (e.g. zero) data when a malfunctioning device does
> not actually transfer any data, but returnes a good status otherwise.

s/returnes/returns

> Check for this and retry, and log a message and return -EINVAL if we can't
> get the capacity information.

Hmmm. A little unclear explanation: "and retry, and log a message and return
-EINVAL"... hard to parse.

> 
> We encountered a device that did this once but returned good data afterwards.
> 
> See similar commit 5cd3bbfad088 ("[SCSI] retry with missing data for INQUIRY")
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

A couple of nits below to make the code cleaner.

With that,

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> ---
>  drivers/scsi/sd.c | 61 ++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 53 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index acd79e9a0d82..6066f5c92c74 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2638,6 +2638,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  		[13] = RC16_LEN,
>  	};
>  	struct scsi_sense_hdr sshdr;
> +	int count, resid;
>  	struct scsi_failure failure_defs[] = {
>  		/*
>  		 * Do not retry Invalid Command Operation Code or Invalid
> @@ -2688,6 +2689,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  	};
>  	const struct scsi_exec_args exec_args = {
>  		.sshdr = &sshdr,
> +		.resid = &resid,
>  		.failures = &failures,
>  	};
>  	int sense_valid = 0;
> @@ -2699,11 +2701,23 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  	if (sdp->no_read_capacity_16)
>  		return -EINVAL;
>  
> -	memset(buffer, 0, RC16_LEN);
> +	for (count = 0; count < 3; ++count) {
> +		memset(buffer, 0, RC16_LEN);
>  
> -	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
> -				      RC16_LEN, SD_TIMEOUT, sdkp->max_retries,
> -				      &exec_args);
> +		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
> +					      buffer, RC16_LEN, SD_TIMEOUT,
> +					      sdkp->max_retries, &exec_args);
> +
> +		if (the_result == 0 && resid == RC16_LEN) {
> +			/*
> +			 * if nothing was transferred, we try
> +			 * again. It's a workaround for a broken
> +			 * device.
> +			 */
> +			continue;
> +		}
> +		break;

Maybe reverse the condition to avoid this break and the continue ? E.g.:

		/*
		 * If nothing was transferred, we try again. It is a workaround
		 * for some buggy devices or SAT which sometimes do not return
		 * data on the first try.
		 */
		if (the_result || resid != RC16_LEN)
			break;

I find this simpler and cleaner :)

> +	}
>  
>  	if (the_result > 0) {
>  		if (media_not_present(sdkp, &sshdr))
> @@ -2727,6 +2741,12 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  		return -EINVAL;
>  	}
>  
> +	if (resid == RC16_LEN) {
> +		sd_printk(KERN_ERR, sdkp,
> +			  "Read Capacity(16) returned good status but no data");
> +		return -EINVAL;
> +	}
> +
>  	sector_size = get_unaligned_be32(&buffer[8]);
>  	lba = get_unaligned_be64(&buffer[0]);
>  

[...]

> @@ -2798,17 +2824,30 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  	};
>  	const struct scsi_exec_args exec_args = {
>  		.sshdr = &sshdr,
> +		.resid = &resid,
>  		.failures = &failures,
>  	};
>  	int the_result;
>  	sector_t lba;
>  	unsigned sector_size;
>  
> -	memset(buffer, 0, 8);
> +	for (count = 0; count < 3; ++count) {
> +		memset(buffer, 0, RC10_LEN);
>  
> -	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
> -				      8, SD_TIMEOUT, sdkp->max_retries,
> -				      &exec_args);
> +		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
> +					      buffer, RC10_LEN, SD_TIMEOUT,
> +					      sdkp->max_retries, &exec_args);
> +
> +		if (the_result == 0 && resid == RC10_LEN) {
> +			/*
> +			 * if nothing was transferred, we try
> +			 * again. It's a workaround for a broken
> +			 * device.
> +			 */
> +			continue;
> +		}
> +		break;

Same suggestion here as above.

> +	}
>  
>  	if (the_result > 0) {
>  		if (media_not_present(sdkp, &sshdr))
> @@ -2821,6 +2860,12 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  		return -EINVAL;
>  	}
>  
> +	if (resid == RC10_LEN) {
> +		sd_printk(KERN_ERR, sdkp,
> +			  "Read Capacity(10) returned good status but no data");
> +		return -EINVAL;
> +	}
> +
>  	sector_size = get_unaligned_be32(&buffer[4]);
>  	lba = get_unaligned_be32(&buffer[0]);
>  


-- 
Damien Le Moal
Western Digital Research

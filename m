Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFA11EEA55
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 02:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755226226; cv=none; b=rfCD2vRUcPmGbTbN9EMTk1DM+VSJa4VF+M6SN7a69m9q3c1A0WSXHujx+uB5eBOip/DlWBte7ECrdljaXfRcY0YDikuKF6Okk/CFfVSu1+S9ATxWlaZkRju6fKhj8Q7J7SxFvkZUJ/lqpQgqDnwamRvsoW1GKe5VJn61u9B9axc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755226226; c=relaxed/simple;
	bh=yfGiorSYWWSZw/DfZyvTHJqhr8vIdi0nWJS7M2Cf3ys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HZCK/rcClml2zSRmJydiGxv/vPBG3K53zmqQlV6RF3Tjj4EANkspiVZw8cAIzCjZvHm0VsUdy5FEMuDWAbjVSHJXfogY6nn1+851aWvCkAwaCR960RjJtJH5AVyIyqwIJUf2OKZQ25pK1PF1UtlCyv3hBuknZ2gaK3a3Ii0H+Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GWE4zNu7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GWE4zNu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68026C4CEED;
	Fri, 15 Aug 2025 02:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755226226;
	bh=yfGiorSYWWSZw/DfZyvTHJqhr8vIdi0nWJS7M2Cf3ys=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GWE4zNu7NKI5DEvWNAw0XrJJnaI13W+KAwb1K5LrTxhdrdPy1gXSKx+3VjoYpWa69
	 rviLN37YvNah8X1E4jFiVo8aIb4VLW53YHgLBxeLsnIaCllBwLpnAZx0VggHgbyTt6
	 Zy3oVaXrEQo4+COq3blrZmR8fyYfWmw3g/HtIdzTkCzKL9Ft/6WDkuzZb6BFEJhyLr
	 AfOP22v4TccWxepMIOq/s6fBqe2tk09svvznUC2y9X3EGsFaQrU8RxX7IaYtZCdzK3
	 EIPJ0+0cZ9z41pQ2tbKw2UoNHthB9YFheEtZ99fKo+2CJDBE+O2HKqTSBHpzF9RNqg
	 +gLTWOw55wLwQ==
Message-ID: <7a503388-d466-491b-aa1e-e56515266eab@kernel.org>
Date: Fri, 15 Aug 2025 11:50:24 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/9] scsi: sd: Check for and retry in case of
 READ_CAPCITY(10)/(16) returning no data
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org
References: <20250814182907.1501213-1-emilne@redhat.com>
 <20250814182907.1501213-8-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250814182907.1501213-8-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/15/25 03:29, Ewan D. Milne wrote:
> sd_read_capacity_10() and sd_read_capacity_16() do not check for underflow
> and can extract invalid (e.g. zero) data when a malfunctioning device does
> not actually transfer any data, but returnes a good status otherwise.
> Check for this and retry, and log a message and return -EINVAL if we can't
> get the capacity information.
> 
> We encountered a device that did this once but returned good data afterwards.
> 
> See similar commit 5cd3bbfad088 ("[SCSI] retry with missing data for INQUIRY")
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/sd.c | 56 ++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 48 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index f1ab2409ea3e..20b5eebba968 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2639,6 +2639,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  		[13] = RC16_LEN,
>  	};
>  	struct scsi_sense_hdr sshdr;
> +	int count, resid;
>  	struct scsi_failure failure_defs[] = {
>  		/*
>  		 * Do not retry Invalid Command Operation Code or Invalid
> @@ -2689,6 +2690,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  	};
>  	const struct scsi_exec_args exec_args = {
>  		.sshdr = &sshdr,
> +		.resid = &resid,
>  		.failures = &failures,
>  	};
>  	int sense_valid = 0;
> @@ -2700,11 +2702,23 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  	if (sdp->no_read_capacity_16)
>  		return -EINVAL;
>  
> -	memset(buffer, 0, buflen);
> +	for (count = 0; count < 3; ++count) {
> +		memset(buffer, 0, buflen);
>  
> -	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
> -				      RC16_LEN, SD_TIMEOUT, sdkp->max_retries,
> -				      &exec_args);
> +		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
> +					      buffer, RC16_LEN, SD_TIMEOUT,
> +					      sdkp->max_retries, &exec_args);
> +
> +		if ((the_result == 0) && (resid == RC16_LEN)) {

You do not need the inner parenthesis. Also, it seems to me that this check
should simply be:

		if (resid)

Because any incomplete read capacity buffer is bound to be invalid.

> +			/*
> +			 * if nothing was transferred, we try
> +			 * again. It's a workaround for a broken
> +			 * device.
> +			 */
> +			continue;
> +		}
> +		break;
> +	}
>  
>  	if (the_result > 0) {
>  		if (media_not_present(sdkp, &sshdr))
> @@ -2728,6 +2742,12 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  		return -EINVAL;
>  	}
>  
> +	if (resid == RC16_LEN) {
> +		sd_printk(KERN_ERR, sdkp,
> +			  "Read Capacity(16) returned good status but no data");

Shouldn't this be a warning instead of error ? After all, there was no error...
And I would prefer seeing a warning for a bad device. The message would also be
better mentioning that this is the device fault.

> +		return -EINVAL;
> +	}
> +
>  	sector_size = get_unaligned_be32(&buffer[8]);
>  	lba = get_unaligned_be64(&buffer[0]);
>  
> @@ -2770,6 +2790,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  {
>  	static const u8 cmd[10] = { READ_CAPACITY };
>  	struct scsi_sense_hdr sshdr;
> +	int count, resid;
>  	struct scsi_failure failure_defs[] = {
>  		/* Do not retry Medium Not Present */
>  		{
> @@ -2804,17 +2825,30 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
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
> -	memset(buffer, 0, buflen);
> +	for (count = 0; count < 3; ++count) {
> +		memset(buffer, 0, buflen);
>  
> -	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
> -				      8, SD_TIMEOUT, sdkp->max_retries,
> -				      &exec_args);
> +		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
> +					      buffer, RC10_LEN, SD_TIMEOUT,
> +					      sdkp->max_retries, &exec_args);
> +
> +		if ((the_result == 0) && (resid == RC16_LEN)) {

Same comment here: if (resid) ?

> +			/*
> +			 * if nothing was transferred, we try
> +			 * again. It's a workaround for a broken
> +			 * device.
> +			 */
> +			continue;
> +		}
> +		break;
> +	}
>  
>  	if (the_result > 0) {
>  		if (media_not_present(sdkp, &sshdr))
> @@ -2827,6 +2861,12 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
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

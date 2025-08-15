Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11996A33B
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 02:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755225799; cv=none; b=fPbhV0CjRMvzJTHFfUJHC2GhyigyK/Ird13YG1qs+o6q/Vaf5fFVpzPxg82FUFLyri9UyyMyI13VI0l6ogRn56lDxPy4S4U7pfYzH9jkwqCZ0YB+KZtd723pp1OCE4Olbofcf3QRENfTyqWvrGSB0DIpaqXasMxIBud/AIOZ/GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755225799; c=relaxed/simple;
	bh=9aEPL1yv3cya6cXPU2UdL/LH0mgaZjBjaDPq89ALH4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XV1zT6akZcgJQUJ/WJI5RQZ+WMVgMyFfEcd1Av7eLRkUgK24daozG6zJ4F5vqIYCzTawW9cTCzTsKsRyIWDmN8odGORNZG11npe88mQX8z26ngIunpyrWnWeSdZXmbyWIlyRFLNI5KXnOdGgJKu0qnHDsCDLxbbMc6AHvx+X7VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nelDdSaX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nelDdSaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809D6C4CEED;
	Fri, 15 Aug 2025 02:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755225799;
	bh=9aEPL1yv3cya6cXPU2UdL/LH0mgaZjBjaDPq89ALH4c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nelDdSaXBVo3fwOyZd8BDOtlgPZLW5DWopyPBi8Pfjwq6xfiPiULd7ieHMRRP0fV7
	 1hlUZTJlAM5vCr6lDOLsEw83otlE0W8dQm1ryxRXTtLKAhbiRMxiLuoRymg6xkGwEk
	 icCtfC33PY677Ki1CrITq4nc6hJV8huNtaqtnP6MOV0AxVVKt3P5TKkYv7rE8ussnU
	 zDcKj9QivA1wVVvDBz1nIFPGIOiUwT3NQws7vdKt5w4jI/4OJdpv3mbhx7sTILtvBH
	 FTOLt/2X7ZS1ZVcWgosGMLOhQERSMkSVWbbtS8NC57zBY+0gchzOq4/sg+jtUXcZY8
	 lxPZSZX4vdK3Q==
Message-ID: <1305ccb7-4e23-436e-bdb3-79ebb8681bfc@kernel.org>
Date: Fri, 15 Aug 2025 11:43:17 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/9] scsi: sd: Pass buffer length as argument to
 sd_read_capacity() et al.
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org
References: <20250814182907.1501213-1-emilne@redhat.com>
 <20250814182907.1501213-4-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250814182907.1501213-4-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/15/25 03:29, Ewan D. Milne wrote:
> That will make it easier to spot an inconsistent buffer size value.

How ? the buffer size is actually not checked. You only memset the buffer.

> Also, memset() the entire buffer rather than the 8 or 32 bytes expected
> back from READ CAPACITY(10) or READ CAPACITY(16).

Why ? There is no explanation why that is needed. The command will not return
more than the transfer length specified. So memsetting bytes that will never be
used seems useless.

> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/sd.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index e3b802b26f0e..ae8eac4b1cb2 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2629,7 +2629,8 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  #define READ_CAPACITY_RETRIES_ON_RESET	10
>  
>  static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
> -		struct queue_limits *lim, unsigned char *buffer)
> +			    struct queue_limits *lim, unsigned char *buffer,
> +			    unsigned int buflen)
>  {
>  	unsigned char cmd[16];
>  	struct scsi_sense_hdr sshdr;
> @@ -2651,7 +2652,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  		cmd[0] = SERVICE_ACTION_IN_16;
>  		cmd[1] = SAI_READ_CAPACITY_16;
>  		cmd[13] = RC16_LEN;
> -		memset(buffer, 0, RC16_LEN);
> +		memset(buffer, 0, buflen);

I would leave this as-is.

>  >  		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
>  					      buffer, RC16_LEN, SD_TIMEOUT,
> @@ -2719,8 +2720,13 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  	return sector_size;
>  }
>  
> +#define RC10_LEN 8
> +#if RC10_LEN > SD_BUF_SIZE
> +#error RC10_LEN must not be more than SD_BUF_SIZE
> +#endif
> +
>  static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
> -						unsigned char *buffer)
> +			    unsigned char *buffer, unsigned int buflen)
>  {
>  	static const u8 cmd[10] = { READ_CAPACITY };
>  	struct scsi_sense_hdr sshdr;
> @@ -2765,7 +2771,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  	sector_t lba;
>  	unsigned sector_size;
>  
> -	memset(buffer, 0, 8);
> +	memset(buffer, 0, buflen);

Same here, but maybe define RC10_LEN instead of having the magic "8" value
hardcoded ?

-- 
Damien Le Moal
Western Digital Research

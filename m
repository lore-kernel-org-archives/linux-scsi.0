Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC2C3C6BA
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 23:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724109907; cv=none; b=Atq5yPER++v4UW6NLp8wLUlTEOabHrETtl9nyQ/XYzK63o6gOOBo6XxsF5aLUne565Kkag14jp0F/YDzP76vXZsIIH/Yq3hYLChQqXj8af/O0/ZHxC765s7fED4j24CZX8ic/dxbOjK6tcDutygypr9J0J5fwC5IfEm+klVTNKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724109907; c=relaxed/simple;
	bh=wLsN8HwfytC398mhEUF4liuiEBwMCsZMblirgQ2FYWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QFgWM6vgJg2bp2oVA6YXIso+mHDW6F4TgQ2+4qvfa16m9InTssN5Tjz+jw9wi6pGit+WIS/YeAisqMGlrKpQp15vPBvO3yuG7rbCLlU9TZMD6h3aYrYABucLROvNakSvv7v/ytAnfIXvQrj5RL8qDmLzWCjqVvIh/ZazCI8BXr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YBzAl0Jf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YBzAl0Jf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2325C32782;
	Mon, 19 Aug 2024 23:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724109906;
	bh=wLsN8HwfytC398mhEUF4liuiEBwMCsZMblirgQ2FYWE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YBzAl0Jfa1Xi/9O+osgpbIylI8QRNJqhu3Lii1y8rHCcXVRLu/vcqyKuRjwPGqgBo
	 K53/xG4EMVQVPZlVfbxBYgRxqwsqsUWq7u5S6Uphf+4UkcnsE3zDYllXb2gEfMqHpI
	 /3E1MeIrwtrkO/DbPuLYz0QdS6s7Xt4FMFhK9JA5UL3Jws/Rk3MVWwhtTKMGBV+RlY
	 SVz9UuBKUuALGwITvECaiiwFTfbC/kZ6AXOGu8dUat3+vCQDPDhRQs0okMDKxh0sZl
	 zXuin/MODabfuOQhuD7s0Xkx4sI2u9nVtT7YCDHewX5y0x+hnAZ486p0j+LBKpluCc
	 watXbPrsZXv/g==
Message-ID: <d226bf67-1d68-4e50-a20f-93a806f6860d@kernel.org>
Date: Tue, 20 Aug 2024 08:25:04 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] scsi: core: Retry passthrough commands if
 SCMD_RETRY_PASSTHROUGH is set
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michael.christie@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240809193115.1222737-1-bvanassche@acm.org>
 <20240809193115.1222737-2-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240809193115.1222737-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/10/24 04:31, Bart Van Assche wrote:
> The SCSI core does not retry passthrough commands even if the SCSI device
> reports a retryable unit attention condition. Support retrying in this case
> by introducing the SCMD_RETRY_PASSTHROUGH flag.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_error.c | 5 ++++-
>  include/scsi/scsi_cmnd.h  | 5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 612489afe8d2..9089d39c2170 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1855,7 +1855,10 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
>  	 * assume caller has checked sense and determined
>  	 * the check condition was retryable.
>  	 */
> -	if (req->cmd_flags & REQ_FAILFAST_DEV || blk_rq_is_passthrough(req))
> +	if (req->cmd_flags & REQ_FAILFAST_DEV)
> +		return true;
> +	if (blk_rq_is_passthrough(req) &&
> +	    !(scmd->flags & SCMD_RETRY_PASSTHROUGH))
>  		return true;
>  
>  	return false;

	return (req->cmd_flags & REQ_FAILFAST_DEV) ||
		(blk_rq_is_passthrough(req) &&
		 !(scmd->flags & SCMD_RETRY_PASSTHROUGH));

maybe ? Not necessarily more readable though.

> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 45c40d200154..19c57446ab23 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -58,8 +58,11 @@ struct scsi_pointer {
>   */
>  #define SCMD_FORCE_EH_SUCCESS	(1 << 3)
>  #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
> +/* If set, retry a passthrough command in case of a unit attention. */

"...in case of error". There are other sense keys than unit attention and there
is no code checking that this flag applies only to unit attention.

With this comment fixed:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> +#define SCMD_RETRY_PASSTHROUGH	(1 << 5)
>  /* flags preserved across unprep / reprep */
> -#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
> +#define SCMD_PRESERVED_FLAGS	\
> +	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING | SCMD_RETRY_PASSTHROUGH)
>  
>  /* for scmd->state */
>  #define SCMD_STATE_COMPLETE	0

-- 
Damien Le Moal
Western Digital Research


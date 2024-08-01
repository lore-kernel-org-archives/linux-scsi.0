Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F47618E0E
	for <linux-scsi@vger.kernel.org>; Thu,  1 Aug 2024 07:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722495847; cv=none; b=KqhZfMvYZcBxYz3/FY9PgTtHcGsRPB2EJmSf/zbv5FVSWl5YU66A8AK+xSAdf1e9HzvfsS3yHkqcm+t4FLIk72NckYhCq8QxRqii+nPRQeYopjNAGdpKzx9Ku4bcMCre1uVo1afe+WQeBUjDLwPAyY+EPO8kIOXRABQUki6rnao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722495847; c=relaxed/simple;
	bh=+GHkS6hmjjIUmdkdk+maFFBxJR47AKa4ahDcAxkEGbk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gCUqrKXO3o5OzvZgM1NpYU/mRmFK1wQT48e4yVkB3CxPez9bAjCvE/YS3mzxDCOV7BBJhKXZ4JtQ5MgU2lhUUnw6C5/QY7ROpBiNXkzGcTAFU9Pqe9TaZ/A2rw+7sAB/oEw73JitbONP0u1V88gn2nTHOBXxM8r8fcbzJ09JLmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AEv7k4Zg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AEv7k4Zg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA4AC4AF0A;
	Thu,  1 Aug 2024 07:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722495846;
	bh=+GHkS6hmjjIUmdkdk+maFFBxJR47AKa4ahDcAxkEGbk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AEv7k4ZghV5LLw4rd1VUrzE4X05xWsWaC1Gh06vhmz3ZjWu69MLpcOHixV4ndrPku
	 VY4te79D3jTzyfHf7LPGXMoXuFwgER2J8BmqADpLtndE1+TmhZWXTtNPtkJ+yJtgKC
	 nLBitUW96kE5fl66VuI21SThByHEXuVLfhppZsipHXnRr5Aov3SNtRy6r10rQr/mn8
	 L+FCOw90oPANBTZRzvR2FRAW7qk0y7UBkS88pmpEQncVgTNeHCIDZb7/sRuGGn15La
	 J8OX0Abo0BD8dEarDMBbVhlDriueWDNwRL4nAdEnYk7r3MfmDNefWuYEs0LpFZYL3b
	 DkERlmwn0BIPg==
Message-ID: <5090f92c-096d-4cbf-95f4-af25b50243bc@kernel.org>
Date: Thu, 1 Aug 2024 16:04:04 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RFC: Retrying SCSI pass-through commands
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>, Mike Christie <michael.christie@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <b0f92045-d10f-4038-a746-e3d87e5830e8@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <b0f92045-d10f-4038-a746-e3d87e5830e8@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 8/1/24 5:22 AM, Bart Van Assche wrote:
> Hi,
> 
> Recently I noticed that a particular UFS-based device does not resume
> correctly. The logs of the device show that sd_start_stop_device() does
> not retry the START STOP UNIT command if the device reports a unit
> attention. I think that's a bug in the SCSI core. The following hack
> makes resume work again. I think this confirms my understanding of this
> issue (sd_start_stop_device() sets RQF_PM):
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index da7dac77f8cd..e21becc5bcf9 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1816,6 +1816,8 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
>          * assume caller has checked sense and determined
>          * the check condition was retryable.
>          */
> +       if (req->rq_flags & RQF_PM)
> +               return false;
>         if (req->cmd_flags & REQ_FAILFAST_DEV || blk_rq_is_passthrough(req))
>                 return true;
> 
> My understanding is that SCSI pass-through commands submitted from
> user space must not be retried. Are there any objections against
> modifying the behavior of the SCSI core such that it retries
> REQ_OP_DRV_* operations submitted by the SCSI core, as illustrated
> by the pseudo-code below?

Another thing: may be check scsi_check_passthrough(). See the call to that in
scsi_execute_cmd() and how it is used to drive retry of the command. Tweaking
that may be what you need for your UFS device problem ?

> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index da7dac77f8cd..e21becc5bcf9 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1816,6 +1816,12 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
>          * assume caller has checked sense and determined
>          * the check condition was retryable.
>          */
> -       if (req->cmd_flags & REQ_FAILFAST_DEV || blk_rq_is_passthrough(req))
> -               return true;
> +       if (req->cmd_flags & REQ_FAILFAST_DEV)
> +               return true;
> +       if (/* submitted by the SCSI core */)
> +               return false;
> +       if (blk_rq_is_passthrough(req))
> +               return true;
> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6975E1D696
	for <linux-scsi@vger.kernel.org>; Thu,  1 Aug 2024 03:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722483196; cv=none; b=ZzGF85blWd2myqaUgjeZDQ7PaZ/mu+BSQXyhdtDHdzLv934gF1L8s72Ou5vVwp45W59yi2YJA/eFHQ47PGcUKDFKeyLdXV8avgRzlPMJFa2Av8zns29G/XfF8O9kXgepOdlXni9uTTQSOAGmB6yqJqnHtibwbyBBE9S13akuYhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722483196; c=relaxed/simple;
	bh=4nEk/1sWuXXuwfYqZ4SVVWAc7Yg3DQvikLR1Y86eePo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CCQ0ZvUUzTfQe1iN6gUYfoWLMqhdVYns9RXaDWVAqVspG7pFzz5nAHlikPyc15eRYNr5kH4dQmR0hTVoSwS5Cy60VjxpUAzhNqXVf/pqUoBOi91bDsGB0pkrUHggylfUG+8F4R6VwlUyTjJO3ZW5qFQnq1v8xp+UMO/C6WiwlE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jq7M02Nj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jq7M02Nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0EFC4AF0A;
	Thu,  1 Aug 2024 03:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722483196;
	bh=4nEk/1sWuXXuwfYqZ4SVVWAc7Yg3DQvikLR1Y86eePo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jq7M02NjY/5uIx8Hr4RwgIyUj/pIaBwgpzniCYQkX82DMIoR3B4Znr65QkhXVXwmR
	 5DWN5XxYSICzyVL8ExpzbSiwqHvhHOrKdJ9BHVfqDaAVu1WFKu36rO9z0h0WAfTbqP
	 7sfMoa+/1dSzUgS33JmQ+KSBeJ/Mqy1Ii3TDKZs5o/JcD4vlylwi0+Z24EwK3f8+TB
	 ZI9VeKN1GerJyqLTV/qSV3BUWOEUfPZOI5gUkj3JS2zBojnGE0J2COUgD5Qd1OsOqg
	 Jn43vI5oiH9bPkncxxIgeZpcWe5loOnXk5BvMh/ITyQebbLf++Vxl6gLKyPFyy7xn9
	 V7LOxKEVS1wwA==
Message-ID: <a23d7a8c-4a4a-4687-ae18-87b2b2fb9fcb@kernel.org>
Date: Thu, 1 Aug 2024 12:33:13 +0900
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

Looking at the code, e.g. sd_start_stop_device():

	res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0, SD_TIMEOUT,
                               sdkp->max_retries, &exec_args);

It seems that it is expected that the retry count will be honored. But that
indeed is not the case as scsi_noretry_cmd() will always return false for
REQ_OP_DRV_* commands.

So may be we should have a RQF_USER_OP_DRV flag to differentiate user
REQ_OP_DRV_* passthrough commands from internally issued REQ_OP_DRV_* commands.
Or the reverse flag, e.g. RQF_INTERNAL_OP_DRV, that we can set in e.g.
scsi_execute_cmnd().

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


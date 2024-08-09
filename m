Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9A2CA64
	for <linux-scsi@vger.kernel.org>; Fri,  9 Aug 2024 15:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723218043; cv=none; b=r/0k1R19PUCRspDx+Jp38T69dog81g1XhAXN7ArJUZsh2usKqLs3hGmGt5YKSLg6Cy7+TxVCK9qB1Mm5SOqHt6mMBTjOk6T3kZ+28GwM+wF6sGqgetXaccahEAfIxAmAyPJC+hqYQJDHzbcS0h9ZGf+JFhuK/XrJQOkPEN37If4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723218043; c=relaxed/simple;
	bh=Jy88Roncbzg3lPy7Qykr9PimpVv/ukZVqISRvgDpmEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GVmjpG9Hm3EHxmT/wLwR691rxAtpFHvzu3c761LaF5rKZ+nBKYjmnM8bUSWmPbYjV6qgzLcr1LZJEskVNFN9tZMuqaP1WmqPEJfpj9gRzrhSTrEJnKRMn0Kmbi4fJTWitU2G+Jesqfvv68C632KnT4Jx8l8u1pJlwm/gnAKmh0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tv8H9ouP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tv8H9ouP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E69C32782;
	Fri,  9 Aug 2024 15:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723218043;
	bh=Jy88Roncbzg3lPy7Qykr9PimpVv/ukZVqISRvgDpmEE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Tv8H9ouPQjlggpqYlSZNR2+Mh28/MhZlwOqaYzXp79eGYbE3H4D+xjtDX67OEPp3b
	 7+11r+L85TcFHxfyYwiYKRwX9O8v/fnYZgW4TjVxW6yBV0/Xim2QzML7c3qAIxDEPI
	 tJedV/vmC4/9BBQheK2TqWmpQLR3QsLDh9RolvOROLnSLicoJTodprtS+7IbpHHxJt
	 kCfZjPaChjvTDy8wVT6LtQ+bcKV5JgCsI++lYA2Zo9ITNz0sMCHUt4h9KnKPOL78H/
	 YHJ00qf0YutyGO8P4ZMhoDt2UFxQgky3cXosejMPyz2HKPJ103zF4ZvhjbJFa1y+1C
	 yvg4PK9LvmlZA==
Message-ID: <cd94a0d4-6e6d-495c-aa17-d2d2c875604a@kernel.org>
Date: Fri, 9 Aug 2024 08:40:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: core: Retry passthrough commands if
 SCMD_RETRY_PASST_ON_UA is set
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michael.christie@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240807203215.2439244-1-bvanassche@acm.org>
 <20240807203215.2439244-2-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240807203215.2439244-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/08/07 13:32, Bart Van Assche wrote:
> The SCSI core does not retry passthrough commands even if the SCSI device
> reports a retryable unit attention condition. Support retrying in this case
> by introducing the SCMD_RETRY_PASST_ON_UA flag.

This flag is badly named since nowhere it is checked that the retry happens on
UNIT ATTENTION. The retry may happen with other sense key as well, no ?

So what about simply calling this: SCMD_RETRY_PASSTHROUGH ?

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
> index 612489afe8d2..38e3ea85e381 100644
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
> +	    !(scmd->flags & SCMD_RETRY_PASST_ON_UA))
>  		return true;
>  
>  	return false;
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 45c40d200154..43c584fbeaca 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -58,8 +58,11 @@ struct scsi_pointer {
>   */
>  #define SCMD_FORCE_EH_SUCCESS	(1 << 3)
>  #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
> +/* If set, retry a passthrough command in case of a unit attention. */
> +#define SCMD_RETRY_PASST_ON_UA	(1 << 5)
>  /* flags preserved across unprep / reprep */
> -#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
> +#define SCMD_PRESERVED_FLAGS	\
> +	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING | SCMD_RETRY_PASST_ON_UA)
>  
>  /* for scmd->state */
>  #define SCMD_STATE_COMPLETE	0
> 

-- 
Damien Le Moal
Western Digital Research


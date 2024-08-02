Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA3FA50
	for <linux-scsi@vger.kernel.org>; Fri,  2 Aug 2024 00:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722559667; cv=none; b=pLHu5pIz8DpEo2aW2lTel35eaVRmw6OU3hNliE+0HkNUqLzCZkoLQb4oJezdads+NguvEso6sShbJahwOvaFGnKkgD6T9ncI8wMZnW4ow8GABwBWh3bFqEg1WmthWGdsDWgXicWlr9n0wW+g/qoXadIRrF/zqd2Du8X3xW0sSQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722559667; c=relaxed/simple;
	bh=a7mWLXhS579H93mZt+XDieN9nB7N31PfEz9FtFWfAbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pTnSLhs7ketssvVlXKoMq1+/GDgxg9pOBsPHMg7bHs8imkKI1P86vYmail1rqJKUt2ZMTyxg79XzvB6sVAd/69goZX0dUg87fs0klOWWRX2pmU/uQpEBgwUnS9vzDv9pXVhZXssNdHtdqBKBKZuogzvFTvg1rx2dyiE1L5TLDMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fR9OWo9I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fR9OWo9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CD6C32786;
	Fri,  2 Aug 2024 00:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722559666;
	bh=a7mWLXhS579H93mZt+XDieN9nB7N31PfEz9FtFWfAbw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fR9OWo9IG9W5j22dIJN/zui+40j64eJzgfkbGWGqRpLwo+vChEbCrbgtOx4PgRO3r
	 ZDmx+hucwK3BC5y2O1JW9dJBhNaQ5sVS3AQLbrEzbwmPOZLLsxFEW4IMYdlfpnpqHF
	 NYU9k2T3VwG3xzZChJ4L/pPp0UFXEfVDl9f00DxUsRIgoMlM/zwum9qRD9ck5ZMCnh
	 H9XsAydhVPvutBg3/AoRsitV8jtBkDU62Muyb3TIB8b/KB1FrsNp843QQQgxek6j0i
	 Lun1JAaPUOT+OfHSYx8V326NGpghdU0pRTCyMNZ5luVz6nsr4Y3B81OX2TmUjG1Ekv
	 gFYfr8fKBQFQA==
Message-ID: <30b1d857-8172-497c-b482-d49af8463029@kernel.org>
Date: Fri, 2 Aug 2024 09:47:44 +0900
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
 <a23d7a8c-4a4a-4687-ae18-87b2b2fb9fcb@kernel.org>
 <1e79816d-02eb-4997-81d2-4b6ec0201dd5@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <1e79816d-02eb-4997-81d2-4b6ec0201dd5@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/2/24 05:12, Bart Van Assche wrote:
> On 7/31/24 8:33 PM, Damien Le Moal wrote:
>> Looking at the code, e.g. sd_start_stop_device():
>>
>> 	res = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, NULL, 0, SD_TIMEOUT,
>>                                 sdkp->max_retries, &exec_args);
>>
>> It seems that it is expected that the retry count will be honored. But that
>> indeed is not the case as scsi_noretry_cmd() will always return false for
>> REQ_OP_DRV_* commands.
>>
>> So may be we should have a RQF_USER_OP_DRV flag to differentiate user
>> REQ_OP_DRV_* passthrough commands from internally issued REQ_OP_DRV_* commands.
>> Or the reverse flag, e.g. RQF_INTERNAL_OP_DRV, that we can set in e.g.
>> scsi_execute_cmnd().
> 
> Hmm ... how about using the simplest possible patch? The patch below seems
> to work fine.
> 
> Thanks,
> 
> Bart.
> 
> [PATCH] scsi: core: Retry commands submitted by the SCSI core
> 
> Pass-through commands either come from user space (SG_IO ioctl,
> SCSI_IOCTL_*, BSG), from the SCSI core or from a SCSI driver (ch,
> cxlflash, pktcdvd, scsi_scan, scsi_dh_*, scsi_transport_spi, sd,
> sg, st, virtio_scsi). All this code sets scsi_cmnd.allowed to the
> maximum number of allowed retries. Hence, removing the
> blk_rq_is_passthrough() check from scsi_noretry_cmd() has the
> effect that scsi_cmnd.allowed is respected for pass-through
> commands.
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 612489afe8d2..c09f65cfa898 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1855,7 +1855,7 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
>   	 * assume caller has checked sense and determined
>   	 * the check condition was retryable.
>   	 */
> -	if (req->cmd_flags & REQ_FAILFAST_DEV || blk_rq_is_passthrough(req))
> +	if (req->cmd_flags & REQ_FAILFAST_DEV)
>   		return true;

But that will cause *all* passthrough requests to be retried, including those
issued from userspace, no ? I do not think that such change would be acceptable
as that can break userspace using passthrough and expecting to deal with errors
and handling them however they see fit, which may not be retrying commands.

> 
>   	return false;
> 

-- 
Damien Le Moal
Western Digital Research


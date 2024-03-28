Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0B82E84B;
	Thu, 28 Mar 2024 22:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711665729; cv=none; b=qLCZRBkcwQ6k/4wk8RHnV31lvBFMEJ2DFr9rtK+HqU2bs/SbXgYzt3PgdvzHyqvP/XvZI6XH2/hzPsdgbiHDPbqzvwOd4kk1sD+rLYb1U9K/ujUJwP+aB+AZA65LkNCKwpV3HFf990ozgM8PH2N/05MP2nu49b7IoXTGCJrdYjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711665729; c=relaxed/simple;
	bh=MzwB43EG7KeAx0YkElgFBYLwOHrbrRhvxrCVC4TpalY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=udOwjtK8LwxgjOREEMcZEnTYHp4CaCStcFp0XZQvB0o3yftlfnM1tQPAay9aexdrXkb4EiYGzCuizJk9r9zWqssYndG7xVm22cbDDbQYLG9bHIW3YVVqGSIDGiFG+jDUTwv42T4sh+U33bMi4vrw/R9L77/s2QLTjMIOwHdq2UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qkhou3GU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qkhou3GU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E527AC433F1;
	Thu, 28 Mar 2024 22:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711665729;
	bh=MzwB43EG7KeAx0YkElgFBYLwOHrbrRhvxrCVC4TpalY=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=Qkhou3GUD0yQYaq5sI+0HzRkxNEJyp94VPii0QzQzPdgLfR4i7I8REIyW2U0gW2Pw
	 FiFwOhTZ5BmhSiDSX+HsYRg7FnPA/bLg05I4IZZnhdnLOc33IElaadzyVDykKunA/N
	 3pjzV/zSWrf1GYawkpeAMbLYwP6jFZq44Echm0ummfcZz9vjlrU0ro6+gNmk3X59zn
	 otAvfZBXu3JfjXrMfnkDznrTzfjHJ1I0AjXvoKtQi1dm5UnSjygvw6Pba2KwGU1ptj
	 oaro5d/8YYhMPsaoSVBv/dlv+cBe+Tq66AfCNdH1OtZVoZKpSDh+icv0fmgKSYC0R4
	 Huv0NR4ajQmeA==
Message-ID: <a4727142-d533-4b75-bacf-ea0c016a3e67@kernel.org>
Date: Fri, 29 Mar 2024 07:42:06 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/30] block: Remove req_bio_endio()
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-4-dlemoal@kernel.org>
 <b09d7101-4124-4d77-b33a-977e2b555607@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <b09d7101-4124-4d77-b33a-977e2b555607@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/29/24 06:28, Bart Van Assche wrote:
> On 3/27/24 5:43 PM, Damien Le Moal wrote:
>> Moving req_bio_endio() code into its only caller, blk_update_request(),
>> allows reducing accesses to and tests of bio and request fields. Also,
>> given that partial completions of zone append operations is not
>> possible and that zone append operations cannot be merged, the update
>> of the BIO sector using the request sector for these operations can be
>> moved directly before the call to bio_endio().
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> 
>> -	if (unlikely(error && !blk_rq_is_passthrough(req) &&
>> -		     !(req->rq_flags & RQF_QUIET)) &&
>> -		     !test_bit(GD_DEAD, &req->q->disk->state)) {
>> +	if (unlikely(error && !blk_rq_is_passthrough(req) && !quiet) &&
>> +	    !test_bit(GD_DEAD, &req->q->disk->state)) {
> 
> A question that is independent of this patch series: is it a bug or is
> it a feature that the GD_DEAD bit test is not marked as "unlikely"?

likely/unlikely are optimizations... I guess that bit test could be under
unlikely() as well. Though if we are dealing with a removable media device, this
may not be appropriate, which may be why it is not under unlikely(). Not sure.

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAE12F37;
	Wed, 29 May 2024 08:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716969638; cv=none; b=CrfIl1nLm6NyhCS9Q5zTZjsC62Br+wX+E96NfAGkGC0YzJB0xBe0EdS/nYjjKTz4yZ+f1shkxWnjk8CGcGWtINUkFHc5DsL05TeJ+7UwODrhwUiMa5IwbQ3s9qj2OJgH492qtRYiXz5Vva2HK+LDSrPcmai66r7KNNsGWVtB+N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716969638; c=relaxed/simple;
	bh=G8ukn4/ipULjaA61nZoKSh0N7cnsV0YBmRdlGxpAHeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XA9CjoMo2W73/RRL1lGlUS0Xbb71R+jRCD4BQ3y98nkRHqAULAwIprjJ38KF1EIMoEt37KMPUI99gRBo7BjYR8z2tDWLNfmd2zDJOYOhO/C6odsAXZBsdwp1fVlaklNt/eKsVMoW+1SdvMkNX9waOKfr1As0JcoNzs5dIWSQq1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SuVzllmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SuVzllmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1365C2BD10;
	Wed, 29 May 2024 08:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716969637;
	bh=G8ukn4/ipULjaA61nZoKSh0N7cnsV0YBmRdlGxpAHeY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SuVzllmYSRfquuJcDcRWnc0GHSPtFNyp26AyBluVbJ0up4tbRtITWjDNuKs1XeKsj
	 9unRV1rYyOv2gxNp3rc+jY9sEkrRoqVZBHFucwYGOw+cZtDcO5G4HtfEKacdVyOA5g
	 6mlURbCvBUcRD04eBHxPfjMS/Igzp8+knm7PD62kn5RYL66jlTq5s1KxPqTq4ABeHL
	 J7gn1nDulWyl0ZYRxhgciUY+N6bzgokG2U4wmuyIXgq6xnWCSKMrB/TqQkHYeFuDg7
	 CGmud4af4+/jP58GUdbsQFpcZukByzTLb1+jCTWsClYve1yVdsTgRE9/fLAmqjluGl
	 t4JqpvDKBOzCw==
Message-ID: <8878dcb7-5f18-4e34-b917-ee5e1ee15cff@kernel.org>
Date: Wed, 29 May 2024 17:00:34 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/12] ubd: untagle discard vs write zeroes not support
 handling
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Josef Bacik
 <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 linux-um@lists.infradead.org, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
References: <20240529050507.1392041-1-hch@lst.de>
 <20240529050507.1392041-2-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240529050507.1392041-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/24 14:04, Christoph Hellwig wrote:
> Discard and Write Zeroes are different operation and implemented
> by different fallocate opcodes for ubd.  If one fails the other one
> can work and vice versa.
> 
> Split the code to disable the operations in ubd_handler to only
> disable the operation that actually failed.
> 
> Fixes: 50109b5a03b4 ("um: Add support for DISCARD in the UBD Driver")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/um/drivers/ubd_kern.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
> index ef805eaa9e013d..a79a3b7c33a647 100644
> --- a/arch/um/drivers/ubd_kern.c
> +++ b/arch/um/drivers/ubd_kern.c
> @@ -471,9 +471,14 @@ static void ubd_handler(void)
>  		for (count = 0; count < n/sizeof(struct io_thread_req *); count++) {
>  			struct io_thread_req *io_req = (*irq_req_buffer)[count];
>  
> -			if ((io_req->error == BLK_STS_NOTSUPP) && (req_op(io_req->req) == REQ_OP_DISCARD)) {
> -				blk_queue_max_discard_sectors(io_req->req->q, 0);
> -				blk_queue_max_write_zeroes_sectors(io_req->req->q, 0);
> +			if (io_req->error == BLK_STS_NOTSUPP) {
> +				struct request_queue *q = io_req->req->q;
> +
> +				if (req_op(io_req->req) == REQ_OP_DISCARD)
> +					blk_queue_max_discard_sectors(q, 0);
> +				if (req_op(io_req->req) == REQ_OP_WRITE_ZEROES)

Nit: this can be an "else if".

Otherwise, looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> +					blk_queue_max_write_zeroes_sectors(q,
> +							0);
>  			}
>  			blk_mq_end_request(io_req->req, io_req->error);
>  			kfree(io_req);

-- 
Damien Le Moal
Western Digital Research


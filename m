Received: from www.kot-begemot.co.uk (ns1.kot-begemot.co.uk [217.160.28.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62F9ECC;
	Fri, 14 Jun 2024 07:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.160.28.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718350236; cv=none; b=SrGiFoFQl6YVBms1ErarXkYSNVigcsiPeokSs3bvEHRfofesEQLIa/MQULPTkpSZ2hCLRBbV7Xoh2QY+r/6L44PqW0TTAUCIIx4EmJAfEmAR9scMb8y7lYvdgk2ZuSzTUAyozowkpmNkPaHJv0rp5kWa1jwsSjDmC0u8wdYnhZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718350236; c=relaxed/simple;
	bh=oLtasVYWOKLHBL3D/xrVIOFLQfLSJvF9p1FP70GLEgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bg3iy3D+OAhANy+pQjvXWzz1WzUIh4ND6t7aaPn5PZ1iZnaTyAsPawlF5WIIJ/l7qJhCbOE1FAFFqqL1LBL0PsHrDy/ib/OK+KtKCtZn7T+rQQkNi2zL+EsusUXWEIWRjNCVZ9Uan/TBbLQv+hRtbqzPIsHESE0fj3TD5lnHEwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cambridgegreys.com; spf=pass smtp.mailfrom=cambridgegreys.com; arc=none smtp.client-ip=217.160.28.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cambridgegreys.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cambridgegreys.com
Received: from [192.168.17.6] (helo=jain.kot-begemot.co.uk)
	by www.kot-begemot.co.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <anton.ivanov@cambridgegreys.com>)
	id 1sI1NW-004AyG-4w; Fri, 14 Jun 2024 07:29:42 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
	by jain.kot-begemot.co.uk with esmtp (Exim 4.96)
	(envelope-from <anton.ivanov@cambridgegreys.com>)
	id 1sI1NT-000Wne-0I;
	Fri, 14 Jun 2024 08:29:41 +0100
Message-ID: <b9909e61-7fc2-4d10-8000-d23b7def93de@cambridgegreys.com>
Date: Fri, 14 Jun 2024 08:29:38 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/14] ubd: untagle discard vs write zeroes not support
 handling
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
 Johannes Berg <johannes@sipsolutions.net>, Josef Bacik
 <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 linux-um@lists.infradead.org, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org,
 Bart Van Assche <bvanassche@acm.org>, Damien Le Moal <dlemoal@kernel.org>
References: <20240531074837.1648501-1-hch@lst.de>
 <20240531074837.1648501-3-hch@lst.de>
From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
In-Reply-To: <20240531074837.1648501-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett



On 31/05/2024 08:47, Christoph Hellwig wrote:
> Discard and Write Zeroes are different operation and implemented
> by different fallocate opcodes for ubd.  If one fails the other one
> can work and vice versa.
> 
> Split the code to disable the operations in ubd_handler to only
> disable the operation that actually failed.
> 
> Fixes: 50109b5a03b4 ("um: Add support for DISCARD in the UBD Driver")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   arch/um/drivers/ubd_kern.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
> index 0c9542d58c01b7..093c87879d08ba 100644
> --- a/arch/um/drivers/ubd_kern.c
> +++ b/arch/um/drivers/ubd_kern.c
> @@ -449,10 +449,11 @@ static int bulk_req_safe_read(
>   
>   static void ubd_end_request(struct io_thread_req *io_req)
>   {
> -	if (io_req->error == BLK_STS_NOTSUPP &&
> -	    req_op(io_req->req) == REQ_OP_DISCARD) {
> -		blk_queue_max_discard_sectors(io_req->req->q, 0);
> -		blk_queue_max_write_zeroes_sectors(io_req->req->q, 0);
> +	if (io_req->error == BLK_STS_NOTSUPP) {
> +		if (req_op(io_req->req) == REQ_OP_DISCARD)
> +			blk_queue_max_discard_sectors(io_req->req->q, 0);
> +		else if (req_op(io_req->req) == REQ_OP_WRITE_ZEROES)
> +			blk_queue_max_write_zeroes_sectors(io_req->req->q, 0);
>   	}
>   	blk_mq_end_request(io_req->req, io_req->error);
>   	kfree(io_req);
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/

Received: from www.kot-begemot.co.uk (ns1.kot-begemot.co.uk [217.160.28.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0BE1474CB;
	Fri, 14 Jun 2024 08:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.160.28.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718352102; cv=none; b=quJMngRge9PKEoIzzpPeN/InYzQQH4awdsHV78HJrANpQypCYU9PzBxE3TdK8t5NGPcigjtEdEwsa8NVlL3zBtJZKYdXLF6UlZHOdRg6qdBJK5mvCljDfNRi/h+XCCTE/K4IMeJRfqb54dQk9yUdWI9YczF6fbv1RZGfiipcNus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718352102; c=relaxed/simple;
	bh=o6mCE3xjAE4ne3tJGZ1/jXYFyYsP/lO4Ylyx4twrtvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PZwLIfbQM8a2mcngJ0XjJGgm7PagVEP/mPWXDXovE5+UN9GRgfihgVzLnjAiE+KkrZRk5tZpW2gCidMF0nYJ2rSZheUhiW9OmPE30+LmCbvd4Qk2sjvans5k0Ikg4TAW2Ziv1PheKmiDI9DpQucmh+LQCONEAPjNRqsHB6Ysbms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cambridgegreys.com; spf=pass smtp.mailfrom=cambridgegreys.com; arc=none smtp.client-ip=217.160.28.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cambridgegreys.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cambridgegreys.com
Received: from [192.168.17.6] (helo=jain.kot-begemot.co.uk)
	by www.kot-begemot.co.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <anton.ivanov@cambridgegreys.com>)
	id 1sI1MY-004Axd-Js; Fri, 14 Jun 2024 07:28:42 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
	by jain.kot-begemot.co.uk with esmtp (Exim 4.96)
	(envelope-from <anton.ivanov@cambridgegreys.com>)
	id 1sI1MU-000Wne-1M;
	Fri, 14 Jun 2024 08:28:42 +0100
Message-ID: <b15de345-838b-4cbb-a156-22b527ed03b6@cambridgegreys.com>
Date: Fri, 14 Jun 2024 08:28:38 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/14] ubd: refactor the interrupt handler
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
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
References: <20240531074837.1648501-1-hch@lst.de>
 <20240531074837.1648501-2-hch@lst.de>
From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
In-Reply-To: <20240531074837.1648501-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0
X-Spam-Score: -1.0
X-Clacks-Overhead: GNU Terry Pratchett



On 31/05/2024 08:47, Christoph Hellwig wrote:
> Instead of a separate handler function that leaves no work in the
> interrupt hanler itself, split out a per-request end I/O helper and
> clean up the coding style and variable naming while we're at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   arch/um/drivers/ubd_kern.c | 49 ++++++++++++++------------------------
>   1 file changed, 18 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
> index ef805eaa9e013d..0c9542d58c01b7 100644
> --- a/arch/um/drivers/ubd_kern.c
> +++ b/arch/um/drivers/ubd_kern.c
> @@ -447,43 +447,30 @@ static int bulk_req_safe_read(
>   	return n;
>   }
>   
> -/* Called without dev->lock held, and only in interrupt context. */
> -static void ubd_handler(void)
> +static void ubd_end_request(struct io_thread_req *io_req)
>   {
> -	int n;
> -	int count;
> -
> -	while(1){
> -		n = bulk_req_safe_read(
> -			thread_fd,
> -			irq_req_buffer,
> -			&irq_remainder,
> -			&irq_remainder_size,
> -			UBD_REQ_BUFFER_SIZE
> -		);
> -		if (n < 0) {
> -			if(n == -EAGAIN)
> -				break;
> -			printk(KERN_ERR "spurious interrupt in ubd_handler, "
> -			       "err = %d\n", -n);
> -			return;
> -		}
> -		for (count = 0; count < n/sizeof(struct io_thread_req *); count++) {
> -			struct io_thread_req *io_req = (*irq_req_buffer)[count];
> -
> -			if ((io_req->error == BLK_STS_NOTSUPP) && (req_op(io_req->req) == REQ_OP_DISCARD)) {
> -				blk_queue_max_discard_sectors(io_req->req->q, 0);
> -				blk_queue_max_write_zeroes_sectors(io_req->req->q, 0);
> -			}
> -			blk_mq_end_request(io_req->req, io_req->error);
> -			kfree(io_req);
> -		}
> +	if (io_req->error == BLK_STS_NOTSUPP &&
> +	    req_op(io_req->req) == REQ_OP_DISCARD) {
> +		blk_queue_max_discard_sectors(io_req->req->q, 0);
> +		blk_queue_max_write_zeroes_sectors(io_req->req->q, 0);
>   	}
> +	blk_mq_end_request(io_req->req, io_req->error);
> +	kfree(io_req);
>   }
>   
>   static irqreturn_t ubd_intr(int irq, void *dev)
>   {
> -	ubd_handler();
> +	int len, i;
> +
> +	while ((len = bulk_req_safe_read(thread_fd, irq_req_buffer,
> +			&irq_remainder, &irq_remainder_size,
> +			UBD_REQ_BUFFER_SIZE)) >= 0) {
> +		for (i = 0; i < len / sizeof(struct io_thread_req *); i++)
> +			ubd_end_request((*irq_req_buffer)[i]);
> +	}
> +
> +	if (len < 0 && len != -EAGAIN)
> +		pr_err("spurious interrupt in %s, err = %d\n", __func__, len);
>   	return IRQ_HANDLED;
>   }
>   
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/

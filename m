From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 3/4] nvme: use blk_rq_payload_bytes
Date: Tue, 17 Jan 2017 22:06:51 +0200
Message-ID: <7532e18a-6cd3-294f-085d-e1ecdc48af6e@grimberg.me>
References: <1484306953-3194-1-git-send-email-hch@lst.de>
 <1484306953-3194-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1484306953-3194-4-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, Dexuan Cui <decui@microsoft.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


> @@ -1014,9 +1013,9 @@ static int nvme_rdma_map_data(struct nvme_rdma_queue *queue,
>  	}
>

Christoph, a little above here we still look at blk_rq_bytes(),
shouldn't that look at blk_rq_payload_bytes() too?

>  	if (count == 1) {
> -		if (rq_data_dir(rq) == WRITE &&
> -		    map_len <= nvme_rdma_inline_data_size(queue) &&
> -		    nvme_rdma_queue_idx(queue))
> +		if (rq_data_dir(rq) == WRITE && nvme_rdma_queue_idx(queue) &&
> +		    blk_rq_payload_bytes(rq) <=
> +				nvme_rdma_inline_data_size(queue))
>  			return nvme_rdma_map_sg_inline(queue, req, c);
>
>  		if (dev->pd->flags & IB_PD_UNSAFE_GLOBAL_RKEY)

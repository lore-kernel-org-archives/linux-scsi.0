From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/4] block: add blk_rq_payload_bytes
Date: Fri, 13 Jan 2017 12:43:06 +0100
Message-ID: <69e13261-dc68-a3f1-7c57-4d42da78df6c@suse.de>
References: <1484306953-3194-1-git-send-email-hch@lst.de>
 <1484306953-3194-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1484306953-3194-2-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
Cc: Dexuan Cui <decui@microsoft.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 01/13/2017 12:29 PM, Christoph Hellwig wrote:
> Add a helper to calculate the actual data transfer size for special
> payload requests.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/blkdev.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index ff3d774..1ca8e8f 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1000,6 +1000,19 @@ static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
>  	return blk_rq_cur_bytes(rq) >> 9;
>  }
>  
> +/*
> + * Some commands like WRITE SAME have a payload or data transfer size which
> + * is different from the size of the request.  Any driver that supports such
> + * commands using the RQF_SPECIAL_PAYLOAD flag needs to use this helper to
> + * calculate the data transfer size.
> + */
> +static inline unsigned int blk_rq_payload_bytes(struct request *rq)
> +{
> +	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
> +		return rq->special_vec.bv_len;
> +	return blk_rq_bytes(rq);
> +}
> +
>  static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
>  						     int op)
>  {
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

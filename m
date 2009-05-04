From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 04/11] block: implement blk_rq_pos/[cur_]sectors() and
 convert obvious ones
Date: Mon, 04 May 2009 17:45:24 +0400
Message-ID: <49FEF174.6040505@ru.mvista.com>
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241423927-11871-5-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:

> Implement accessors - blk_rq_pos(), blk_rq_sectors() and
> blk_rq_cur_sectors() which return rq->sector, rq->hard_nr_sectors and

    Well, blk_rq_pos() returns rq->hard_sector, not rq->sector, doesn't it?

> rq->hard_cur_sectors respectively and convert direct references of the
> said fields to the accessors.

> This is in preparation of request data length handling cleanup.

> const added to struct request * parameter to accessors as suggested by
> Geert Uytterhoeven.

> [ Impact: cleanup ]

> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Tested-by: Grant Likely <grant.likely@secretlab.ca>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 7ab93d9..b921d91 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -833,13 +833,30 @@ static inline void blk_run_address_space(struct address_space *mapping)
>  extern void blkdev_dequeue_request(struct request *req);
>  
>  /*
> - * blk_end_request() takes bytes instead of sectors as a complete size.
> - * blk_rq_bytes() returns bytes left to complete in the entire request.
> - * blk_rq_cur_bytes() returns bytes left to complete in the current segment.
> + * blk_rq_pos()		: the current sector
> + * blk_rq_bytes()	: bytes left in the entire request
> + * blk_rq_cur_bytes()	: bytes left in the current segment
> + * blk_rq_sectors()	: sectors left in the entire request
> + * blk_rq_cur_sectors()	: sectors left in the current segment
>   */
> +static inline sector_t blk_rq_pos(const struct request *rq)
> +{
> +	return rq->hard_sector;
> +}
> +

[...]

MBR, Sergei

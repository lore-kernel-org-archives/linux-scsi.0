From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 07/18] dm: always defer request allocation to
 the owner of the request_queue
Date: Fri, 27 Jan 2017 11:34:34 -0500
Message-ID: <20170127163434.GA30221@redhat.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485365126-23210-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1485365126-23210-8-git-send-email-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com, Junichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 25 2017 at 12:25pm -0500,
Christoph Hellwig <hch@lst.de> wrote:

> DM already calls blk_mq_alloc_request on the request_queue of the
> underlying device if it is a blk-mq device.  But now that we allow drivers
> to allocate additional data and initialize it ahead of time we need to do
> the same for all drivers.   Doing so and using the new cmd_size
> infrastructure in the block layer greatly simplifies the dm-rq and mpath
> code, and should also make arbitrary combinations of SQ and MQ devices
> with SQ or MQ device mapper tables easily possible as a further step.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Mike Snitzer <snitzer@redhat.com>
...
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index 3f12916..8d06834 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -185,7 +163,7 @@ static void end_clone_bio(struct bio *clone)
>  
>  static struct dm_rq_target_io *tio_from_request(struct request *rq)
>  {
> -	return (rq->q->mq_ops ? blk_mq_rq_to_pdu(rq) : rq->special);
> +	return blk_mq_rq_to_pdu(rq);
>  }

Noticed after further review that it seems a bit weird to have the non
blk-mq support in drivers calling blk_mq_rq_to_pdu().  But I'm not sure
a blk_rq_to_pdu() macro to blk_mq_rq_to_pdu() is the right thing.  What
do you guys think?

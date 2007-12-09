From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 27/28] blk_end_request: changing scsi
 mid-layer for bidi (take 3)
Date: Sun, 09 Dec 2007 11:43:31 +0200
Message-ID: <475BB8C3.9040700@panasas.com>
References: <47555880.9070902@panasas.com>	<20071205.192611.08317167.k-ueda@ct.jp.nec.com>	<4757BFDC.6090502@panasas.com>
	<20071206.144417.41628995.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071206.144417.41628995.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 06 2007 at 21:44 +0200, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> Hi Boaz, Jens,
> 
> On Thu, 06 Dec 2007 11:24:44 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
>>> Index: 2.6.24-rc3-mm2/drivers/scsi/scsi_lib.c
<snip>
>> No I don't like it. The only client left for blk_end_request_callback()
>> is bidi,
> 
> ide-cd (cdrom_newpc_intr) is another client.
> So I can't drop blk_end_request_callback() even if bidi doesn't use it.
> 
It looks like all is needed for the ide-cd case is a flag that says
"don't complete the request". And the call-back is not actually used.
(Inspecting the last: [PATCH 26/28] blk_end_request: changing ide-cd (take 3))
The same exact flag could also help the bidi case. Perhaps have an API
for that?

<snip>
> 
> Index: 2.6.24-rc3-mm2/drivers/scsi/scsi_lib.c
> ===================================================================
> --- 2.6.24-rc3-mm2.orig/drivers/scsi/scsi_lib.c
> +++ 2.6.24-rc3-mm2/drivers/scsi/scsi_lib.c
> @@ -629,28 +629,6 @@ void scsi_run_host_queues(struct Scsi_Ho
>  		scsi_run_queue(sdev->request_queue);
>  }
>  
> -static void scsi_finalize_request(struct scsi_cmnd *cmd, int uptodate)
> -{
> -	struct request_queue *q = cmd->device->request_queue;
> -	struct request *req = cmd->request;
> -	unsigned long flags;
> -
> -	add_disk_randomness(req->rq_disk);
> -
> -	spin_lock_irqsave(q->queue_lock, flags);
> -	if (blk_rq_tagged(req))
> -		blk_queue_end_tag(q, req);
> -
> -	end_that_request_last(req, uptodate);
> -	spin_unlock_irqrestore(q->queue_lock, flags);
> -
> -	/*
> -	 * This will goose the queue request function at the end, so we don't
> -	 * need to worry about launching another command.
> -	 */
> -	scsi_next_command(cmd);
> -}
> -
>  /*
>   * Function:    scsi_end_request()
>   *
> @@ -930,23 +908,25 @@ EXPORT_SYMBOL(scsi_release_buffers);
>  void scsi_end_bidi_request(struct scsi_cmnd *cmd)
>  {
>  	struct request *req = cmd->request;
> +	unsigned int dlen = req->data_len;
> +	unsigned int next_dlen = req->next_rq->data_len;
>  
> -	end_that_request_chunk(req, 1, req->data_len);
>  	req->data_len = scsi_out(cmd)->resid;
> -
> -	end_that_request_chunk(req->next_rq, 1, req->next_rq->data_len);
>  	req->next_rq->data_len = scsi_in(cmd)->resid;
>  
> -	scsi_release_buffers(cmd);
> -
>  	/*
>  	 *FIXME: If ll_rw_blk.c is changed to also put_request(req->next_rq)
> -	 *       in end_that_request_last() then this WARN_ON must be removed.
> +	 *       in blk_end_bidi_request() then this WARN_ON must be removed.
>  	 *       for now, upper-driver must have registered an end_io.
>  	 */
>  	WARN_ON(!req->end_io);
>  
> -	scsi_finalize_request(cmd, 1);
> +	if (blk_end_bidi_request(req, 1, dlen, next_dlen))
> +		/* req has not been completed */
> +		BUG();
> +
> +	scsi_release_buffers(cmd);
> +	scsi_next_command(cmd);
>  }
>  
>  /*
> Index: 2.6.24-rc3-mm2/block/ll_rw_blk.c
> ===================================================================
> --- 2.6.24-rc3-mm2.orig/block/ll_rw_blk.c
> +++ 2.6.24-rc3-mm2/block/ll_rw_blk.c
> @@ -3792,24 +3792,17 @@ static void complete_request(struct requ
>  	if (!list_empty(&rq->queuelist))
>  		blkdev_dequeue_request(rq);
>  
> +	if (blk_bidi_rq(rq) && !rq->end_io)
> +		__blk_put_request(rq->next_rq->q, rq->next_rq);
> +
>  	end_that_request_last(rq, uptodate);
>  }
>  
> -/**
> - * blk_end_request - Helper function for drivers to complete the request.
> - * @rq:       the request being processed
> - * @uptodate: 1 for success, 0 for I/O error, < 0 for specific error
> - * @nr_bytes: number of bytes to complete
> - *
> - * Description:
> - *     Ends I/O on a number of bytes attached to @rq.
> - *     If @rq has leftover, sets it up for the next range of segments.
> - *
> - * Return:
> - *     0 - we are done with this request
> - *     1 - still buffers pending for this request
> - **/
> -int blk_end_request(struct request *rq, int uptodate, int nr_bytes)
> +/*
> + * Internal function
> + */
> +static int blk_end_io(struct request *rq, int uptodate, int nr_bytes,
> +		      int bidi_bytes, int (drv_callback)(struct request *))
>  {
>  	struct request_queue *q = rq->q;
>  	unsigned long flags = 0UL;
> @@ -3817,8 +3810,17 @@ int blk_end_request(struct request *rq, 
>  	if (blk_fs_request(rq) || blk_pc_request(rq)) {
>  		if (__end_that_request_first(rq, uptodate, nr_bytes))
>  			return 1;
> +
> +		/* Bidi request must be completed as a whole */
> +		if (blk_bidi_rq(rq) &&
> +		    __end_that_request_first(rq->next_rq, uptodate, bidi_bytes))
> +			return 1;
>  	}
>  
> +	/* Special feature for tricky drivers */
> +	if (drv_callback && drv_callback(rq))
> +		return 1;
> +
>  	add_disk_randomness(rq->rq_disk);
>  
>  	spin_lock_irqsave(q->queue_lock, flags);
> @@ -3827,6 +3829,32 @@ int blk_end_request(struct request *rq, 
>  
>  	return 0;
>  }
> +
> +int blk_end_bidi_request(struct request *rq, int uptodate, int nr_bytes,
> +			 int bidi_bytes)
> +{
> +	return blk_end_io(rq, uptodate, nr_bytes, bidi_bytes, NULL);
> +}
> +EXPORT_SYMBOL_GPL(blk_end_bidi_request);
> +
> +/**
> + * blk_end_request - Helper function for drivers to complete the request.
> + * @rq:       the request being processed
> + * @uptodate: 1 for success, 0 for I/O error, < 0 for specific error
> + * @nr_bytes: number of bytes to complete
> + *
> + * Description:
> + *     Ends I/O on a number of bytes attached to @rq.
> + *     If @rq has leftover, sets it up for the next range of segments.
> + *
> + * Return:
> + *     0 - we are done with this request
> + *     1 - still buffers pending for this request
> + **/
> +int blk_end_request(struct request *rq, int uptodate, int nr_bytes)
> +{
> +	return blk_end_io(rq, uptodate, nr_bytes, 0, NULL);
> +}
>  EXPORT_SYMBOL_GPL(blk_end_request);
>  

All above looks fine, thanks.

>  /**
> @@ -3878,25 +3906,7 @@ EXPORT_SYMBOL_GPL(__blk_end_request);
>  int blk_end_request_callback(struct request *rq, int uptodate, int nr_bytes,
>  			     int (drv_callback)(struct request *))
>  {
> -	struct request_queue *q = rq->q;
> -	unsigned long flags = 0UL;
> -
> -	if (blk_fs_request(rq) || blk_pc_request(rq)) {
> -		if (__end_that_request_first(rq, uptodate, nr_bytes))
> -			return 1;
> -	}
> -
> -	/* Special feature for tricky drivers */
> -	if (drv_callback && drv_callback(rq))
> -		return 1;
> -
> -	add_disk_randomness(rq->rq_disk);
> -
> -	spin_lock_irqsave(q->queue_lock, flags);
> -	complete_request(rq, uptodate);
> -	spin_unlock_irqrestore(q->queue_lock, flags);
> -
> -	return 0;
> +	return blk_end_io(rq, uptodate, nr_bytes, 0, drv_callback);
>  }
>  EXPORT_SYMBOL_GPL(blk_end_request_callback);
>  

Boaz

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 27/28] blk_end_request: changing scsi
 mid-layer for bidi (take 3)
Date: Thu, 06 Dec 2007 11:24:44 +0200
Message-ID: <4757BFDC.6090502@panasas.com>
References: <20071130.183512.120442861.k-ueda@ct.jp.nec.com>	<47555880.9070902@panasas.com>
	<20071205.192611.08317167.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071205.192611.08317167.k-ueda@ct.jp.nec.com>
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

On Thu, Dec 06 2007 at 2:26 +0200, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> Hi Boaz,
> 
> On Tue, 04 Dec 2007 15:39:12 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
>> On Sat, Dec 01 2007 at 1:35 +0200, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
>>> This patch converts bidi of scsi mid-layer to use blk_end_request().
>>>
>>> rq->next_rq represents a pair of bidi requests.
>>> (There are no other use of 'next_rq' of struct request.)
>>> For both requests in the pair, end_that_request_chunk() should be
>>> called before end_that_request_last() is called for one of them.
>>> Since the calls to end_that_request_first()/chunk() and
>>> end_that_request_last() are packaged into blk_end_request(),
>>> the handling of next_rq completion has to be moved into
>>> blk_end_request(), too.
>>>
>>> Bidi sets its specific value to rq->data_len before the request is
>>> completed so that upper-layer can read it.
>>> This setting must be between end_that_request_chunk() and
>>> end_that_request_last(), because rq->data_len may be used
>>> in end_that_request_chunk() by blk_trace and so on.
>>> To satisfy the requirement, use blk_end_request_callback() which
>>> is added in PATCH 25 only for the tricky drivers.
>>>
>>> If bidi didn't reuse rq->data_len and added new members to request
>>> for the specific value, it could set before end_that_request_chunk()
>>> and use the standard blk_end_request() like below.
>>>
>>> void scsi_end_bidi_request(struct scsi_cmnd *cmd)
>>> {
>>> 	struct request *req = cmd->request;
>>>
>>> 	rq->resid = scsi_out(cmd)->resid;
>>> 	rq->next_rq->resid = scsi_in(cmd)->resid;
>>>
>>> 	if (blk_end_request(req, 1, req->data_len))
>>> 		BUG();
>>>
>>> 	scsi_release_buffers(cmd);
>>> 	scsi_next_command(cmd);
>>> }
> ...
> snip
> ...
>> rq->data_len = scsi_out(cmd)->resid is Not Just a problem of bidi
>> it is a General problem of scsi residual handling, and user code.
>>
>> Even today before any bidi. at scsi_lib.c at scsi_io_completion()
>> we do req->data_len = scsi_get_resid(cmd);
>> ( or: req->data_len = cmd->resid; depends which version you look)
>> And then call scsi_end_request() which calls __end_that_request_first/last
>> So it is assumed even today that req->data_len is not touched by
>> __end_that_request_first/last unless __end_that_request_first returned
>> that there is more work to do and the command is resubmitted in which
>> case the resid information is discarded.
>>
>> So if the regular resid handling is acceptable - Set req->data_len
>> before the call to __end_that_request_first/last, or blk_end_request()
>> in your case, then here goes your second client of the _callback and
>> it can be removed.
>> But if it is found that req->data_len is touched and the resid information
>> gets lost, than it should be fixed for the common uni-io case, by - for example
>> - pass resid to the blk_end_request() function.
>> (So in any way the _callback can go)
> 
> Thank you for the explanation of scsi's rq->data_len usage.
> I see that scsi usually uses rq->data_len for cmd->resid.
> 
> I have investigated the possibility of setting data_len before
> the call to blk_end_request.
> But no matter whether data_len is touched or not, we need a callback
> for bidi.  So I would like to go with the current patch.
> 
> I explained the reason and some details below.
> 
> 
> As far as I can see, rq->data_len is just referenced
> by blk_add_trace_rq() in __end_that_request_first(), not modified.
> And I don't change any logic around there in the block-layer.
> So there shouldn't be any critical problem for scsi residual handing.
> (although I'm not sure that scsi expectes cmd->resid to be traced
>  by blk_trace.)
> 
> Anyway, I see that it is no critical problem for bidi to set cmd->resid
> to rq->data_len before blk_end_request() call.
> But if I do that, blk_end_request() can't get the next_rq's size
> to complete in its code below.
> 
>> +		/* Bidi request must be completed as a whole */
>> +		if (blk_bidi_rq(rq) &&
>> +		    __end_that_request_first(rq->next_rq, uptodate,
>> +					     blk_rq_bytes(rq->next_rq)))
>> +			return 1;
> 
> So I will have to move next_rq completion to bidi and use _callback()
> anyway like the following.
> ---------------------------------------------------------------------
> static int dummy_cb(struct request *rq)
> {
> 	return 1;
> }
> 
> void scsi_end_bidi_request(struct scsi_cmnd *cmd)
> {
>  	struct request *req = cmd->request;
> 	unsigned int dlen = req->data_len;
> 	unsigned int next_dlen = req->next_rq->data_len;
>  
>  	req->data_len = scsi_out(cmd)->resid;
>  	req->next_rq->data_len = scsi_in(cmd)->resid;
>  
> 	/* Complete only DATA of next_rq using _callback and dummy function */
> 	if (!blk_end_request_callback(req->next_rq, 1, next_dlen, dummy_cb))
> 		BUG();
>  
> 	if (blk_end_request(req, 1, dlen))
> 		BUG();
> 
> 	scsi_release_buffers(cmd);
> 	scsi_next_command(cmd);
> }
> ---------------------------------------------------------------------
> 
> I prefer the current patch rather than the code like above,
> since the code calls blk_end_request twice and looks trickier.
> So I'd like to leave the patch but descriptions and comments in it.
> Below is the patch, which updated only descriptions and comments.
> If you still have some concerns on this, please let me know.
> 
> 
> 
> Subject: [PATCH 27/28] blk_end_request: changing scsi mid-layer for bidi (take 3)
> 
> This patch converts bidi of scsi mid-layer to use blk_end_request
> interfaces.
> 
> rq->next_rq represents a pair of bidi requests.
> (There are no other use of 'next_rq' of struct request.)
> For both requests in the pair, end_that_request_chunk() should be
> called before end_that_request_last() is called for one of them.
> Since the calls to end_that_request_first()/chunk() and
> end_that_request_last() are packaged into blk_end_request(),
> the handling of next_rq completion has to be moved into
> blk_end_request(), too.
> 
> Since blk_end_request() family don't have any argument for
> the completion size of next_rq, they use next_rq->data_len for it.
> So bidi has to set the resid after blk_end_request() completes
> the data of next_rq.
> To satisfy the requirement, bidi uses blk_end_request_callback(),
> which is added in PATCH 25 only for the tricky drivers.
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> ---
>  block/ll_rw_blk.c       |   18 +++++++++++++
>  drivers/scsi/scsi_lib.c |   62 +++++++++++++++++++++++-------------------------
>  2 files changed, 48 insertions(+), 32 deletions(-)
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
> @@ -921,6 +899,20 @@ void scsi_release_buffers(struct scsi_cm
>  EXPORT_SYMBOL(scsi_release_buffers);
>  
>  /*
> + * Called from blk_end_request_callback() after all DATA in rq and its next_rq
> + * are completed before rq is completed/freed.
> + */
> +static int scsi_end_bidi_request_cb(struct request *rq)
> +{
> +	struct scsi_cmnd *cmd = rq->special;
> +
> +	rq->data_len = scsi_out(cmd)->resid;
> +	rq->next_rq->data_len = scsi_in(cmd)->resid;
> +
> +	return 0;
> +}
> +
> +/*
>   * Bidi commands Must be complete as a whole, both sides at once.
>   * If part of the bytes were written and lld returned
>   * scsi_in()->resid and/or scsi_out()->resid this information will be left
> @@ -931,22 +923,28 @@ void scsi_end_bidi_request(struct scsi_c
>  {
>  	struct request *req = cmd->request;
>  
> -	end_that_request_chunk(req, 1, req->data_len);
> -	req->data_len = scsi_out(cmd)->resid;
> -
> -	end_that_request_chunk(req->next_rq, 1, req->next_rq->data_len);
> -	req->next_rq->data_len = scsi_in(cmd)->resid;
> -
> -	scsi_release_buffers(cmd);
> -
>  	/*
>  	 *FIXME: If ll_rw_blk.c is changed to also put_request(req->next_rq)
> -	 *       in end_that_request_last() then this WARN_ON must be removed.
> +	 *       in blk_end_request() then this WARN_ON must be removed.
>  	 *       for now, upper-driver must have registered an end_io.
>  	 */
>  	WARN_ON(!req->end_io);
>  
> -	scsi_finalize_request(cmd, 1);
> +	/*
> +	 * blk_end_request() family take care of data completion of next_rq.
> +	 * blk_end_request() family use next_rq->data_len for 
> +	 * the completion data size of next_rq.
> +	 * So resid can't be set before the data completion of next_rq
> +	 * in blk_end_request().
> +	 * To resolve that, use the callback feature of blk_end_request().
> +	 */
> +	if (blk_end_request_callback(req, 1, req->data_len,
> +				     scsi_end_bidi_request_cb))
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
> @@ -3817,6 +3817,12 @@ int blk_end_request(struct request *rq, 
>  	if (blk_fs_request(rq) || blk_pc_request(rq)) {
>  		if (__end_that_request_first(rq, uptodate, nr_bytes))
>  			return 1;
> +
> +		/* Bidi request must be completed as a whole */
> +		if (blk_bidi_rq(rq) &&
> +		    __end_that_request_first(rq->next_rq, uptodate,
> +					     blk_rq_bytes(rq->next_rq)))
> +			return 1;
>  	}
>  
>  	add_disk_randomness(rq->rq_disk);
> @@ -3840,6 +3846,12 @@ int __blk_end_request(struct request *rq
>  	if (blk_fs_request(rq) || blk_pc_request(rq)) {
>  		if (__end_that_request_first(rq, uptodate, nr_bytes))
>  			return 1;
> +
> +		/* Bidi request must be completed as a whole */
> +		if (blk_bidi_rq(rq) &&
> +		    __end_that_request_first(rq->next_rq, uptodate,
> +					     blk_rq_bytes(rq->next_rq)))
> +			return 1;
>  	}
>  
>  	add_disk_randomness(rq->rq_disk);
> @@ -3884,6 +3896,12 @@ int blk_end_request_callback(struct requ
>  	if (blk_fs_request(rq) || blk_pc_request(rq)) {
>  		if (__end_that_request_first(rq, uptodate, nr_bytes))
>  			return 1;
> +
> +		/* Bidi request must be completed as a whole */
> +		if (blk_bidi_rq(rq) &&
> +		    __end_that_request_first(rq->next_rq, uptodate,
> +					     blk_rq_bytes(rq->next_rq)))
> +			return 1;
>  	}
>  
>  	/* Special feature for tricky drivers */
> 
> Thanks,
> Kiyoshi Ueda
No I don't like it. The only client left for blk_end_request_callback()
is bidi, and for bidi we can do a much simpler thing. listed below 
are some possible solutions.

1. Take extra parm to blk_end_request like
int blk_end_request(struct request *rq, int error, int nr_bytes, int bidi_bytes)

if the bidi_bytes is not zero than req->next_req is freed like above.

2. My original suggestion of keeping end_that_request_first() exported Just for the
bidi case. Or rename it to:
int blk_end_bidi_req(struct request *rq, int nr_bytes)
{
	return __end_that_request_first(rq->next_rq, 0, /* 0 is the new API for uptodate */
					     nr_bytes);
}

Or some other variation of the 2 above ...
------

And please reconsider that double implementation. (triple above, but I hope
now I have convinced you to drop one). Jense please ?

Boaz

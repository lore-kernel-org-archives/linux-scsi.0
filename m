From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/1] libosd: Fix blk_put_request locking again
Date: Thu, 03 Dec 2009 10:59:56 +0200
Message-ID: <4B177E0C.60407@panasas.com>
References: <4B15367C.9040405@panasas.com> <4B1537F5.6050600@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:22848 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754541AbZLCI7x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2009 03:59:53 -0500
In-Reply-To: <4B1537F5.6050600@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Vineet Agarwal <checkout.vineet@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On 12/01/2009 05:36 PM, Boaz Harrosh wrote:
> 
> So libosd has decided to sacrifice some code simplicity for the sake of
> a clean API. One of these things is the possibility for users to call
> osd_end_request, in any condition at any state. This opens up some
> problems with calling blk_put_request when out-side of the completion
> callback but calling __blk_put_request when detecting a from-completion
> state.
> 
> The current hack was working just fine until exofs decided to operate on
> all devices in parallel and wait for the sum of the requests, before
> deallocating all osd-requests at once. There are two new possible cases
> 1. All request in a group are deallocated as part of the last request's
>    async-done, request_queue is locked.
> 2. All request in a group where executed asynchronously, but
>    de-allocation was delayed to after the async-done, in the context of
>    another thread. Async execution but request_queue is not locked.
> 
> The solution I chose was to separate the deallocation of the osd_request
> which has the information users need, from the deallocation of the
> internal(2) requests which impose the locking problem. The internal
> block-requests are freed unconditionally inside the async-done-callback,
> when we know the queue is always locked. If at osd_end_request time we
> still have a bock-request, then we know it did not come from within an
> async-done-callback and we can call the regular blk_put_request.
> 
> The internal requests were used for carrying error information after
> execution. This information is now copied to osd_request members for
> later analysis by user code.
> 
> The external API and behaviour was unchanged, except now it really
> supports what was previously advertised.
> 
> Reported-by: Vineet Agarwal <checkout.vineet@gmail.com>
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

James Hi

Linus has locked the 2.6.32 Kernel. I absolutely must have this patch
submitted in this merge window. The all of exofs patches depend on it.
Please submit ASAP

Boaz

> ---
>  drivers/scsi/osd/osd_initiator.c |   88 ++++++++++++++++++++------------------
>  include/scsi/osd_initiator.h     |    5 +-
>  2 files changed, 50 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index 950202a..2422347 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -432,30 +432,23 @@ static void _osd_free_seg(struct osd_request *or __unused,
>  	seg->alloc_size = 0;
>  }
>  
> -static void _put_request(struct request *rq , bool is_async)
> +static void _put_request(struct request *rq)
>  {
> -	if (is_async) {
> -		WARN_ON(rq->bio);
> -		__blk_put_request(rq->q, rq);
> -	} else {
> -		/*
> -		 * If osd_finalize_request() was called but the request was not
> -		 * executed through the block layer, then we must release BIOs.
> -		 * TODO: Keep error code in or->async_error. Need to audit all
> -		 *       code paths.
> -		 */
> -		if (unlikely(rq->bio))
> -			blk_end_request(rq, -ENOMEM, blk_rq_bytes(rq));
> -		else
> -			blk_put_request(rq);
> -	}
> +	/*
> +	 * If osd_finalize_request() was called but the request was not
> +	 * executed through the block layer, then we must release BIOs.
> +	 * TODO: Keep error code in or->async_error. Need to audit all
> +	 *       code paths.
> +	 */
> +	if (unlikely(rq->bio))
> +		blk_end_request(rq, -ENOMEM, blk_rq_bytes(rq));
> +	else
> +		blk_put_request(rq);
>  }
>  
>  void osd_end_request(struct osd_request *or)
>  {
>  	struct request *rq = or->request;
> -	/* IMPORTANT: make sure this agrees with osd_execute_request_async */
> -	bool is_async = (or->request->end_io_data == or);
>  
>  	_osd_free_seg(or, &or->set_attr);
>  	_osd_free_seg(or, &or->enc_get_attr);
> @@ -463,20 +456,34 @@ void osd_end_request(struct osd_request *or)
>  
>  	if (rq) {
>  		if (rq->next_rq) {
> -			_put_request(rq->next_rq, is_async);
> +			_put_request(rq->next_rq);
>  			rq->next_rq = NULL;
>  		}
>  
> -		_put_request(rq, is_async);
> +		_put_request(rq);
>  	}
>  	_osd_request_free(or);
>  }
>  EXPORT_SYMBOL(osd_end_request);
>  
> +static void _set_error_resid(struct osd_request *or, struct request *req,
> +			     int error)
> +{
> +	or->async_error = error;
> +	or->req_errors = req->errors ? : error;
> +	or->sense_len = req->sense_len;
> +	if (or->out.req)
> +		or->out.residual = or->out.req->resid_len;
> +	if (or->in.req)
> +		or->in.residual = or->in.req->resid_len;
> +}
> +
>  int osd_execute_request(struct osd_request *or)
>  {
> -	return or->async_error =
> -			blk_execute_rq(or->request->q, NULL, or->request, 0);
> +	int error = blk_execute_rq(or->request->q, NULL, or->request, 0);
> +
> +	_set_error_resid(or, or->request, error);
> +	return error;
>  }
>  EXPORT_SYMBOL(osd_execute_request);
>  
> @@ -484,15 +491,17 @@ static void osd_request_async_done(struct request *req, int error)
>  {
>  	struct osd_request *or = req->end_io_data;
>  
> -	or->async_error = error;
> -
> -	if (unlikely(error)) {
> -		OSD_DEBUG("osd_request_async_done error recieved %d "
> -			  "errors 0x%x\n", error, req->errors);
> -		if (!req->errors) /* don't miss out on this one */
> -			req->errors = error;
> +	_set_error_resid(or, req, error);
> +	if (req->next_rq) {
> +		__blk_put_request(req->q, req->next_rq);
> +		req->next_rq = NULL;
>  	}
>  
> +	__blk_put_request(req->q, req);
> +	or->request = NULL;
> +	or->in.req = NULL;
> +	or->out.req = NULL;
> +
>  	if (or->async_done)
>  		or->async_done(or, or->async_private);
>  	else
> @@ -1489,21 +1498,18 @@ int osd_req_decode_sense_full(struct osd_request *or,
>  #endif
>  	int ret;
>  
> -	if (likely(!or->request->errors)) {
> -		osi->out_resid = 0;
> -		osi->in_resid = 0;
> +	if (likely(!or->req_errors))
>  		return 0;
> -	}
>  
>  	osi = osi ? : &local_osi;
>  	memset(osi, 0, sizeof(*osi));
>  
> -	ssdb = or->request->sense;
> -	sense_len = or->request->sense_len;
> +	ssdb = (typeof(ssdb))or->sense;
> +	sense_len = or->sense_len;
>  	if ((sense_len < (int)sizeof(*ssdb) || !ssdb->sense_key)) {
>  		OSD_ERR("Block-layer returned error(0x%x) but "
>  			"sense_len(%u) || key(%d) is empty\n",
> -			or->request->errors, sense_len, ssdb->sense_key);
> +			or->req_errors, sense_len, ssdb->sense_key);
>  		goto analyze;
>  	}
>  
> @@ -1525,7 +1531,7 @@ int osd_req_decode_sense_full(struct osd_request *or,
>  			"additional_code=0x%x async_error=%d errors=0x%x\n",
>  			osi->key, original_sense_len, sense_len,
>  			osi->additional_code, or->async_error,
> -			or->request->errors);
> +			or->req_errors);
>  
>  	if (original_sense_len < sense_len)
>  		sense_len = original_sense_len;
> @@ -1695,10 +1701,10 @@ analyze:
>  		ret = -EIO;
>  	}
>  
> -	if (or->out.req)
> -		osi->out_resid = or->out.req->resid_len ?: or->out.total_bytes;
> -	if (or->in.req)
> -		osi->in_resid = or->in.req->resid_len ?: or->in.total_bytes;
> +	if (!or->out.residual)
> +		or->out.residual = or->out.total_bytes;
> +	if (!or->in.residual)
> +		or->in.residual = or->in.total_bytes;
>  
>  	return ret;
>  }
> diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
> index 39d6d10..a8f3701 100644
> --- a/include/scsi/osd_initiator.h
> +++ b/include/scsi/osd_initiator.h
> @@ -142,6 +142,7 @@ struct osd_request {
>  	struct _osd_io_info {
>  		struct bio *bio;
>  		u64 total_bytes;
> +		u64 residual;
>  		struct request *req;
>  		struct _osd_req_data_segment *last_seg;
>  		u8 *pad_buff;
> @@ -150,12 +151,14 @@ struct osd_request {
>  	gfp_t alloc_flags;
>  	unsigned timeout;
>  	unsigned retries;
> +	unsigned sense_len;
>  	u8 sense[OSD_MAX_SENSE_LEN];
>  	enum osd_attributes_mode attributes_mode;
>  
>  	osd_req_done_fn *async_done;
>  	void *async_private;
>  	int async_error;
> +	int req_errors;
>  };
>  
>  static inline bool osd_req_is_ver1(struct osd_request *or)
> @@ -297,8 +300,6 @@ enum osd_err_priority {
>  };
>  
>  struct osd_sense_info {
> -	u64 out_resid;		/* Zero on success otherwise out residual */
> -	u64 in_resid;		/* Zero on success otherwise in residual */
>  	enum osd_err_priority osd_err_pri;
>  
>  	int key;		/* one of enum scsi_sense_keys */


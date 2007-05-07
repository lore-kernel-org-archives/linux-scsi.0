From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH 0/2] bidi support
Date: Mon, 07 May 2007 09:05:37 +0300
Message-ID: <463EC1B1.1060408@panasas.com>
References: <200705050902.l4592YeE009469@mbox.iij4u.or.jp> <200705050924.l459Oo2M020018@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:52024 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754044AbXEGGHV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 02:07:21 -0400
In-Reply-To: <200705050924.l459Oo2M020018@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

Tomo,

Thanks for quickly crafting this patchset.
Please see my comments in-line below.

Putting aside the controversial design issues,
we need to carefully compare our patches against yours
to make sure no functional issues have been overlooked.

Benny

FUJITA Tomonori wrote:
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH 0/2] bidi support
> Date: Sat, 05 May 2007 18:02:29 +0900
> 
>> This patchset add bidi support for block pc requests.
> 
> Oh, this patchset is against Linus' tree.
> 
> The first patch (the block layer changes) can be applied against Jens'
> tree.
> 
> The second patch (the scsi mid-layer changes) has one minor reject
> against the scsi-misc tree. The following patch is against the
> scsi-misc.
> 
> ---
> From 6a8c5375f1f6dbd574107920dd0a613527bd556b Mon Sep 17 00:00:00 2001
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Sat, 5 May 2007 18:11:42 +0900
> Subject: [PATCH] add bidi support for block pc requests
> 
> This adds bidi support for block pc requests.
> 
> A bidi request uses req->next_rq pointer for an in request.
> 
> This patch introduces a new structure, scsi_data_buffer to hold the
> data buffer information. To avoid make scsi_cmnd structure fatter, the
> scsi mid-layer uses cmnd->request->next_rq->special pointer for
> a scsi_data_buffer structure. LLDs don't touch the second request
> (req->next_rq) so it's safe to use req->special.
> 
> scsi_blk_pc_done() always completes the whole command so
> scsi_end_request() simply completes the bidi chunk too.
> 
> A helper function, scsi_bidi_data_buffer() is for LLDs to access to
> the scsi_data_buffer structure easily.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/scsi_lib.c  |  120 +++++++++++++++++++++++++++++++++++++++------
>  include/scsi/scsi_cmnd.h |   14 +++++
>  2 files changed, 118 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index be8e655..8f7873a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -66,6 +66,12 @@ #undef SP
>  
>  static void scsi_run_queue(struct request_queue *q);
>  
> +struct scsi_data_buffer *scsi_bidi_data_buffer(struct scsi_cmnd *cmd)
> +{
> +	return blk_bidi_rq(cmd->request) ? cmd->request->next_rq->special : NULL;
> +}
> +EXPORT_SYMBOL(scsi_bidi_data_buffer);
> +
>  /*
>   * Function:	scsi_unprep_request()
>   *
> @@ -85,6 +91,7 @@ static void scsi_unprep_request(struct r
>  	req->cmd_flags &= ~REQ_DONTPREP;
>  	req->special = NULL;
>  
> +	kfree(scsi_bidi_data_buffer(cmd));
>  	scsi_put_command(cmd);
>  }
>  
> @@ -657,6 +664,7 @@ static struct scsi_cmnd *scsi_end_reques
>  	request_queue_t *q = cmd->device->request_queue;
>  	struct request *req = cmd->request;
>  	unsigned long flags;
> +	struct scsi_data_buffer *sdb = scsi_bidi_data_buffer(cmd);
>  
>  	/*
>  	 * If there are blocks left over at the end, set up the command
> @@ -685,6 +693,14 @@ static struct scsi_cmnd *scsi_end_reques
>  		}
>  	}
>  
> +	/*
> +	 * a REQ_BLOCK_PC command is always completed fully so just do
> +	 * end the bidi chunk.
> +	 */
> +	if (sdb)
> +		end_that_request_chunk(req->next_rq, uptodate,
> +				       sdb->request_bufflen);

I think I agree you shouldn't call end_that_request_last(req->next_rq)
so sdb and req->next_rq should be freed here, no?

> +
>  	add_disk_randomness(req->rq_disk);
>  
>  	spin_lock_irqsave(q->queue_lock, flags);
> @@ -701,34 +717,35 @@ static struct scsi_cmnd *scsi_end_reques
>  	return NULL;
>  }
>  
> -struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
> +static struct scatterlist *do_scsi_alloc_sgtable(unsigned short use_sg,
> +						 unsigned short *sglist_len,
> +						 gfp_t gfp_mask)
>  {
>  	struct scsi_host_sg_pool *sgp;
> -	struct scatterlist *sgl;
>  
> -	BUG_ON(!cmd->use_sg);
> +	BUG_ON(!use_sg);
>  
> -	switch (cmd->use_sg) {
> +	switch (use_sg) {
>  	case 1 ... 8:
> -		cmd->sglist_len = 0;
> +		*sglist_len = 0;
>  		break;
>  	case 9 ... 16:
> -		cmd->sglist_len = 1;
> +		*sglist_len = 1;
>  		break;
>  	case 17 ... 32:
> -		cmd->sglist_len = 2;
> +		*sglist_len = 2;
>  		break;
>  #if (SCSI_MAX_PHYS_SEGMENTS > 32)
>  	case 33 ... 64:
> -		cmd->sglist_len = 3;
> +		*sglist_len = 3;
>  		break;
>  #if (SCSI_MAX_PHYS_SEGMENTS > 64)
>  	case 65 ... 128:
> -		cmd->sglist_len = 4;
> +		*sglist_len = 4;
>  		break;
>  #if (SCSI_MAX_PHYS_SEGMENTS  > 128)
>  	case 129 ... 256:
> -		cmd->sglist_len = 5;
> +		*sglist_len = 5;
>  		break;
>  #endif
>  #endif
> @@ -737,11 +754,14 @@ #endif
>  		return NULL;
>  	}
>  
> -	sgp = scsi_sg_pools + cmd->sglist_len;
> -	sgl = mempool_alloc(sgp->pool, gfp_mask);
> -	return sgl;
> +	sgp = scsi_sg_pools + *sglist_len;
> +	return mempool_alloc(sgp->pool, gfp_mask);
>  }
>  
> +struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
> +{
> +	return do_scsi_alloc_sgtable(cmd->use_sg, &cmd->sglist_len, gfp_mask);
> +}
>  EXPORT_SYMBOL(scsi_alloc_sgtable);
>  
>  void scsi_free_sgtable(struct scatterlist *sgl, int index)
> @@ -775,6 +795,8 @@ EXPORT_SYMBOL(scsi_free_sgtable);
>   */
>  static void scsi_release_buffers(struct scsi_cmnd *cmd)
>  {
> +	struct scsi_data_buffer *sdb = scsi_bidi_data_buffer(cmd);
> +
>  	if (cmd->use_sg)
>  		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
>  
> @@ -784,6 +806,13 @@ static void scsi_release_buffers(struct
>  	 */
>  	cmd->request_buffer = NULL;
>  	cmd->request_bufflen = 0;
> +
> +	if (sdb) {
> +		if (sdb->use_sg)
> +			scsi_free_sgtable(sdb->request_buffer, sdb->sglist_len);
> +		sdb->request_buffer = NULL;
> +		sdb->request_bufflen = 0;
> +	}
>  }
>  
>  /*
> @@ -834,6 +863,7 @@ void scsi_io_completion(struct scsi_cmnd
>  	}
>  
>  	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
> +		struct scsi_data_buffer *sdb = scsi_bidi_data_buffer(cmd);
>  		req->errors = result;
>  		if (result) {
>  			clear_errors = 0;
> @@ -850,6 +880,8 @@ void scsi_io_completion(struct scsi_cmnd
>  			}
>  		}
>  		req->data_len = cmd->resid;
> +		if (sdb)
> +			req->next_rq->data_len = sdb->resid;
>  	}
>  
>  	/*
> @@ -1075,6 +1107,38 @@ static struct scsi_cmnd *scsi_get_cmd_fr
>  	return cmd;
>  }
>  
> +static int scsi_data_buffer_init(struct scsi_cmnd *cmd)
> +{
> +	struct scatterlist *sgpnt;
> +	struct scsi_data_buffer *sdb = scsi_bidi_data_buffer(cmd);
> +	struct request *req = cmd->request;
> +	int count;
> +
> +	sdb->use_sg = req->next_rq->nr_phys_segments;
> +	sgpnt = do_scsi_alloc_sgtable(sdb->use_sg, &sdb->sglist_len,
> +				      GFP_ATOMIC);
> +	if (unlikely(!sgpnt)) {
> +		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
> +		scsi_unprep_request(req);
> +		return BLKPREP_DEFER;
> +	}
> +
> +	req->buffer = NULL;

req->next_rq->buffer = NULL;

no?

> +	sdb->request_buffer = (char *) sgpnt;
> +	sdb->request_bufflen = req->next_rq->data_len;
> +
> +	count = blk_rq_map_sg(req->q, req->next_rq, sgpnt);
> +	if (likely(count <= sdb->use_sg)) {
> +		sdb->use_sg = count;
> +		return BLKPREP_OK;
> +	}
> +
> +	scsi_release_buffers(cmd);

either kfree(sbd) and blk_put_request(req->next_rq) here, or
should that be done in scsi_put_command?
who does that on the error-free path? (see comment above in scsi_end_request)

> +	scsi_put_command(cmd);
> +
> +	return BLKPREP_KILL;
> +}
> +
>  static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
>  {
>  	BUG_ON(!blk_pc_request(cmd->request));
> @@ -1090,10 +1154,21 @@ static void scsi_blk_pc_done(struct scsi
>  static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
>  {
>  	struct scsi_cmnd *cmd;
> +	struct scsi_data_buffer *sdb = NULL;
> +
> +	if (blk_bidi_rq(req)) {
> +		sdb = kzalloc(sizeof(*sdb), GFP_ATOMIC);
> +		if (unlikely(!sdb))
> +			return BLKPREP_DEFER;
> +		req->next_rq->special = sdb;
> +	}
>  
>  	cmd = scsi_get_cmd_from_req(sdev, req);
> -	if (unlikely(!cmd))
> +	if (unlikely(!cmd)) {
> +		req->next_rq->special = NULL;

req->next_rq can be NULL

> +		kfree(sdb);
>  		return BLKPREP_DEFER;
> +	}
>  
>  	/*
>  	 * BLOCK_PC requests may transfer data, in which case they must
> @@ -1109,6 +1184,12 @@ static int scsi_setup_blk_pc_cmnd(struct
>  		ret = scsi_init_io(cmd);
>  		if (unlikely(ret))
>  			return ret;
> +
> +		if (sdb) {
> +			ret = scsi_data_buffer_init(cmd);
> +			if (ret != BLKPREP_OK)
> +				return ret;
> +		}
>  	} else {
>  		BUG_ON(req->data_len);
>  		BUG_ON(req->data);
> @@ -1122,13 +1203,15 @@ static int scsi_setup_blk_pc_cmnd(struct
>  	BUILD_BUG_ON(sizeof(req->cmd) > sizeof(cmd->cmnd));
>  	memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
>  	cmd->cmd_len = req->cmd_len;
> -	if (!req->data_len)
> +	if (sdb)
> +		cmd->sc_data_direction = DMA_BIDIRECTIONAL;
> +	else if (!req->data_len)
>  		cmd->sc_data_direction = DMA_NONE;
>  	else if (rq_data_dir(req) == WRITE)
>  		cmd->sc_data_direction = DMA_TO_DEVICE;
>  	else
>  		cmd->sc_data_direction = DMA_FROM_DEVICE;
> -	
> +
>  	cmd->transfersize = req->data_len;
>  	cmd->allowed = req->retries;
>  	cmd->timeout_per_command = req->timeout;
> @@ -1178,6 +1261,11 @@ static int scsi_prep_fn(struct request_q
>  	struct scsi_device *sdev = q->queuedata;
>  	int ret = BLKPREP_OK;
>  
> +	if (WARN_ON(!blk_pc_request(req) && blk_bidi_rq(req))) {
> +		ret = BLKPREP_KILL;
> +		goto out;
> +	}
> +
>  	/*
>  	 * If the device is not in running state we will reject some
>  	 * or all commands.
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index a2e0c10..597c48c 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -28,6 +28,18 @@ struct scsi_pointer {
>  	volatile int phase;
>  };
>  
> +struct scsi_data_buffer {
> +	unsigned short use_sg;		/* Number of pieces of scatter-gather */
> +	unsigned short sglist_len;	/* size of malloc'd scatter-gather list */
> +	void *request_buffer;		/* Actual requested buffer */
> +	unsigned request_bufflen;	/* Actual request size */
> +	/*
> +	 * Number of bytes requested to be transferred less actual
> +	 * number transferred (0 if not supported)
> +	*/
> +	int resid;
> +};
> +
>  struct scsi_cmnd {
>  	struct scsi_device *device;
>  	struct list_head list;  /* scsi_cmnd participates in queue lists */
> @@ -135,4 +147,6 @@ extern void scsi_kunmap_atomic_sg(void *
>  extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
>  extern void scsi_free_sgtable(struct scatterlist *, int);
>  
> +extern struct scsi_data_buffer *scsi_bidi_data_buffer(struct scsi_cmnd *);
> +
>  #endif /* _SCSI_SCSI_CMND_H */


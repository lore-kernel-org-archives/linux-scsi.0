From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patchset 0/4] osd: Stop usage of blk_rq_append_bio
Date: Sun, 17 May 2009 11:24:40 +0300
Message-ID: <4A0FC9C8.6040907@panasas.com>
References: <4A0307F4.50205@panasas.com> <20090512112539.GH4140@kernel.dk>	 <4A0AD8FA.6030903@panasas.com>  <4A0ADAEF.3040501@panasas.com>	 <1242226048.4728.24.camel@mulgrave.int.hansenpartnership.com>	 <4A0C3086.2010802@panasas.com> <1242315327.11484.2.camel@mulgrave.int.hansenpartnership.com> <4A0C4295.4080101@panasas.com> <4A0C494D.6040803@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:49976 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbZEQIYs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 May 2009 04:24:48 -0400
Received: by fg-out-1718.google.com with SMTP id d23so406745fga.17
        for <linux-scsi@vger.kernel.org>; Sun, 17 May 2009 01:24:47 -0700 (PDT)
In-Reply-To: <4A0C494D.6040803@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On 05/14/2009 07:46 PM, James Bottomley wrote:
> On Thu, 2009-05-14 at 19:11 +0300, Boaz Harrosh wrote:
>> On 05/14/2009 06:35 PM, James Bottomley wrote:
>> <snip>
>>>> I see that you rebased by now, though I suspect the fc's blk_end_request
>>>> call will fail to build if merged with block tree.
>>> Yes, that's the bit we need a postmerge tree for.  It has to build on
>>> it's own in scsi-misc, but it's making use of an API Tejun is altering,
>>> so the block postmerge has to do the API alteration based on the SCSI
>>> tree.
>>>
>> Tejun's cleanup is a bit tricky and cross trees wide. It will need to be
>> completely postponed to post merge which will be a pity since there are
>> so many patches ontop of it in block-next. Unless we want to sacrifice
>> the build ability of the tree between block-merge and the fixup to this driver.
>>
>> Perhaps you could do a scsi-post-merge tree that has only this driver, already
>> with the new needed code?
> 
> If necessary.  However, the disadvantage of doing it this way around is
> that I have to squash together the two patches (FC transport patch and
> the update to tejun's API) otherwise we get a bisection break.
> 
> James

Either, almost the complete block tree together with below patch needs to
be post-merge, rebased over a single scsi-misc patch: "FC Pass Thru"

or a single scsi-misc patch is rebased post-merge over block-tree, yes
with below squashed in.

But merging the trees as they are will cause bisection break from the
second merge to below patch.

So since the block tree is much more code, I'd say squash below and post-
merge the single "FC Pass Thru support" patch.

Tejun, I need your review on this patch have you had a chance to look at it?

Boaz

> 
> Below is a patch that should be squashed into scsi-misc's:
>  [04576e3] [SCSI] FC Pass Thru support
> 
> In order to compile and work ontop of Tejun's block layer revamps,
> in block-next
> 
> Tejun please review, specially the blk_fetch_request bit. Thanks
> 
> Boaz
> ---
> From: Boaz Harrosh <bharrosh@panasas.com>
> Date: Thu, 14 May 2009 19:32:46 +0300
> Subject: [SQUASHME] into: FC Pass Thru support
> 
> This patch should be squashed into
>   [SCSI] FC Pass Thru support
> 
> If it needs to compile after Tejun's block-layer revamps
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/scsi_transport_fc.c |   20 ++++++++------------
>  1 files changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 4df8c3c..41c90fe 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -3409,7 +3409,6 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
>  	struct request *req = job->req;
>  	struct request *rsp = req->next_rq;
>  	unsigned long flags;
> -	unsigned rsp_len = 0, req_len = blk_rq_bytes(req);
>  	int err;
>  
>  	spin_lock_irqsave(&job->job_lock, flags);
> @@ -3425,16 +3424,15 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
>  		job->req->sense_len = job->reply_len;
>  
>  	/* we assume all request payload was transferred, residual == 0 */
> -	req->data_len = 0;
> +	req->resid_len = 0;
>  
>  	if (rsp) {
> -		rsp_len = blk_rq_bytes(rsp);
> -		BUG_ON(job->reply->reply_payload_rcv_len > rsp_len);
>  		/* set reply (bidi) residual */
> -		rsp->data_len = (rsp_len - job->reply->reply_payload_rcv_len);
> +		rsp->resid_len = blk_rq_bytes(rsp) -
> +					job->reply->reply_payload_rcv_len;
>  	}
>  
> -	blk_end_bidi_request(req, err, req_len, rsp_len);
> +	blk_end_request_all(req, err);
>  
>  	fc_destroy_bsgjob(job);
>  }
> @@ -3496,7 +3494,7 @@ fc_bsg_map_buffer(struct fc_bsg_buffer *buf, struct request *req)
>  		return -ENOMEM;
>  	sg_init_table(buf->sg_list, req->nr_phys_segments);
>  	buf->sg_cnt = blk_rq_map_sg(req->q, req, buf->sg_list);
> -	buf->payload_len = req->data_len;
> +	buf->payload_len = blk_rq_bytes(req);
>  	return 0;
>  }
>  
> @@ -3762,14 +3760,12 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
>  		return;
>  
>  	while (!blk_queue_plugged(q)) {
> -		req = elv_next_request(q);
> -		if (!req)
> -			break;
> -
>  		if (rport && (rport->port_state == FC_PORTSTATE_BLOCKED))
>  				break;
>  
> -		blkdev_dequeue_request(req);
> +		req = blk_fetch_request(q);
> +		if (!req)
> +			break;
>  
>  		if (rport && (rport->port_state != FC_PORTSTATE_ONLINE)) {
>  			req->errors = -ENXIO;


From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 2/2] scsi_transport_fc: fix NULL pointer dereference in
 fc_bsg_job_timeout
Date: Fri, 8 Sep 2017 09:29:36 +0800
Message-ID: <20170908012935.GC3802@ming.t460p>
References: <20170907115436.5069-1-hch@lst.de>
 <20170907115436.5069-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170907115436.5069-3-hch@lst.de>
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 07, 2017 at 01:54:36PM +0200, Christoph Hellwig wrote:
> bsg-lib now embeddeds the job structure into the request, and req->special
> can't be used anymore.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/scsi_transport_fc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 892fbd9800d9..bea06de60827 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -3550,7 +3550,7 @@ fc_vport_sched_delete(struct work_struct *work)
>  static enum blk_eh_timer_return
>  fc_bsg_job_timeout(struct request *req)
>  {
> -	struct bsg_job *job = (void *) req->special;
> +	struct bsg_job *job = blk_mq_rq_to_pdu(req);
>  	struct Scsi_Host *shost = fc_bsg_to_shost(job);
>  	struct fc_rport *rport = fc_bsg_to_rport(job);
>  	struct fc_internal *i = to_fc_internal(shost->transportt);
> -- 
> 2.11.0
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

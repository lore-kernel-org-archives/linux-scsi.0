From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 1/2] nvme: untangle 0 and BLK_MQ_RQ_QUEUE_OK
Date: Tue, 15 Nov 2016 14:44:04 -0500
Message-ID: <20161115194404.GA5138@localhost.localdomain>
References: <ec8930a71efdc30f9d5e5c69954f5b10cfab9927.1479236597.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:36398 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751790AbcKOTeB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Nov 2016 14:34:01 -0500
Content-Disposition: inline
In-Reply-To: <ec8930a71efdc30f9d5e5c69954f5b10cfab9927.1479236597.git.osandov@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-block@vger.kernel.org, kernel-team@fb.com, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org

On Tue, Nov 15, 2016 at 11:11:58AM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Let's not depend on any of the BLK_MQ_RQ_QUEUE_* constants having
> specific values. No functional change.
>
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Yeah, we've been depending on the values of BLK_MQ_RQ_QUEUE_[ERROR|BUSY]
not being zero without this. Looks good.

Reviewed-by: Keith Busch <keith.busch@intel.com>

> ---
>  drivers/nvme/host/core.c   | 4 ++--
>  drivers/nvme/host/pci.c    | 8 ++++----
>  drivers/nvme/host/rdma.c   | 2 +-
>  drivers/nvme/target/loop.c | 6 +++---
>  4 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 53584d2..e54bb10 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -269,7 +269,7 @@ static inline int nvme_setup_discard(struct nvme_ns *ns, struct request *req,
>  	 */
>  	req->__data_len = nr_bytes;
>  
> -	return 0;
> +	return BLK_MQ_RQ_QUEUE_OK;
>  }
>  
>  static inline void nvme_setup_rw(struct nvme_ns *ns, struct request *req,
> @@ -317,7 +317,7 @@ static inline void nvme_setup_rw(struct nvme_ns *ns, struct request *req,
>  int nvme_setup_cmd(struct nvme_ns *ns, struct request *req,
>  		struct nvme_command *cmd)
>  {
> -	int ret = 0;
> +	int ret = BLK_MQ_RQ_QUEUE_OK;
>  
>  	if (req->cmd_type == REQ_TYPE_DRV_PRIV)
>  		memcpy(cmd, nvme_req(req)->cmd, sizeof(*cmd));
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index 51d13d5..d58f8e4 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -328,7 +328,7 @@ static int nvme_init_iod(struct request *rq, unsigned size,
>  		rq->retries = 0;
>  		rq->rq_flags |= RQF_DONTPREP;
>  	}
> -	return 0;
> +	return BLK_MQ_RQ_QUEUE_OK;
>  }
>  
>  static void nvme_free_iod(struct nvme_dev *dev, struct request *req)
> @@ -598,17 +598,17 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
>  
>  	map_len = nvme_map_len(req);
>  	ret = nvme_init_iod(req, map_len, dev);
> -	if (ret)
> +	if (ret != BLK_MQ_RQ_QUEUE_OK)
>  		return ret;
>  
>  	ret = nvme_setup_cmd(ns, req, &cmnd);
> -	if (ret)
> +	if (ret != BLK_MQ_RQ_QUEUE_OK)
>  		goto out;
>  
>  	if (req->nr_phys_segments)
>  		ret = nvme_map_data(dev, req, map_len, &cmnd);
>  
> -	if (ret)
> +	if (ret != BLK_MQ_RQ_QUEUE_OK)
>  		goto out;
>  
>  	cmnd.common.command_id = req->tag;
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index c4700ef..ff1b34060 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -1395,7 +1395,7 @@ static int nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
>  			sizeof(struct nvme_command), DMA_TO_DEVICE);
>  
>  	ret = nvme_setup_cmd(ns, rq, c);
> -	if (ret)
> +	if (ret != BLK_MQ_RQ_QUEUE_OK)
>  		return ret;
>  
>  	c->common.command_id = rq->tag;
> diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
> index 26aa3a5..be56d05 100644
> --- a/drivers/nvme/target/loop.c
> +++ b/drivers/nvme/target/loop.c
> @@ -169,7 +169,7 @@ static int nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
>  	int ret;
>  
>  	ret = nvme_setup_cmd(ns, req, &iod->cmd);
> -	if (ret)
> +	if (ret != BLK_MQ_RQ_QUEUE_OK)
>  		return ret;
>  
>  	iod->cmd.common.flags |= NVME_CMD_SGL_METABUF;
> @@ -179,7 +179,7 @@ static int nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
>  		nvme_cleanup_cmd(req);
>  		blk_mq_start_request(req);
>  		nvme_loop_queue_response(&iod->req);
> -		return 0;
> +		return BLK_MQ_RQ_QUEUE_OK;
>  	}
>  
>  	if (blk_rq_bytes(req)) {
> @@ -198,7 +198,7 @@ static int nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
>  	blk_mq_start_request(req);
>  
>  	schedule_work(&iod->work);
> -	return 0;
> +	return BLK_MQ_RQ_QUEUE_OK;
>  }
>  
>  static void nvme_loop_submit_async_event(struct nvme_ctrl *arg, int aer_idx)
> -- 
> 2.10.2
> 
> 
> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme

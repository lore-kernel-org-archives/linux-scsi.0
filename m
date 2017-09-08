From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/2] bsg-lib: don't free job in bsg_prepare_job
Date: Fri, 8 Sep 2017 09:28:52 +0800
Message-ID: <20170908012851.GB3802@ming.t460p>
References: <20170907115436.5069-1-hch@lst.de>
 <20170907115436.5069-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48544 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753103AbdIHB3F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Sep 2017 21:29:05 -0400
Content-Disposition: inline
In-Reply-To: <20170907115436.5069-2-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Thu, Sep 07, 2017 at 01:54:35PM +0200, Christoph Hellwig wrote:
> The job structure is allocated as part of the request, so we should not
> free it in the error path of bsg_prepare_job.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Cc: stable@vger.kernel.org
> ---
>  block/bsg-lib.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/block/bsg-lib.c b/block/bsg-lib.c
> index dd56d7460cb9..c587c71d78af 100644
> --- a/block/bsg-lib.c
> +++ b/block/bsg-lib.c
> @@ -154,7 +154,6 @@ static int bsg_prepare_job(struct device *dev, struct request *req)
>  failjob_rls_rqst_payload:
>  	kfree(job->request_payload.sg_list);
>  failjob_rls_job:
> -	kfree(job);
>  	return -ENOMEM;
>  }
>  
> -- 
> 2.11.0
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

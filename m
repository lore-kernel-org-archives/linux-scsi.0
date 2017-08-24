From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] Improve requeuing behavior
Date: Thu, 24 Aug 2017 14:09:44 +0200
Message-ID: <20170824120944.GB23186@lst.de>
References: <20170823210535.1072-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49432 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751290AbdHXMJp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Aug 2017 08:09:45 -0400
Content-Disposition: inline
In-Reply-To: <20170823210535.1072-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

On Wed, Aug 23, 2017 at 02:05:35PM -0700, Bart Van Assche wrote:
> Requests are unprepared and reprepared when being requeued. Avoid
> that requeuing resets .jiffies_at_alloc and .retries by initializing
> these two member variables from inside blk_get_request() and by
> preserving both member variables when preparing a request. This patch
> affects the requeuing behavior of scsi-sq and scsi-mq.
> 
> Reported-by: Brian King <brking@linux.vnet.ibm.com>
> References: https://lkml.org/lkml/2017/8/18/923 ("Re: [BUG][bisected 270065e] linux-next fails to boot on powerpc")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Brian King <brking@linux.vnet.ibm.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi_lib.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index ebc5c713ee37..8d1ec1e7b0e2 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1122,6 +1122,8 @@ void scsi_initialize_rq(struct request *rq)
>  	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
>  
>  	scsi_req_init(&cmd->req);
> +	cmd->jiffies_at_alloc = jiffies;
> +	cmd->retries = 0;
>  }
>  EXPORT_SYMBOL(scsi_initialize_rq);

How is this working for non-passthrough commands where we don't
call scsi_initialize_rq?

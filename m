From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/18] scsi: Make scsi_initialize_rq() zero the entire
        struct scsi_cmnd
Date: Sun, 21 May 2017 08:49:18 +0200
Message-ID: <20170521064918.GD12891@lst.de>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com> <20170519183016.12646-15-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42793 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750824AbdEUGtT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 21 May 2017 02:49:19 -0400
Content-Disposition: inline
In-Reply-To: <20170519183016.12646-15-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>

On Fri, May 19, 2017 at 11:30:12AM -0700, Bart Van Assche wrote:
> This simplifies the memset() call in scsi_initialize_rq() and avoids
> that any stale data is left behind in struct scsi_request.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_lib.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index eeb668935836..791bae192bfb 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1160,11 +1160,9 @@ static void scsi_initialize_rq(struct request *rq)
>  	void *buf = cmd->sense_buffer;
>  	void *prot = cmd->prot_sdb;
>  
> -	/* zero out the cmd, except for the embedded scsi_request */
> -	memset((char *)cmd + sizeof(cmd->req), 0,
> -		sizeof(*cmd) - sizeof(cmd->req) + dev->host->hostt->cmd_size);
> +	memset(cmd, 0, blk_queue_cmd_size(rq->q));
>  	scsi_req_init(&cmd->req);
> -	cmd->req.sense = cmd->sense_buffer;
> +	cmd->req.sense = buf;
>  	cmd->device = dev;
>  	cmd->sense_buffer = buf;

maybe move the two sense buffer initializations together?

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

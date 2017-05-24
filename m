From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 25/31] scsi-mq: Make behavior scsi_mq_prep_fn() closer to
 that of scsi_prep_fn()
Date: Wed, 24 May 2017 08:11:59 +0200
Message-ID: <1a3c896d-000f-1d13-a618-20fdcee186b3@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-26-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60260 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933607AbdEXGMB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 02:12:01 -0400
In-Reply-To: <20170524003420.5381-26-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>

On 05/24/2017 02:34 AM, Bart Van Assche wrote:
> Instead of clearing most of struct scsi_cmnd and reinitializing
> it, rely on scsi_initialize_rq() for initialization of struct
> scsi_cmnd. This patch fixes a bug, namely that it avoids that
> jiffies_at_alloc gets overwritten if a request is requeued.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_lib.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 4b24c45fa113..12fd2bb0fe9c 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1861,27 +1861,17 @@ static int scsi_mq_prep_fn(struct request *req)
>  	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
>  	struct scsi_device *sdev = req->q->queuedata;
>  	struct Scsi_Host *shost = sdev->host;
> -	unsigned char *sense_buf = cmd->sense_buffer;
>  	struct scatterlist *sg;
>  
> -	/* zero out the cmd, except for the embedded scsi_request */
> -	memset((char *)cmd + sizeof(cmd->req), 0,
> -		sizeof(*cmd) - sizeof(cmd->req) + shost->hostt->cmd_size);
> +	memset(scsi_cmd_priv(cmd), 0, shost->hostt->cmd_size);
>  
>  	req->special = cmd;
>  
>  	cmd->request = req;
> -	cmd->device = sdev;
> -	cmd->sense_buffer = sense_buf;
>  
>  	cmd->tag = req->tag;
> -
>  	cmd->prot_op = SCSI_PROT_NORMAL;
>  
> -	INIT_LIST_HEAD(&cmd->list);
> -	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
> -	cmd->jiffies_at_alloc = jiffies;
> -
>  	scsi_add_cmd_to_list(cmd);
>  
>  	sg = (void *)cmd + sizeof(struct scsi_cmnd) + shost->hostt->cmd_size;
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

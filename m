From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 24/31] scsi: Make scsi_initialize_rq() zero the entire
 struct scsi_cmnd
Date: Wed, 24 May 2017 08:10:49 +0200
Message-ID: <10b21774-8910-df3c-b5a0-238b2acba20c@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-25-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59994 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933607AbdEXGKv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 02:10:51 -0400
In-Reply-To: <20170524003420.5381-25-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 05/24/2017 02:34 AM, Bart Van Assche wrote:
> This simplifies the memset() call in scsi_initialize_rq() and avoids
> that any stale data is left behind in struct scsi_request.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_lib.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 10c6adb208dc..4b24c45fa113 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1159,12 +1159,10 @@ static void scsi_initialize_rq(struct request *rq)
>  	void *buf = cmd->sense_buffer;
>  	void *prot = cmd->prot_sdb;
>  
> -	/* zero out the cmd, except for the embedded scsi_request */
> -	memset((char *)cmd + sizeof(cmd->req), 0,
> -	       sizeof(*cmd) - sizeof(cmd->req));
> +	memset(cmd, 0, sizeof(*cmd));
>  	scsi_req_init(&cmd->req);
>  	cmd->device = dev;
> -	cmd->req.sense = cmd->sense_buffer;
> +	cmd->req.sense = buf;
>  	cmd->sense_buffer = buf;
>  	cmd->prot_sdb = prot;
>  	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
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

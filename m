From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: zero per-cmd driver data before each I/O
Date: Tue, 21 Feb 2017 07:48:18 +0100
Message-ID: <e145c8c8-43e1-5a6a-56c0-72cb6a01941b@suse.de>
References: <20170220165239.25669-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170220165239.25669-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com
Cc: decui@microsoft.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/20/2017 05:52 PM, Christoph Hellwig wrote:
> Without this drivers that don't clear the state themselves can see off
> effects.  For example Hyper-V VMs using the storvsc driver will often
> hang during boot due to uncleared Test Unit Ready failures.
> 
> Fixes: e9c787e6 ("scsi: allocate scsi_cmnd structures as part of struct request")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Dexuan Cui <decui@microsoft.com>
> Tested-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/scsi/scsi_lib.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 90f65c8f487a..daced9db8af8 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1167,6 +1167,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
>  	/* zero out the cmd, except for the embedded scsi_request */
>  	memset((char *)cmd + sizeof(cmd->req), 0,
>  		sizeof(*cmd) - sizeof(cmd->req));
> +	memset((char *)(cmd + 1), 0, dev->host->hostt->cmd_size);
>  
>  	cmd->device = dev;
>  	cmd->sense_buffer = buf;
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

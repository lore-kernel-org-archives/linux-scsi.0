From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH] scsi-mq: Always unprepare before requeuing a request
Date: Fri, 4 Aug 2017 17:06:36 +0900
Message-ID: <8a0d37b6-5f38-8300-e7fc-cc9bdabd7f50@wdc.com>
References: <20170803214014.20332-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170803214014.20332-1-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 8/4/17 06:40, Bart Van Assche wrote:
> One of the two scsi-mq functions that requeue a request unprepares
> a request before requeueing (scsi_io_completion()) but the other
> function not (__scsi_queue_insert()). Make sure that a request is
> unprepared before requeuing it.
> 
> Fixes: commit d285203cf647 ("scsi: add support for a blk-mq based I/O path.")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Damien Le Moal <damien.lemoal@wdc.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/scsi_lib.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 4a2f705cdb14..c7514f3b444a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -44,6 +44,8 @@ static struct kmem_cache *scsi_sense_cache;
>  static struct kmem_cache *scsi_sense_isadma_cache;
>  static DEFINE_MUTEX(scsi_sense_cache_mutex);
>  
> +static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd);
> +
>  static inline struct kmem_cache *
>  scsi_select_sense_cache(bool unchecked_isa_dma)
>  {
> @@ -140,6 +142,12 @@ static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
>  {
>  	struct scsi_device *sdev = cmd->device;
>  
> +	if (cmd->request->rq_flags & RQF_DONTPREP) {
> +		cmd->request->rq_flags &= ~RQF_DONTPREP;
> +		scsi_mq_uninit_cmd(cmd);
> +	} else {
> +		WARN_ON_ONCE(true);
> +	}
>  	blk_mq_requeue_request(cmd->request, true);
>  	put_device(&sdev->sdev_gendev);
>  }
> @@ -995,8 +1003,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  		 * A new command will be prepared and issued.
>  		 */
>  		if (q->mq_ops) {
> -			cmd->request->rq_flags &= ~RQF_DONTPREP;
> -			scsi_mq_uninit_cmd(cmd);
>  			scsi_mq_requeue_cmd(cmd);
>  		} else {
>  			scsi_release_buffers(cmd);
> 

Tested-by: Damien Le Moal <damien.lemoal@wdc.com>

This patch is needed for the V2 of the series "Zoned block device
support fixes" that I sent.

Best regards.

-- 
Damien Le Moal,
Western Digital

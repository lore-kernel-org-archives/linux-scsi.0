From: Steffen Maier <maier@linux.ibm.com>
Subject: Re: [RFC PATCH] scsi: fix oops in scsi_uninit_cmd()
Date: Tue, 19 Feb 2019 11:32:25 +0100
Message-ID: <ca0a03a1-6b36-2626-cb16-113cbc01f4bc@linux.ibm.com>
References: <20190219072743.13606-1-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190219072743.13606-1-yanaijie@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On 02/19/2019 08:27 AM, Jason Yan wrote:
> If we remove the scsi disk when running io with fio, oops occured with
> the following condition.
> 
> [scsi_eh_0]                              [fio]
> scsi_end_request
>    ->blk_update_request
>      ->end_bio(io returned to userspace)
>                                           close
>                                             ->sd_release
>                                                ->scsi_disk_put
>                                                   ->scsi_disk_release
>                                                       ->disk->private_data = NULL;
> 
>    ->scsi_mq_uninit_cmd
>      ->scsi_uninit_cmd
>        ->scsi_cmd_to_driver
>      ->drv is NULL, Oops
> 
> There is a small window between blk_update_request() and
> scsi_mq_uninit_cmd() that scsi disk may have been released. This will
> cause a oops like below:

> To fix this, get a refcount of scsi_disk in sd_init_command() to ensure
> it will not be released before sd_uninit_command().
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>   drivers/scsi/sd.c | 46 +++++++++++++++++++++++++++++++++++-----------
>   1 file changed, 35 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 5464d467e23e..6bdb8fbb570f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1249,42 +1249,64 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
>   static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
>   {
>   	struct request *rq = cmd->request;
> +	struct scsi_disk *sdkp = NULL;

This pre-init with NULL kinda prevents static compile warnings on uninitialized 
use?

> +	blk_status_t ret;
> 
>   	switch (req_op(rq)) {

>   	}
> +
> +	if (!ret) {
> +		sdkp = scsi_disk(rq->rq_disk);
> +		get_device(&sdkp->dev);
> +	}
> +
> +	return ret;
>   }
> 
>   static void sd_uninit_command(struct scsi_cmnd *SCpnt)
>   {
>   	struct request *rq = SCpnt->request;
>   	u8 *cmnd;
> +	struct scsi_disk *sdkp = NULL;

dito

> 
>   	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
>   		mempool_free(rq->special_vec.bv_page, sd_page_pool);
> @@ -1295,6 +1317,8 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
>   		SCpnt->cmd_len = 0;
>   		mempool_free(cmnd, sd_cdb_pool);
>   	}
> +	sdkp = scsi_disk(rq->rq_disk);
> +	put_device(&sdkp->dev);
>   }
> 
>   /**
> 


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z Development

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Matthias Hartmann
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: [PATCH] Avoid that a kernel warning appears during system resume
Date: Sat, 16 Mar 2019 11:43:11 +0100
Message-ID: <4337330.mz4Gj9yf0O@merkaba>
References: <20190315232758.221199-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190315232758.221199-1-bvanassche@acm.org>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Ming Lei <ming.lei@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Oleksandr Natalenko <oleksandr@natalenko.name>, stable@vger.kernel.org, Jisheng Zhang <Jisheng.Zhang@synaptics.com>
List-Id: linux-scsi@vger.kernel.org

Hi Bart.

Bart Van Assche - 16.03.19, 00:27:
> Since scsi_device_quiesce() skips SCSI devices that have another state
> than RUNNING, OFFLINE or TRANSPORT_OFFLINE, scsi_device_resume()
> should not complain about SCSI devices that have been skipped. Hence
> this patch. This patch avoids that the following warning appears
> during resume:

Am I on CC cause one of those warnings appeared in bug reports from me 
from quite some time ago?

> WARNING: CPU: 3 PID: 1039 at blk_clear_pm_only+0x2a/0x30
> CPU: 3 PID: 1039 Comm: kworker/u8:49 Not tainted 5.0.0+ #1
> Hardware name: LENOVO 4180F42/4180F42, BIOS 83ET75WW (1.45 )

This at least does not appear to be this ThinkPad T520, as I have BIOS 
version 1.49 already.

Thanks and have good weekend,
Martin

> 05/10/2013 Workqueue: events_unbound async_run_entry_fn
> RIP: 0010:blk_clear_pm_only+0x2a/0x30
> Call Trace:
>  ? scsi_device_resume+0x28/0x50
>  ? scsi_dev_type_resume+0x2b/0x80
>  ? async_run_entry_fn+0x2c/0xd0
>  ? process_one_work+0x1f0/0x3f0
>  ? worker_thread+0x28/0x3c0
>  ? process_one_work+0x3f0/0x3f0
>  ? kthread+0x10c/0x130
>  ? __kthread_create_on_node+0x150/0x150
>  ? ret_from_fork+0x1f/0x30
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
> Cc: Martin Steigerwald <martin@lichtvoll.de>
> Cc: <stable@vger.kernel.org>
> Reported-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> Tested-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> Fixes: 3a0a529971ec ("block, scsi: Make SCSI quiesce and resume work
> reliably") # v4.15 Signed-off-by: Bart Van Assche
> <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_lib.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 324f830ee9fa..54ad751b42b8 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2541,8 +2541,10 @@ void scsi_device_resume(struct scsi_device
> *sdev) * device deleted during suspend)
>  	 */
>  	mutex_lock(&sdev->state_mutex);
> -	sdev->quiesced_by = NULL;
> -	blk_clear_pm_only(sdev->request_queue);
> +	if (sdev->quiesced_by) {
> +		sdev->quiesced_by = NULL;
> +		blk_clear_pm_only(sdev->request_queue);
> +	}
>  	if (sdev->sdev_state == SDEV_QUIESCE)
>  		scsi_device_set_state(sdev, SDEV_RUNNING);
>  	mutex_unlock(&sdev->state_mutex);


-- 
Martin

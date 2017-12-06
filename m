From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: Re: [PATCH] SCSI: run queue if SCSI device queue isn't ready and
 queue is idle
Date: Thu, 7 Dec 2017 00:10:51 +0100
Message-ID: <0352a2f1-d49b-aaa1-f8e9-10486bb5fa9d@applied-asynchrony.com>
References: <20171205075256.10319-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171205075256.10319-1-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 12/05/17 08:52, Ming Lei wrote:
> Before commit 0df21c86bdbf ("scsi: implement .get_budget and .put_budget
> for blk-mq"), we run queue after 3ms if queue is idle and SCSI device
> queue isn't ready, which is done in handling BLK_STS_RESOURCE. After
> commit 0df21c86bdbf is introduced, queue won't be run any more under
> this situation.
> 
> IO hang is observed when timeout happened, and this patch fixes the IO
> hang issue by running queue after delay in scsi_dev_queue_ready, just like
> non-mq. This issue can be triggered by the following script[1].
> 
> There is another issue which can be covered by running idle queue:
> when .get_budget() is called on request coming from hctx->dispatch_list,
> if one request just completes during .get_budget(), we can't depend on
> SCSI's restart to make progress any more. This patch fixes the race too.
> 
> With this patch, we basically recover to previous behaviour(before commit
> 0df21c86bdbf) of handling idle queue when running out of resource.
> 
> [1] script for test/verify SCSI timeout
> rmmod scsi_debug
> modprobe scsi_debug max_queue=1
> 
> DEVICE=`ls -d /sys/bus/pseudo/drivers/scsi_debug/adapter*/host*/target*/*/block/* | head -1 | xargs basename`
> DISK_DIR=`ls -d /sys/block/$DEVICE/device/scsi_disk/*`
> 
> echo "using scsi device $DEVICE"
> echo "-1" >/sys/bus/pseudo/drivers/scsi_debug/every_nth
> echo "temporary write through" >$DISK_DIR/cache_type
> echo "128" >/sys/bus/pseudo/drivers/scsi_debug/opts
> echo none > /sys/block/$DEVICE/queue/scheduler
> dd if=/dev/$DEVICE of=/dev/null bs=1M iflag=direct count=1 &
> sleep 5
> echo "0" >/sys/bus/pseudo/drivers/scsi_debug/opts
> wait
> echo "SUCCESS"
> 
> Fixes: 0df21c86bdbf ("scsi: implement .get_budget and .put_budget for blk-mq")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/scsi_lib.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index db9556662e27..1816dd8259b3 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1967,6 +1967,8 @@ static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
>  out_put_device:
>  	put_device(&sdev->sdev_gendev);
>  out:
> +	if (atomic_read(&sdev->device_busy) == 0 && !scsi_device_blocked(sdev))
> +		blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
>  	return false;
>  }

So just to follow up on this: with this patch I haven't encountered any
new hangs with blk-mq, regardless of medium (SSD/rotating disk) or scheduler.
I cannot speak for other hangs that may be reproducible by other means,
but for now here's my:

Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>

cheers,
Holger

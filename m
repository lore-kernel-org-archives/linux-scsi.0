From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] scsi: sd: Contribute to randomness when running
 rotational device
Date: Sun, 9 Sep 2018 19:52:07 +0800
Message-ID: <20180909115205.GA17732@ming.t460p>
References: <20180906203719.209399-1-xueweiz@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180906203719.209399-1-xueweiz@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Xuewei Zhang <xueweiz@google.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aditya Kali <adityakali@google.com>, tytso@mit.edu, Guenter Roeck <groeck@chromium.org>, maze@google.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 06, 2018 at 01:37:19PM -0700, Xuewei Zhang wrote:
> Currently a scsi device won't contribute to kernel randomness when it
> uses blk-mq. Since we commonly use scsi on rotational device with
> blk-mq, it make sense to keep contributing to kernel randomness in these
> cases. This is especially important for virtual machines.
> 
> commit b5b6e8c8d3b4 ("scsi: virtio_scsi: fix IO hang caused by automatic
> irq vector affinity") made all virtio-scsi device to use blk-mq, which
> does not contribute to randomness today. So for a virtual machine only
> having virtio-scsi disk (which is common), it will simple stop getting
> randomness from its disks in today's implementation.
> 
> With this patch, if the above VM has rotational virtio-scsi device, then
> it can still benefit from the entropy generated from the disk.
> 
> Reported-by: Xuewei Zhang <xueweiz@google.com>
> Signed-off-by: Xuewei Zhang <xueweiz@google.com>
> ---
>  drivers/scsi/sd.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index b79b366a94f7..5e4f10d28065 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2959,6 +2959,9 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
>  	if (rot == 1) {
>  		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
>  		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
> +	} else {
> +		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
> +		blk_queue_flag_set(QUEUE_FLAG_ADD_RANDOM, q);
>  	}
>  
>  	if (sdkp->device->type == TYPE_ZBC) {
> -- 
> 2.19.0.rc2.392.g5ba43deb5a-goog
> 

Look reasonable, especially the disk randomness is added by SCSI itself.

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming

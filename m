From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/31] pktcdvd: Check queue type before attaching to a
 queue
Date: Wed, 24 May 2017 08:02:08 +0200
Message-ID: <07fe4cff-e361-fba1-4a3a-a66b71096b43@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-14-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-14-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 05/24/2017 02:34 AM, Bart Van Assche wrote:
> Since the pktcdvd driver only supports request queues for which
> struct scsi_request is the first member of their private request
> data, refuse to register block layer queues for which struct
> scsi_request is not the first member of the private data.
> 
> References: commit 82ed4db499b8 ("block: split scsi_request out of struct request")
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Omar Sandoval <osandov@fb.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: linux-block@vger.kernel.org
> ---
>  drivers/block/pktcdvd.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index 205b865ebeb9..b8ce55d7911d 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -2583,6 +2583,11 @@ static int pkt_new_dev(struct pktcdvd_device *pd, dev_t dev)
>  	bdev = bdget(dev);
>  	if (!bdev)
>  		return -ENOMEM;
> +	if (!blk_queue_scsi_sup(bdev_get_queue(bdev))) {
> +		WARN_ONCE(true, "Attempt to register a non-SCSI queue\n");
> +		bdput(bdev);
> +		return -EINVAL;
> +	}
>  	ret = blkdev_get(bdev, FMODE_READ | FMODE_NDELAY, NULL);
>  	if (ret)
>  		return ret;
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

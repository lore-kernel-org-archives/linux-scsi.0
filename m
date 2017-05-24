From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/31] bsg: Check queue type before attaching to a queue
Date: Wed, 24 May 2017 08:01:47 +0200
Message-ID: <2a44a07d-6eec-dbeb-5a0a-6868dccbb2cb@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-13-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-13-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 05/24/2017 02:34 AM, Bart Van Assche wrote:
> Since BSG only supports request queues for which struct scsi_request
> is the first member of their private request data, refuse to register
> block layer queues for which struct scsi_request is not the first
> member of their private data.
> 
> References: commit bd1599d931ca ("scsi_transport_sas: fix BSG ioctl memory corruption")
> References: commit 82ed4db499b8 ("block: split scsi_request out of struct request")
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Omar Sandoval <osandov@fb.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: linux-block@vger.kernel.org
> ---
>  block/bsg.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index 6fd08544d77e..f7695bb141d9 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -750,6 +750,12 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
>  #ifdef BSG_DEBUG
>  	unsigned char buf[32];
>  #endif
> +
> +	if (!blk_queue_scsi_sup(rq)) {
> +		WARN_ONCE(true, "Attempt to register a non-SCSI queue\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
>  	if (!blk_get_queue(rq))
>  		return ERR_PTR(-ENXIO);
>  
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

From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] sg: protect access to to 'reserved' page array
Date: Wed, 1 Feb 2017 14:12:48 +0100
Message-ID: <20170201131247.GA5384@lst.de>
References: <1485948135-83249-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485948135-83249-1-git-send-email-hare@suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 01, 2017 at 12:22:15PM +0100, Hannes Reinecke wrote:
> The 'reserved' page array is used as a short-cut for mapping
> data, saving us to allocate pages per request.
> However, the 'reserved' array is only capable of holding one
> request, so we need to protect it against concurrent accesses.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Link: http://www.spinics.net/lists/linux-scsi/msg104326.html
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Tested-by: Johannes Thumshirn <jth@kernel.org>
> ---
>  drivers/scsi/sg.c | 30 ++++++++++++------------------
>  1 file changed, 12 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 652b934..6a8601c 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -155,6 +155,8 @@
>  	unsigned char next_cmd_len; /* 0: automatic, >0: use on next write() */
>  	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
>  	char mmap_called;	/* 0 -> mmap() never called on this fd */
> +	unsigned long flags;
> +#define SG_RESERVED_IN_USE 1
>  	struct kref f_ref;
>  	struct execute_work ew;
>  } Sg_fd;
> @@ -198,7 +200,6 @@ static int sg_common_write(Sg_fd * sfp, Sg_request * srp,
>  static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
>  static Sg_request *sg_add_request(Sg_fd * sfp);
>  static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
> -static int sg_res_in_use(Sg_fd * sfp);
>  static Sg_device *sg_get_dev(int dev);
>  static void sg_device_destroy(struct kref *kref);
>  
> @@ -721,7 +722,7 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
>  			sg_remove_request(sfp, srp);
>  			return -EINVAL;	/* either MMAP_IO or DIRECT_IO (not both) */
>  		}
> -		if (sg_res_in_use(sfp)) {
> +		if (test_bit(SG_RESERVED_IN_USE, &sfp->flags)) {
>  			sg_remove_request(sfp, srp);
>  			return -EBUSY;	/* reserve buffer already being used */
>  		}
> @@ -963,10 +964,14 @@ static int max_sectors_bytes(struct request_queue *q)
>  		val = min_t(int, val,
>  			    max_sectors_bytes(sdp->device->request_queue));
>  		if (val != sfp->reserve.bufflen) {
> -			if (sg_res_in_use(sfp) || sfp->mmap_called)
> +			if (sfp->mmap_called)
> +				return -EBUSY;
> +			if (test_and_set_bit(SG_RESERVED_IN_USE, &sfp->flags))
>  				return -EBUSY;
> +
>  			sg_remove_scat(sfp, &sfp->reserve);
>  			sg_build_reserve(sfp, val);
> +			clear_bit(SG_RESERVED_IN_USE, &sfp->flags);


This seems to be abusing an atomic bitflag as a lock.  And I think
in general we have two different things here that this patch conflates:

 a) a lock to protect building and using the reserve lists
 b) a flag is a reservations is in use

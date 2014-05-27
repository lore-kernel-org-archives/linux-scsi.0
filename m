From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] notify block layer when using temporary change to
 cache_type
Date: Tue, 27 May 2014 20:18:16 +0400
Message-ID: <1401207496.14454.90.camel@dabdike>
References: <1401190754-6822-1-git-send-email-vaughan.cao@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401190754-6822-1-git-send-email-vaughan.cao@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-05-27 at 19:39 +0800, Vaughan Cao wrote:
> This is a fix for commit:
>   39c60a0948cc06139e2fbfe084f83cb7e7deae3b sd: fix array cache flushing bug causing performance problems
> We must notify the block layer via q->flush_flags after temporary change the cache_type to write through.
> If not, SYNCHRONIZE CACHE command will still be generated.
> 
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
> ---
>  drivers/scsi/sd.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 6146b9d..366e48b 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -144,6 +144,7 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,

This is a weird function name.  The name in the vanilla kernel is
cache_type_store().

>  	struct scsi_sense_hdr sshdr;
>  	static const char temp[] = "temporary ";
>  	int len;
> +	unsigned flush;
>  
>  	if (sdp->type != TYPE_DISK)
>  		/* no cache control on RBC devices; theoretically they
> @@ -174,6 +175,17 @@ sd_store_cache_type(struct device *dev, struct device_attribute *attr,
>  	if (sdkp->cache_override) {
>  		sdkp->WCE = wce;
>  		sdkp->RCD = rcd;
> +
> +		/* set flush_flags to notify the block layer */
> +		flush = 0;
> +		if (sdkp->WCE) {
> +			flush |= REQ_FLUSH;
> +			if (sdkp->DPOFUA)
> +				flush |= REQ_FUA;
> +		}
> +
> +		blk_queue_flush(sdkp->disk->queue, flush);
> +

Is there a reason you cut and paste from sd_revalidate_disk() instead of
just calling it directly?

James

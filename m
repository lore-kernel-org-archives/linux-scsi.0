From: Ewan Milne <emilne@redhat.com>
Subject: Re: [scsi 5/7 RESEND] scsi_debug: schedule_resp fix input variable
 check
Date: Tue, 25 Aug 2015 15:52:51 -0400
Message-ID: <1440532371.23183.81.camel@localhost.localdomain>
References: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
	 <1438091666-18113-5-git-send-email-tomas.winkler@intel.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438091666-18113-5-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-07-28 at 16:54 +0300, Tomas Winkler wrote:
> The function should never be called with cmnd NULL so
> put a fat WARN there.
> Fix also smatch wraning:
> schedule_resp() warn: variable dereferenced before check 'cmnd'
> 
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  drivers/scsi/scsi_debug.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 3a70683cf9f9..faa4ddd8decf 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3941,13 +3941,20 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>  	unsigned long iflags;
>  	int k, num_in_q, qdepth, inject;
>  	struct sdebug_queued_cmd *sqcp = NULL;
> -	struct scsi_device *sdp = cmnd->device;
> +	struct scsi_device *sdp;
> +
> +	/* this should never happen */
> +	if (WARN_ON(!cmnd))
> +		return SCSI_MLQUEUE_HOST_BUSY;
>  
> -	if (NULL == cmnd || NULL == devip) {
> -		pr_warn("called with NULL cmnd or devip pointer\n");
> +	if (NULL == devip) {
> +		pr_warn("called devip == NULL\n");
>  		/* no particularly good error to report back */
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  	}

Please refer to the patch I just posted, we can't return _HOST_BUSY here
if devip == NULL.  I posted a fix against the current "misc" branch as
I don't see this patch applied, let me know if I need to update it.

> +
> +	sdp = cmnd->device;
> +
>  	if ((scsi_result) && (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
>  		sdev_printk(KERN_INFO, sdp, "%s: non-zero result=0x%x\n",
>  			    __func__, scsi_result);

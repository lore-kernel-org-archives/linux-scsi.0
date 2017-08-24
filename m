From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 17/19] scsi_transport_srp: Suppress a W=1 compiler
        warning
Date: Thu, 24 Aug 2017 11:11:57 +0200
Message-ID: <20170824091157.GP19886@lst.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com> <20170823214009.15015-18-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48685 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751285AbdHXJL6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Aug 2017 05:11:58 -0400
Content-Disposition: inline
In-Reply-To: <20170823214009.15015-18-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>

On Wed, Aug 23, 2017 at 02:40:07PM -0700, Bart Van Assche wrote:
> Avoid that the following compiler warning is reported when building
> with W=1:
> 
> drivers/scsi/scsi_transport_srp.c:92:19: warning: comparison is always false due to limited range of data type [-Wtype-limits]
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi_transport_srp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> index 698cc4681706..b8f5e4c47579 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -89,7 +89,7 @@ int srp_tmo_valid(int reconnect_delay, int fast_io_fail_tmo, int dev_loss_tmo)
>  	if (fast_io_fail_tmo < 0 &&
>  	    dev_loss_tmo > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
>  		return -EINVAL;
> -	if (dev_loss_tmo >= LONG_MAX / HZ)
> +	if (dev_loss_tmo + 0UL >= LONG_MAX / HZ)
>  		return -EINVAL;

That's a weird change..  If we can to promote dev_loss_tmo to
long we should just cast it.  And of course we should always ask
us why we got this warning.  If long is 64-bit and int is 32-bit
the warning makes sense, as for every reasonable comparism
the 32-bit timeout can't be larger than LONG_MAX divided by 100 or 100.

But for 32-bit longs it can, so we should keep it, maybe with a comment.

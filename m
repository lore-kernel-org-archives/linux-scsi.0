From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/19] sg: Fix type of last blk_trace_setup() argument
Date: Fri, 25 Aug 2017 17:51:06 +0200
Message-ID: <9b703470-f4e0-bddd-748b-d59f932ac55a@suse.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
 <20170823214009.15015-13-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42910 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933662AbdHYPvJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 11:51:09 -0400
In-Reply-To: <20170823214009.15015-13-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 08/23/2017 11:40 PM, Bart Van Assche wrote:
> Avoid that sparse reports the following:
> 
> drivers/scsi/sg.c:1114:41: warning: incorrect type in argument 5 (different address spaces)
> drivers/scsi/sg.c:1114:41:    expected char [noderef] <asn:1>*arg
> drivers/scsi/sg.c:1114:41:    got char *<noident>
> 
> This patch does not change any functionality.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/sg.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index f5705a95319f..03194c4b6744 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1110,8 +1110,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
>  		return blk_trace_setup(sdp->device->request_queue,
>  				       sdp->disk->disk_name,
>  				       MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
> -				       NULL,
> -				       (char *)arg);
> +				       NULL, p);
>  	case BLKTRACESTART:
>  		return blk_trace_startstop(sdp->device->request_queue, 1);
>  	case BLKTRACESTOP:
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

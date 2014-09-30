From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/2] sg: fix sparse __user annotation warning
Date: Tue, 30 Sep 2014 11:54:00 -0400
Message-ID: <542AD218.1090808@interlog.com>
References: <1412090405-24436-1-git-send-email-hch@lst.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59854 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaI3PyS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2014 11:54:18 -0400
In-Reply-To: <1412090405-24436-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 14-09-30 11:20 AM, Christoph Hellwig wrote:
> blk_trace_setup takes a __user pointer, so use the local void __user *
> pointer instead of casting the argument to char * for it in the sg
> ioctl handler.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/sg.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 01cf888..b94435b 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1138,7 +1138,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
>   				       sdp->disk->disk_name,
>   				       MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
>   				       NULL,
> -				       (char *)arg);
> +				       p);
>   	case BLKTRACESTART:
>   		return blk_trace_startstop(sdp->device->request_queue, 1);
>   	case BLKTRACESTOP:
>


From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 3/6] sd: fix up ->compat_ioctl
Date: Thu, 6 Nov 2014 21:41:21 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402959377FA0@G4W3202.americas.hpqcorp.net>
References: <1414661229-15199-1-git-send-email-hch@lst.de>
 <1414661229-15199-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:57827 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaKFVm2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 16:42:28 -0500
In-Reply-To: <1414661229-15199-4-git-send-email-hch@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Thursday, 30 October, 2014 4:27 AM
> To: linux-scsi@vger.kernel.org
> Cc: Douglas Gilbert; Elliott, Robert (Server Storage)
> Subject: [PATCH 3/6] sd: fix up ->compat_ioctl
> 
> No need to verify the passthrough ioctls, the real handler will
> take care of that.  Also make sure not to block for resets on
> O_NONBLOCK fds.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/sd.c | 28 ++++++++--------------------
>  1 file changed, 8 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 61e50ae..baf5cf4 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1541,31 +1541,19 @@ static int sd_compat_ioctl(struct
> block_device *bdev, fmode_t mode,
>  			   unsigned int cmd, unsigned long arg)
...
>  	/*
>  	 * Let the static ioctl translation table take care of it.
>  	 */
> -	return -ENOIOCTLCMD;
> +	if (!sdev->host->hostt->compat_ioctl)
> +		return -ENOIOCTLCMD;

Although I don't see it in the quoted email, git complains that 
this line (and the original being deleted) have a space 
after -ENOIOCTLCMD;

> +	return sdev->host->hostt->compat_ioctl(sdev, cmd, (void __user
> *)arg);
>  }
>  #endif
> 
> --
> 1.9.1

Reviewed-by: Robert Elliott <elliott@hp.com>



From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] SYNCHRONIZE_CACHE on umount
Date: Thu, 12 Jan 2006 12:13:41 +0100
Message-ID: <20060112111340.GC3945@suse.de>
References: <6.0.0.20.2.20060112180316.04202110@129.60.53.12>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:53591 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1030379AbWALLLq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 06:11:46 -0500
Content-Disposition: inline
In-Reply-To: <6.0.0.20.2.20060112180316.04202110@129.60.53.12>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hifumi Hisashi <hifumi.hisashi@lab.ntt.co.jp>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Thu, Jan 12 2006, Hifumi Hisashi wrote:
> Hi.
> When a SCSI HDD(WCE bit is set) is umounted, SYNCHRONIZE_CACHE(35h)
> command is not issued under current sd driver.
> 
> When an IDE HDD is umounted, FLUSH CACHE is issued through
> idedisk_release().
> I suppose that the sd driver also needs to flush cache through umount.
> 
> Thanks.
> 
> Signed-off-by: Hifumi Hisashi <hifumi.hisashi@lab.ntt.co.jp>
> 
> --- linux-2.6.15/drivers/scsi/sd.c      2006-01-12 16:23:44.000000000 +0900
> +++ linux-2.6.15_fix/drivers/scsi/sd.c  2006-01-12 16:43:04.000000000 +0900
> @@ -503,6 +503,8 @@
> 
>         SCSI_LOG_HLQUEUE(3, printk("sd_release: disk=%s\n", 
>         disk->disk_name));
> 
> +       if (sdkp->WCE)
> +               sd_sync_cache(sdev);
>         if (!--sdkp->openers && sdev->removable) {
>                 if (scsi_block_when_processing_errors(sdev))
>                         scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);

Wrong way to place it, imo. If you are pushing out dirty data on umount,
the core should make sure to do a blkdev_issue_flush() afterwards. Then
you don't have to put it in each and every driver.

-- 
Jens Axboe


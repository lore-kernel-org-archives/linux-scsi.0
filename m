From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: Fix crash due to race when removing scsi disk
Date: Fri, 01 Jul 2016 09:36:30 -0700
Message-ID: <1467390990.2341.31.camel@HansenPartnership.com>
References: <1467389699-10571-1-git-send-email-hcochran@kernelspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39512 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702AbcGAQge (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2016 12:36:34 -0400
In-Reply-To: <1467389699-10571-1-git-send-email-hcochran@kernelspring.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Howard Cochran <hcochran@kernelspring.com>, linux-scsi@vger.kernel.org
Cc: Howard Cochran <cochran@lexmark.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@Odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org

On Fri, 2016-07-01 at 12:14 -0400, Howard Cochran wrote:
> This crash occurred while writing 1 to /sys/block/sda/device/delete
> at
> the same instant that another process was closing the block device:
> 
>  BUG: unable to handle kernel NULL pointer dereference at 00000230
>  IP: [<c138fa9c>] blk_get_backing_dev_info+0xc/0x20
>  Oops: 0000 [#1] PREEMPT SMP
>  Call Trace:
>   [<c112da2a>] ? __filemap_fdatawrite_range+0x15a/0x180
>   [<c112d9b5>] ? __filemap_fdatawrite_range+0xe5/0x180
>   [<c112dae8>] filemap_write_and_wait+0x38/0x70
>   [<c11b79b1>] fsync_bdev+0x41/0x50
>   [<c13a4f7c>] invalidate_partition+0x1c/0x40
>   [<c13a5d0f>] del_gendisk+0xcf/0x1c0
>   [<c15c7143>] sd_remove+0x53/0xb0
>   [<c157eaf0>] __device_release_driver+0x80/0x120
>   [<c157ebad>] device_release_driver+0x1d/0x30
>   [<c157e392>] bus_remove_device+0xb2/0xf0
>   [<c157b45c>] device_del+0xec/0x1e0
>   [<c13b6d88>] ? kobject_put+0x58/0xc0
>   [<c15c12af>] __scsi_remove_device+0xaf/0xc0
>   [<c15c12df>] scsi_remove_device+0x1f/0x30
>   [<c15c131b>] sdev_store_delete+0x2b/0x40
>   [<c15c12f0>] ? scsi_remove_device+0x30/0x30
>   [<c157a87f>] dev_attr_store+0x1f/0x40
>                ...
>   [<c11829bc>] SyS_write+0x4c/0xb0
>  EIP: [<c138fa9c>] blk_get_backing_dev_info+0xc/0x20 SS:ESP
> 0068:f5eb9d18
> 
> It is caused by this race: Between the time Thread B's instance of
> filemap_write_and_wait() has asked whether there are any pages to
> flush and
> when it it dereferences bdev->disk, Thread A can clear that pointer
> in
> __blkdev_put().
> 
> Thread A:                             Thread B:
> blkdev_close()                        sdev_store_delete()
>   blkdev_put()                          sd_remove()
>     __blkdev_put()                        del_gendisk()
>       mutex_lock(bd_mutex);                 invalidate_partition()
> 	sync_blkdev()                         fsync_bdev()
>           filemap_write_and_wait()             
>  filemap_write_and_wait()
> 	    if (mapping has pages)                if (mapping has
> pages)
> 	      deref bdev->disk (OK)
>         Set bdev->bd_disk = NULL;
>       mutex_unlock(bd_mutex);                       deref. bdev
> ->bd_disk (BOOM!)
> 
> The "dereference bdev->disk" occurs on this sub-chain:
> filemap_write_and_wait()
>   __filemap_fdatawrite_range()
>     mapping_cap_writeback_dirty()
>       inode_to_bdi()
>         bdev_get_queue()
>           return bdev->disk->queue;
> 
> The problem was introduced by de1414a654e6 ("fs: export inode_to_bdi 
> and use it in favor of mapping->backing_dev_info"). Before that 
> change, mapping_cap_writeback_dirty() directly retrieved the 
> backing_dev_info from the mapping rather than looking it up through
> mapping->host->inode_dev->bdev->bd_disk->queue.

Great analysis, thanks.

> This was found while running a stress test on an ARM-based embedded 
> system which involved repeatedly shutting down many services 
> simultaneously via systemd isolate (thereby making it likely that 
> "Thread B" was preempted for awhile just before it dereferenced bdev
> ->bd_disk). I subsequently reproduced this on vanilla Linux 4.6 in
> QEMU/x86.
> 
> This patch fixes the race by making sd_remove() hold bd_mutex during 
> the call to del_gendisk().
> 
> Fixes: de1414a654e6 ("fs: export inode_to_bdi and use it in favor of
> mapping->backing_dev_info")
> Signed-off-by: Howard Cochran <hcochran@kernelspring.com>
> Cc: Howard Cochran <cochran@lexmark.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: James Bottomley <JBottomley@Odin.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/scsi/sd.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index f52b74c..0f53925 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3126,6 +3126,7 @@ static int sd_remove(struct device *dev)
>  {
>  	struct scsi_disk *sdkp;
>  	dev_t devt;
> +	struct block_device *bdev;
>  
>  	sdkp = dev_get_drvdata(dev);
>  	devt = disk_devt(sdkp->disk);
> @@ -3134,7 +3135,13 @@ static int sd_remove(struct device *dev)
>  	async_synchronize_full_domain(&scsi_sd_pm_domain);
>  	async_synchronize_full_domain(&scsi_sd_probe_domain);
>  	device_del(&sdkp->dev);
> +
> +	bdev = bdget_disk(sdkp->disk, 0);
> +	mutex_lock(&bdev->bd_mutex);
>  	del_gendisk(sdkp->disk);
> +	mutex_unlock(&bdev->bd_mutex);
> +	bdput(bdev);
> +
>  	sd_shutdown(dev);
>  
>  	blk_register_region(devt, SD_MINORS, NULL,


OK, so this can't be the proper fix because it's a layering violation. 
 You can see this if you consider what happens to any other block
device doing the same thing: they would oops in the same way, implying
that this fix would have to be replicated to every other block device
remove path.  Instead place to fix it should be somewhere inside the
block subsystem.  My suspicion is that it should probably be in
del_gendisk() because that will fix every device, but the block people
should think more about the problem (linux-block cc added).

James


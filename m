From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] scsi_dh_alua: Check scsi_device_get() return value
Date: Sat, 18 Mar 2017 12:17:31 +0100
Message-ID: <74b0f4ca-7be1-9d76-b4ce-6945d7593a3b@suse.de>
References: <20170318000203.7469-1-bart.vanassche@sandisk.com>
 <20170318000203.7469-2-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170318000203.7469-2-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Tang Junhui <tang.junhui@zte.com.cn>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/18/2017 01:02 AM, Bart Van Assche wrote:
> Do not queue ALUA work nor call scsi_device_put() if the scsi_device_get()
> call fails. This patch fixes the following crash:
> 
> general protection fault: 0000 [#1] SMP
> RIP: 0010:scsi_device_put+0xb/0x30
> Call Trace:
>  scsi_disk_put+0x2d/0x40
>  sd_release+0x3d/0xb0
>  __blkdev_put+0x29e/0x360
>  blkdev_put+0x49/0x170
>  dm_put_table_device+0x58/0xc0 [dm_mod]
>  dm_put_device+0x70/0xc0 [dm_mod]
>  free_priority_group+0x92/0xc0 [dm_multipath]
>  free_multipath+0x70/0xc0 [dm_multipath]
>  multipath_dtr+0x19/0x20 [dm_multipath]
>  dm_table_destroy+0x67/0x120 [dm_mod]
>  dev_suspend+0xde/0x240 [dm_mod]
>  ctl_ioctl+0x1f5/0x520 [dm_mod]
>  dm_ctl_ioctl+0xe/0x20 [dm_mod]
>  do_vfs_ioctl+0x8f/0x700
>  SyS_ioctl+0x3c/0x70
>  entry_SYSCALL_64_fastpath+0x18/0xad
> 
> Fixes: commit 03197b61c5ec ("scsi_dh_alua: Use workqueue for RTPG")
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Tang Junhui <tang.junhui@zte.com.cn>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

From: Israel Rukshin <israelr@mellanox.com>
Subject: Re: [PATCH v3 0/4] Avoid that __scsi_remove_device() hangs
Date: Tue, 18 Apr 2017 14:58:02 +0300
Message-ID: <63e7faf7-f4e7-9e5c-dad5-ec59032df698@mellanox.com>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-eopbgr20050.outbound.protection.outlook.com ([40.107.2.50]:7872
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752802AbdDRL6a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Apr 2017 07:58:30 -0400
In-Reply-To: <20170417173436.15555-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On 4/17/2017 8:34 PM, Bart Van Assche wrote:
> __scsi_remove_device() hangs if it is waiting for the SYNCHRONIZE CACHE
> command submitted by the sd driver to finish if the block layer queue is
> stopped and does not get restarted. This patch series avoids that that
> hang occurs.
>
> Changes compared to v2:
> - Moved the "stop_disk" assignment after the sdkp check in the sd driver.
> - Added a completion function for asynchronous SYNCHRONIZE CACHE commands.
> - Added "disk" and "done" arguments to scsi_execute_async().
>
> Changes compared to v1:
> - Reworked the approach of this patch series.
>
> Bart Van Assche (4):
>    Introduce scsi_start_queue()
>    Introduce scsi_execute_async()
>    sd: Make synchronize cache upon shutdown asynchronous
>    Avoid that __scsi_remove_device() hangs
>
>   drivers/scsi/scsi_lib.c    | 114 ++++++++++++++++++++++++++++++++++-----------
>   drivers/scsi/scsi_priv.h   |   1 +
>   drivers/scsi/scsi_sysfs.c  |   9 ++++
>   drivers/scsi/sd.c          |  45 ++++++++++++++++--
>   include/scsi/scsi_device.h |   5 ++
>   5 files changed, 142 insertions(+), 32 deletions(-)
>
Hi Bart,

I tested those patches and I got a NULL dereference at sd_sync_cache_done().
The test is unloading ib_srp while one port is down.
The previous version worked fine.

 From the log:
[  190.260240] sd 8:0:0:0: [sdc] Synchronizing SCSI cache
[  190.266412] scsi 8:0:0:0: rejecting I/O to dead device
[  190.272412] BUG: unable to handle kernel NULL pointer dereference at 
00000000000002f0
[  190.281102] IP: sd_sync_cache_done+0x1b/0x80 [sd_mod]
[  190.482738] Call Trace:
[  190.486052]  blk_finish_request+0x73/0x130
[  190.491007]  __blk_end_bidi_request+0x2d/0x40
[  190.496215]  __blk_end_request_all+0x1f/0x40
[  190.501338]  blk_peek_request+0x1c5/0x2b0
[  190.506203]  scsi_request_fn+0x3f/0x6c0
[  190.510888]  ? kobject_put+0x1f/0x60
[  190.515305]  __blk_run_queue+0x33/0x40
[  190.519877]  blk_start_queue+0x29/0x40
[  190.524438]  scsi_start_queue+0x40/0x60
[  190.529081]  __scsi_remove_device+0x4d/0xe0
[  190.534079]  scsi_forget_host+0x60/0x70
[  190.538738]  scsi_remove_host+0x77/0x110
[  190.543462]  srp_remove_work+0x90/0x230 [ib_srp]

Regards,
Israel.

From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi: Unblock devices in state SDEV_CANCEL
Date: Wed, 06 Oct 2010 03:10:59 -0500
Message-ID: <4CAC2F13.60901@cs.wisc.edu>
References: <20100902110540.GB4097@schmichrtp.mainz.de.ibm.com> <4C83DC70.5030304@cs.wisc.edu> <20100906104742.GA23653@schmichrtp.mainz.de.ibm.com> <20100906105938.GB23653@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060102050608020600020405"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55035 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab0JFILc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Oct 2010 04:11:32 -0400
In-Reply-To: <20100906105938.GB23653@schmichrtp.mainz.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

This is a multi-part message in MIME format.
--------------060102050608020600020405
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 09/06/2010 05:59 AM, Christof Schmitt wrote:
> Deleting a SCSI device on a blocked fc_remote_port (before
> fast_io_fail_tmo fires) results in a hanging thread:
>
>    STACK:
>    0 schedule+1108 [0x5cac48]
>    1 schedule_timeout+528 [0x5cb7fc]
>    2 wait_for_common+266 [0x5ca6be]
>    3 blk_execute_rq+160 [0x354054]
>    4 scsi_execute+324 [0x3b7ef4]
>    5 scsi_execute_req+162 [0x3b80ca]
>    6 sd_sync_cache+138 [0x3cf662]
>    7 sd_shutdown+138 [0x3cf91a]
>    8 sd_remove+112 [0x3cfe4c]
>    9 __device_release_driver+124 [0x3a08b8]
> 10 device_release_driver+60 [0x3a0a5c]
> 11 bus_remove_device+266 [0x39fa76]
> 12 device_del+340 [0x39d818]
> 13 __scsi_remove_device+204 [0x3bcc48]
> 14 scsi_remove_device+66 [0x3bcc8e]
> 15 sysfs_schedule_callback_work+50 [0x260d66]
> 16 worker_thread+622 [0x162326]
> 17 kthread+160 [0x1680b0]
> 18 kernel_thread_starter+6 [0x10aaea]
>
> During the delete, the SCSI device is in moved to SDEV_CANCEL.  When
> the FC transport class later calls scsi_target_unblock, this has no
> effect, since scsi_internal_device_unblock ignores SCSI devics in this
> state.
>
> Fix this by also accepting SDEV_CANCEL in
> scsi_internal_device_unblock.
>
> Signed-off-by: Christof Schmitt<christof.schmitt@de.ibm.com>
> ---
>   drivers/scsi/scsi_lib.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2428,7 +2428,7 @@ scsi_internal_device_unblock(struct scsi
>   		sdev->sdev_state = SDEV_RUNNING;
>   	else if (sdev->sdev_state == SDEV_CREATED_BLOCK)
>   		sdev->sdev_state = SDEV_CREATED;
> -	else
> +	else if (sdev->sdev_state != SDEV_CANCEL)
>   		return -EINVAL;
>
>   	spin_lock_irqsave(q->queue_lock, flags);


If the device goes from block to offline then the IO gets stuck in the 
queue and we can hang like above. The attached patch just modifies your 
patch to also handle the offline case.

It looks like all these are regressions caused by:
5c10e63c943b4c67561ddc6bf61e01d4141f881f
[SCSI] limit state transitions in scsi_internal_device_unblock
so maybe this should go to stable?

--------------060102050608020600020405
Content-Type: text/plain;
 name="scsi-unblock-fix-state-check.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scsi-unblock-fix-state-check.patch"

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ee02d38..7f2f652 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2428,7 +2431,8 @@ scsi_internal_device_unblock(struct scsi_device *sdev)
 		sdev->sdev_state = SDEV_RUNNING;
 	else if (sdev->sdev_state == SDEV_CREATED_BLOCK)
 		sdev->sdev_state = SDEV_CREATED;
-	else
+	else if (sdev->sdev_state != SDEV_CANCEL &&
+		 sdev->sdev_state != SDEV_OFFLINE)
 		return -EINVAL;
 
 	spin_lock_irqsave(q->queue_lock, flags);

--------------060102050608020600020405--

From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Deleting SCSI device on blocked rport
Date: Sun, 05 Sep 2010 13:07:44 -0500
Message-ID: <4C83DC70.5030304@cs.wisc.edu>
References: <20100902110540.GB4097@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020408090102090704030005"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56490 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab0IESCb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Sep 2010 14:02:31 -0400
In-Reply-To: <20100902110540.GB4097@schmichrtp.mainz.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020408090102090704030005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 09/02/2010 06:05 AM, Christof Schmitt wrote:
> Deleting a SCSI device on a rport in the state FC_PORTSTATE_BLOCKED,
> but before the fast_io_fail_tmo expires results in a hanging kernel
> thread:
>
> STACK TRACE FOR TASK: 0x2a368b38 (sysfsd)
>
>   STACK:
>   0 schedule+1108 [0x5cac48]
>   1 schedule_timeout+528 [0x5cb7fc]
>   2 wait_for_common+266 [0x5ca6be]
>   3 blk_execute_rq+160 [0x354054]
>   4 scsi_execute+324 [0x3b7ef4]
>   5 scsi_execute_req+162 [0x3b80ca]
>   6 sd_sync_cache+138 [0x3cf662]
>   7 sd_shutdown+138 [0x3cf91a]
>   8 sd_remove+112 [0x3cfe4c]
>   9 __device_release_driver+124 [0x3a08b8]
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
> When the fast_io_fail_tmo or dev_loss_tmo expire, this does not
> change, so this has the potential of blocking the entire system.

Are you saying if you delete the device then one of those timers fires, 
nothing starts the queues? Is it because scsi_target_unblock is not 
seeing the devices, because the scsi_remove_device has already removed 
it from the device lists?

>
> The request queue seems to be STOPPED at the moment.
>          queue_flags = 0xa805
>

What causes the delete? Is it userspace or a scsi_remove_device by a LLD?

It looks like if the driver does fc_remove_host it will call 
fc_rport_final_delete->fc_terminate_rport_io->scsi_target_unblock..-> 
blk_start_queue which clears the queue_flags stopped bit and avoids the 
problem.

And it looks like if fc_terminate_rport_io is called by fast_io_fail or 
the dev_loss_tmo handlers that will call scsi_target_unblock too.

We hit something similar in iscsi, because it used to loop over devices 
in userspace and would call the device's delete sysfs attr.


> I am not sure how to approach this. One idea would be that the unblock
> in fc_terminate_rport_io should also trigger the release of the
> pending command, but it does not seem to happen.
>

I did the attached patch for iscsi. It starts the queue and runs it. You 
still have to wait for the transport class to move from blocked to 
online or dead/not-present, so the queuecommand chkready functions can 
fail or finish the IO.

One thing I was worried about was if something stopped the queues and 
really did not want IO sent, and did not have some checks like how FC 
and iSCSI do. Maybe we want to set some state on the scsi device so that 
scsi_request_fn can check it and just fail IO immediately?

--------------020408090102090704030005
Content-Type: text/plain;
 name="flush-scsi-dev.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="flush-scsi-dev.patch"

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9ade720..41c2625 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -67,8 +67,6 @@ static struct scsi_host_sg_pool scsi_sg_pools[] = {
 
 struct kmem_cache *scsi_sdb_cache;
 
-static void scsi_run_queue(struct request_queue *q);
-
 /*
  * Function:	scsi_unprep_request()
  *
@@ -397,7 +395,7 @@ static inline int scsi_host_is_busy(struct Scsi_Host *shost)
  * Notes:	The previous command was completely finished, start
  *		a new one if possible.
  */
-static void scsi_run_queue(struct request_queue *q)
+void scsi_run_queue(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index b4056d1..d041cdb 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -26,6 +26,7 @@ extern int scsi_init_hosts(void);
 extern void scsi_exit_hosts(void);
 
 /* scsi.c */
+extern void scsi_run_queue(struct request_queue *q);
 extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index c3f6737..b829ffc 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -923,6 +923,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 			return;
 
+		blk_start_queue(sdev->request_queue);
+		scsi_run_queue(sdev->request_queue);
+
 		bsg_unregister_queue(sdev->request_queue);
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);

--------------020408090102090704030005--

From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: possible circular locking dependency
Date: Tue, 10 Nov 2009 14:33:54 +0100
Message-ID: <20091110133354.GA11163@schmichrtp.mainz.de.ibm.com>
References: <20090921140050.GA17668@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:45129 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbZKJNdw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2009 08:33:52 -0500
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate1.uk.ibm.com (8.13.1/8.13.1) with ESMTP id nAADXt2r005473
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2009 13:33:55 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nAADXtZZ2555924
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2009 13:33:55 GMT
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id nAADXtjV008721
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2009 13:33:55 GMT
Received: from schmichrtp.mainz.de.ibm.com (dyn-9-155-42-48.mainz.de.ibm.com [9.155.42.48])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.12.11) with SMTP id nAADXsvt008713
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2009 13:33:55 GMT
Content-Disposition: inline
In-Reply-To: <20090921140050.GA17668@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Mon, Sep 21, 2009 at 04:00:50PM +0200, Christof Schmitt wrote:
> The lock dependency checker found this circular lock dependency
> warning on the 2.6.31 kernel plus some s390 patches. But the problem
> occurs in common SCSI code in 5 steps:
> 
> #4 first acquires scan_mutex in scsi_remove_device,
>    then sd_ref_mutex in scsi_disk_get_from_dev
> 
> #3 first acquires rport_delete_work in run_workqueue (inlined in worker_thread),
>    then scan_mutex in scsi_remove_device
> 
> #2 first acquires fc_host->work_q in run_workqueue,
>    then rport_delete_work also in run_workqueue
> 
> #1 first acquires cpu_add_remove_lock in destroy_workqueue,
>    then fc_host->work_q in cleanup_workqueue_thread
> 
> #0 first acquires sd_ref_mutex in scsi_disk_put,
>    then cpu_add_remove_lock in destroy_workqueue
> 
> I think this is only a theoretical warning which will be very hard or
> impossible to trigger in reality. But at least the warning should be
> fixed to keep the lock dependency checker useful.
> 
> Does anybody have an idea how to break this dependency chain?

This still happens with 2.6.32. I think it boils down to:

#4: The work function acquiring the sd_ref_mutex gives:
    cpu_add_remove_lock -> sd_ref_mutex

#0: Calling destroy_workqueue from scsi_host_dev_release introduces
    the dependency
    sd_ref_mutex -> cpu_add_remove_lock

But the sd_ref_mutex is required for the scsi_disk references. So far,
i don't see a good way to approach this.

> 
> The complete output of the lock dependency checker:
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.31 #12
> -------------------------------------------------------
> multipathd/2285 is trying to acquire lock:
>  (cpu_add_remove_lock){+.+.+.}, at: [<000000000006a38e>] destroy_workqueue+0x3a/0x274
> 
> but task is already holding lock:
>  (sd_ref_mutex){+.+.+.}, at: [<0000000000284202>] scsi_disk_put+0x36/0x5c
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #4 (sd_ref_mutex){+.+.+.}:
>        [<0000000000086782>] __lock_acquire+0xe76/0x1940
>        [<00000000000872dc>] lock_acquire+0x90/0xb8
>        [<000000000046fccc>] mutex_lock_nested+0x80/0x41c
>        [<0000000000284190>] scsi_disk_get_from_dev+0x30/0x6c
>        [<0000000000284830>] sd_shutdown+0x28/0x160
>        [<0000000000284ca4>] sd_remove+0x68/0xac
>        [<0000000000257450>] __device_release_driver+0x98/0x108
>        [<00000000002575e8>] device_release_driver+0x38/0x48
>        [<000000000025674a>] bus_remove_device+0xd6/0x11c
>        [<000000000025458c>] device_del+0x160/0x218
>        [<0000000000272650>] __scsi_remove_device+0x6c/0xb4
>        [<00000000002726da>] scsi_remove_device+0x42/0x54
>        [<00000000002727c6>] __scsi_remove_target+0xce/0x108
>        [<00000000002728ae>] __remove_child+0x3a/0x4c
>        [<0000000000253b0e>] device_for_each_child+0x72/0xbc
>        [<000000000027284e>] scsi_remove_target+0x4e/0x74
>        [<000000000027929a>] fc_rport_final_delete+0xb2/0x20c
>        [<0000000000069ed0>] worker_thread+0x25c/0x318
>        [<000000000006ff62>] kthread+0x9a/0xa4
>        [<000000000001c952>] kernel_thread_starter+0x6/0xc
>        [<000000000001c94c>] kernel_thread_starter+0x0/0xc
> 
> -> #3 (&shost->scan_mutex){+.+.+.}:
>        [<0000000000086782>] __lock_acquire+0xe76/0x1940
>        [<00000000000872dc>] lock_acquire+0x90/0xb8
>        [<000000000046fccc>] mutex_lock_nested+0x80/0x41c
>        [<00000000002726d0>] scsi_remove_device+0x38/0x54
>        [<00000000002727c6>] __scsi_remove_target+0xce/0x108
>        [<00000000002728ae>] __remove_child+0x3a/0x4c
>        [<0000000000253b0e>] device_for_each_child+0x72/0xbc
>        [<000000000027284e>] scsi_remove_target+0x4e/0x74
>        [<000000000027929a>] fc_rport_final_delete+0xb2/0x20c
>        [<0000000000069ed0>] worker_thread+0x25c/0x318
>        [<000000000006ff62>] kthread+0x9a/0xa4
>        [<000000000001c952>] kernel_thread_starter+0x6/0xc
>        [<000000000001c94c>] kernel_thread_starter+0x0/0xc
> 
> -> #2 (&rport->rport_delete_work){+.+.+.}:
>        [<0000000000086782>] __lock_acquire+0xe76/0x1940
>        [<00000000000872dc>] lock_acquire+0x90/0xb8
>        [<0000000000069eca>] worker_thread+0x256/0x318
>        [<000000000006ff62>] kthread+0x9a/0xa4
>        [<000000000001c952>] kernel_thread_starter+0x6/0xc
>        [<000000000001c94c>] kernel_thread_starter+0x0/0xc
> 
> -> #1 ((fc_host->work_q_name)){+.+.+.}:
>        [<0000000000086782>] __lock_acquire+0xe76/0x1940
>        [<00000000000872dc>] lock_acquire+0x90/0xb8
>        [<000000000006a2ae>] cleanup_workqueue_thread+0x62/0xac
>        [<000000000006a420>] destroy_workqueue+0xcc/0x274
>        [<0000000000279c4a>] fc_remove_host+0x1de/0x210
>        [<000000000034556e>] zfcp_adapter_scsi_unregister+0x96/0xc4
>        [<0000000000343df0>] zfcp_ccw_remove+0x9c/0x370
>        [<00000000002c2a6a>] ccw_device_remove+0x3e/0x1a8
>        [<0000000000257450>] __device_release_driver+0x98/0x108
>        [<00000000002575e8>] device_release_driver+0x38/0x48
>        [<000000000025674a>] bus_remove_device+0xd6/0x11c
>        [<000000000025458c>] device_del+0x160/0x218
>        [<00000000002c3404>] ccw_device_unregister+0x5c/0x7c
>        [<00000000002c3490>] io_subchannel_remove+0x6c/0x9c
>        [<00000000002be32e>] css_remove+0x3e/0x7c
>        [<0000000000257450>] __device_release_driver+0x98/0x108
>        [<00000000002575e8>] device_release_driver+0x38/0x48
>        [<000000000025674a>] bus_remove_device+0xd6/0x11c
>        [<000000000025458c>] device_del+0x160/0x218
>        [<000000000025466a>] device_unregister+0x26/0x38
>        [<00000000002be4bc>] css_sch_device_unregister+0x44/0x54
>        [<00000000002c435e>] ccw_device_call_sch_unregister+0x4e/0x78
>        [<0000000000069ed0>] worker_thread+0x25c/0x318
>        [<000000000006ff62>] kthread+0x9a/0xa4
>        [<000000000001c952>] kernel_thread_starter+0x6/0xc
>        [<000000000001c94c>] kernel_thread_starter+0x0/0xc
> 
> -> #0 (cpu_add_remove_lock){+.+.+.}:
>        [<0000000000086e5a>] __lock_acquire+0x154e/0x1940
>        [<00000000000872dc>] lock_acquire+0x90/0xb8
>        [<000000000046fccc>] mutex_lock_nested+0x80/0x41c
>        [<000000000006a38e>] destroy_workqueue+0x3a/0x274
>        [<0000000000265bb0>] scsi_host_dev_release+0x88/0x104
>        [<000000000025396a>] device_release+0x36/0xa0
>        [<000000000022ae92>] kobject_release+0x62/0xa8
>        [<000000000022c11c>] kref_put+0x74/0x94
>        [<00000000002771cc>] fc_rport_dev_release+0x2c/0x40
>        [<000000000025396a>] device_release+0x36/0xa0
>        [<000000000022ae92>] kobject_release+0x62/0xa8
>        [<000000000022c11c>] kref_put+0x74/0x94
>        [<000000000025396a>] device_release+0x36/0xa0
>        [<000000000022ae92>] kobject_release+0x62/0xa8
>        [<000000000022c11c>] kref_put+0x74/0x94
>        [<000000000006ba9c>] execute_in_process_context+0xa4/0xbc
>        [<000000000025396a>] device_release+0x36/0xa0
>        [<000000000022ae92>] kobject_release+0x62/0xa8
>        [<000000000022c11c>] kref_put+0x74/0x94
>        [<0000000000284216>] scsi_disk_put+0x4a/0x5c
>        [<0000000000285560>] sd_release+0x6c/0x108
>        [<0000000000126364>] __blkdev_put+0x1b8/0x1cc
>        [<00000000000f224e>] __fput+0x12a/0x240
>        [<00000000000ee4c0>] filp_close+0x78/0xa8
>        [<00000000000ee5d0>] SyS_close+0xe0/0x148
>        [<000000000002a042>] sysc_noemu+0x10/0x16
>        [<0000020000041160>] 0x20000041160
> 
> other info that might help us debug this:
> 
> 2 locks held by multipathd/2285:
>  #0:  (&bdev->bd_mutex){+.+.+.}, at: [<00000000001261f2>] __blkdev_put+0x46/0x1cc
>  #1:  (sd_ref_mutex){+.+.+.}, at: [<0000000000284202>] scsi_disk_put+0x36/0x5c
> 
> stack backtrace:
> CPU: 1 Not tainted 2.6.31 #12
> Process multipathd (pid: 2285, task: 000000002d87b900, ksp: 000000002eca7800)
> 0000000000000000 000000002eca7770 0000000000000002 0000000000000000 
>        000000002eca7810 000000002eca7788 000000002eca7788 000000000046db82 
>        0000000000000000 0000000000000001 000000002d87bfd0 0000000000000000 
>        000000000000000d 0000000000000000 000000002eca77d8 000000000000000e 
>        000000000047fc30 0000000000017d80 000000002eca7770 000000002eca77b8 
> Call Trace:
> ([<0000000000017c82>] show_trace+0xee/0x144)
>  [<000000000008532e>] print_circular_bug_tail+0x10a/0x110
>  [<0000000000086e5a>] __lock_acquire+0x154e/0x1940
>  [<00000000000872dc>] lock_acquire+0x90/0xb8
>  [<000000000046fccc>] mutex_lock_nested+0x80/0x41c
>  [<000000000006a38e>] destroy_workqueue+0x3a/0x274
>  [<0000000000265bb0>] scsi_host_dev_release+0x88/0x104
>  [<000000000025396a>] device_release+0x36/0xa0
>  [<000000000022ae92>] kobject_release+0x62/0xa8
>  [<000000000022c11c>] kref_put+0x74/0x94
>  [<00000000002771cc>] fc_rport_dev_release+0x2c/0x40
>  [<000000000025396a>] device_release+0x36/0xa0
>  [<000000000022ae92>] kobject_release+0x62/0xa8
>  [<000000000022c11c>] kref_put+0x74/0x94
>  [<000000000025396a>] device_release+0x36/0xa0
>  [<000000000022ae92>] kobject_release+0x62/0xa8
>  [<000000000022c11c>] kref_put+0x74/0x94
>  [<000000000006ba9c>] execute_in_process_context+0xa4/0xbc
>  [<000000000025396a>] device_release+0x36/0xa0
>  [<000000000022ae92>] kobject_release+0x62/0xa8
>  [<000000000022c11c>] kref_put+0x74/0x94
>  [<0000000000284216>] scsi_disk_put+0x4a/0x5c
>  [<0000000000285560>] sd_release+0x6c/0x108
>  [<0000000000126364>] __blkdev_put+0x1b8/0x1cc
>  [<00000000000f224e>] __fput+0x12a/0x240
>  [<00000000000ee4c0>] filp_close+0x78/0xa8
>  [<00000000000ee5d0>] SyS_close+0xe0/0x148
>  [<000000000002a042>] sysc_noemu+0x10/0x16
>  [<0000020000041160>] 0x20000041160
> INFO: lockdep is turned off.
> 
> --
> Christof Schmitt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

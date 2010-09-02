From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Deleting SCSI device on blocked rport
Date: Thu, 2 Sep 2010 13:05:41 +0200
Message-ID: <20100902110540.GB4097@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:37226 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab0IBLFp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2010 07:05:45 -0400
Received: from d06nrmr1806.portsmouth.uk.ibm.com (d06nrmr1806.portsmouth.uk.ibm.com [9.149.39.193])
	by mtagate1.uk.ibm.com (8.13.1/8.13.1) with ESMTP id o82B5fik017979
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2010 11:05:41 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o82B5f9L3629272
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2010 12:05:41 +0100
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o82B5f0C008974
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2010 12:05:41 +0100
Received: from schmichrtp.mainz.de.ibm.com (dyn-9-155-42-47.mainz.de.ibm.com [9.155.42.47])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.12.11) with SMTP id o82B5fe0008967
	for <linux-scsi@vger.kernel.org>; Thu, 2 Sep 2010 12:05:41 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Deleting a SCSI device on a rport in the state FC_PORTSTATE_BLOCKED,
but before the fast_io_fail_tmo expires results in a hanging kernel
thread:

STACK TRACE FOR TASK: 0x2a368b38 (sysfsd)

 STACK:
 0 schedule+1108 [0x5cac48]
 1 schedule_timeout+528 [0x5cb7fc]
 2 wait_for_common+266 [0x5ca6be]
 3 blk_execute_rq+160 [0x354054]
 4 scsi_execute+324 [0x3b7ef4]
 5 scsi_execute_req+162 [0x3b80ca]
 6 sd_sync_cache+138 [0x3cf662]
 7 sd_shutdown+138 [0x3cf91a]
 8 sd_remove+112 [0x3cfe4c]
 9 __device_release_driver+124 [0x3a08b8]
10 device_release_driver+60 [0x3a0a5c]
11 bus_remove_device+266 [0x39fa76]
12 device_del+340 [0x39d818]
13 __scsi_remove_device+204 [0x3bcc48]
14 scsi_remove_device+66 [0x3bcc8e]
15 sysfs_schedule_callback_work+50 [0x260d66]
16 worker_thread+622 [0x162326]
17 kthread+160 [0x1680b0]
18 kernel_thread_starter+6 [0x10aaea]

When the fast_io_fail_tmo or dev_loss_tmo expire, this does not
change, so this has the potential of blocking the entire system.

The request queue seems to be STOPPED at the moment.
        queue_flags = 0xa805

I am not sure how to approach this. One idea would be that the unblock
in fc_terminate_rport_io should also trigger the release of the
pending command, but it does not seem to happen.

The above stack trace is from 2.6.35, but the same also happens with
2.6.36-rc3, only the kernel threads kworker/u are affected.

--
Christof

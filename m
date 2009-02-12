From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Deadlock during multipath failover
Date: Thu, 12 Feb 2009 10:40:22 +0100
Message-ID: <20090212094022.GA4973@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:57561 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbZBLJky (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Feb 2009 04:40:54 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

During failover tests on a current distribution kernel, we found this
problem. From reading the code, the upstream kernel has the same
problem:

During multipath failover tests with SCSI on System z, the kernel
deadlocks in this situation:

>  STACK:
>  0 blk_add_timer+206 [0x2981ea]
>  1 blk_rq_timed_out+132 [0x2982a8]
>  2 blk_abort_request+114 [0x29833e]
>  3 blk_abort_queue+92 [0x2983a8]
>  4 deactivate_path+74 [0x3e00009625a]
>  5 run_workqueue+236 [0x149e04]
>  6 worker_thread+294 [0x149fce]
>  7 kthread+110 [0x14f436]
>  8 kernel_thread_starter+6 [0x10941a]

blk_abort_queue takes the queue_lock with spinlock_irqsave and walks
the timer_list with list_for_each_entry_safe. Since a path to a SCSI
device just failed, the rport state is FC_PORTSTATE_BLOCKED. This
rport state triggers blk_add_timer that calls list_add_tail to move
the request to the end of timer_list. Thus, the
list_for_each_entry_safe never reaches the end of the timer_list, it
continously moves the requests to the end of the list.

The rport state FC_PORTSTATE_BLOCKED would end, when the function
fc_timeout_deleted_rport would run to remove the rport. But this
function was schedules from queue_delayed_work. The timer already
expired, but the timer function does not run, because the timer
interrupt is disabled from the spinlock_irqsave call.

Christof Schmitt

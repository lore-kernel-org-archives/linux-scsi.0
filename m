From: sthumma@codeaurora.org
Subject: Re: Race condition in block layer runtime PM init and scsi disk
 driver
Date: Wed, 9 Oct 2013 08:32:31 -0000
Message-ID: <4ed022cf2fedc9ee1049254ea274f705.squirrel@www.codeaurora.org>
References: <6c835b531761fe70209d015daa6b87e8.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38955 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab3JIIcc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Oct 2013 04:32:32 -0400
In-Reply-To: <6c835b531761fe70209d015daa6b87e8.squirrel@www.codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sthumma@codeaurora.org
Cc: Aaron Lu <aaron.lu@intel.com>, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org

> Hi Aaron,
>
> I found a race condition with the block layer runtime PM due to which
> the q->nr_pending is decremented to less than zero (0xFFFF_FFFF (-1))
> and hence the blk pre-runtime suspend always returns -EBUSY.
>
>
> The issue is easily reproduced with a scsi disk with disabled tagged
> command queuing
>
> sd_probe_async() ->
> 	add_disk() ->
> 		disk_add_event() ->
> 			schedule(disk_events_workfn)
> 	sd_revalidate_disk()
> 	blk_pm_runtime_init()
> return;
>
> Let's say the disk_events_workfn() calls sd_check_events() which tries
> to send test_unit_ready() and because of sd_revalidate_disk() trying to
> send another commands the test_unit_ready() might be re-queued as the
> tagged command queuing is disabled.
>
> So the race condition is -
>
> Thread 1 			  |		Thread 2
> sd_revalidate_disk()		  |	sd_check_events()
> ...nr_pending = 0 as q->dev = NULL|	scsi_queue_insert()
> blk_runtime_pm_init()		  | 	blk_pm_requeue_request() ->
> 				  |	nr_pending = -1 since
> 				  |	q->dev != NULL
>
> Do you have any suggestions on how to fix this issue?
>
>
> --
> Regards,
> Sujit
>



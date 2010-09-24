From: Mark Lord <kernel@teksavvy.com>
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
 prevent?
Date: Thu, 23 Sep 2010 23:51:21 -0400
Message-ID: <4C9C2039.8050903@teksavvy.com>
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BEB49.2060208@interlog.com> <4C9C129E.5050504@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C9C129E.5050504@teksavvy.com>
Sender: linux-ide-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Joel Becker <joel.becker@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 10-09-23 10:53 PM, Mark Lord wrote:
> On 10-09-23 08:05 PM, Douglas Gilbert wrote:
>> Mark,
>> If you issued the SG_IO ioctl with a timeout of at
>> least 66 minutes (expressed in milliseconds) then
>> it looks like ata_scsi_queuecmd() has a problem.
> ..
>
> Mmm.. more like blk_execute_rq() perhaps.
> That's where the wait_for_completion(&wait) call is at.
>
> Perhaps I should change it to wait in smaller increments,
> so that the lockup detection doesn't trigger on it..
..

This patch (below) seems to work.

Does this look kosher enough for me to roll it up
as a proper patch submission?   Jens?  Joel?

The problem, again, is that the hangcheck timer fires
inappropriately during very long SG_IO commands,
such as --security-erase operations which take minutes/hours to complete.

Thanks

--- old/block/blk-exec.c	2010-08-26 19:47:12.000000000 -0400
+++ linux/block/blk-exec.c	2010-09-23 23:41:47.478826002 -0400
@@ -95,7 +95,8 @@
  
  	rq->end_io_data = &wait;
  	blk_execute_rq_nowait(q, bd_disk, rq, at_head, blk_end_sync_rq);
-	wait_for_completion(&wait);
+	while (!wait_for_completion_timeout(&wait, (sysctl_hung_task_timeout_secs >> 1) * HZ))
+		; /* periodic wakeup prevents "hung_task" warnings */
  
  	if (rq->errors)
  		err = -EIO;

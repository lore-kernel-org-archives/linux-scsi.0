From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: serial_number and serial_number_at_timeout in 2.4
Date: Mon, 15 Sep 2003 14:09:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030915210923.GA1702@beaverton.ibm.com>
References: <20030914174104.A20722@one-eyed-alien.net> <Pine.LNX.4.56.0309152048550.1409@kai.makisara.local> <002e01c37bc2$e838bc10$3906ee0f@americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:51177 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S261639AbTIOVJL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Sep 2003 17:09:11 -0400
Content-Disposition: inline
In-Reply-To: <002e01c37bc2$e838bc10$3906ee0f@americas.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: Charlie Brett <cfb@ldl.fc.hp.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, dann frazier <dannf@hp.com>

Charlie Brett [cfb@ldl.fc.hp.com] wrote:
> We discovered what appears to be a race problem in scsi_done() on the 2.4
> kernel. On MP systems, we found the following to occur:
> 
> 1) A command is scheduled through scsi_dispatch_cmd(). This will start the
> timeout timer and call queuecommand().
> 2) The command completes and the interrupt handler acquires the lock.
> 3) The timeout occurs before scsi_done()[scsi_old_done()] is called (which
> would have turned off the timeout).
> 4) The timeout routine, scsi_old_times_out(), waits for the lock.
> In scsi_done() the following lines are executed:
> 
>     SCpnt->serial_number = 0;
>     SCpnt->serial_number_at_timeout = 0;
> 
> 5) If, it is decided that the command should be retried, the lock is
> released to call scsi_dispatch_cmd().
> 6) As soon as the lock is released, the timeout routine acquires the lock
> and starts to complete. It will either call scsi_abort() or scsi_reset(). In
> each of the routines, serial_number and serial_number_at_timeout are
> compared, which are now both 0, so the routines continue (calling
> scsi_done() a second time).
> 
> To minimize the changes, we would like propose the addition of a check to
> see if the serial number is zero at the beginning of scsi_old_times_out().
> This would prevent to continuation of an abort or reset on a command that
> scsi_done() has already processed.
> 
> Note: If scsi_dispatch_cmd() does start, before the timeout routine, then a
> new serial number is assigned, which cause the current test to work.
> 
> Any thoughts?

It has been a while since I looked at that the old error handler, but
with your change you would still have an issue with the call to
scsi_old_done from the driver if scsi_old_times_out aquired the lock
first. As the update_timeout function does not past the return value
back from scsi_delete_timer so scsi_old_done does not know the timeout
is already running.

Moving to the new error handler would be better answer, but depending on
your driver maybe plugging the old error handler is your only option.

-andmike
--
Michael Anderson
andmike@us.ibm.com


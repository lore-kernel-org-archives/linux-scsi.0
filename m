From: "Charlie Brett" <cfb@ldl.fc.hp.com>
Subject: Re: serial_number and serial_number_at_timeout in 2.4
Date: Tue, 16 Sep 2003 08:08:13 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <009201c37c5b$f7fd32e0$3906ee0f@americas.cpqcorp.net>
References: <20030914174104.A20722@one-eyed-alien.net> <Pine.LNX.4.56.0309152048550.1409@kai.makisara.local> <002e01c37bc2$e838bc10$3906ee0f@americas.cpqcorp.net> <20030915210923.GA1702@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel7.hp.com ([156.153.255.213]:16550 "EHLO atlrel7.hp.com")
	by vger.kernel.org with ESMTP id S261930AbTIPOIP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Sep 2003 10:08:15 -0400
Received: from udlkern.fc.hp.com (udlkern.fc.hp.com [15.1.52.48])
	by atlrel7.hp.com (Postfix) with ESMTP id 58C9B1C0230C
	for <linux-scsi@vger.kernel.org>; Tue, 16 Sep 2003 10:08:14 -0400 (EDT)
Received: from CFBLAPTOP (dhcp-ftcbldg5pc-oae-aag057.fc.hp.com [15.238.6.57])
	by udlkern.fc.hp.com (8.11.1/8.9.3 SMKit7.01) with ESMTP id h8GE8EH16123
	for <linux-scsi@vger.kernel.org>; Tue, 16 Sep 2003 08:08:14 -0600 (MDT)
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>

You're correct about the reverse scenerio. We were trying to keep the fix as
simple as possible. With that in mind I would like to go back to our
original thought and propose changing the 2 locations in scsi_abort() where
the serial numbers are compared to also test for serial_number having a zero
value. I haven't quite figured out why the second test is there, it really
doesn't make sense, and if either one of the fields changed between the
first test and the second test, there's a serious problem (considering the
lock was held during this time). There is also one test in scsi_reset() that
could be changed as well. This should not affect how it behaves when it is
called by scsi_done(), since it only does this with the
SCSI_RESET_ASYNCHRONOUS cleared, and the test is not performed. Adding the
test to scsi_reset() does reduce the possibility of collision from the scsi
error handler (scsi_eh_*), which can call scsi_reset() from
scsi_unjam_host() without the lock held.

So now, how about in scsi_abort() and scsi_reset(), changing:

if (SCpnt->serial_number != SCpnt->serial_number_at_timeout) {
    return 0;
}

to:

if (!SCpnt->serial_number ||
    (SCpnt->serial_number != SCpnt->serial_number_at_timeout)) {
    return 0;
}

Note: The scsi_done() function I was referring to is ->scsi_done() which in
this case is scsi_old_done().

       Charlie Brett - Hewlett Packard


----- Original Message ----- 
From: "Mike Anderson" <andmike@us.ibm.com>
To: "Charlie Brett" <cfb@ldl.fc.hp.com>
Cc: "Linux SCSI list" <linux-scsi@vger.kernel.org>; "dann frazier"
<dannf@hp.com>
Sent: Monday, September 15, 2003 3:09 PM
Subject: Re: serial_number and serial_number_at_timeout in 2.4


> Charlie Brett [cfb@ldl.fc.hp.com] wrote:
> > We discovered what appears to be a race problem in scsi_done() on the
2.4
> > kernel. On MP systems, we found the following to occur:
> >
> > 1) A command is scheduled through scsi_dispatch_cmd(). This will start
the
> > timeout timer and call queuecommand().
> > 2) The command completes and the interrupt handler acquires the lock.
> > 3) The timeout occurs before scsi_done()[scsi_old_done()] is called
(which
> > would have turned off the timeout).
> > 4) The timeout routine, scsi_old_times_out(), waits for the lock.
> > In scsi_done() the following lines are executed:
> >
> >     SCpnt->serial_number = 0;
> >     SCpnt->serial_number_at_timeout = 0;
> >
> > 5) If, it is decided that the command should be retried, the lock is
> > released to call scsi_dispatch_cmd().
> > 6) As soon as the lock is released, the timeout routine acquires the
lock
> > and starts to complete. It will either call scsi_abort() or
scsi_reset(). In
> > each of the routines, serial_number and serial_number_at_timeout are
> > compared, which are now both 0, so the routines continue (calling
> > scsi_done() a second time).
> >
> > To minimize the changes, we would like propose the addition of a check
to
> > see if the serial number is zero at the beginning of
scsi_old_times_out().
> > This would prevent to continuation of an abort or reset on a command
that
> > scsi_done() has already processed.
> >
> > Note: If scsi_dispatch_cmd() does start, before the timeout routine,
then a
> > new serial number is assigned, which cause the current test to work.
> >
> > Any thoughts?
>
> It has been a while since I looked at that the old error handler, but
> with your change you would still have an issue with the call to
> scsi_old_done from the driver if scsi_old_times_out aquired the lock
> first. As the update_timeout function does not past the return value
> back from scsi_delete_timer so scsi_old_done does not know the timeout
> is already running.
>
> Moving to the new error handler would be better answer, but depending on
> your driver maybe plugging the old error handler is your only option.
>
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
>
>


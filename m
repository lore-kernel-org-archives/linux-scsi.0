From: "Charlie Brett" <cfb@ldl.fc.hp.com>
Subject: serial_number and serial_number_at_timeout in 2.4
Date: Mon, 15 Sep 2003 13:52:34 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <002e01c37bc2$e838bc10$3906ee0f@americas.cpqcorp.net>
References: <20030914174104.A20722@one-eyed-alien.net> <Pine.LNX.4.56.0309152048550.1409@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel8.hp.com ([156.153.255.206]:19124 "EHLO atlrel8.hp.com")
	by vger.kernel.org with ESMTP id S261419AbTIOTwh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Sep 2003 15:52:37 -0400
Received: from udlkern.fc.hp.com (udlkern.fc.hp.com [15.1.52.48])
	by atlrel8.hp.com (Postfix) with ESMTP id E736C1C00CC9
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2003 15:52:34 -0400 (EDT)
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: dann frazier <dannf@hp.com>

We discovered what appears to be a race problem in scsi_done() on the 2.4
kernel. On MP systems, we found the following to occur:

1) A command is scheduled through scsi_dispatch_cmd(). This will start the
timeout timer and call queuecommand().
2) The command completes and the interrupt handler acquires the lock.
3) The timeout occurs before scsi_done()[scsi_old_done()] is called (which
would have turned off the timeout).
4) The timeout routine, scsi_old_times_out(), waits for the lock.
In scsi_done() the following lines are executed:

    SCpnt->serial_number = 0;
    SCpnt->serial_number_at_timeout = 0;

5) If, it is decided that the command should be retried, the lock is
released to call scsi_dispatch_cmd().
6) As soon as the lock is released, the timeout routine acquires the lock
and starts to complete. It will either call scsi_abort() or scsi_reset(). In
each of the routines, serial_number and serial_number_at_timeout are
compared, which are now both 0, so the routines continue (calling
scsi_done() a second time).

To minimize the changes, we would like propose the addition of a check to
see if the serial number is zero at the beginning of scsi_old_times_out().
This would prevent to continuation of an abort or reset on a command that
scsi_done() has already processed.

Note: If scsi_dispatch_cmd() does start, before the timeout routine, then a
new serial number is assigned, which cause the current test to work.

Any thoughts?

   Thanks,
            Charlie Brett - Hewlett Packard



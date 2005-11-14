From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 5/10] convert st to use scsi_execute_async
Date: Mon, 14 Nov 2005 17:55:06 +1000
Message-ID: <437842DA.80800@torque.net>
References: <1131444404.23111.66.camel@max> <Pine.LNX.4.63.0511121859070.10335@kai.makisara.local> <43763E94.40406@cs.wisc.edu> <43764861.6030408@cs.wisc.edu> <Pine.LNX.4.63.0511130938570.15153@kai.makisara.local> <437772EA.7080100@redhat.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:21888 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1750981AbVKNHyG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Nov 2005 02:54:06 -0500
In-Reply-To: <437772EA.7080100@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

Doug Ledford wrote:
> Kai Makisara wrote:
> 
>> On Sat, 12 Nov 2005, Mike Christie wrote:
> 
> 
> I noticed that these patches still have the same bug that the 2.4 kernel
> st driver has, namely the holding of the st's SCSI request struct until
> write_behind_check is called.  This behavior is responsible for at least
> two bugs with tape systems under 2.4 that we've fixed.  The first bug is
> that if you perform a write to a tape device that involves an async
> write behind request, then attempt to access the device via the sg
> mechanism without performing any intervening read or ioctl commands on
> the st device, the sg access will hang.  This only happens on SCSI
> controllers that set the cmd_per_lun value == 1 (eg. mptscsih).  In
> order to replicate this problem you need one application writing to the
> tape device, then pausing, then something as simple as attempting to do
> an INQUIRY to the tape while the writer is paused causes the hang.  This
> happens at least with NetBackup, possibly with others as well.  The
> second bug is related to multiple tape usage on the same system.  It
> only happens on x86_64, not i686, but with multiple tapes in use the
> system eventually attempts to dma map a null pointer resulting in a
> BUG().  I didn't root cause the dma mapping issue, but I did verify that
> once the initial bug was fixed, the dma mapping bug went away as well
> (either because whatever race window existed was reduced to so small
> that we no longer hit it or the problem was in fact fixed).  The patch
> we used to solve the problem is attached.  As a side note, holding on to
> a command without any upper bound on when it will be released is simply
> a *bad* idea.  Get the information you need from the command and free it.

Doug,
It might indeed be a bad idea, but there is the odd SCSI
command that is defined that way. I wonder if any cd/dvd
drive implements the GET EVENT STATUS NOTIFICATION command
in asynchronous notification mode (see MMC-4)?

INQUIRY and REPORT LUNS have implicit "head of queue"
task attribute and should not be blocked by the scsi
subsystem in response to a TASK SET FULL status. In the
case of the mptscsih driver, the limit seems to be in
the HBA.

OTOH while formatting SCSI disks in foreground
(immed=0) I noticed that sending an innocent INQUIRY
or TEST UNIT READY can be fatal (for the format). This
occurred because the disk being formatted didn't respond
to the INQUIRY (perhaps it should have returned BUSY),
the INQUIRY timed out and the disk ended up being reset
which aborted the format.

In some cases I think a "fire and forget" timeout would
be useful: when the timeout goes off, just report it
back to the caller, clean up resources, but do _not_
start issuing, a command abort escalating to a lu/target/bus
reset. If the LLD does see a response to that command later,
then it just consigns it to the bit bucket.

Doug Gilbert

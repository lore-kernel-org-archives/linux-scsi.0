From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Incorrect response to SK/ASC/ASCQ = x 02/04/01 (becoming ready)
Date: 22 Aug 2004 19:32:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093217548.1727.367.camel@mulgrave>
References: <Pine.LNX.4.44L0.0408221154220.15992-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:47834 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267440AbUHVXc3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Aug 2004 19:32:29 -0400
In-Reply-To: <Pine.LNX.4.44L0.0408221154220.15992-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, "Mike R." <turbanator1@verizon.net>

On Sun, 2004-08-22 at 12:21, Alan Stern wrote:
> The SCSI core doesn't react properly when it receives SK/ASC/ASCQ = x 
> 02/04/01 = Not Ready, Logical unit in process of becoming ready.
> 
> The core is complex enough that I can't tell exactly what's wrong or how
> it should be fixed.  That particular sense data combination is spotted in
> two different places: scsi_lib.c:scsi_io_completion() and
> scsi_error.c:scsi_check_sense().  It's not clear which one is causing the
> problem -- maybe they both are.
> 
> Anyway, the reaction in both routines is to requeue the request for
> immediate retry.  Obviously that's the wrong thing to do.  The request
> should be retried, yes, but only after a delay of, say, a second or so.  
> (Presumably the queue should remain blocked during that time.)  And this
> should keep happening for up to maybe 30 seconds.
> 
> Instead what happens is that all the retries get exhausted in a fraction 
> of a second, which isn't long enough for any device to spin up.  The 
> drivers then proceed blindly with whatever else they want to do, which 
> generally incurs its own set of errors.

Well, that all depends on what's causing this.

You're correct in that the mid-layer assumes an operational device won't
spontaneously spin down, so it does interpret this sense as indicating a
transient error....In fact, most often it's the sense returned by disc
arrays after a bus or device reset, which is the case the code is
designed to handle.

If the spin down is caused by user intervention (actually sending a spin
down command followed by a spin up) then I'd say the user needs to
ensure the device has fully spun up before using it.

What other conditions produce something like this?

> This problem seems to be particularly bad for USB DVD drives.  One user
> was able to work around it by manually loading the usb-storage driver 20
> to 30 seconds after plugging the drive into the computer.  Obviously it
> would be much better to have the system do the right thing in the first
> place.

Hmm, well, the sr code does contain a loop (in get_capabilites()) for
waiting for the device to become ready, but it obviously simply sends
the command five times and then gives up.  Perhaps adding logic here to
wait much longer might fix the DVD problem?

James



From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Incorrect response to SK/ASC/ASCQ = x 02/04/01 (becoming ready)
Date: Mon, 23 Aug 2004 11:10:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412A08D9.7020502@adaptec.com>
References: <Pine.LNX.4.44L0.0408221154220.15992-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:62641 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265027AbUHWPKb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 11:10:31 -0400
In-Reply-To: <Pine.LNX.4.44L0.0408221154220.15992-100000@netrider.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, "Mike R." <turbanator1@verizon.net>

Alan Stern wrote:
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

If the queue is a _general_ SCSI queue on which _any_ kind of
SCSI command can be queued to the LU/target (i.e. not necessarily
medium access), then you must _not_ block it.  HOQ task attribute
commands could be sent which may operate other components of the
LU/target.

But you should block the IO (R/W) general queue, yes.  _A_ way
to do this is to send START STOP UNIT (0x1B) with the IMMED
bit set to 0.  When the command completes, you'll get status
and set the device to active, unblock the IO queue, etc.

		Luben

> Instead what happens is that all the retries get exhausted in a fraction
> of a second, which isn't long enough for any device to spin up.  The
> drivers then proceed blindly with whatever else they want to do, which
> generally incurs its own set of errors.
> 
> This problem seems to be particularly bad for USB DVD drives.  One user
> was able to work around it by manually loading the usb-storage driver 20
> to 30 seconds after plugging the drive into the computer.  Obviously it
> would be much better to have the system do the right thing in the first
> place.
> 
> I don't know enough about the SCSI core to change it properly.  Can
> someone please help?
> 
> Alan Stern
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: Tue, 28 Oct 2003 17:49:48 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0310281737350.6912-100000@ida.rowland.org>
References: <1067376788.1056.5.camel@ronald.kuetemeier.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:30724 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261798AbTJ1Wtt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 17:49:49 -0500
In-Reply-To: <1067376788.1056.5.camel@ronald.kuetemeier.com>
List-Id: linux-scsi@vger.kernel.org
To: Ronald Kuetemeier <ronald@kuetemeier.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Tue, 28 Oct 2003, Ronald Kuetemeier wrote:

> Ah, now that makes sense, should have looked at the code ...
> Fixed it with a *.debug to messages.
> Anyhow,quick test.
> 1st. (which works and is now in my rc.local): mount successes 
> echo "Sony:Sony DSC:0x4000" > /proc/scsi/device_info
> into succ-usb_messages.txt.
> 
> 2nd. tried to mount without success, i.e error
> after reboot and no rc.local entry
> into err-usb_messages.txt
> echo "Sony:Sony DSC:0x0000" > /proc/scsi/device_inf
> didn't do the trick.
> 
> Hope this helps,
> Ronald

All right.  The logs make it clear.

Your device doesn't like the MODE-SENSE(10) for page 3F.  But instead of 
reporting a normal error code, it tries to send an overlong packet (i.e., 
longer than the host asked for).  Of course this is an error, and the SCSI 
code retries several times, eventually giving up.  Oddly enough, the 
device then returns an Invalid Command status for the _next_ command, 
which is an innocuous TEST-UNIT-READY.  I don't understand that.

Anyway, the SCSI layer recognizes that something is wrong.  But for some
unknown reason it goes right back to the beginning of the probe sequence,
starting with another TEST-UNIT-READY, READ-CAPACITY, and moving on.  
Naturally enough, when it reaches the MODE-SENSE(10) again the same
problem reoccurs.  Patrick, do you know why the sd initialization code is
doing this?

Even the successful logfile had an odd feature.  The sd driver knew enough
to skip both the page 3F and the page 8 MODE-SENSE(10) calls.  But then it
went ahead and issued MODE-SENSE(6) for page 8!  Fortunately this worked
(or rather, failed cleanly enough) for things to progress okay.  Patrick,
can you explain that too?

Alan Stern




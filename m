From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Sat, 26 Apr 2003 11:22:20 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304261055480.8773-100000@netrider.rowland.org>
References: <200304261024.37470.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:13319 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S261521AbTDZPKH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 11:10:07 -0400
In-Reply-To: <200304261024.37470.oliver@neukum.org>
List-Id: linux-scsi@vger.kernel.org
To: oliver@neukum.name
Cc: Andries.Brouwer@cwi.nl, stelian@popies.net, James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, USB development list <linux-usb-devel@lists.sourceforge.net>, pwkpete@yahoo.com

On Sat, 26 Apr 2003, Oliver Neukum wrote:

> > Do you mean it makes user space drivers inferior to kernel drivers?  I
> > don't see how.  The LLDD would treat them both the same, doing a minimum
> > of modifications.
> 
> You got to make up your mind :-)
> So the LLDD should filter in both cases?

Maybe I wasn't clear enough.  I want the LLDD to do exactly the same thing
regardless of where the request originates from.  I want it to do a
minimum of filtering, really just filtering out commands that are known to
crash the device.  I want it to do essentially no alteration of commands,
just enough to work at all.

In fact, I would argue that usb-storage is already doing too much.  It 
should not be converting between the 6-byte and 10-byte forms for several 
commands.  The caller should be smart enough to handle that.

The changes I'm proposing aren't that large.  There's just a couple of
rules the SCSI code should follow:

	(o) Use the 10-byte command form by default.  If it doesn't work, 
try the 6-byte form, and if that works better then flag the device entry 
as requiring the 6-byte form.  The READ and WRITE commands are already 
handled this way.

The MODE-SENSE problem that Andries was addressing wouldn't exist if this
rule had been followed.  The code tried the 6-byte form first and then did
not fall back to the 10-byte form when that failed.

	(o) Request the smallest-size data transfer that includes the data 
needed.  This is kind of vague, but I mean something like what the INQUIRY 
code now does: start with a minimum-sized 36-byte transfer and from that 
determine how much more is needed and supported.  Maybe try to stick with 
sizes that are commonly used by other popular OS's.

	If these two rules were followed carefully, we could remove a lot
of excess code from usb-storage and things would work more reliably.  So
far as I can see, the commands that would be affected are REQUEST-SENSE,
MODE-SENSE, MODE_SELECT, and maybe INQUIRY.

> > If you mean that it would make user space drivers inferior to the way they
> > work now, then I agree.  At least, they might be inferior in terms of
> > performance, since they would no longer have commands altered
> > automatically for their benefit.  On the other hand, they would be
> > superior in terms of receiving a more transparent channel directly to the
> > device.  For some people this is very important.
> 
> For the larger part it's vastly important that exactly that doesn't happen.
> Eg. I want the user to have access to a device, but I don't want him to
> be able to crash the device. It's a multiuser system and others might
> want to use the device afterwards.
> We usually require root level to get a transparent channel to hardware.

Nothing I propose involves relaxing permissions checking for access to
devices.  If root privileges were required before they will still be
required.  In addition, I am also proposing that the LLDD continue to
filter out commands that are known to crash the device.

If a user program wants convenient access to a device with the kernel
doing all the appropriate conversions to make things work, then the
program should be a SCSI _client_ and use the sd or sr facilities.  A
user-space _driver_ naturally must accept more responsibility for making
things work okay.

> If filtering is marginal you need to use yet another demon to be checked for
> buffer overflows, etc. ... .

No more than any other daemon or device driver requires.

> > I think it won't really be a problem.  A user-space driver _ought_ to be
> > prepared to cope with the quirks and special requirements of a particular
> > device.
> 
> But can you depend on it? From an administration viewpoint you create a
> hole for a DoS attack.

That's true for any user-space driver.  Consider an X11 server, for
example.  Of course a buggy user-space USB-SCSI driver can cause problems,
just as a buggy X11 server can.  The same mechanisms that protect against
one can protect against the other.

Alan Stern


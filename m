From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Fri, 25 Apr 2003 20:58:47 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304252046570.5053-100000@netrider.rowland.org>
References: <200304251712.41252.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:23813 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S264554AbTDZAqg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 20:46:36 -0400
In-Reply-To: <200304251712.41252.oliver@neukum.org>
List-Id: linux-scsi@vger.kernel.org
To: oliver@neukum.name
Cc: Andries.Brouwer@cwi.nl, stelian@popies.net, James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, USB development list <linux-usb-devel@lists.sourceforge.net>, pwkpete@yahoo.com

On Fri, 25 Apr 2003, Oliver Neukum wrote:

> > To begin with, in my opinion the LLDD should do a minimum of filtering and
> > altering.  Not only is it frequently difficult to know if such actions are
> > valid or will be acceptable to the caller, there is also the principle
> > that user-generated requests (via the scsi-generic interface) should be
> > left totally alone -- after all, the user may be probing precisely to
> > determine whether or not the device will accept a particular command.
> 
> Seriously, why this principle? It makes user space drivers inferior in
> some respects. After all, we usually require a special capability to
> allow actions that can crash hardware.

Do you mean it makes user space drivers inferior to kernel drivers?  I 
don't see how.  The LLDD would treat them both the same, doing a minimum 
of modifications.

If you mean that it would make user space drivers inferior to the way they
work now, then I agree.  At least, they might be inferior in terms of
performance, since they would no longer have commands altered
automatically for their benefit.  On the other hand, they would be
superior in terms of receiving a more transparent channel directly to the
device.  For some people this is very important.

I think it won't really be a problem.  A user-space driver _ought_ to be
prepared to cope with the quirks and special requirements of a particular
device.

> > (1) is obviously necessary.  In general, refusing to accept a command is
> > better than changing it, IMO.
> 
> Better it would not be issued in the first place.

True enough.  I'm not so sure that's really feasible at this point.  A 
large part of the debate that started this thread had to do with finding 
an appropriate way to represent the necessary information, and no 
satisfactory resolution was reached.

> [..]
> > This puts the burden of dealing with partially-compliant devices on the
> > SCSI midlayer.  The routines there should be prepared to issue multiple
> > forms of a some commands, so that if one form doesn't work another form
> > can be tried.  Of course, this is already being done for READ and WRITE.
> 
> Wouldn't it be better if drivers had attributes which tell the midlevel
> which forms of the several commands are acceptable?

Yes it would.  I'm not sure that everybody can agree on a good way to do 
this beyond the most rudimentary aspects.

Alan Stern


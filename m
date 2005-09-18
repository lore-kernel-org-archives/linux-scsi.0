From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] oops on usb storage device disconnect with
 2.6.14-rc1
Date: Sat, 17 Sep 2005 22:33:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509172225040.6834-100000@netrider.rowland.org>
References: <1127003801.4794.13.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.rowland.org ([192.131.102.7]:44048 "HELO mx1.rowland.org")
	by vger.kernel.org with SMTP id S1751272AbVIRCdZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Sep 2005 22:33:25 -0400
In-Reply-To: <1127003801.4794.13.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net

On Sat, 17 Sep 2005, James Bottomley wrote:

> On Thu, 2005-09-15 at 21:52 -0400, Alan Stern wrote:
> > In short, those iterations must be carried out as in my patch.
> 
> OK, I looked at making this work while reaping the target correctly, but
> I couldn't (basic problem is that the target list keeps the target until
> it has no more devices, a condition that could be made untrue by
> something as simple as an open of the sysfs file).

Sorry, I'm a bit slow tonight.  I thought you _wanted_ the target to hang
around until it had no more devices.  (Wasn't that the whole point of
scsi_target_reap?)  What's wrong with keeping the target until the sysfs
file is closed?

> So, rather than try that, I thought a better approach might be to make
> the host state model work for us.  i.e. if we know the host is being
> removed, there's no point allowing target or device removal because at
> some point the host removal will do it for us.  This enforcement would
> ensure we're the only legitimate removers of the target and device.

How does this make things any better?  You still face the problem that an 
open sysfs file will delay device removal and target reaping, if all the 
devices on that target are hot-unplugged and the host remains alive and 
active.

> The alternative is to migrate to klists, I think ...

Think very carefully before taking such a step...  :-)

Alan Stern


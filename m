From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-usb-devel] oops on usb storage device disconnect with
	2.6.14-rc1
Date: Sun, 18 Sep 2005 15:00:23 -0500
Message-ID: <1127073623.4847.31.camel@mulgrave>
References: <Pine.LNX.4.44L0.0509172225040.6834-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:28833 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750730AbVIRUAe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 16:00:34 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509172225040.6834-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net

On Sat, 2005-09-17 at 22:33 -0400, Alan Stern wrote:
> > OK, I looked at making this work while reaping the target correctly, but
> > I couldn't (basic problem is that the target list keeps the target until
> > it has no more devices, a condition that could be made untrue by
> > something as simple as an open of the sysfs file).
> 
> Sorry, I'm a bit slow tonight.  I thought you _wanted_ the target to hang
> around until it had no more devices.  (Wasn't that the whole point of
> scsi_target_reap?)  What's wrong with keeping the target until the sysfs
> file is closed?

nothing ... that happens regardless (with either patch).

> > So, rather than try that, I thought a better approach might be to make
> > the host state model work for us.  i.e. if we know the host is being
> > removed, there's no point allowing target or device removal because at
> > some point the host removal will do it for us.  This enforcement would
> > ensure we're the only legitimate removers of the target and device.
> 
> How does this make things any better?  You still face the problem that an 
> open sysfs file will delay device removal and target reaping, if all the 
> devices on that target are hot-unplugged and the host remains alive and 
> active.

Actually, since we don't need the target reaping in the host removal (it
would be reaped when the device is removed), I agree ... I'll put your
original patch in.

Thanks,

James


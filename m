From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open
	file references
Date: Wed, 05 Mar 2008 14:55:14 -0600
Message-ID: <1204750514.3047.63.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0803041237440.4039-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45708 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbYCEUzS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 15:55:18 -0500
In-Reply-To: <Pine.LNX.4.44L0.0803041237440.4039-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>


On Tue, 2008-03-04 at 12:43 -0500, Alan Stern wrote:
> On Tue, 4 Mar 2008, James Bottomley wrote:
> 
> > If you want to see for yourself, it's fs/block_dev.c:do_open().
> 
> Thanks for the pointer.  I see the subroutine is not exactly loaded 
> with comments...
> 
> > > If you can suggest an alternative approach, I'll be glad to change the
> > > patch.
> > 
> > Well, since this is the 7th patch of an eight patch series, I don't
> > really have the context for that.  However, I assume it's all on the
> > linux-usb list?  If so, I'll add it to my list of things to look at.
> 
> The patches before it probably won't give you any additional useful 
> context.  The following patch might; that's the one affecting 
> usb-storage.

OK, I looked through the patch series.  It really looks like the
in-kernel thing is the wrong approach.

Why not export this want_persist flag via sysfs and then have hal and
udev update it when they see a filesystem on an underlying usb device
mounted (and zero it out on unmount)?  That way you always have the
exactly correct state and there's no need to go fishing for information
in layers that are difficult to get to.

James



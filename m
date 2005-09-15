From: Greg KH <greg@kroah.com>
Subject: Re: [linux-usb-devel] oops on usb storage device disconnect with 2.6.14-rc1
Date: Thu, 15 Sep 2005 16:46:12 -0700
Message-ID: <20050915234612.GA10974@kroah.com>
References: <20050915190338.GA6807@kroah.com> <Pine.LNX.4.44L0.0509151514460.4493-100000@iolanthe.rowland.org> <20050915192912.GA7077@kroah.com> <1126814226.4821.48.camel@mulgrave> <1126818483.4821.60.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([69.55.234.183]:29571 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S932595AbVIOXqi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 19:46:38 -0400
Content-Disposition: inline
In-Reply-To: <1126818483.4821.60.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net

On Thu, Sep 15, 2005 at 05:08:03PM -0400, James Bottomley wrote:
> On Thu, 2005-09-15 at 15:57 -0400, James Bottomley wrote:
> > I haven't had time to review the eh changes, but I was going to reply to
> > the other one (basically there's a better way to try to close the device
> > add/host remove race using the host state model).
> > 
> > Let me complete the SCSI process and I'll take them through the scsi-rc-
> > fixes tree.
> 
> Well, I think the symptoms are racing scsi_remove_host() calls and the
> solution is to enforce the state model on removal (as in if the host is
> already in the remove state, don't try to remove it again).
> 
> Could you try the patch here:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112613077011571
> 
> And see if it will fix the problem?

That helped in that there is no more kernel oops.  But the
/sys/block/sdb device (and partitions) do not get removed from the
kernel.  So the next time I plug the device in, it gets bumped to "sdc".
I can provide kernel logs of the unplug event if you wish.

thanks,

greg k-h

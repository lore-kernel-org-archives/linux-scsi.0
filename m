From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] oops on usb storage device disconnect with
 2.6.14-rc1
Date: Thu, 15 Sep 2005 21:57:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509152155160.9589-100000@netrider.rowland.org>
References: <20050915234612.GA10974@kroah.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.rowland.org ([192.131.102.7]:48652 "HELO mx1.rowland.org")
	by vger.kernel.org with SMTP id S1161043AbVIPB5i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 21:57:38 -0400
In-Reply-To: <20050915234612.GA10974@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net

On Thu, 15 Sep 2005, Greg KH wrote:

> On Thu, Sep 15, 2005 at 05:08:03PM -0400, James Bottomley wrote:
> > On Thu, 2005-09-15 at 15:57 -0400, James Bottomley wrote:
> > > I haven't had time to review the eh changes, but I was going to reply to
> > > the other one (basically there's a better way to try to close the device
> > > add/host remove race using the host state model).
> > > 
> > > Let me complete the SCSI process and I'll take them through the scsi-rc-
> > > fixes tree.
> > 
> > Well, I think the symptoms are racing scsi_remove_host() calls and the
> > solution is to enforce the state model on removal (as in if the host is
> > already in the remove state, don't try to remove it again).
> > 
> > Could you try the patch here:
> > 
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=112613077011571
> > 
> > And see if it will fix the problem?
> 
> That helped in that there is no more kernel oops.  But the
> /sys/block/sdb device (and partitions) do not get removed from the
> kernel.  So the next time I plug the device in, it gets bumped to "sdc".
> I can provide kernel logs of the unplug event if you wish.

You still need to use the second patch in the Bugzilla entry, the one
that James hasn't had time to check over yet.  Without it, the SCSI error
handler thread never exits and the device removal sequence hangs.

Alan Stern


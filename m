From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG: CD driver sends command during host removal
Date: Mon, 11 Oct 2004 15:20:37 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0410111513400.21084-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:4371 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S269184AbUJKTUh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 15:20:37 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@SteelEye.com] wrote:

> On Wed, 2004-09-29 at 16:31, Mike Anderson wrote:
> > James Bottomley [James.Bottomley@SteelEye.com] wrote:
> > > Once you've called scsi_remove_host() the mid-layer will take control of
> > > your in-flight commands (if there are any) and error them back to the
> > > user.  You need to take any actions to clean up internal structures
> > > belonging to the commands *before* you do a scsi_remove_host.
> > > 
> > 
> > How do we address the problem we get into with the reordering in
> > scsi_remove_host (i.e. the call to scsi_forget_host prior to
> > scsi_host_cancel) if we possibly generate new io from sd_sync_cache
> > that will cause the error handler to fire up if the LLDD just lets the
> > command fall on the floor with no response.
> 
> That's why LLD's are responsible for erroring all commands issued at
> this time if the removal is a surprise ejection.  The commands have to
> be errored in a way (like DID_NO_CONNECT) that won't excite the error
> handler.

This raises a question for the case where the host removal is not a
surprise ejection.  The LLD knows to clean up commands from _before_ doing
scsi_remove_host, and it knows that it should handle commands from _after_
calling scsi_remove_host.

But scsi_remove_host isn't synchronized at all with queuecommand, so what
about commands that arrive at just about _the same time_ as when
scsi_remove_host is called?  The LLD has no way to tell which class such a
command belongs to.  What then?

Alan Stern


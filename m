From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG: CD driver sends command during host removal
Date: Wed, 29 Sep 2004 12:55:22 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0409291239250.1167-100000@ida.rowland.org>
References: <415ADD7D.6060105@adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:10244 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S268717AbUI2QzX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 12:55:23 -0400
In-Reply-To: <415ADD7D.6060105@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Mohammed Sameer <uniball@gmx.net>, USB users list <linux-usb-users@lists.sourceforge.net>

On Wed, 29 Sep 2004, Luben Tuikov wrote:

> > Next usb-storage called scsi_remove_host().  Apparently this caused some
> > component of the CD driver to queue a command:

This sounds like a bug, by the way.  Commands shouldn't be queued because 
of a call to scsi_remove_host!

> >  > Sep 26 11:20:54 localhost kernel: usb-storage: queuecommand called
> >  > Sep 26 11:20:54 localhost kernel: usb-storage: *** thread awakened.
> >  > Sep 26 11:20:54 localhost kernel: usb-storage: No command during 
> > disconnect
> >  > Sep 26 11:20:54 localhost kernel: usb-storage: *** thread sleeping.
> > 
> > usb-storage accepted the command but then ignored it because the host was
> > in process of removal.  Should the queuecommand routine have rejected the
> > command?
> 
> Yes, if the service delivery subsystem (SDS) knows that the device is gone
> and the command wouldn't be delivered, it should *not* "ignore" the
> command, but return it with error.
> 
> I.e. if the LLDD has active/most recent knowledge about the device
> whereto the command is destined, it should act on that and return
> an appropriate error.  After all, this is what a properly implemented
> SDS would do.

According to Documentation/scsi/scsi_mid_low_api.txt, the only possible 
error returns are SCSI_MLQUEUE_DEVICE_BUSY and SCSI_MLQUEUE_HOST_BUSY.  
Neither is appropriate; should the second one be returned?

> >  This would involve a race, because it's possible for
> > queuecommand to accept a command and then scsi_remove_host() to be called
> > before the command is carried out.
> 
> If the command hasn't been carried out, then delivery would fail and SDS
> would return the appropriate error back to SCSI Core.

How?  The SCSI core deallocates the scsi_cmnd before the SDS has a chance 
to return anything.

> Where *was* the command?  From the point of time when queuecommand() is
> called until scsi_done() is called, the command belongs to the LLDD.
> It should honor any TMF, regardless of the _state_ of the task.

If the command belongs to the LLDD, why does scsi_remove_host do the
following:

	calls scsi_host_cancel,
	which calls scsi_device_cancel_cb for each device,
	which calls scsi_device_cancel,
	which calls scsi_finish_command for each active command,
	which passes the command back to the upper layer

Either there's a bug in the host removal sequence, or else the LLDD 
doesn't own any requests once scsi_remove_host has been called.

Alan Stern


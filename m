From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: make use of the residue value
Date: Sat, 8 Mar 2008 11:22:52 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0803081110480.17487-100000@netrider.rowland.org>
References: <1204935475.2889.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:1532 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751982AbYCHQWw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Mar 2008 11:22:52 -0500
In-Reply-To: <1204935475.2889.28.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 7 Mar 2008, James Bottomley wrote:

> On Wed, 2008-02-27 at 15:25 -0500, Alan Stern wrote:
> > On 20 Feb 2008, Alan Stern wrote:
> > 
> > > This patch (as1036) causes the SCSI midlayer to take into account the
> > > residue value provided by some low-level drivers.  There's at least
> > > one situation (USB mass storage with the Bulk-only transport) where
> > > the specification states that it is permissible for a device to
> > > indicate some of the data was not transferred correctly merely by
> > > setting the residue value, without issuing a Check Condition.
> > 
> > After a week, there hasn't been any feedback on this patch.  Has it
> > been accepted?  Is there anything wrong with it?  Is it still on a
> > "to-look-at" queue?
> 
> OK, I ran it through its paces, but it fails in testing.  A very fun
> failure, actually, some disks fail to appear with udev.
> 
> The reason is they return a residue from the VPD inquiry.  What your
> patch actually causes is the block layer to resubmit the command with
> the residue and triggers an overrun error (because the length in the
> command is now much longer than the data buffer).

Can you give any more details?

	What was the transfer length of the original command?

	What were the actual data length and the residue value?

	What were the length and data-buffer size of the
	resubmitted command?

> The bottom line is that this patch won't work with variable length
> commands like inquiry that always return a residue.

You're saying that the amount of data returned is smaller that the 
amount requested because the data is variable length, right?

Under these circumstances the block layer should not resubmit anything.
That is, it should be smart enough to know that the "missing" data does
not in fact exist, as opposed to not being returned because of a
retryable device error.

Aren't requests for things like VPD distinguished from regular 
data-block accesses by a flag in the request structure already?  The 
block layer should take this flag into account when deciding whether to 
continue trying to transfer the "missing" data.  Maybe that needs to be 
fixed first.

Alan Stern


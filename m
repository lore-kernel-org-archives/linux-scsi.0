From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: make use of the residue value
Date: Sat, 08 Mar 2008 11:20:42 -0600
Message-ID: <1204996842.2893.14.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0803081110480.17487-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34642 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900AbYCHRUq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Mar 2008 12:20:46 -0500
In-Reply-To: <Pine.LNX.4.44L0.0803081110480.17487-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 2008-03-08 at 11:22 -0500, Alan Stern wrote:
> On Fri, 7 Mar 2008, James Bottomley wrote:
> 
> > On Wed, 2008-02-27 at 15:25 -0500, Alan Stern wrote:
> > > On 20 Feb 2008, Alan Stern wrote:
> > > 
> > > > This patch (as1036) causes the SCSI midlayer to take into account the
> > > > residue value provided by some low-level drivers.  There's at least
> > > > one situation (USB mass storage with the Bulk-only transport) where
> > > > the specification states that it is permissible for a device to
> > > > indicate some of the data was not transferred correctly merely by
> > > > setting the residue value, without issuing a Check Condition.
> > > 
> > > After a week, there hasn't been any feedback on this patch.  Has it
> > > been accepted?  Is there anything wrong with it?  Is it still on a
> > > "to-look-at" queue?
> > 
> > OK, I ran it through its paces, but it fails in testing.  A very fun
> > failure, actually, some disks fail to appear with udev.
> > 
> > The reason is they return a residue from the VPD inquiry.  What your
> > patch actually causes is the block layer to resubmit the command with
> > the residue and triggers an overrun error (because the length in the
> > command is now much longer than the data buffer).
> 
> Can you give any more details?
> 
> 	What was the transfer length of the original command?

Depends on how you instigate it.  If you use sg_inq it will be 252.

> 	What were the actual data length and the residue value?

Depends on the page and the drive.  Best way is 0x80 it also depends on
the driver (since a lot don't report a residue).  Mostly they seem to be
24 bytes.

> 	What were the length and data-buffer size of the
> 	resubmitted command?

The length remains the same, it's embedded in the command.  The failing
length reported at 2.

> > The bottom line is that this patch won't work with variable length
> > commands like inquiry that always return a residue.
> 
> You're saying that the amount of data returned is smaller that the 
> amount requested because the data is variable length, right?

Yes.

> Under these circumstances the block layer should not resubmit anything.
> That is, it should be smart enough to know that the "missing" data does
> not in fact exist, as opposed to not being returned because of a
> retryable device error.
> 
> Aren't requests for things like VPD distinguished from regular 
> data-block accesses by a flag in the request structure already?  The 
> block layer should take this flag into account when deciding whether to 
> continue trying to transfer the "missing" data.  Maybe that needs to be 
> fixed first.

I'm sure Jens will look at patches.

James



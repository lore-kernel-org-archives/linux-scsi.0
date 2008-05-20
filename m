From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Tue, 20 May 2008 10:23:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0805201005120.2494-100000@iolanthe.rowland.org>
References: <48328E81.2080504@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:45715 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1765519AbYETOX0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 May 2008 10:23:26 -0400
In-Reply-To: <48328E81.2080504@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 20 May 2008, Boaz Harrosh wrote:

> Alan Stern wrote:
> > On Mon, 19 May 2008, Boaz Harrosh wrote:
> > 
> >> Sure, inspecting other places that emulate MODE_SENSE, (And inspecting the scsi
> >> spec) all zeros is a very good scsi response. Alan do you want to send a fix for all
> >> places that initiate a MODE_SENSE command, specifically at
> >> scsi_scan.c::scsi_unlock_floptical() ? (Some other places do)
> > 
> > I can't send such a fix because at these places the residue information 
> > has already been lost.  The fix needs to be made lower down.
> > 
> 
> I was talking about zero-set the data buffer before issue of the 
> MODE_SENSE command. (As it accidentally happen to be before)

The data buffer _is_ set to zero bufore the MODE SENSE command is
issued.  It doesn't help, because the device sends garbage data along
with a Residue value saying that none of the data it sent was valid.

> > Besides, everybody seems to be missing an important point.
> > 
> 
> No, you are missing the point.
> 
> > MODE SENSE is just one example of a command for which a device might
> > return less data than the host expected.  In principle the same thing
> > could happen with _any_ command.  The host should be prepared for this
> > and should be able to handle it correctly.  And the host shouldn't
> > blindly assume that devices will slavishly follow the letter of the
> > SCSI spec.
> > 
> 
> LLD's do a good job upto now. If *NO* data was written to a target they
> return some error status.

We are talking about data being _read_ from a device, not _written_ to 
a device.  MODE SENSE does a read, not a write.

> You keep returning to, "what if we wrote less and the target
> did not signal an error status". Well, up to now we did not see such 
> thing, let's cross that when we see it with black lists or something.

Why use a blacklist?  This sort of thing is allowed by the USB mass 
storage spec, and probably also by the SCSI spec.  The core should be 
able to handle it.

> > We need something much more thorough than just fiddling with
> > scsi_mode_sense().  One possibility would be to pass a
> > minimum-response-length argument to scsi_execute_req().  But even that
> > wouldn't catch all the code paths where this sort of thing could  
> > happen (although it probably would catch most of them).
> > 
> It never happens! LLD's set proper status when something gone wrong.

What do you mean by "gone wrong"?  The device didn't send an error 
status, so in that sense nothing is wrong.

It also didn't send the data we want.  But how is the LLD supposed to 
know how much data is truly needed?  The only mechanism for that is 
scmd->underflow.  usb-storage does indeed test that, as it should.

Apparently the SCSI core should start setting scmd->underflow in cases
where it currently doesn't.

> > This needs someone who is more familiar than I am with the operation of
> > the SCSI core.
> >
> 
> The SCSI core assumes the LLD will return some status condition. 
> If an LLD trusts it's device it will blindly return what the device returned,
> if not it will do some checks of it's own. You can see examples of both in 
> the source tree.

Your description bears no relation to what usb-storage does.  It does 
_not_ blindly trust the device; it _does_ check status conditions, and 
it _does_ do checks of its own.

It's not usb-storage's fault that the SCSI core failed to tell it how
much data was required to be transferred.

Alan Stern


From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: make use of the residue value
Date: Sun, 9 Mar 2008 17:50:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0803091617480.16105-100000@netrider.rowland.org>
References: <1205091283.3792.68.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:3385 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751885AbYCIVua (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Mar 2008 17:50:30 -0400
In-Reply-To: <1205091283.3792.68.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 9 Mar 2008, James Bottomley wrote:

> > But the comment talks about identifying a bad sector.  That makes no 
> > sense if the command isn't sector-oriented to begin with.
> 
> At the moment we have two (well, a lot more if you include the token
> based PM commands, but SCSI doesn't really do those) command types:
> BLOCK_PC and FS.  The latter go through this clause and *are* sector
> based.

And we really don't have to worry about the other types?  Okay...

> > Yes.  And if residue > good_bytes then you end up taking the larger
> > instead of the smaller: Since good_bytes is unsigned, subtracting a
> > larger quantity from it yields a very large positive result.
> 
> For that to happen the driver would have to have returned a larger
> residue than it was given bytes to write or read, which should be an
> impossible condition given that they count down from the bytes to write.
> If any driver is doing this, it needs catching and shooting.

In short, you're trusting the low-level drivers to catch this
impossible condition.  (usb-storage does check for it, incidentally.)  
That's fine with me, as long as it's explicit.

> > 	It doesn't use the residue at all for BLOCK_PC requests.
> 
> The residue for these is returned in a different way.
> 
> > BTW, you never answered my question: How does the SCSI midlayer tell
> > callers that a command returned less data than requested because the
> > device claims the remainder doesn't exist?
> 
> For BLOCK_PC that's returned in req->data_len, which is placed in resid
> (sgv3) or din/dout_resid (sgv4) for the user.

I see.  Although oddly enough, the scsi_execute() routine throws this 
information away.  Don't its callers need to know?

All right, your version of the patch seems okay.  But there still is an
unanswered question:

What's the reason for this baroque arrangement?  Why tell the block 
layer that the data was transferred successfully and then use a 
back-door arrangement like req->data_len to let the caller know that 
no, the data wan't really all transferred?

Alan Stern

P.S.: In case you're interested...

It's not common, even among USB devices, to return a residue without
identifying the bad sector.  The one example where I saw it happen was
explained by the fact that max_sectors was too high.  The device
returned as much data as it could, with the residue set to indicate
that some was missing.  But since it never actually encountered a
sector-read error, it didn't return any sense information.

Yes, the device _should_ have returned Illegal Request, Invalid 
Field in CDB, or something of the sort.  That would have alerted us to 
the problem.  But it didn't.  And as a result, the midlayer thought the 
missing data was present and correct.  The user reported it as data 
corruption: Files written to the device and then read back did not 
compare equal to the original files.


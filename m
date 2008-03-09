From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: make use of the residue value
Date: Sun, 9 Mar 2008 15:13:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0803091444220.13999-100000@netrider.rowland.org>
References: <1205073884.3792.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:3149 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750987AbYCITNn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Mar 2008 15:13:43 -0400
In-Reply-To: <1205073884.3792.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 9 Mar 2008, James Bottomley wrote:

> > > --- a/drivers/scsi/scsi.c
> > > +++ b/drivers/scsi/scsi.c
> > > @@ -759,9 +759,16 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
> > >  
> > >  	good_bytes = scsi_bufflen(cmd) + cmd->request->extra_len;
> > >          if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
> > > +		int old_good_bytes = good_bytes;
> > >  		drv = scsi_cmd_to_driver(cmd);
> > >  		if (drv->done)
> > >  			good_bytes = drv->done(cmd);
> > > +		/*
> > > +		 * USB may not give sense identifying bad sector and
> > > +		 * simply return a residue instead.
> > > +		 */
> > 
> > This comment is inaccurate.  It would be better to say "USB may provide
> > a residue to indicate the data isn't entirely valid, even if there is
> > no sense".  That is, a residue may be provided even when:
> > 
> > 	the requested amount of data has been transferred; or
> > 
> > 	the data is variable length, not a group of sectors.
> 
> That's true, but irrelevant.  Placing the condition inside the check for
> BLOCK_PC eliminates the possibility of variable length commands, which
> is why I did it this way.

But the comment talks about identifying a bad sector.  That makes no 
sense if the command isn't sector-oriented to begin with.

Why do you think that only BLOCK_PC commands can have variable length?

And why do you want to ignore the residue for variable-length commands?

> > > +		if (good_bytes == old_good_bytes)
> > > +			good_bytes -= scsi_get_resid(cmd);
> > 
> > I don't like this calculation.  The residue should be checked, not
> > blindly accepted.  It is reasonable only it doesn't cause good_bytes to
> > wrap below 0.  Maybe the lower-level driver can be relied on for this 
> > checking, maybe not.
> 
> Um, it's actually a narrowing of what you did in your original patch.

Not so.

> There you looked at good bytes and the original minus the residue and
> took the smaller.

Yes.

> Here, I'm only subtracting the residue if good_bytes wasn't altered.

Yes.  And if residue > good_bytes then you end up taking the larger
instead of the smaller: Since good_bytes is unsigned, subtracting a
larger quantity from it yields a very large positive result.

> (If we get any error identification at all, we believe it over the
> residue).

I don't mind ignoring the residue when good_bytes was changed; 
believing the error identification makes sense.  What I do mind about 
your patch is:

	It doesn't check for underflow when subtracting the residue;

	It doesn't use the residue at all for BLOCK_PC requests.

BTW, you never answered my question: How does the SCSI midlayer tell
callers that a command returned less data than requested because the
device claims the remainder doesn't exist?

Alan Stern


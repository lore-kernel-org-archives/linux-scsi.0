From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: make use of the residue value
Date: Sun, 09 Mar 2008 09:44:44 -0500
Message-ID: <1205073884.3792.10.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0803082144050.10362-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43609 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713AbYCIOos (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Mar 2008 10:44:48 -0400
In-Reply-To: <Pine.LNX.4.44L0.0803082144050.10362-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 2008-03-08 at 22:05 -0500, Alan Stern wrote:
> On Sat, 8 Mar 2008, James Bottomley wrote:
> 
> > This is really pretty complex, and it's adjusting an already complex
> > path we've had quite a bit of difficulty with previously.
> 
> The new part of the patch isn't complex.  Apart from modifying a bunch
> of comments, all it does is add one more clause to an "if" test.  But I
> have to agree that the test is in a rather complex path.  And it looks
> as though that path, complex as it is, isn't set up to handle
> situations where variable-length data ends up being shorter than
> requested.  Am I missing something pretty basic?
> 
> (I still think that modifying the comments is a good idea.  When
> dealing with complex code, misleading comments are the last thing you
> need.)
> 
> > What I was actually looking for was something simpler.  How about this?
> > I'll still have to run it through the test wringer since it might still
> > end up causing problems if drivers are careless about their residue
> > calculations.
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > index e5c6f6a..96dbc63 100644
> > --- a/drivers/scsi/scsi.c
> > +++ b/drivers/scsi/scsi.c
> > @@ -759,9 +759,16 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
> >  
> >  	good_bytes = scsi_bufflen(cmd) + cmd->request->extra_len;
> >          if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
> > +		int old_good_bytes = good_bytes;
> >  		drv = scsi_cmd_to_driver(cmd);
> >  		if (drv->done)
> >  			good_bytes = drv->done(cmd);
> > +		/*
> > +		 * USB may not give sense identifying bad sector and
> > +		 * simply return a residue instead.
> > +		 */
> 
> This comment is inaccurate.  It would be better to say "USB may provide
> a residue to indicate the data isn't entirely valid, even if there is
> no sense".  That is, a residue may be provided even when:
> 
> 	the requested amount of data has been transferred; or
> 
> 	the data is variable length, not a group of sectors.

That's true, but irrelevant.  Placing the condition inside the check for
BLOCK_PC eliminates the possibility of variable length commands, which
is why I did it this way.

> Furthermore this is true for any type of request, including BLOCK_PC.  
> In fact, I would expect this to be true for any transport, not just
> USB.  How else would you know that the amount of VPD data returned is
> less than the amount asked for?
> 
> > +		if (good_bytes == old_good_bytes)
> > +			good_bytes -= scsi_get_resid(cmd);
> 
> I don't like this calculation.  The residue should be checked, not
> blindly accepted.  It is reasonable only it doesn't cause good_bytes to
> wrap below 0.  Maybe the lower-level driver can be relied on for this 
> checking, maybe not.

Um, it's actually a narrowing of what you did in your original patch.
There you looked at good bytes and the original minus the residue and
took the smaller.

Here, I'm only subtracting the residue if good_bytes wasn't altered.
(If we get any error identification at all, we believe it over the
residue).

James


From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: How many retries to allow?
Date: Sun, 28 Sep 2008 11:44:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809281134550.12081-100000@netrider.rowland.org>
References: <48DF4D6E.5060509@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:2378 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750855AbYI1PoI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Sep 2008 11:44:08 -0400
In-Reply-To: <48DF4D6E.5060509@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 28 Sep 2008, Boaz Harrosh wrote:

> Alan Stern wrote:
> > James and Boaz:
> > 
> > Here's a question.  Suppose a device returns NOT READY sense key 
> > repeatedly.  How long should the request be retried before we give up?  
> > If we never give up then the request will never finish, so the caller 
> > will hang.
> > 
> > Alan Stern
> > 
> I always thought  request->retries was for that. Perhaps I misunderstood.

Maybe it is intended for that purpose, but it isn't being used as far 
as I can tell.  req->retries is never decremented; instead 
scmd->allowed is initialized to req->retries when the request is 
prepped.  But when a command fails and scsi_requeue_command() is 
called, the request is un-prepped and put back on the queue.  Then it 
is prepped again and a new scmd is created -- with the same number of 
retries as before.  Thus we will never run out of retries.

> I think there should be one user settable global counter that will limit
> all retries of any kind.

You're missing a major point.  Suppose for example that the device
returns NOT READY because a new medium is being loaded, a procedure
that takes a couple of seconds.  But the SCSI core doesn't wait between
retries; a new command is sent as soon as the old one fails.  A retry
limit of 10 could easily be used up in a fraction of a second, and then
the request would fail.

Is this how it's supposed to work?  Would it be better to invoke the 
error handler for this sort of thing?

Alan Stern


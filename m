From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Fix handling of failed requests in scsi_io_completion
Date: Sat, 20 Sep 2008 16:49:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809201640160.16873-100000@netrider.rowland.org>
References: <1221933306.3152.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:2422 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751289AbYITUtx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Sep 2008 16:49:53 -0400
In-Reply-To: <1221933306.3152.18.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>, USB list <linux-usb@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Hans de Goede <j.w.r.degoede@hhs.nl>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 20 Sep 2008, James Bottomley wrote:

> What I mean is that I can't find an error case that's currently shown
> scsi_end_request(cmd, -EIO, this_count, 1) where requeuing after
> completing only the currently attempted transfer is valid.  If this had
> all been done as a single transaction, we'd have killed everything at
> this point.  Just because we split the request into multiple
> transactions doesn't mean we should go back around and try a new
> transaction after we hit an error.

Yes, that makes sense.

> > They end up doing this:
> > 
> > 		scsi_end_request(cmd, -EIO, this_count, 1);
> > 
> > when in fact they should do this:
> > 
> > 		scsi_end_request(cmd, -EIO, 0, 1);
> > 
> > (where the -EIO value is ignored).
> 
> Actually, no ... that's just equivalent to scsi_requeue_command(q, cmd)
> which is done at several places in the code (correctly) for sense errors
> that imply the whole lot should be retried (actually, it's assuming
> good_bytes is zero).

Except that those places don't do the blk_noretry_request test.  Should 
they?  And even if they do, what's to prevent an infinite retry loop?

> OK, so look at the current code in scsi_io_completion where we call
> scsi_end_request(cmd, -EIO, this_count, 1):
> 
> UNIT ATTENTION for removable medium (means medium changed)
> ILLEGAL REQUEST where there's no command resize fallback
> NOT READY for unknown (non retryable) reasons
> VOLUME OVERFLOW
> 
> In none of these cases do we want any form of requeuing, we want to kill
> the entire request.

I take your point.  Which leads to the question: Why was the code ever 
calling scsi_end_request(cmd, -EIO, this_count, 1) in the first place?  
Apparently all of these paths should be setting the last argument to 0, 
always.

Alan Stern


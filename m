From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] SCSI: simplify scsi_io_completion()
Date: Wed, 26 Nov 2008 15:03:41 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0811261447100.29893-100000@netrider.rowland.org>
References: <1227726163.3387.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:2347 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751585AbYKZUDn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2008 15:03:43 -0500
In-Reply-To: <1227726163.3387.27.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 26 Nov 2008, James Bottomley wrote:

> On Mon, 2008-11-03 at 15:56 -0500, Alan Stern wrote:
> > This patch (as1142b) consolidates a lot of repetitious code in
> > scsi_io_completion().  It also fixes a few comments.  Most
> > importantly, however, it clearly distinguishes among the three sorts
> > of retries that can be done when a command fails to complete:

> OK, how about this as an update to the patch.  It corrects several
> things:
> 
>      1. For several error conditions, we would now print the sense twice
>         in slightly different ways, so unify the location of sense
>         printing.
>      2. I added more descriptions to actual failure conditions for
>         better debugging
>      3. according to spec, ABORTED_COMMAND is supposed to be retried
>         (except on DIF failure).  Our old behaviour of erroring it looks
>         to be a bug.
>      4. I'd prefer not to default initialise the action variable because
>         that ensures that every leg of the error handler has an
>         associated action and the compiler will warn if someone later
>         accidentally misses one or removes one.

This looks very good.  I'm pleased you didn't find anything actually 
wrong with the original patch aside from the ABORTED COMMAND handling. 

I was going to suggest adding a description to the ILLEGAL REQUEST
case.  But that case arises normally under various circumstances, so
perhaps it wouldn't be appropriate.  In fact, do you really want to
print out the result and sense data every time that case occurs?

> It also looks like 

... ?

Alan Stern


From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/5] SCSI: fix bad method call in scsi_target_destroy
Date: Fri, 19 Feb 2010 14:53:48 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002191305470.1506-100000@iolanthe.rowland.org>
References: <1266596983.2822.40.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57019 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753720Ab0BSTxv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2010 14:53:51 -0500
In-Reply-To: <1266596983.2822.40.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 19 Feb 2010, James Bottomley wrote:

> On Fri, 2010-02-12 at 12:14 -0500, Alan Stern wrote:
> > This patch (as1336) fixes a bug in scsi_target_destroy().  It calls
> > the host template's target_destroy method even if the target_alloc
> > method failed.  (Also, the target_destroy method is called inside the
> > scope of the host lock, which is unnecessary and probably a mistake.)
> 
> OK, so this isn't a mistake.  The act of create/destroy on the target
> and removing it from the lists has to be atomic for devices which use
> fixed slots (most SPI cards).  If the target is still in the list after
> destroy, it could end up getting spuriously reused.  Conversely, if you
> remove it from the list and then destroy, we could end up getting target
> alloc for a new target called *before* the target_destroy of the old
> one.

If the rest of the system is designed properly, targets won't get 
spuriously reused.  Of course, that's a big "if" -- but it's more 
relevant to the patch 5/5 discussion than to this one.

If you would prefer, I can revise this patch leaving the target_destroy
method call within the spinlocked region.

> > A new flag is added to struct scsi_target to remember whether or not
> > the target_alloc has succeeded.  There also are a couple of minor
> > whitespace formatting improvements.
> 
> I don't really see the need for this.  None of the users assumes the
> target was created ... if they do allocations, they all check before
> unwinding.  If there is a case for needing this, it should be part of
> the target state flags.

Maybe none of the current users make this assumption, but future users
might.  It's only natural to assume that the core won't call
your target_destroy function if target_alloc returned an error.  And 
neither of these methods is mentioned in 
Documentation/scsi/scsi_mid_low_api.txt, so the unnatural calling 
sequence isn't documented.

Some time ago I did post a patch adding an new state (STARGET_NEW) in
order to record whether or not target_alloc had failed.  I can't find
your response in the email archives, but I vaguely recall you saying
that adding a new state to the state machine wasn't an appropriate
approach.

What do you think is the best way to handle this?

Alan Stern


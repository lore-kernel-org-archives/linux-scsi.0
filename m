From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 4/5] SCSI: fix bad method call in scsi_target_destroy
Date: Fri, 12 Mar 2010 12:00:58 -0600
Message-ID: <1268416858.2802.23.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1002191305470.1506-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933630Ab0CLSBE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 13:01:04 -0500
In-Reply-To: <Pine.LNX.4.44L0.1002191305470.1506-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2010-02-19 at 14:53 -0500, Alan Stern wrote:
> On Fri, 19 Feb 2010, James Bottomley wrote:
> 
> > On Fri, 2010-02-12 at 12:14 -0500, Alan Stern wrote:
> > > This patch (as1336) fixes a bug in scsi_target_destroy().  It calls
> > > the host template's target_destroy method even if the target_alloc
> > > method failed.  (Also, the target_destroy method is called inside the
> > > scope of the host lock, which is unnecessary and probably a mistake.)
> > 
> > OK, so this isn't a mistake.  The act of create/destroy on the target
> > and removing it from the lists has to be atomic for devices which use
> > fixed slots (most SPI cards).  If the target is still in the list after
> > destroy, it could end up getting spuriously reused.  Conversely, if you
> > remove it from the list and then destroy, we could end up getting target
> > alloc for a new target called *before* the target_destroy of the old
> > one.
> 
> If the rest of the system is designed properly, targets won't get 
> spuriously reused.  Of course, that's a big "if" -- but it's more 
> relevant to the patch 5/5 discussion than to this one.
> 
> If you would prefer, I can revise this patch leaving the target_destroy
> method call within the spinlocked region.
> 
> > > A new flag is added to struct scsi_target to remember whether or not
> > > the target_alloc has succeeded.  There also are a couple of minor
> > > whitespace formatting improvements.
> > 
> > I don't really see the need for this.  None of the users assumes the
> > target was created ... if they do allocations, they all check before
> > unwinding.  If there is a case for needing this, it should be part of
> > the target state flags.
> 
> Maybe none of the current users make this assumption, but future users
> might.  It's only natural to assume that the core won't call
> your target_destroy function if target_alloc returned an error.  And 
> neither of these methods is mentioned in 
> Documentation/scsi/scsi_mid_low_api.txt, so the unnatural calling 
> sequence isn't documented.

So documenting it would be fine ...

> Some time ago I did post a patch adding an new state (STARGET_NEW) in
> order to record whether or not target_alloc had failed.  I can't find
> your response in the email archives, but I vaguely recall you saying
> that adding a new state to the state machine wasn't an appropriate
> approach.
> 
> What do you think is the best way to handle this?

Just add documentation ... there's no real need for a new state or a
flag.

James



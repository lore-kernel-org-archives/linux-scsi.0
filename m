From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/5] SCSI: fix bad method call in scsi_target_destroy
Date: Fri, 12 Mar 2010 16:37:50 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1003121619310.1320-100000@iolanthe.rowland.org>
References: <1268416858.2802.23.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33785 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932707Ab0CLVhw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2010 16:37:52 -0500
In-Reply-To: <1268416858.2802.23.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 12 Mar 2010, James Bottomley wrote:

> > Some time ago I did post a patch adding an new state (STARGET_NEW) in
> > order to record whether or not target_alloc had failed.  I can't find
> > your response in the email archives, but I vaguely recall you saying
> > that adding a new state to the state machine wasn't an appropriate
> > approach.
> > 
> > What do you think is the best way to handle this?
> 
> Just add documentation ... there's no real need for a new state or a
> flag.

Okay.  I'll put it off for now... in fact, I had more or less reached
the conclusion that this patch wasn't worth bothering with any further.

The 5/5 patch is more important, though.  The race doesn't need to be
fixed in the way I did it; another approach would be for
scsi_alloc_target() to busy-wait if the old target it finds has not yet
gone through the transport_setup_device() and
shost->hostt->target_alloc() procedures.  Waiting on the scan_mutex
seems more straightforward, though.

And it looks like there needs to be one more patch in addition.  The
logic in scsi_alloc_target() is wrong.  When deciding whether or not
the old target it found is dying, it needs to test reap_ref rather than
found_target->state, because the state is changed outside the
spinlocked region in scsi_target_reap().  Or the state change could be 
moved inside the spinlocked region; that would work also.

Alan Stern


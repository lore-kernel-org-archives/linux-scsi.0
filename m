From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
Date: Thu, 28 May 2009 16:02:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905281545300.4059-100000@iolanthe.rowland.org>
References: <1243534904.2830.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48158 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757592AbZE1UCI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2009 16:02:08 -0400
In-Reply-To: <1243534904.2830.13.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>

On Thu, 28 May 2009, James Bottomley wrote:

> > >  However, the piece that's missing, is the fact that all of
> > > this has to be tied into the host state.  If the host is running, you
> > > can't remove the target from visibility even if all its children are
> > > invisible because it might get another visible child added.
> > 
> > Are you sure about that?  It's not obvious at all to me.
> 
> Yes ... otherwise you have to elongate the DEL interval from a few ms to
> potentially anything.  That would allow locking a target in a dying
> state and prevent any new LUNs being added.

How so?  Why not unlink the target from the host's list when the 
device_del() call returns?  A new target can be created any time after 
that, since the old one is now completely invisible.

> > For example, suppose during scanning it turns out there are no LUNs at
> > a particular target address.  Why should the empty target be retained?  
> > You'd end up with unusable targets at all possible bus addresses.
> > 
> > Besides, if a target is removed from visibility and then another child
> > is added, the answer is simply to create a new target structure.  
> > There's already code in scsi_alloc_target() to do this.
> 
> As I've said several times, this could be done, but we'd have to audit
> the code paths to make sure we allow for multiple same targets in the
> list.

No, not if the old target is removed from the host's list before the
new target is added.

Is there any reason the old target has to remain on the list?  If 
there is, we can introduce a new state: STARGET_CLEANUP.  The old 
target gets put into this state when device_del() returns.  List 
entries in that state are ignored by __scsi_find_target() or whatever 
else looks through the list.

Alan Stern

P.S.: Does scsi_target_reap() really ever get called in non-process
context?  I couldn't find any place where that might happen.


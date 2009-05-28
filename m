From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs
	directories.
Date: Thu, 28 May 2009 18:21:44 +0000
Message-ID: <1243534904.2830.13.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0905281105310.3037-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34589 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756562AbZE1SVp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 May 2009 14:21:45 -0400
In-Reply-To: <Pine.LNX.4.44L0.0905281105310.3037-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>

On Thu, 2009-05-28 at 11:24 -0400, Alan Stern wrote:
> On Wed, 27 May 2009, James Bottomley wrote:
> 
> > Right, and I think reap_ref can be seconded to count underlying device
> > visibility.
> 
> Exactly.  It should count the number of underlying devices that have 
> not yet been removed from visibility (this may include some which still 
> have to become visible), plus one if we want to keep the target hanging 
> around for a while with no visible children (while scanning it, for 
> example).
> 
> >  However, the piece that's missing, is the fact that all of
> > this has to be tied into the host state.  If the host is running, you
> > can't remove the target from visibility even if all its children are
> > invisible because it might get another visible child added.
> 
> Are you sure about that?  It's not obvious at all to me.

Yes ... otherwise you have to elongate the DEL interval from a few ms to
potentially anything.  That would allow locking a target in a dying
state and prevent any new LUNs being added.

> For example, suppose during scanning it turns out there are no LUNs at
> a particular target address.  Why should the empty target be retained?  
> You'd end up with unusable targets at all possible bus addresses.
> 
> Besides, if a target is removed from visibility and then another child
> is added, the answer is simply to create a new target structure.  
> There's already code in scsi_alloc_target() to do this.

As I've said several times, this could be done, but we'd have to audit
the code paths to make sure we allow for multiple same targets in the
list.

> >  once it goes
> > into the cancel or del states, it can't acquire new children, so then
> > it's safe to make a target with no visible children invisible.
> 
> If you grant my point above, targets don't need to be tied into the
> host state.  They can be removed from visibility whenever the reap_ref
> counter goes to 0.  This will happen naturally while the host is in 
> the CANCEL state, thanks to scsi_forget_host().
> 
> There's another point to consider.  If you do accept my argument that 
> empty targets can be removed from visibility regardless of the host's 
> state, then this removal races with addition of a new child.  Since 
> removal involves calling device_del(), it can't be protected by the 
> host lock.  Instead we'd have to use a mutex to protect both target 
> addition and target removal.

No, this is state model 101 ... you alter the state inside the lock and
call del outside of it.  Technically you're lying about the state for
the few us it takes to run out of the lock and del the target, but
there's a papal indulgence for that.

> Since the host's scan_mutex already protects target addition, extending 
> its scope to encompass target removal (and perhaps sdev removal too) 
> seems natural.  Do you agree?

James



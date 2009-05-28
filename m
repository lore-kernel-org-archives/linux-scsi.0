From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
Date: Thu, 28 May 2009 11:24:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905281105310.3037-100000@iolanthe.rowland.org>
References: <1243462960.6067.87.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:39182 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755428AbZE1PYF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2009 11:24:05 -0400
In-Reply-To: <1243462960.6067.87.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>

On Wed, 27 May 2009, James Bottomley wrote:

> Right, and I think reap_ref can be seconded to count underlying device
> visibility.

Exactly.  It should count the number of underlying devices that have 
not yet been removed from visibility (this may include some which still 
have to become visible), plus one if we want to keep the target hanging 
around for a while with no visible children (while scanning it, for 
example).

>  However, the piece that's missing, is the fact that all of
> this has to be tied into the host state.  If the host is running, you
> can't remove the target from visibility even if all its children are
> invisible because it might get another visible child added.

Are you sure about that?  It's not obvious at all to me.

For example, suppose during scanning it turns out there are no LUNs at
a particular target address.  Why should the empty target be retained?  
You'd end up with unusable targets at all possible bus addresses.

Besides, if a target is removed from visibility and then another child
is added, the answer is simply to create a new target structure.  
There's already code in scsi_alloc_target() to do this.

>  once it goes
> into the cancel or del states, it can't acquire new children, so then
> it's safe to make a target with no visible children invisible.

If you grant my point above, targets don't need to be tied into the
host state.  They can be removed from visibility whenever the reap_ref
counter goes to 0.  This will happen naturally while the host is in 
the CANCEL state, thanks to scsi_forget_host().

There's another point to consider.  If you do accept my argument that 
empty targets can be removed from visibility regardless of the host's 
state, then this removal races with addition of a new child.  Since 
removal involves calling device_del(), it can't be protected by the 
host lock.  Instead we'd have to use a mutex to protect both target 
addition and target removal.

Since the host's scan_mutex already protects target addition, extending 
its scope to encompass target removal (and perhaps sdev removal too) 
seems natural.  Do you agree?

Alan Stern


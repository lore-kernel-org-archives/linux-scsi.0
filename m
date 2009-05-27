From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs
	directories.
Date: Wed, 27 May 2009 22:22:40 +0000
Message-ID: <1243462960.6067.87.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0905271810320.2669-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0905271810320.2669-100000@iolanthe.rowland.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-05-27 at 18:15 -0400, Alan Stern wrote:
> On Wed, 27 May 2009, James Bottomley wrote:
> 
> > I find the terms delete and release too close for comfort, which is why
> > I've always been careful to say remove from visibility.
> 
> Okay; I'll use your terms when conversing with you.  :-)
> 
> > > That's fine.  You remove a target from visibility when target->reap_ref
> > > becomes 0.  The target isn't released until the target's embedded
> > > struct device's refcount becomes 0.  To make this work, simply have
> > > scsi_alloc_sdev() call
> > > 
> > > 	get_device(&starget->dev);
> > > 
> > > and have scsi_device_dev_release_usercontext() call
> > > 
> > > 	put_device(&starget->dev);
> > > 
> > > Doesn't that do exactly what you're asking for?
> > 
> > That's um what we do to day ... the addition has to be to the visibility
> > management.
> 
> That's what I was trying to accomplish in the patch you said was wrong.  
> It moved the call to scsi_target_reap() from
> scsi_device_dev_release_usercontext() into __scsi_remove_device().  
> That is, the target's count of underlying sdevs was to be decremented
> whenever an sdev was removed from visibility, not when the sdev was
> released.
> 
> That's how the problem should be solved.  But the details need to be 
> correct, and I don't understand how they all work (as you noticed when 
> reading the patch).

Right, and I think reap_ref can be seconded to count underlying device
visibility.  However, the piece that's missing, is the fact that all of
this has to be tied into the host state.  If the host is running, you
can't remove the target from visibility even if all its children are
invisible because it might get another visible child added. once it goes
into the cancel or del states, it can't acquire new children, so then
it's safe to make a target with no visible children invisible.

James



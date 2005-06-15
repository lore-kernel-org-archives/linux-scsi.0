From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Wed, 15 Jun 2005 17:11:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506151706030.6561-100000@iolanthe.rowland.org>
References: <1118806139.5027.37.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:61674 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261576AbVFOVMB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 17:12:01 -0400
In-Reply-To: <1118806139.5027.37.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 14 Jun 2005, James Bottomley wrote:

> On Tue, 2005-06-14 at 17:27 -0400, Alan Stern wrote:
> > Can you or anyone else please explain what scsi_target_reap() and
> > especially what scsi_target.reap_ref are for?  What's the point of this
> > home-brewed reference counting scheme when there's already a perfectly
> > useful embedded struct device inside scsi_target?  Why isn't
> > scsi_target_reap() simply the release routine for the embedded device?
> 
> Look at how scsi_target_reap works: it's the decider for visibility
> removal, not actual release, that's why we can't use the device
> reference, which is the decider for release.  I could have used a kref,
> but, given the special locking conventions and the tying to the __target
> list, the call would have had to be wrappered anyway, so there didn't
> seem to to be much point.
> 
> A target is basically a self destroying entity which is why the
> complexity.

> __target entries are removed when the target goes invisible (and for
> this to happen, all the devices have to be already gone).  __devices
> when the device is released.

This means that scsi_target_reap can be called and the __targets list 
changed essentially at any time (subject only to the host_lock).  Hence it 
is impossible for scsi_forget_host to iterate through the list of targets 
belonging to the host: While it is working to remove one target, the next 
target on the list (stored in the tmp variable) might be removed by 
another thread.

In fact there doesn't seem to be any safe way to remove all the targets
from a host.  And what's to prevent scsi_target_reap being called twice
for the same target?

Alan Stern


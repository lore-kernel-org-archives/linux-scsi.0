From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Wed, 15 Jun 2005 22:22:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506152205000.5061-100000@netrider.rowland.org>
References: <1118876632.5045.90.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.247.233.35] ([140.247.233.35]:3838 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S261583AbVFPCW1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 22:22:27 -0400
In-Reply-To: <1118876632.5045.90.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 15 Jun 2005, James Bottomley wrote:

> On Wed, 2005-06-15 at 17:11 -0400, Alan Stern wrote:
> > This means that scsi_target_reap can be called and the __targets list 
> > changed essentially at any time (subject only to the host_lock).  Hence it 
> > is impossible for scsi_forget_host to iterate through the list of targets 
> > belonging to the host: While it is working to remove one target, the next 
> > target on the list (stored in the tmp variable) might be removed by 
> > another thread.
> 
> It's no better nor worse than we already have.  As has been said many
> times before, we need a proper host state model.
> 
> > In fact there doesn't seem to be any safe way to remove all the targets
> > from a host.  And what's to prevent scsi_target_reap being called twice
> > for the same target?
> 
> The usage, if you look at the code ... it's alloc/reap or inc
> reap_ref/reap

Okay, I understand a little better now.

Would it hurt anything to change scsi_remove_host so that SHOST_DEL gets
set at the start, before scsi_forget_host is called?  If that were done,
then we could make every pathway that adds a device acquire the scan_mutex
and fail if SHOST_DEL is already set.  Thus no devices would ever be added
after forget_host had removed the existing ones, which can happen as
things stand.

Furthermore, forget_host could be changed to loop over the __devices list
instead of the __targets list.  The net effect would be the same: All the
devices on the host would be removed and the targets would automatically
get reaped by scsi_device_dev_release.  There wouldn't be any need to
iterate over the targets at all.

As a final change, the new loop-over-devices in forget_host and the one in
__scsi_remove_target should be made to skip over devices with SDEV_DEL
already set, and each time they call scsi_remove_device the loops should
restart from the beginning.  This will eliminate the problem of the tmp
pointer being pulled out from under the code (even though it has 
quadratic behavior).

Do these changes sound okay?

Alan Stern


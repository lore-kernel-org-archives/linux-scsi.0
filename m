From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Tue, 14 Jun 2005 22:28:59 -0500
Message-ID: <1118806139.5027.37.camel@mulgrave>
References: <Pine.LNX.4.44L0.0506141714530.4698-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:31135 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261306AbVFOD3H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 23:29:07 -0400
In-Reply-To: <Pine.LNX.4.44L0.0506141714530.4698-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2005-06-14 at 17:27 -0400, Alan Stern wrote:
> Can you or anyone else please explain what scsi_target_reap() and
> especially what scsi_target.reap_ref are for?  What's the point of this
> home-brewed reference counting scheme when there's already a perfectly
> useful embedded struct device inside scsi_target?  Why isn't
> scsi_target_reap() simply the release routine for the embedded device?

Look at how scsi_target_reap works: it's the decider for visibility
removal, not actual release, that's why we can't use the device
reference, which is the decider for release.  I could have used a kref,
but, given the special locking conventions and the tying to the __target
list, the call would have had to be wrappered anyway, so there didn't
seem to to be much point.

A target is basically a self destroying entity which is why the
complexity.

> In addition, can someone please explain how long a scsi_target structure 
> and a scsi_device structure are supposed to remain linked into the host's 
> __targets and __devices lists once they have been removed?  The 
> scsi_device link isn't severed until the release routine runs, which can 
> be quite a long time after the device has been removed.  The scsi_target 
> link is severed in scsi_target_reap(), which should be thought of as a
> kind of release routine as well.

__target entries are removed when the target goes invisible (and for
this to happen, all the devices have to be already gone).  __devices
when the device is released.

> Won't this cause trouble in a hotplug environment?  A target or a LUN can 
> be removed, and while it's still on the host's list a new target or LUN 
> could be discovered with the same ID.  Having multiple entries on a list 
> with the same ID sounds like a bad idea.  Is there some reason why these 
> things aren't taken off their list as soon as they are removed?

It shouldn't, that's what rescan is about.  If the device isn't gone,
you get the old device back again.

James



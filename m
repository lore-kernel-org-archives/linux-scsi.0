From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] UAS hangs khubd on USB disconnect
Date: Fri, 13 Dec 2013 13:19:36 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1312131316470.1185-100000@iolanthe.rowland.org>
References: <20131213180907.GB10727@xanatos>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60531 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752926Ab3LMSTh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Dec 2013 13:19:37 -0500
In-Reply-To: <20131213180907.GB10727@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hans de Goede <hdegoede@redhat.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>

On Fri, 13 Dec 2013, Sarah Sharp wrote:

> > Given the way things work now, I suspect these warnings are truly 
> > harmless.  We could simply get rid of the WARN in sysfs_remove_group.
> > 
> > The alternative is to call device_del for SCSI targets earlier on, such 
> > as when their hosts are unregistered.  I don't know how James would 
> > feel about this approach.  It would be difficult because targets use 
> > their own reference counts instead of relying on the usual device 
> > refcounting mechanism.
> 
> Thanks for looking into this.  I think just getting rid of the WARN
> would be sufficient.  Can you make a patch for that?

Easily.  The downside is that there would no longer be any warning 
when someone tries to remove a wrong subdirectory by mistake.

> The patch still won't help with the UAS issues with
> scsi_init_shared_tag_map though.

I wasn't clear on the reason for that problem.  Does it also arise from 
late device_del for scsi_target?  I could try to change the way that 
works, if anybody (Hans?) would like to test it.

Alan Stern


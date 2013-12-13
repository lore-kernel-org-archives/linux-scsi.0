From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [usb-storage] UAS hangs khubd on USB disconnect
Date: Fri, 13 Dec 2013 11:18:47 -0800
Message-ID: <1386962327.2055.54.camel@dabdike.int.hansenpartnership.com>
References: <20131213180907.GB10727@xanatos>
	 <Pine.LNX.4.44L0.1312131316470.1185-100000@iolanthe.rowland.org>
	 <20131213183343.GC27070@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52923 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226Ab3LMTTA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Dec 2013 14:19:00 -0500
In-Reply-To: <20131213183343.GC27070@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Fri, 2013-12-13 at 13:33 -0500, Tejun Heo wrote:
> Hello, guys.
> 
> (cc'ing Greg)
> 
> On Fri, Dec 13, 2013 at 01:19:36PM -0500, Alan Stern wrote:
> > On Fri, 13 Dec 2013, Sarah Sharp wrote:
> > 
> > > > Given the way things work now, I suspect these warnings are truly 
> > > > harmless.  We could simply get rid of the WARN in sysfs_remove_group.
> > > > 
> > > > The alternative is to call device_del for SCSI targets earlier on, such 
> > > > as when their hosts are unregistered.  I don't know how James would 
> > > > feel about this approach.  It would be difficult because targets use 
> > > > their own reference counts instead of relying on the usual device 
> > > > refcounting mechanism.
> > > 
> > > Thanks for looking into this.  I think just getting rid of the WARN
> > > would be sufficient.  Can you make a patch for that?
> > 
> > Easily.  The downside is that there would no longer be any warning 
> > when someone tries to remove a wrong subdirectory by mistake.
> > 
> > > The patch still won't help with the UAS issues with
> > > scsi_init_shared_tag_map though.
> > 
> > I wasn't clear on the reason for that problem.  Does it also arise from 
> > late device_del for scsi_target?  I could try to change the way that 
> > works, if anybody (Hans?) would like to test it.
> 
> While the recent sysfs changes made this issue more visible, Greg
> wants to make sure that devices are removed from leaf up in all cases
> and keep the warning to ensure that.  Would there be a way fix SCSI
> removal ordering?

Could someone analyse the actual problem?  We're quite careful even on
host remove to iterate and remove all the devices, then targets, then
host (and allied transport objects).  Which removal is inverted?

James



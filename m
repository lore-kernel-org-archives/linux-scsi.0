From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 7/7] scsi_dh: attach to hardware handler from dm-mpath
Date: Tue, 20 May 2008 11:52:34 -0700
Message-ID: <1211309554.21974.427.camel@chandra-ubuntu>
References: <20080514144338.714F910B5DF@craiglockhart-ipmi.suse.de>
	 <1210819801.21974.266.camel@chandra-ubuntu>  <482C0676.9070004@suse.de>
	 <1210964001.21974.351.camel@chandra-ubuntu>  <483154B0.7020500@suse.de>
	 <1211221247.21974.382.camel@chandra-ubuntu>  <4832C706.5040202@suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54282 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbYETSun (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 14:50:43 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4KIoYpU015589
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 14:50:34 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4KIoY3C146814
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 14:50:34 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4KIoXSZ001678
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 14:50:34 -0400
In-Reply-To: <4832C706.5040202@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, dm-devel <dm-devel@redhat.com>

Hi Hannes,

Now I see why you want this change in dm-multipath. I think I agree with
these changes.

But, it brings another question: what does dh_state provide ? Help to
user to see which hardware handler a device is attached to ?

I thought more about the scsi_dh_detach function (in the context of my
earlier comment), adding it would require more housekeeping to associate
one-to-one mapping between attach and detach. We can leave it the same
way as the module will be detached when the device disappear eventually.

Thanks,

chandra 
On Tue, 2008-05-20 at 14:41 +0200, Hannes Reinecke wrote:
> Hi Chandra,
> 
> Chandra Seetharaman wrote:
> > On Mon, 2008-05-19 at 12:21 +0200, Hannes Reinecke wrote:
> >> Hi Chandra,
> >>
> [ .. ]
> >> Yes, but this only verifies that the _handler_ exist, not that it is
> >> attached to this sdev
> > 
> > Agreed. And it works properly with the original design.
> > 
> > Here is my thinking on how it would work with the new feature (ability
> > to attach any device using dh_state) you added:
> >  - User adds a new device
> >  - User knows which scsi hardware handler their device can attach to,
> >    lets say, "mydev".
> >  - User attaches the device with scsi hardware handler (writing "mydev"
> >    to "dh_state").
> >    Device is now attached to "mydev"
> >  - User updates his/her multipath.conf file with "mydev" for the
> >    specific device.
> >  - User invokes multipath, which checks for the existence of "mydev"
> >    and allows the table insertion.
> >  - When pg_init was required in the future, multipath calls "activate"
> >    for "mydev" correctly.
> > 
> > Wouldn't this work ?
> > 
> > Note: In the absence of this patch (7/7) only.
> > 
> Yes, but only for the first time. After reboot the user would
> have to do the reconfiguration again.
> 
> >>> Hardware handler module is attached to the device itself (thru
> >>> try_module_get() in attach), so, the module will exist as long as the
> >>> device exists.
> >>>
> >> Not quite. It's only attached automatically if the device map has
> >> an entry for this module.
> >> However, given this patchset we can now easily manually attach any
> >> device to the device handler. Or at least try to do so.
> >> It's then up to the device handler to refuse binding if none of
> >> the necessary pages/information etc. was found.
> > 
> > Doesn't dh_state solve this issue ?
> > 
> In theory, yes.
> 
> >>> Hence, there is no need to attach it again from the multipath layer.
> >>>
> >> Yes, you do. The user might have it's own custom configuration file,
> >> covering new/unknown/unhandled/testing devices, which out of necessity
> >> are _not_ hardcoded in the device table of the device handler.
> >> So multipath has to have a way of attaching device handler to those
> >> devices, too.
> > 
> > dh_state allows the user to do this, in which case why do we need to do
> > this in multipath layer ?
> > 
> Because then we (read: I) don't have to modify multipath-tools.
> If we don't take this patch we'll have to modify multipath-tools
> to check for the dh_state attribute explicitly and activate
> the hardware handler directly via sysfs.
> 
> But this also means that existing multipath-tools programs won't
> be able to correctly activate the hardware handler in
> _some_ cases (ie those cases, where the hardware table for the
> device_handler doesn't contain the device in question).
> And I can just imagine the bugs I'll be getting ...
> So if we decide to take that road we should kill the hardware
> handler feature from the device-mapper multipath interface
> altogether to notify the user that the programs won't work
> anymore. Otherwise it's just heading for trouble.
> 
> So I'd rather keep the userland interface stable here and add
> some code to the kernel.
> 
> Cheers,
> 
> Hannes


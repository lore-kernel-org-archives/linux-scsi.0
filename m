From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 07/10] block: add a new interface to block events
Date: Sun, 18 Nov 2012 15:35:31 -0800
Message-ID: <20121118233531.GC25790@mtj.dyndns.org>
References: <20121118215657.GA25790@mtj.dyndns.org>
 <Pine.LNX.4.44L0.1211181822320.9225-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43503 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab2KRXfh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Nov 2012 18:35:37 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1211181822320.9225-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

Hey, Alan.

On Sun, Nov 18, 2012 at 06:28:24PM -0500, Alan Stern wrote:
> > The problem is that SATA devices aren't really designed to be used
> > like that.  If you reset a ODD w/ a media in it, it'll probably spin
> > it up and try to re-establish media state during probe sequence.  It
> > isn't designed that way and has never been used like that.  SATA has
> > its own dynamic link power management (DIPM/HIPM) tho.
> 
> Is it possible to use those to implement runtime suspend?  Or are they 
> handled autonomously by the hardware?

It's controlled by /sys/class/scsi_host/hostX/link_power_management.
Once enabled, the power saving is completedly handled by hardware.  If
link stays idle longer than certain duration, the hardware initiates
low power state and leaves it when something needs to happen.

> > So, this whole autopm thing doesn't sound like a good idea to me.
> 
> No doubt it's better suited to some devices than to others.

Yeah, SATA seems to need a different approach than USB.

> > I think the only reason autopm doesn't blow up for SATA devices is
> > that userland usually automatically mounts them thus effectively
> > disabling autopm.
> 
> Either that or else because it hasn't been fully implemented yet.  :-)

Ah.. that makes sense. :)

> >  I *think* the only sane thing we can do is doing
> > autopm iff zpodd is available && no media.
> 
> That may be true for SATA.  For USB optical drives, it does make sense
> to power-down the host controller when the drive isn't in use.  USB
> suspend/resume takes on the order of 50-100 ms or so.

I see.  For SATA too, the controller / link bring up doesn't take too
long.  The crappy part is what the attached, especially ATAPI, devices
would do after such events as those events will be visible to them
basically as random link resets.

So, at least for SATA, I think what autopm can do is...

* Trigger zpodd if possible.

* Trigger suspend iff polling isn't happening on the device.

Thanks.

-- 
tejun

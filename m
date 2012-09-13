From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Thu, 13 Sep 2012 22:18:24 +0200
Message-ID: <1787325.sGDVDNVD6E@linux-lqwf.site>
References: <Pine.LNX.4.44L0.1209131213450.21932-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:57820 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215Ab2IMUTy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Sep 2012 16:19:54 -0400
In-Reply-To: <Pine.LNX.4.44L0.1209131213450.21932-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org

On Thursday 13 September 2012 12:24:46 Alan Stern wrote:
> On Thu, 13 Sep 2012, Oliver Neukum wrote:

> > Yes, but this confusion is necessary. The driver core is supposed to
> > be generic and knows strictly speaking only suspended and active.
> > It is a driver's job to do what needs to be done and translate this
> > into the appropriate device states.
> 
> Currently the sd driver's suspend routine is not very sophisticated.  
> It needs to become smarter about the differences between system
> suspend, runtime suspend, and power off.

In what way?

> > Well, yes, but we need support modes of power management that cut off
> > power to the disk in any case, so what does it matter if we also do it for
> > runtime PM?
> > 
> > Are you concerned about layering?
> 
> It sounds like James is partly concerned about efficiency.  If Lin
> Ming's patches are merged then we will be doing runtime suspend
> relatively often, not just when the device file is closed.  The
> sd_suspend routine should know when SYNCHRONIZE CACHE is needed and
> when it can be skipped.

How? This depends on the hardware?

> From what I gather of this discussion, we can avoid flushing the cache 
> during (1) a runtime suspend provided (2) the drive isn't going to be 
> powered down.  If either (1) or (2) doesn't hold then the cache needs 
> to be synchronized.

This is true, but how is it relevant?

> The problem with relying on the internal timers and the power
> management mode page is that the transitions take place automatically
> and the host system doesn't know about them.  We _want_ to know about
> them so that the higher layers of the device tree can go to low power
> when the disk does.

Why would you want that to correlate? The operation of the controller
and the driver is independent of the state.
And what would it tell us, as the driver knows aout all IO anyway?

	Regards
		Oliver



From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [isci PATCH v3 3/4] libsas: suspend / resume support
Date: Wed, 14 Mar 2012 10:21:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1203141010470.1644-100000@iolanthe.rowland.org>
References: <20120314071403.7223.82124.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56238 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752988Ab2CNOVY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 10:21:24 -0400
In-Reply-To: <20120314071403.7223.82124.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>

On Wed, 14 Mar 2012, Dan Williams wrote:

> libsas power management routines to suspend and recover the sas domain
> based on a model where the lldd is allowed and expected to be
> "forgetful".

What exactly does that mean?  What is there for the lldd to remember?  
Does it maintain some sort of state information about the devices 
attached to the links?

> sas_suspend_ha - disable event processing allowing the lldd to take down
>                  links without concern for causing hotplug events.
>                  Regardless of whether the lldd actually posts link down
>                  messages libsas notifies the lldd that all
>                  domain_devices are gone.
> 
> sas_prep_resume_ha - on the way back up before the lldd starts link
>                      training clean out any spurious events that were
>                      generated on the way down, and re-enable event
>                      processing
> 
> sas_resume_ha - after the lldd has started and decided that all phys
> 		have posted link-up events this routine is called to let
> 		libsas start it's own timeout of any phys that did not
> 		resume.  After the timeout an lldd can cancel the
>                 phy teardown by posting a link-up event.
> 
> Storage for ex_change_count (u16) and phy_change_count (u8) are changed
> to int so they can be set to -1 to indicate 'invalidated'.
> 
> There's a hack added to sas_destruct_devices to workaround a deadlock
> when a device is removed across the suspend cycle.  sd_remove is called
> under device_lock() and wants to async_synchronize_full(), while the
> resume path is running in an async callback and is trying to grab
> device_lock()... fun ensues.  So we guarantee that async resume actions
> have been flushed before allowing new invocations of sd_remove.

Ooh, that doesn't sound like a good way to handle it.  For one thing, 
it's possible for the resume routine to be called while the caller 
holds the device-lock for the device being resumed.  It would be best 
if the resume path defers removal of devices that have disappeared to a 
different thread.

Alan Stern


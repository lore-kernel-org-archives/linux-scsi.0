From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] BUG when removing USB flash drive
Date: Fri, 14 May 2004 09:59:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040514165956.GA8122@us.ibm.com>
References: <20040514053623.GD3819@us.ibm.com> <Pine.LNX.4.44L0.0405141105060.4524-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:24559 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261779AbUENRA1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 May 2004 13:00:27 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0405141105060.4524-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alberto Bertogli <albertogli@telpin.com.ar>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> On Thu, 13 May 2004, Mike Anderson wrote:
> 
> > The LLDD queuecommand should not be called after the return of
> > scsi_remove_host (unless we have a bug). The LLDD should not free its
> > resources until the release function is called on the struct device
> > passed in during the scsi_add_host call.
> 
> Ah.  We have a problem here, because usb-storage doesn't own that struct 
> device.  It is owned by the USB core, and usb-storage has no way to know 
> when its release function has been called.
> 
> Even worse, the release function may never be called at all.  The device
> itself may still exist and be attached to the system even though the
> usb-storage driver has been unbound from it.
> 
> There must be many other LLDDs with the same problem.  Any driver that 
> manages a PCI host controller, for example.  The struct device it receives 
> from the PCI layer isn't owned by the LLDD, yet that's what it must pass 
> to scsi_add_host().
> 
> How should we handle this?
> 

I was incorrect in my previous statement. Well we may hold a reference
count on the struct device passed into the scsi_add_host until all
references on the host instance are gone and there maybe a positive ref
count on the hostt module until all devices are closed a instance of
LLDD should be able to do cleanup post return of scsi_remove_host. This
needs to be true or SCSI mid-layer would not honor the requirement for
the pci remove call.

I believe in the past you or someone else has mentioned that post the
return of scsi_remove_host a Scsi_Host instance still has a hostt and a
transportt which may be dangerous if all code paths are not correctly
handling a host in the SHOST_DEL state.

I guess we still have this current issue on what is happening in the
usb storage that it believes SCSI mid is still using the device. Is
something not cleaning up, or is something in SCSI mid not honoring the
SHOST_DEL state.

-andmike
--
Michael Anderson
andmike@us.ibm.com


From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] BUG when removing USB flash drive
Date: Fri, 14 May 2004 11:12:34 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0405141105060.4524-100000@ida.rowland.org>
References: <20040514053623.GD3819@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:7684 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261505AbUENPMf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 May 2004 11:12:35 -0400
In-Reply-To: <20040514053623.GD3819@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Alberto Bertogli <albertogli@telpin.com.ar>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 13 May 2004, Mike Anderson wrote:

> The LLDD queuecommand should not be called after the return of
> scsi_remove_host (unless we have a bug). The LLDD should not free its
> resources until the release function is called on the struct device
> passed in during the scsi_add_host call.

Ah.  We have a problem here, because usb-storage doesn't own that struct 
device.  It is owned by the USB core, and usb-storage has no way to know 
when its release function has been called.

Even worse, the release function may never be called at all.  The device
itself may still exist and be attached to the system even though the
usb-storage driver has been unbound from it.

There must be many other LLDDs with the same problem.  Any driver that 
manages a PCI host controller, for example.  The struct device it receives 
from the PCI layer isn't owned by the LLDD, yet that's what it must pass 
to scsi_add_host().

How should we handle this?

Alan Stern


From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Fw: [BUG] USB Storage OOPS and a D state
 process in 2.6.10
Date: Mon, 10 Jan 2005 17:29:34 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0501101718480.1334-100000@ida.rowland.org>
References: <20050110201430.GB11967@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:25604 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262555AbVAJW3i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 17:29:38 -0500
In-Reply-To: <20050110201430.GB11967@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Srihari Vijayaraghavan <harisri@internode.on.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 10 Jan 2005, Mike Anderson wrote:

> > This is the first indication of something funny.  I can't think how a bus
> > reset would get initiated by the kernel -- that only happens after a
> > timeout.  Maybe it came from a user program?
> 
> Well it can get initiated in the scsi error handler. This can be verified
> by setting the logging_level (sysctl -w dev.scsi.logging_level=0x4).

It could be, but it's very unlikely.  Especially since the error handler 
only does a bus reset in response to repeated timeouts (which don't happen 
here; commands either succeed or quickly get an error) and since the host 
has already been removed.

> You probably do not need to do this as I assume what is happening is that
> with all the plug and unplug that is being initiated that a IO is in
> flight when the scsi_remove_host functions is called. It looks like we
> still have to decide on the removal cleanup. Currently scsi_host_cancel
> being called from scsi_remove_host appears to not do anything as
> scsi_forget_host removes the devices from the list it iterates over.

That could easily be the problem.

>  Also
> as previously mentioned by you there are races with scsi_mid canceling IOs
> that might be completing.  Both of these issue where mentioned in an old
> thread (link provided below), but not completely resolved.
> 
> http://marc.theaimsgroup.com/?t=109630920600005&r=1&w=2
> 
> What is needed is for the LLDD to ensure all IO sent through the LLDD's
> queuecommand functions gets a scsi_done call (even a fail call). The scsi
> mid applies choke points to stop IO being set to the LLDDs queuecommand,
> but there can be races during a host removal (you previously mentioned
> this). This would also imply that scsi mid should not be making the call
> to scsi_host_cancel (which appears to not do anything anyway).

This _has_ been resolved in usb-storage.  Every command sent to the 
queuecommand routine either gets executed and sent to scsi_done or else is 
rejected immediately with a failure call to scsi_done.  The exception is 
commands that were aborted through the command_abort routine; scsi_done is 
not called for them.

My concern is about reset requests coming in through an ioctl call; they
don't pass through queuecommand but are sent directly to the bus_reset
routine.  Hence they aren't subject to the choke point treatment you
describe.

Alan Stern


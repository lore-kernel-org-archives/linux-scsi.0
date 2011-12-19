From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH] usb/uas: use scsi_host_find_tag() to find command from a
 tag
Date: Mon, 19 Dec 2011 12:12:26 -0800
Message-ID: <20111219201226.GC5470@xanatos>
References: <4EE9B375.4020606@linutronix.de>
 <20111215211201.GA6482@xanatos>
 <20111216144724.GC19563@linutronix.de>
 <20111216201236.GE19563@linutronix.de>
 <20111216203146.GN14291@linux.intel.com>
 <20111216204241.GA30915@linutronix.de>
 <20111216213628.GA5509@xanatos>
 <1324072059.10429.27.camel@dabdike>
 <20111219193955.GA2060@linutronix.de>
 <20111219195050.GQ14291@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51089 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab1LSUMl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Dec 2011 15:12:41 -0500
Content-Disposition: inline
In-Reply-To: <20111219195050.GQ14291@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>

On Mon, Dec 19, 2011 at 02:50:50PM -0500, Matthew Wilcox wrote:
> On Mon, Dec 19, 2011 at 08:39:55PM +0100, Sebastian Andrzej Siewior wrote:
> > In "usb/uas: use unique tags for all LUNs" we make sure to create unique
> > tags across all LUNs. This patch uses scsi_host_find_tag() to obtain the
> > correct command which is associated with the tag.
> > The following changes were required:
> > - don't use sdev->current_cmnd anymore
> >   Since be can have devices which don't support command tagging we must
> >   ensure that we can tell the two commands apart. devinfo->cmnd is used
> >   for this.
> 
> I don't understand.  There's one devinfo per sdev.  How does moving the
> untagged command anchor from sdev to devinfo change anything?

I thought there was only one devinfo per USB device.  uas_probe() is
only called once per USB device, and that's where devinfo is allocated and
the scsi_host is created.

> It's my understanding that the SCSI core will only send either a single
> untagged command, or tagged commands.  ie any outstanding tagged command
> will cause an untagged command to be deferred, and an outstanding untagged
> command will prevent any other command from being sent to the driver.

Across all scsi_devices on a scsi_host?

In the status command completion for USB 2.0 devices, we can't know
which scsi_device we're completing the command for.  Is it an untagged
command completion for LUN 1 or LUN 2?  We can't tell, because the
device could reorder the commands across LUNs.  So for untagged USB 2.0
devices, we need to be sure there is only one untagged command pending
per scsi_host, and pull the command out of devinfo.

Sarah Sharp

From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] [PATCH] SCSI: add check_capacity flag and
 sd_read_last_sector()
Date: Wed, 22 Apr 2009 16:47:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0904221633050.3405-100000@iolanthe.rowland.org>
References: <20090422191752.GA24309@ub>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:46462 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754569AbZDVUrE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 16:47:04 -0400
In-Reply-To: <20090422191752.GA24309@ub>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 22 Apr 2009, Andries E. Brouwer wrote:

> On Wed, Apr 22, 2009 at 10:42:36AM -0400, Alan Stern wrote:
> > This patch (as1196) adds a new scsi_device flag to tell sd.c that it
> > should verify the results of READ CAPACITY by trying the read the last
> > sector.
> 
> Hi Alan,
> 
> I can see why you want to do this, but allow me to mutter a bit nevertheless.
> Many devices are flaky and get into strange states requiring error-recovery
> or reboot when you try an I/O that they do not like.
> For this reason, and also for aesthetical reasons, I would prefer never to
> do I/O to a device unless user space asks for it.

I appreciate your caution -- and your aesthetic sensibilities!

Note that a certain amount of I/O goes on independent of userspace (to
determine the partitioning, if nothing else).  One can make a good case
that this "check the last sector" falls into the same category.

> (So - this would be much more work, but I would prefer a capacity value
> that says "it reported this, but we have not checked yet - try an actual
> I/O if you really want to know", and leave it at that until the value is
> needed. Typically one needs the value (i) to check against it if one
> wants to do I/O, or (ii) when user space asks for it because some fdisk type
> program is invoked. In case (i) an additional read is superfluous.
> In case (ii) user space asked and we try to make sure.)
> 
> Comments?

How would the kernel know when it needed to make sure?  By the time an 
actual I/O request from userspace arrives, it's probably too late -- 
the task has already looked at the capacity value and doesn't know that 
the capacity might change spontaneously.

As a more theoretical point, consider what would happen if the last 
partition included the "last" sector.  If the capacity got changed 
after the partitions were determined, we could run into trouble.  
Better to adjust the capacity right away, before a bogus value can get 
used.

My thought (expressed in an email some months ago, so it's not
surprising that people may have forgotten) was that this "check the
last sector" test would not be applied if we knew beforehand that it
was unnecessary or the device couldn't support it.  If either of the
CAPACITY_OK or FIX_CAPACITY flags is set then the last-sector check
won't be performed.

Thus, when we run across a device that dies during the last-sector
check, we'll have to add an unusual_devs entry for it.  But since
that's basically the same position we're in now, I don't see it as much
of a loss.

Alan Stern


From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] BUG when removing USB flash drive
Date: Thu, 13 May 2004 23:11:01 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0405132305400.32262-100000@netrider.rowland.org>
References: <20040514004132.GA10537@telpin.com.ar>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:62219 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S264192AbUENDLC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 23:11:02 -0400
In-Reply-To: <20040514004132.GA10537@telpin.com.ar>
List-Id: linux-scsi@vger.kernel.org
To: Alberto Bertogli <albertogli@telpin.com.ar>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 13 May 2004, Alberto Bertogli wrote:

> Hi!
> 
> I've just hit a bug after removing a Kingston USB flash drive.
> 
> I have removed it several (probably more than 40) times today without
> problems until now. I'm removing it while doing streaming write()s on
> the device (using /dev/sda) because I'm testing some things with the
> drive. This was just like all the other times, so it looks like a race
> somewhere.
> 
> This is a stock 2.6.6 kernel, on a Pentium 4 with HT (the kernel is
> compiled with both SMP and preempt).
> 
> After the BUG the kernel doesn't detect the device anymore.
> 
> Please let me know if you need any more information or if I can give you a
> hand with testing.
> 
> Thanks a lot,
> 		Alberto
> 
> 
> kernel BUG at drivers/usb/storage/usb.c:848!

This BUG happened because the SCSI layer was still using the drive after 
usb-storage had called scsi_remove_host().

This is an aspect of SCSI midlayer <-> low-level driver interaction that
I'm not very clear about.  How long after the host is removed can the
midlayer continue to use it?  How does the driver know when the midlayer
is finished using the host so the driver can exit (and unload from
memory)?

Alan Stern


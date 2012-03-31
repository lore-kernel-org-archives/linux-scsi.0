From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Sat, 31 Mar 2012 11:31:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1203311121560.27759-100000@netrider.rowland.org>
References: <BA1D046C8A454166BF330A4A89630D1F@diamond1720>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:48233 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760309Ab2CaPbv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Mar 2012 11:31:51 -0400
In-Reply-To: <BA1D046C8A454166BF330A4A89630D1F@diamond1720>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, 31 Mar 2012, Norman Diamond wrote:

> >> bcdDevice is 1.00
> >
> > That's the same as a bridge that was reported non-working.  Which means 
> > the OS has no way to tell them apart.
> 
> There's still something wrong here.  When the bridge is connected to Windows 
> XP, Windows accesses the correct number of blocks.  We need to find someone 
> who has a non-working but indistinguishable bridge, ask them to connect it 
> to Windows XP, and see if Windows XP gets a number of blocks that is too 
> large by 1.

How would you tell?  And what's so special about XP?  Why not Vista or 
Windows 7?

> > There is no good solution to this problem.
> 
> Agreed.  But in my case I think I need to disable that quirk entirely for 
> all USB bridges, so that my uses of Linux will always believe what the USB 
> bridge reports.  At least then my program will work correctly when working 
> bridges are attached.  Then if a user complains, we can tell them to use a 
> different bridge. 

Well, if you want to disable the quirk entirely, it's not hard to do.  
In drivers/usb/storage/scsiglue.c, just get rid of the lines that set 
sdev->fix_capacity and sdev->guess_capacity.

If you want to find out who reported the problems with the bridge chip, 
look in the unusual_devs.h file for the entry with vendor ID 0x067b and 
product ID 0x2507.

Alan Stern


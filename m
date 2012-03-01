From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: scsi_wait_scan and scsi_complete_async_scans
Date: Thu, 01 Mar 2012 07:26:57 -0600
Message-ID: <1330608417.2888.6.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1202160916160.1268-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50029 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966222Ab2CAN07 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 08:26:59 -0500
In-Reply-To: <Pine.LNX.4.44L0.1202160916160.1268-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2012-02-16 at 09:29 -0500, Alan Stern wrote:
> James or anyone else:
> 
> The purpose of the scsi_wait_scan module is to provide a method for
> initramfs images to wait until all the SCSI drives available at boot-up
> have been discovered and probed, so that the drive containing the root
> filesystem will be available when the time comes to mount it.
> 
> Now, in include/scsi/scsi_scan.h, the declaration of 
> scsi_complete_async_scans() depends on CONFIG_SCSI.  If the SCSI core 
> is built as a module, scsi_complete_async_scans() is defined as an 
> empty inline routine.
> 
> This doesn't seem to make any sense.  The drive containing the root 
> filesystem needs to be available for mounting regardless of whether 
> scsi_mod is built into the kernel or is loaded as a module within an 
> initramfs image.
> 
> In short, is there any reason not to remove the "#ifdef CONFIG_SCSI"  
> from include/scsi/scsi_scan.h?
> 
> My reason for asking is because I need to fix a bug in scsi_pm.c, and 
> the fix involves calling scsi_complete_async_scans().  This has to 
> happen even when CONFIG_SCSI isn't defined, so I'd like to change the 
> header file.  If necessary, I can put the call in scsi_wait_scan.c 
> inside a "#ifdef CONFIG_SCSI" block.

I'm fine with that.  scsi_wait_scan was supposed to be a hack until all
distros got wait for device in initrd sorted out ... but like all hacks
it's lived on way past its time.

James



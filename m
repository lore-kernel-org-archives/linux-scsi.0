From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] 3ware 5/6/7/8000 driver v1.26.02.000
Date: Fri, 10 Sep 2004 15:53:31 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040910135331.GA484@lst.de>
References: <I3R1V900.IHN@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:45286 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267409AbUIJNxj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2004 09:53:39 -0400
Content-Disposition: inline
In-Reply-To: <I3R1V900.IHN@hadar.amcc.com>
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <aradford@amcc.com>
Cc: akpm@osdl.org, James.Bottomley@SteelEye.com, hch@lst.de, linux-scsi@vger.kernel.org

On Wed, Sep 08, 2004 at 06:08:27PM -0700, Adam Radford wrote:
> Andrew/James/Christoph Hellwig,
> 
> Here is a large driver update for the 3ware 5/6/7/8000 series controllers
> for 2.6.9-rc1-bk16.
> 
> Changes in this release are the following:
> 
> - Remove deprecated SCSI_IOCTL_SEND_COMMAND interface.
> - Remove deprecated /proc/scsi/3w-xxxx interface.
> - Convert entire driver to pci_driver format.
> - Remove all mdelays, replace w/msleep to fix possible watchdog
>   timer issues.
> - Make all register accesses macros.
> - Remove all prototypes from header file, reorder functions to
>   eliminate all prototypes but one.
> - Add sysfs 'queue_depth' setting attribute.
> - Add sysfs 'stats' attribute.
> - Fix spinlocks everywhere, remove tw_lock spinlock.
> - Remove all bitfields, add bitmask access macros.
> - Remove un-needed scsi_eh_abort entrypoint.  Controller does not
>   support aborting invididual IO's, scsi_eh_reset sufficient.
> 
> The patch is rather lengthy due to the function reordering.  I hope it doesn't
> get sniffed out by the list server.

The patch is indeed extremly huge and because of that not really
reviewable :P  I did a quick look over the patched sourcefiles and
the driver looks pretty nice to me (except for the non-standard coding
style which we tend to accept if the diver is sane otherwise) and it
also compiles without a warning on ppc64.

Minor things (could be fixed in a followup patch)

 - tw_check_bits should be marked static like everything else
 - please provide a MODULE_VERSION like most modern scsi drivers
 - in the ioctl path it might be usefull to use dma_alloc_coherent
   instead of pci_alloc_consistent because it allows allocations to
   sleep when use with GFP_KERNEL as last argument (else they're the
   same on pci devices)
 - also in the ioctl patch you return the value that copy_to_user
   returned, but that's not an error code but the number of bytes
   copied, you probaly want an 

	if (copy_to_user(argp, tw_ioctl, sizeof(TW_New_Ioctl) +
				data_buffer_length - 1))
		error = -EFAULT;


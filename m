From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Areca RAID driver remaining items?
Date: Mon, 20 Feb 2006 18:20:45 +0000
Message-ID: <20060220182045.GA1634@infradead.org>
References: <1140458552.3495.26.camel@mentorng.gurulabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53638 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1161104AbWBTSUs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2006 13:20:48 -0500
Content-Disposition: inline
In-Reply-To: <1140458552.3495.26.camel@mentorng.gurulabs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dax Kelson <dax@gurulabs.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, billion.wu@areca.com.tw, alan@lxorguk.ukuu.org.uk, akpm@osdl.org, erich@areca.com.tw, arjan@infradead.org, oliver@neukum.org

On Mon, Feb 20, 2006 at 11:02:32AM -0700, Dax Kelson wrote:
> This appears to be the most current version of the driver:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.16-rc4/2.6.16-rc4-mm1/broken-out/areca-raid-linux-scsi-driver.patch
> 
> Is this the current TODO list?
> 
> =================
> Issues not yet patched:
> 
> 13. uintNN_t int types:  use kernel types except for userspace
> interfaces
> 14. use kernel-doc
> 18. Put arcmsr.txt in Documentation/scsi/, not in scsi/arcmsr/.
> 19. Maybe use sysfs (/sys) instead of /proc.
> 20. check stack usage, init/exit sections;


 - remove internal queueing
 - fix hardware datastructures
 - remove odd ioctls
 - remove useless forward prototypes
 - give types like ACB useful names
 - give variable useful names, especially follow kernel conventions,
   e.g. a struct pci_dev is usually named pdev
 - kill ->proc_info method
 - use normal comment style even for comments not fitting into the
   kernel-doc item above.  kill useless separator comments without
   text
 - convert arcmsr_show_firmware_info to useful one value per
   file attributes.  best follow the schemes used in aacraid or
   lpfc
 - convert arcmsr_show_driver_state to useful one value per
   file attributes.
 - remove never called release method in the host template
 - audit whether setting unchecked_isa_dma to false really makes
   sense (I strongly doubt it)
 - remove shutdown notifier, add pci_driver ->shutdown method instead
 - remove CameCase PCI Ids.  The vendor Id should go into pci_ids.h,
   the device ids either removed or spelled the normal linux way
 - arcmsr_do_interrupt should stop walking the global host list
   and use the private data passed to request_irq
 - the global host list should go away completely
 - arcmsr_bios_param looks like duplicating the generic CAM version?
 - locking needs to be redone.  If the driver really needs more than
   one per-host lock we'll want a very good explanation
 - arcmsr_device_probe needs to be rewritten to do goto-based
   error unwinding.
 - msi should be a module options if at all, but defintitly not
   a config options
 - arcmsr_scsi_host_template_init should go away.  the host template
   must be initialized statically with no run-time writes to it
 - the hardware documentation should be split out of arcmsr.h
   into a separate file (btw, thanks a lot to areca to provide such
   detailed hardware informations, it's just the wrong format..)
 - remove the SCSISTAT_* defines, and use the generic ones from
   <scsi/scsi.h> instead.  Dito for various other SAM defines.
 - the driver has just two files and should go directly into
   drivers/scsi instead of a subdirectory

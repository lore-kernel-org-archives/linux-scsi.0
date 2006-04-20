From: Andrew Morton <akpm@osdl.org>
Subject: Re: areca RAID driver
Date: Thu, 20 Apr 2006 13:07:23 -0700
Message-ID: <20060420130723.2cc2396e.akpm@osdl.org>
References: <20060419155300.321c352e.akpm@osdl.org>
	<20060420194831.GA7923@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:20712 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751241AbWDTUId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Apr 2006 16:08:33 -0400
In-Reply-To: <20060420194831.GA7923@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com, hch@lst.de, axboe@suse.de, erich@areca.com.tw, billion.wu@areca.com.tw, linux-scsi@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Apr 19, 2006 at 03:53:00PM -0700, Andrew Morton wrote:
> > 
> > Gents, Erich thinks that the Areca driver is pretty much ready to go.
> > 
> > We still have the weird read-past-EOF problem if MAX_XFER_SECTORS=4096, but
> > this version of the driver has it set to 512, which makes the problem go
> > away.  I've suggested that we can set that problem aside for now.
> > 
> > I've put a copy of the latest diff at
> > http://www.zip.com.au/~akpm/linux/patches/stuff/areca-raid-linux-scsi-driver.patch.
> >  Could you please take a look sometime, decide how we should proceed?
> 
> It still doesn't address lots of the month-old comments.
> 
> Serious stuff:
>  - doesn't follow one value per file in sysfs rule
>  - arcmsr_device_probe (which should really be called arcmsr_probe!)
>    doesn't propagate the pci_enable_device return value
>  - ditto  for request_irq
>  - please do proper goto unwinding in arcmsr_device_probe instead of
>    calling arcmsr_pcidev_disattach in various places
>  - arcmsr_report_sense_info is buggy.  all scsi-commands are S/G lists
>    now.
>  - pleaase don't put that odd "linux bug" workaround into
>    arcmsr_queue_command.  If you can reproduce that bug please report it
>    and we'll fix it.
>  - the target 16 inquiry emulation is broken for the same reasons as the
>    report_luns one above.  Care to explain why you need it at all?
>  - I can't see any endianess handling in the whole driver.  Was this
>    tested on a BE platform like powerpc?
>  - the probe path is doing mmio access before pci_request_regions.
>  - scsi_remove_host is called far too late
>  - dma_addr_ts are casted to unsigned longs which doesn't work
>    with 64bit dma and 32bit plattforms
> 
> Cosmetical stuff:
> 
>  - odd formated comments instead of kerneldoc / per CondingStyle
>  - very odd variable naming, lots of uppercase and p prefixes
>  - please kill all these useless forward-declarations and format
>    the code in the natural call flow
>  - the consistent_dma_mask is 32bits by default, not need to call
>    pci_set_consistent_dma_mask
> 

Thanks again, Christoph.  I'll add the above to the changelog (along with
Matthew's observations)

> And there's probably a lot more issues.  Below is a patch that tries to
> cleanup the pci driver entry points according to the above list.  Due
> to all this moving things around it's pretty huge.

Erich, could you please test and review this patch, and send the result
back to me for integration?


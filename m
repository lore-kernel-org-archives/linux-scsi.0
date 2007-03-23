From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic7xxx: aic7892(B): BUG: soft lockup detected on CPU#0!
Date: Thu, 22 Mar 2007 22:45:38 -0600
Message-ID: <1174625139.30030.31.camel@mulgrave.il.steeleye.com>
References: <46029D72.3060403@gmx.de> <4602B576.6020602@gmx.de>
	 <4602EED5.5070503@gmx.de> <46030A9A.2060604@gmx.de>
	 <46032CC8.6030307@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45301 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933569AbXCWEpo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Mar 2007 00:45:44 -0400
In-Reply-To: <46032CC8.6030307@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: t.schorpp@gmx.de
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2007-03-23 at 02:26 +0100, thomas schorpp wrote:
> ok, overriding the first while(ahc_is_paused) that blocked before 
> (i see no sense for doing this in a pci mmap test function, cause 
> proper resource setup is required *before* using such I/O functions, 
> otherwise the adapter had entered SEQ paused status)
> i got the kernel to boot at least at pio mode.
> 
> this is surely not the correct resource and looks like a datatype 
> boundary overflow, the upper 0x0f is missing:
> [   49.278810] Trying to free nonexistent resource
> <00000000fffff000-00000000fff
> fffff>

That's because ahc->platform_data->mem_busaddr is u32


> [   54.513224] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
> [   54.513226]         <Adaptec 19160B Ultra160 SCSI adapter>
> [   54.513227]         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

The driver code suggests that the 7892 can't do the AHC_LARGE_SCBS
features ... which means the card itself cannot address more than 32
bits of memory, so it would be unable to decode a BAR that's beyond the
32 bit range.  So this looks like some type of error in the PCI config
system (or possibly in the BIOS).  I think this card needs its BARs to
be in the lower 32 bits to function.

James



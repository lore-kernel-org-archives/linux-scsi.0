From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [patch 0/4] aha152x.c - Cleanup, need help in testing and
 auditing
Date: Thu, 19 Jul 2007 08:37:19 -0700
Message-ID: <20070719083719.33d8994c.rdunlap@xenotime.net>
References: <4695F76F.5000305@panasas.com>
	<20070712135750.2a4a4a54.rdunlap@xenotime.net>
	<469B38CC.50501@panasas.com>
	<20070717171607.ffc278eb.rdunlap@xenotime.net>
	<469DDD74.2060208@panasas.com>
	<20070718103320.4b6ad7b3.rdunlap@xenotime.net>
	<20070718145818.8eebbd66.rdunlap@xenotime.net>
	<20070718194335.e21a01e5.rdunlap@xenotime.net>
	<20070718200315.3adcd194.rdunlap@xenotime.net>
	<469F616D.1000909@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:53394 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S939409AbXGSPcx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jul 2007 11:32:53 -0400
Received: from midway.site ([71.117.236.25]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 19 Jul 2007 08:32:52 -0700
In-Reply-To: <469F616D.1000909@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dougg@torque.net>, scsi <linux-scsi@vger.kernel.org>, "=?ISO-8859-1?Q? J=FCrgen_E._Fischer ?=" <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thu, 19 Jul 2007 16:04:45 +0300 Boaz Harrosh wrote:

> Randy Dunlap wrote:
> > On Wed, 18 Jul 2007 19:43:35 -0700 Randy Dunlap wrote:
> > 
> >> On Wed, 18 Jul 2007 14:58:18 -0700 Randy Dunlap wrote:
> >>
> >>> On Wed, 18 Jul 2007 10:33:20 -0700 Randy Dunlap wrote:
> >>>
> >>>> Hi,
> >>>>
> >>>> I don't see the reset problem after applying this patch, but I'm
> >>>> still seeing an Oops in datao_run.  Log is attached.
> OK 1 bug down.
> 
> >> Looks to me like this driver doesn't handle highmem virtual addresses
> >> very well.  I expect that it would work OK if CONFIG_HIGHMEM=n or
> >> it had a slave_alloc function to limit the memory addresses that it
> >> sees (like ppa & imm do).  As it is on a machine with HIGHMEM=y,
> >> it gets sglist virtual addresses of 0, e.g.:
> > 
> > Confirmed that limiting the blk queue bounce limit to
> > BLK_BOUNCE_HIGH runs as expected (copy files, compare them successfully).
> > 
> This is grate! Thanks for checking and debugging this.
> Am I right in assuming that the remaining bug has been there
> before my patchset? Has my patchset made it any worse?

Yes, this problem has been around forever AFAIK.  You didn't add
to it.

> > include/asm-i386/scatterlist.h talks about using pci_map_sg()
> > to get bus addresses from the scatterlist table.  However, this driver
> > knows nothing about PCI.  Should it use dma sg mapping instead?
> > or what is the desired fix here?
> 
> I'm afraid this is out of my league. James, Christoph, anybody?
> What would be the right thing to do here?
> 
> > 
> > Thanks.
> > ---
> 
> Thank you. Please forgive me with the debug thing. One thing I learned in
> my 17 years of programing is never send code you have not compiled & tested.
> I mean what can go wrong with turning debugging on, right?;)
> 
> I will wait out the solution to above remaining problem and send another
> round of patches.
> 
> One more thing if I may? Do you have at hand an old Zip cartridge that 
> has bad sectors or other errors on it. My motivation is to exercise the
> Sense return code-path. I would like to make sure that its doing the 
> expected. It is the part that changed the most.
> I will try to look if there is a way to send a scsi_read using sg3_utils that 
> will read passed the media capacity, and will trigger a short read. I guess
> on an unmounted device. Douglas?

No, I don't have any bad media that I know of.
I suggest that you look into the "Fault-injection framework"
(CONFIG_FAULT_INJECTION) to see if it can inject some errors for you.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

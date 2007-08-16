From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [patch 0/4] aha152x.c - Cleanup, need help in testing and
 auditing
Date: Thu, 16 Aug 2007 10:20:06 -0700
Message-ID: <20070816102006.8a46281e.rdunlap@xenotime.net>
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
	<20070719083719.33d8994c.rdunlap@xenotime.net>
	<469F89FE.4080900@panasas.com>
	<20070719104930.7ae87df8.rdunlap@xenotime.net>
	<20070815222258.2601797f.rdunlap@xenotime.net>
	<1187275194.3367.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:36795 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757417AbXHPRNz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Aug 2007 13:13:55 -0400
Received: from midway.site ([71.117.240.242]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 16 Aug 2007 10:13:46 -0700
In-Reply-To: <1187275194.3367.21.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dougg@torque.net>, "=?ISO-8859-1?Q? _J=FCrgen_E._Fischer_ ?=" <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, matthew@wil.cx, jens.axboe@oracle.com

On Thu, 16 Aug 2007 09:39:54 -0500 James Bottomley wrote:

> On Wed, 2007-08-15 at 22:22 -0700, Randy Dunlap wrote:
> > On Thu, 19 Jul 2007 10:49:30 -0700 Randy Dunlap wrote:
> > 
> > > On Thu, 19 Jul 2007 18:57:50 +0300 Boaz Harrosh wrote:
> > > 
> > > > Randy Dunlap wrote:
> > > > > 
> > > > > Yes, this problem has been around forever AFAIK.  You didn't add
> > > > > to it.
> > > > Do we need to file a bug report in Bugzilla or something, so people have a 
> > > > documentation of the work-around, until it is fixed?
> > > 
> > > Wouldn't hurt, I guess, but the SCSI people know about it.
> > > 
> > > > I think that for now I will wrap it up as it is. Could you send me the right
> > > > BUG_ON() in place, with a printk pointing users to a solution? and I'll 
> > > > redo all the patches.
> > > 
> > > I didn't add a BUG_ON(), so I don't have that patch.
> > > (I just used a .slave_alloc function to force no high memory data
> > > addresses, just like ppa.c does.)
> > > 
> > > You could just do a BUG_ON() just before there is an outsw()
> > > or insw() to a NULL pointer, e.g., in datao_run:
> > > 
> > > 		BUG_ON(CURRENT_SC->SCp.ptr);
> > > 
> > > or we could make building the driver depend on !HIGHMEM.
> > > 
> > > I prefer either of the !HIGHMEM or slave_alloc changes to adding
> > > a BUG_ON().  However, the SCSI people likely won't want to use the
> > > slave_alloc() change because then the driver may never get fixed.
> > > (Of course, it hasn't got fixed with the BUG happening either.)
> > > 
> > > Anyway, I'll re-read Documentation/DMA*.txt to see if I can fix it.
> > 
> > 
> > I have asked this once before, but I don't like the answer.
> > 
> > Currently aha152x.c only works with !HIGHMEM due to highmem-pages
> > not being mapped into the driver's memory space.  James and hch
> > tell me that using DMA mapping functions is the way to fix this,
> > but those appear to me to be for DMA (!!), and this driver is (only)
> > using PIO.
> > 
> > I did try to use dma_map_sg() & dma_unmap_sg() here, but they end up
> > giving the driver physical buffer addresses, which aren't what is
> > needed for PIO.  Should this driver be using
> > 	scsi_kmap_atomic_sg() and scsi_kunmap_atomic_sg()
> > or other API functions, or should the driver just use
> > 	kmap_atomic() + kunmap_atomic()
> > for each highmem page?
> 
> For DMA transfers ... which is where you give the device a bus physical
> address and a length and tell it to go off and perform the transfer on
> its own, you need to use the dma_map_ functions.
> 
> For PIO transfers, which are usually ones where you have to feed the
> data into a special device register, since the kernel needs access to do
> this, it has to be done via kmap_atomic()/kunmap_atomic().  So, if
> everything has to go via pio, you use a sequence like

Thanks for the confirmation.

> scsi_for_each_sg(cmd, sg, max, i) {
> 	offset = sg->offset;
> 	len = sg->len;
		->length;

> 	do {
> 		coffset = offset; clen =len;
> 		buf = scsi_kmap_atomic_sg(sg, 1, &coffset, &clen)

					why   1 ?

> 		offset -= coffset; clen -= len;

		       += ?

> 		<feed buf+coffset to/from PIO for clen>
> 		scsi_kunmap_atomic_sg(buf);
> 	} while (len > 0);
> }

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

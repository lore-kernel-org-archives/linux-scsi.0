From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [patch 0/4] aha152x.c - Cleanup, need help in testing and
 auditing
Date: Wed, 18 Jul 2007 20:03:15 -0700
Message-ID: <20070718200315.3adcd194.rdunlap@xenotime.net>
References: <4695F76F.5000305@panasas.com>
	<20070712135750.2a4a4a54.rdunlap@xenotime.net>
	<469B38CC.50501@panasas.com>
	<20070717171607.ffc278eb.rdunlap@xenotime.net>
	<469DDD74.2060208@panasas.com>
	<20070718103320.4b6ad7b3.rdunlap@xenotime.net>
	<20070718145818.8eebbd66.rdunlap@xenotime.net>
	<20070718194335.e21a01e5.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:46061 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757845AbXGSC65 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jul 2007 22:58:57 -0400
Received: from midway.site ([71.117.236.25]) by xenotime.net for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 19:58:51 -0700
In-Reply-To: <20070718194335.e21a01e5.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, "=?ISO-8859-1?Q? J=FCrgen_E._Fischer ?=" <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Wed, 18 Jul 2007 19:43:35 -0700 Randy Dunlap wrote:

> On Wed, 18 Jul 2007 14:58:18 -0700 Randy Dunlap wrote:
> 
> > On Wed, 18 Jul 2007 10:33:20 -0700 Randy Dunlap wrote:
> > 
> > > On Wed, 18 Jul 2007 12:29:24 +0300 Boaz Harrosh wrote:
> > > 
> > > > Randy Dunlap wrote:
> > > > > On Mon, 16 Jul 2007 12:22:20 +0300 Boaz Harrosh wrote:
> > > > > 
> > > > >> If you could do some testing it is grate. The first 3 patches do not
> > > > >> need scsi-misc specifically. Any post 2.6.20 tree will do. The last patch
> > > > >> could be done together with attached patch on any 2.6.22 tree.
> > > > >> (Apply attached patch anywhere before the last patch (4/4) of the patchset)
> > > > >> Though I do recommend scsi-misc tree.
> > > > > 
> > > > > I took 2.6.22, backed out Christoph's aha152x.c patch (using
> > > > > completion for timeouts), added your 5 patches, and then tested.
> > > > > Does that sound OK?
> > > > > 
> > > > Yes what you did is perfect
> > > > I was not aware of "Christoph's aha152x.c patch" is that in scsi-misc?
> > > > I'm almost positive I did a git-pull before I sent the patches.
> > > > Sorry about that.
> > > > 
> > > > >> Testing:
> > > > > 
> > > > > I booted/tested 4 times.  2 Oopsen and 2 of
> > > > > could-never-mount-the-device-due-to-reset-problems.
> > > > > Log is attached.
> > > > > 
> > > > > 
> > > > > ---
> > > > > ~Randy
> > > > > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > > > 
> > > > Thank you for testing and helping me with this.
> > > > 
> > > > I found one thing that should definitely trash the Reset
> > > > and do funny things. But I'm not sure it is it at all.
> > > > If below does not work, could you pleas do a small bisect
> > > > of my patches.
> > > > 
> > > > first patch first, than 2nd, 3rd ,accessors thing, and 4th 
> > > 
> > > Hi,
> > > 
> > > I don't see the reset problem after applying this patch, but I'm
> > > still seeing an Oops in datao_run.  Log is attached.
> 
> Looks to me like this driver doesn't handle highmem virtual addresses
> very well.  I expect that it would work OK if CONFIG_HIGHMEM=n or
> it had a slave_alloc function to limit the memory addresses that it
> sees (like ppa & imm do).  As it is on a machine with HIGHMEM=y,
> it gets sglist virtual addresses of 0, e.g.:

Confirmed that limiting the blk queue bounce limit to
BLK_BOUNCE_HIGH runs as expected (copy files, compare them successfully).

include/asm-i386/scatterlist.h talks about using pci_map_sg()
to get bus addresses from the scatterlist table.  However, this driver
knows nothing about PCI.  Should it use dma sg mapping instead?
or what is the desired fix here?

Thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

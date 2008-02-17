From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] scsi_debug: disable clustering
Date: Mon, 18 Feb 2008 00:11:45 +0900
Message-ID: <20080218001211R.tomof@acm.org>
References: <20080217142848.GD21012@parisc-linux.org>
	<20080217235244N.tomof@acm.org>
	<1203260534.3082.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:51966 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533AbYBQPL5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Feb 2008 10:11:57 -0500
In-Reply-To: <1203260534.3082.15.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: tomof@acm.org, matthew@wil.cx, dougg@torque.net, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, linux-ide@vger.kernel.org

On Sun, 17 Feb 2008 09:02:14 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> 
> On Sun, 2008-02-17 at 23:52 +0900, FUJITA Tomonori wrote:
> > On Sun, 17 Feb 2008 07:28:48 -0700
> > Matthew Wilcox <matthew@wil.cx> wrote:
> > 
> > > On Sun, Feb 17, 2008 at 08:18:11AM -0600, James Bottomley wrote:
> > > > No, he means that kmap_atomic can only map a page of data.  This makes
> > > > single page only sg list entries and input assumption into this loop.
> > > > with ENABLE_CLUSTERING, that's potentially not true.   Of course, this
> > > > accidentally works most of the time because of the way kmap functions.
> > > 
> > > Ah, right.  I'm on the verge of releasing a ram-based scsi driver I've
> > > been working on ... this loop should work fine with clustering as it
> > > takes account of the sg potentially having multiple pages:
> > > 
> > >         scsi_for_each_sg(cmnd, sg, scsi_sg_count(cmnd), i) {
> > >                 struct page *sgpage = sg_page(sg);
> > >                 unsigned int to_off = sg->offset;
> > >                 unsigned int sg_copy = sg->length;
> > >                 if (sg_copy > len)
> > >                         sg_copy = len;
> > >                 len -= sg_copy;
> > 
> > stex driver has a similar function to copies data between a buffer and
> > a scatter list. I think that scsi_kmap_atomic_sg is a bit primitive
> > (and not very popular).  I'll send a patch to add a helper function to
> > scsi_lib.c that copies data between a buffer and a scatter list. It
> > would be useful for several drivers.
> 
> Actually, if you're going to sweep up them all, libata also does this.

Thanks, I'll look at it.


> However, mapping and copying data isn't a SCSI specific function, it's
> one any virtual block driver should do, so I think block might be the
> correct location for such a function.

I see. It could go to lib/scatterlist.c or block/ I guess.

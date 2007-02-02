From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] Unable to handle kernel NULL pointer
 dereference...as_move_to_dispatch+0x11/0x135
Date: Fri, 2 Feb 2007 14:12:10 -0800
Message-ID: <20070202141210.948152a9.akpm@linux-foundation.org>
References: <20070122183510.GA19905@andrew-vasquezs-computer.local>
	<20070201232302.905962b6.akpm@linux-foundation.org>
	<20070202205630.GI3737@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42644 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946118AbXBBWMZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Feb 2007 17:12:25 -0500
In-Reply-To: <20070202205630.GI3737@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Nigel Kirkland <nigel.kirkland@qlogic.com>, Ken Chen <kenchen@google.com>

On Fri, 2 Feb 2007 12:56:30 -0800
Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:

> On Thu, 01 Feb 2007, Andrew Morton wrote:
> 
> > On Mon, 22 Jan 2007 10:35:10 -0800 Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:
> > > Basically what is happening from the FC side is the initiator executes
> > > a simple dt test:
> > > 
> > >         dt of=/dev/raw/raw1 procs=8 oncerr=abort bs=16k disable=stats limit=2m passes=1000000 pattern=iot dlimit=2048
> > > 
> > > against a single lun (a very basic Windows target mode driver).
> > > During the test a port-enable, port-disable script is running agains
> > > the switch's port that is connected to the target (this occurs every
> > > sixty seconds (for a disabled duration of 2 seconds).  Additionally,
> > > the target itself is set to LOGO (logout) or drop off the topology
> > > every 30 seconds.
> > 
> > I don't understand what effect the port-enable/port-disable has upon the
> > system.  Will it cause I/O errors, or what?
> 
> No I/O errors should make there way to the upper-layers (block/FS).
> The system *should* be shielded from the fibre-channel fabric events.
> I just wanted to explain what the (basic sanity) test did.
> 
> > > This test runs fine up to 2.6.19.
> > 
> > One thing we did in there was to give direct-io-against-blockdevs some
> > special-case bio-preparation code.  Perhaps this is tickling a bug somehow.
> > 
> > We can revert that change like this:
> > 
> > 
> > diff -puN fs/block_dev.c~a fs/block_dev.c
> > --- a/fs/block_dev.c~a
> > +++ a/fs/block_dev.c
> > @@ -196,8 +196,47 @@ static void blk_unget_page(struct page *
> >  	pvec->page[--pvec->idx] = page;
> >  }
> >  
> > +static int
> > +blkdev_get_blocks(struct inode *inode, sector_t iblock,
> > +		struct buffer_head *bh, int create)
> ...
> 
> Hmm, with this patch we've noted two main differences:
> 
> 1) I/O throughput with the basic 'dd' command used (above) is back to
>    60MB/s, rather than the appalling 20-22 MB/s we were seeing with
>    2.6.20-rcX.
> 
> 2) No panics -- so far with 2+ hours of testing.  With our vanilla
>    system of 2.6.20-rc7, the test could trigger the panic within 15 to
>    20 minutes.
> 
> We'll let this run over the weekend -- I'll certainly let you know if
> anything has changed (failures).

Oh crap, I didn't realise we had a performance regression as well.

direct-io against a blockdev is kinda important for some people, so this is
a must-fix for 2.6.20.  I'll prepare a minimal patch to switch 2.6.20 back
to the 2.6.19 codepaths.



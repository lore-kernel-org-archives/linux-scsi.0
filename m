From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: ST alloc failures
Date: Sat, 3 Apr 2004 10:19:51 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0404030958510.7955@kai.makisara.local>
References: <20040402051355.GA1604@frodo> <20040402073207.A31736@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep19-0.kolumbus.fi ([193.229.0.45]:37509 "EHLO
	fep19-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261619AbUDCHTz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Apr 2004 02:19:55 -0500
In-Reply-To: <20040402073207.A31736@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Nathan Scott <nathans@sgi.com>, linux-scsi@vger.kernel.org

On Fri, 2 Apr 2004, Christoph Hellwig wrote:

> [linux-scsi is the right list for st problems, moving the thread there]
> 
> On Fri, Apr 02, 2004 at 03:13:55PM +1000, Nathan Scott wrote:
> > Hi all,
> > 
> > I'm seeing a bunch of large allocation attempts failing from
> > the SCSI tape driver when doing dumps and restores ... (this
> > is with a stock 2.6.4 kernel).
> > 
> > xfsdump: page allocation failure. order:8, mode:0xd0
> > Call Trace:
> >  [<c013982b>] __alloc_pages+0x33b/0x3d0
> >  [<c03805ac>] enlarge_buffer+0xdc/0x1b0
> >  [<c03819a3>] st_map_user_pages+0x33/0x90
> >  [<c037cf24>] setup_buffering+0xb4/0x160
> 
> This looks like the driver tries to pin down the userpages first
> (st_map_user_pages) but then fails and needs to use an inkernel
> buffer.  Can you put some debug printks into st_map_user_pages
> to see why it fails?

Pinning down pages should not fail with most modern hardware except for 
the following three cases:

1) A change in 2.6.4 (*) mandates st (and sg) not to use direct transfers 
unless the user buffer is aligned at 512 byte boundary. This means, for 
instance, that in most cases transfers from/to malloced/calloced buffers 
are forced to use bounce buffers (alignment at 8 or 16 byte boundaries).

2) There is a bug in checking the allowed address range. Most SCSI 
adapters support 64-bit addresses and so even lots of memory should not 
prevent using direct transfers.

3) Some resource shortage that happened just now. This is not a bug.

> The actual message is harmless, it's the
> same thing we had in the XFS log code:  It tries to allocate
> an as large as possible buffer and if that fails tries the next
> smaller power of two size.  We should probably add an __GFP_NOWARN
> here.

Yes. st prints a message if the allocation finally fails.

(*) Some history for those who have not followed this development:

In 2.6.3, st (and sg) started checking the user buffer alignment with 
queue_dma_alignment(). The overall default is 512 bytes. A change was 
added to the scsi code to set the limit for SCSI devices to 8 bytes.

In 2.6.4, the code setting the SCSI device alignment to 8 bytes was, for 
some reason unknown to me, removed and this put the requirement to 512 
bytes.

The alignment requirement defaults can be set using many strategies. The 
current one is very safe. The low-level drivers (practically every 
driver in this case) can relax the constraints but this is not currently 
done. Another strategy (the 8-byte limit) sets the requirements safe for 
most devices. The exceptions can then enforce more strict limits.

-- 
Kai

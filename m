From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] REQ-flags to/from BIO-flags bugfix
Date: Thu, 13 Dec 2007 16:36:21 +1100
Message-ID: <20071213053621.GC4396912@sgi.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <47462F3C.3040700@googlemail.com> <20071122201250.f957e280.akpm@linux-foundation.org> <47466B5D.90607@googlemail.com> <20071126221509.8f437b61.akpm@linux-foundation.org> <1197390783.3812.19.camel@localhost.localdomain> <475FB316.6040804@panasas.com> <475FBFEE.9010009@panasas.com> <20071212151813.GJ26334@parisc-linux.org> <20071212155407.GK26334@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.171.30]:36101 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750821AbXLMFqF (ORCPT
	<rfc822;@relay.sgi.com:linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 00:46:05 -0500
Content-Disposition: inline
In-Reply-To: <20071212155407.GK26334@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

On Wed, Dec 12, 2007 at 08:54:07AM -0700, Matthew Wilcox wrote:
> On Wed, Dec 12, 2007 at 08:18:14AM -0700, Matthew Wilcox wrote:
> > I don't know whether BIO_RW_BARRIER is __REQ_SOFTBARRIER or
> > __REQ_HARDBARRIER, so I didn't include that in this patch.  There also
> > doesn't seem to be a __REQ equivalent to BIO_RW_AHEAD, but we can do
> > the other four bits (and leave gaps for those two).
> 
> Hm.  BIO_RW_AHEAD seems unused:
> 
> willy@honeydew:~/kernel/linux-2.6$ grep -r BIO_RW_AHEAD *
> block/blktrace.c:       (((rw) & (1 << BIO_RW_AHEAD)) << (2 - BIO_RW_AHEAD))
> include/linux/bio.h:#define BIO_RW_AHEAD        1
> include/linux/bio.h:#define bio_rw_ahead(bio)   ((bio)->bi_rw & (1 << BIO_RW_AHEAD))
> willy@honeydew:~/kernel/linux-2.6$ grep -r bio_rw_ahead *
> block/ll_rw_blk.c:      if (bio_rw_ahead(bio) || bio_failfast(bio))
> drivers/md/dm-mpath.c:  if ((error == -EWOULDBLOCK) && bio_rw_ahead(bio))
> drivers/md/multipath.c: else if (!bio_rw_ahead(bio)) {
> include/linux/bio.h:#define bio_rw_ahead(bio)   ((bio)->bi_rw & (1 << BIO_RW_AHEAD))

That would say to me that READA is not hooked up correctly. i.e:

#define READ 0
#define WRITE 1
#define READA 2         /* read-ahead  - don't block if no resources */
#define SWRITE 3        /* for ll_rw_block() - wait for buffer lock */
#define READ_SYNC       (READ | (1 << BIO_RW_SYNC))
#define READ_META       (READ | (1 << BIO_RW_META))
#define WRITE_SYNC      (WRITE | (1 << BIO_RW_SYNC))
#define WRITE_BARRIER   ((1 << BIO_RW) | (1 << BIO_RW_BARRIER))

i.e. it should be:

#define READA		(1 << BIO_RW_AHEAD)

Right?

FWIW, dm does this:

		if (bio_rw(bio) != READA)

Which really should be if (bio_rw_ahead(bio)).....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

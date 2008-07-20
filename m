From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
	blk_recalc_rq_segments about VMERGE
Date: Sun, 20 Jul 2008 12:33:31 -0500
Message-ID: <1216575211.4199.35.camel@localhost.localdomain>
References: <1216520228.3376.33.camel@localhost.localdomain>
	 <20080719.210737.197246608.davem@davemloft.net>
	 <1216565545.4199.10.camel@localhost.localdomain>
	 <20080720.102302.137955996.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <20080720.102302.137955996.davem@davemloft.net>
Sender: linux-parisc-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: mpatocka@redhat.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2008-07-20 at 10:23 -0700, David Miller wrote:
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Sun, 20 Jul 2008 09:52:25 -0500
> 
> > Since we're using it successfully in parisc, I don't want the block code
> > removed, but I don't see a reason to force other architectures to use
> > it.
> > 
> > However, it has two use cases.  One is the legacy one of making rather
> > dumb I/O cards perform better (which is the primary on on parisc), but
> > there is a current one making huge transfers go through SCSI using using
> > the sg_table code.  That latter is pretty vital to me since I have to
> > keep the code working, but I don't really have any SCSI cards that can
> > take advantage of it without virtual merging.  As a slight irony, IBM is
> > trying to persuade me that a ppc would be better than a parisc for big
> > endian I/O testing ... so I might just be seeing if I can make virtual
> > merging work on power too.
> 
> All of this is gibberish, we've been over this a few times already
> in this thread.

Really? I must have missed the proposed replacement for the
functionality that we're using then.

> For a dumb I/O card, you advertise SG_ALL capabilities, the IOMMU
> is going to merge things as it would have anyways, and you have
> code in the driver to advance SG entries after each "dumb I/O".

Not that dumb ... they just have a limited number of SG slots.  We
wouldn't want to run them as spoon fed PIO because that really would
kill performance.

> There is zero value to the vmerge code, the real gains are being
> realized already.

There is value to me in my testbed, which I can't achieve any other way
(except by buying different SCSI cards).

As I said, you can compile it out on sparc just fine.  I wish to keep it
running for parisc, so I'll maintain it.  If it ever bit rots out of
parisc like it has done for the other architectures, then feel free to
remove it.

James



From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
	blk_recalc_rq_segments about VMERGE
Date: Sun, 20 Jul 2008 09:52:25 -0500
Message-ID: <1216565545.4199.10.camel@localhost.localdomain>
References: <20080719.002826.73806419.davem@davemloft.net>
	 <Pine.LNX.4.64.0807192141500.13523@devserv.devel.redhat.com>
	 <1216520228.3376.33.camel@localhost.localdomain>
	 <20080719.210737.197246608.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <20080719.210737.197246608.davem@davemloft.net>
Sender: linux-parisc-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: mpatocka@redhat.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2008-07-19 at 21:07 -0700, David Miller wrote:
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Sat, 19 Jul 2008 21:17:08 -0500
> 
> > Try this patch
> 
> I'd rather remove the vmerge code, it doesn't buy us
> anything, and for something so complex and so hard to
> keep working correctly it's existence is far from
> justified these days.

You can ... as soon as BIO_VMERGE_BOUNDARY is undefined or set to zero,
it gets compiled out of the block code. 

Since we're using it successfully in parisc, I don't want the block code
removed, but I don't see a reason to force other architectures to use
it.

However, it has two use cases.  One is the legacy one of making rather
dumb I/O cards perform better (which is the primary on on parisc), but
there is a current one making huge transfers go through SCSI using using
the sg_table code.  That latter is pretty vital to me since I have to
keep the code working, but I don't really have any SCSI cards that can
take advantage of it without virtual merging.  As a slight irony, IBM is
trying to persuade me that a ppc would be better than a parisc for big
endian I/O testing ... so I might just be seeing if I can make virtual
merging work on power too.

James



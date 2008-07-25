From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
 blk_recalc_rq_segments about VMERGE
Date: Fri, 25 Jul 2008 11:26:27 +0900
Message-ID: <20080725112711H.fujita.tomonori@lab.ntt.co.jp>
References: <Pine.LNX.4.64.0807241232040.9412@devserv.devel.redhat.com>
	<1216918371.4524.38.camel@localhost.localdomain>
	<Pine.LNX.4.64.0807241727320.12036@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0807241727320.12036@devserv.devel.redhat.com>
Sender: linux-parisc-owner@vger.kernel.org
To: mpatocka@redhat.com
Cc: James.Bottomley@HansenPartnership.com, davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 24 Jul 2008 17:49:14 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> On Thu, 24 Jul 2008, James Bottomley wrote:
> 
> > On Thu, 2008-07-24 at 12:34 -0400, Mikulas Patocka wrote:
> > > On Thu, 24 Jul 2008, James Bottomley wrote:
> > > 
> > > > On Thu, 2008-07-24 at 11:07 -0400, Mikulas Patocka wrote:
> > > > > So try to #define BIO_VMERGE_BOUNDARY 0 for Pa-Risc and tell us what 
> > > > > performance degradation do you see (and what driver do you use and what is 
> > > > > the I/O pattern).
> > > > > 
> > > > > If you show something specific, we can consider that --- but you haven't 
> > > > > yet told us anything, except generic talk.
> > > > 
> > > > You keep ignoring inconvenient facts.  For about the third time:
> > > > 
> > > > I run a test bed for sg_tables (large chaining of requests).  This runs
> > > > on parisc using virtual merging (has to because the final physical table
> > > > size can't go over the sg list of the SCSI card).  If I turn off virtual
> > > > merging I can no longer test sg_tables in vanilla kernels.
> > > > 
> > > > James
> > > 
> > > What sg_tables test do you mean? What does the test do? Why couldn't you 
> > > run the test if BIO_VMERGE_BOUNDARY is 0? Normal I/O obviously can work 
> > > with BIO_VMERGE_BOUNDARY 0, the kernel will just send more smaller 
> > 
> > Look, if you don't really understand what I'm doing, it's not really my
> > job to educate you.  The sg_table discussions are on marc.info, mainly
> > on the SCSI lists; just look for 'sg chaining' in the header (need to
> > use google site ... marc's search is bad).
> > 
> > You can complain if the code is impacting you ... but I believe I've
> > optimised it so it isn't.  Your basic problem amounts to you not liking
> > me doing something that has no impact on you ... I'm afraid that's what
> > freedom leads to (shocking, I know).
> > 
> > James
> 
> Chaining of sg_tables is used for drivers with big sg tables --- and 
> vmerge counting is used for drivers with small sg tables. So what do they 
> have in common?

VMERGE enables you to handle a large request even with drivers with
small sg tables.


> Summary, what I mean:
> 
> * in blk-merge.c, you have 85 lines, that is 16% of the size of the file, 
> devoted to counting of hw_segments
> 
> * it is only used on two architectures, one already outdated (alpha), the 
> other being discontinued (pa-risc). On all the other architectures, 
> hw_segments == phys_segments

BTW, alpha IOMMU can't handle VMERGE. But the IOMMU has the code to
handle VMERGE so one-line patch can fix the IOMMU.


As I said before, can we leave this to Jens, keeping or removing
VMERGE? Seems that I see the same arguments again and again.

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
	blk_recalc_rq_segments about VMERGE
Date: Sat, 19 Jul 2008 21:17:08 -0500
Message-ID: <1216520228.3376.33.camel@localhost.localdomain>
References: <20080717131444K.fujita.tomonori@lab.ntt.co.jp>
	 <Pine.LNX.4.64.0807170746001.31185@devserv.devel.redhat.com>
	 <20080717221908D.fujita.tomonori@lab.ntt.co.jp>
	 <20080719.002826.73806419.davem@davemloft.net>
	 <Pine.LNX.4.64.0807192141500.13523@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0807192141500.13523@devserv.devel.redhat.com>
Sender: linux-parisc-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2008-07-19 at 21:45 -0400, Mikulas Patocka wrote:
> On Sat, 19 Jul 2008, David Miller wrote:
> 
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Date: Thu, 17 Jul 2008 22:18:44 +0900
> > 
> > > BTW, as I've already said, I'm not against removing the vmerge
> > > accounting from the block layer.
> > 
> > I am also, as stated, not against this.
> > 
> > Fujita-san, please proposage a patch so that we can put this
> > issue behind us :-)
> 
> Few days ago I created this.
> 
> Another task would be to remove nr_hw_segments from request, bio and queue 
> parameters (if this patch is accepted).

I think we've already established that the code in question is correct
and functional, 

As far as I can tell, virtual merging has always been broken on ppc, so
it shouldn't enable it.  It looks like at some point in history sparc
went from a working vmerge to a non working one (by copying the broken
ppc code), so the correct fix for both of these arches is simply to turn
off virtual merging.

ppc claims to turn off virtual merging, but in fact the define is
broken.  Sparc should now follow ppc.

Try this patch

James

---

diff --git a/include/asm-powerpc/io.h b/include/asm-powerpc/io.h
index 8b62782..0f3212c 100644
--- a/include/asm-powerpc/io.h
+++ b/include/asm-powerpc/io.h
@@ -715,7 +715,7 @@ static inline void * phys_to_virt(unsigned long address)
  * to coalesce sglists that happen to have been mapped in a contiguous
  * way by the iommu
  */
-#define BIO_VMERGE_BOUNDARY	0
+#undef BIO_VMERGE_BOUNDARY
 
 /*
  * 32 bits still uses virt_to_bus() for it's implementation of DMA
diff --git a/include/asm-sparc64/io.h b/include/asm-sparc64/io.h
index 3158960..1da5642 100644
--- a/include/asm-sparc64/io.h
+++ b/include/asm-sparc64/io.h
@@ -16,7 +16,9 @@
 /* BIO layer definitions. */
 extern unsigned long kern_base, kern_size;
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
-#define BIO_VMERGE_BOUNDARY	8192
+
+/* virtual merging doesn't work on sparc now */
+#undef BIO_VMERGE_BOUNDARY
 
 static inline u8 _inb(unsigned long addr)
 {



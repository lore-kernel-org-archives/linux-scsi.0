From: Badari Pulavarty <badari@us.ibm.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Wed, 30 Oct 2002 11:31:57 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210301931.g9UJVvC02347@eng2.beaverton.ibm.com>
References: <20021030181627.GV3416@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021030181627.GV3416@suse.de> from "Jens Axboe" at Oct 30, 2002 06:16:27 PM PST
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Badari Pulavarty <badari@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Badari Pulavarty <pbadari@us.ibm.com>, Andrew Morton <akpm@digeo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, merlin@merlin.org

> 
> On Wed, Oct 30 2002, Badari Pulavarty wrote:
> > Hi,
> > 
> > I still get panics while doing filesystem IO on -mm kernels (with
> > qlogic fc). I get following msgs before getting the panic:
> > 
> > Incorrect number of segments after building list
> > counted 3, received 2
> > req nr_sec 256, cur_nr_sec 8
> > 
	....
> > 
> > What does BIOVEC_VIRT_MERGEABLE() supposed to do ? I am guessing
> > it is supposed to restrict IO crossing 4GB boundary. Is it correct ?
> 
> It's only for platforms with iommu that can do funky remapping tricks
> for pages ending on certain boundaries. I'm sure davem or anton can tell
> you more about this for sparc64 or ppc64. For x86, it will always be
> true. Hmm, looking at it, I can't convince myself that it is right.
> Davem, could you please check up on this? I'll be back later tonight to
> review it as well. Things are not consistent, I agree on that.
> 
> Good debugging, btw!
> 
> -- 
> Jens Axboe

How about the following patch ?

- Badari

--- linux/include/linux/bio.h	Wed Oct 30 10:32:52 2002
+++ linux.new/include/linux/bio.h	Wed Oct 30 10:35:06 2002
@@ -160,7 +160,7 @@
 #define BIOVEC_PHYS_MERGEABLE(vec1, vec2)	\
 	((bvec_to_phys((vec1)) + (vec1)->bv_len) == bvec_to_phys((vec2)))
 #define BIOVEC_VIRT_MERGEABLE(vec1, vec2)	\
-	((((bvec_to_phys((vec1)) + (vec1)->bv_len) | bvec_to_phys((vec2))) & (BIO_VMERGE_BOUNDARY - 1)) == 0)
+	(((bvec_to_phys((vec1)) + (vec1)->bv_len) | (BIO_VMERGE_BOUNDARY - 1)) == (bvec_to_phys((vec2)) | (BIO_VMERGE_BOUNDARY - 1)))
 #define __BIO_SEG_BOUNDARY(addr1, addr2, mask) \
 	(((addr1) | (mask)) == (((addr2) - 1) | (mask)))
 #define BIOVEC_SEG_BOUNDARY(q, b1, b2) \

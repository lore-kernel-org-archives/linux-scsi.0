From: Badari Pulavarty <badari@us.ibm.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Wed, 30 Oct 2002 14:03:20 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210302203.g9UM3KO05630@eng2.beaverton.ibm.com>
References: <20021030.123519.25407274.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021030.123519.25407274.davem@redhat.com> from "David S. Miller" at Oct 30, 2002 11:35:19 AM PST
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@redhat.com>
Cc: axboe@suse.de, badari@us.ibm.com, James.Bottomley@steeleye.com, pbadari@us.ibm.com, akpm@digeo.com, linux-scsi@vger.kernel.org, Martin.Bligh@us.ibm.com, dledford@redhat.com

> 
>    From: Jens Axboe <axboe@suse.de>
>    Date: Wed, 30 Oct 2002 19:16:27 +0100
> 
>    On Wed, Oct 30 2002, Badari Pulavarty wrote:
>    > What does BIOVEC_VIRT_MERGEABLE() supposed to do ? I am guessing
>    > it is supposed to restrict IO crossing 4GB boundary. Is it correct ?
>    
>    It's only for platforms with iommu that can do funky remapping tricks
>    for pages ending on certain boundaries. I'm sure davem or anton can tell
>    you more about this for sparc64 or ppc64. For x86, it will always be
>    true. Hmm, looking at it, I can't convince myself that it is right.
>    Davem, could you please check up on this? I'll be back later tonight to
>    review it as well. Things are not consistent, I agree on that.
> 
> This whole report sounds like ppc64 is setting BIO_VMERGE_BOUNDARY
> incorrectly.
> 
> If the IOMMU code on ppc64 is not going to merge physical scatterlist
> segments which begin/end on a page boundry into a single DMA addr/len
> pair, then this port should not be setting BIO_VMERGE_BOUNDARY
> non-zero.
> 
> Else, if ppc64's IOMMU code will merge such pages, BIO_VMERGE_BOUNDARY
> must be defined to the page size used by the IOMMU.
> 
> I notice now that the BIO_VMERGE_BOUNDARY define is "#if 0" protected
> on ppc64.  It absolutely must be in sync with how the IOMMU code on
> the platform behaves.  So some ppc64 expert needs to comment :)

Dave,

We are also talking about the correctness of the macro BIOVEC_VIRT_MERGEABLE().
I don't think it is doing the right thing.  (For x86, it is returning always false).

#define BIOVEC_VIRT_MERGEABLE(vec1, vec2)       \
        ((((bvec_to_phys((vec1)) + (vec1)->bv_len) | bvec_to_phys((vec2))) & (BIO_VMERGE_BOUNDARY - 1)) == 0)

I think it should me more like ..

#define BIOVEC_VIRT_MERGEABLE(vec1, vec2)       \
        (((bvec_to_phys((vec1)) + (vec1)->bv_len) | (BIO_VMERGE_BOUNDARY - 1)) == (bvec_to_phys((vec2)) | (BIO_VMERGE_BOUNDARY - 1)))

Do you agree ?

- Badari

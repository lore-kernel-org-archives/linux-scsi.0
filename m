From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC][PATCH] Direct I/O for the SCSI tapes
Date: Sun, 28 Jul 2002 00:39:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D437590.8D69B132@torque.net>
References: <Pine.LNX.4.44.0207271530500.1090-100000@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, ingo.oeser@informatik.tu-chemnitz.de

Kai Makisara wrote:
> 
> The URL http://www.kolumbus.fi/kai.makisara/st-dio.html contains
> explanation and a link to a patch implementing direct I/O in the SCSI tape
> driver (st). Before adding this to the official kernel, I would like to
> get some feedback on this patch. If no one is interested in this
> enhancement and/or it seems to be useless, it will probably be left to
> collect dust.

Kai,
Faster throughput and less CPU overhead seem pretty good reasons
to use direct IO. With larger disk sizes, faster tape transfer speeds 
are needed to backup them up in a reasonable time. So I hope your
patch doesn't collect dust. Also most high speed application that
use sg are _streaming_ to disks [I have one report of > 320 MB/sec].
Perhaps people may one day use a purpose built command set for
streaming like SSC rather than SBC (as used by direct access devices).

It was interesting to see that your patch used variants of Ingo Oeser's 
sg_map_user_pages() [see Kai's version shown below] **. My interest in 
those functions is that I would like to use them in sg (since kiobufs 
have been removed from lk 2.5). According to Ingo several other char
drivers that previously used kiobufs are probably looking for
replacements as well.

Since they are general routines of use to char drivers that
build scatter gather lists (block drivers have bio) perhaps they 
should be placed in some common area.

Doug Gilbert

** lkml 2002-07-19 22:39:18 Ingo Oeser "Re: [never mind] kiobufs and highmem"


Kai's st_map_user_pages() and st_unmap_user_pages() follow:
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

static int st_map_user_pages(struct scatterlist *sgl, const unsigned int max_pages,
                            unsigned long uaddr, size_t count, int rw,
                            unsigned long max_pfn)
{
       int res, i, j;
       unsigned int nr_pages;
       struct page **pages;

       nr_pages = ((uaddr & ~PAGE_MASK) + count - 1 + ~PAGE_MASK) >> PAGE_SHIFT;

       /* User attempted Overflow! */
       if ((uaddr + count) < uaddr)
               return -EINVAL;

       /* Too big */
        if (nr_pages > max_pages)
               return -ENOMEM;

       /* Hmm? */
       if (count == 0)
               return 0;

       if ((pages = kmalloc(max_pages * sizeof(*pages), GFP_ATOMIC)) == NULL)
               return -ENOMEM;

        /* Try to fault in all of the necessary pages */
       down_read(&current->mm->mmap_sem);
        /* rw==READ means read from drive, write into memory area */
       res = get_user_pages(
               current,
               current->mm,
               uaddr,
               nr_pages,
               rw == READ,
               0, /* don't force */
               pages,
               NULL);
       up_read(&current->mm->mmap_sem);

       /* Errors and no page mapped should return here */
       if (res < nr_pages)
               goto out_unmap;

        for (i=0; i < nr_pages; i++) {
                /* FIXME: flush superflous for rw==READ,                 
		 * probably wrong function for rw==WRITE
                 */
               flush_dcache_page(pages[i]);
               if (page_to_pfn(pages[i]) > max_pfn)
                       goto out_unlock;
               /* ?? Is locking needed? I don't think so */
               /* if (TestSetPageLocked(pages[i]))
                  goto out_unlock; */
        }

       /* Populate the scatter/gather list */
       sgl[0].page = pages[0];
       sgl[0].offset = uaddr & ~PAGE_MASK;
       if (nr_pages > 1) {
               sgl[0].length = PAGE_SIZE - sgl[0].offset;
               count -= sgl[0].length;
               for (i=1; i < nr_pages ; i++) {
                       sgl[i].offset = 0;
                       sgl[i].page = pages[i];
                       sgl[i].length = count < PAGE_SIZE ? count : PAGE_SIZE;
                       count -= PAGE_SIZE;
               }
       }
       else {
               sgl[0].length = count;
       }

       kfree(pages);
       return nr_pages;

 out_unlock:
       /* for (j=0; j < i; j++)
          unlock_page(pages[j]); */
       res = 0;
 out_unmap:
       if (res > 0)
               for (j=0; j < res; j++)
                       page_cache_release(pages[j]);
       kfree(pages);
       return res;
}

/* And unmap them... */
static int st_unmap_user_pages(struct scatterlist *sgl, const unsigned int nr_pages,
                              int dirtied)
{
       int i;

       for (i=0; i < nr_pages; i++) {
               if (dirtied && !PageReserved(sgl[i].page))
                       SetPageDirty(sgl[i].page);
               /* unlock_page(sgl[i].page); */
               /* FIXME: cache flush missing for rw==READ
                * FIXME: call the correct reference counting function
                */
               page_cache_release(sgl[i].page);
       }

       return 0;
}

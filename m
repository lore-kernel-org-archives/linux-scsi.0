From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: 2.6.20-rc6-mm1
Date: Tue, 30 Jan 2007 20:50:10 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0701302045290.3202@hermes-1.csi.cam.ac.uk>
References: <20070127234928.64d8e437.akpm@osdl.org> <45BC7A26.1080303@gmail.com>
 <20070129232727.96e580ac.akpm@osdl.org> <20070130113055.431ad91a.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751448AbXA3UuV@vger.kernel.org>
In-Reply-To: <20070130113055.431ad91a.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Miles Lane <miles.lane@gmail.com>, Pierre Ossman <drzeus@drzeus.cx>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Hi Andrew,

Looks good for NTFS thanks!  The only thing is that I think we 
already have a variable "unsigned long flags" in the function 
ntfs_end_buffer_async_read() so that could be used instead of 
redefining it more locally in the if statements.

Could you send the patch to Linus?

Feel free to add my Acked-by or Signed-off-by "Anton Altaparmakov 
<aia21@cantab.net> line if you wish (I am not bothered either way)...

Thanks a lot for fixing it!

Best regards,

	Anton

On Tue, 30 Jan 2007, Andrew Morton wrote:

> On Mon, 29 Jan 2007 23:27:27 -0800
> Andrew Morton <akpm@osdl.org> wrote:
> 
> > On Sun, 28 Jan 2007 11:25:42 +0100
> > Jiri Slaby <jirislaby@gmail.com> wrote:
> > 
> > > Andrew Morton napsal(a):
> > > > Temporarily at
> > > > 
> > > > 	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm1/
> > > 
> > > I'm still seeing this during bootup:
> > > BUG: at /home/l/latest/xxx/arch/i386/mm/highmem.c:52 kmap_atomic()
> > >   [<c0104ffb>] show_trace_log_lvl+0x1a/0x30
> > >   [<c01056b5>] show_trace+0x12/0x14
> > >   [<c010573c>] dump_stack+0x16/0x18
> > >   [<c011b24f>] kmap_atomic+0x16c/0x20e
> > >   [<c01b279e>] ntfs_end_buffer_async_read+0x18e/0x2ed
> > >   [<c0183352>] end_bio_bh_io_sync+0x26/0x3f
> > >   [<c0184dd4>] bio_endio+0x37/0x62
> > >   [<c01cda43>] __end_that_request_first+0x224/0x444
> > >   [<c01cdc6b>] end_that_request_chunk+0x8/0xa
> > >   [<c024507d>] scsi_end_request+0x1f/0xc7
> > >   [<c02451e6>] scsi_io_completion+0x7b/0x33a
> > >   [<c024aa5d>] sd_rw_intr+0x23/0x1ab
> > >   [<c02415ed>] scsi_finish_command+0x42/0x47
> > >   [<c0245a38>] scsi_softirq_done+0x64/0xcf
> > >   [<c01cf9e6>] blk_done_softirq+0x54/0x62
> > >   [<c0127bc5>] __do_softirq+0x75/0xde
> > >   [<c0127c69>] do_softirq+0x3b/0x3d
> > >   [<c0127ee6>] irq_exit+0x3b/0x3d
> > >   [<c0106804>] do_IRQ+0x51/0x8d
> > >   [<c0104a5f>] common_interrupt+0x23/0x28
> > >   [<c010241a>] cpu_idle+0x80/0xc3
> > >   [<c010140d>] rest_init+0x23/0x36
> > >   [<c045ea59>] start_kernel+0x3a5/0x43c
> > >   [<00000000>] 0x0
> > >   =======================
> > > 
> > > I.e. KM_BIO_SRC_IRQ through softirq path.
> > > 
> > 
> > argh.
> > 
> > ntfs_end_buffer_async_read() doesn't know whether it will be called from
> > hardirq or from softirq context: it depends upon the underlying driver.
> > 
> > In this case, if the CPU running ntfs_end_buffer_async_read() is
> > interrupted by IO completion against a different disk controller and that
> > completion handler uses KM_BIO_SRC_IRQ (as it is allowed to do), it will
> > trash ntfs_end_buffer_async_read()'s atomic kmap and unpleasing things will
> > ensue.
> > 
> > I guess a suitable fix here is to protect that kmap with
> > local_irq_save/restore.
> > 
> > I wonder where else we have that bug?
> 
> Actually, this isn't related to softirq-vs-hardirq.  Most interrupt
> handlers are interruptible, so the rule is simply that KM_BIO_SRC_IRQ must
> always be taken under local_irq_disable().
> 
> A quick scan indicates that the following files might be buggy in this
> regard:
> 
> drivers/mmc/wbsd.c
> drivers/mmc/at91_mci.c
> drivers/mmc/sdhci.c
> drivers/scsi/scsi_lib.c when called from stex.c
> fs/ntfs/aops.c
> 
> Happily, KM_BIO_DST_IRQ has no users and can presumably be removed.
> 
> 
> Fixes for stex and ntfs follow.
> 
> 
> From: Andrew Morton <akpm@osdl.org>
> 
> The KM_BIO_SRC_IRQ kmap slot requires local irq protection.
> 
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Cc: Ed Lin <ed.lin@promise.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
> 
>  drivers/scsi/stex.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff -puN drivers/scsi/stex.c~stex-kmap_atomic-atomicity-fix drivers/scsi/stex.c
> --- a/drivers/scsi/stex.c~stex-kmap_atomic-atomicity-fix
> +++ a/drivers/scsi/stex.c
> @@ -459,15 +459,19 @@ static void stex_internal_copy(struct sc
>  		*count = cmd->request_bufflen;
>  	lcount = *count;
>  	while (lcount) {
> +		unsigned long flags = flags;	/* Suppress uninit warning */
> +
>  		len = lcount;
>  		s = (void *)src;
>  		if (cmd->use_sg) {
>  			size_t offset = *count - lcount;
>  			s += offset;
> +			local_irq_save(flags);
>  			base = scsi_kmap_atomic_sg(cmd->request_buffer,
>  				sg_count, &offset, &len);
>  			if (base == NULL) {
>  				*count -= lcount;
> +				local_irq_restore(flags);
>  				return;
>  			}
>  			d = base + offset;
> @@ -480,8 +484,10 @@ static void stex_internal_copy(struct sc
>  			memcpy(s, d, len);
>  
>  		lcount -= len;
> -		if (cmd->use_sg)
> +		if (cmd->use_sg) {
>  			scsi_kunmap_atomic_sg(base);
> +			local_irq_restore(flags);
> +		}
>  	}
>  }
>  
> _
> 
> 
> 
> From: Andrew Morton <akpm@osdl.org>
> 
> The KM_BIO_SRC_IRQ kmap slot requires local irq protection.
> 
> Cc: Anton Altaparmakov <aia21@cantab.net>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
> 
>  fs/ntfs/aops.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff -puN fs/ntfs/aops.c~ntfs-kmap_atomic-atomicity-fix fs/ntfs/aops.c
> --- a/fs/ntfs/aops.c~ntfs-kmap_atomic-atomicity-fix
> +++ a/fs/ntfs/aops.c
> @@ -88,14 +88,17 @@ static void ntfs_end_buffer_async_read(s
>  		if (unlikely(file_ofs + bh->b_size > init_size)) {
>  			u8 *kaddr;
>  			int ofs;
> +			unsigned long flags;
>  
>  			ofs = 0;
>  			if (file_ofs < init_size)
>  				ofs = init_size - file_ofs;
> +			local_irq_save(flags);
>  			kaddr = kmap_atomic(page, KM_BIO_SRC_IRQ);
>  			memset(kaddr + bh_offset(bh) + ofs, 0,
>  					bh->b_size - ofs);
>  			kunmap_atomic(kaddr, KM_BIO_SRC_IRQ);
> +			local_irq_restore(flags);
>  			flush_dcache_page(page);
>  		}
>  	} else {
> @@ -138,16 +141,19 @@ static void ntfs_end_buffer_async_read(s
>  		u8 *kaddr;
>  		unsigned int i, recs;
>  		u32 rec_size;
> +		unsigned long flags;
>  
>  		rec_size = ni->itype.index.block_size;
>  		recs = PAGE_CACHE_SIZE / rec_size;
>  		/* Should have been verified before we got here... */
>  		BUG_ON(!recs);
> +		local_irq_save(flags);
>  		kaddr = kmap_atomic(page, KM_BIO_SRC_IRQ);
>  		for (i = 0; i < recs; i++)
>  			post_read_mst_fixup((NTFS_RECORD*)(kaddr +
>  					i * rec_size), rec_size);
>  		kunmap_atomic(kaddr, KM_BIO_SRC_IRQ);
> +		local_irq_restore(flags);
>  		flush_dcache_page(page);
>  		if (likely(page_uptodate && !PageError(page)))
>  			SetPageUptodate(page);
> _
> 
> 

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

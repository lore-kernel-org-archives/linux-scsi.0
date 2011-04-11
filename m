From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Date: Mon, 11 Apr 2011 12:42:29 -0400
Message-ID: <20110411124229.47bc28f6@corrin.poochiereds.net>
References: <20110224182732.GV27190@tux1.beaverton.ibm.com>
	<1298897186-sup-9394@think>
	<20110304210724.GF27190@tux1.beaverton.ibm.com>
	<20110308045626.GD1956@dastard>
	<20110319000755.GD1110@tux1.beaverton.ibm.com>
	<20110321140451.GA7153@quack.suse.cz>
	<1300716666-sup-2087@think>
	<20110321164305.GC7153@quack.suse.cz>
	<20110406232938.GF1110@tux1.beaverton.ibm.com>
	<20110407165700.GB7363@quack.suse.cz>
	<20110408203135.GH1110@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab1DKRkR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2011 13:40:17 -0400
In-Reply-To: <20110408203135.GH1110@tux1.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com
Cc: Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 8 Apr 2011 13:31:35 -0700
"Darrick J. Wong" <djwong@us.ibm.com> wrote:

> On Thu, Apr 07, 2011 at 06:57:00PM +0200, Jan Kara wrote:
> > On Wed 06-04-11 16:29:38, Darrick J. Wong wrote:
> > > On Mon, Mar 21, 2011 at 05:43:05PM +0100, Jan Kara wrote:
> > > > On Mon 21-03-11 10:24:41, Chris Mason wrote:
> > > > > Excerpts from Jan Kara's message of 2011-03-21 10:04:51 -0400:
> > > > > > On Fri 18-03-11 17:07:55, Darrick J. Wong wrote:
> > > > > > > > > Ok, here's what I have so far.  I took everyone's suggestions of where to add
> > > > > > > > > calls to wait_on_page_writeback, which seems to handle the multiple-write case
> > > > > > > > > adequately.  Unfortunately, it is still possible to generate checksum errors by
> > > > > > > > > scribbling furiously on a mmap'd region, even after adding the writeback wait
> > > > > > > > > in the ext4 writepage function.  Oddly, I couldn't break btrfs with mmap by
> > > > > > > > > removing its wait_for_page_writeback call, so I suspect there's a bit more
> > > > > > > > > going on in btrfs than I've been able to figure out.
> > > > > > > 
> > > > > > > I wonder, is it possible for this to happen:
> > > > > > > 
> > > > > > > 1. Thread A mmaps a page and tries to write to it.  ext4_page_mkwrite executes,
> > > > > > >    but there's no ongoing writeback, so it returns without delay.
> > > > > > > 2. Thread A starts writing furiously to the page.
> > > > > > > 3. Thread B runs fsync() or something that results in the page being
> > > > > > >    checksummed and scheduled for writeout.
> > > > > > > 4. Thread A continues to write furiously(!) on that same page before the
> > > > > > >    controller finishes the DMA transfer.
> > > > > > > 5. Disk gets the page, which now doesn't match its checksum, and *boom*
> > > > > >   What happens on writepage (see mm/page-writeback.c:write_cache_pages())
> > > > > > is:
> > > > > >   lock_page(page)
> > > > > >   ...
> > > > > >   clear_page_dirty_for_io() - removes PageDirty, marks page as read-only in
> > > > > >     PTE
> > > > > >   ...
> > > > > >   set_page_writeback() (happens e.g. in __block_write_full_page() called
> > > > > > from filesystem's writepage implementation).
> > > > > >   unlock_page(page)
> > > > > > 
> > > > > >   So if you compute the checksum after set_page_writeback() is done in the
> > > > > > writepage() implementation (you cannot use __block_write_full_page() in
> > > > > > that case)
> > > >   I should add that if you are computing the checksum in the block layer
> > > > once the bio is submitted, you obviously are computing it after the page is
> > > > marked as writeback. So that should be fine...
> > > > 
> > > > > > and you call wait_on_page_writeback() in ext4_page_mkwrite()
> > > > > > under page lock, you should be safe. If you do all this and still see
> > > > > > errors, something is broken I'd say...
> > > > > 
> > > > > Looking at the ext4_page_mkwrite, it does this:
> > > > > 
> > > > > lock the page
> > > > > check for holes
> > > > > unlock the page
> > > > > if (no_holes)
> > > > > 	return;
> > > > > 
> > > > > write_begin/write_end
> > > > > return
> > > > > 
> > > > > So, to have page_mkwrite work, you need to wait for writeback with the
> > > > > page locked in both the no holes case and after the
> > > > > write_begin/write_end.  write_begin will dirty the page, so someone can
> > > > > wander in and start the IO while we are still in page_mkwrite.
> > > >   Oh right, that's a good point.
> > > > 
> > > > > This is untested and uncompiled, but it should
> > > > > do the trick.
> > > > > 
> > > > > Jan, did you get rid of all the buffer head based writeback for
> > > > > data=ordered in ext4?  That's my only other idea, that someone is doing
> > > > > writeback directly without taking the page lock.
> > > >   Yes, ext4 shouldn't do any buffer based writeback.
> > > > 
> > > > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > > > index 9f7f9e4..8a75e12 100644
> > > > > --- a/fs/ext4/inode.c
> > > > > +++ b/fs/ext4/inode.c
> > > > > @@ -5880,6 +5880,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> > > > >  	if (page_has_buffers(page)) {
> > > > >  		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
> > > > >  					ext4_bh_unmapped)) {
> > > > > +			wait_on_page_writeback(page);
> > > > >  			unlock_page(page);
> > > > >  			goto out_unlock;
> > > > >  		}
> > > > > @@ -5901,6 +5902,16 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> > > > >  	if (ret < 0)
> > > > >  		goto out_unlock;
> > > > >  	ret = 0;
> > > > > +
> > > > > +	/*
> > > > > +	 * write_begin/end might have created a dirty page and someone
> > > > > +	 * could wander in and start the IO.  Make sure that hasn't
> > > > > +	 * happened
> > > > > +	 */
> > > > > +	lock_page(page);
> > > > > +	wait_on_page_writeback(page);
> > > > > +	unlock_page(page);
> > > > > +
> > > > >  out_unlock:
> > > > >  	if (ret)
> > > > >  		ret = VM_FAULT_SIGBUS;
> > > > > 
> > > >   This looks good AFAICT.
> > > 
> > > I gave this a spin a couple of weeks ago (and accidentally left the test
> > > machines running for a full week!)  From what I can tell, with all the various
> > > wait_for_page_writeback stuff-ins, we've cut the frequency of writeback errors
> > > down to about 7-8 per day.  Not bad, but not fixed.
> >   Ugh, strange. Can you post the full patch you are currently using? I've
> > already lost track of all the proposed changes... Thanks.
> 
> Yes, me too.  Attached is the giant patch I've been working on.
> 
> --D
> 
> fs: Wait for page writeback when rewrite detected, and mark pages ro during writeback
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> diff --git a/fs/buffer.c b/fs/buffer.c
> index a08bb8e..dd429fe 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2357,6 +2357,8 @@ block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	else
>  		end = PAGE_CACHE_SIZE;
>  
> +	WARN_ON(!PageLocked(page));
> +	wait_on_page_writeback(page);
>  	ret = __block_write_begin(page, 0, end, get_block);
>  	if (!ret)
>  		ret = block_commit_write(page, 0, end);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 1a86282..57cd028 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2666,6 +2666,8 @@ static int ext4_writepage(struct page *page,
>  		 */
>  		goto redirty_page;
>  	}
> +	WARN_ON(!PageLocked(page));
> +	wait_on_page_writeback(page);
>  	if (commit_write)
>  		/* now mark the buffer_heads as dirty and uptodate */
>  		block_commit_write(page, 0, len);
> @@ -2778,7 +2780,8 @@ static int write_cache_pages_da(struct address_space *mapping,
>  			}
>  
>  			lock_page(page);
> -
> +			if (PageWriteback(page))
> +				wait_on_page_writeback(page);
>  			/*
>  			 * If the page is no longer dirty, or its
>  			 * mapping no longer corresponds to inode we
> @@ -5803,12 +5806,14 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	if (PageMappedToDisk(page))
>  		goto out_unlock;
>  
> +	lock_page(page);
> +	/* this one seems to handle mmap */
> +	wait_on_page_writeback(page);
>  	if (page->index == size >> PAGE_CACHE_SHIFT)
>  		len = size & ~PAGE_CACHE_MASK;
>  	else
>  		len = PAGE_CACHE_SIZE;
>  
> -	lock_page(page);
>  	/*
>  	 * return if we have all the buffers mapped. This avoid
>  	 * the need to call write_begin/write_end which does a
> @@ -5839,6 +5844,15 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	if (ret < 0)
>  		goto out_unlock;
>  	ret = 0;
> +
> +	/*
> +	 * write_begin/end might have created a dirty page and someone
> +	 * could wander in and start the IO.  Make sure that hasn't
> +	 * happened.
> +	 */
> +	lock_page(page);
> +	wait_on_page_writeback(page);
> +	unlock_page(page);

nit:

The callers of page_mkwrite always lock the page afterward if you
return from page_mkwrite with it unlocked. If you plan to take page
lock anyway, it's probably slightly more efficient not to unlock it and
instead return VM_FAULT_LOCKED.

-- 
Jeff Layton <jlayton@redhat.com>

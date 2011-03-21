From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Date: Mon, 21 Mar 2011 15:04:51 +0100
Message-ID: <20110321140451.GA7153@quack.suse.cz>
References: <yq1vd0cf26f.fsf@sermon.lab.mkp.net>
 <20110223202446.GG4020@noexit>
 <1298493173-sup-8301@think>
 <20110224164758.GH23042@quack.suse.cz>
 <1298566775-sup-730@think>
 <20110224182732.GV27190@tux1.beaverton.ibm.com>
 <1298897186-sup-9394@think>
 <20110304210724.GF27190@tux1.beaverton.ibm.com>
 <20110308045626.GD1956@dastard>
 <20110319000755.GD1110@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110319000755.GD1110@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri 18-03-11 17:07:55, Darrick J. Wong wrote:
> > > Ok, here's what I have so far.  I took everyone's suggestions of where to add
> > > calls to wait_on_page_writeback, which seems to handle the multiple-write case
> > > adequately.  Unfortunately, it is still possible to generate checksum errors by
> > > scribbling furiously on a mmap'd region, even after adding the writeback wait
> > > in the ext4 writepage function.  Oddly, I couldn't break btrfs with mmap by
> > > removing its wait_for_page_writeback call, so I suspect there's a bit more
> > > going on in btrfs than I've been able to figure out.
> 
> I wonder, is it possible for this to happen:
> 
> 1. Thread A mmaps a page and tries to write to it.  ext4_page_mkwrite executes,
>    but there's no ongoing writeback, so it returns without delay.
> 2. Thread A starts writing furiously to the page.
> 3. Thread B runs fsync() or something that results in the page being
>    checksummed and scheduled for writeout.
> 4. Thread A continues to write furiously(!) on that same page before the
>    controller finishes the DMA transfer.
> 5. Disk gets the page, which now doesn't match its checksum, and *boom*
  What happens on writepage (see mm/page-writeback.c:write_cache_pages())
is:
  lock_page(page)
  ...
  clear_page_dirty_for_io() - removes PageDirty, marks page as read-only in
    PTE
  ...
  set_page_writeback() (happens e.g. in __block_write_full_page() called
from filesystem's writepage implementation).
  unlock_page(page)

  So if you compute the checksum after set_page_writeback() is done in the
writepage() implementation (you cannot use __block_write_full_page() in
that case) and you call wait_on_page_writeback() in ext4_page_mkwrite()
under page lock, you should be safe. If you do all this and still see
errors, something is broken I'd say...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

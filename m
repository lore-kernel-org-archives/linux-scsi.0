From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
	problem
Date: Tue, 22 Mar 2011 12:23:01 -0700
Message-ID: <20110322192301.GE1110@tux1.beaverton.ibm.com>
References: <20110223202446.GG4020@noexit> <1298493173-sup-8301@think> <20110224164758.GH23042@quack.suse.cz> <1298566775-sup-730@think> <20110224182732.GV27190@tux1.beaverton.ibm.com> <1298897186-sup-9394@think> <20110304210724.GF27190@tux1.beaverton.ibm.com> <20110308045626.GD1956@dastard> <20110319000755.GD1110@tux1.beaverton.ibm.com> <E2EA0861-6143-4F91-805A-63736F45C514@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E2EA0861-6143-4F91-805A-63736F45C514@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 18, 2011 at 08:28:26PM -0600, Andreas Dilger wrote:
> On 2011-03-18, at 6:07 PM, Darrick J. Wong wrote:
> >> Ok, here's what I have so far.  I took everyone's suggestions of where to add
> >> calls to wait_on_page_writeback, which seems to handle the multiple-write case
> >> adequately.  Unfortunately, it is still possible to generate checksum errors by
> >> scribbling furiously on a mmap'd region, even after adding the writeback wait
> >> in the ext4 writepage function.  Oddly, I couldn't break btrfs with mmap by
> >> removing its wait_for_page_writeback call, so I suspect there's a bit more
> >> going on in btrfs than I've been able to figure out.
> 
> > I wonder, is it possible for this to happen:
> > 
> > 1. Thread A mmaps a page and tries to write to it.  ext4_page_mkwrite executes,
> >   but there's no ongoing writeback, so it returns without delay.
> > 2. Thread A starts writing furiously to the page.
> > 3. Thread B runs fsync() or something that results in the page being
> >   checksummed and scheduled for writeout.
> > 4. Thread A continues to write furiously(!) on that same page before the
> >   controller finishes the DMA transfer.
> 
> Right, page_mkwrite() is only called for the ro->rw transition.
> 
> > 5. Disk gets the page, which now doesn't match its checksum, and *boom*
> > 
> > After letting the stress tool run for a few days, I can say fairly confidently
> > that the write() case doesn't seem to fail regardless of the O_DIRECT setting.
> > However, with writes to mmap regions, failures happen about once every 20-40
> > minutes, even with O_DIRECT set.  To me this suggests some sort of race
> > condition that we seem to win except once every 20 minutes.
> > 
> > I then thought, if page_mkwrite contains a wait_on_page_writeback, then perhaps
> > there's something that I could do just prior to calculating the DIF checksum
> > that would cause any subsequent write attempts to be shuffled back into
> > page_mkwrite.  I tried the set_memory_ro thing again, though that led to some
> > recursive lock errors and I noticed that those functions only seem to exist in
> > arch/x86/.  Next I tried directly mucking with PTEs, in addition to feeling
> > messy, only seemed to corrupt memory. :)
> 
> This seems like the best solution, IMHO, to ensure that mmap is blocked in
> page_mkwrite() before it has any chance to dirty the page undergoing
> checksum.  The trick is that you need to set_page_writeback() before setting
> the page read-only, otherwise the race still exists.

I figured out that the recursive locking errors only happened in the
set_memory_rw half of the ro/rw memory pair, and that I could make them go away
(for now) by do set_memory_rw in the kintegrityd workqueue.  Then I added a
call to set_page_writeback just prior to the set_memory_ro call, though that
resulted in a lot of complaints about invalid page states and the like.  It
would seem that the memory pages that arrive in bio_integrity_prep from jbd2
don't have the writeback flag set, and setting it causes problems for it.  The
writeback flag is set on all the pages that are associated with a checksum
failure, I noticed.

As for changing pte's around... does that set_memory_ro change the pte flags
for all running processes?  I'm not so sure it does for anything other than the
current process.  I think I saw a flush_tlb call in there... though I don't
think it helps me much.

If I /don't/ set the flag, the frequency of the errors decreases further to
about once an hour, but I still see the occasional error. :/  Currently I'm
trying to figure out how one might distinguish dirty pages that shouldn't have
writeback set vs. pages that ought to have it but don't.

I suppose I could pull out the 're-checksum and resubmit' patch I made a while
back, though it seems like a bandaid.

> > Is there a "correct" way to take a writeable page and make it so that any
> > process trying to write to it ends up hitting the page fault handler where we
> > can then wait for writeback?  Or perhaps I am simply barking up the wrong tree?
> > 
> > (Just FYI I took the old copy-everything-to-bounce-buffers patch that few
> > people liked for a second spin, and the errors did not surface regardless of
> > what combination of write/mmap and directio/bufferedio I told it to use.)
> 
> I wouldn't be so much against memcpy() for mmap pages, but it does seem kind
> of gross that mmap is forcing data copies when a major reason to use mmap is
> to AVOID data copies.

Yeah.  We probably want to avoid having to find extra pages too. :(

--D

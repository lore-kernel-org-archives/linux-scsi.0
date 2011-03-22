From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Date: Tue, 22 Mar 2011 22:54:30 +0100
Message-ID: <20110322215430.GD19716@quack.suse.cz>
References: <1298493173-sup-8301@think>
 <20110224164758.GH23042@quack.suse.cz>
 <1298566775-sup-730@think>
 <20110224182732.GV27190@tux1.beaverton.ibm.com>
 <1298897186-sup-9394@think>
 <20110304210724.GF27190@tux1.beaverton.ibm.com>
 <20110308045626.GD1956@dastard>
 <20110319000755.GD1110@tux1.beaverton.ibm.com>
 <E2EA0861-6143-4F91-805A-63736F45C514@dilger.ca>
 <20110322192301.GE1110@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110322192301.GE1110@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue 22-03-11 12:23:01, Darrick J. Wong wrote:
> On Fri, Mar 18, 2011 at 08:28:26PM -0600, Andreas Dilger wrote:
> > This seems like the best solution, IMHO, to ensure that mmap is blocked in
> > page_mkwrite() before it has any chance to dirty the page undergoing
> > checksum.  The trick is that you need to set_page_writeback() before setting
> > the page read-only, otherwise the race still exists.
> 
> I figured out that the recursive locking errors only happened in the
> set_memory_rw half of the ro/rw memory pair, and that I could make them go away
> (for now) by do set_memory_rw in the kintegrityd workqueue.  Then I added a
> call to set_page_writeback just prior to the set_memory_ro call, though that
> resulted in a lot of complaints about invalid page states and the like.  It
> would seem that the memory pages that arrive in bio_integrity_prep from jbd2
> don't have the writeback flag set, and setting it causes problems for it.  The
> writeback flag is set on all the pages that are associated with a checksum
> failure, I noticed.
  Yeah, pages submitted by jbd2 don't have writeback flag set because they
are metadata blocks written directly via buffer heads. But as you noted,
these are protected in a different way by the journalling layer so
shouldn't need to worry.

> As for changing pte's around... does that set_memory_ro change the pte flags
> for all running processes?  I'm not so sure it does for anything other than the
> current process.  I think I saw a flush_tlb call in there... though I don't
> think it helps me much.
> 
> If I /don't/ set the flag, the frequency of the errors decreases further to
> about once an hour, but I still see the occasional error. :/  Currently I'm
> trying to figure out how one might distinguish dirty pages that shouldn't have
> writeback set vs. pages that ought to have it but don't.
  It's difficult at the block layer... If page->mapping->host is not a
device inode, the page should have PageWriteback set. If it is a device
inode, you don't know - JBD2 will submit pages without PageWriteback set,
flusher thread will submit pages with PageWriteback set. And both is OK
since we use buffer state for synchronization.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

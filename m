From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCHSET v3.1 0/7] data integrity: Stabilize pages during
	writeback for various fses
Date: Mon, 16 May 2011 11:47:36 -0700
Message-ID: <20110516184736.GL20579@tux1.beaverton.ibm.com>
References: <87tyd31fkc.fsf@devron.myhome.or.jp> <20110510123819.GB4402@quack.suse.cz> <87hb924s2x.fsf@devron.myhome.or.jp> <20110510132953.GE4402@quack.suse.cz> <878vue4qjb.fsf@devron.myhome.or.jp> <87zkmu3b2i.fsf@devron.myhome.or.jp> <20110510145421.GJ4402@quack.suse.cz> <87zkmupmaq.fsf@devron.myhome.or.jp> <20110510162237.GM4402@quack.suse.cz> <87vcxipljj.fsf@devron.myhome.or.jp>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87vcxipljj.fsf@devron.myhome.or.jp>
Sender: linux-ext4-owner@vger.kernel.org
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-kernel <linux-kernel@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 11, 2011 at 01:28:32AM +0900, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> Maybe possible, but you really think on usual case just blocking is
> >> better?
> >   Define usual case... As Christoph noted, we don't currently have a real
> > practical case where blocking would matter (since frequent rewrites are
> > rather rare). So defining what is usual when we don't have a single real
> > case is kind of tough ;)
> 
> OK. E.g. usual workload on desktop, but FS like ext2/fat.

In the frequent rewrite case, here's what you get:

Regular disk: (possibly garbage) write, followed by a second write to make the
disk reflect memory contents.

RAID w/ shadow pages: two writes, both consistent.  Higher memory consumption.

T10 DIF disk: disk error any time the CPU modifies a page that the disk
controller is DMA'ing out of memory.  I suppose one could simply retry the
operation if the page is dirty, but supposing memory writes are happening fast
enough that the retries also produce disk errors, _nothing_ ever gets written.

With the new stable-page-writes patchset, the garbage write/disk error symptoms
go away since the processes block instead of creating this window where it's
not clear whether the disk's copy of the data is consistent.  I could turn the
wait_on_page_writeback calls into some sort of page migration if the
performance turns out to be terrible, though I'm still working on quantifying
the impact.  Some people pointed out that sqlite tends to write the same blocks
frequently, though I wonder if sqlite actually tries to write memory pages
while syncing them?

One use case where I could see a serious performance hit happening is the case
where some app writes a bunch of memory pages, calls sync to force the dirty
pages to disk, and /must/ resume writing those memory pages before the sync
completes.  The page migration would of course help there, provided a memory
page can be found in less time than an I/O operation.

Someone commented on the LWN article about this topic, claiming that he had a
program that couldn't afford to block on writes to mlock()'d memory.  I'm not
sure how to fix that program, because if memory writes never coordinate with
disk writes and the other threads are always writing memory, I wonder how the
copy on disk isn't always indeterminate.

--D

From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC v2] block integrity: Stabilize(?) pages during writeback
Date: Tue, 26 Apr 2011 07:33:18 -0400
Message-ID: <1303817010-sup-351@think>
References: <20110407165700.GB7363@quack.suse.cz> <20110408203135.GH1110@tux1.beaverton.ibm.com> <20110411124229.47bc28f6@corrin.poochiereds.net> <1302543595-sup-4352@think> <1302569212.2580.13.camel@mingming-laptop> <20110412005719.GA23077@infradead.org> <1302742128.2586.274.camel@mingming-laptop> <20110422000226.GA22189@tux1.beaverton.ibm.com> <1303476503-sup-4141@think> <20110422203434.GA2977@quack.suse.cz> <20110426003738.GB22189@tux1.beaverton.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20110426003738.GB22189@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: djwong <djwong@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Mingming Cao <cmm@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Excerpts from Darrick J. Wong's message of 2011-04-25 20:37:38 -0400:
> On Fri, Apr 22, 2011 at 10:34:34PM +0200, Jan Kara wrote:
> > On Fri 22-04-11 08:50:01, Chris Mason wrote:
> > > Excerpts from Darrick J. Wong's message of 2011-04-21 20:02:26 -0400:
> > > > Hi everyone,
> > > > 
> > > > I've finally managed to get together a patch that seems to provide stable pages
> > > > during writeback, or at least gets us to the point that after several days of
> > > > running tests I don't see DIF checksum errors anymore. :)
> > > > 
> > > > The last two pieces to go into this puzzle were (a) bio_integrity_prep needs to
> > > > walk the process tree to find all userland ptes that map to a particular memory
> > > > page and revoke write access, and
> > > 
> > > Hmm, did you need the bio_integrity_prep change for all the filesystems?
> > > This should be happening already as part of using page_mkwrite.
> >   Or more precisely page_mkclean() should do what you try to do in
> > bio_integrity_prep()... It would certainly be interesting (bug) if you
> > could write to the page after calling page_mkclean() without page_mkwrite()
> > being called.
> 
> Hm... in mpage_da_submit_io I see the following sequence of calls:
> 
> 1. clear_page_dirty_for_io
> 2. possibly one of: ext4_bio_write_page or block_write_full_page.
>    If ext4_bio_write_page, 
>    2a. kmem_cache_alloc
>    2b. set_page_writeback
> 
> Before and after #1, the page is locked but writeback is not set.
> 
> Before #2, the page must be locked and writeback must not be set, because both
> of those two functions want to set the writeback bit themselves.  However,
> ext4_bio_write_page tries to allocate memory with GFP_NOFS, which means it can
> sleep (I think).

Sleeping isn't the problem as long as you sleep with the page locked.
The idea is that writepage will:

1) lock the page
2) clear_page_dirty_for_io (which calls page_mkclean)
3) set_page_writeback()
4) unlock the page
5) start the IO

page_mkwrite will:

1) lock the page
2) wait on page writeback
3) do other stuff

So if ext is calling set_page_writeback() on an unlocked page, that's a
problem.  Otherwise it should be working.

-chris

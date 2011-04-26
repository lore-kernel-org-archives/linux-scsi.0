From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC v2] block integrity: Stabilize(?) pages during writeback
Date: Tue, 26 Apr 2011 13:37:32 +0200
Message-ID: <20110426113732.GA5114@quack.suse.cz>
References: <20110408203135.GH1110@tux1.beaverton.ibm.com>
 <20110411124229.47bc28f6@corrin.poochiereds.net>
 <1302543595-sup-4352@think>
 <1302569212.2580.13.camel@mingming-laptop>
 <20110412005719.GA23077@infradead.org>
 <1302742128.2586.274.camel@mingming-laptop>
 <20110422000226.GA22189@tux1.beaverton.ibm.com>
 <1303476503-sup-4141@think>
 <20110422203434.GA2977@quack.suse.cz>
 <20110426003738.GB22189@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110426003738.GB22189@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>, Mingming Cao <cmm@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon 25-04-11 17:37:38, Darrick J. Wong wrote:
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
  Yes, it can sleep. But the page remains locked until we set page as
writeback in both cases.

> Unfortunately, ext4_page_mkwrite will check for page locked, wait for
> page writeback, and then return the page.  I think it is theoretically
> possible for #1 to trigger a page_mkwrite which completes before #2b,
> right?
  I'm not sure I understand but once the page is locked by ext4_writepages()
before #1, ext4_page_mkwrite() will block until it can get the page lock -
which can happen only after set_page_writeback() in #2 is done. So then
ext4_page_mkwrite() will block waiting for PageWriteback which gets cleared
after the IO is finished... Or did you mean something else?

> In which case the thread that called mkwrite will think that the
> page isn't being written out, and happily scribble on it during
> writeback.  I could be wrong, but it seems to me that one has to
> write-protect the page after setting the writeback bit.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

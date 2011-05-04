From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC v2] block integrity: Stabilize(?) pages during writeback
Date: Tue, 3 May 2011 18:26:21 -0700
Message-ID: <20110504012621.GD20579@tux1.beaverton.ibm.com>
References: <1302543595-sup-4352@think> <1302569212.2580.13.camel@mingming-laptop> <20110412005719.GA23077@infradead.org> <1302742128.2586.274.camel@mingming-laptop> <20110422000226.GA22189@tux1.beaverton.ibm.com> <1303476503-sup-4141@think> <20110422203434.GA2977@quack.suse.cz> <20110426003738.GB22189@tux1.beaverton.ibm.com> <1303817010-sup-351@think> <20110503015931.GC20579@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110503015931.GC20579@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Mingming Cao <cmm@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, May 02, 2011 at 06:59:31PM -0700, Darrick J. Wong wrote:
> On Tue, Apr 26, 2011 at 07:33:18AM -0400, Chris Mason wrote:
> > Excerpts from Darrick J. Wong's message of 2011-04-25 20:37:38 -0400:
> > > On Fri, Apr 22, 2011 at 10:34:34PM +0200, Jan Kara wrote:
> > > > On Fri 22-04-11 08:50:01, Chris Mason wrote:
> > > > > Excerpts from Darrick J. Wong's message of 2011-04-21 20:02:26 -0400:
> > > > > > Hi everyone,
> > > > > > 
> > > > > > I've finally managed to get together a patch that seems to provide stable pages
> > > > > > during writeback, or at least gets us to the point that after several days of
> > > > > > running tests I don't see DIF checksum errors anymore. :)
> > > > > > 
> > > > > > The last two pieces to go into this puzzle were (a) bio_integrity_prep needs to
> > > > > > walk the process tree to find all userland ptes that map to a particular memory
> > > > > > page and revoke write access, and
> > > > > 
> > > > > Hmm, did you need the bio_integrity_prep change for all the filesystems?
> > > > > This should be happening already as part of using page_mkwrite.
> > > >   Or more precisely page_mkclean() should do what you try to do in
> > > > bio_integrity_prep()... It would certainly be interesting (bug) if you
> > > > could write to the page after calling page_mkclean() without page_mkwrite()
> > > > being called.
> > > 
> > > Hm... in mpage_da_submit_io I see the following sequence of calls:
> > > 
> > > 1. clear_page_dirty_for_io
> > > 2. possibly one of: ext4_bio_write_page or block_write_full_page.
> > >    If ext4_bio_write_page, 
> > >    2a. kmem_cache_alloc
> > >    2b. set_page_writeback
> > > 
> > > Before and after #1, the page is locked but writeback is not set.
> > > 
> > > Before #2, the page must be locked and writeback must not be set, because both
> > > of those two functions want to set the writeback bit themselves.  However,
> > > ext4_bio_write_page tries to allocate memory with GFP_NOFS, which means it can
> > > sleep (I think).
> > 
> > Sleeping isn't the problem as long as you sleep with the page locked.
> > The idea is that writepage will:
> > 
> > 1) lock the page
> > 2) clear_page_dirty_for_io (which calls page_mkclean)
> > 3) set_page_writeback()
> > 4) unlock the page
> > 5) start the IO
> > 
> > page_mkwrite will:
> > 
> > 1) lock the page
> > 2) wait on page writeback
> > 3) do other stuff
> > 
> > So if ext is calling set_page_writeback() on an unlocked page, that's a
> > problem.  Otherwise it should be working.
> 
> You're right, at this point in time writepage and page_mkwrite in ext4 both
> behave as you describe.  I began backing out parts of my patches to
> bio-integrity.c and discovered that with the current kernel (2.6.39-rc5) the
> only part that seems useful is the set_memory_ro/rw pair from that old
> debugging patch.  Unfortunately, those two functions only seem to exist on x86;
> I suppose I could port them to others.  If that's even a sane idea.

Never mind, I looked around for anything that would result in the kernel trying
to map a page for the purpose of writing, and I think adding a
wait_on_writeback to get_cache_page_for_write will solve that last hole without
having to port set_memory_* to other arches.  With that, a whole lot of code
falls out of the patches, which I will post shortly.

--D
> 
> --D
> > 
> > -chris
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

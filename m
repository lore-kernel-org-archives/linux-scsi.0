From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Date: Thu, 24 Feb 2011 17:47:58 +0100
Message-ID: <20110224164758.GH23042@quack.suse.cz>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com>
 <yq1vd0cf26f.fsf@sermon.lab.mkp.net>
 <20110223202446.GG4020@noexit>
 <1298493173-sup-8301@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1298493173-sup-8301@think>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, djwong <djwong@us.ibm.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed 23-02-11 15:35:11, Chris Mason wrote:
> Excerpts from Joel Becker's message of 2011-02-23 15:24:47 -0500:
> > On Tue, Feb 22, 2011 at 11:45:44AM -0500, Martin K. Petersen wrote:
> > > Also, DIX is only the tip of the iceberg. Many other impending
> > > technologies feature checksums and require pages to be stable during I/O
> > > due to checksumming, encryption and so on.
> > > 
> > > The VM is already trying to do the right thing. We just need the
> > > relevant filesystems to catch up.
> > 
> >     ocfs2 handles stable metadata for its checksums when feeding
> > things to the journal.  If we're doing pagecache-based I/O, is the
> > pagecache going to help here for data?
> 
> Data is much easier than metadata.  All you really need is to wait on
> writeback in file_write, wait on writeback in page_mkwrite, and make
> sure you don't free blocks back to the allocator that are actively under
> IO.
> 
> I expect the hard part to be jbd and metadata in ext34.
  But JBD already has to do data copy if a buffer is going to be modified
before/while it is written to the journal. So we should alredy do all that
is needed for metadata. I don't say there aren't any bugs as they could be
triggered only by crashing at the wrong moment and observing fs corruption.
But most of the work should be there...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

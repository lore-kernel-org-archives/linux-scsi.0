From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Date: Wed, 23 Feb 2011 09:53:51 +1100
Message-ID: <20110222225351.GG3166@dastard>
References: <20110222020022.GH32261@tux1.beaverton.ibm.com>
 <180713DB-114C-454B-A91E-063AB0116251@dilger.ca>
 <20110222194538.GU27190@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110222194538.GU27190@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 22, 2011 at 11:45:38AM -0800, Darrick J. Wong wrote:
> On Tue, Feb 22, 2011 at 09:13:49AM -0700, Andreas Dilger wrote:
> > On 2011-02-21, at 19:00, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> > > Last summer there was a long thread entitled "Wrong DIF guard tag on ext2
> > > write" (http://marc.info/?l=linux-scsi&m=127530531808556&w=2) that started a
> > > discussion about how to deal with the situation where one program tells the
> > > kernel to write a block to disk, the kernel computes the checksum of that data,
> > > and then a second program begins writing to that same block before the disk HBA
> > > can DMA the memory block, thereby causing the disk to complain about being sent
> > > invalid checksums.
> > > 
> > > I was able to write a
> > > trivial program to trigger the write problem, I'm pretty sure that this has not
> > > been fixed upstream.  (FYI, using O_DIRECT still seems fine.)
> > 
> > Can you please attach your reproducer? IIRC it needed mmap() to hit this
> > problem?  Did you measure CPU usage during your testing?
> 
> I didn't need mmap; a lot of threads using write() was enough.  (The reproducer
> program does have a mmap mode though).  Basically it creates a lot of threads
> to write small blobs to random offsets in a file, with optional mmap, dio, and
> sync options.

*nod*

Both mmap and write paths need to be block on
wait_for_page_writeback(page) once they have a locked page ready for
modification. btrfs does this in btrfs_page_mkwrite() and
prepare_pages(), so adding similar calls into block_page_mkwrite()
and grab_cache_page_write_begin() would probably fix the problem for
the other major filesystems....

> Agreed.  I too am curious to study which circumstances favor copying vs
> blocking.

IMO blocking is generally preferable in high throughput threaded
workloads as there is always another thread that can do useful work
while we wait for IO to complete. Most use cases for DIF center
around high throughput environments....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [dm-devel] [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Tue, 24 Jan 2012 14:07:32 -0500
Message-ID: <20120124190732.GH4387@shiny>
References: <20120119094637.GA23442@quack.suse.cz>
 <4F1BFF5F.6000502@panasas.com>
 <20120123161857.GC28526@quack.suse.cz>
 <20120123175353.GD30782@redhat.com>
 <x49r4yq9suf.fsf@segfault.boston.devel.redhat.com>
 <20120124151504.GQ4387@shiny>
 <20120124165631.GA8941@infradead.org>
 <186EA560-1720-4975-AC2F-8C72C4A777A9@dilger.ca>
 <x49fwf5kmbl.fsf@segfault.boston.devel.redhat.com>
 <20120124184054.GA23227@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120124184054.GA23227@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, Andreas Dilger <adilger@dilger.ca>, Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>, Mike Snitzer <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "Darrick J.Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 24, 2012 at 01:40:54PM -0500, Christoph Hellwig wrote:
> On Tue, Jan 24, 2012 at 01:05:50PM -0500, Jeff Moyer wrote:
> > - buffered writes and buffered O_SYNC writes, all 1MB block size show 4k
> >   I/Os passed down to the I/O scheduler
> > - buffered 1MB reads are a little better, typically in the 128k-256k
> >   range when they hit the I/O scheduler.
> > 
> > ext4:
> > - buffered writes: 512K I/Os show up at the elevator
> > - buffered O_SYNC writes: data is again 512KB, journal writes are 4K
> > - buffered 1MB reads get down to the scheduler in 128KB chunks
> > 
> > xfs:
> > - buffered writes: 1MB I/Os show up at the elevator
> > - buffered O_SYNC writes: 1MB I/Os
> > - buffered 1MB reads: 128KB chunks show up at the I/O scheduler
> > 
> > So, ext4 is doing better than ext3, but still not perfect.  xfs is
> > kicking ass for writes, but reads are still split up.
> 
> All three filesystems use the generic mpages code for reads, so they
> all get the same (bad) I/O patterns.  Looks like we need to fix this up
> ASAP.

Can you easily run btrfs through the same rig?  We don't use mpages and
I'm curious.

-chris


From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [Lsf-pc] [dm-devel]  [LSF/MM TOPIC] a few storage topics
Date: Fri, 27 Jan 2012 12:03:50 -0500
Message-ID: <20120127170350.GA10479@thunk.org>
References: <20120124190732.GH4387@shiny>
 <x49vco0kj5l.fsf@segfault.boston.devel.redhat.com>
 <20120124200932.GB20650@quack.suse.cz>
 <x49pqe8kgej.fsf@segfault.boston.devel.redhat.com>
 <20120124203936.GC20650@quack.suse.cz>
 <20120125032932.GA7150@localhost>
 <F6F2DEB8-F096-4A3B-89E3-3A132033BC76@dilger.ca>
 <20120125063552.GA27375@localhost>
 <20120125140048.GC32361@quack.suse.cz>
 <5B229F2F-4B0D-4AC1-A726-9E0CC8CE5FBE@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B229F2F-4B0D-4AC1-A726-9E0CC8CE5FBE@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Wu Fengguang <fengguang.wu@gmail.com>, Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, "neilb@suse.de Brown" <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>, "dm-devel@redhat.com development" <dm-devel@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>, "linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>, lsf-pc@lists.linux-foundation.org, Chris Mason <chris.mason@oracle.com>, "Darrick J.Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 26, 2012 at 05:29:03AM -0700, Andreas Dilger wrote:
> 
> Ext4 will also align IO to 1MB boundaries (from the start of
> LUN/partition) by default.  If the mke2fs code detects the
> underlying RAID geometry (or the sysadmin sets this manually with
> tune2fs) it will store this in the superblock for the allocator to
> pick a better alignment.

(Still in Hawaii on vacation, but picked this up while I was quickly
scanning through e-mail.)

This is true only if you're using the special (non-upstream'ed) Lustre
interfaces for writing Lustre objects.  The writepages interface
doesn't have all of the necessary smarts to do the right thing.  It's
been on my todo list to look at, but I've been mostly concentrated on
single disk file systems since that's what we use at Google.  (GFS can
scale to many many file systems and servers, and avoiding RAID means
fast FSCK recoveries, simplifying things since we don't have to worry
about RAID-related failures, etc.)

Eventually I'd like ext4 to handle RAID better, but unless you're
forced to support really large files, I've come around to believing
that n=3 replication or Reed-Solomon encoding across multiple servers
is a much better way of achieving data robustness, so it's just not
been high on my list of priorities.  I'm much more interested in
making sure ext4 works well under high memory pressure, and other
cloud-related issues.

							- Ted

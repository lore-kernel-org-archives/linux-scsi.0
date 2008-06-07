From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Sun, 8 Jun 2008 06:54:38 +1000
Message-ID: <20080607205438.GS10720@disturbed>
References: <patchbomb.1212643369@sermon.lab.mkp.net> <20080605104042.GB20308@shareable.org> <yq1hcc7mkgn.fsf@sermon.lab.mkp.net> <20080606045150.GL10720@disturbed> <yq1zlpyld2k.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1zlpyld2k.fsf@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 06, 2008 at 12:53:39PM -0400, Martin K. Petersen wrote:
> >>>>> "Dave" == Dave Chinner <david@fromorbit.com> writes:
> 
> Dave> So is there going to be any obvious kernel API to access all
> Dave> this info? i.e. if you do an online modification of a volume
> Dave> (e.g.  add new storage of a different geometry to the volume)
> Dave> and then do an online grow of the filesystem, how does the
> Dave> filesystem get that new geometry information for the expanded
> Dave> area?
> 
> xfs_growfs would call libdisk to see whether the topology had changed
> since the fs was created.

Sure it could, but xfs_growfs is currently just a wrapper around an
ioctl that tells the kernel to grow the filesystem by N bytes and
the kernel does all the changes transactionally. So changing
xfs_growfs to provide this information to the kernel will 
require a new userspace API for XFS to push this information
straight back down into the kernel....

Also, it would be good to verify that stored filesystem parameters
are still optimal at mount time by querying the block device(s)
when internal structures are first initialised from disk.
Hence even a simple kernel API to this info would be handy.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

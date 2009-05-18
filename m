From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 05/13] block: Export I/O topology for block devices and
	partitions
Date: Mon, 18 May 2009 14:12:05 -0400
Message-ID: <20090518181204.GC32085@redhat.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com> <1242362435-11953-6-git-send-email-martin.petersen@oracle.com> <20090518175741.GM4140@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090518175741.GM4140@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, May 18 2009 at  1:57pm -0400,
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Fri, May 15 2009, Martin K. Petersen wrote:
> > From: Martin K. Petersen <martin.petersen@oracle.com>
> > 
> > To support devices with physical block sizes bigger than 512 bytes we
> > need to ensure proper alignment.  This patch adds support for exposing
> > I/O topology characteristics as devices are stacked.
> > 
> >   logical_block_size is the smallest unit the device can address.
> > 
> >   physical_block_size indicates the smallest I/O the device can write
> >   without incurring a read-modify-write penalty.
> > 
> >   The io_min parameter is the smallest preferred I/O size reported by
> >   the device.  In many cases this is the same as the physical block
> >   size.  However, the io_min parameter can be scaled up when stacking
> >   (RAID5 chunk size > physical block size).
> > 
> >   The io_opt characteristic indicates the optimal I/O size reported by
> >   the device.  This is usually the stripe width for arrays.
> > 
> >   The io_alignment parameter indicates the number of bytes the start of
> >   the device/partition is offset from the device's natural alignment.
> >   Partition tools and MD/DM utilities can use this to pad their offsets
> >   so filesystem start on proper boundaries.
> > 
> > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> > ---
> >  Documentation/ABI/testing/sysfs-block |   59 +++++++++++
> >  block/blk-settings.c                  |  184 +++++++++++++++++++++++++++++++++
> >  block/blk-sysfs.c                     |   33 ++++++
> >  block/genhd.c                         |   10 ++
> >  fs/partitions/check.c                 |   10 ++
> >  include/linux/blkdev.h                |   47 +++++++++
> >  include/linux/genhd.h                 |    1 +
> >  7 files changed, 344 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
> > index 44f52a4..93075cf 100644
> > --- a/Documentation/ABI/testing/sysfs-block
> > +++ b/Documentation/ABI/testing/sysfs-block
> > @@ -60,3 +60,62 @@ Description:
> >  		Indicates whether the block layer should automatically
> >  		generate checksums for write requests bound for
> >  		devices that support receiving integrity metadata.
> > +
> > +What:		/sys/block/<disk>/alignment
> > +Date:		April 2009
> > +Contact:	Martin K. Petersen <martin.petersen@oracle.com>
> > +Description:
> > +		Storage devices may report a physical block size that is
> > +		bigger than the logical block size (for instance a drive
> > +		with 4KB physical sectors exposing 512-byte logical
> > +		blocks to the operating system).  This parameter
> > +		indicates how many bytes the beginning of the device is
> > +		offset from the disk's natural alignment.
> > +
> > +What:		/sys/block/<disk>/<partition>/alignment
> > +Date:		April 2009
> > +Contact:	Martin K. Petersen <martin.petersen@oracle.com>
> > +Description:
> > +		Storage devices may report a physical block size that is
> > +		bigger than the logical block size (for instance a drive
> > +		with 4KB physical sectors exposing 512-byte logical
> > +		blocks to the operating system).  This parameter
> > +		indicates how many bytes the beginning of the partition
> > +		is offset from the disk's natural alignment.
> 
> I really hate the 'alignment' name, nobody will know wtf that is without
> looking it up. The rest of the names are fairly self explanatory.
> offset? offset_size? misalignment? Not very good with names, but perhaps
> we can find something more appropriate :-)
> 
> The rest of the patch set looks ok to me, if we can just agree on a
> silly name, then lets merge it for 2.6.31.

I agree that 'alignment' is too terse/confusing given that it is an
offset we're exposing.  How about 'alignment_offset'?

Mike

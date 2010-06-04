From: Jan Kara <jack@suse.cz>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Fri, 4 Jun 2010 17:32:10 +0200
Message-ID: <20100604153210.GE3414@quack.suse.cz>
References: <20100601164750.GQ8980@think>
 <1275411293.21962.387.camel@mulgrave.site>
 <20100601180905.GR8980@think>
 <20100601184649.GE9453@laptop>
 <20100601193528.GV8980@think>
 <20100602032030.GF9453@laptop>
 <yq17hmhbmkb.fsf@sermon.lab.mkp.net>
 <20100602134121.GD6152@laptop>
 <20100603154634.GC8980@think>
 <20100604020243.GE19651@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100604020243.GE19651@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Matthew Wilcox <matthew@wil.cx>, Christof Schmitt <christof.schmitt@de.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri 04-06-10 12:02:43, Dave Chinner wrote:
> On Thu, Jun 03, 2010 at 11:46:34AM -0400, Chris Mason wrote:
> > On Wed, Jun 02, 2010 at 11:41:21PM +1000, Nick Piggin wrote:
> > > Closing the while it is dirty, while it is being written back window
> > > still leaves a pretty big window. Also, how do you handle mmap writes?
> > > Write protect and checksum the destination page after every store? Or
> > > leave some window between when the pagecache is dirtied and when it is
> > > written back? So I don't know whether it's worth putting a lot of effort
> > > into this case.
> > 
> > So, changing gears to how do we protect filesystem page cache pages
> > instead of the generic idea of dif/dix, btrfs crcs just before writing,
> > which does leave a pretty big window for the page to get corrupted.
> > The storage layer shouldn't care or know about that though, we hand it a
> > crc and it makes sure data matching that crc goes to the media.
> 
> I think the only way to get accurate CRCs is to stop modifications
> from occurring while the page is under writeback. i.e. when a page
> transitions from dirty to writeback we need to unmap any writable
> mappings on the page, and then any new modifications (either by the
> write() path or through ->fault) need to block waiting for
> page writeback to complete before they can proceed...
  Actually, we already write-protect the page in clear_page_dirty_for_io
so the first part already happens. Any filesystem can do
wait_on_page_writeback() in its ->page_mkwrite function so even the second
part shouldn't be hard. I'm just a bit worried about the performance
implications / hidden deadlocks...
  Also we'd have to wait_on_page_writeback() in ->write_begin function to
protect against ordinary writes  but that's the easy part...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

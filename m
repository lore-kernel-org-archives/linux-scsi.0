From: Nick Piggin <npiggin@suse.de>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 8 Jun 2010 18:52:00 +1000
Message-ID: <20100608085200.GU26335@laptop>
References: <yq11vcqlwp8.fsf@sermon.lab.mkp.net>
 <20100602133748.GA11196@schmichrtp.mainz.de.ibm.com>
 <20100602232039.GA8287@dastard>
 <yq139x3y411.fsf@sermon.lab.mkp.net>
 <20100604023253.GF19651@dastard>
 <yq1zkz6vmpu.fsf@sermon.lab.mkp.net>
 <4C0D2AD4.2020303@panasas.com>
 <yq1sk4yvj0a.fsf@sermon.lab.mkp.net>
 <20100608071534.GA3263@schmichrtp.mainz.de.ibm.com>
 <20100608084718.GB7869@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100608084718.GB7869@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 08, 2010 at 06:47:18PM +1000, Dave Chinner wrote:
> On Tue, Jun 08, 2010 at 09:15:35AM +0200, Christof Schmitt wrote:
> > > But my original changes were along the lines of what Jan mentioned
> > > earlier (hooking into page_mkwrite and waiting for writeback.  I could
> > > have sworn that I only did it for ext[23] and that XFS waited out of the
> > > box but git proves me wrong).  Anyway, I'll try to get some benchmarking
> > > happening later this week.
> > 
> > Is there a patch with this change available somewhere? It might be
> > useful to patch a kernel with this XFS change for reliable DIF/DIX
> > testing.
> 
> Adding a wait_on_page_writeback() call to page_mkwrite() won't help
> by itself - you need to unmap the pages after transitioning them
> from dirty to writeback but before the hardware starts processing
> the IO if you want to lock out mmap writes this way....

Actually as Jan pointed out, clear_page_dirty_for_io already does
this. So it seems pretty doable. get_user_pages remains a problem
(which I believe NFS just ignores) but it could be avoided by
just disallowing it.

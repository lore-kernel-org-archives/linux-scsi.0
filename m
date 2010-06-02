From: Dave Chinner <david@fromorbit.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Thu, 3 Jun 2010 09:20:39 +1000
Message-ID: <20100602232039.GA8287@dastard>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
 <20100531144648.GA19068@schmichrtp.mainz.de.ibm.com>
 <yq11vcqlwp8.fsf@sermon.lab.mkp.net>
 <20100602133748.GA11196@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100602133748.GA11196@schmichrtp.mainz.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 02, 2010 at 03:37:48PM +0200, Christof Schmitt wrote:
> On Tue, Jun 01, 2010 at 09:16:35AM -0400, Martin K. Petersen wrote:
> > >>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:
> > 
> > >> Yep, known bug.  Page writeback locking is messed up for buffer_head
> > >> users.  The extNfs folks volunteered to look into this a while back
> > >> but I don't think they have found the time yet.
> > 
> > Christof> Thanks for the info. This means that this bug appears with all
> > Christof> filesystems?
> > 
> > XFS and btrfs should be fine.
> 
> XFS looks good in my test, thanks for the hint. I am going to use XFS
> for anything related to DIF for now. It would be nice to have a
> solution that works for all filesystems, but it looks like this will
> take some time and work.

If you are running DIF hardware, then XFS is only OK for direct IO.
XFS will still get torn writes if you are overwriting buffered data
(either by write() or mmap()) because there are no interlocks to
prevent cached pages under writeback from being modified while DMA
is being performed.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

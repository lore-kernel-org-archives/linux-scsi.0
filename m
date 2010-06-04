From: Dave Chinner <david@fromorbit.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Fri, 4 Jun 2010 12:32:53 +1000
Message-ID: <20100604023253.GF19651@dastard>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
 <20100531144648.GA19068@schmichrtp.mainz.de.ibm.com>
 <yq11vcqlwp8.fsf@sermon.lab.mkp.net>
 <20100602133748.GA11196@schmichrtp.mainz.de.ibm.com>
 <20100602232039.GA8287@dastard>
 <yq139x3y411.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:47706 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757007Ab0FDCdM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2010 22:33:12 -0400
Content-Disposition: inline
In-Reply-To: <yq139x3y411.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Jun 03, 2010 at 09:34:18PM -0400, Martin K. Petersen wrote:
> >>>>> "Dave" == Dave Chinner <david@fromorbit.com> writes:
> 
> Dave> If you are running DIF hardware, then XFS is only OK for direct
> Dave> IO.  XFS will still get torn writes if you are overwriting
> Dave> buffered data (either by write() or mmap()) because there are no
> Dave> interlocks to prevent cached pages under writeback from being
> Dave> modified while DMA is being performed.....
> 
> Didn't you use to wait_on_page_writeback() in page_mkwrite()?

The generic implementation of ->page_mkwrite  (block_page_mkwrite())
which XFS uses has never had a wait_on_page_writeback() call in it.
There's no call in the generic write paths, either, hence my comment
that only direct IO on XFS will work.

It should be noted that metadata updates in XFS are already
protected against torn writes - buffers are held locked during IO,
and can only be modified while holding the lock. Hence the only
problem that needs solving for XFS to make full use of DIF/DIX is
getting the page cache paths to not modify pages under IO...


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

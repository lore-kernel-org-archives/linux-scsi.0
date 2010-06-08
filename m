From: Dave Chinner <david@fromorbit.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 8 Jun 2010 18:47:18 +1000
Message-ID: <20100608084718.GB7869@dastard>
References: <20100531144648.GA19068@schmichrtp.mainz.de.ibm.com>
 <yq11vcqlwp8.fsf@sermon.lab.mkp.net>
 <20100602133748.GA11196@schmichrtp.mainz.de.ibm.com>
 <20100602232039.GA8287@dastard>
 <yq139x3y411.fsf@sermon.lab.mkp.net>
 <20100604023253.GF19651@dastard>
 <yq1zkz6vmpu.fsf@sermon.lab.mkp.net>
 <4C0D2AD4.2020303@panasas.com>
 <yq1sk4yvj0a.fsf@sermon.lab.mkp.net>
 <20100608071534.GA3263@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:57252 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753438Ab0FHIrX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2010 04:47:23 -0400
Content-Disposition: inline
In-Reply-To: <20100608071534.GA3263@schmichrtp.mainz.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Jun 08, 2010 at 09:15:35AM +0200, Christof Schmitt wrote:
> On Mon, Jun 07, 2010 at 01:40:21PM -0400, Martin K. Petersen wrote:
> > >>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:
> > 
> > Boaz> Do you remember some performance numbers that show degradation /
> > Boaz> sameness?
> > 
> > Boaz> What type of work loads?
> > 
> > I haven't been using XFS much for over a year.  I'm using an internal
> > async I/O tool and btrfs for most of my DIX/DIF testing these days.
> > 
> > But my original changes were along the lines of what Jan mentioned
> > earlier (hooking into page_mkwrite and waiting for writeback.  I could
> > have sworn that I only did it for ext[23] and that XFS waited out of the
> > box but git proves me wrong).  Anyway, I'll try to get some benchmarking
> > happening later this week.
> 
> Is there a patch with this change available somewhere? It might be
> useful to patch a kernel with this XFS change for reliable DIF/DIX
> testing.

Adding a wait_on_page_writeback() call to page_mkwrite() won't help
by itself - you need to unmap the pages after transitioning them
from dirty to writeback but before the hardware starts processing
the IO if you want to lock out mmap writes this way....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

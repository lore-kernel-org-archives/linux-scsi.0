From: Craig Tierney <ctierney@hpti.com>
Subject: Re: Question about Qlogic performance in 2.6 kernel
Date: Thu, 14 Oct 2004 06:41:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097757667.2939.9.camel@localhost.localdomain>
References: <1097713700.3213.159.camel@hpti9.fsl.noaa.gov>
	 <20041014030340.GA290349@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from system65-210-78-197.hpti.com ([65.210.78.197]:2913 "EHLO
	hptimail01.HPTI.COM") by vger.kernel.org with ESMTP id S263778AbUJNMn6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 08:43:58 -0400
In-Reply-To: <20041014030340.GA290349@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2004-10-13 at 21:03, Jeremy Higdon wrote:
> On Wed, Oct 13, 2004 at 06:28:20PM -0600, Craig Tierney wrote:
> > I am seeing a large disparity in reads and writes from
> > my Raid box under the 2.6 kernel.  I have tried this from
> > an Itanium box runing RHEL 4 beta and an Opteron box running
> > SUSE 9.1 professional.  In both cases I am using 2 qlogic
> > QLA2200F HBAs.  Each HBA talks to one lun from the array, and
> > I use dm to create a filesystem.
> > 
> > Using lmdd to create a single stream of IO, I see 190 MB/s for
> > writes, but only 55 MB/s for reads.  The vendor says reads and
> > writes can be as much as 300 MB/s if I had the right HBAs, but
> > the write performance is good for 2 1 Gb/s HBAs.  
> > 
> > I tried this with a 2.4 kernel on a dual Xeon box.  Performance
> > was 150 MB/s for both reads and writes.  The read performance was
> > that high only after I changed /proc/sys/vm/max-readahead to 1023.
> > 
> > I tried changing the readahead size in 2.6 using blockdev.  The
> > readahead was much larger by default than the 2.4 kernel.  However,
> > no matter how large I set the readahead (as large as 1 MB), the
> > read performance did not change.
> > 
> > I read on the kernel list that in the linux-2.6.9-rc3, some changes
> > to the readahead code path had been merged that was supposed to
> > simplify the logic.  I tried the patch to see if affected performance.
> > It did not.
> > 
> > Does anyone have some suggestions on how to improve the read performance
> > under 2.6?
> > 
> > Thanks,
> > Craig
> 
> 
> It's my experience that changing readahead on devices under a dm
> volume does not actually change the amount of readahead you get.
> 
> Your results suggest that you may be having the same problem.

I read that somewhere in the docs at one point.  I tried changing
the readahead on the dm and on the luns themselves.  By
running blockdev, I saw that the values did indeed change for the
luns.  My read tests showed no change in performance when
I read from the filesystem or each of the luns directly.

Craig


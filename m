From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: Question about Qlogic performance in 2.6 kernel
Date: Wed, 13 Oct 2004 20:03:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041014030340.GA290349@sgi.com>
References: <1097713700.3213.159.camel@hpti9.fsl.noaa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:37330 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S269812AbUJNDDr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 23:03:47 -0400
Content-Disposition: inline
In-Reply-To: <1097713700.3213.159.camel@hpti9.fsl.noaa.gov>
List-Id: linux-scsi@vger.kernel.org
To: Craig Tierney <ctierney@hpti.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 13, 2004 at 06:28:20PM -0600, Craig Tierney wrote:
> I am seeing a large disparity in reads and writes from
> my Raid box under the 2.6 kernel.  I have tried this from
> an Itanium box runing RHEL 4 beta and an Opteron box running
> SUSE 9.1 professional.  In both cases I am using 2 qlogic
> QLA2200F HBAs.  Each HBA talks to one lun from the array, and
> I use dm to create a filesystem.
> 
> Using lmdd to create a single stream of IO, I see 190 MB/s for
> writes, but only 55 MB/s for reads.  The vendor says reads and
> writes can be as much as 300 MB/s if I had the right HBAs, but
> the write performance is good for 2 1 Gb/s HBAs.  
> 
> I tried this with a 2.4 kernel on a dual Xeon box.  Performance
> was 150 MB/s for both reads and writes.  The read performance was
> that high only after I changed /proc/sys/vm/max-readahead to 1023.
> 
> I tried changing the readahead size in 2.6 using blockdev.  The
> readahead was much larger by default than the 2.4 kernel.  However,
> no matter how large I set the readahead (as large as 1 MB), the
> read performance did not change.
> 
> I read on the kernel list that in the linux-2.6.9-rc3, some changes
> to the readahead code path had been merged that was supposed to
> simplify the logic.  I tried the patch to see if affected performance.
> It did not.
> 
> Does anyone have some suggestions on how to improve the read performance
> under 2.6?
> 
> Thanks,
> Craig


It's my experience that changing readahead on devices under a dm
volume does not actually change the amount of readahead you get.

Your results suggest that you may be having the same problem.

jeremy

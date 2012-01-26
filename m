From: Dave Chinner <david@fromorbit.com>
Subject: Re: [dm-devel] [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Fri, 27 Jan 2012 09:31:11 +1100
Message-ID: <20120126223111.GY15102@dastard>
References: <4F1758D4.9010401@panasas.com>
 <20120119094637.GA23442@quack.suse.cz>
 <4F1BFF5F.6000502@panasas.com>
 <20120123161857.GC28526@quack.suse.cz>
 <20120123175353.GD30782@redhat.com>
 <x49r4yq9suf.fsf@segfault.boston.devel.redhat.com>
 <20120124151504.GQ4387@shiny>
 <20120124165631.GA8941@infradead.org>
 <186EA560-1720-4975-AC2F-8C72C4A777A9@dilger.ca>
 <x49fwf5kmbl.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:1491 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361Ab2AZWbP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2012 17:31:15 -0500
Content-Disposition: inline
In-Reply-To: <x49fwf5kmbl.fsf@segfault.boston.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, Chris Mason <chris.mason@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>, Mike Snitzer <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "Darrick J.Wong" <djwong@us.ibm.com>

On Tue, Jan 24, 2012 at 01:05:50PM -0500, Jeff Moyer wrote:
> Andreas Dilger <adilger@dilger.ca> writes:
> I've been wondering if it's gotten better, so decided to run a few quick
> tests.
> 
> kernel version 3.2.0, storage: hp eva fc array, i/o scheduler cfq,
> max_sectors_kb: 1024, test program: dd
> 
> ext3:
> - buffered writes and buffered O_SYNC writes, all 1MB block size show 4k
>   I/Os passed down to the I/O scheduler
> - buffered 1MB reads are a little better, typically in the 128k-256k
>   range when they hit the I/O scheduler.
> 
> ext4:
> - buffered writes: 512K I/Os show up at the elevator
> - buffered O_SYNC writes: data is again 512KB, journal writes are 4K
> - buffered 1MB reads get down to the scheduler in 128KB chunks
> 
> xfs:
> - buffered writes: 1MB I/Os show up at the elevator
> - buffered O_SYNC writes: 1MB I/Os
> - buffered 1MB reads: 128KB chunks show up at the I/O scheduler
> 
> So, ext4 is doing better than ext3, but still not perfect.  xfs is
> kicking ass for writes, but reads are still split up.

Isn't that simply because the default readahead is 128k? Change the
readahead to be much larger, and you should see much larger IOs
being issued....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

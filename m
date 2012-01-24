From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [dm-devel] [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Tue, 24 Jan 2012 13:05:50 -0500
Message-ID: <x49fwf5kmbl.fsf@segfault.boston.devel.redhat.com>
References: <20120117213648.GA9457@quack.suse.cz>
	<20120118225808.GA3074@tux1.beaverton.ibm.com>
	<20120118232200.GA22019@quack.suse.cz> <4F1758D4.9010401@panasas.com>
	<20120119094637.GA23442@quack.suse.cz> <4F1BFF5F.6000502@panasas.com>
	<20120123161857.GC28526@quack.suse.cz>
	<20120123175353.GD30782@redhat.com>
	<x49r4yq9suf.fsf@segfault.boston.devel.redhat.com>
	<20120124151504.GQ4387@shiny> <20120124165631.GA8941@infradead.org>
	<186EA560-1720-4975-AC2F-8C72C4A777A9@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab2AXSGk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2012 13:06:40 -0500
In-Reply-To: <186EA560-1720-4975-AC2F-8C72C4A777A9@dilger.ca> (Andreas
	Dilger's message of "Tue, 24 Jan 2012 10:08:47 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Mason <chris.mason@oracle.com>, Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>, Mike Snitzer <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "Darrick J.Wong" <djwong@us.ibm.com>

Andreas Dilger <adilger@dilger.ca> writes:

> On 2012-01-24, at 9:56, Christoph Hellwig <hch@infradead.org> wrote:
>> On Tue, Jan 24, 2012 at 10:15:04AM -0500, Chris Mason wrote:
>>> https://lkml.org/lkml/2011/12/13/326
>>> 
>>> This patch is another example, although for a slight different reason.
>>> I really have no idea yet what the right answer is in a generic sense,
>>> but you don't need a 512K request to see higher latencies from merging.
>> 
>> That assumes the 512k requests is created by merging.  We have enough
>> workloads that create large I/O from the get go, and not splitting them
>> and eventually merging them again would be a big win.  E.g. I'm
>> currently looking at a distributed block device which uses internal 4MB
>> chunks, and increasing the maximum request size to that dramatically
>> increases the read performance.
>
> (sorry about last email, hit send by accident)
>
> I don't think we can have a "one size fits all" policy here. In most
> RAID devices the IO size needs to be at least 1MB, and with newer
> devices 4MB gives better performance.

Right, and there's more to it than just I/O size.  There's access
pattern, and more importantly, workload and related requirements
(latency vs throughput).

> One of the reasons that Lustre used to hack so much around the VFS and
> VM APIs is exactly to avoid the splitting of read/write requests into
> pages and then depend on the elevator to reconstruct a good-sized IO
> out of it.
>
> Things have gotten better with newer kernels, but there is still a
> ways to go w.r.t. allowing large IO requests to pass unhindered
> through to disk (or at least as far as enduring that the IO is aligned
> to the underlying disk geometry).

I've been wondering if it's gotten better, so decided to run a few quick
tests.

kernel version 3.2.0, storage: hp eva fc array, i/o scheduler cfq,
max_sectors_kb: 1024, test program: dd

ext3:
- buffered writes and buffered O_SYNC writes, all 1MB block size show 4k
  I/Os passed down to the I/O scheduler
- buffered 1MB reads are a little better, typically in the 128k-256k
  range when they hit the I/O scheduler.

ext4:
- buffered writes: 512K I/Os show up at the elevator
- buffered O_SYNC writes: data is again 512KB, journal writes are 4K
- buffered 1MB reads get down to the scheduler in 128KB chunks

xfs:
- buffered writes: 1MB I/Os show up at the elevator
- buffered O_SYNC writes: 1MB I/Os
- buffered 1MB reads: 128KB chunks show up at the I/O scheduler

So, ext4 is doing better than ext3, but still not perfect.  xfs is
kicking ass for writes, but reads are still split up.

Cheers,
Jeff

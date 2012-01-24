From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [Lsf-pc] [dm-devel]  [LSF/MM TOPIC] a few storage topics
Date: Tue, 24 Jan 2012 18:06:36 +0100
Message-ID: <20120124170636.GG30782@redhat.com>
References: <20120118225808.GA3074@tux1.beaverton.ibm.com>
 <20120118232200.GA22019@quack.suse.cz>
 <4F1758D4.9010401@panasas.com>
 <20120119094637.GA23442@quack.suse.cz>
 <4F1BFF5F.6000502@panasas.com>
 <20120123161857.GC28526@quack.suse.cz>
 <20120123175353.GD30782@redhat.com>
 <x49r4yq9suf.fsf@segfault.boston.devel.redhat.com>
 <20120124151504.GQ4387@shiny>
 <20120124165631.GA8941@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194Ab2AXRHS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2012 12:07:18 -0500
Content-Disposition: inline
In-Reply-To: <20120124165631.GA8941@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>, Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, neilb@suse.de, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, "Darrick J. Wong" <djwong@us.ibm.com>

On Tue, Jan 24, 2012 at 11:56:31AM -0500, Christoph Hellwig wrote:
> That assumes the 512k requests is created by merging.  We have enough
> workloads that create large I/O from the get go, and not splitting them
> and eventually merging them again would be a big win.  E.g. I'm
> currently looking at a distributed block device which uses internal 4MB
> chunks, and increasing the maximum request size to that dramatically
> increases the read performance.

Depends on the device though, if it's a normal disk, it likely only
reduces the number of dma ops without increasing performance too
much. Most disks should reach platter speed at 64KB, so larger request
only saves a bit of cpu in interrutps and stuff.

But I think nobody here was suggesting to reduce the request size by
default. cfq should easily notice when there are multiple queues that
are being submitted in the same time range. A device in addition to
specifying the max request dma size it can handle it could specify the
minimum it runs at platter speed and cfq could degrade to it when
there's multiple queues running in parallel over the same millisecond
or so. Reads will return in the I/O queue almost immediately but
they'll be out for a little while until the data is copied to
userland. So it'd need to keep it down to the min request size the
device allows to reach platter speed, for a little while. Then if no
other queue presents itself it double up the request size for each
unit of time until it reaches the max again. Maybe that could work, maybe
not :). Waiting only once for 4MB sounds better than waiting every
time 4MB for each 4k metadata seeking read.

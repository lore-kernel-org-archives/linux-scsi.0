From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Tue, 24 Jan 2012 10:08:47 -0700
Message-ID: <186EA560-1720-4975-AC2F-8C72C4A777A9@dilger.ca>
References: <20120117213648.GA9457@quack.suse.cz>
	<20120118225808.GA3074@tux1.beaverton.ibm.com>
	<20120118232200.GA22019@quack.suse.cz>
	<4F1758D4.9010401@panasas.com>
	<20120119094637.GA23442@quack.suse.cz>
	<4F1BFF5F.6000502@panasas.com>
	<20120123161857.GC28526@quack.suse.cz>
	<20120123175353.GD30782@redhat.com>
	<x49r4yq9suf.fsf@segfault.boston.devel.redhat.com>
	<20120124151504.GQ4387@shiny> <20120124165631.GA8941@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120124165631.GA8941@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Chris Mason <chris.mason@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 2012-01-24, at 9:56, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Jan 24, 2012 at 10:15:04AM -0500, Chris Mason wrote:
>> https://lkml.org/lkml/2011/12/13/326
>> 
>> This patch is another example, although for a slight different reason.
>> I really have no idea yet what the right answer is in a generic sense,
>> but you don't need a 512K request to see higher latencies from merging.
> 
> That assumes the 512k requests is created by merging.  We have enough
> workloads that create large I/O from the get go, and not splitting them
> and eventually merging them again would be a big win.  E.g. I'm
> currently looking at a distributed block device which uses internal 4MB
> chunks, and increasing the maximum request size to that dramatically
> increases the read performance.

(sorry about last email, hit send by accident)

I don't think we can have a "one size fits all" policy here. In most RAID devices the IO size needs to be at least 1MB, and with newer devices 4MB gives better performance.

One of the reasons that Lustre used to hack so much around the VFS and VM APIs is exactly to avoid the splitting of read/write requests into pages and then depend on the elevator to reconstruct a good-sized IO out of it.

Things have gotten better with newer kernels, but there is still a ways to go w.r.t. allowing large IO requests to pass unhindered through to disk (or at least as far as enduring that the IO is aligned to the underlying disk geometry). 

Cheers, Andreas

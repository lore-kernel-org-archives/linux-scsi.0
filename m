From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Tue, 24 Jan 2012 11:56:31 -0500
Message-ID: <20120124165631.GA8941@infradead.org>
References: <20120117213648.GA9457@quack.suse.cz>
 <20120118225808.GA3074@tux1.beaverton.ibm.com>
 <20120118232200.GA22019@quack.suse.cz>
 <4F1758D4.9010401@panasas.com>
 <20120119094637.GA23442@quack.suse.cz>
 <4F1BFF5F.6000502@panasas.com>
 <20120123161857.GC28526@quack.suse.cz>
 <20120123175353.GD30782@redhat.com>
 <x49r4yq9suf.fsf@segfault.boston.devel.redhat.com>
 <20120124151504.GQ4387@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120124151504.GQ4387@shiny>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>, Jeff Moyer <jmoyer@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, neilb@suse.de, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 24, 2012 at 10:15:04AM -0500, Chris Mason wrote:
> https://lkml.org/lkml/2011/12/13/326
> 
> This patch is another example, although for a slight different reason.
> I really have no idea yet what the right answer is in a generic sense,
> but you don't need a 512K request to see higher latencies from merging.

That assumes the 512k requests is created by merging.  We have enough
workloads that create large I/O from the get go, and not splitting them
and eventually merging them again would be a big win.  E.g. I'm
currently looking at a distributed block device which uses internal 4MB
chunks, and increasing the maximum request size to that dramatically
increases the read performance.


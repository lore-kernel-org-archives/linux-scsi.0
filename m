From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Lsf-pc] [dm-devel]  [LSF/MM TOPIC] a few storage topics
Date: Tue, 24 Jan 2012 12:08:18 -0500
Message-ID: <20120124170818.GY4387@shiny>
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
Received: from acsinet15.oracle.com ([141.146.126.227]:31031 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab2AXRIr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2012 12:08:47 -0500
Content-Disposition: inline
In-Reply-To: <20120124165631.GA8941@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, neilb@suse.de, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, "Darrick J. Wong" <djwong@us.ibm.com>

On Tue, Jan 24, 2012 at 11:56:31AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 24, 2012 at 10:15:04AM -0500, Chris Mason wrote:
> > https://lkml.org/lkml/2011/12/13/326
> > 
> > This patch is another example, although for a slight different reason.
> > I really have no idea yet what the right answer is in a generic sense,
> > but you don't need a 512K request to see higher latencies from merging.
> 
> That assumes the 512k requests is created by merging.  We have enough
> workloads that create large I/O from the get go, and not splitting them
> and eventually merging them again would be a big win.  E.g. I'm
> currently looking at a distributed block device which uses internal 4MB
> chunks, and increasing the maximum request size to that dramatically
> increases the read performance.

Is this read latency or read tput?  If you're waiting on the whole 4MB
anyway, I'd expect one request to be better for both.  But Andrea's
original question  was on the impact of the big request on other requests
being serviced by the drive....there's really not much we can do about
that outside of more knobs for the admin.

-chris

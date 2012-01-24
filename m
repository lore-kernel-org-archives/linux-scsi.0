From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Tue, 24 Jan 2012 12:32:46 -0500
Message-ID: <20120124173246.GB4387@shiny>
References: <20120118225808.GA3074@tux1.beaverton.ibm.com>
 <20120118232200.GA22019@quack.suse.cz>
 <4F1758D4.9010401@panasas.com>
 <20120119094637.GA23442@quack.suse.cz>
 <4F1BFF5F.6000502@panasas.com>
 <20120123161857.GC28526@quack.suse.cz>
 <20120123175353.GD30782@redhat.com>
 <x49r4yq9suf.fsf@segfault.boston.devel.redhat.com>
 <20120124151504.GQ4387@shiny>
 <x49k44hkosh.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49k44hkosh.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, neilb@suse.de, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 24, 2012 at 12:12:30PM -0500, Jeff Moyer wrote:
> Chris Mason <chris.mason@oracle.com> writes:
> 
> > On Mon, Jan 23, 2012 at 01:28:08PM -0500, Jeff Moyer wrote:
> >> Andrea Arcangeli <aarcange@redhat.com> writes:
> >> 
> >> > On Mon, Jan 23, 2012 at 05:18:57PM +0100, Jan Kara wrote:
> >> >> requst granularity. Sure, big requests will take longer to complete but
> >> >> maximum request size is relatively low (512k by default) so writing maximum
> >> >> sized request isn't that much slower than writing 4k. So it works OK in
> >> >> practice.
> >> >
> >> > Totally unrelated to the writeback, but the merged big 512k requests
> >> > actually adds up some measurable I/O scheduler latencies and they in
> >> > turn slightly diminish the fairness that cfq could provide with
> >> > smaller max request size. Probably even more measurable with SSDs (but
> >> > then SSDs are even faster).
> >> 
> >> Are you speaking from experience?  If so, what workloads were negatively
> >> affected by merging, and how did you measure that?
> >
> > https://lkml.org/lkml/2011/12/13/326
> >
> > This patch is another example, although for a slight different reason.
> > I really have no idea yet what the right answer is in a generic sense,
> > but you don't need a 512K request to see higher latencies from merging.
> 
> Well, this patch has almost nothing to with merging, right?  It's about
> keeping I/O from the I/O scheduler for too long (or, prior to on-stack
> plugging, it was about keeping the queue plugged for too long).  And,
> I'm pretty sure that the testing involved there was with deadline or
> noop, nothing to do with CFQ fairness.  ;-)
> 
> However, this does bring to light the bigger problem of optimizing for
> the underlying storage and the workload requirements.  Some tuning can
> be done in the I/O scheduler, but the plugging definitely circumvents
> that a little bit.

Well, its merging in the sense that we know with perfect accuracy how
often it happens (all the time) and how big an impact it had on latency.
You're right that it isn't related to fairness because in this workload
the only IO being sent down was these writes, and only one process was
doing it.

I mention it mostly because the numbers go against all common sense (at
least for me).  Storage just isn't as predictable anymore.

The benchmarking team later reported the patch improved latencies on all
io, not just the log writer.  This one box is fairly consistent.

-chris


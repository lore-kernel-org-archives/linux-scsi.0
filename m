From: Jan Kara <jack@suse.cz>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Thu, 19 Jan 2012 21:52:11 +0100
Message-ID: <20120119205211.GB3629@quack.suse.cz>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com>
 <20120117200609.GA7933@redhat.com>
 <20120117213648.GA9457@quack.suse.cz>
 <20120118225808.GA3074@tux1.beaverton.ibm.com>
 <20120118232200.GA22019@quack.suse.cz>
 <4F1758D4.9010401@panasas.com>
 <20120119094637.GA23442@quack.suse.cz>
 <20120119150849.GD8316@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33899 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932718Ab2ASUwO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 15:52:14 -0500
Content-Disposition: inline
In-Reply-To: <20120119150849.GD8316@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, neilb@suse.de, dm-devel@redhat.com, Boaz Harrosh <bharrosh@panasas.com>, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, "Darrick J. Wong" <djwong@us.ibm.com>

On Thu 19-01-12 16:08:49, Andrea Arcangeli wrote:
> On Thu, Jan 19, 2012 at 10:46:37AM +0100, Jan Kara wrote:
> > So to make this useful the logic won't be trivial. Thirdly, the benefit is
> > questionable anyway (at least for most of realistic workloads) because
> > flusher thread doesn't write the pages all that often - when there are not
> > many pages, we write them out just once every couple of seconds, when we
> > have lots of dirty pages we cycle through all of them so one page is not
> > written that often.
> 
> If you mean migrate as in mm/migrate.c that's also not cheap, it will
> page fault anybody accessing the page, it'll do the page copy, and
> it'll IPI all cpus that had the mm on the TLB, it locks the page too
> and does all sort of checks. But it's true it'll be CPU bound... while
> I understand the current solution is I/O bound.
  Thanks for explanation. You are right that currently we are I/O bound so
migration is probably faster on most HW but as I said earlier, different
things might end up better in different workloads.

> > > Do you have a more detailed description of the workload? Is it theoretically
> > > avoidable?
> >   See https://lkml.org/lkml/2011/10/23/156. Using page migration or copyout
> > would solve the problems of this guy.
> 
> Copying in the I/O layer should be better than page migration,
> 1) copying the page to a I/O kernel buffer won't involve expensive TLB
> IPIs that migration requires, 2) copying the page to a I/O kernel
> buffer won't cause page faults because of migration entries being set,
> 3) migration has to copy too so the cost on the memory bus is the
> same.
>
> So unless I'm missing something page migration and pte/tlb mangling (I
> mean as in mm/migrate.c) is worse in every way than bounce buffering
> at the I/O layer if you notice the page can be modified while it's
> under I/O.
  Well, but the advantage of migration is that you need to do it only if
the page is redirtied while under IO. Copying to I/O buffer would have to
be done for *all* pages because once we submit the bio, we cannot change
anything. So what will be cheaper depends on how often are redirtied pages
under IO. This is rather rare because pages aren't flushed all that often.
So the effect of stable pages in not observable on throughput. But you can
certainly see it on max latency...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

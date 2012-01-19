From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Thu, 19 Jan 2012 16:08:49 +0100
Message-ID: <20120119150849.GD8316@redhat.com>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com>
 <20120117200609.GA7933@redhat.com>
 <20120117213648.GA9457@quack.suse.cz>
 <20120118225808.GA3074@tux1.beaverton.ibm.com>
 <20120118232200.GA22019@quack.suse.cz>
 <4F1758D4.9010401@panasas.com>
 <20120119094637.GA23442@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120119094637.GA23442@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, neilb@suse.de, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 19, 2012 at 10:46:37AM +0100, Jan Kara wrote:
> So to make this useful the logic won't be trivial. Thirdly, the benefit is
> questionable anyway (at least for most of realistic workloads) because
> flusher thread doesn't write the pages all that often - when there are not
> many pages, we write them out just once every couple of seconds, when we
> have lots of dirty pages we cycle through all of them so one page is not
> written that often.

If you mean migrate as in mm/migrate.c that's also not cheap, it will
page fault anybody accessing the page, it'll do the page copy, and
it'll IPI all cpus that had the mm on the TLB, it locks the page too
and does all sort of checks. But it's true it'll be CPU bound... while
I understand the current solution is I/O bound.

> 
> > Do you have a more detailed description of the workload? Is it theoretically
> > avoidable?
>   See https://lkml.org/lkml/2011/10/23/156. Using page migration or copyout
> would solve the problems of this guy.

Copying in the I/O layer should be better than page migration,
1) copying the page to a I/O kernel buffer won't involve expensive TLB
IPIs that migration requires, 2) copying the page to a I/O kernel
buffer won't cause page faults because of migration entries being set,
3) migration has to copy too so the cost on the memory bus is the
same.

So unless I'm missing something page migration and pte/tlb mangling (I
mean as in mm/migrate.c) is worse in every way than bounce buffering
at the I/O layer if you notice the page can be modified while it's
under I/O.

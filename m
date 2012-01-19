From: Jan Kara <jack@suse.cz>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Thu, 19 Jan 2012 10:46:37 +0100
Message-ID: <20120119094637.GA23442@quack.suse.cz>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com>
 <20120117200609.GA7933@redhat.com>
 <20120117213648.GA9457@quack.suse.cz>
 <20120118225808.GA3074@tux1.beaverton.ibm.com>
 <20120118232200.GA22019@quack.suse.cz>
 <4F1758D4.9010401@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F1758D4.9010401@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, neilb@suse.de, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu 19-01-12 01:42:12, Boaz Harrosh wrote:
> On 01/19/2012 01:22 AM, Jan Kara wrote:
> > On Wed 18-01-12 14:58:08, Darrick J. Wong wrote:
> >> On Tue, Jan 17, 2012 at 10:36:48PM +0100, Jan Kara wrote:
> >>> On Tue 17-01-12 15:06:12, Mike Snitzer wrote:
> >>>> 5) Any more progress on stable pages?
> >>>>    - I know Darrick Wong had some proposals, what remains?
> >>>   As far as I know this is done for XFS, btrfs, ext4. Is more needed?
> >>
> >> Yep, it's done for those three fses.
> >>
> >> I suppose it might help some people if instead of wait_on_page_writeback we
> >> could simply page-migrate all the processes onto a new page...?
> 
> >   Well, but it will cost some more memory & copying so whether it's faster
> > or not pretty much depends on the workload, doesn't it? Anyway I've already
> > heard one guy complaining that his RT application does redirtying of mmaped
> > pages and it started seeing big latencies due to stable pages work. So for
> > these guys migrating might be an option (or maybe fadvise/madvise flag to
> > do copy out before submitting for IO?).
> > 
> 
> OK That one is interesting. Because I'd imagine that the Kernel would not
> start write-out on a busily modified page.
  So currently writeback doesn't use the fact how busily is page modified.
After all whole mm has only two sorts of pages - active & inactive - which
reflects how often page is accessed but says nothing about how often is it
dirtied. So we don't have this information in the kernel and it would be
relatively (memory) expensive to keep it.

> Some heavy modifying then a single write. If it's not so then there is
> already great inefficiency, just now exposed, but was always there. The
> "page-migrate" mentioned here will not help.
  Yes, but I believe RT guy doesn't redirty the page that often. It is just
that if you have to meet certain latency criteria, you cannot afford a
single case where you have to wait. And if you redirty pages, you are bound
to hit PageWriteback case sooner or later.

> Could we not better our page write-out algorithms to avoid heavy
> contended pages?
  That's not so easy. Firstly, you'll have track and keep that information
somehow. Secondly, it is better to writeout a busily dirtied page than to
introduce a seek. Also definition of 'busy' differs for different purposes.
So to make this useful the logic won't be trivial. Thirdly, the benefit is
questionable anyway (at least for most of realistic workloads) because
flusher thread doesn't write the pages all that often - when there are not
many pages, we write them out just once every couple of seconds, when we
have lots of dirty pages we cycle through all of them so one page is not
written that often.

> Do you have a more detailed description of the workload? Is it theoretically
> avoidable?
  See https://lkml.org/lkml/2011/10/23/156. Using page migration or copyout
would solve the problems of this guy.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Sun, 22 Jan 2012 14:21:51 +0200
Message-ID: <4F1BFF5F.6000502@panasas.com>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com>
	<20120117200609.GA7933@redhat.com>
	<20120117213648.GA9457@quack.suse.cz>
	<20120118225808.GA3074@tux1.beaverton.ibm.com>
	<20120118232200.GA22019@quack.suse.cz>
	<4F1758D4.9010401@panasas.com>
	<20120119094637.GA23442@quack.suse.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120119094637.GA23442@quack.suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jan Kara <jack@suse.cz>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On 01/19/2012 11:46 AM, Jan Kara wrote:
>>
>> OK That one is interesting. Because I'd imagine that the Kernel would not
>> start write-out on a busily modified page.
>   So currently writeback doesn't use the fact how busily is page modified.
> After all whole mm has only two sorts of pages - active & inactive - which
> reflects how often page is accessed but says nothing about how often is it
> dirtied. So we don't have this information in the kernel and it would be
> relatively (memory) expensive to keep it.
> 

Don't we? what about the information used by the IO elevators per-io-group.
Is it not collected at redirty time. Is it only recorded by the time a bio
is submitted? How does the io-elevator keeps small IO behind heavy writer
latency bound? We could use the reverse of that to not IO the "too soon"

>> Some heavy modifying then a single write. If it's not so then there is
>> already great inefficiency, just now exposed, but was always there. The
>> "page-migrate" mentioned here will not help.
>   Yes, but I believe RT guy doesn't redirty the page that often. It is just
> that if you have to meet certain latency criteria, you cannot afford a
> single case where you have to wait. And if you redirty pages, you are bound
> to hit PageWriteback case sooner or later.
> 

OK, thanks. I need this overview. What you mean is that since the writeback
fires periodically then there must be times when the page or group of pages
are just in the stage of changing and the writeback takes only half of the
modification.

So What if we let the dirty data always wait that writeback timeout, if
the pages are "to-new" and memory condition is fine, then postpone the
writeout to the next round. (Assuming we have that information from the
first part)

>> Could we not better our page write-out algorithms to avoid heavy
>> contended pages?
>   That's not so easy. Firstly, you'll have track and keep that information
> somehow. Secondly, it is better to writeout a busily dirtied page than to
> introduce a seek. 

Sure I'd say we just go on the timestamp of the first page in the group.
Because I'd imagine that the application has changed that group of pages
ruffly at the same time.

> Also definition of 'busy' differs for different purposes.
> So to make this useful the logic won't be trivial. 

I don't think so. 1st: io the oldest data. 2nd: Postpone the IO of
"too new data". So any dirtying has some "aging time" before attack. The
aging time is very much related to your writeback timer. (Which is
 "the amount of memory buffer you want to keep" divide by your writeout-rate)

> Thirdly, the benefit is
> questionable anyway (at least for most of realistic workloads) because
> flusher thread doesn't write the pages all that often - when there are not
> many pages, we write them out just once every couple of seconds, when we
> have lots of dirty pages we cycle through all of them so one page is not
> written that often.
> 

Exactly, so lets make sure dirty is always "couple of seconds" old. Don't let
that timer sample data that is just been dirtied.

Which brings me to another subject in the second case "when we have lots of
dirty pages". I wish we could talk at LSF/MM about how to not do a dumb cycle
on sb's inodes but do a time sort write-out. The writeout is always started
from the lowest addressed page (inode->i_index) so take the time-of-dirty of
that page as the sorting factor of the inode. And maybe keep a min-inode-dirty-time
per SB to prioritize on SBs.

Because you see elevator-less FileSystems. Which are none-block-dev BDIs like
NFS or exofs have a problem. An heavy writer can easily totally starve a slow
IOer (read or write). I can easily demonstrate how an NFS heavy writer starves
a KDE desktop to a crawl. We should be starting to think on IO fairness and
interactivity at the VFS layer. So to not let every none-block-FS solve it's
own problem all over again.

>> Do you have a more detailed description of the workload? Is it theoretically
>> avoidable?
>   See https://lkml.org/lkml/2011/10/23/156. Using page migration or copyout
> would solve the problems of this guy.
> 
> 								Honza

Thanks
Boaz

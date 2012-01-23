From: Jan Kara <jack@suse.cz>
Subject: Re: [LSF/MM TOPIC] [ATTEND] Future writeback topics
Date: Mon, 23 Jan 2012 19:15:34 +0100
Message-ID: <20120123181534.GG28526@quack.suse.cz>
References: <4F1C141C.2050704@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab2AWSPh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jan 2012 13:15:37 -0500
Content-Disposition: inline
In-Reply-To: <4F1C141C.2050704@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Andrea Arcangeli <aarcange@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dave Chinner <david@fromorbit.com>

On Sun 22-01-12 15:50:20, Boaz Harrosh wrote:
> Now that we have the "IO-less dirty throttling" in and kicking (ass I might say)
> Are there plans for second stage? I can see few areas that need some love.
> 
> [IO Fairness, time sorted writeback, properly delayed writeback]
> 
>   As we started to talk about in another thread: "[LSF/MM TOPIC] a few storage topics"
>   I would like to propose the following topics:
> 
> * Do we have enough information for the time of dirty of pages, such as the
>   IO-elevators information, readily available to be used at the VFS layer.
> * BDI writeout should be smarter then a round robin cycle of SBs per BDI /
>   inodes. It should be time based, writing the oldest data first.
>   (Take the lowest indexed page of an inode as the dirty time of the inode.
>    maybe also keep an oldest modified inode per-SB of a BDI)
  As I wrote in the other thread, we are a bit smarter by using
i_dirtied_when timestamp. But not much. But it's hard to do without
introducing rather big memory cost (e.g. something like per-page timestamps
which you suggest). So if you have some solution without big overhead then
I'm happy to listen to that.

>   This can solve the IO fairness and latency bound (interactivness) of small
>   IOs.
  As I also said in the other thread writeback IMO isn't the right place to
solve problems of small vs big IO. Writeback should more or less guarantee
that data get to disk before certain time to assure reasonable behavior
after crash. We also try to be fair among files but that's basically our
way how to get data to disk early enough. I don't know about any other
fairness that would make sense to be handled in writeback code.

>   There might be other solutions to this problem, any Ideas?
> 
> * Introduce an "aging time" factor of an inode which will postpone the writeout
>   of an inode to the next writeback timer if the inode has "just changed".
> 
>   This can solve the problem of an application doing heavy modification of some
>   area of a file and the writeback timer sampling that change too soon and forcing
>   pages to change during IO, as well as having split IO where waiting for the next
>   cycle could have the complete modification in a singe submit.
  But it also brings some problems - like avoiding to postpone writeback
forever. The devil is in the details here I believe and I thought about
similar ideas some time ago and I didn't come up with anything reasonably
simple and working better than current simple scheme.

> [Targeted writeback (IO-less page-reclaim)]
>   Sometimes we would need to write a certain page or group of pages. It could be
>   nice to prioritize/start the writeback on these pages, through the regular writeback
>   mechanism instead of doing direct IO like today.
> 
>   This is actually related to above where we can have a "write_now" time constant that
>   makes the priority of that inode to be written first. Then we also need the page-info
>   that we want to write as part of that inode's IO. Usually today we start at the lowest
>   indexed page of the inode, right? In targeted writeback we should make sure the writeout
>   is the longest contiguous (aligned) dirty region containing the targeted page.
> 
>   With this in place we can also move to an IO-less page-reclaim. that is done entirely by
>   the BDI thread writeback. (Need I say more)
  Again, expensive to track IMHO. Also as Johannes wrote, IO-less
page-reclaim may be less urgent in recent kernels.
 
> [Aligned IO]
> 
>   Each BDI should have a way to specify it's Alignment preferences and optimum IO sizes
>   and the VFS writeout can take that into consideration when submitting IO.
> 
>   This can both reduce lots of work done at individual filesystems, as well as benefit
>   lots of other filesystems that did not take care of this. It can also make the life of
>   some of the FSs that do care, a lot easier. Producing IO patterns that are much better
>   then what can be achieved today with the FS trying to second guess the VFS.
  This is probably doable and may be reasonable. Just currently writeback
code has no idea where particular page lands on disk (mapping logical
offset->physical block is in filesystem hands). But this might be
reasonably doable. Just someone has to write a code to expose enough
information from filesystems to writeback.
 
> [IO less sync]
> 
>   This topic is actually related to the above Aligned IO. 
> 
>   In today's code, in a regular write pattern, when an application is writing a long
>   enough file, we have two sources of threads for the .write_pages vector. One is the
>   BDI write_back thread, the other is the sync operation. This produces nightmarish IO
>   patterns when the write_cache_pages() is re-entrant and each instance is fighting the
>   other in garbing random pages, this is bad because of two reasons:
>    1. makes each instance grab a none contiguous set of pages which causes the IO
>       to split and be none-aligned.
>    2. Causes Seeky IO where otherwise the application just wrote linear IO of
>       a large file and then sync.
> 
>   The IO pattern is so bad that in some cases it is better to serialize the call to
>   write_cache_pages() to avoid it. Even with the cost of a Mutex at every call
> 
>   Would it be hard to have "sync" set some info, raise a flag, fire up the writeback
>   and wait for it to finish? writeback in it's turn should switch to a sync mode on that
>   inode. (The sync operation need not change the writeback priority in my opinion like
>   today)
  We already have I_SYNC inode flag for this used in
writeback_single_inode(). Just fsync path currently seems to avoid
writeback_single_inode() so that exclusion doesn't quite work it. I'm not
sure if I_SYNC was originally intended to provide exlusion against fsync.
But in either case I belive this particular problem can be somehow
resolved.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

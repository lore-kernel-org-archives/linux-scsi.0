From: nick <xerofoify@gmail.com>
Subject: Re: [f2fs-dev] [PATCH 2/2][v2] blk-plug: don't flush nested plug
 lists
Date: Sat, 11 Apr 2015 00:11:54 -0400
Message-ID: <55289F0A.1040309@gmail.com>
References: <1428347694-17704-1-git-send-email-jmoyer@redhat.com>	<1428347694-17704-2-git-send-email-jmoyer@redhat.com>	<x49wq1nrcoe.fsf_-_@segfault.boston.devel.redhat.com>	<20150408230203.GG15810@dastard> <x498udzlkkx.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <x498udzlkkx.fsf@segfault.boston.devel.redhat.com>
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, linux-aio@kvack.org, Miklos Szeredi <mszeredi@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Ming Lei <tom.leiming@gmail.com>, Ming Lei <ming.lei@canonical.com>, Trond Myklebust <trond.myklebust@primarydata.com>, Jianyu Zhan <nasa4836@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-kernel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, Chris Mason <clm@fb.com>, dm-devel@redhat.com, target-devel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, Mark Rustad <mark.d.rustad@intel.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-scsi@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, linux-raid@vger.kernel.org, cluster-devel@redhat.com, Mel Gorman <mgorman@suse.>
List-Id: linux-scsi@vger.kernel.org



On 2015-04-10 05:50 PM, Jeff Moyer wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
>> On Tue, Apr 07, 2015 at 02:55:13PM -0400, Jeff Moyer wrote:
>>> The way the on-stack plugging currently works, each nesting level
>>> flushes its own list of I/Os.  This can be less than optimal (read
>>> awful) for certain workloads.  For example, consider an application
>>> that issues asynchronous O_DIRECT I/Os.  It can send down a bunch of
>>> I/Os together in a single io_submit call, only to have each of them
>>> dispatched individually down in the bowels of the dirct I/O code.
>>> The reason is that there are blk_plug-s instantiated both at the upper
>>> call site in do_io_submit and down in do_direct_IO.  The latter will
>>> submit as little as 1 I/O at a time (if you have a small enough I/O
>>> size) instead of performing the batching that the plugging
>>> infrastructure is supposed to provide.
>>
>> I'm wondering what impact this will have on filesystem metadata IO
>> that needs to be issued immediately. e.g. we are doing writeback, so
>> there is a high level plug in place and we need to page in btree
>> blocks to do extent allocation. We do readahead at this point,
>> but it looks like this change will prevent the readahead from being
>> issued by the unplug in xfs_buf_iosubmit().
> 
> I'm not ignoring you, Dave, I'm just doing some more investigation and
> testing.  It's taking longer than I had hoped.
> 
> -Jeff
> 
Jeff,
Would you mind sending your test reports to the list so we can see what workloads
and tests your running your patch under. This is due to me and the others perhaps
being able to give input into the other major benchmarks or workloads we need to
test too in order to see if there are any regressions with your patch.
Thanks,
Nick

> ------------------------------------------------------------------------------
> BPM Camp - Free Virtual Workshop May 6th at 10am PDT/1PM EDT
> Develop your own process in accordance with the BPMN 2 standard
> Learn Process modeling best practices with Bonita BPM through live exercises
> http://www.bonitasoft.com/be-part-of-it/events/bpm-camp-virtual- event?utm_
> source=Sourceforge_BPM_Camp_5_6_15&utm_medium=email&utm_campaign=VA_SF
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
> 

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>

From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: READ_META semantics, was Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 09:52:19 -0400
Message-ID: <x49d3u7soh8.fsf@segfault.boston.devel.redhat.com>
References: <20100727175418.GF6820@quack.suse.cz>
	<20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org>
	<20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org>
	<20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org>
	<20100728090025.GA9252@lst.de> <4C4FF42C.1050701@suse.de>
	<1280309335.2502.14.camel@localhost> <20100728093532.GA11862@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab0G1NxV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 09:53:21 -0400
In-Reply-To: <20100728093532.GA11862@lst.de> (Christoph Hellwig's message of
	"Wed, 28 Jul 2010 11:35:32 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Steven Whitehouse <steve@chygwyn.com>, Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, konishi.ryusuke@lab.ntt.co.jp

Christoph Hellwig <hch@lst.de> writes:

> On Wed, Jul 28, 2010 at 10:28:55AM +0100, Steven Whitehouse wrote:
>> The META tag is used in GFS2 for tagging all metadata whether to the
>> journal or otherwise. Is there some reason why this isn't correct? My
>> understanding was that it was more or less an informational hint to
>> those watching blktrace,
>
> Unfortunately the META flag is overloaded in the CFQ I/O scheduler.
> It gives META requests a boost over other, including synchronous
> request.

Within a single process, when choosing the next request to be serviced,
if both requests are synchronous and one is tagged as metadata, then the
metadata request is chosen.

Also, as you mention, a request tagged as metadata will also allow the
issuing process to preempt another process that currently has the I/O
scheduler.  Note that this isn't the intention of the code;  it's
actually a bug, I think:

	/*
	 * So both queues are sync. Let the new request get disk time if
	 * it's a metadata request and the current queue is doing regular IO.
	 */
	if (rq_is_meta(rq) && !cfqq->meta_pending)
		return true;

But, it seems to me that there is no guarantee that both cfq_queues are
synchronous at this point!  Probably some code reshuffling has caused
this to happen.

> From all I could gather so far it's intended to give desktops better
> interactivity by boosting some metadata reads, while it should in that
> form never be used for writes.

Unfortunately, I don't know the history of this code.  The commit
messages are too vague to be useful:

    cfq-iosched: fix bad return value cfq_should_preempt()
    
    Commit a6151c3a5c8e1ff5a28450bc8d6a99a2a0add0a7 inadvertently
    reversed a preempt condition check, potentially causing a
    performance regression.  Make the meta check correct again.

It's anyone's guess as to what the performance regression "potentially"
was.

commit 374f84ac39ec7829a57a66efd5125d3561ff0e00
Author: Jens Axboe <axboe@suse.de>
Date:   Sun Jul 23 01:42:19 2006 +0200

    [PATCH] cfq-iosched: use metadata read flag
    
    Give meta data reads preference over regular reads, as the process
    often needs to get that out of the way to do the io it was actually
    interested in.
    
    Signed-off-by: Jens Axboe <axboe@suse.de>

Again, no idea what the affected workloads are.  I have to admit, though
it sounds like a good idea.  ;-)  Jens, if you know what types of
workloads are affected, then I can put together some tests and submit a
patch to fix the above logic.

> So far I failed badly in getting a clarification of which read requests
> need to be tagged and if we should not apply this boost to write request
> marked META so that they can be used for blktrace tagging.  Unless
> we really want to boost all reads separating the META from the BOOST
> flag might be a good option, but I really need to understand better
> how it's supposed to use.

I think it makes sense to split out the flag into two: one for blktrace
annotation and the other for boosted I/O priority.  Hopefully we can
come up with some real world use cases that shows the benefits of the
latter.

Cheers,
Jeff

> Except for gfs2 big hammer tagging it's used in ext3/ext4 for all
> reads on directories, the quota file and for reading the actual inode
> structure.  It's not used for indirect blocks, symlinks, the superblock
> and allocation bitmaps.
>
> XFS appears to set the META flag for both reads and writes, but that
> code is unreachable currently.  I haven't removed it yet as I'm still
> wondering if it could be used correctly instead.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

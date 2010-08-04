From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH] Flush only barriers (Was: Re: [RFC] relaxed barrier
 semantics)
Date: Wed, 4 Aug 2010 11:29:16 -0400
Message-ID: <20100804152916.GA11807@redhat.com>
References: <20100728092859.GA11096@lst.de>
 <20100729014431.GD4506@thunk.org>
 <20100729024334.GA21736@redhat.com>
 <20100729084225.GA30446@lst.de>
 <20100729200217.GD28704@redhat.com>
 <20100729200655.GB17767@lst.de>
 <20100730031721.GA31762@redhat.com>
 <20100730070732.GA6291@lst.de>
 <20100802182804.GD19740@redhat.com>
 <20100803130347.GA25643@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab0HDP3d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Aug 2010 11:29:33 -0400
Content-Disposition: inline
In-Reply-To: <20100803130347.GA25643@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Tue, Aug 03, 2010 at 03:03:47PM +0200, Christoph Hellwig wrote:
> On Mon, Aug 02, 2010 at 02:28:04PM -0400, Vivek Goyal wrote:
> > Hi Christoph,
> > 
> > Please find attached a new version of patch where I am trying to implement
> > flush only barriers. Why do that? I was thinking that it would nice to avoid
> > elevator drains with WCE=1.
> > 
> > Here I have a DRAIN queue and I seem to be issuing post-flush only after
> > barrier has finished. Need to find some device with TAG queue also to test.
> > 
> > This is still a very crude patch where I need to do lot of testing to see if
> > things are working. For the time being I have just hooked up ext3 to use
> > flush barrier and verified that in case of WCE=0 we don't issue barrier
> > and in case of WCE=1 we do issue barrier with pre flush and postflush.
> > 
> > I don't yet have found a device with FUA and tagging support to verify 
> > that functionality.
> 
> There are not devices that use the tagging support.  Only brd and virtio
> every use the QUEUE_ORDERED_TAG type.  For brd Nick chose it at random,
> and it really doesn't matter when we're dealing with a ramdisk.  For
> virtio-blk it's only used by lguest which only allows a signle
> outstanding command anyway.

What about qemu-kvm? Who imposes this single request in queue limitation?
A quick look at virtio-blk driver code did not suggest anything like that. 

> In short we can just remove it once we
> stop draining for the other modes.
> 
> > o On storage with write cache, for empty barrier, only pre-flush is done.
> >   For barrier request with some data one of following should happen depending
> >   on queue capability.
> > 
> > 	Draining queue
> > 	--------------
> > 	preflush ==> barrier (FUA)
> > 	preflush ==> barrier ===> postflush
> > 	
> > 	Ordered Queue
> > 	-------------
> > 	preflush-->barrier (FUA)
> > 	preflush --> barrier ---> postflush
> > 
> > 	===> Wait for previous request to finish
> > 	---> Issue an ordered request in Tagged queue.
> 
> with ordered you mean the unused _TAG mode?

Yes. If nobody is using it, then we can probably drop it but some of the
mails in the thread suggested scsi controllers can support tagged/ordered
queues very well. If so then whole barrier problem is really simplified
a lot without losing performance. That would suggest that instead of
dropping the TAG queue support we should move in the direction of figuring
out how to enable it for scsi devices.

> 
> >   - Not sure how to avoid this drain. Trying to allow other non-barrier
> >     requests to dispatch while we wait for pre-flush/flush barrier to finish
> >     will make code more complicated.
> 
> That's pretty much where I got stuck, too.  Thanks for doing this, but
> I'd be surprised if it really gives us all that much benefits for real
> life workloads.

True. Without getting rid of draining completely performance benefits
might not be there.

May be file systems can take care of ordering completely. You alredy
modifed blkdev_issue_flush() to convert it to just flush reqeust and
it is no longer a barrier. So file systems can always issue flush first
and then issue the dependent commit request with FUA. 

That will bring us back to question of FUA emulation. Can the queue
capability be exposed to file systems so that they issue a post flush
after commit block if device does not support FUA. 

Vivek

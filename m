From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH] Flush only barriers (Was: Re: [RFC] relaxed barrier semantics)
Date: Tue, 3 Aug 2010 15:03:47 +0200
Message-ID: <20100803130347.GA25643@lst.de>
References: <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <20100729024334.GA21736@redhat.com> <20100729084225.GA30446@lst.de> <20100729200217.GD28704@redhat.com> <20100729200655.GB17767@lst.de> <20100730031721.GA31762@redhat.com> <20100730070732.GA6291@lst.de> <20100802182804.GD19740@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:36172 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab0HCNES (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Aug 2010 09:04:18 -0400
Content-Disposition: inline
In-Reply-To: <20100802182804.GD19740@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Mon, Aug 02, 2010 at 02:28:04PM -0400, Vivek Goyal wrote:
> Hi Christoph,
> 
> Please find attached a new version of patch where I am trying to implement
> flush only barriers. Why do that? I was thinking that it would nice to avoid
> elevator drains with WCE=1.
> 
> Here I have a DRAIN queue and I seem to be issuing post-flush only after
> barrier has finished. Need to find some device with TAG queue also to test.
> 
> This is still a very crude patch where I need to do lot of testing to see if
> things are working. For the time being I have just hooked up ext3 to use
> flush barrier and verified that in case of WCE=0 we don't issue barrier
> and in case of WCE=1 we do issue barrier with pre flush and postflush.
> 
> I don't yet have found a device with FUA and tagging support to verify 
> that functionality.

There are not devices that use the tagging support.  Only brd and virtio
every use the QUEUE_ORDERED_TAG type.  For brd Nick chose it at random,
and it really doesn't matter when we're dealing with a ramdisk.  For
virtio-blk it's only used by lguest which only allows a signle
outstanding command anyway.  In short we can just remove it once we
stop draining for the other modes.

> o On storage with write cache, for empty barrier, only pre-flush is done.
>   For barrier request with some data one of following should happen depending
>   on queue capability.
> 
> 	Draining queue
> 	--------------
> 	preflush ==> barrier (FUA)
> 	preflush ==> barrier ===> postflush
> 	
> 	Ordered Queue
> 	-------------
> 	preflush-->barrier (FUA)
> 	preflush --> barrier ---> postflush
> 
> 	===> Wait for previous request to finish
> 	---> Issue an ordered request in Tagged queue.

with ordered you mean the unused _TAG mode?

>   - Not sure how to avoid this drain. Trying to allow other non-barrier
>     requests to dispatch while we wait for pre-flush/flush barrier to finish
>     will make code more complicated.

That's pretty much where I got stuck, too.  Thanks for doing this, but
I'd be surprised if it really gives us all that much benefits for real
life workloads.


From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH] Flush only barriers (Was: Re: [RFC] relaxed barrier semantics)
Date: Wed, 4 Aug 2010 18:21:54 +0200
Message-ID: <20100804162154.GA7016@lst.de>
References: <20100729014431.GD4506@thunk.org> <20100729024334.GA21736@redhat.com> <20100729084225.GA30446@lst.de> <20100729200217.GD28704@redhat.com> <20100729200655.GB17767@lst.de> <20100730031721.GA31762@redhat.com> <20100730070732.GA6291@lst.de> <20100802182804.GD19740@redhat.com> <20100803130347.GA25643@lst.de> <20100804152916.GA11807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100804152916.GA11807@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 04, 2010 at 11:29:16AM -0400, Vivek Goyal wrote:
> > There are not devices that use the tagging support.  Only brd and virtio
> > every use the QUEUE_ORDERED_TAG type.  For brd Nick chose it at random,
> > and it really doesn't matter when we're dealing with a ramdisk.  For
> > virtio-blk it's only used by lguest which only allows a signle
> > outstanding command anyway.
> 
> What about qemu-kvm? Who imposes this single request in queue limitation?
> A quick look at virtio-blk driver code did not suggest anything like that. 

qemu never used that mode exactly because it's buggy.  It has no way to
actually send a cache flush request (aka empty barrier), and to
implement the ordering by tag properly in a Unix userspace program
we just need to do the drain we currently do in the host kernel inside
qemu/lguest.

> > with ordered you mean the unused _TAG mode?
> 
> Yes. If nobody is using it, then we can probably drop it but some of the
> mails in the thread suggested scsi controllers can support tagged/ordered
> queues very well. If so then whole barrier problem is really simplified
> a lot without losing performance. That would suggest that instead of
> dropping the TAG queue support we should move in the direction of figuring
> out how to enable it for scsi devices.

scsi controllers can in theory, but the scsi layer can't without major
work.  I don't mind using ordering by tag, but I'd rather see an
actually working implementation instead of code that doesn't actually
get used and this almost by defintion is getting buggy sooner or later.

> That will bring us back to question of FUA emulation. Can the queue
> capability be exposed to file systems so that they issue a post flush
> after commit block if device does not support FUA. 

Doing the pre and post flushes from the filesystem does mean that

 a) we add a lot of complexity to every single filesystem instead
    of doing it once
 b) much higher latency as we need to go through a lot more layers
    compared to the current implementation.  E.g. for XFS moving
    the log state machines means first waking up a per-cpu kernel
    thread.


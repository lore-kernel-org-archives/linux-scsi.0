From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced flush
Date: Fri, 13 Aug 2010 15:17:22 +0200
Message-ID: <20100813131722.GB4140@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <4C6540C5.8070108@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C6540C5.8070108@vlnb.net>
Sender: linux-raid-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, jack@suse.cz, rwheeler@redhat.com, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 13, 2010 at 04:55:33PM +0400, Vladislav Bolkhovitin wrote:
> I'm not mentioning the obvious that a common functionality (enforcing 
> requests ordering in this case) should be handled by a common library, 
> but not internally by a zillion file systems Linux has.

I/O ordering is still handled mostly by common code, that is the
pagecache and the buffercache, although a few filesystems like XFS and
btrfs have their own implementation of the second one.

The current ordered semantics of barriers have only successfull
implemented by a complete queue drain, and not effectively been used
by filesystems.  This patchset removes the bogus global ordering
enforced by the block layer whenever a filesystems wants to be able
to use cache flushes, and because of that allows deeper outstanding
queue depth I/O with less latency.

Now I know you in particular are a fan of scsi ordered tags.  And as I
told you before I'm open to review such an implementation if it shows
us any advantages.  Adding it after this patch is in fact not any more
complicated than before, I'd almost be tempted it's easier as you don't
have to plug it into the complex state machine we used for barriers, and
more importantly we drop the requirement for the barrier sequence to
be atomic, which in fact made implementing barriers using tagged queues
impossible with the current scsi layer.

As far as playing with ordered tags it's just adding a new flag for
it on the bio that gets passed down to the driver.  For a final version
you'd need a queue-level feature if it's supported, but you don't
even need that for the initial work.  Then you can implement a
variant of blk_do_flush that does away with queueing additional requests
once finish but queues all two or three at the same time with your
new ordered flag set, at which point you are back to the level or
ordered tag usage that the old code allows.  You're still left with
all the hard problems of actually implementing error handling for it
and using it higher up in the filesystem and generic page cache code.

I'd really love to see your results, up to the point of just trying
that once I get a little spare time.  But my theory is that it won't
help us - the problem with ordered tags is that they enforce global
ordering while we currently have local ordering.  While it will reduce
the latency for the process waiting for an fsync or similar it will
affect other I/O going on in the background and reduce the devices
ability to reorder that I/O.

So for now this patch set is a massive improvement of performance for
workloads we care about, while removing the interface we put in place
to allow a theoretical optimization that didn't show up for 8 years
before, and in fact made the interface just complicated enough to make
that optimization so hard.

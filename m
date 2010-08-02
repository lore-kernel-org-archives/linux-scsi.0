From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] relaxed barrier semantics
Date: Mon, 2 Aug 2010 13:39:30 -0400
Message-ID: <20100802173930.GP16630@think>
References: <20100727175418.GF6820@quack.suse.cz>
 <20100727183546.GG7347@redhat.com>
 <4C4FE58C.8080403@kernel.org>
 <20100728082447.GA7668@lst.de>
 <4C4FECFE.9040509@kernel.org>
 <20100728085048.GA8884@lst.de>
 <4C4FF136.5000205@kernel.org>
 <20100728090025.GA9252@lst.de>
 <4C4FF592.9090800@kernel.org>
 <20100728092859.GA11096@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100728092859.GA11096@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 28, 2010 at 11:28:59AM +0200, Christoph Hellwig wrote:
> On Wed, Jul 28, 2010 at 11:17:06AM +0200, Tejun Heo wrote:
> > Well, if disabling barrier works around the problem for them (which is
> > basically what was suggeseted in the first message), that's not too
> > bad for short term, I think.
> 
> It's a pretty horrible workaround.  Requiring manual mount options to
> get performance out of a setup which could trivially work out of the
> box is a bad workaround.
> 
> > I'll re-read barrier code and see how hard it would be to implement a
> > proper solution.
> 
> If we move all filesystems to non-draining barriers with pre- and post-
> flushes that might actually be a relatively easy first step.  We don't
> have the complications to deal with multiple types of barriers to
> start with, and it'll fix the issue for devices without volatile write
> caches completely.
> 
> I just need some help from the filesystem folks to determine if they
> are safe with them.
> 
> I know for sure that ext3 and xfs are from looking through them.  And
> I know reiserfs is if we make sure it doesn't hit the code path that
> relies on it that is currently enabled by the barrier option.
> 
> I'll just need more feedback from ext4, gfs2, btrfs and nilfs folks.
> That already ends our small list of barrier supporting filesystems, and
> possibly ocfs2, too - although the barrier implementation there seems
> incomplete as it doesn't seem to flush caches in fsync.

Btrfs is going to be similar to xfs, except because of COW we have to
always pretend someone is extending the file (or filling a hole).

The short answer is that a preflush of the disk cache, followed by FUA
for commits is fine.  Btrfs explicitly waits for all the bios it sends
down without trusting other layers for silent ordering.

The long answer is the btrfs commit is basically:

wait for bio completion of a bunch of different things
write new super block pointing to new tree roots with barrier

Everything we waited for must be fully on disk before the new super
block, and the new super must be fully on disk after we wait for the bh.

I regret putting the ordering into the original barrier code...it
definitely did help reiserfs back in the day but it stinks of magic and
voodoo.

When it goes wrong, we'll only notice .000000001% of the time, and even
then it'll only be when people report some random corruption which we'll
blindly blame on either axboe or the drive.

-chris


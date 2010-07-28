From: Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 11:19:57 +0100
Message-ID: <1280312397.2502.49.camel@localhost>
References: <20100727165627.GA474@lst.de>
	 <20100727175418.GF6820@quack.suse.cz> <20100727183546.GG7347@redhat.com>
	 <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de>
	 <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de>
	 <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de>
	 <4C4FF592.9090800@kernel.org>  <20100728092859.GA11096@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100728092859.GA11096@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

Hi,

On Wed, 2010-07-28 at 11:28 +0200, Christoph Hellwig wrote:
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

GFS2 uses barriers only on journal flushing. There are three reasons for
flushing the journal:

1. Its full and we need more space (or the periodic timer has expired,
and there is at least one transaction to flush)
2. We are doing fsync or a full fs sync
3. We need to release a glock to another node, and that glock has some
journaled blocks associated with it

In case #1, I don't think there is any need to actually issue a flush
along with the barrier - the fs will always be correct in case of a (for
example) power failure and it is only the amount of data which might be
lost which depends on the write cache size. This is basically the same
for any local filesystem.

In case #2 we must always flush

In case #3 we need to be certain that all I/O up to and including the
barrier (and subsequent written back in-place metadata, if any) has
reached the storage device (and is not still lurking in the I/O
elevator) before we release the lock, but there is no actual need to
flush the write cache of the device itself. In other words, we need to
flush the non-shared bit of the stack, but not the shared bit on the
device itself. The same caveats about the amount of data which may be
lost on power failure apply as per case #1.

I have also made the assumption that a barrier issued from one node to
the shared device will affect I/O from all nodes equally. If that is not
the case, then the above will not apply and we must always flush in case
#3.

Currently the code is also waiting for I/O to drain in cases #1 and #3
as well as case #2 since it was simpler to implement all cases the same,
at least to start with.

Also in case #3, if we were to implement a non-flushing barrier, then we
would need to add a barrier after the in-place metadata writeback of the
inode that is being released I think, in order to be sure cross-node
ordering was correct. Hmmm. Maybe we should be doing that anyway....

Steve.



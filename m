From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Wed, 28 Jul 2010 13:45:16 +0200
Message-ID: <20100728114516.GA17886@lst.de>
References: <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <1280312397.2502.49.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1280312397.2502.49.camel@localhost>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 28, 2010 at 11:19:57AM +0100, Steven Whitehouse wrote:
> In case #1, I don't think there is any need to actually issue a flush
> along with the barrier - the fs will always be correct in case of a (for
> example) power failure and it is only the amount of data which might be
> lost which depends on the write cache size. This is basically the same
> for any local filesystem.

For now we're mostly talking about removing the _ordering_ not the
flushing.  Eventually I'd like to relax some of the flushing
requirements, too - but that is secondary priority.

So for now I'm mostly interested if gfs2 relies on the ordering
semantics from barriers.  Given that it's been around for a while
and primarily used on devices without any kind of barriers support
I'm inclined it is, but I'd really prefer to get this from the horses
mouth.

> I have also made the assumption that a barrier issued from one node to
> the shared device will affect I/O from all nodes equally. If that is not
> the case, then the above will not apply and we must always flush in case
> #3.

There is absolutely no ordering vs other nodes.  The volatile write
cache if present is a per-target state so it will be flushed for all
nodes.

> Currently the code is also waiting for I/O to drain in cases #1 and #3
> as well as case #2 since it was simpler to implement all cases the same,
> at least to start with.

Aka gfs2 waits for the I/O completion by itself.  That sounds like it
is the answer to my original question.


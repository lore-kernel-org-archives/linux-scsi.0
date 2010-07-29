From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 10:42:25 +0200
Message-ID: <20100729084225.GA30446@lst.de>
References: <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <20100729024334.GA21736@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100729024334.GA21736@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Ted Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 28, 2010 at 10:43:34PM -0400, Vivek Goyal wrote:
> I guess we will require something like set_buffer_preflush_fua() kind of
> operation so that we preflush the cache to make sure everything before
> commit block is on platter and then do commit block write with FUA
> to make sure commit block is on platter.

No more messing with buffer flags for barriers / cache flush options
please.  It's a flag for the I/O submission, not buffer state.  See
my patch from June to remove BH_Ordered if you're interested.

> This is assuming that before issuing commit block request we have waited
> for completion of rest of the journal data. This will make sure none of
> that journal data is in request queue. Then if we issue commit with 
> preflush and FUA, it should make sure all the journal blocks are on
> disk and then commit block is on disk.
> 
> So as long as we wait in filesystem for completion of the requests commit
> block is dependent on, before we issue commit request, we should not
> require request queue drain and preflush and FUA write probably should
> be fine.

We do not require the drain for that case.  The flush is more difficult,
because it's entirely possible that we have state that we require to be
on disk before writing out a log buffer.  For XFS that's two cases:

 (1) we require the actual file data to be on disk before logging the
     file size update to avoid stale data exposure in case the log
     buffer hits the disk before the data
 (2) we require that the buffers writing back metadata actually made it
     to disk before pushing the log tail

(1) means we'll always a pre-flush when a log buffer contains a size
update from an appending write.
(2) means we need to more complicated tracking of the tail lsn, e.g.
by caching it somewhere and only updating the cached value after a
cache flush happened, with a way to force one if needed.

All that is at least as complicated as it sounds.  While I have a
working prototype just going with the relaxed barriers as a first step
is probably.

> IIUC, blkdev_issue_flush() is just a hard barrier and will drain queue
> and flush the cache.

Exactly.


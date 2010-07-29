From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 13:16:14 +0200
Message-ID: <20100729111613.GB3757@quack.suse.cz>
References: <4C4FE58C.8080403@kernel.org>
 <20100728082447.GA7668@lst.de>
 <4C4FECFE.9040509@kernel.org>
 <20100728085048.GA8884@lst.de>
 <4C4FF136.5000205@kernel.org>
 <20100728090025.GA9252@lst.de>
 <4C4FF592.9090800@kernel.org>
 <20100728092859.GA11096@lst.de>
 <20100729014431.GD4506@thunk.org>
 <20100729083142.GA30077@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab0G2LQn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2010 07:16:43 -0400
Content-Disposition: inline
In-Reply-To: <20100729083142.GA30077@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Thu 29-07-10 10:31:42, Christoph Hellwig wrote:
> On Wed, Jul 28, 2010 at 09:44:31PM -0400, Ted Ts'o wrote:
> > Define "are safe" --- what interface we planning on using for the
> > non-draining barrier?  At least for ext3, when we write the commit
> > record using set_buffer_ordered(bh), it assumes that this will do a
> > flush of all previous writes and that the commit will hit the disk
> > before any subsequent writes are sent to the disk.  So turning the
> > write of a buffer head marked with set_buffered_ordered() into a FUA
> > write would _not_ be safe for ext3.
> 
> Please be careful with your wording.  Dou you really mean
> "all previous writes" or "all previous writes that were completed".
> 
> My reading of the ext3/jbd code we explicitly wait on I/O completion
> of dependent writes, and only require those to actually be stable
> by issueing a flush.   If that wasn't the case the default ext3
> barriers off behaviour would not only be dangerous on devices with
> volatile write caches, but also on devices that do not have them,
> which in addition to the reading of the code is not what we've seen
> in actual power fail testing, where ext3 does well as long as there
> is no volatile write cache.
  Yes, ext3 waits for all buffers it needs before writing the commit block
with ordered flag to disk. So preflush + FUA write of commit block is OK
for ext3. Note: We really rely on commit block being on disk before
transaction commit finishes because at that moment we allow reallocation
of blocks freed by the committed transaction. And if they are reallocated
for data, they can get overwritten as soon as they are reallocated, so
we have to be sure they are percieved as free even after journal replay.

> Any, the pre-flush semantics are what the relaxe barriers will
> preservere.  REQ_FUA is a separate interface, which we actually have
> already inside the block layer, we'll just need to emulate it for
> devices withot the FUA bit and handle it in dm and md.
> 
> > For ext4, if we don't use journal checksums, then we have the same
> > requirements as ext3, and the same method of requesting it.  If we do
> > use journal checksums, what ext4 needs is a way of assuring that no
> > writes after the commit are reordered with respect to the disk platter
> > before the commit record --- but any of the writes before that,
> > including the commit, and be reordered because we rely on the checksum
> > in the commit record to know at replay time whether the last commit is
> > valid or not.  We do that right now by calling blkdev_issue_flush()
> > with BLKDEF_IFL_WAIT after submitting the write of the commit block.
> 
> blkdev_issue_flush is just am empty barrier, and the current barriers
> prevent any kind of reordering.  I'd rather avoid adding a one way
> reordering prevention.
> 
> Given that we don't appear to actually need the full reordering
> prevention even without the journal checksums why do you have stricter
> requirements when they are enabled?
  Because Ted found out it actually improves performance - see message
of commit 0e3d2a6313d03413d93327202a60256d1d726fdc. At that time we
thought it's because the latency of forcing commit block to the platter
after flushing caches is still noticeable. But maybe it's something else.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

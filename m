From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] relaxed barrier semantics
Date: Sat, 31 Jul 2010 02:35:20 +0200
Message-ID: <20100731003520.GB3273@quack.suse.cz>
References: <4C4FE58C.8080403@kernel.org>
 <20100728082447.GA7668@lst.de>
 <4C4FECFE.9040509@kernel.org>
 <20100728085048.GA8884@lst.de>
 <4C4FF136.5000205@kernel.org>
 <20100728090025.GA9252@lst.de>
 <4C4FF592.9090800@kernel.org>
 <20100728092859.GA11096@lst.de>
 <20100729014431.GD4506@thunk.org>
 <4C51DA1F.2040701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C51DA1F.2040701@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Ted Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Thu 29-07-10 15:44:31, Ric Wheeler wrote:
> On 07/28/2010 09:44 PM, Ted Ts'o wrote:
> >On Wed, Jul 28, 2010 at 11:28:59AM +0200, Christoph Hellwig wrote:
> >>If we move all filesystems to non-draining barriers with pre- and post-
> >>flushes that might actually be a relatively easy first step.  We don't
> >>have the complications to deal with multiple types of barriers to
> >>start with, and it'll fix the issue for devices without volatile write
> >>caches completely.
> >>
> >>I just need some help from the filesystem folks to determine if they
> >>are safe with them.
> >>
> >>I know for sure that ext3 and xfs are from looking through them.  And
> >>I know reiserfs is if we make sure it doesn't hit the code path that
> >>relies on it that is currently enabled by the barrier option.
> >>
> >>I'll just need more feedback from ext4, gfs2, btrfs and nilfs folks.
> >>That already ends our small list of barrier supporting filesystems, and
> >>possibly ocfs2, too - although the barrier implementation there seems
> >>incomplete as it doesn't seem to flush caches in fsync.
> >Define "are safe" --- what interface we planning on using for the
> >non-draining barrier?  At least for ext3, when we write the commit
> >record using set_buffer_ordered(bh), it assumes that this will do a
> >flush of all previous writes and that the commit will hit the disk
> >before any subsequent writes are sent to the disk.  So turning the
> >write of a buffer head marked with set_buffered_ordered() into a FUA
> >write would _not_ be safe for ext3.
> 
> I confess that I am a bit fuzzy on FUA, but think that it means that
> any FUA tagged IO will go down to persistent store before returning.
> 
> If so, then all order dependent IO would need to be issued in order
> and tagged with FUA. It would not suffice to tag just the commit
> record as FUA, or do I misunderstand what FUA does?
  Ric, I think you misunderstood it a bit. I think the proposal for ext3
was to write ordered data + metadata to the journal except for transaction
commit block, then issue SYNCHRONIZE_CACHE and then write transaction
commit block either with FUA bit set or without it and call
SYNCHRONIZE_CACHE after that as well.
  The difference from the current behavior would be that we save the queue
draining we do these days...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

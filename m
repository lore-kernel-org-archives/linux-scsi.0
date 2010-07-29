From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 09:54:50 -0700
Message-ID: <20100729165449.GC25490@mail.oracle.com>
References: <20100728082447.GA7668@lst.de>
 <4C4FECFE.9040509@kernel.org>
 <20100728085048.GA8884@lst.de>
 <4C4FF136.5000205@kernel.org>
 <20100728090025.GA9252@lst.de>
 <4C4FF592.9090800@kernel.org>
 <20100728092859.GA11096@lst.de>
 <20100728124720.GA3613@quack.suse.cz>
 <20100728230010.GA13406@lst.de>
 <20100729104529.GA3757@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:55645 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab0G2Q5N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2010 12:57:13 -0400
Content-Disposition: inline
In-Reply-To: <20100729104529.GA3757@quack.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Thu, Jul 29, 2010 at 12:45:30PM +0200, Jan Kara wrote:
> On Thu 29-07-10 01:00:10, Christoph Hellwig wrote:
> > On Wed, Jul 28, 2010 at 02:47:20PM +0200, Jan Kara wrote:
> > >   Well, ocfs2 uses jbd2 for journaling so it supports barriers out of the
> > > box and does not need the ordering. ocfs2_sync_file is actually correct
> > > (although maybe slightly inefficient) because it does
> > > jbd2_journal_force_commit() which creates and immediately commits a
> > > transaction and that implies a barrier.
> > 
> > I don't think that's correct.  ocfs2_sync_file first does
> > ocfs2_sync_inode, which does a completely superflous filemap_fdatawrite,
> > and from what I can see a just as superflous sync_mapping_buffers (given
> > that ocfs doesn't use mark_buffer_dirty_inode) and then might return
> > early in case we do fdatasync but the inode isn't marked
> > I_DIRTY_DATASYNC.  In that case we might need a cache flush given
> > that the data might still be dirty.
>   Ah, I see. You're right, fdatasync case is buggy. I'll send Joel a fix.

	I can certainly see our code being inefficient if the
handled-for-us behaviors of sync have changed.  If the VFS is already
doing some work for us, maybe we don't need to do it.  But we have to be
sure that these calls are always going through those paths.  We sync our
files to disk when we drop cluster locks, regardless of whether there is
a userspace fsync().
	I guess I never knew that data could be dirty without the
I_DIRTY_DATASYNC bit.

Joel

-- 

"Copy from one, it's plagiarism; copy from two, it's research."
        - Wilson Mizner

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127

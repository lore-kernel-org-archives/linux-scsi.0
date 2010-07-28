From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 01:00:10 +0200
Message-ID: <20100728230010.GA13406@lst.de>
References: <20100727183546.GG7347@redhat.com> <4C4FE58C.8080403@kernel.org> <20100728082447.GA7668@lst.de> <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100728124720.GA3613@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:50354 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774Ab0G1XAo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 19:00:44 -0400
Content-Disposition: inline
In-Reply-To: <20100728124720.GA3613@quack.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Wed, Jul 28, 2010 at 02:47:20PM +0200, Jan Kara wrote:
>   Well, ocfs2 uses jbd2 for journaling so it supports barriers out of the
> box and does not need the ordering. ocfs2_sync_file is actually correct
> (although maybe slightly inefficient) because it does
> jbd2_journal_force_commit() which creates and immediately commits a
> transaction and that implies a barrier.

I don't think that's correct.  ocfs2_sync_file first does
ocfs2_sync_inode, which does a completely superflous filemap_fdatawrite,
and from what I can see a just as superflous sync_mapping_buffers (given
that ocfs doesn't use mark_buffer_dirty_inode) and then might return
early in case we do fdatasync but the inode isn't marked
I_DIRTY_DATASYNC.  In that case we might need a cache flush given
that the data might still be dirty.


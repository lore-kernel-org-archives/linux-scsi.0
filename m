From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 19:02:11 +0200
Message-ID: <20100729170211.GA8718@lst.de>
References: <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100728124720.GA3613@quack.suse.cz> <20100728230010.GA13406@lst.de> <20100729104529.GA3757@quack.suse.cz> <20100729165449.GC25490@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:34731 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab0G2RCt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2010 13:02:49 -0400
Content-Disposition: inline
In-Reply-To: <20100729165449.GC25490@mail.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.k

On Thu, Jul 29, 2010 at 09:54:50AM -0700, Joel Becker wrote:
> handled-for-us behaviors of sync have changed.  If the VFS is already
> doing some work for us, maybe we don't need to do it.  But we have to be
> sure that these calls are always going through those paths.  We sync our
> files to disk when we drop cluster locks, regardless of whether there is
> a userspace fsync().

ocfs2_sync_file only gets called through the fsync inode operation, so
that doesn't happen here.  And if it did the filemap_fdatawrite would
not help at all, given that is only starts writeout, but never waits for
it to finish.


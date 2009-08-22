From: Theodore Tso <tytso@mit.edu>
Subject: Re: O_DIRECT and barriers
Date: Fri, 21 Aug 2009 22:11:37 -0400
Message-ID: <20090822021137.GR9529@mit.edu>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821220852.GM9529@mit.edu> <20090821224518.GG4330@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37572 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933129AbZHVCLo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Aug 2009 22:11:44 -0400
Content-Disposition: inline
In-Reply-To: <20090821224518.GG4330@mail.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jamie Lokier <jamie@shareable.org>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Aug 21, 2009 at 03:45:18PM -0700, Joel Becker wrote:
> On Fri, Aug 21, 2009 at 06:08:52PM -0400, Theodore Tso wrote:
> > http://ext4.wiki.kernel.org/index.php/Clarifying_Direct_IO's_Semantics
> > 
> > Comments are welcome, either on the wiki's talk page, or directly to
> > me, or to the linux-fsdevel or linux-ext4.
> 
> 	In the section on perhaps not waiting for buffered fallback, we
> need to clarify that O_DIRECT reads need to know to look in the
> pagecache.  That is, if we decide that extending O_DIRECT writes without
> fsync can return before the data hits the storage, the caller shouldn't
> also have to call fsync() just to call read() of data they just wrote!

Yeah, I guess we can only do that if the filesystem guarantees
coherence between the page cache and O_DIRECT reads; it's been a long
while since I've studied that code, so I'm not sure whether all
filesystems that support O_DIRECT provide this coherency (since I
thought it was provided in the generic O_DIRECT routines, isn't it?)
or not.

							- Ted

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: O_DIRECT and barriers
Date: Sun, 23 Aug 2009 22:37:56 -0400
Message-ID: <20090824023756.GB775__5571.30654710836$1251081530$gmane$org@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821220852.GM9529@mit.edu> <20090821224518.GG4330@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60470 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbZHXCh4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Aug 2009 22:37:56 -0400
Content-Disposition: inline
In-Reply-To: <20090821224518.GG4330@mail.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>, Jamie Lokier <jamie@shareable.org>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi

On Fri, Aug 21, 2009 at 03:45:18PM -0700, Joel Becker wrote:
> 	In the section on perhaps not waiting for buffered fallback, we
> need to clarify that O_DIRECT reads need to know to look in the
> pagecache.  That is, if we decide that extending O_DIRECT writes without
> fsync can return before the data hits the storage, the caller shouldn't
> also have to call fsync() just to call read() of data they just wrote!

The way the O_DIRECT fallback is implemented currenly is that data does
hit the disk before return, thanks to a:

	err = do_sync_mapping_range(file->f_mapping, pos, endbyte,
					SYNC_FILE_RANGE_WAIT_BEFORE|
					SYNC_FILE_RANGE_WRITE|
					SYNC_FILE_RANGE_WAIT_AFTER);

which I expected to also sync the required metdata to disk, which
it doesn't.    Which btw are really horrible semantics given that
we export that beast to userspace as a separate system call.


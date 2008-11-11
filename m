From: Christoph Hellwig <hch@infradead.org>
Subject: Re: thin provisioned LUN support
Date: Tue, 11 Nov 2008 11:40:29 -0500
Message-ID: <20081111164028.GA29902@infradead.org>
References: <4913028B.6010405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57098 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYKKQlA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2008 11:41:00 -0500
Content-Disposition: inline
In-Reply-To: <4913028B.6010405@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>

Sorry for beeing so late to the game, been on the road for a couple of
days.


Why do most people assume that sending unmap/trim commands for every
deletet extent ASAP is a good idea?  What this means is that we
basically duplicate the space allocator in the array.  Everytime we
free something we don't just have to do a local btree insert in the
filesystem code but another behind a couple of abstractions, and
similarly on each allocation the storage device would have to allocate
from it's pool.  Worth off all the interesting preallocation
optimization we've done in the filesystem, be thos explicit
pre-allocation from the application or implicit ones in the allocator
will be lost due to the abstraction boundary.

So I think not actually doing these on every alloc/free is a good idea.
Instead the filesystem would free bits when big enough regions happen,
which is something simple enough to do with most btree implementations.

That is of course not an excuse for just having the UNMAP as a hint. I
think having the UNMAP a an exact operation that is either guaranteed
to release the underlying space or fail will make the whole storage
setup a lot more robust.  And while odd "unmap block" sizes will make
it a lot harder for the filesystem I think we could find ways to deal
with them, even if it might be ugly in places.

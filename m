From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] block: add support for discard limits
Date: Mon, 02 Nov 2009 13:16:32 -0500
Message-ID: <yq1skcwg5bz.fsf@sermon.lab.mkp.net>
References: <20091029150830.497006534@bombadil.infradead.org>
	<20091029151127.257902381@bombadil.infradead.org>
	<yq1ws2dsh4g.fsf@sermon.lab.mkp.net>
	<20091030050558.GC17714@infradead.org>
	<yq1eioh9hsr.fsf@sermon.lab.mkp.net>
	<1257176376.2472.24.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:64881 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408AbZKBSrZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2009 13:47:25 -0500
In-Reply-To: <1257176376.2472.24.camel@mulgrave.site> (James Bottomley's
	message of "Mon, 02 Nov 2009 09:39:36 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, axboe@kernel.dk, matthew@wil.cx

>>>>> "James" == James Bottomley <James.Bottomley@suse.de> writes:

James> Agree entirely for this with UNMAP, since the array will just
James> silently discard what it doesn't want.

James> Don't necessarily agree with this for WRITE_SAME.  From the
James> implementations I've read, it sounds like the array will discard
James> all sectors within the correct boundary and alignment but it will
James> have to write zeros to all sectors outside of the aligned region
James> ... this sounds like a performance hit unless we do some
James> judicious aligning of the discards.

Depends whether the array firmware tracks partial allocation units or
not.  Some do (and will report allocation units in the block limits VPD
because it's a hint to FS/DB allocators).

Since all vendors I've talked to treat unmaps (whether UNMAP or WRITE
SAME with the UNMAP bit set) asynchronously, I doubt it's a problem.
And they all seem to think that the overhead is minimal.  They say we
can worry about loss of a queue tag, but that we shouldn't worry about
processing time on the back end at all.

Should the problem arise I vote for doing the alignment correction in
the WRITE SAME codepath in sd.c.  Potentially backed by some heuristic.
That solves the problem of information being lost on the way down due to
stacking and whatnot...

-- 
Martin K. Petersen	Oracle Linux Engineering

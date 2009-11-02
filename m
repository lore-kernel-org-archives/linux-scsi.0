From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] block: add support for discard limits
Date: Mon, 02 Nov 2009 08:29:08 -0500
Message-ID: <yq1eioh9hsr.fsf@sermon.lab.mkp.net>
References: <20091029150830.497006534@bombadil.infradead.org>
	<20091029151127.257902381@bombadil.infradead.org>
	<yq1ws2dsh4g.fsf@sermon.lab.mkp.net>
	<20091030050558.GC17714@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:59694 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbZKBN3c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2009 08:29:32 -0500
In-Reply-To: <20091030050558.GC17714@infradead.org> (Christoph Hellwig's
	message of "Fri, 30 Oct 2009 01:05:58 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, axboe@kernel.dk, matthew@wil.cx

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

>> ACS-2 doesn't currently have a notion of unmap granularity and all
>> array vendors I have talked to appear to happily process any unmap
>> request we throw at them.  So I'm leaning towards keeping things
>> simple and just sending things down verbatim...

Christoph> We have all the granularity and alignment information
Christoph> avilable and keeping track of it is simple enough.

That's not the issue.

Nothing prevents you from submitting a misaligned read/write request to
the array.  If you do, the array may be slower in servicing the request.
But the entire request will still be serviced.

Similarly, nothing prevents you from submitting a misaligned unmap
request.  If you do, the array will just ignore the portions that do not
constitute entire allocation units.  Your code is taking what is a hint
and turning it into a hard limit.  Note that it's called OPTIMAL UNMAP
GRANULARITY, not REQUIRED UNMAP GRANULARITY.

Every vendor I have talked to have asked us to always unmap the *entire*
LBA range we're interested in freeing.  No exceptions.

We don't throw away the beginning/end of a read/write request because
it's not properly aligned either, do we?


Christoph> Yes md/dm will need to update the first aligned unmap sector,
Christoph> but they'll also need to update the first aligned LBA for I/O
Christoph> purposes and adding more more is simple enough.

But with md and dm you can have devices with different unmap alignment
and granularity.  With read/write alignment we can throw our hands in
the air and say that things will be slow.  But we'll still submit all
I/O.

With heterogeneous md and dm devices there may not be a meaningful value
to put in the discard granularity field.  Then what?

-- 
Martin K. Petersen	Oracle Linux Engineering

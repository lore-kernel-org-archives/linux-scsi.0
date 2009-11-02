From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/2] block: add support for discard limits
Date: Mon, 02 Nov 2009 09:39:36 -0600
Message-ID: <1257176376.2472.24.camel@mulgrave.site>
References: <20091029150830.497006534@bombadil.infradead.org>
	 <20091029151127.257902381@bombadil.infradead.org>
	 <yq1ws2dsh4g.fsf@sermon.lab.mkp.net> <20091030050558.GC17714@infradead.org>
	 <yq1eioh9hsr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:33698 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990AbZKBPjj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2009 10:39:39 -0500
In-Reply-To: <yq1eioh9hsr.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, axboe@kernel.dk, matthew@wil.cx

On Mon, 2009-11-02 at 08:29 -0500, Martin K. Petersen wrote:
> >>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:
> 
> >> ACS-2 doesn't currently have a notion of unmap granularity and all
> >> array vendors I have talked to appear to happily process any unmap
> >> request we throw at them.  So I'm leaning towards keeping things
> >> simple and just sending things down verbatim...
> 
> Christoph> We have all the granularity and alignment information
> Christoph> avilable and keeping track of it is simple enough.
> 
> That's not the issue.
> 
> Nothing prevents you from submitting a misaligned read/write request to
> the array.  If you do, the array may be slower in servicing the request.
> But the entire request will still be serviced.
> 
> Similarly, nothing prevents you from submitting a misaligned unmap
> request.  If you do, the array will just ignore the portions that do not
> constitute entire allocation units.  Your code is taking what is a hint
> and turning it into a hard limit.  Note that it's called OPTIMAL UNMAP
> GRANULARITY, not REQUIRED UNMAP GRANULARITY.
> 
> Every vendor I have talked to have asked us to always unmap the *entire*
> LBA range we're interested in freeing.  No exceptions.
> 
> We don't throw away the beginning/end of a read/write request because
> it's not properly aligned either, do we?

Agree entirely for this with UNMAP, since the array will just silently
discard what it doesn't want.

Don't necessarily agree with this for WRITE_SAME.  From the
implementations I've read, it sounds like the array will discard all
sectors within the correct boundary and alignment but it will have to
write zeros to all sectors outside of the aligned region ... this sounds
like a performance hit unless we do some judicious aligning of the
discards.

James



From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] block: add support for discard limits
Date: Tue, 3 Nov 2009 10:16:48 -0500
Message-ID: <20091103151648.GC19068@infradead.org>
References: <20091029150830.497006534@bombadil.infradead.org> <20091029151127.257902381@bombadil.infradead.org> <yq1ws2dsh4g.fsf@sermon.lab.mkp.net> <20091030050558.GC17714@infradead.org> <yq1eioh9hsr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50415 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbZKCPQp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 10:16:45 -0500
Content-Disposition: inline
In-Reply-To: <yq1eioh9hsr.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, axboe@kernel.dk, matthew@wil.cx

On Mon, Nov 02, 2009 at 08:29:08AM -0500, Martin K. Petersen wrote:
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

read/write is different.  If we throw parts of it away we lose data, we
don't do for unmap requests.  I'll resend a patch series that moves the
trimming of the range into sd.c as suggested later and make it tunable.
That might not be what we want to keep long term, but it'll allow us
benchmarking both variants on the real life arrays.


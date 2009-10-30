From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] block: add support for discard limits
Date: Thu, 29 Oct 2009 23:19:43 -0400
Message-ID: <yq1ws2dsh4g.fsf@sermon.lab.mkp.net>
References: <20091029150830.497006534@bombadil.infradead.org>
	<20091029151127.257902381@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:19661 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZJ3DVt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2009 23:21:49 -0400
In-Reply-To: <20091029151127.257902381@bombadil.infradead.org> (Christoph
	Hellwig's message of "Thu, 29 Oct 2009 11:08:31 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, axboe@kernel.dk, matthew@wil.cx

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> To properly support discard on SCSI Arrays we need to take
Christoph> the discard granularity and the first aligned discard LBA
Christoph> into account.  This patch adds block limits for both of them,
Christoph> and trims down dicard requests to fit into these limits in
Christoph> blkdev_issue_discard.  We also make sure the alignment offset
Christoph> is properly adjust for partitions and add sysfs files to
Christoph> expose the limits to userspaced.

Do we know for sure that this is really needed?

The reason I'm asking is that in my first attempt I also exposed all
this up the stack.  However, it sucks to keep this in sync and would
require the same level of topology stacking magic as the rest of the
queue limits.  My brain melted at the thought of LVM/MD volumes striped
or mirrored between devices with different unmap granularity and
alignment.

So I talked to a variety of array folks.  And regardless of whether they
implement WRITE SAME or UNMAP they all appear to handle misaligned
requests just fine.  I.e. there may be some mapped residue at the
beginning and end of an unmap request but any full allocation units in
between will be correctly unmapped.  They all told me the alignment and
granularity parameters were purely informational and intended as hints
for laying out data.  Not as hard limits for issuing I/O.

Consequently I gutted all the alignment stuff from my thin provisioning
tree.  I also changed mt scsi_debug code to unmap allocations similar to
the way the arrays work (my first attempt completely ignored misaligned
requests).

ACS-2 doesn't currently have a notion of unmap granularity and all array
vendors I have talked to appear to happily process any unmap request we
throw at them.  So I'm leaning towards keeping things simple and just
sending things down verbatim...

-- 
Martin K. Petersen	Oracle Linux Engineering

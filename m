From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] block: add function to issue compare and write
Date: Sat, 18 Oct 2014 08:16:39 -0700
Message-ID: <20141018151639.GF30355@infradead.org>
References: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
 <1413437835-13778-3-git-send-email-michaelc@cs.wisc.edu>
 <20141017095555.GA360@infradead.org>
 <yq1egu62rnm.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56534 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaJRPQn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Oct 2014 11:16:43 -0400
Content-Disposition: inline
In-Reply-To: <yq1egu62rnm.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, ceph-devel@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 07:38:37PM -0400, Martin K. Petersen wrote:
> The problem with this is that, as it stands, a bio has no type. And it
> would suck if we couldn't keep bio rw and request flags in sync.
> 
> I wonder if it would make more sense to move the remaining rq types to
> cmd_flags after I'm done with the 64-bit conversion?

I'd prefer adding a cmd_type to the bio as well and avoid the 64-bit
flag conversion.  While we'll probably grow more types of I/Os (e.g.
copy offload) I hope we can actually reduce the number of real flags,
and it's easier to read for sure if we can switch on the command type
in the driver.


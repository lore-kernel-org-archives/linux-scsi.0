From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request payload
Date: Wed, 30 Jun 2010 10:42:04 +0200
Message-ID: <20100630084204.GA27609@lst.de>
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-1-git-send-email-snitzer@redhat.com> <1277652576.4366.19.camel@mulgrave.site> <4C2B012B.2000407@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:39541 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab0F3InC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 04:43:02 -0400
Content-Disposition: inline
In-Reply-To: <4C2B012B.2000407@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Wed, Jun 30, 2010 at 11:32:43AM +0300, Boaz Harrosh wrote:
> May I ask a silly question? Why the dynamic allocation?
> 
> Why not have a const-static single global page at the block-layer somewhere
> that will be used for all discard-type operations and be done with it once and
> for all. A single page can be used for any size bio , any number of concurrent
> discards, any ZERO needed operation. It can also be used by other operations
> like padding and others. In fact isn't there one for the libsata padding?

for UNMAP we need to write into the payload.  And for ATA TRIM we need
to write into the WRITE SAME payload.  That's another layering violation
for those looking for them, btw..


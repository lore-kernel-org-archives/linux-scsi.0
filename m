From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 4/4] bidi support: bidirectional request
Date: Tue, 1 May 2007 20:57:20 +0200
Message-ID: <20070501185718.GE4653@kernel.dk>
References: <462261E8.5090005@panasas.com> <200704281948.l3SJm9jS001428@mbox.iij4u.or.jp> <4634BE6B.3000808@panasas.com> <1177872588.3688.79.camel@mulgrave.il.steeleye.com> <20070430111157.GI21015@kernel.dk> <4635D89D.4000500@panasas.com> <20070430115917.GK21015@kernel.dk> <463602AA.2090908@torque.net> <20070430145105.GO21015@kernel.dk> <4637856F.5090404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:4753 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161762AbXEAS6A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 May 2007 14:58:00 -0400
Content-Disposition: inline
In-Reply-To: <4637856F.5090404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Douglas Gilbert <dougg@torque.net>, Benny Halevy <bhalevy@panasas.com>, FUJITA Tomonori <tomof@acm.org>, akpm@osdl.org, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Tue, May 01 2007, Boaz Harrosh wrote:
> Please consider the attached proposal. It is a complete block-level bidi
> implementation that is, I hope, a middle ground which will keep everyone
> happy (including Christoph). It is both quite small and not invasive,
> yet has a full bidi API that is easy to use and maintain.

This isn't much of an improvement imo, if any at all. Why didn't you do
the ->next_rq approach I suggested? Your patch still makes struct
request considerably fatter (30% here, from 280 to 368 bytes on x86-64
from a quick look) for something that will have relatively few uses. And
it still has its paws all over the block layer code.

Please just implement the 2nd data phase as a linked request off the
first one. I think that approach is both much cleaner from a design
perspective, and also much leaner and has zero (well almost, it costs a
pointer) impact on the regular read-write paths.

-- 
Jens Axboe


From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 17 May 2007 20:29:23 +0900
Message-ID: <20070517202923O.fujita.tomonori@lab.ntt.co.jp>
References: <20070517054811.GV23798@kernel.dk>
	<20070517145958P.fujita.tomonori@lab.ntt.co.jp>
	<464C1721.8030009@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:34498 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbXEQLa3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 07:30:29 -0400
In-Reply-To: <464C1721.8030009@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 17 May 2007 11:49:37 +0300

> FUJITA Tomonori wrote:
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Subject: Re: [PATCH v2] add bidi support for block pc requests
> > Date: Thu, 17 May 2007 07:48:13 +0200
> > 
> >> On Thu, May 17 2007, FUJITA Tomonori wrote:
> >>> From: Jens Axboe <jens.axboe@oracle.com>
> >>> Subject: Re: [PATCH v2] add bidi support for block pc requests
> >>> Date: Wed, 16 May 2007 19:53:22 +0200
> >>>
> >>>> On Wed, May 16 2007, Boaz Harrosh wrote:
> >>>>> now there are 2 issues with this:
> >>>>> 1. Even if I do blk_queue_max_phys_segments(q, 127); I still get
> >>>>>    requests for use_sg=128 which will crash the kernel.
> >>>> That sounds like a serious issue, it should definitely not happen. Stuff
> >>>> like that would bite other drivers as well, are you absolutely sure that
> >>>> is happening? Power-of-2 bug in your code, or in the SCSI code?
> >>> Boaz, how do you send requests to the scsi-ml, via fs, sg, or bsg?
> 
> These are regular fs (ext3) requests during bootup. The machine will not
> boot. (Usually from the read ahead code)
> Don't believe me look at the second patch Over Tomo's cleanup.
> If I define SCSI_MAX_SG_SEGMENTS to 127 it will crash even when I
> did in code:
> 	blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
> I suppose someone is looking at a different definition. Or there is
> another call I need to do for this to work.

ata_scsi_slave_config?

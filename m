From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] scsi: explicitly release bidi buffers
Date: Mon, 31 Mar 2014 08:10:41 +0200
Message-ID: <20140331061041.GB13184@lst.de>
References: <1395936862-6938-1-git-send-email-hch@lst.de> <1395936862-6938-2-git-send-email-hch@lst.de> <533903E9.3020300@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60690 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaCaGKo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 02:10:44 -0400
Content-Disposition: inline
In-Reply-To: <533903E9.3020300@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

On Mon, Mar 31, 2014 at 12:58:01AM -0500, Mike Christie wrote:
> 
> Hey,
> 
> I just wanted to double check that the only time we do bidi requests is
> when they come through as REQ_TYPE_BLOCK_PC requests. I saw some of the
> code comments on the init side that indicated that, but there was that
> scsi_end_request() -> scsi_release_buffers() -> __scsi_release_buffers()
>  call which then did not make sense because we were passing in 1 for the
> bidi check argument.

We only support BIDI for REQ_TYPE_BLOCK_PC requests, and scsi_io_completion
enforces this:

	if (req->cmd_type == REQ_TYPE_BLOCK_PC) { /* SG_IO ioctl from block level */
		...

		if (scsi_bidi_cmnd(cmd)) {
			...
			< end_io and return >
		}
	}

	/* no bidi support for !REQ_TYPE_BLOCK_PC yet */
	BUG_ON(blk_bidi_rq(req));


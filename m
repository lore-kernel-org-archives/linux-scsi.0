From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] change scsi_cmd_ioctl to take a gendisk instead of a queue
Date: Sun, 1 Feb 2004 22:13:55 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040201221355.A18561@infradead.org>
References: <20040201124803.A18050@beaverton.ibm.com> <20040201213334.A17988@infradead.org> <20040201134916.A18509@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:3853 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265479AbUBAWOA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Feb 2004 17:14:00 -0500
Content-Disposition: inline
In-Reply-To: <20040201134916.A18509@beaverton.ibm.com>; from patmans@us.ibm.com on Sun, Feb 01, 2004 at 01:49:16PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

On Sun, Feb 01, 2004 at 01:49:16PM -0800, Patrick Mansfield wrote:
> Yes. That would also clean up the upper level driver code (for example,
> sd.c's sd_init_command), but I have not tried this.

Heh, I just took a short look at sd_rw_intr vs rw_intr (sr) and moving
those into common code defintily looks like a good thing.  There's a
bunch of small difference, but I think we'd better off having those
two unified instead of two sets of bugs.  It's probably worth investigating.

> Then in the future we could use sg_io instead of the scsi_do_req,
> scsi_wait_req, etc., and get rid of REQ_CMD in favor of REQ_BLOCK_PC.

Hmmm..  Sound like an interesting path to investigate.  But unlike the
REQ_PC unification it sounds more like a 2.7 thing.


From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/15] scsi: initial blk-mq support
Date: Fri, 7 Feb 2014 04:42:56 -0800
Message-ID: <20140207124256.GA30510@infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
 <20140205124154.337539740@bombadil.infradead.org>
 <1391724663.14985.11.camel@haakon3.risingtidesystems.com>
 <52F49D1E.2000007@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33576 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaBGMnu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 07:43:50 -0500
Content-Disposition: inline
In-Reply-To: <52F49D1E.2000007@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

On Fri, Feb 07, 2014 at 02:45:18AM -0600, Mike Christie wrote:
> Yeah, it would be nice if like in Nick's patches, the driver could just
> set the scsi_host_template->cmd_size then when the scsi_cmnd got to the
> driver's queuecommand, the driver could just get its internal cmd struct
> from the scsi_cmnd struct (for example in Nick's patch it was off the
> SCp.ptr).

You can do this with my series.  The cmd_size support is actually
added in the first series and still works here.

Instead of needing SCp.ptr you just grab the memory right behind
the command.  Right now virtio_scsi opencodes this, but I should
probably add a helper for the next iteration.


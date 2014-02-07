From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/15] scsi: initial blk-mq support
Date: Fri, 7 Feb 2014 04:51:47 -0800
Message-ID: <20140207125147.GA3198@infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
 <20140205124154.337539740@bombadil.infradead.org>
 <1391724663.14985.11.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33620 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbaBGMvt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 07:51:49 -0500
Content-Disposition: inline
In-Reply-To: <1391724663.14985.11.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

> Is there extra scsi_mq_done() part that does IPI here even necessary
> anymore..?
> 
> I was under the assumption that blk_mq_end_io() is already taking care
> of this..?

blk_mq_end_io does it, but given that the SCSI-specific I/O completion
path is non-trivial I'd rather run it on the indicated CPU as well,
similar to how the old blk-softirq code works.  I'll send out a patch
series that should make this area a lot cleaner and avoid having to
implement the IPIs in each driver that wants or needs it soon.

> OK, so your in-lining the allocation of data + protection SGLs from
> blk-mq..
> 
> The original prototype code was doing these allocations separately below
> for each pre-allocated cmd, and offering LLD's to optionally
> pre-allocate their own descripts using sh->hostt->cmd_size if
> necessary..
> 
> This was necessary to eliminate all fast-path allocations for
> virtio-scsi, and I'd like to see something similar here as an optional
> feature as well.

It's present.  The cmd_size host_template parameter is added in the
previous series, and we still take it into account.  

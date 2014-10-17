From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Fri, 17 Oct 2014 04:06:27 -0700
Message-ID: <20141017110627.GD7819@infradead.org>
References: <5433E43D.3010107@acm.org>
 <5433E585.607@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35549 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaJQLGc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Oct 2014 07:06:32 -0400
Content-Disposition: inline
In-Reply-To: <5433E585.607@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

>  	} else {
> +		if (blk_mq_unique_tag_to_hwq(rsp->tag) != ch - target->ch)
> +			pr_err("Channel idx mismatch: tag %#llx <> ch %#lx\n",
> +			       rsp->tag, ch - target->ch);
>  		scmnd = scsi_host_find_tag(target->scsi_host, rsp->tag);

Shouldn't we do this validity check inside scsi_host_find_tag, so that
all callers get it? That means adding an argument to it,  but there are
very few callers at the moment.


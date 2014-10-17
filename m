From: Christoph Hellwig <hch@infradead.org>
Subject: EH action after scsi_remove_host, was: Re: [PATCH v2 12/12] IB/srp:
 Add multichannel support
Date: Fri, 17 Oct 2014 04:01:02 -0700
Message-ID: <20141017110102.GC7819@infradead.org>
References: <5433E43D.3010107@acm.org>
 <5433E585.607@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35332 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaJQLBF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Oct 2014 07:01:05 -0400
Content-Disposition: inline
In-Reply-To: <5433E585.607@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Oct 07, 2014 at 03:07:17PM +0200, Bart Van Assche wrote:
> +	/*
> +	 * Avoid that the SCSI error handler tries to use this channel after
> +	 * it has been freed. The SCSI error handler can namely continue
> +	 * trying to perform recovery actions after scsi_remove_host()
> +	 * returned.
> +	 */
> +	ch->target = NULL;

Do you have a reproducer for that?  I think we should fix the root
cause.


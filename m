From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] block/null_blk: Fix completion processing from LIFO to
 FIFO
Date: Thu, 6 Feb 2014 08:35:42 -0800
Message-ID: <20140206163542.GA30008@infradead.org>
References: <1391704397-26816-1-git-send-email-shlomop@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58093 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaBFQfv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 11:35:51 -0500
Content-Disposition: inline
In-Reply-To: <1391704397-26816-1-git-send-email-shlomop@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shlomo Pongratz <shlomop@mellanox.com>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org

On Thu, Feb 06, 2014 at 06:33:17PM +0200, Shlomo Pongratz wrote:
> The completion queue is implemented using lockless list.
> 
> The llist_add is adds the events to the list head which is a push operation.
> The processing of the completion elements is done by disconnecting all the
> pushed elements and iterating over the disconnected list. The problem is
> that the processing is done in reverse order w.r.t order of the insertion
> i.e. LIFO processing. By reversing the disconnected list which is done in
> linear time the desired FIFO processing is achieved.

I think it should just switch to using __smp_call_function_single
directly, mirroring commit 3d6efbf62c797a2924785f482e4ce8aa8820ec72 for
the blk-mq core.

I've actually a patch in the queue that allows generic request
completion offloading similar to blk_complete_request() in the old
request code, but it'll need a bit more polishing first.


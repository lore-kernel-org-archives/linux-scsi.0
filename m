From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block/null_blk: Fix completion processing from LIFO to
 FIFO
Date: Thu, 6 Feb 2014 12:23:01 -0700
Message-ID: <20140206192301.GC3950@kernel.dk>
References: <1391704397-26816-1-git-send-email-shlomop@mellanox.com>
 <20140206163542.GA30008@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:35123 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbaBFTXH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 14:23:07 -0500
Received: by mail-pb0-f54.google.com with SMTP id uo5so2152117pbc.41
        for <linux-scsi@vger.kernel.org>; Thu, 06 Feb 2014 11:23:06 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140206163542.GA30008@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Shlomo Pongratz <shlomop@mellanox.com>, linux-scsi@vger.kernel.org

On Thu, Feb 06 2014, Christoph Hellwig wrote:
> On Thu, Feb 06, 2014 at 06:33:17PM +0200, Shlomo Pongratz wrote:
> > The completion queue is implemented using lockless list.
> > 
> > The llist_add is adds the events to the list head which is a push operation.
> > The processing of the completion elements is done by disconnecting all the
> > pushed elements and iterating over the disconnected list. The problem is
> > that the processing is done in reverse order w.r.t order of the insertion
> > i.e. LIFO processing. By reversing the disconnected list which is done in
> > linear time the desired FIFO processing is achieved.
> 
> I think it should just switch to using __smp_call_function_single
> directly, mirroring commit 3d6efbf62c797a2924785f482e4ce8aa8820ec72 for
> the blk-mq core.
> 
> I've actually a patch in the queue that allows generic request
> completion offloading similar to blk_complete_request() in the old
> request code, but it'll need a bit more polishing first.

The patch is trivial enough that I may as well just apply it. It's not a
bug as such, but doing FIFO completions does make more sense. I was
aware of this issued, fwiw, it just didn't really matter for my testing
and I opted to avoid a list reversal to make it cheaper.

-- 
Jens Axboe


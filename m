From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: add support for shared tag maps
Date: Thu, 31 Aug 2006 11:00:14 +0200
Message-ID: <20060831090014.GA5528@kernel.dk>
References: <NONAMEBU6CuyzC0bHwr00000ed4@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:29453 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S1750837AbWHaI5W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 04:57:22 -0400
Content-Disposition: inline
In-Reply-To: <NONAMEBU6CuyzC0bHwr00000ed4@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Aug 31 2006, Ed Lin wrote:
> 
> ======= On 2006-08-30 21:44:18, James Bottomley wrote:
> >+
> >+/**
> >+ * blk_free_tags - release a given set of tag maintenance info
> >+ *
> >+ * @bqt:	the tag map to free
> >+ *
> >+ * For externally managed @bqt@ frees the map.  Callers of this
> >+ * function must guarantee to have released all the queues that
> >+ * might have been using this tag map.
> >+ */
> >+void blk_free_tags(struct blk_queue_tag *bqt)
> >+{
> >+	if (unlikely(!__blk_free_tags(bqt)))
> >+		BUG();
> >+}
> >+
> 
> EXPORT_SYMBOL(blk_free_tags) ?
> Also, add new function definitions in blkdev.h?

Good point. James will be reposting it anyways, the patch needed a few
more fixes (memory leak, coding style).

-- 
Jens Axboe


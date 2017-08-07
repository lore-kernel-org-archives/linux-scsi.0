From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 1/2] block: Zoned block device single-threaded submission
Date: Mon, 7 Aug 2017 15:15:55 +0900
Message-ID: <903d537c-3f4e-046b-a251-ac75dfa209ce@wdc.com>
References: <20170804075237.2089-1-damien.lemoal@wdc.com>
 <20170804075237.2089-2-damien.lemoal@wdc.com> <20170805113405.GA16313@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:47877 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751476AbdHGGQq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2017 02:16:46 -0400
In-Reply-To: <20170805113405.GA16313@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Chistoph,

On 8/5/17 20:34, Christoph Hellwig wrote:
> We'll need a blk-mq version as well, otherwise: NAK.

Not that I have not tried, but I do not see how this is possible without
in the end making blk-mq/scsi-mq for a ZBC disk work exactly like the sq
path, that is adding locks/barriers in many places to prevent the mq 3
different contexts form potentially messing with the dispatch queue
order (submission, run and requeue). I do not see any solution simple
enough to be considered RC material.

This patch ensures that for 4.13 we at least have the legacy single
queue I/O path that is safe for zoned block devices. With the other
patch I sent (+ Bart's "always unprep" patch) enduring that mq does not
deadlock (and only that, unaligned write errors can happen with ZBC drives).

Going forward, considering only block-mq/scsi-mq (since the legacy path
will eventually go away), I think that trying to ensure per-zone
sequential writes at the SCSI layer is not a sustainable approach. It
will add too many constraints on the mq path/queue management and will
only make the mq code more complex and very hard to debug any issue with
sequential writes.

I thought of another simpler and easier to maintain approach: extending
the writeback throttling code to implement a "only one write per
sequential zone" I/O pattern, which will always result in sequential
writes within a zone no matter what blk-mq, the mq schedulers or the
scsi dispatch code do. In effect, this is exactly the same as what the
zone locking does currently, but all the implementation would be limited
to the higher bio_submit() level. This would allow removing all the ZBC
specific code in the I/O path (single threaded dispatch, zone lock) and
will not need messing mq I/O path. So overall, a much cleaner and easier
to maintain approach.

Of course, this kind of writeback throttling could be implemented in
each zoned block device user (currently only f2fs and dm-zoned, but
likely more coming). But that would lead to a lot of duplicated code. So
integrating that to bio_submit()/WBT makes sense to me.

What do you think ?

Of course, I may be missing something really simple to solve the problem
in blk-mq. I would be happy to tackle the implementation & testing if
someone has an idea.

Best regards.

-- 
Damien Le Moal,
Western Digital

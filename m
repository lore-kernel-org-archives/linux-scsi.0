From: Christoph Hellwig <hch@lst.de>
Subject: split scsi passthrough fields out of struct request
Date: Mon, 23 Jan 2017 16:29:05 +0100
Message-ID: <1485185361-29786-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56414 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbdAWP31 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2017 10:29:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

Hi all,

this series splits the support for SCSI passthrough commands from the
main struct request used all over the block layer into a separate
scsi_request structure that drivers that want to support SCSI passthough
need to embedded as the first thing into their request-private data,
similar to how we handle NVMe passthrough commands.

To support this I've added support for that the private data after
request structure to the legacy request path instead, so that it can
be treated the same way as the blk-mq path.  Compare to the current
scsi_cmnd allocator that actually is a major simplification.

Compared to the previous RFC version the major change is that dm-mpath
works with this version.  To make it work I've switched the legacy
request dm-rq to use the same clone and map method as the blk-mq version.

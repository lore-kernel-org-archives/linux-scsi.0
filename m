From: Christoph Hellwig <hch@lst.de>
Subject: [RFC] blk-mq: support for shared tags
Date: Mon, 31 Mar 2014 16:46:11 +0200
Message-ID: <1396277175-21382-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Matias Bjorling <m@bjorling.me>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This series adds support for sharing tags (and thus requests) between
multiple request_queues.  We'll need this for SCSI, and I think Martin
also wants something similar for nvme.

Besides the mess with request contructors/destructors the major RFC here
is how the blk_mq_alloc_shared_tags API should look like.  For now I've
been lazy and reused struct blk_mq_reg, but that feels a bit cumbersome.
Either a separate blk_mq_tags_reg or just passing the few arguments directly
would work fine for me.

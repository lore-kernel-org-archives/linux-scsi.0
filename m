From: Christoph Hellwig <hch@lst.de>
Subject: RFC: split scsi passthrough fields out of struct request
Date: Tue, 10 Jan 2017 16:06:05 +0100
Message-ID: <1484060780-15592-1-git-send-email-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

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

There is one major show-stopper for the series as-is:  Request-based
device mapper currently allocate the request structures in the stacking
driver without a knowledge of the queue it's going to be submitte on
for the legacy request path.  It managed to avoid that issue for the
blk-mq path, but that currently can't be used on legacy request devices
for reasons I don't fully understand.  We'll need to figure out how
sort this out, but maybe that's a good opportunity to drop one or two
of the three different dm-mpath I/O paths? :)

Note that the first two patches are 4.10 material and have already
been submitted independently.

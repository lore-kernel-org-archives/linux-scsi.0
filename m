From: Christoph Hellwig <hch@lst.de>
Subject: split scsi passthrough fields out of struct request V3
Date: Fri, 27 Jan 2017 17:34:59 +0100
Message-ID: <1485534918-18239-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
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

Changes since V2:
 - remove req->cmd tracing
 - minor spelling fixes

Changes since V1:
 - fix handling of a NULL sense pointer in __scsi_execute
 - clean up handling of the flush flags in the block layer and MD
 - additional small cleanup in dm-rq

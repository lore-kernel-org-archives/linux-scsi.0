From: Christoph Hellwig <hch@lst.de>
Subject: kill req->errors V3
Date: Wed, 19 Apr 2017 21:26:28 +0200
Message-ID: <20170419192651.22037-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Currently the request structure has an errors field that is used in
various different ways.  The oldest drivers use it as an error count,
blk-mq and the generic timeout code assume that it holds a Linux
errno for block completions, and various drivers use it for internal
status values, often overwriting them with Linux errnos later,
that is unless they are processing passthrough requests in which
case they'll leave their errors in it.

This series kills the ->errors field and replaced it with new fields
in the drivers (or an odd hack in a union in struct request for
two bitrotting old drivers).

Also available in the following git tree:

    git://git.infradead.org/users/hch/block.git request-errors

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/request-errors

Changes since V2;
 - reorder one patch to be earlier in the series
 - fix the argument to a bsg dprintk
 - fix a kerneldoc comment

Changes since V1:
 - rebased on top the latest block for-next tree
 - fix error handling in nfsd blocklayout
 - dropped "scsi: fix fast-fail for non-passthrough requests"

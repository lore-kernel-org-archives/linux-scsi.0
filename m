From: Christoph Hellwig <hch@lst.de>
Subject: kill req->errors V4
Date: Thu, 20 Apr 2017 16:02:53 +0200
Message-ID: <20170420140316.6546-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36129 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S946189AbdDTODa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 10:03:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

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

Changes since V3:
 - SCSI OSD fix
 - Various Reviewed-by: tags

Changes since V2;
 - reorder one patch to be earlier in the series
 - fix the argument to a bsg dprintk
 - fix a kerneldoc comment

Changes since V1:
 - rebased on top the latest block for-next tree
 - fix error handling in nfsd blocklayout
 - dropped "scsi: fix fast-fail for non-passthrough requests"

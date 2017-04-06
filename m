From: Christoph Hellwig <hch@lst.de>
Subject: kill req->errors
Date: Thu,  6 Apr 2017 17:39:19 +0200
Message-ID: <20170406153944.10058-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40091 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754350AbdDFPj5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 11:39:57 -0400
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

Note that this series expects that the patch to remove the mg_disk
driver has been applied already on top of the block for-next tree.

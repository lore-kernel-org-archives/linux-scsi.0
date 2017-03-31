From: Christoph Hellwig <hch@lst.de>
Subject: always use REQ_OP_WRITE_ZEROES for zeroing offload
Date: Fri, 31 Mar 2017 18:32:48 +0200
Message-ID: <20170331163313.31821-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56267 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933106AbdCaQdX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2017 12:33:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org

This series makes REQ_OP_WRITE_ZEROES the only zeroing offload
supported by the block layer, and switches existing implementations
of REQ_OP_DISCARD that correctly set discard_zeroes_data to it,
removes incorrect discard_zeroes_data, and also switches WRITE SAME
based zeroing in SCSI to this new method.

The series is against the block for-next tree.

A git tree is also avaiable at:

    git://git.infradead.org/users/hch/block.git discard-rework

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/discard-rework

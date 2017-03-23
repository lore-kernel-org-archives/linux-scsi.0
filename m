From: Christoph Hellwig <hch@lst.de>
Subject: RFC: always use REQ_OP_WRITE_ZEROES for zeroing offload
Date: Thu, 23 Mar 2017 10:33:18 -0400
Message-ID: <20170323143341.31549-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35732 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754916AbdCWOed (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2017 10:34:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org

This series makes REQ_OP_WRITE_ZEROES the only zeroing offload
supported by the block layer, and switches existing implementations
of REQ_OP_DISCARD that correctly set discard_zeroes_data to it,
removes incorrect discard_zeroes_data, and also switches WRITE SAME
based zeroing in SCSI to this new method.

I've done testing with ATA, SCSI and NVMe setups, but there are
a few things that will need more attention:

 - what is dm-kcopyd doing with the current WRITE SAME usage
   that gets multiple biovecs?  Can we fix it up in any way.
 - what are we going to do with discards through parity raid?
   I suspect we should either just disable it for now entirely
   or modify raid5.c to issue REQ_OP_WRITE_ZEROES to the underlying
   devices.  But I need someone with such a setup to test it.
 - The DRBD code in this area was very odd, and will need an
   audit from the maintainers.

Note that this series needs to be applied on top of the
"support ranges TRIM for libata" series.

A git tree is also avaiable at:

    git://git.infradead.org/users/hch/block.git discard-rework

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/discard-rework

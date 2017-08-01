From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/2] Zoned block device support fixes
Date: Tue,  1 Aug 2017 18:39:15 +0900
Message-ID: <20170801093917.4131-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:18058 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdHAJke (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2017 05:40:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@wdc.com>, Christoph Hellwig <hch@lst.de>

This small series addresses a couple of problems detected with 4.13-rc.

The first patch ensures that a well behaved host managed zoned block device
user (an application doing direct disk accesses, f2fs or dm-zoned) will not
see unaligned write errors due to reordering of write commands at dispatch
time.

The second patch addresses a request dispatch deadlock that can very easily
trigger with f2fs or dm-zoned when scsi-mq is enabled. The root cause of this
problem is the high probability of unintended reordering of sequential writes
in the dispatch queue due to concurrent requeue and insert events. This
patch only fixes the deadlock problem and is not a fix for the root cause
itself, which will require most likely a different approach as no easy fix
seem to be possible at the scsi-mq level.

This means that host managed zoned block devices cannot be reliably used under
a regular asynchronous (queued) write BIO issuing pattern with scsi-mq enabled
for now.

Damien Le Moal (1):
  sd_zbc: Disable zone locking with scsi-mq enabled

Hannes Reinecke (1):
  block: Zoned block device single-threaded submission

 block/blk-core.c      | 7 +++++++
 drivers/scsi/sd_zbc.c | 7 ++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

-- 
2.13.3

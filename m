From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/2 V2] Zoned block device support fixes
Date: Fri,  4 Aug 2017 16:52:35 +0900
Message-ID: <20170804075237.2089-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:32169 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751283AbdHDHyb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 03:54:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@wdc.com>, Christoph Hellwig <hch@lst.de>

This small series addresses a couple of problems with zoned block devices
detected with 4.13-rc.

The first patch ensures that a well behaved host managed zoned block device
user (an application doing direct disk accesses, f2fs or dm-zoned) will not
see unaligned write errors due to reordering of write commands at dispatch
time.

The second patch addresses a request dispatch deadlock that can very easily
trigger with f2fs or dm-zoned when scsi-mq is enabled. The root cause of this
problem is the high probability of unintended reordering of sequential writes
in the dispatch queue due to concurrent requeue and insert events. This
patch only fixes the deadlock problem and is not a fix for the reordering
problem.

This means that host managed zoned block devices cannot be reliably used under
a regular asynchronous (queued) write BIO issuing pattern to a zone with
scsi-mq enabled for now.

The second patch requires the patch 2f2d7c92dda
"scsi-mq: Always unprepare before requeuing a request" sent by Bart.

Damien Le Moal (1):
  sd_zbc: Write unlock zone from sd_uninit_cmnd()

Hannes Reinecke (1):
  block: Zoned block device single-threaded submission

 block/blk-core.c         | 7 +++++++
 drivers/scsi/sd.c        | 3 +++
 drivers/scsi/sd_zbc.c    | 9 +++++----
 include/scsi/scsi_cmnd.h | 1 +
 4 files changed, 16 insertions(+), 4 deletions(-)

-- 
2.13.3

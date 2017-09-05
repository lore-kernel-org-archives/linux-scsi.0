From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V3 0/2] sd fixes and cleanup
Date: Tue,  5 Sep 2017 20:55:34 +0900
Message-ID: <20170905115536.2896-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:29258 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750741AbdIEL4f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2017 07:56:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>

A couple of patches in this small series.

The first patch addresses a problem with large write same (or zeroout) block
layer calls being split into commands that are not aligned on the device
physical block size. This will work on regular disks but is not optimal.
The commands will however fail with host-managed zoned block device if the
commands target sequential write required zones. The patch simply makes sure
that the maximum write same sectors is aligned to physical block sizes.
Note that this fix can be implemented either in sd_config_write_same() or in
the block layer (__blkdev_issue_write_same() and __blkdev_issue_write_zeroes()).

The second patch does not introduce functional changes.

Changes from V2:
* Use round_down() in first patch to align maximum write same sectors to
  physical sector size.

Changes from V1:
* Removed useless addition of blank line an indentaion change in first patch.

*** BLURB HERE ***

Damien Le Moal (2):
  scsi: sd: Fix sd_config_write_same()
  scsi: sd: Use sectors_to_logical()

 drivers/scsi/sd.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

-- 
2.13.5

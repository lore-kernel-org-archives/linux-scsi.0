From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V2 0/2] sd fixes and cleanup
Date: Fri,  1 Sep 2017 10:07:27 +0900
Message-ID: <20170901010729.16524-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:47814 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdIABJC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2017 21:09:02 -0400
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
This solution can be implemented here in sd_config_write_same() or in the block
layer (__blkdev_issue_write_same() and __blkdev_issue_write_zeroes()). Please
let me know if you prefer a block layer solution.

The second patch does not introduce functional changes.

As always, comments are welcome !

changes from V1:
* Removed useless addition of blank line an indentaion change in first patch.

Damien Le Moal (2):
  scsi: sd: Fix sd_config_write_same()
  scsi: sd: Use sectors_to_logical()

 drivers/scsi/sd.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

-- 
2.13.5

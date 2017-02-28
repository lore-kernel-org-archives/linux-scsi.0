From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/2] Improve ZBC integration
Date: Tue, 28 Feb 2017 19:26:29 +0900
Message-ID: <20170228102631.16101-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:27880 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751677AbdB1Kbb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 05:31:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>

2 patches in this series.

The first one from myself, cleans up and simplify sd_done() by moving all
ZBC specific processing to sd_zbc_complete().
sd_zbc_complete() as well as sd_zbc_report_zones_complete() are improved to
be more resilient against eventual weird values of good_bytes and resid
returned for the report zone command. These changes alone do not however fix
the mpt3sas problem which incorrectly align resid to the device logical block
size for the report zones command. The fix for this is in the series sent to
Jens ("mpt3sas: Do not check resid for non medium access commands").

The second patch, from Bart, cleans up unused variable assignments in
sd_zbc_read_zones().

Bart Van Assche (1):
  sd_zbc: Remove superfluous assignments

Damien Le Moal (1):
  sd: Rework ZBC integration

 drivers/scsi/sd.c     |  36 ++++++-----------
 drivers/scsi/sd.h     |  11 +++---
 drivers/scsi/sd_zbc.c | 105 ++++++++++++++++++++++++++++++++------------------
 3 files changed, 85 insertions(+), 67 deletions(-)

-- 
2.9.3

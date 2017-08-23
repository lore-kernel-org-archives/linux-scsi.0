From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 17/19] scsi_transport_srp: Suppress a W=1 compiler warning
Date: Wed, 23 Aug 2017 14:40:07 -0700
Message-ID: <20170823214009.15015-18-bart.vanassche@wdc.com>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:60815 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdHWVnk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 17:43:40 -0400
In-Reply-To: <20170823214009.15015-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>

Avoid that the following compiler warning is reported when building
with W=1:

drivers/scsi/scsi_transport_srp.c:92:19: warning: comparison is always false due to limited range of data type [-Wtype-limits]

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_transport_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 698cc4681706..b8f5e4c47579 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -89,7 +89,7 @@ int srp_tmo_valid(int reconnect_delay, int fast_io_fail_tmo, int dev_loss_tmo)
 	if (fast_io_fail_tmo < 0 &&
 	    dev_loss_tmo > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
 		return -EINVAL;
-	if (dev_loss_tmo >= LONG_MAX / HZ)
+	if (dev_loss_tmo + 0UL >= LONG_MAX / HZ)
 		return -EINVAL;
 	if (fast_io_fail_tmo >= 0 && dev_loss_tmo >= 0 &&
 	    fast_io_fail_tmo >= dev_loss_tmo)
-- 
2.14.0

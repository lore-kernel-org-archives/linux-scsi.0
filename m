From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 12/19] sg: Fix type of last blk_trace_setup() argument
Date: Wed, 23 Aug 2017 14:40:02 -0700
Message-ID: <20170823214009.15015-13-bart.vanassche@wdc.com>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:57495 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751140AbdHWVnD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 17:43:03 -0400
In-Reply-To: <20170823214009.15015-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

Avoid that sparse reports the following:

drivers/scsi/sg.c:1114:41: warning: incorrect type in argument 5 (different address spaces)
drivers/scsi/sg.c:1114:41:    expected char [noderef] <asn:1>*arg
drivers/scsi/sg.c:1114:41:    got char *<noident>

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/sg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index f5705a95319f..03194c4b6744 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1110,8 +1110,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		return blk_trace_setup(sdp->device->request_queue,
 				       sdp->disk->disk_name,
 				       MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
-				       NULL,
-				       (char *)arg);
+				       NULL, p);
 	case BLKTRACESTART:
 		return blk_trace_startstop(sdp->device->request_queue, 1);
 	case BLKTRACESTOP:
-- 
2.14.0

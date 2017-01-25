From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] sd: always scan VPD pages if thin provisioning is enabled
Date: Wed, 25 Jan 2017 08:26:05 +0100
Message-ID: <1485329165-64825-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37734 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751287AbdAYH0b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Jan 2017 02:26:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

For any device with an older SCSI revision we might not
be scanning VPD pages, which results in a wrongly configured
discard mode if thin provisioned is enabled.
According to sbc3 any thin provisioned device (ie devices which
have the LBPME bit set in the output of READ CAPACITY(16)) need
to support VPD pages. So this patch always enables VPD pages
even for older SCSI revisions if thin provisioning is enabled.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/sd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1fbb1ec..08963b0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2169,7 +2169,15 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		if (buffer[14] & 0x40) /* LBPRZ */
 			sdkp->lbprz = 1;
 
-		sd_config_discard(sdkp, SD_LBP_WS16);
+		/*
+		 * sbc3r36 states:
+		 * The device server in a logical unit the supports
+		 * logical block provisioning management shall support
+		 * the Logical Block Provisioning VPD page.
+		 * So VPD pages should be supported if lbpme is set.
+		 */
+		if (!scsi_device_supports_vpd(sdp))
+			sdp->try_vpd_pages = 1;
 	}
 
 	sdkp->capacity = lba + 1;
-- 
1.8.5.6


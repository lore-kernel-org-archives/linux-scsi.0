From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: vpd pages are mandatory for SPC-2
Date: Fri, 11 Mar 2016 14:46:05 +0100
Message-ID: <1457703965-71028-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbcCKNqI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2016 08:46:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

VPD pages 0x0 and 0x83 are mandatory even for SPC-2, so we should
be lowering the restriction to avoid having to whitelist every
SPC-2 compliant device.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 include/scsi/scsi_device.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 06a2f83..2536ade 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -538,9 +538,9 @@ static inline int scsi_device_supports_vpd(struct scsi_device *sdev)
 	/*
 	 * Although VPD inquiries can go to SCSI-2 type devices,
 	 * some USB ones crash on receiving them, and the pages
-	 * we currently ask for are for SPC-3 and beyond
+	 * we currently ask for are mandatory for SPC-2 and beyond
 	 */
-	if (sdev->scsi_level > SCSI_SPC_2 && !sdev->skip_vpd_pages)
+	if (sdev->scsi_level >= SCSI_SPC_2 && !sdev->skip_vpd_pages)
 		return 1;
 	return 0;
 }
-- 
1.8.5.6


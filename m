From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_lib: Decode T-10 vendor IDs
Date: Fri,  6 May 2016 10:35:07 +0200
Message-ID: <1462523707-63224-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbcEFIf0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2016 04:35:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Some arrays / HBAs will only present T-10 vendor IDs, so we
should be decoding them, too.

Suggested-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b920c5d..a6158f8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3064,6 +3064,7 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 	 * - EUI-64 based 12-byte
 	 * - NAA IEEE Registered
 	 * - NAA IEEE Extended
+	 * - T10 Vendor ID
 	 * as longer descriptors reduce the likelyhood
 	 * of identification clashes.
 	 */
@@ -3082,6 +3083,21 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 			goto next_desig;
 
 		switch (d[1] & 0xf) {
+		case 0x1:
+			/* T-10 Vendor ID */
+			if (cur_id_size > d[3])
+				break;
+			/* Prefer anything */
+			if (cur_id_type > 0x01)
+				break;
+			cur_id_size = d[3];
+			if (cur_id_size + 4 > id_len)
+				cur_id_size = id_len - 4;
+			cur_id_str = d + 4;
+			cur_id_type = d[1] & 0xf;
+			id_size = snprintf(id, id_len, "t10.%*pE",
+					   cur_id_size, cur_id_str);
+			break;
 		case 0x2:
 			/* EUI-64 */
 			if (cur_id_size > d[3])
-- 
1.8.5.6


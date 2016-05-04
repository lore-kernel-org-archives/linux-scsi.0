From: Paul Mackerras <paulus@ozlabs.org>
Subject: [PATCH] scsi: Make scsi_vpd_lun_id() able to use T10 vendor ID based
 designators
Date: Wed, 4 May 2016 16:58:30 +1000
Message-ID: <20160504065830.GB19436@oak.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:38700 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757124AbcEDJVK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 May 2016 05:21:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

This adds code to scsi_vpd_lun_id() to enable it to use T10 vendor ID
based designators.  This is needed to allow alua to work on disks that
don't have any designators of type 2, 3 or 8.  Commit 0047220c6c36
("scsi_dh_alua: use unique device id", 2016-02-19) added a requirement
that alua can only be used on disks for which scsi_vpd_lun_id() can
produce an identifying string.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 drivers/scsi/scsi_lib.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8106515..f4f69cc 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3214,6 +3214,20 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 			goto next_desig;
 
 		switch (d[1] & 0xf) {
+		case 0x1:
+			/* T10 vendor ID */
+			if (cur_id_size > d[3])
+				break;
+			/* Prefer EUI-64 or NAA IEEE Registered Extended */
+			if ((cur_id_type == 0x2 || cur_id_type == 0x3) &&
+			    cur_id_size == d[3])
+				break;
+			cur_id_size = d[3];
+			cur_id_str = d + 4;
+			cur_id_type = d[1] & 0xf;
+			id_size = snprintf(id, id_len, "%*phN", cur_id_size,
+					   cur_id_str);
+			break;
 		case 0x2:
 			/* EUI-64 */
 			if (cur_id_size > d[3])

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] osd: remove deadcode
Date: Wed, 24 Feb 2016 15:58:00 +0530
Message-ID: <1456309680-17847-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:35897 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbcBXK2K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2016 05:28:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <ooo@electrozaur.com>, Benny Halevy <bhalevy@primarydata.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>

The variable is_ver1 is always true and so OSD_CAP_LEN can never be
used.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 drivers/scsi/osd/osd_initiator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index d8a2b51..3b11aad 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -2006,9 +2006,8 @@ EXPORT_SYMBOL(osd_sec_init_nosec_doall_caps);
  */
 void osd_set_caps(struct osd_cdb *cdb, const void *caps)
 {
-	bool is_ver1 = true;
 	/* NOTE: They start at same address */
-	memcpy(&cdb->v1.caps, caps, is_ver1 ? OSDv1_CAP_LEN : OSD_CAP_LEN);
+	memcpy(&cdb->v1.caps, caps, OSDv1_CAP_LEN);
 }
 
 bool osd_is_sec_alldata(struct osd_security_parameters *sec_parms __unused)
-- 
1.9.1


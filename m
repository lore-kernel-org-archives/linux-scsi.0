From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] hpsa: fallback to use legacy REPORT PHYS command
Date: Fri,  2 Dec 2016 11:32:59 +0100
Message-ID: <1480674779-118014-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45230 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753678AbcLBKdC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 05:33:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Older SmartArray controllers (eg SmartArray 64xx) do
not support the extended REPORT PHYS command, so
fallback to use the legacy version here.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 216c137..0aed9d6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3438,7 +3438,7 @@ static u64 hpsa_get_sas_address_from_report_physical(struct ctlr_info *h,
 		kfree(physdev);
 		return 0;
 	}
-	nphysicals = get_unaligned_be32(physdev->LUNListLength) / 24;
+	nphysicals = get_unaligned_be32(physdev->LUNListLength) / 8;
 
 	for (i = 0; i < nphysicals; i++)
 		if (!memcmp(&physdev->LUN[i].lunid[0], scsi3addr, 8)) {
@@ -3640,8 +3640,32 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 static inline int hpsa_scsi_do_report_phys_luns(struct ctlr_info *h,
 		struct ReportExtendedLUNdata *buf, int bufsize)
 {
-	return hpsa_scsi_do_report_luns(h, 0, buf, bufsize,
-						HPSA_REPORT_PHYS_EXTENDED);
+	int rc;
+	struct ReportLUNdata *lbuf;
+
+	rc = hpsa_scsi_do_report_luns(h, 0, buf, bufsize,
+				      HPSA_REPORT_PHYS_EXTENDED);
+	if (!rc || !hpsa_allow_any)
+		return rc;
+
+	/* REPORT PHYS EXTENDED is not supported */
+	lbuf = kzalloc(sizeof(*lbuf), GFP_KERNEL);
+	if (!lbuf)
+		return -ENOMEM;
+
+	rc = hpsa_scsi_do_report_luns(h, 0, lbuf, sizeof(*lbuf), 0);
+	if (!rc) {
+		int i;
+		u32 nphys;
+
+		/* Copy ReportLUNdata header */
+		memcpy(buf, lbuf, 8);
+		nphys = be32_to_cpu(*((__be32 *)lbuf->LUNListLength)) / 24;
+		for (i = 0; i < nphys; i++)
+			memcpy(buf->LUN[i].lunid, lbuf->LUN[i], 8);
+	}
+	kfree(lbuf);
+	return rc;
 }
 
 static inline int hpsa_scsi_do_report_log_luns(struct ctlr_info *h,
-- 
1.8.5.6


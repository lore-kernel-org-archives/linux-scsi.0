From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3] hpsa: fallback to use legacy REPORT PHYS command
Date: Fri,  2 Dec 2016 11:36:13 +0100
Message-ID: <1480674973-118250-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45512 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759021AbcLBKgQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 05:36:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Older SmartArray controllers (eg SmartArray 64xx) do
not support the extended REPORT PHYS command, so
fallback to use the legacy version here.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 216c137..3783ef6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
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
+		nphys = be32_to_cpu(*((__be32 *)lbuf->LUNListLength)) / 8;
+		for (i = 0; i < nphys; i++)
+			memcpy(buf->LUN[i].lunid, lbuf->LUN[i], 8);
+	}
+	kfree(lbuf);
+	return rc;
 }
 
 static inline int hpsa_scsi_do_report_log_luns(struct ctlr_info *h,
-- 
1.8.5.6


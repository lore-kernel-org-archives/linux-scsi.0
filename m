From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 4/6] hpsa: do not print errors for unsupported report luns format
Date: Mon, 14 Aug 2017 13:19:13 +0200
Message-ID: <1502709555-15837-5-git-send-email-hare@suse.de>
References: <1502709555-15837-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54223 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752820AbdHNLTV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Aug 2017 07:19:21 -0400
In-Reply-To: <1502709555-15837-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Legacy boards might not support the 'extended' report luns format,
but as this is to be expected we don't need to print out an error here.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Acked-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b34ec42..c90a83d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3601,7 +3601,7 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 	memset(scsi3addr, 0, sizeof(scsi3addr));
 	if (fill_cmd(c, logical ? HPSA_REPORT_LOG : HPSA_REPORT_PHYS, h,
 		buf, bufsize, 0, scsi3addr, TYPE_CMD)) {
-		rc = -1;
+		rc = -EAGAIN;
 		goto out;
 	}
 	if (extended_response)
@@ -3614,16 +3614,17 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 	if (ei->CommandStatus != 0 &&
 	    ei->CommandStatus != CMD_DATA_UNDERRUN) {
 		hpsa_scsi_interpret_error(h, c);
-		rc = -1;
+		rc = -EIO;
 	} else {
 		struct ReportLUNdata *rld = buf;
 
 		if (rld->extended_response_flag != extended_response) {
-			dev_err(&h->pdev->dev,
-				"report luns requested format %u, got %u\n",
-				extended_response,
-				rld->extended_response_flag);
-			rc = -1;
+			if (!h->legacy_board)
+				dev_err(&h->pdev->dev,
+					"report luns requested format %u, got %u\n",
+					extended_response,
+					rld->extended_response_flag);
+			rc = -EOPNOTSUPP;
 		}
 	}
 out:
@@ -3639,7 +3640,10 @@ static inline int hpsa_scsi_do_report_phys_luns(struct ctlr_info *h,
 
 	rc = hpsa_scsi_do_report_luns(h, 0, buf, bufsize,
 				      HPSA_REPORT_PHYS_EXTENDED);
-	if (!rc || !hpsa_allow_any)
+	if (rc == -EOPNOTSUPP) {
+		if (!h->legacy_board)
+			return rc;
+	} else if (rc < 0)
 		return rc;
 
 	/* REPORT PHYS EXTENDED is not supported */
@@ -6617,7 +6621,6 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 		default:
 			dev_warn(&h->pdev->dev, "unknown command 0x%c\n", cmd);
 			BUG();
-			return -1;
 		}
 	} else if (cmd_type == TYPE_MSG) {
 		switch (cmd) {
-- 
1.8.5.6

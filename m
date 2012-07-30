From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 2/2] [SCSI] ipr: remove an unneeded check
Date: Mon, 30 Jul 2012 11:18:22 +0300
Message-ID: <20120730081822.GF15702@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

"rc" is always zero here, so there is no need to check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 7a5ccb2c..fc49f17 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5847,7 +5847,7 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 	struct ipr_ioarcb *ioarcb;
 	struct ipr_cmnd *ipr_cmd;
 	unsigned long lock_flags;
-	int rc = 0;
+	int rc;
 
 	ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
 
@@ -5905,12 +5905,10 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 	    (!ipr_is_gscsi(res) || scsi_cmd->cmnd[0] == IPR_QUERY_RSRC_STATE))
 		ioarcb->cmd_pkt.request_type = IPR_RQTYPE_IOACMD;
 
-	if (likely(rc == 0)) {
-		if (ioa_cfg->sis64)
-			rc = ipr_build_ioadl64(ioa_cfg, ipr_cmd);
-		else
-			rc = ipr_build_ioadl(ioa_cfg, ipr_cmd);
-	}
+	if (ioa_cfg->sis64)
+		rc = ipr_build_ioadl64(ioa_cfg, ipr_cmd);
+	else
+		rc = ipr_build_ioadl(ioa_cfg, ipr_cmd);
 
 	spin_lock_irqsave(shost->host_lock, lock_flags);
 	if (unlikely(rc || (!ioa_cfg->allow_cmds && !ioa_cfg->ioa_is_dead))) {

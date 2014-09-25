From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 14/17] qla2xxx: Do not send SS_RESIDUAL_UNDER with SAM_STAT_BUSY
Date: Thu, 25 Sep 2014 06:14:56 -0400
Message-ID: <1411640099-7856-15-git-send-email-saurav.kashyap@qlogic.com>
References: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com
List-Id: linux-scsi@vger.kernel.org

From: Himanshu Madhani <himanshu.madhani@qlogic.com>

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 9f248e7..94b726e 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4313,12 +4313,6 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 	 */
 	ctio24->u.status1.ox_id = swab16(atio->u.isp24.fcp_hdr.ox_id);
 	ctio24->u.status1.scsi_status = cpu_to_le16(status);
-	ctio24->u.status1.residual = get_unaligned((uint32_t *)
-	    &atio->u.isp24.fcp_cmnd.add_cdb[
-	    atio->u.isp24.fcp_cmnd.add_cdb_len]);
-	if (ctio24->u.status1.residual != 0)
-		ctio24->u.status1.scsi_status |= SS_RESIDUAL_UNDER;
-
 	qla2x00_start_iocbs(vha, vha->req);
 	return 0;
 }
-- 
1.7.7

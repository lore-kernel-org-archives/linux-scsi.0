From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 15/31] qla2xxx: Use sp->free instead of hard coded call.
Date: Wed, 23 Aug 2017 15:05:09 -0700
Message-ID: <20170823220525.3115-16-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0054.outbound.protection.outlook.com ([104.47.41.54]:10176
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751093AbdHWWFv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:05:51 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Calling sp->free() ensures the context-correct free routine is called.

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b6b070db5891..5b033e265a3b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -742,7 +742,7 @@ qla2x00_sp_compl(void *ptr, int res)
 	if (!atomic_dec_and_test(&sp->ref_count))
 		return;
 
-	qla2x00_sp_free_dma(sp);
+	sp->free(sp);
 	cmd->scsi_done(cmd);
 }
 
@@ -814,7 +814,7 @@ qla2xxx_qpair_sp_compl(void *ptr, int res)
 	if (!atomic_dec_and_test(&sp->ref_count))
 		return;
 
-	qla2xxx_qpair_sp_free_dma(sp);
+	sp->free(sp);
 	cmd->scsi_done(cmd);
 }
 
@@ -935,7 +935,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	return 0;
 
 qc24_host_busy_free_sp:
-	qla2x00_sp_free_dma(sp);
+	sp->free(sp);
 
 qc24_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
@@ -1024,7 +1024,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 	return 0;
 
 qc24_host_busy_free_sp:
-	qla2xxx_qpair_sp_free_dma(sp);
+	sp->free(sp);
 
 qc24_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
-- 
2.12.0

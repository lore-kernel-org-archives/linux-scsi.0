From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] qla2xxx: correctly shift host byte
Date: Fri,  6 Apr 2018 09:52:22 +0200
Message-ID: <20180406075222.7358-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Himanshu Madhani <himanshu.madhani@cavium.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

The host byte has to be shifted by 16 not 6.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/qla2xxx/qla_isr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 89f93ebd819d..49d67e1d571f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2368,7 +2368,7 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	/* Always return DID_OK, bsg will send the vendor specific response
 	 * in this case only */
-	sp->done(sp, DID_OK << 6);
+	sp->done(sp, DID_OK << 16);
 
 }
 
-- 
2.16.2

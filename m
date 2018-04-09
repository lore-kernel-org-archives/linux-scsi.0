From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2] qla2xxx: correctly shift host byte
Date: Mon,  9 Apr 2018 14:24:23 +0200
Message-ID: <20180409122423.32231-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

The SCSI host byte has to be shifted by 16 not 6.

As Bart pointed out this patch does not change any functionality
because DID_OK == 0, but a wrong shift is irritating for the reviewer.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
---
Changes to v1:
* Add Bart's review remark, that I'm not changing actual functionality
  as DID_OK == 0

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

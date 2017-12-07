From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] scsi_debug: Add support for injecting SCSI_MLQUEUE_HOST_BUSY
Date: Thu,  7 Dec 2017 14:56:18 -0800
Message-ID: <20171207225618.3116-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:21328 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750919AbdLGW4T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2017 17:56:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

Although it is important to be able to trigger the code in the SCSI
core for SCSI_MLQUEUE_HOST_BUSY handling, currently it is
nontrivial to trigger that code. Hence this patch that adds a new
error injection option to the scsi_debug driver for making the
.queue_rq() implementation of this driver return
SCSI_MLQUEUE_HOST_BUSY.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_debug.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9833850a53df..4b87e94e6611 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -161,12 +161,14 @@ static const char *sdebug_version_date = "20160430";
 #define SDEBUG_OPT_N_WCE		0x1000
 #define SDEBUG_OPT_RESET_NOISE		0x2000
 #define SDEBUG_OPT_NO_CDB_NOISE		0x4000
+#define SDEBUG_OPT_HOST_BUSY		0x8000
 #define SDEBUG_OPT_ALL_NOISE (SDEBUG_OPT_NOISE | SDEBUG_OPT_Q_NOISE | \
 			      SDEBUG_OPT_RESET_NOISE)
 #define SDEBUG_OPT_ALL_INJECTING (SDEBUG_OPT_RECOVERED_ERR | \
 				  SDEBUG_OPT_TRANSPORT_ERR | \
 				  SDEBUG_OPT_DIF_ERR | SDEBUG_OPT_DIX_ERR | \
-				  SDEBUG_OPT_SHORT_TRANSFER)
+				  SDEBUG_OPT_SHORT_TRANSFER | \
+				  SDEBUG_OPT_HOST_BUSY)
 /* When "every_nth" > 0 then modulo "every_nth" commands:
  *   - a missing response is simulated if SDEBUG_OPT_TIMEOUT is set
  *   - a RECOVERED_ERROR is simulated on successful read and write
@@ -282,6 +284,7 @@ struct sdebug_queued_cmd {
 	unsigned int inj_dif:1;
 	unsigned int inj_dix:1;
 	unsigned int inj_short:1;
+	unsigned int inj_host_busy:1;
 };
 
 struct sdebug_queue {
@@ -3995,6 +3998,7 @@ static void setup_inject(struct sdebug_queue *sqp,
 	sqcp->inj_dif = !!(SDEBUG_OPT_DIF_ERR & sdebug_opts);
 	sqcp->inj_dix = !!(SDEBUG_OPT_DIX_ERR & sdebug_opts);
 	sqcp->inj_short = !!(SDEBUG_OPT_SHORT_TRANSFER & sdebug_opts);
+	sqcp->inj_host_busy = !!(SDEBUG_OPT_HOST_BUSY & sdebug_opts);
 }
 
 /* Complete the processing of the thread that queued a SCSI command to this
@@ -5278,6 +5282,12 @@ static bool fake_timeout(struct scsi_cmnd *scp)
 	return false;
 }
 
+static bool fake_host_busy(struct scsi_cmnd *scp)
+{
+	return (sdebug_opts & SDEBUG_OPT_HOST_BUSY) &&
+		(atomic_read(&sdebug_cmnd_count) % abs(sdebug_every_nth)) == 0;
+}
+
 static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 				   struct scsi_cmnd *scp)
 {
@@ -5320,6 +5330,8 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 			sdev_printk(KERN_INFO, sdp, "%s: cmd %s\n", my_name,
 				    b);
 	}
+	if (fake_host_busy(scp))
+		return SCSI_MLQUEUE_HOST_BUSY;
 	has_wlun_rl = (sdp->lun == SCSI_W_LUN_REPORT_LUNS);
 	if (unlikely((sdp->lun >= sdebug_max_luns) && !has_wlun_rl))
 		goto err_out;
-- 
2.15.0
